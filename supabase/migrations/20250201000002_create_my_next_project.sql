-- Migration: Create My Next Project Assessment
-- This migration creates the database structure for "My Next Project" assessment
-- Unlocks after "About Me" is completed

-- Add 'my_next_project' and 'about_me' to assessment_type enum if they don't exist
DO $$ 
BEGIN
    -- Add 'about_me' if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'about_me' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'assessment_type')) THEN
        ALTER TYPE assessment_type ADD VALUE 'about_me';
    END IF;
    
    -- Add 'my_next_project' if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'my_next_project' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'assessment_type')) THEN
        ALTER TYPE assessment_type ADD VALUE 'my_next_project';
    END IF;
END $$;

-- Create table for My Next Project questions
CREATE TABLE IF NOT EXISTS my_next_project_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_text TEXT NOT NULL,
    field_key TEXT NOT NULL UNIQUE,
    sequence_number INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create table for My Next Project responses
-- This stores individual student responses
CREATE TABLE IF NOT EXISTS my_next_project_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    field_key TEXT NOT NULL,
    response_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_student_field UNIQUE (student_id, field_key)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_my_next_project_questions_sequence ON my_next_project_questions(sequence_number);
CREATE INDEX IF NOT EXISTS idx_my_next_project_responses_student ON my_next_project_responses(student_id);
CREATE INDEX IF NOT EXISTS idx_my_next_project_responses_field ON my_next_project_responses(field_key);

-- Insert My Next Project questions
INSERT INTO my_next_project_questions (question_text, field_key, sequence_number) VALUES
('The friend in my family', 'friend_in_family', 1),
('My friend outside of my family', 'friend_outside_family', 2),
('What activities am I doing at home?', 'activities_at_home', 3),
('Activities/aspects I Enjoy during the school hours', 'activities_during_school', 4),
('Activities/aspects I enjoy outside of the school', 'activities_outside_school', 5),
('Work/activities I enjoy personally', 'activities_enjoy_personally', 6),
('Work/activities I enjoy as a team', 'activities_enjoy_team', 7),
('Activity that needs to be done in the school but I find difficult', 'activity_difficult_school', 8),
('Activity that I find difficult to do after school hours', 'activity_difficult_after_school', 9),
('Activities I must do', 'activities_must_do', 10),
('Activities that come naturally to me', 'activities_natural', 11),
('Activities that don''t come naturally to me', 'activities_not_natural', 12),
('Qualities I like in myself', 'qualities_like_myself', 13),
('Qualities that others like in me', 'qualities_others_like', 14),
('Qualities that I need to improve on', 'qualities_improve', 15);

-- Create function to get My Next Project questions
CREATE OR REPLACE FUNCTION get_my_next_project_questions()
RETURNS TABLE (
    id UUID,
    question_text TEXT,
    field_key TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        q.id,
        q.question_text,
        q.field_key,
        q.sequence_number
    FROM my_next_project_questions q
    WHERE q.is_active = true
    ORDER BY q.sequence_number;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_my_next_project_questions() TO authenticated;

-- Create function to get My Next Project responses for a student
CREATE OR REPLACE FUNCTION get_my_next_project_responses(p_student_id UUID)
RETURNS TABLE (
    field_key TEXT,
    response_text TEXT,
    updated_at TIMESTAMP WITH TIME ZONE
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.field_key,
        r.response_text,
        r.updated_at
    FROM my_next_project_responses r
    WHERE r.student_id = p_student_id
    ORDER BY r.field_key;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_my_next_project_responses(UUID) TO authenticated;

-- Create function to save/update My Next Project response
CREATE OR REPLACE FUNCTION save_my_next_project_response(
    p_student_id UUID,
    p_field_key TEXT,
    p_response_text TEXT
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_response_id UUID;
BEGIN
    INSERT INTO my_next_project_responses (student_id, field_key, response_text, updated_at)
    VALUES (p_student_id, p_field_key, p_response_text, NOW())
    ON CONFLICT (student_id, field_key)
    DO UPDATE SET
        response_text = EXCLUDED.response_text,
        updated_at = NOW()
    RETURNING id INTO v_response_id;
    
    RETURN v_response_id;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION save_my_next_project_response(UUID, TEXT, TEXT) TO authenticated;

-- Create function to check if student has completed My Next Project
CREATE OR REPLACE FUNCTION has_completed_my_next_project(p_student_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_total_questions INTEGER;
    v_completed_responses INTEGER;
BEGIN
    -- Get total active questions
    SELECT COUNT(*) INTO v_total_questions
    FROM my_next_project_questions
    WHERE is_active = true;
    
    -- Get count of non-empty responses
    SELECT COUNT(*) INTO v_completed_responses
    FROM my_next_project_responses
    WHERE student_id = p_student_id
    AND response_text IS NOT NULL
    AND TRIM(response_text) != '';
    
    -- Completed if all questions have responses
    RETURN v_completed_responses >= v_total_questions;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION has_completed_my_next_project(UUID) TO authenticated;

-- Verify data insertion
DO $$
DECLARE
    question_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO question_count FROM my_next_project_questions;
    
    RAISE NOTICE 'My Next Project Questions Population Complete:';
    RAISE NOTICE 'Total Questions: %', question_count;
    
    IF question_count = 15 THEN
        RAISE NOTICE '✅ All 15 My Next Project questions inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 15 questions, but found %', question_count;
    END IF;
END $$;

