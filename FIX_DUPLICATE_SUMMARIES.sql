-- Fix: Delete old pending summary and ensure only approved one exists
-- This will clean up the duplicate summaries issue

-- First, let's see what summaries exist for this assessment
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    updated_at,
    created_at
FROM assessment_summaries
WHERE assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'
ORDER BY updated_at DESC;

-- Delete the old pending summary (49421251-8375-4c8b-bafc-45ab236718c0)
-- Keep only the approved one (72d9571d-1f27-4b61-a01e-537f08183185)
DELETE FROM assessment_summaries
WHERE id = '49421251-8375-4c8b-bafc-45ab236718c0'
  AND assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83'
  AND approval_status = 'pending_approval';

-- Verify the fix
SELECT 
    id,
    assessment_response_id,
    approval_status,
    approved_at,
    updated_at
FROM assessment_summaries
WHERE assessment_response_id = '7bfb1b73-0e6c-4ed1-86c2-6a3d81f17f83';

