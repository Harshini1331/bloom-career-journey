-- Migration: About Me Assessment Field Mapping
-- This migration creates a proper field mapping for the About Me Assessment

-- Create a new table for About Me field definitions
CREATE TABLE IF NOT EXISTS about_me_fields (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    field_key TEXT NOT NULL UNIQUE,
    question_text TEXT NOT NULL,
    help_text TEXT,
    field_type TEXT NOT NULL CHECK (field_type IN ('text', 'textarea', 'triple', 'double')),
    section TEXT NOT NULL,
    sequence_number INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clear existing data
DELETE FROM about_me_fields;

-- Insert all About Me fields with proper mapping
INSERT INTO about_me_fields (field_key, question_text, help_text, field_type, section, sequence_number) VALUES

-- A. Your Profile
('profile_family', 'With which family member are you able to share your opinions and feelings freely without fear or reserve?', 'Write the name or relation of the person (mother, father, sister, etc.) with whom you feel most comfortable sharing your thoughts.', 'text', 'A. Your Profile', 1),
('profile_other', 'Other than your family members, with whom are you able to share your opinions and feelings freely without fear or reserve?', 'Mention a friend, teacher, or another person you trust and can talk to openly.', 'text', 'A. Your Profile', 2),
('home_work', 'What work do you do at home? (eg: help in farming activities, buying vegetables, taking care of cattle, filling water, etc.)', 'Write about the kind of work or help you give at home every day or sometimes.', 'textarea', 'A. Your Profile', 3),

-- B. What is your favourite work?
('fav_job_school', 'The job that you do well and are happy to do - at school', 'Write about a school activity or subject you are good at and enjoy doing.', 'textarea', 'B. What is your favourite work?', 4),
('fav_job_after_school', 'The job that you do well and are happy to do - after school', 'Write about something you do at home or outside school that you do well and like doing.', 'textarea', 'B. What is your favourite work?', 5),
('solo_activities', 'The activities that you like to do on your own (Practically doing it alone)', 'Write about things you like doing alone — for example reading, drawing, singing, or gardening.', 'textarea', 'B. What is your favourite work?', 6),
('with_friends_tasks', 'The tasks that you like to do with your friends', 'Mention the fun or helpful activities you enjoy doing with your friends.', 'textarea', 'B. What is your favourite work?', 7),

-- C. The job that you find difficult to carry out
('diff_at_school', 'At school', 'Write about something at school that feels hard for you to do.', 'textarea', 'C. The job that you find difficult to carry out', 8),
('diff_after_school', 'After school', 'Mention a task outside school that you find difficult.', 'textarea', 'C. The job that you find difficult to carry out', 9),
('dont_like_but_do', 'The jobs that you don''t like to do but have to do', 'Write about tasks you don''t enjoy but still do because they are needed.', 'textarea', 'C. The job that you find difficult to carry out', 10),
('not_natural_jobs', 'The jobs that don''t come naturally to you', 'Write about tasks that you struggle with or take time to learn.', 'textarea', 'C. The job that you find difficult to carry out', 11),

-- D. Answer the below questions to share more information about yourself
('like_about_me', 'The things that you like about yourself', 'Write about your good habits, strengths, or anything that makes you proud of yourself.', 'triple', 'D. Answer the below questions to share more information about yourself', 12),
('others_like_about_me', 'What do others like about you? (You could ask your parents/guardians, teachers, friends etc.)', 'Write what others appreciate about you — kindness, helpfulness, honesty, etc.', 'triple', 'D. Answer the below questions to share more information about yourself', 13),
('praised_for', 'Things for which you were praised.', 'Mention any time you were appreciated or got good comments — at home, school, or anywhere.', 'triple', 'D. Answer the below questions to share more information about yourself', 14),
('change_in_self', 'What would you like to change in yourself.', 'Write about something you want to improve or learn to do better.', 'double', 'D. Answer the below questions to share more information about yourself', 15),
('aspire_like_someone', 'If you had the chance to be like somebody or be someone, who would you aspire to be or what would you aspire to do?', 'Write the name of a person you admire or the kind of work/life you wish to have.', 'textarea', 'D. Answer the below questions to share more information about yourself', 16),
('about_me_brief', 'Write about yourself in brief', 'Write a few lines about who you are — your likes, hobbies, family, or dreams.', 'textarea', 'D. Answer the below questions to share more information about yourself', 17);

-- Create function to get About Me fields
CREATE OR REPLACE FUNCTION get_about_me_fields()
RETURNS TABLE (
    field_key TEXT,
    question_text TEXT,
    help_text TEXT,
    field_type TEXT,
    section TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.field_key,
        a.question_text,
        a.help_text,
        a.field_type,
        a.section,
        a.sequence_number
    FROM about_me_fields a
    WHERE a.is_active = true
    ORDER BY a.sequence_number;
END $$;

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_about_me_fields() TO authenticated;

-- Verify data insertion
DO $$
DECLARE
    field_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO field_count FROM about_me_fields;
    
    RAISE NOTICE 'About Me Fields Population Complete:';
    RAISE NOTICE 'Total About Me Fields: %', field_count;
    
    IF field_count = 17 THEN
        RAISE NOTICE '✅ All 17 About Me fields inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 17 fields, but found %', field_count;
    END IF;
END $$;
