-- Migration: Populate Assessment Data
-- This migration populates all the assessment tables with data

-- Insert Holland Code Questions
INSERT INTO holland_code_questions (category, question_text, sequence_number) VALUES
-- Realistic (R)
('R', 'I like to fix a car', 1),
('R', 'I like to build things', 2),
('R', 'I like to take care of animals', 3),
('R', 'I like working outdoors', 4),
('R', 'I like to play a sport', 5),
('R', 'I like to paint a room', 6),
('R', 'I like to cook', 7),

-- Investigative (I)
('I', 'I like to do experiments', 1),
('I', 'I like to figure out how things work', 2),
('I', 'I am good with numbers and charts', 3),
('I', 'I enjoy science', 4),
('I', 'I like to do puzzles', 5),
('I', 'I like to analyze things (problems/solutions)', 6),
('I', 'I like to evaluate a crime scene', 7),

-- Artistic (A)
('A', 'I like acting in a play', 1),
('A', 'I like to sing or play an instrument', 2),
('A', 'I like to draw', 3),
('A', 'I like to design stage sets', 4),
('A', 'I like to take photographs', 5),
('A', 'I enjoy creative writing', 6),
('A', 'I like to read about art and music', 7),

-- Social (S)
('S', 'I like to get into discussions about issues', 1),
('S', 'I like trying to help people solve their problems', 2),
('S', 'I like helping people', 3),
('S', 'I like to teach or train people', 4),
('S', 'I like to meet new people', 5),
('S', 'I like to volunteer for a charity', 6),
('S', 'I like to work in teams', 7),

-- Enterprising (E)
('E', 'I like selling things', 1),
('E', 'I like to start a club', 2),
('E', 'I like to take charge', 3),
('E', 'I like to manage money', 4),
('E', 'I like to lead', 5),
('E', 'I would like to start my own business', 6),
('E', 'I like to give speeches', 7),

-- Conventional (C)
('C', 'I follow a recipe', 1),
('C', 'I like to organize things (files, desks/offices)', 2),
('C', 'I like to create a budget', 3),
('C', 'I like to follow instructions', 4),
('C', 'I like to be a bank teller', 5),
('C', 'I would like to work in an office', 6),
('C', 'I am good at keeping records of my work', 7);

-- Insert Inspiration Questions
INSERT INTO inspiration_questions (question_text, help_text, sequence_number) VALUES
('Write about the moments or messages you enjoyed or that made you feel motivated.', 'Write about the moments or messages you enjoyed or that made you feel motivated.', 1),
('Mention the main lessons or ideas you got from watching or listening.', 'Mention the main lessons or ideas you got from watching or listening.', 2),
('Say what actions, habits, or thoughts from the video you want to try in your own life.', 'Say what actions, habits, or thoughts from the video you want to try in your own life.', 3),
('Write how this video might change the way you think, feel, or behave.', 'Write how this video might change the way you think, feel, or behave.', 4),
('Write about the good qualities or values in the characters that you also have.', 'Write about the good qualities or values in the characters that you also have.', 5),
('Describe what you would do or feel if you were in the same situation.', 'Describe what you would do or feel if you were in the same situation.', 6),
('Write about the part of the video/audio that motivated or inspired you the most.', 'Write about the part of the video/audio that motivated or inspired you the most.', 7);

