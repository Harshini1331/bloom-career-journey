-- Migration: Update Role Models Assessment Questions
-- This migration replaces existing role models questions with 13 new questions with help text

-- Clear existing role models questions
DELETE FROM role_models_questions;

-- Insert new Role Models Questions with help text
INSERT INTO role_models_questions (question_text, help_text, sequence_number) VALUES

-- Question 1: Name
('Name your Role model', 'Enter the full name of your role model. This can be a person you know personally or a well-known figure who inspires you.', 1),

-- Question 2: Relationship
('Are you personally related to this individual? If so, do they belong to your family, relatives, school, a broader community, or are they a familiar acquaintance?', 'Describe your relationship with this person. Indicate if they are family, a relative, someone from school, part of your community, or a familiar acquaintance. If they are a public figure or celebrity you don''t know personally, you can mention that as well.', 2),

-- Question 3: Qualities Admired
('What qualities about your role model do you admire the most? Please list the specific qualities that you appreciate, and also share what makes them special in your eyes.', 'List specific traits such as kindness, resilience, intelligence, leadership, creativity, honesty, compassion, determination, or any other qualities. Explain why these qualities stand out to you and what makes this person unique and special in your eyes. Be detailed and specific about how these qualities have impacted you.', 3),

-- Question 4: Occupation/Profession
('What is their occupation or profession?', 'Describe their job or profession. If they are retired, mention what they used to do. If they are a student or in a different stage of life, describe their current role or career path.', 4),

-- Question 5: Talents/Skills to Develop
('What talents or skills do you aspire to develop based on the abilities demonstrated by your role models?', 'Think about the specific talents, skills, or abilities your role model possesses that you would like to develop in yourself. This could include technical skills, soft skills, personal qualities, or professional capabilities. Be specific about what you want to learn or develop.', 5),

-- Question 6: Career Conversations
('Have you had conversations with any of your role models regarding your career aspirations? If so, what have you discussed?', 'If you have talked to your role model about your career goals or aspirations, describe those conversations. Share what advice, insights, or guidance they provided. If you haven''t had such conversations, you can mention that.', 6),

-- Question 7: Opinion on Dream Career
('If not, have you thought about getting their opinion on your dream career?', 'If you haven''t discussed your career aspirations with them yet, reflect on whether you would like to seek their opinion or advice. Explain why you think their perspective would be valuable, or why you might be hesitant to ask.', 7),

-- Question 8: Perspective on Dream Job
('What is their perspective on your dream job or career aspiration?', 'Share what your role model thinks about your career aspirations. Include their advice, concerns, encouragement, or any feedback they have provided. If you haven''t discussed this with them, you can describe what you imagine their perspective might be based on what you know about them.', 8),

-- Question 9: Possibility of Assistance
('Is there a possibility for any of your role models to assist you in choosing your career aspiration or profession?', 'Consider whether your role model could help guide you in your career choices. Think about their expertise, willingness to help, accessibility, and how their experience could benefit you. Answer yes, no, or maybe, and explain your reasoning.', 9),

-- Question 10: How They Can Help
('If your answer is yes to the above question, how do you think they can help your career choice?', 'If your role model can assist you, describe the specific ways they could help. This might include mentoring, providing information about their field, introducing you to opportunities, sharing their experiences, giving advice, or connecting you with others in the profession. Be concrete and practical about how their assistance could benefit you.', 10),

-- Question 11: Additional Comments
('Anything that you want to mention apart from above questions', 'Share any additional thoughts, stories, experiences, or insights about your role model that you haven''t covered in the previous questions. This is an opportunity to express anything else that is important to you about this person and their influence on your life.', 11),

-- Question 12: Similarities
('Do you notice any similarities between your personality traits and those of your role models?', 'Reflect on whether you see similarities between your personality, values, interests, or behaviors and those of your role model. Identify specific traits, characteristics, or qualities you share. Explain how these similarities make you feel and whether they inspire you to follow a similar path.', 12),

-- Question 13: Incorporate Qualities
('How do you intend to cultivate and incorporate some of the qualities exhibited by your role models into your own life?', 'Describe your specific plan or steps to develop and practice the qualities you admire in your role model. This could include setting goals, seeking mentorship, practicing certain behaviors, studying their approach, or any concrete actions you plan to take. Be detailed and actionable in your response.', 13);

-- Create or replace function to get role models questions
CREATE OR REPLACE FUNCTION get_role_models_questions()
RETURNS TABLE (
    id UUID,
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
        r.id,
        r.question_text,
        r.help_text,
        r.sequence_number
    FROM role_models_questions r
    WHERE r.is_active = true
    ORDER BY r.sequence_number;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_role_models_questions() TO authenticated;

-- Verify data insertion
DO $$
DECLARE
    role_models_q_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO role_models_q_count FROM role_models_questions;
    
    RAISE NOTICE 'Role Models Questions Update Complete:';
    RAISE NOTICE 'Total Questions: %', role_models_q_count;
    
    IF role_models_q_count = 13 THEN
        RAISE NOTICE '✅ All 13 questions inserted successfully!';
    ELSE
        RAISE WARNING '⚠️ Expected 13 questions, found %', role_models_q_count;
    END IF;
END $$;

