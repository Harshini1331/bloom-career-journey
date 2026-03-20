-- Drop the legacy ALL policy that compares auth.uid() directly to student_id.
-- student_id is the students-table PK, not the auth UID, so the qual
-- (auth.uid() = student_id) always fails on UPDATE, causing 409 on upsert.
-- The newer ar_select_student / ar_insert_student / ar_update_student
-- policies already cover all operations correctly via is_student_owned_by_auth().

DROP POLICY IF EXISTS "Students can manage their own assessment responses"
  ON assessment_responses;
