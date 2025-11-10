
-- Migration: Preserve approvals when regenerating identical AI summaries
DROP FUNCTION IF EXISTS create_ai_summary(UUID, JSONB, UUID);

CREATE FUNCTION create_ai_summary(
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

    -- Insert or update the summary while preserving approval status when unchanged
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
        summary_type = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.summary_type
            ELSE 'ai_generated'
        END,
        approval_status = CASE
            WHEN assessment_summaries.approval_status = 'approved'
                 AND assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN 'approved'
            ELSE 'pending_approval'
        END,
        version = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.version
            ELSE assessment_summaries.version + 1
        END,
        generated_at = NOW(),
        updated_at = NOW(),
        approved_by = CASE
            WHEN assessment_summaries.approval_status = 'approved'
                 AND assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.approved_by
            ELSE NULL
        END,
        approved_at = CASE
            WHEN assessment_summaries.approval_status = 'approved'
                 AND assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.approved_at
            ELSE NULL
        END,
        rejected_by = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.rejected_by
            ELSE NULL
        END,
        rejected_at = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.rejected_at
            ELSE NULL
        END,
        rejection_reason = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.rejection_reason
            ELSE NULL
        END,
        teacher_edited_summary = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.teacher_edited_summary
            ELSE NULL
        END,
        student_edited_summary = CASE
            WHEN assessment_summaries.ai_summary IS NOT DISTINCT FROM EXCLUDED.ai_summary
            THEN assessment_summaries.student_edited_summary
            ELSE NULL
        END,
        student_user_id = EXCLUDED.student_user_id
    RETURNING id INTO v_summary_id;

    RETURN v_summary_id;
END;
$$;

GRANT EXECUTE ON FUNCTION create_ai_summary(UUID, JSONB, UUID) TO authenticated;
