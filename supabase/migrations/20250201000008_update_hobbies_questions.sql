-- Migration: Update Hobbies Assessment Questions
-- This migration replaces existing hobbies questions with 14 new questions organized into 3 sections

-- Clear existing hobbies questions
DELETE FROM hobbies_questions;

-- Add section column if it doesn't exist
DO $$ 
BEGIN
    -- Check if section column exists
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'hobbies_questions' 
        AND column_name = 'section'
    ) THEN
        ALTER TABLE hobbies_questions ADD COLUMN section TEXT;
        -- Set default section for existing data if any
        UPDATE hobbies_questions SET section = 'section1' WHERE section IS NULL;
        -- Make section NOT NULL
        ALTER TABLE hobbies_questions ALTER COLUMN section SET NOT NULL;
    END IF;
    
    -- Drop existing check constraint if it exists
    ALTER TABLE hobbies_questions DROP CONSTRAINT IF EXISTS hobbies_questions_section_check;
    
    -- Add new check constraint to support section1-3
    ALTER TABLE hobbies_questions ADD CONSTRAINT hobbies_questions_section_check 
        CHECK (section IN ('section1', 'section2', 'section3'));
END $$;

-- Insert new Hobbies Questions with help text organized into 3 sections
INSERT INTO hobbies_questions (section, question_text, help_text, sequence_number) VALUES

-- Section 1: Hobbies & Interests (Questions 1-7)
('section1', 'What work/activities do you do in your free time?', 'Think about how you spend your time when you are not doing schoolwork or chores. Consider activities like reading, playing sports, drawing, listening to music, spending time with friends, or any other activities you enjoy.', 1),
('section1', 'Do you have any hobbies? List the good habits that you have.', 'Reflect on activities you do regularly for enjoyment. List hobbies such as reading, playing instruments, sports, drawing, writing, cooking, or any other interests. Also mention positive habits you have developed through these activities.', 2),
('section1', 'Among the above list, which is your favourite and Why?', 'Think about which hobby or activity brings you the most joy and satisfaction. Consider what specifically makes this hobby stand out - is it the sense of accomplishment, the relaxation it provides, or the skills you develop?', 3),
('section1', 'Have you ever changed any of your hobbies?', 'Reflect on whether your hobbies have evolved over time. Consider if you used to have different hobbies that you no longer pursue, or if your interests have shifted or expanded.', 4),
('section1', 'What inspired your hobbies? Did you inherit any of your hobbies from someone in your life, or were they influenced by certain sources of inspiration? Think about this and write below', 'Think about the origins of your hobbies. Did family members, friends, teachers, or role models introduce you to these activities? Were you inspired by books, movies, music, or other media? Reflect on the people or experiences that sparked your interest.', 5),
('section1', 'Do you have anyone close to you who shares similar hobbies or interests? If so, who are they?', 'Consider people in your life who enjoy similar activities. Think about family members, friends, classmates, or mentors who share your interests and how these shared hobbies strengthen your relationships.', 6),
('section1', 'How do you feel when you''re engaged in your favourite hobby? Does it help you relax or feel more confident?', 'Reflect on the emotional impact of your favourite hobby. Consider how it makes you feel - does it calm you down, energize you, boost your confidence, provide a sense of accomplishment, or bring you happiness?', 7),

-- Section 2: Talents & Practice (Questions 8-10)
('section2', 'Can you list your talents?', 'Think about natural abilities or skills that come easily to you. Consider talents like singing, drawing, problem-solving, communication, athletic abilities, creative thinking, or any other natural strengths you possess.', 8),
('section2', 'Do you engage and practice to enhance and refine your talent? If so, how?', 'Reflect on how you work to improve your talents. Consider the practice routines, learning methods, or training you undertake. Think about the steps you take to develop and strengthen your natural abilities.', 9),
('section2', 'Are you encouraged to practice your hobbies and talents at home, school, or any other locations? Do you also get opportunities to demonstrate them?', 'Think about the support and opportunities you receive. Consider whether your family, school, or community provides encouragement, resources, or platforms for you to practice and showcase your hobbies and talents.', 10),

-- Section 3: Support & Career Connection (Questions 11-14)
('section3', 'Are your parents supportive of your efforts to develop your talents and hobbies? How?', 'Reflect on parental support for your interests. Consider how your parents encourage you - through financial support, time allocation, participation, guidance, or emotional encouragement. Think about specific ways they help you pursue your hobbies and talents.', 11),
('section3', 'Do you have any hobbies that align with your natural talents and abilities?', 'Consider the connection between your hobbies and talents. Think about whether your hobbies help you develop or utilize your natural talents, and how they complement each other to enhance your overall abilities.', 12),
('section3', 'Are there any hobbies that can potentially be pursued as a profession in the future? If so, what steps can be taken to turn these hobbies into a career?', 'Think about career possibilities from your hobbies. Identify hobbies that could become professions and consider the education, training, skills development, networking, or practical steps needed to transform these interests into career paths.', 13),
('section3', 'Do you know anyone who has turned their hobby or personal interests into a profession? Who and what hobby and how did they do it?', 'Reflect on people you know who have made careers from hobbies. Consider family members, friends, mentors, or public figures who successfully transformed their interests into professions. Think about their journey and the steps they took to achieve this.', 14);

-- Update the function to return questions in proper order
CREATE OR REPLACE FUNCTION get_hobbies_questions()
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
        h.id,
        h.section,
        h.question_text,
        h.help_text,
        h.sequence_number
    FROM hobbies_questions h
    WHERE h.is_active = true
    ORDER BY 
        CASE h.section
            WHEN 'section1' THEN 1
            WHEN 'section2' THEN 2
            WHEN 'section3' THEN 3
            ELSE 99
        END,
        h.sequence_number;
END $$;

-- Verify data insertion
DO $$
DECLARE
    hobbies_q_count INTEGER;
    section1_count INTEGER;
    section2_count INTEGER;
    section3_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO hobbies_q_count FROM hobbies_questions;
    SELECT COUNT(*) INTO section1_count FROM hobbies_questions WHERE section = 'section1';
    SELECT COUNT(*) INTO section2_count FROM hobbies_questions WHERE section = 'section2';
    SELECT COUNT(*) INTO section3_count FROM hobbies_questions WHERE section = 'section3';
    
    RAISE NOTICE 'Hobbies Questions Update Complete:';
    RAISE NOTICE 'Total Hobbies Questions: %', hobbies_q_count;
    RAISE NOTICE 'Section 1 Questions: %', section1_count;
    RAISE NOTICE 'Section 2 Questions: %', section2_count;
    RAISE NOTICE 'Section 3 Questions: %', section3_count;
    
    IF hobbies_q_count = 14 THEN
        RAISE NOTICE '✅ All 14 Hobbies questions inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 14 questions, but found %', hobbies_q_count;
    END IF;
    
    IF section1_count = 7 AND section2_count = 3 AND section3_count = 4 THEN
        RAISE NOTICE '✅ Questions properly distributed across 3 sections!';
    ELSE
        RAISE NOTICE '⚠️ Section distribution: Section 1: %, Section 2: %, Section 3: %', 
            section1_count, section2_count, section3_count;
    END IF;
END $$;

