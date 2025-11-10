-- Check if summaries exist for this assessment response
-- Run this as a teacher or admin to see all summaries

-- Check all summaries for this assessment response (bypasses RLS)
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by,
    updated_at,
    created_at
FROM assessment_summaries
WHERE assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'
ORDER BY updated_at DESC;

-- Check if the approved summary exists
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by
FROM assessment_summaries
WHERE id = '72d9571d-1f27-4b61-a01e-537f08183185';

-- Test the function as a student user (replace with actual student user_id)
-- SELECT * FROM get_summary_by_assessment(
--     '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'::UUID,
--     'STUDENT_USER_ID_HERE'::UUID
-- );

