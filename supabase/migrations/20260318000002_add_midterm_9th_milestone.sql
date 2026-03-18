-- ============================================================
-- Add 'midterm_9th' milestone to career_roadmap CHECK constraint
-- ============================================================

BEGIN;

-- Drop and recreate the CHECK constraint to include the new milestone
ALTER TABLE career_roadmap
DROP CONSTRAINT IF EXISTS career_roadmap_milestone_check;

ALTER TABLE career_roadmap
ADD CONSTRAINT career_roadmap_milestone_check
CHECK (milestone IN (
  'beginning_9th', 'midterm_9th', 'end_9th', 'beginning_10th',
  'midterm_10th', 'post_exam_10th', 'before_results_10th', 'final_decision'
));

COMMIT;
