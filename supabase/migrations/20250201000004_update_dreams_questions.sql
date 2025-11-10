-- Migration: Update Dreams Assessment Questions
-- This migration replaces existing dreams questions with 18 new questions organized into 3 sections

-- Clear existing dreams questions
DELETE FROM dreams_questions;

-- Update section column to support 'section1', 'section2', 'section3'
-- First, drop the check constraint if it exists
DO $$ 
BEGIN
    -- Drop existing check constraint if it exists
    ALTER TABLE dreams_questions DROP CONSTRAINT IF EXISTS dreams_questions_section_check;
    
    -- Add new check constraint to support section1, section2, section3
    ALTER TABLE dreams_questions ADD CONSTRAINT dreams_questions_section_check 
        CHECK (section IN ('section1', 'section2', 'section3', 'part1', 'part2'));
END $$;

-- Insert new Dreams Questions with help text organized into 3 sections
INSERT INTO dreams_questions (section, question_text, help_text, sequence_number) VALUES

-- Section 1: Your Dreams & Future Goals
('section1', 'What are your dreams about your future?', 'Think about your long-term aspirations and what you want to achieve in your life. Consider different aspects like personal growth, relationships, career, and life experiences.', 1),
('section1', 'What are your academic goals and what would you like to achieve in your studies?', 'Reflect on your educational aspirations. What subjects interest you? What degrees or qualifications do you want to pursue? What knowledge and skills do you hope to gain?', 2),
('section1', 'What career path do you dream of pursuing?', 'Consider your ideal profession or career field. What work would make you happy and fulfilled? Think about your interests, skills, and passions that align with different career paths.', 3),
('section1', 'The sport that you want to play professionally.', 'If you have a passion for sports, describe which sport you would like to pursue at a professional level. Consider what motivates you about this sport and what it would mean to you.', 4),
('section1', 'If you could be a writer, which field would you choose?', 'Think about different types of writing: novels, poetry, journalism, scripts, technical writing, etc. Which form of writing appeals to you and why?', 5),
('section1', 'What field of music do you want to major in? (Singing / Instruments)', 'Consider your musical interests. Do you want to focus on vocal performance, instrumental performance, music composition, or music production? What draws you to music?', 6),

-- Section 2: Career & Life Aspirations
('section2', 'The college that you want to choose.', 'Think about higher education institutions that appeal to you. Consider factors like location, programs offered, campus culture, and how they align with your goals.', 7),
('section2', 'If you were to dedicate your efforts to serving others—whether individuals or a larger cause—what would you choose to serve?', 'Reflect on causes or communities you care about. How do you want to make a positive impact? What issues or people inspire you to help?', 8),
('section2', 'If you had the chance to live anywhere in the world, where would it be?', 'Consider different places based on culture, climate, opportunities, lifestyle, or personal connections. What draws you to this location?', 9),
('section2', 'If you could be an artist, what kind of art would you pursue?', 'Think about different art forms: painting, sculpture, digital art, photography, dance, theater, etc. Which artistic expression resonates with you?', 10),
('section2', 'Are you passionate about traveling? If so, what aspects of travel excite and inspire you the most? Please write.', 'If you love travel, describe what fascinates you about it. Is it exploring new cultures, meeting people, experiencing nature, learning history, or something else?', 11),
('section2', 'If you could observe and learn from a professional for one day, who would it be and why?', 'Think about someone whose work, skills, or achievements inspire you. What would you want to learn from them? What makes them admirable to you?', 12),

-- Section 3: Making Dreams Reality
('section3', 'Do you want to make your dream come true?', 'Reflect on your commitment and determination. Are you willing to put in the effort and work required to achieve your dreams? How important is this to you?', 13),
('section3', 'What essential elements do you believe are necessary to transform your dreams into reality? (pick at least one dream and describe how).', 'Think about the resources, skills, support, opportunities, and steps needed. For at least one of your dreams, outline what you believe is necessary to make it happen.', 14),
('section3', 'What initial steps do you plan to take in order to transform your aspirations and dreams into reality?', 'Consider the immediate actions you can start taking now. What are the first concrete steps you will take to begin working towards your dreams?', 15),
('section3', 'Do you believe you have a positive mindset and the motivation necessary to achieve your dreams and aspirations?', 'Reflect on your mindset and motivation level. Are you optimistic and driven? What helps you stay motivated? What challenges your motivation?', 16),
('section3', 'Have you contemplated the potential hurdles or challenges that could arise on your journey towards achieving your dreams? If yes, what are they? Write them down.', 'Think about obstacles you might face: financial, educational, personal, social, or other challenges. Being aware of potential difficulties helps in planning how to overcome them.', 17),
('section3', 'Do you believe the education and knowledge you are acquiring in school will aid in achieving your dreams? If yes, How?', 'Reflect on how your current education relates to your dreams. Which subjects, skills, or knowledge from school are relevant? How can they help you achieve your goals?', 18);

-- Update the function to return questions in proper order
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
    ORDER BY 
        CASE d.section
            WHEN 'section1' THEN 1
            WHEN 'section2' THEN 2
            WHEN 'section3' THEN 3
            WHEN 'part1' THEN 1
            WHEN 'part2' THEN 2
            ELSE 99
        END,
        d.sequence_number;
END $$;

-- Verify data insertion
DO $$
DECLARE
    dreams_q_count INTEGER;
    section1_count INTEGER;
    section2_count INTEGER;
    section3_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO dreams_q_count FROM dreams_questions;
    SELECT COUNT(*) INTO section1_count FROM dreams_questions WHERE section = 'section1';
    SELECT COUNT(*) INTO section2_count FROM dreams_questions WHERE section = 'section2';
    SELECT COUNT(*) INTO section3_count FROM dreams_questions WHERE section = 'section3';
    
    RAISE NOTICE 'Dreams Questions Update Complete:';
    RAISE NOTICE 'Total Dreams Questions: %', dreams_q_count;
    RAISE NOTICE 'Section 1 Questions: %', section1_count;
    RAISE NOTICE 'Section 2 Questions: %', section2_count;
    RAISE NOTICE 'Section 3 Questions: %', section3_count;
    
    IF dreams_q_count = 18 THEN
        RAISE NOTICE '✅ All 18 Dreams questions inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 18 questions, but found %', dreams_q_count;
    END IF;
    
    IF section1_count = 6 AND section2_count = 6 AND section3_count = 6 THEN
        RAISE NOTICE '✅ Questions properly distributed across 3 sections!';
    ELSE
        RAISE NOTICE '⚠️ Section distribution: Section 1: %, Section 2: %, Section 3: %', section1_count, section2_count, section3_count;
    END IF;
END $$;

