-- Migration: Update School Learning Assessment Questions
-- This migration replaces existing school learning questions with 21 new questions organized into 4 sections

-- Clear existing school learning questions and options
DELETE FROM school_learning_options;
DELETE FROM school_learning_questions;

-- Update section column to support 'section1', 'section2', 'section3', 'section4'
DO $$ 
BEGIN
    -- Drop existing check constraint if it exists
    ALTER TABLE school_learning_questions DROP CONSTRAINT IF EXISTS school_learning_questions_section_check;
    
    -- Add new check constraint to support section1-4 and part1-3 for backward compatibility
    ALTER TABLE school_learning_questions ADD CONSTRAINT school_learning_questions_section_check 
        CHECK (section IN ('section1', 'section2', 'section3', 'section4', 'part1', 'part2', 'part3'));
END $$;

-- Insert new School Learning Questions with help text organized into 4 sections
INSERT INTO school_learning_questions (section, question_text, question_type, help_text, sequence_number) VALUES

-- Section 1: School Experience (Questions 1-5)
('section1', 'Do you like coming to school? Why?', 'textarea', 'Reflect on your overall feelings about school. Think about what motivates you to come to school each day. Consider both positive aspects and any challenges you face.', 1),
('section1', 'What do you like to learn at school?', 'textarea', 'Think about the subjects, topics, or skills that interest you most at school. Consider what makes learning enjoyable for you.', 2),
('section1', 'Are there reasons why you don''t like learning at school?', 'textarea', 'Be honest about any challenges or difficulties you face while learning at school. Consider factors like teaching methods, subject difficulty, or classroom environment.', 3),
('section1', 'Who are your best friends at school, and what qualities or shared experiences make them your best friends?', 'textarea', 'Think about the friendships you value most. Consider what qualities you appreciate in your friends and what shared experiences have strengthened these friendships.', 4),
('section1', 'Which topics/subjects do you enjoy learning? Write.', 'textarea', 'List the specific subjects or topics that you find interesting and engaging. Consider what draws you to these particular areas of study.', 5),

-- Section 2: Learning Preferences & Challenges (Questions 6-12)
('section2', 'What specifically draws you towards these topics/subjects? Write the reasons.', 'textarea', 'Reflect deeply on what makes these subjects appealing to you. Consider factors like your interests, natural abilities, practical applications, or personal goals.', 6),
('section2', 'Which subjects do you dislike learning?', 'textarea', 'Be honest about subjects that you find challenging or uninteresting. Think about what specifically makes these subjects difficult for you.', 7),
('section2', 'Why do you have less interest in the above mentioned subjects? What challenges do you find in learning those subjects?', 'textarea', 'Analyze the specific reasons behind your disinterest. Consider factors such as difficulty level, teaching methods, lack of relevance, or previous negative experiences.', 8),
('section2', 'In which subjects do you score/get marks well?', 'textarea', 'Identify subjects where you consistently perform well academically. Think about the subjects where you feel confident and successful.', 9),
('section2', 'In which subjects do you find it challenging to achieve high scores?', 'textarea', 'Reflect on subjects where you struggle to get good marks despite your efforts. Consider what makes these subjects particularly challenging for you.', 10),
('section2', 'Which learning methodologies from the following options resonate with you the most? (Mark with ✔ that applies to you).', 'checkbox', 'Select all learning methods that work best for you. This helps identify your preferred learning style, which can guide how you approach studying and career choices.', 11),
('section2', 'Do you enjoy studying alone or in a group? Why? Write the reason.', 'textarea', 'Reflect on your preferred study environment. Consider whether you learn better independently or with others, and think about the specific reasons for your preference.', 12),

-- Section 3: Learning from Others & School Life (Questions 13-16)
('section3', 'Do you learn from your friends in school? Can you list a few things that you learnt from your friends in school recently.', 'textarea', 'Think about what you have learned from your peers beyond academics. Consider social skills, different perspectives, study techniques, or life lessons you have gained from friendships.', 13),
('section3', 'Besides academics, what aspects of school do you enjoy the most?', 'textarea', 'Reflect on non-academic aspects of school life. Consider extracurricular activities, social interactions, school events, clubs, sports, or other activities that bring you joy.', 14),
('section3', 'Who is your favourite teacher and why? How has this teacher influenced you?', 'textarea', 'Think about a teacher who has made a positive impact on you. Consider their teaching style, personality, support, or how they have shaped your learning and personal growth.', 15),
('section3', 'Was there a specific instance in school that made you feel very successful or proud? What was it?', 'textarea', 'Reflect on a memorable achievement or moment in school that made you feel accomplished. Consider what made this moment special and how it affected your confidence.', 16),

