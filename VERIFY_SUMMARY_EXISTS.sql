-- Verify the summary exists and check its status
-- Run this to see what summaries exist for this assessment

-- Check all summaries for this assessment response
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

-- Test the function directly (replace STUDENT_USER_ID with actual student user_id)
-- This will show what the function returns for the student
SELECT * FROM get_summary_by_assessment(
    '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'::UUID,
    'STUDENT_USER_ID_HERE'::UUID  -- Replace with actual student user_id
);

-- Check if the student can see the summary (RLS check)
-- Replace STUDENT_USER_ID with actual student user_id
SELECT 
    assum.id,
    assum.assessment_response_id,
    assum.approval_status,
    ar.id as response_id,
    s.user_id as student_user_id
FROM assessment_summaries assum
JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
JOIN students s ON s.id = ar.student_id
WHERE assum.assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'
  AND s.user_id = 'STUDENT_USER_ID_HERE';  -- Replace with actual student user_id

