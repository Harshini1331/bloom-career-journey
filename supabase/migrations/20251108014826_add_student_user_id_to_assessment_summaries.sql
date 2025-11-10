-- Migration: Add student_user_id column to assessment_summaries for real-time filtering and notifications
-- Adds student_user_id, backfills existing records, and sets up indexes/constraints

ALTER TABLE assessment_summaries
ADD COLUMN IF NOT EXISTS student_user_id UUID;

-- Backfill student_user_id for existing summaries
UPDATE assessment_summaries assum
SET student_user_id = s.user_id
FROM assessment_responses ar
JOIN students s ON s.id = ar.student_id
WHERE assum.assessment_response_id = ar.id
  AND (assum.student_user_id IS DISTINCT FROM s.user_id);

-- Add foreign key constraint (if it doesn't already exist)
DO $$
BEGIN
    ALTER TABLE assessment_summaries
    ADD CONSTRAINT assessment_summaries_student_user_id_fkey
    FOREIGN KEY (student_user_id) REFERENCES users(id) ON DELETE CASCADE;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- Index for faster lookups and realtime filters
CREATE INDEX IF NOT EXISTS idx_assessment_summaries_student_user
ON assessment_summaries(student_user_id);
