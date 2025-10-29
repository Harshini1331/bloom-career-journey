-- Migration: Assessment API Functions
-- This migration creates functions to fetch assessment data from the database

-- Function to get assessment template with all related data
CREATE OR REPLACE FUNCTION get_assessment_template(
    p_assessment_type assessment_type
)
RETURNS TABLE (
    template_id UUID,
    title TEXT,
    description TEXT,
    instructions TEXT,
    sections JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id as template_id,
        t.title,
        t.description,
        t.instructions,
        COALESCE(
            (
                SELECT jsonb_agg(
                    jsonb_build_object(
                        'id', s.id,
                        'title', s.title,
                        'description', s.description,
                        'sequence_number', s.sequence_number,
                        'questions', COALESCE(
                            (
                                SELECT jsonb_agg(
                                    jsonb_build_object(
                                        'id', q.id,
                                        'question_text', q.question_text,
                                        'question_type', q.question_type,
                                        'help_text', q.help_text,
                                        'is_required', q.is_required,
                                        'sequence_number', q.sequence_number,
                                        'options', COALESCE(
                                            (
                                                SELECT jsonb_agg(
                                                    jsonb_build_object(
                                                        'id', o.id,
                                                        'option_text', o.option_text,
                                                        'option_value', o.option_value,
                                                        'sequence_number', o.sequence_number
                                                    ) ORDER BY o.sequence_number
                                                )
                                                FROM assessment_question_options o
                                                WHERE o.question_id = q.id AND o.is_active = true
                                            ),
                                            '[]'::jsonb
                                        )
                                    ) ORDER BY q.sequence_number
                                )
                                FROM assessment_questions q
                                WHERE q.section_id = s.id AND q.is_active = true
                            ),
                            '[]'::jsonb
                        )
                    ) ORDER BY s.sequence_number
                )
                FROM assessment_sections s
                WHERE s.assessment_template_id = t.id AND s.is_active = true
            ),
            '[]'::jsonb
        ) as sections
    FROM assessment_templates t
    WHERE t.assessment_type = p_assessment_type AND t.is_active = true;
END $$;

-- Function to get media sources for an assessment
CREATE OR REPLACE FUNCTION get_assessment_media_sources(
    p_assessment_type assessment_type
)
RETURNS TABLE (
    id UUID,
    media_type TEXT,
    title TEXT,
    url TEXT,
    description TEXT,
    thumbnail_url TEXT,
    duration_seconds INTEGER,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        m.id,
        m.media_type,
        m.title,
        m.url,
        m.description,
        m.thumbnail_url,
        m.duration_seconds,
        m.sequence_number
    FROM assessment_media_sources m
    JOIN assessment_templates t ON m.assessment_template_id = t.id
    WHERE t.assessment_type = p_assessment_type 
    AND m.is_active = true 
    AND t.is_active = true
    ORDER BY m.sequence_number;
END $$;

-- Function to get all assessment templates (for admin/teacher use)
CREATE OR REPLACE FUNCTION get_all_assessment_templates()
RETURNS TABLE (
    id UUID,
    assessment_type assessment_type,
    title TEXT,
    description TEXT,
    instructions TEXT,
    is_active BOOLEAN,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.id,
        t.assessment_type,
        t.title,
        t.description,
        t.instructions,
        t.is_active,
        t.created_at,
        t.updated_at
    FROM assessment_templates t
    ORDER BY t.assessment_type;
END $$;

-- Function to update assessment template
CREATE OR REPLACE FUNCTION update_assessment_template(
    p_template_id UUID,
    p_title TEXT DEFAULT NULL,
    p_description TEXT DEFAULT NULL,
    p_instructions TEXT DEFAULT NULL,
    p_is_active BOOLEAN DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE assessment_templates
    SET 
        title = COALESCE(p_title, title),
        description = COALESCE(p_description, description),
        instructions = COALESCE(p_instructions, instructions),
        is_active = COALESCE(p_is_active, is_active),
        updated_at = NOW()
    WHERE id = p_template_id;
END $$;

-- Function to add or update media source
CREATE OR REPLACE FUNCTION upsert_media_source(
    p_assessment_type assessment_type,
    p_title TEXT,
    p_url TEXT,
    p_description TEXT DEFAULT NULL,
    p_thumbnail_url TEXT DEFAULT NULL,
    p_duration_seconds INTEGER DEFAULT NULL,
    p_sequence_number INTEGER DEFAULT 0
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_template_id UUID;
    v_media_id UUID;
BEGIN
    -- Get template ID
    SELECT id INTO v_template_id
    FROM assessment_templates
    WHERE assessment_type = p_assessment_type AND is_active = true;
    
    IF v_template_id IS NULL THEN
        RAISE EXCEPTION 'Assessment template not found for type: %', p_assessment_type;
    END IF;
    
    -- Try to find existing media source
    SELECT id INTO v_media_id
    FROM assessment_media_sources
    WHERE assessment_template_id = v_template_id 
    AND title = p_title 
    AND url = p_url;
    
    IF v_media_id IS NOT NULL THEN
        -- Update existing
        UPDATE assessment_media_sources
        SET 
            description = COALESCE(p_description, description),
            thumbnail_url = COALESCE(p_thumbnail_url, thumbnail_url),
            duration_seconds = COALESCE(p_duration_seconds, duration_seconds),
            sequence_number = COALESCE(p_sequence_number, sequence_number),
            updated_at = NOW()
        WHERE id = v_media_id;
    ELSE
        -- Insert new
        INSERT INTO assessment_media_sources (
            assessment_template_id,
            media_type,
            title,
            url,
            description,
            thumbnail_url,
            duration_seconds,
            sequence_number
        ) VALUES (
            v_template_id,
            'video', -- Default to video for now
            p_title,
            p_url,
            p_description,
            p_thumbnail_url,
            p_duration_seconds,
            p_sequence_number
        ) RETURNING id INTO v_media_id;
    END IF;
    
    RETURN v_media_id;
END $$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_assessment_template(assessment_type) TO authenticated;
GRANT EXECUTE ON FUNCTION get_assessment_media_sources(assessment_type) TO authenticated;
GRANT EXECUTE ON FUNCTION get_all_assessment_templates() TO authenticated;
GRANT EXECUTE ON FUNCTION update_assessment_template(UUID, TEXT, TEXT, TEXT, BOOLEAN) TO authenticated;
GRANT EXECUTE ON FUNCTION upsert_media_source(assessment_type, TEXT, TEXT, TEXT, TEXT, INTEGER, INTEGER) TO authenticated;
