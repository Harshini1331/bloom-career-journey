-- Fix approval workflow gaps (A1, A2, A5, D2, B1 prerequisites)

-- 1. Add notification types needed for revision workflow
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'revision_requested';
ALTER TYPE notification_type ADD VALUE IF NOT EXISTS 'summary_rejected';

-- 2. approve_summary: guard against re-approving already-approved summaries
--    Preserves student_user_id backfill from 20251112000000 migration.
CREATE OR REPLACE FUNCTION approve_summary(
    p_summary_id UUID,
    p_teacher_user_id UUID
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_is_teacher_authorized BOOLEAN;
    v_student_user_id UUID;
    v_current_status summary_approval_status;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM assessment_summaries assum
        JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
        JOIN students s ON s.id = ar.student_id
        JOIN teachers t ON t.id = s.teacher_id
        WHERE assum.id = p_summary_id
          AND t.user_id = p_teacher_user_id
    ), (
        SELECT s.user_id
        FROM assessment_summaries assum
        JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
        JOIN students s ON s.id = ar.student_id
        WHERE assum.id = p_summary_id
    ) INTO v_is_teacher_authorized, v_student_user_id;

    IF NOT v_is_teacher_authorized THEN
        RAISE EXCEPTION 'not_authorized';
    END IF;

    SELECT approval_status INTO v_current_status
    FROM assessment_summaries WHERE id = p_summary_id;

    IF v_current_status = 'approved' THEN
        RAISE EXCEPTION 'already_approved';
    END IF;

    UPDATE assessment_summaries
    SET
        approval_status = 'approved',
        approved_by = p_teacher_user_id,
        approved_at = NOW(),
        updated_at = NOW(),
        student_user_id = COALESCE(student_user_id, v_student_user_id),
        rejected_by = NULL,
        rejected_at = NULL,
        rejection_reason = NULL
    WHERE id = p_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION approve_summary(UUID, UUID) TO authenticated;

-- 3. reject_summary: guard against rejecting already-approved summaries
CREATE OR REPLACE FUNCTION reject_summary(
    p_summary_id UUID,
    p_teacher_user_id UUID,
    p_rejection_reason TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_is_teacher_authorized BOOLEAN;
    v_current_status summary_approval_status;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM assessment_summaries assum
        JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
        JOIN students s ON s.id = ar.student_id
        JOIN teachers t ON t.id = s.teacher_id
        WHERE assum.id = p_summary_id
          AND t.user_id = p_teacher_user_id
    ) INTO v_is_teacher_authorized;

    IF NOT v_is_teacher_authorized THEN
        RAISE EXCEPTION 'not_authorized';
    END IF;

    SELECT approval_status INTO v_current_status
    FROM assessment_summaries WHERE id = p_summary_id;

    IF v_current_status = 'approved' THEN
        RAISE EXCEPTION 'already_approved';
    END IF;

    UPDATE assessment_summaries
    SET
        approval_status = 'rejected',
        rejected_by = p_teacher_user_id,
        rejected_at = NOW(),
        rejection_reason = p_rejection_reason,
        updated_at = NOW(),
        approved_by = NULL,
        approved_at = NULL
    WHERE id = p_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION reject_summary(UUID, UUID, TEXT) TO authenticated;

-- 4. update_student_summary: allow edits when revision_requested; reset to pending_approval on save
CREATE OR REPLACE FUNCTION update_student_summary(
    p_summary_id UUID,
    p_student_user_id UUID,
    p_student_edited_summary JSONB
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_is_authorized BOOLEAN;
    v_current_status summary_approval_status;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM assessment_summaries assum
        JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
        JOIN students s ON s.id = ar.student_id
        WHERE assum.id = p_summary_id
          AND s.user_id = p_student_user_id
          AND assum.approval_status IN ('approved', 'revision_requested')
    ) INTO v_is_authorized;

    IF NOT v_is_authorized THEN
        RAISE EXCEPTION 'not_authorized_or_not_editable';
    END IF;

    SELECT approval_status INTO v_current_status
    FROM assessment_summaries WHERE id = p_summary_id;

    UPDATE assessment_summaries
    SET
        student_edited_summary = p_student_edited_summary,
        summary_type = 'student_edited',
        version = version + 1,
        updated_at = NOW(),
        -- Student resubmitting after revision_requested sends it back for re-review
        approval_status = CASE
            WHEN v_current_status = 'revision_requested' THEN 'pending_approval'::summary_approval_status
            ELSE approval_status
        END,
        rejection_reason = CASE
            WHEN v_current_status = 'revision_requested' THEN NULL
            ELSE rejection_reason
        END,
        rejected_by = CASE
            WHEN v_current_status = 'revision_requested' THEN NULL
            ELSE rejected_by
        END,
        rejected_at = CASE
            WHEN v_current_status = 'revision_requested' THEN NULL
            ELSE rejected_at
        END
    WHERE id = p_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION update_student_summary(UUID, UUID, JSONB) TO authenticated;

-- 5. New RPC: request_revision_summary — teacher asks student to revise their summary
CREATE OR REPLACE FUNCTION request_revision_summary(
    p_summary_id UUID,
    p_teacher_user_id UUID,
    p_revision_notes TEXT
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_is_teacher_authorized BOOLEAN;
    v_current_status summary_approval_status;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM assessment_summaries assum
        JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
        JOIN students s ON s.id = ar.student_id
        JOIN teachers t ON t.id = s.teacher_id
        WHERE assum.id = p_summary_id
          AND t.user_id = p_teacher_user_id
    ) INTO v_is_teacher_authorized;

    IF NOT v_is_teacher_authorized THEN
        RAISE EXCEPTION 'not_authorized';
    END IF;

    SELECT approval_status INTO v_current_status
    FROM assessment_summaries WHERE id = p_summary_id;

    IF v_current_status = 'approved' THEN
        RAISE EXCEPTION 'already_approved';
    END IF;

    UPDATE assessment_summaries
    SET
        approval_status = 'revision_requested',
        rejection_reason = p_revision_notes,
        rejected_by = p_teacher_user_id,
        rejected_at = NOW(),
        updated_at = NOW(),
        approved_by = NULL,
        approved_at = NULL
    WHERE id = p_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION request_revision_summary(UUID, UUID, TEXT) TO authenticated;
