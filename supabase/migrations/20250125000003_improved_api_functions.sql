-- Migration: Improved API Functions for Separate Assessment Tables

-- Function to get Holland Code questions
CREATE OR REPLACE FUNCTION get_holland_code_questions()
RETURNS TABLE (
    category TEXT,
    question_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        h.category,
        h.question_text,
        h.sequence_number
    FROM holland_code_questions h
    WHERE h.is_active = true
    ORDER BY h.category, h.sequence_number;
END $$;

-- Function to get Inspiration questions
CREATE OR REPLACE FUNCTION get_inspiration_questions()
RETURNS TABLE (
    id UUID,
    question_text TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.id,
        i.question_text,
        i.help_text,
        i.sequence_number
    FROM inspiration_questions i
    WHERE i.is_active = true
    ORDER BY i.sequence_number;
END $$;

-- Function to get Inspiration videos
CREATE OR REPLACE FUNCTION get_inspiration_videos()
RETURNS TABLE (
    id UUID,
    title TEXT,
    url TEXT,
    youtube_id TEXT,
    description TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id,
        v.title,
        v.url,
        v.youtube_id,
        v.description,
        v.sequence_number
    FROM inspiration_videos v
    WHERE v.is_active = true
    ORDER BY v.sequence_number;
END $$;

-- Function to get Dreams questions
CREATE OR REPLACE FUNCTION get_dreams_questions()
RETURNS TABLE (
    id UUID,
    section TEXT,
    question_text TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id,
        d.section,
        d.question_text,
        d.help_text,
        d.sequence_number
    FROM dreams_questions d
    WHERE d.is_active = true
    ORDER BY d.section, d.sequence_number;
END $$;

-- Function to get School Learning questions
CREATE OR REPLACE FUNCTION get_school_learning_questions()
RETURNS TABLE (
    id UUID,
    section TEXT,
    question_text TEXT,
    question_type TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
        s.section,
        s.question_text,
        s.question_type,
        s.help_text,
        s.sequence_number
    FROM school_learning_questions s
    WHERE s.is_active = true
    ORDER BY s.section, s.sequence_number;
END $$;

-- Function to get School Learning options
CREATE OR REPLACE FUNCTION get_school_learning_options(p_question_id UUID)
RETURNS TABLE (
    id UUID,
    option_text TEXT,
    option_value TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.option_text,
        o.option_value,
        o.sequence_number
    FROM school_learning_options o
    WHERE o.question_id = p_question_id AND o.is_active = true
    ORDER BY o.sequence_number;
END $$;

-- Function to update Holland Code question
CREATE OR REPLACE FUNCTION update_holland_code_question(
    p_question_id UUID,
    p_question_text TEXT DEFAULT NULL,
    p_sequence_number INTEGER DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE holland_code_questions
    SET 
        question_text = COALESCE(p_question_text, question_text),
        sequence_number = COALESCE(p_sequence_number, sequence_number),
        updated_at = NOW()
    WHERE id = p_question_id;
END $$;

-- Function to update Inspiration question
CREATE OR REPLACE FUNCTION update_inspiration_question(
    p_question_id UUID,
    p_question_text TEXT DEFAULT NULL,
    p_help_text TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE inspiration_questions
    SET 
        question_text = COALESCE(p_question_text, question_text),
        help_text = COALESCE(p_help_text, help_text),
        updated_at = NOW()
    WHERE id = p_question_id;
END $$;

-- Function to update Inspiration video
CREATE OR REPLACE FUNCTION update_inspiration_video(
    p_video_id UUID,
    p_title TEXT DEFAULT NULL,
    p_url TEXT DEFAULT NULL,
    p_description TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE inspiration_videos
    SET 
        title = COALESCE(p_title, title),
        url = COALESCE(p_url, url),
        description = COALESCE(p_description, description),
        updated_at = NOW()
    WHERE id = p_video_id;
END $$;

-- Function to get About Me questions
CREATE OR REPLACE FUNCTION get_about_me_questions()
RETURNS TABLE (
    id UUID,
    question_text TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.question_text,
        a.help_text,
        a.sequence_number
    FROM about_me_questions a
    WHERE a.is_active = true
    ORDER BY a.sequence_number;
END $$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_holland_code_questions() TO authenticated;
GRANT EXECUTE ON FUNCTION get_inspiration_questions() TO authenticated;
GRANT EXECUTE ON FUNCTION get_inspiration_videos() TO authenticated;
GRANT EXECUTE ON FUNCTION get_dreams_questions() TO authenticated;
GRANT EXECUTE ON FUNCTION get_school_learning_questions() TO authenticated;
GRANT EXECUTE ON FUNCTION get_school_learning_options(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_about_me_questions() TO authenticated;
GRANT EXECUTE ON FUNCTION update_holland_code_question(UUID, TEXT, INTEGER) TO authenticated;
GRANT EXECUTE ON FUNCTION update_inspiration_question(UUID, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION update_inspiration_video(UUID, TEXT, TEXT, TEXT) TO authenticated;
