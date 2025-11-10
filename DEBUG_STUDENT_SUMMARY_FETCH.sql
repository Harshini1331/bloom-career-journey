-- Debug: Check why student can't see the approved summary
-- Replace STUDENT_USER_ID with actual student user_id

-- Step 1: Check if the student is linked to this assessment response
SELECT 
    ar.id as assessment_response_id,
    ar.assessment_type,
    s.id as student_id,
    s.user_id as student_user_id,
    t.id as teacher_id,
    t.user_id as teacher_user_id
FROM assessment_responses ar
LEFT JOIN students s ON s.id = ar.student_id
LEFT JOIN teachers t ON t.id = s.teacher_id
WHERE ar.id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83';

-- Step 2: Test the function with the student's user_id
-- Replace STUDENT_USER_ID with actual student user_id from Step 1
SELECT * FROM get_summary_by_assessment(
    '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'::UUID,
    'STUDENT_USER_ID_HERE'::UUID  -- Replace with actual student user_id
);

-- Step 3: Check if the summary exists and is approved
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by
FROM assessment_summaries
WHERE assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83';

-- Step 4: Check RLS - see if student can see the summary directly
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

