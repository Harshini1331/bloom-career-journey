-- Migration: Complete About Me Assessment Structure
-- This migration creates the proper database structure for the About Me Assessment

-- Clear existing About Me questions
DELETE FROM about_me_questions;

-- Insert the complete About Me Assessment questions
INSERT INTO about_me_questions (question_text, help_text, sequence_number) VALUES

-- A. Your Profile
('With which family member are you able to share your opinions and feelings freely without fear or reserve?', 'Write the name or relation of the person (mother, father, sister, etc.) with whom you feel most comfortable sharing your thoughts.', 1),
('Other than your family members, with whom are you able to share your opinions and feelings freely without fear or reserve?', 'Mention a friend, teacher, or another person you trust and can talk to openly.', 2),
('What work do you do at home? (eg: help in farming activities, buying vegetables, taking care of cattle, filling water, etc.)', 'Write about the kind of work or help you give at home every day or sometimes.', 3),

-- B. What is your favourite work?
('The job that you do well and are happy to do - at school', 'Write about a school activity or subject you are good at and enjoy doing.', 4),
('The job that you do well and are happy to do - after school', 'Write about something you do at home or outside school that you do well and like doing.', 5),
('The activities that you like to do on your own (Practically doing it alone)', 'Write about things you like doing alone — for example reading, drawing, singing, or gardening.', 6),
('The tasks that you like to do with your friends', 'Mention the fun or helpful activities you enjoy doing with your friends.', 7),

-- C. The job that you find difficult to carry out
('At school', 'Write about something at school that feels hard for you to do.', 8),
('After school', 'Mention a task outside school that you find difficult.', 9),
('The jobs that you don''t like to do but have to do', 'Write about tasks you don''t enjoy but still do because they are needed.', 10),
('The jobs that don''t come naturally to you', 'Write about tasks that you struggle with or take time to learn.', 11),

-- D. Answer the below questions to share more information about yourself
('The things that you like about yourself (Answer 1)', 'Write about your good habits, strengths, or anything that makes you proud of yourself.', 12),
('The things that you like about yourself (Answer 2)', 'Write about your good habits, strengths, or anything that makes you proud of yourself.', 13),
('The things that you like about yourself (Answer 3)', 'Write about your good habits, strengths, or anything that makes you proud of yourself.', 14),
('What do others like about you? (Answer 1)', 'Write what others appreciate about you — kindness, helpfulness, honesty, etc.', 15),
('What do others like about you? (Answer 2)', 'Write what others appreciate about you — kindness, helpfulness, honesty, etc.', 16),
('What do others like about you? (Answer 3)', 'Write what others appreciate about you — kindness, helpfulness, honesty, etc.', 17),
('Things for which you were praised (Answer 1)', 'Mention any time you were appreciated or got good comments — at home, school, or anywhere.', 18),
('Things for which you were praised (Answer 2)', 'Mention any time you were appreciated or got good comments — at home, school, or anywhere.', 19),
('Things for which you were praised (Answer 3)', 'Mention any time you were appreciated or got good comments — at home, school, or anywhere.', 20),
('What would you like to change in yourself (Answer 1)', 'Write about something you want to improve or learn to do better.', 21),
('What would you like to change in yourself (Answer 2)', 'Write about something you want to improve or learn to do better.', 22),
('If you had the chance to be like somebody or be someone, who would you aspire to be or what would you aspire to do?', 'Write the name of a person you admire or the kind of work/life you wish to have.', 23),
('Write about yourself in brief', 'Write a few lines about who you are — your likes, hobbies, family, or dreams.', 24);

-- Verify data insertion
DO $$
DECLARE
    about_me_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO about_me_count FROM about_me_questions;
    
    RAISE NOTICE 'About Me Questions Population Complete:';
    RAISE NOTICE 'Total About Me Questions: %', about_me_count;
    
    IF about_me_count = 24 THEN
        RAISE NOTICE '✅ All 24 About Me questions inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Expected 24 questions, but found %', about_me_count;
    END IF;
END $$;
