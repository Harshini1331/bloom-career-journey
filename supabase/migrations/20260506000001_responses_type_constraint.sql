-- Ensure assessment_responses.responses is always a JSON object.
-- NOT VALID skips backfilling existing rows; only new inserts/updates are checked.
ALTER TABLE assessment_responses
  ADD CONSTRAINT responses_is_object
  CHECK (jsonb_typeof(responses) = 'object') NOT VALID;
