-- Fix: get_inspiration_videos was missing WHERE s.is_active = true.
-- Inactive video rows were still returned to students.
-- Also consistent with get_inspiration_questions_i18n which already filters is_active.

DROP FUNCTION IF EXISTS get_inspiration_videos(TEXT);

CREATE OR REPLACE FUNCTION get_inspiration_videos(p_lang TEXT DEFAULT 'en')
RETURNS TABLE (
    id UUID,
    title TEXT,
    url TEXT,
    description TEXT,
    sequence_number INTEGER
)
LANGUAGE sql
SECURITY DEFINER
AS $$
    SELECT s.id, s.title, s.url, s.description, s.sequence_number
    FROM inspiration_sources s
    WHERE s.lang = p_lang
      AND s.is_active = true
      AND s.sequence_number IS NOT NULL
    ORDER BY s.sequence_number;
$$;

GRANT EXECUTE ON FUNCTION get_inspiration_videos(TEXT) TO authenticated;
