-- Check if the summary exists by the approved ID
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by,
    ai_summary,
    teacher_edited_summary,
    updated_at
FROM assessment_summaries
WHERE id = '72d9571d-1f27-4b61-a01e-537f08183185';

-- If the summary doesn't exist, we need to check if we can find it in the teacher's view
-- Or we need to regenerate it from the student's assessment responses

-- Check if there are any summaries at all for this student
-- (Replace STUDENT_USER_ID with actual student user_id)
SELECT 
    assum.id,
    assum.assessment_response_id,
    assum.approval_status,
    ar.assessment_type,
    ar.assessment_title
FROM assessment_summaries assum
JOIN assessment_responses ar ON ar.id = assum.assessment_response_id
JOIN students s ON s.id = ar.student_id
WHERE s.user_id = 'STUDENT_USER_ID'  -- Replace with actual student user_id
  AND ar.assessment_type = 'inspiration'
ORDER BY assum.updated_at DESC;

