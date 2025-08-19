-- Migration: Add Inspiration Assessment Support
-- This migration adds tables and functions to support the "My Inspiration" assessment

-- Create enum for assessment types
CREATE TYPE IF NOT EXISTS assessment_type AS ENUM ('inspiration', 'dreams', 'school_learning', 'role_models', 'hobbies', 'personality', 'career_aptitude');

-- Create table for assessment responses
CREATE TABLE IF NOT EXISTS assessment_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    assessment_type assessment_type NOT NULL,
    assessment_title TEXT NOT NULL,
    responses JSONB NOT NULL, -- Store all responses as JSON
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create table for inspirational videos/audio sources
CREATE TABLE IF NOT EXISTS inspiration_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    description TEXT,
    sequence_number INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert the 6 inspirational videos from the worksheet
INSERT INTO inspiration_sources (title, url, description, sequence_number) VALUES
('Inspirational Video 1', 'https://youtu.be/U7-HIfpvQIA', 'First inspirational content for self-reflection', 1),
('Inspirational Video 2', 'https://youtu.be/xqb1hfgfcl8', 'Second inspirational content for self-reflection', 2),
('Inspirational Video 3', 'https://youtu.be/z3PYJ9MfMH4', 'Third inspirational content for self-reflection', 3),
('Inspirational Video 4', 'https://youtu.be/X9wViEY5tPQ', 'Fourth inspirational content for self-reflection', 4),
('Inspirational Video 5', 'https://youtu.be/PP-kmxMY1ts', 'Fifth inspirational content for self-reflection', 5),
('Inspirational Video 6', 'https://youtu.be/ZgRLkpSA3iQ', 'Sixth inspirational content for self-reflection', 6);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_assessment_responses_student_id ON assessment_responses(student_id);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_type ON assessment_responses(assessment_type);
CREATE INDEX IF NOT EXISTS idx_assessment_responses_completed_at ON assessment_responses(completed_at);
CREATE INDEX IF NOT EXISTS idx_inspiration_sources_sequence ON inspiration_sources(sequence_number);

-- Enable Row Level Security
ALTER TABLE assessment_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE inspiration_sources ENABLE ROW LEVEL SECURITY;

-- RLS Policies for assessment_responses
CREATE POLICY "Students can view their own assessment responses" ON assessment_responses
    FOR SELECT USING (
        student_id IN (
            SELECT s.id FROM students s 
            WHERE s.user_id = auth.uid()
        )
    );

CREATE POLICY "Students can insert their own assessment responses" ON assessment_responses
    FOR INSERT WITH CHECK (
        student_id IN (
            SELECT s.id FROM students s 
            WHERE s.user_id = auth.uid()
        )
    );

CREATE POLICY "Students can update their own assessment responses" ON assessment_responses
    FOR UPDATE USING (
        student_id IN (
            SELECT s.id FROM students s 
            WHERE s.user_id = auth.uid()
        )
    );

-- Teachers can view assessment responses of their students
CREATE POLICY "Teachers can view assessment responses of their students" ON assessment_responses
    FOR SELECT USING (
        student_id IN (
            SELECT s.id FROM students s 
            WHERE s.teacher_id = (
                SELECT t.id FROM teachers t 
                WHERE t.user_id = auth.uid()
            )
        )
    );

-- RLS Policies for inspiration_sources (read-only for all authenticated users)
CREATE POLICY "Authenticated users can view inspiration sources" ON inspiration_sources
    FOR SELECT USING (auth.role() = 'authenticated');

-- Function to get assessment responses for a teacher
CREATE OR REPLACE FUNCTION get_student_assessment_responses(
    teacher_user_id UUID,
    assessment_type_filter assessment_type DEFAULT NULL
)
RETURNS TABLE (
    student_name TEXT,
    student_class TEXT,
    assessment_title TEXT,
    responses JSONB,
    completed_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        u.full_name as student_name,
        c.name as student_class,
        ar.assessment_title,
        ar.responses,
        ar.completed_at
    FROM assessment_responses ar
    JOIN students s ON ar.student_id = s.id
    JOIN users u ON s.user_id = u.id
    JOIN classes c ON s.class_id = c.id
    JOIN teachers t ON s.teacher_id = t.id
    WHERE t.user_id = teacher_user_id
    AND (assessment_type_filter IS NULL OR ar.assessment_type = assessment_type_filter)
    ORDER BY ar.completed_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant necessary permissions
GRANT SELECT ON assessment_responses TO authenticated;
GRANT INSERT, UPDATE ON assessment_responses TO authenticated;
GRANT SELECT ON inspiration_sources TO authenticated;
GRANT EXECUTE ON FUNCTION get_student_assessment_responses TO authenticated;
