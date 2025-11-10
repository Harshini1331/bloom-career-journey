-- Test query to check which summary is being returned
-- This will help us verify if the migration was applied correctly

-- First, let's see all summaries for this assessment response
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
ORDER BY 
    CASE WHEN approval_status = 'approved' THEN 0 ELSE 1 END,
    updated_at DESC,
    created_at DESC;

-- Now test the function directly
SELECT * FROM get_summary_by_assessment(
    '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'::UUID,
    'd49f2322-6f7b-4ca0-96de-127673cad3fd'::UUID  -- Replace with actual student user_id
);