-- Insert Inspiration Videos
INSERT INTO inspiration_videos (title, url, youtube_id, description, sequence_number) VALUES
('Inspirational Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'U7-HlfpvQIA', 'First inspirational content for self-reflection', 1),
('Inspirational Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'xqb1hfgfcl8', 'Second inspirational content for self-reflection', 2),
('Inspirational Video 3', 'https://youtu.be/z3PYJ9MfMH4', 'z3PYJ9MfMH4', 'Third inspirational content for self-reflection', 3),
('Inspirational Video 4', 'https://youtu.be/X9wViEY5tPQ?si=qDOuMSUatButKwZk', 'X9wViEY5tPQ', 'Fourth inspirational content for self-reflection', 4),
('Inspirational Video 5', 'https://youtu.be/PP-kmxMY1ts', 'PP-kmxMY1ts', 'Fifth inspirational content for self-reflection', 5),
('Inspirational Video 6', 'https://youtu.be/GPeeZ6viNgY?si=sg4hFF33p3cF4X25', 'GPeeZ6viNgY', 'Sixth inspirational content for self-reflection', 6);

-- Insert Dreams Questions
INSERT INTO dreams_questions (section, question_text, help_text, sequence_number) VALUES
-- Part 1
('part1', 'What are your future dreams?', 'Think about what you want to achieve in life', 1),
('part1', 'What educational degree would you like to pursue?', 'Consider your educational goals', 2),
('part1', 'What career would you like to have?', 'Think about your ideal profession', 3),
('part1', 'Would you like to play any professional sport?', 'Consider sports and physical activities', 4),
('part1', 'Would you like to write books, articles, or stories?', 'Think about writing and creative expression', 5),
('part1', 'Would you like to learn to play any musical instrument?', 'Consider music and artistic pursuits', 6),
('part1', 'Which college would you like to go to?', 'Think about higher education', 7),
('part1', 'Would you like to help others in any way?', 'Consider how you want to contribute to society', 8),
('part1', 'Where would you like to live?', 'Think about your ideal living situation', 9),
('part1', 'Would you like to do any form of art?', 'Consider artistic and creative activities', 10),
('part1', 'Do you have any other dreams?', 'Share any other aspirations you have', 11),
('part1', 'Do you want to make your dreams come true?', 'Reflect on your commitment to your dreams', 12),

-- Part 2
('part2', 'What do you think you need to achieve your dreams?', 'Think about the resources and support you need', 1),
('part2', 'What is the first step you would take to achieve your dreams?', 'Consider the immediate actions you can take', 2),
('part2', 'Do you have the willpower and enthusiasm to achieve your dreams?', 'Reflect on your motivation and determination', 3),
('part2', 'What obstacles do you think you might face?', 'Consider potential challenges and how to overcome them', 4);

-- Insert School Learning Questions
INSERT INTO school_learning_questions (section, question_text, question_type, help_text, sequence_number) VALUES
-- Part 1
('part1', 'Do you like to come to school?', 'textarea', 'Reflect on your feelings about school', 1),
('part1', 'Why do you like to come to school?', 'textarea', 'Think about what makes school enjoyable for you', 2),
('part1', 'Why don''t you like coming to school?', 'textarea', 'Consider what challenges you face at school', 3),
('part1', 'Who is your best friend at school?', 'textarea', 'Think about your social connections at school', 4),
('part1', 'Which is your favourite subject/topic?', 'textarea', 'Identify subjects you enjoy most', 5),
('part1', 'Why do you like these topics?', 'textarea', 'Reflect on what makes these subjects interesting', 6),
('part1', 'Which subject/s do you not like?', 'textarea', 'Consider subjects that are challenging for you', 7),

-- Part 2
('part2', 'Why do you not like these subjects?', 'textarea', 'Think about what makes these subjects difficult', 1),
('part2', 'In which subject/s do you score more marks?', 'textarea', 'Identify your academic strengths', 2),
('part2', 'In which subject/s do you score less marks?', 'textarea', 'Consider areas where you need improvement', 3),
('part2', 'How do you like to learn?', 'checkbox', 'Select all learning methods that work for you', 4),
('part2', 'Apart from school curriculum, what attracts you to school?', 'textarea', 'Think about extracurricular activities and social aspects', 5),

-- Part 3
('part3', 'What school activities would you like to participate in?', 'textarea', 'Think about clubs, sports, and other activities', 1),
('part3', 'What would you want to change about your school?', 'textarea', 'Consider improvements you would like to see', 2),
('part3', 'What is your favourite place to study and why?', 'textarea', 'Reflect on your ideal study environment', 3),
('part3', 'Is school important for your learning?', 'textarea', 'Think about the value of school in your education', 4),
('part3', 'How can schooling help you realise your dreams?', 'textarea', 'Connect your school experience to your future goals', 5);

-- Insert School Learning Options
INSERT INTO school_learning_options (question_id, option_text, option_value, sequence_number)
SELECT q.id, o.option_text, o.option_value, o.sequence_number
FROM school_learning_questions q
CROSS JOIN (VALUES
    ('Looking at pictures', 'lookingAtPictures', 1),
    ('Reading', 'reading', 2),
    ('Listening', 'listening', 3),
    ('Doing experiments', 'experiment', 4),
    ('Discussions', 'discussions', 5),
    ('Practice', 'practice', 6),
    ('Group sessions', 'groupSessions', 7),
    ('Others', 'others', 8)
) AS o(option_text, option_value, sequence_number)
WHERE q.question_text = 'How do you like to learn?';

-- Insert Role Models Questions
INSERT INTO role_models_questions (question_text, help_text, sequence_number) VALUES
('Name of the person', 'Enter the person''s name', 1),
('Relationship to you', 'e.g., Teacher, Parent, Friend', 2),
('What qualities do you admire in this person?', 'Describe the qualities you admire', 3),
('How has this person influenced you?', 'Describe their influence on you', 4),
('How do you plan to incorporate their qualities into your life?', 'Describe your plan to incorporate their qualities', 5);

-- Insert Hobbies Questions
INSERT INTO hobbies_questions (question_text, help_text, sequence_number) VALUES
('Name of the hobby/activity', 'e.g., Playing guitar, Reading, Painting', 1),
('How much time do you spend on this hobby?', 'e.g., 2 hours daily, 5 hours weekly', 2),
('Describe this hobby/activity', 'Describe what you do in this hobby', 3),
('What do you enjoy most about this hobby?', 'What makes this hobby enjoyable for you', 4),
('What skills have you developed through this hobby?', 'What skills or abilities have you gained', 5);

-- Insert About Me Questions
INSERT INTO about_me_questions (question_text, help_text, sequence_number) VALUES
('Tell us about yourself', 'Share your thoughts and experiences', 1),
('What are your strengths?', 'Think about what you do well', 2),
('What are your interests?', 'Share what you enjoy doing', 3),
('What are your goals?', 'Think about what you want to achieve', 4),
('What challenges do you face?', 'Share any difficulties you encounter', 5);
