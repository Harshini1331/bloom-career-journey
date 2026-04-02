-- Migration: Add approval workflow to profile_card_cache
-- Teachers can approve/reject student profile cards per module

BEGIN;

-- Add approval columns
ALTER TABLE profile_card_cache
  ADD COLUMN IF NOT EXISTS approval_status text DEFAULT 'pending'
    CHECK (approval_status IN ('pending', 'approved', 'rejected'));

ALTER TABLE profile_card_cache
  ADD COLUMN IF NOT EXISTS approved_by uuid REFERENCES users(id);

ALTER TABLE profile_card_cache
  ADD COLUMN IF NOT EXISTS approved_at timestamptz;

ALTER TABLE profile_card_cache
  ADD COLUMN IF NOT EXISTS rejection_reason text;

-- Teachers can update profile_card_cache for their students (approve/reject)
CREATE POLICY "Teachers can update profile card cache for their students"
  ON profile_card_cache FOR UPDATE
  USING (
    EXISTS (
      SELECT 1
      FROM students s
      JOIN classes c ON s.class_id = c.id
      JOIN teachers t ON t.state_id = c.state_id
      WHERE s.user_id = profile_card_cache.student_id
        AND t.user_id = auth.uid()
    )
  );

-- RLS for teacher reads on career_roadmap (for the new teacher roadmap view)
CREATE POLICY "Teachers can read career roadmap for their students"
  ON career_roadmap FOR SELECT
  USING (
    student_id IN (
      SELECT s.id FROM students s
      JOIN teachers t ON s.teacher_id = t.id
      WHERE t.user_id = auth.uid()
    )
    OR student_id = auth.uid()
  );

-- RLS for teacher reads on things_that_interest_me (for the new teacher interests view)
CREATE POLICY "Teachers can read interests for their students"
  ON things_that_interest_me FOR SELECT
  USING (
    student_id IN (
      SELECT s.id FROM students s
      JOIN teachers t ON s.teacher_id = t.id
      WHERE t.user_id = auth.uid()
    )
  );

COMMIT;
