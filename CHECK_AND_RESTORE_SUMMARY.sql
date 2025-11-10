-- Step 1: Check if the approved summary still exists
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

-- Step 2: Check if the approved summary exists by ID
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    approved_by
FROM assessment_summaries
WHERE id = '72d9571d-1f27-4b61-a01e-537f08183185';

-- Step 3: If the summary doesn't exist, check if we can restore it from a backup
-- Or we need to regenerate it

-- IMPORTANT: If the summary was deleted, we need to either:
-- 1. Restore it from a backup (if available)
-- 2. Have the teacher approve it again
-- 3. Regenerate it

-- Step 4: Check if there are any summaries at all for this assessment
SELECT COUNT(*) as summary_count
FROM assessment_summaries
WHERE assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83';

