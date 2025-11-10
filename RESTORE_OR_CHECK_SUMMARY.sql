-- First, check if the approved summary still exists
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

-- Check if the approved summary exists by ID
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by
FROM assessment_summaries
WHERE id = '72d9571d-1f27-4b61-a01e-537f08183185';

-- If the approved summary doesn't exist, we need to check what happened
-- The summary might have been deleted accidentally

-- Check all summaries for this student (replace with actual student user_id)
-- This will help us see if there are any summaries at all
SELECT 
    assum.id,
    assum.assessment_response_id,
    assum.approval_status,
    ar.assessment_type,
    ar.assessment_title
FROM assessment_summaries assum
JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
JOIN students s ON s.id = ar.student_id
WHERE s.user_id = 'STUDENT_USER_ID_HERE'  -- Replace with actual student user_id
ORDER BY assum.updated_at DESC;