-- Section 4: School's Impact & Future (Questions 17-21)
('section4', 'How will the things you learned in school help you achieve your dreams and aspirations? Explain.', 'textarea', 'Connect your school learning to your future goals. Think about how the knowledge, skills, and experiences you gain at school will contribute to achieving your dreams and career aspirations.', 17),
('section4', 'What is the one thing you would like to change in your school? Give reasons.', 'textarea', 'Think about improvements you would like to see in your school. Consider changes in facilities, teaching methods, activities, rules, or anything else that would enhance your learning experience.', 18),
('section4', 'Do you have a separate place to practice? Explain why it is necessary.', 'textarea', 'Reflect on your study or practice space. Consider whether you have a dedicated area for learning and why having a separate practice space is important for your academic success.', 19),
('section4', 'Does school play an important role in your life''s learning process? Write your opinion.', 'textarea', 'Consider the overall value and importance of school in your educational journey. Think about how school contributes to your personal and academic development.', 20),
('section4', 'Do you like talking to your parents about school activities and your learnings? What topics do you discuss with them?', 'textarea', 'Reflect on your communication with parents about school. Consider what aspects of school you share with them and how these conversations help or influence your learning.', 21);

-- Insert checkbox options for Question 11 (Learning Methodologies)
INSERT INTO school_learning_options (question_id, option_text, option_value, sequence_number)
SELECT q.id, o.option_text, o.option_value, o.sequence_number
FROM school_learning_questions q
CROSS JOIN (VALUES
    ('Watching videos or relating to pictures (visual)', 'lookingAtPictures', 1),
    ('Reading', 'reading', 2),
    ('Listening (audio)', 'listening', 3),
    ('Experimenting', 'experiment', 4),
    ('Discuss / Brainstorming', 'discussions', 5),
    ('Group discussions', 'groupSessions', 6),
    ('Writing', 'practice', 7),
    ('Reading & byheart', 'readingByheart', 8),
    ('I learn by teaching others, or I like someone to listen to me', 'teachingOthers', 9),
    ('I learn better when - (any other method you apply)', 'others', 10)
) AS o(option_text, option_value, sequence_number)
WHERE q.section = 'section2' AND q.sequence_number = 11;

-- Update the function to return questions in proper order
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
    ORDER BY 
        CASE s.section
            WHEN 'section1' THEN 1
            WHEN 'section2' THEN 2
            WHEN 'section3' THEN 3
            WHEN 'section4' THEN 4
            WHEN 'part1' THEN 1
            WHEN 'part2' THEN 2
            WHEN 'part3' THEN 3
            ELSE 99
        END,
        s.sequence_number;
END $$;

-- Verify data insertion
DO $$
DECLARE
    school_learning_q_count INTEGER;
    section1_count INTEGER;
    section2_count INTEGER;
    section3_count INTEGER;
    section4_count INTEGER;
    options_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO school_learning_q_count FROM school_learning_questions;
    SELECT COUNT(*) INTO section1_count FROM school_learning_questions WHERE section = 'section1';
    SELECT COUNT(*) INTO section2_count FROM school_learning_questions WHERE section = 'section2';
    SELECT COUNT(*) INTO section3_count FROM school_learning_questions WHERE section = 'section3';
    SELECT COUNT(*) INTO section4_count FROM school_learning_questions WHERE section = 'section4';
    SELECT COUNT(*) INTO options_count FROM school_learning_options;
    
    RAISE NOTICE 'School Learning Questions Update Complete:';
    RAISE NOTICE 'Total School Learning Questions: %', school_learning_q_count;
    RAISE NOTICE 'Section 1 Questions: %', section1_count;
    RAISE NOTICE 'Section 2 Questions: %', section2_count;
    RAISE NOTICE 'Section 3 Questions: %', section3_count;
    RAISE NOTICE 'Section 4 Questions: %', section4_count;
    RAISE NOTICE 'Checkbox Options: %', options_count;
    
    IF school_learning_q_count = 21 THEN
        RAISE NOTICE '✅ All 21 School Learning questions inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 21 questions, but found %', school_learning_q_count;
    END IF;
    
    IF section1_count = 5 AND section2_count = 7 AND section3_count = 4 AND section4_count = 5 THEN
        RAISE NOTICE '✅ Questions properly distributed across 4 sections!';
    ELSE
        RAISE NOTICE '⚠️ Section distribution: Section 1: %, Section 2: %, Section 3: %, Section 4: %', 
            section1_count, section2_count, section3_count, section4_count;
    END IF;
    
    IF options_count = 10 THEN
        RAISE NOTICE '✅ All 10 checkbox options inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 10 options, but found %', options_count;
    END IF;
END $$;

