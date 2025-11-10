-- Migration: Cleanup duplicate summaries
-- This removes old pending summaries when an approved one exists for the same assessment response
-- This ensures the get_summary_by_assessment function returns the correct summary
-- IMPORTANT: This only deletes pending summaries, never approved ones!

-- Delete old pending summaries when an approved one exists for the same assessment_response_id
-- This ensures we only keep the approved summary
DELETE FROM assessment_summaries assum1
WHERE assum1.approval_status = 'pending_approval'
  AND EXISTS (
    SELECT 1
    FROM assessment_summaries assum2
    WHERE assum2.assessment_response_id = assum1.assessment_response_id
      AND assum2.approval_status = 'approved'
      AND assum2.id != assum1.id
  );

-- Also delete any pending summaries that are older than approved ones for the same assessment
DELETE FROM assessment_summaries assum1
WHERE assum1.approval_status = 'pending_approval'
  AND EXISTS (
    SELECT 1
    FROM assessment_summaries assum2
    WHERE assum2.assessment_response_id = assum1.assessment_response_id
      AND assum2.approval_status = 'approved'
      AND assum2.updated_at > assum1.updated_at
  );

-- Safety check: Never delete approved summaries!
-- This migration should only delete pending_approval summaries

