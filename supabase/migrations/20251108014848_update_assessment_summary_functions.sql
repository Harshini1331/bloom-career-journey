-- Migration: Update assessment summary RPCs to include student_user_id
-- Updates create_ai_summary, get_summary_by_assessment, and get_pending_summaries_for_teacher

-- Drop existing functions so we can change return signatures safely
DROP FUNCTION IF EXISTS create_ai_summary(UUID, JSONB, UUID);
DROP FUNCTION IF EXISTS get_summary_by_assessment(UUID, UUID);
DROP FUNCTION IF EXISTS get_pending_summaries_for_teacher(UUID);

-- Function: Create or update AI-generated summary (adds student_user_id handling)
CREATE OR REPLACE FUNCTION create_ai_summary(
    p_assessment_response_id UUID,
    p_ai_summary JSONB,
    p_student_user_id UUID
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_summary_id UUID;
    v_is_student_owner BOOLEAN;
BEGIN
    -- Verify the student owns this assessment response
    SELECT EXISTS (
        SELECT 1
        FROM assessment_responses ar
        JOIN students s ON s.id = ar.student_id
        WHERE ar.id = p_assessment_response_id
          AND s.user_id = p_student_user_id
    ) INTO v_is_student_owner;

    IF NOT v_is_student_owner THEN
        RAISE EXCEPTION 'not_authorized';
    END IF;

    -- Insert or update the summary
    INSERT INTO assessment_summaries (
        assessment_response_id,
        ai_summary,
        summary_type,
        approval_status,
        version,
        generated_at,
        student_user_id
    ) VALUES (
        p_assessment_response_id,
        p_ai_summary,
        'ai_generated',
        'pending_approval',
        1,
        NOW(),
        p_student_user_id
    )
    ON CONFLICT (assessment_response_id) 
    DO UPDATE SET
        ai_summary = EXCLUDED.ai_summary,
        summary_type = 'ai_generated',
        approval_status = 'pending_approval',
        version = assessment_summaries.version + 1,
        generated_at = NOW(),
        updated_at = NOW(),
        -- Reset approval fields when regenerating
        approved_by = NULL,
        approved_at = NULL,
        rejected_by = NULL,
        rejected_at = NULL,
        rejection_reason = NULL,
        teacher_edited_summary = NULL,
        student_user_id = EXCLUDED.student_user_id
    RETURNING id INTO v_summary_id;

    RETURN v_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION create_ai_summary(UUID, JSONB, UUID) TO authenticated;

-- Function: Get summary by assessment response ID (returns student_user_id)
CREATE OR REPLACE FUNCTION get_summary_by_assessment(
    p_assessment_response_id UUID,
    p_user_id UUID
)
RETURNS TABLE (
    id UUID,
    assessment_response_id UUID,
    ai_summary JSONB,
    student_edited_summary JSONB,
    teacher_edited_summary JSONB,
    summary_type summary_type,
    approval_status summary_approval_status,
    version INTEGER,
    approved_by UUID,
    approved_at TIMESTAMPTZ,
    rejected_by UUID,
    rejected_at TIMESTAMPTZ,
    rejection_reason TEXT,
    generated_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    student_user_id UUID
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_is_authorized BOOLEAN;
BEGIN
    -- Check if user is authorized (student owner or teacher)
    SELECT EXISTS (
        SELECT 1
        FROM assessment_responses ar
        LEFT JOIN students s ON s.id = ar.student_id
        LEFT JOIN teachers t ON t.id = s.teacher_id
        WHERE ar.id = p_assessment_response_id
          AND (s.user_id = p_user_id OR t.user_id = p_user_id)
    ) INTO v_is_authorized;

    IF NOT v_is_authorized THEN
        RAISE EXCEPTION 'not_authorized';
    END IF;

    -- Return the most recent summary, preferring approved ones
    RETURN QUERY
    SELECT 
        assum.id,
        assum.assessment_response_id,
        assum.ai_summary,
        assum.student_edited_summary,
        assum.teacher_edited_summary,
        assum.summary_type,
        assum.approval_status,
        assum.version,
        assum.approved_by,
        assum.approved_at,
        assum.rejected_by,
        assum.rejected_at,
        assum.rejection_reason,
        assum.generated_at,
        assum.created_at,
        assum.updated_at,
        assum.student_user_id
    FROM assessment_summaries assum
    WHERE assum.assessment_response_id = p_assessment_response_id
    ORDER BY 
        CASE WHEN assum.approval_status = 'approved' THEN 0 ELSE 1 END,
        assum.updated_at DESC,
        assum.created_at DESC
    LIMIT 1;
END;
$$;

GRANT EXECUTE ON FUNCTION get_summary_by_assessment(UUID, UUID) TO authenticated;

-- Function: Get pending summaries for a teacher (exposes student_user_id)
CREATE OR REPLACE FUNCTION get_pending_summaries_for_teacher(
    p_teacher_user_id UUID
)
RETURNS TABLE (
    summary_id UUID,
    assessment_response_id UUID,
    student_name TEXT,
    student_class TEXT,
    assessment_title TEXT,
    ai_summary JSONB,
    teacher_edited_summary JSONB,
    approval_status summary_approval_status,
    generated_at TIMESTAMPTZ,
    rejection_reason TEXT,
    student_user_id UUID
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        assum.id AS summary_id,
        ar.id AS assessment_response_id,
        u.full_name AS student_name,
        c.name AS student_class,
        ar.assessment_title,
        assum.ai_summary,
        assum.teacher_edited_summary,
        assum.approval_status,
        assum.generated_at,
        assum.rejection_reason,
        assum.student_user_id
    FROM assessment_summaries assum
    JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
    JOIN students s ON s.id = ar.student_id
    JOIN users u ON u.id = s.user_id
    LEFT JOIN classes c ON c.id = s.class_id
    JOIN teachers t ON t.id = s.teacher_id
    WHERE t.user_id = p_teacher_user_id
      AND assum.approval_status IN ('pending_approval', 'rejected', 'revision_requested')
    ORDER BY assum.generated_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION get_pending_summaries_for_teacher(UUID) TO authenticated;
