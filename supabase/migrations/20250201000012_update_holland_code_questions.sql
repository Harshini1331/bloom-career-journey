-- Migration: Update Holland Code Assessment Questions
-- This migration replaces existing Holland Code questions with all 42 questions from the worksheet
-- Questions are mapped to categories based on the scoreboard: R (1,7,13,19,25,31,37), I (2,8,14,20,26,32,38), 
-- A (3,9,15,21,27,33,39), S (4,10,16,22,28,34,40), E (5,11,17,23,29,35,41), C (6,12,18,24,30,36,42)

-- Clear existing Holland Code questions
DELETE FROM holland_code_questions;

-- Insert all 42 questions with proper category mapping based on scoreboard
-- Scoreboard mapping: R(1,7,13,19,25,31,37), I(2,8,14,20,26,32,38), A(3,9,15,21,27,33,39),
-- S(4,10,16,22,28,34,40), E(5,11,17,23,29,35,41), C(6,12,18,24,30,36,42)
INSERT INTO holland_code_questions (category, question_text, sequence_number) VALUES

-- Question 1 - Realistic
('R', 'I like to fix appliances, bikes, cycles, broken toys, etc.', 1),

-- Question 2 - Investigative
('I', 'I like to solve puzzles, riddles, and find answers to interesting questions.', 2),

-- Question 3 - Artistic
('A', 'I prefer to work alone instead of in a group or a team.', 3),

-- Question 4 - Social
('S', 'I prefer working with others in a group or team instead of working alone.', 4),

-- Question 5 - Enterprising
('E', 'I am an ambitious person, I set goals for myself.', 5),

-- Question 6 - Conventional
('C', 'I like to organize things - my bag, my home, my books, play materials, my clothes, etc.', 6),

-- Question 7 - Realistic
('R', 'I like to build things, like models for school projects, my own play materials, household items, etc.', 7),

-- Question 8 - Investigative
('I', 'I like to read about art and music.', 8),

-- Question 9 - Artistic
('A', 'I like to try to influence or persuade people (reason out or convince).', 9),

-- Question 10 - Social
('S', 'I like to do experiments, hands-on activities and see things in action.', 10),

-- Question 11 - Enterprising
('E', 'I like to teach and I help my friends, siblings or kids in my neighborhood regularly and show them how to do things.', 11),

-- Question 12 - Conventional
('C', 'I like to be given clear instructions on what I have to do. If not I get confused when some work is given to me without clear instructions.', 12),

-- Question 13 - Realistic
('R', 'I like to take care of animals and I take care of cows, goats, dogs etc. in my house.', 13),

-- Question 14 - Investigative
('I', 'I like to study/prepare for my lessons for long hours in my house.', 14),

-- Question 15 - Artistic
('A', 'I enjoy creative writing stories, poetry, play etc.', 15),

-- Question 16 - Social
('S', 'I like selling things. I like interacting with people and helping them buy things they want.', 16),

-- Question 17 - Enterprising
('E', 'I like to help people solve their problems in any way I can.', 17),

-- Question 18 - Conventional
('C', 'I always volunteer at home and school for any new responsibilities.', 18),

-- Question 19 - Realistic
('R', 'I am a practical person (I don''t take things too emotionally. don''t waste time over past and focus on things that are in my control)', 19),

-- Question 20 - Investigative
('I', 'I enjoy science.', 20),

-- Question 21 - Artistic
('A', 'I enjoy doing experiments, opening devices, reading, asking people to understand how things work.', 21),

-- Question 22 - Social
('S', 'I like putting things together or assembling things.', 22),

-- Question 23 - Enterprising
('E', 'I am a creative person - have a keen interest in music or dance or writing or design of any kind- clothes, houses. furniture. I like to write my own stories.', 23),

-- Question 24 - Conventional
('C', 'I give attention to doing things well so when I write I don''t make spelling mistakes. I don''t make simple errors in Math when I am adding or subtracting', 24),

-- Question 25 - Realistic
('R', 'I like to do filing or typing', 25),

-- Question 26 - Investigative
('I', 'I like to analyze and solve problems both academic or otherwise', 26),

-- Question 27 - Artistic
('A', 'I like to play musical instruments or sing', 27),

-- Question 28 - Social
('S', 'Some of my favourite chapters in my textbooks have been about learning about our past, different cultures of various kingdoms and countries, and how different people live in different places.', 28),

-- Question 29 - Enterprising
('E', 'I would like to start my own business', 29),

-- Question 30 - Conventional
('C', 'I am interested in healing people.', 30),

-- Question 31 - Realistic
('R', 'I like to spend my time outdoors rather than inside my house.', 31),

-- Question 32 - Investigative
('I', 'I like numbers, data charts and statistics.', 32),

-- Question 33 - Artistic
('A', 'I like acting in plays', 33),

-- Question 34 - Social
('S', 'I like to debate and discuss about many topics', 34),

-- Question 35 - Enterprising
('E', 'I like to lead in any activity, at school or anywhere', 35),

-- Question 36 - Conventional
('C', 'I like to write down the list of things or tasks I need to do. every day.', 36),

-- Question 37 - Realistic
('R', 'I like to cook', 37),

-- Question 38 - Investigative
('I', 'I like to spend time indoors rather than outside.', 38),

-- Question 39 - Artistic
('A', 'I like to draw', 39),

-- Question 40 - Social
('S', 'I like helping people', 40),

-- Question 41 - Enterprising
('E', 'I like to give speeches, host events or participate in debate/elocution competitions', 41),

-- Question 42 - Conventional
('C', 'I enjoy Math', 42);

-- Verify data insertion
DO $$
DECLARE
    holland_q_count INTEGER;
    r_count INTEGER;
    i_count INTEGER;
    a_count INTEGER;
    s_count INTEGER;
    e_count INTEGER;
    c_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO holland_q_count FROM holland_code_questions;
    SELECT COUNT(*) INTO r_count FROM holland_code_questions WHERE category = 'R';
    SELECT COUNT(*) INTO i_count FROM holland_code_questions WHERE category = 'I';
    SELECT COUNT(*) INTO a_count FROM holland_code_questions WHERE category = 'A';
    SELECT COUNT(*) INTO s_count FROM holland_code_questions WHERE category = 'S';
    SELECT COUNT(*) INTO e_count FROM holland_code_questions WHERE category = 'E';
    SELECT COUNT(*) INTO c_count FROM holland_code_questions WHERE category = 'C';
    
    RAISE NOTICE 'Holland Code Questions Update Complete:';
    RAISE NOTICE 'Total Questions: %', holland_q_count;
    RAISE NOTICE 'R: %, I: %, A: %, S: %, E: %, C: %', r_count, i_count, a_count, s_count, e_count, c_count;
    
    IF holland_q_count = 42 THEN
        RAISE NOTICE '✅ All 42 questions inserted successfully!';
    ELSE
        RAISE WARNING '⚠️ Expected 42 questions, found %', holland_q_count;
    END IF;
END $$;

