-- Cleanup: Migration 20260331000003 inserted Hindi inspiration summary question
-- translations with keys 'summary_question_1/2/3' (underscore before number).
-- The authoritative RPC (20260331000002) looks for 'summary_question1/2/3' (no underscore).
-- The correct no-underscore rows already exist from the clean_slate migration renamed by
-- 20260312000008. The underscore-format rows are dead data never reached by the RPC.

DELETE FROM content_translations
WHERE resource_type = 'inspiration_summary_question'
  AND lang = 'hi'
  AND resource_key IN ('summary_question_1', 'summary_question_2', 'summary_question_3');
