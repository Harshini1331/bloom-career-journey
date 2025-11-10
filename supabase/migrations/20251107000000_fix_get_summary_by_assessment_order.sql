-- Migration: Fix get_summary_by_assessment to return the most recent/approved summary
-- This ensures that if there are multiple summaries (which shouldn't happen due to UNIQUE constraint),
-- we return the approved one first, or the most recently updated one

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
    updated_at TIMESTAMPTZ
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
        assum.updated_at
    FROM assessment_summaries assum
    WHERE assum.assessment_response_id = p_assessment_response_id
    ORDER BY 
        -- Prefer approved summaries first
        CASE WHEN assum.approval_status = 'approved' THEN 0 ELSE 1 END,
        -- Then by most recently updated
        assum.updated_at DESC,
        -- Finally by most recently created
        assum.created_at DESC
    LIMIT 1;
END;
$$;

GRANT EXECUTE ON FUNCTION get_summary_by_assessment(UUID, UUID) TO authenticated;

