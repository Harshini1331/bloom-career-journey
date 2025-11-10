-- Migration: Update Inspiration Assessment Questions
-- This migration replaces the existing 7 inspiration questions with 9 new questions and their help text

-- Delete existing inspiration questions
DELETE FROM inspiration_questions;

-- Insert new Inspiration Questions with help text
INSERT INTO inspiration_questions (question_text, help_text, sequence_number) VALUES
('What aspects of the video/audio that you liked the most or found most inspiring?', 'Think about specific moments, messages, or themes that resonated with you and made you feel inspired.', 1),
('What qualities and values can you learn from this video/audio?', 'Identify the positive qualities, values, or principles demonstrated in the content that you can learn from.', 2),
('What specific qualities or values would you like to incorporate into your own life?', 'Consider which qualities or values from the video/audio you want to develop or practice in your daily life.', 3),
('Can you outline the key parameters or aspects from these videos/audios that have the potential to bring positive changes to your life?', 'Reflect on specific elements, strategies, or insights from the content that could help you grow, improve, or make positive changes.', 4),
('Did you identify with any characters in the videos/audios? If so, which character resonated with you, and what was the reason behind your connection?', 'Think about characters you relate to, why you connected with them, and what similarities you share with them.', 5),
('Have you ever demonstrated any of the values you admire in real life? Describe the situation briefly', 'Share a real-life example or experience where you showed similar values, qualities, or behaviors that you admire from the content.', 6),
('If you were to step into the shoes of a character from these videos/audios, how do you imagine you would respond to the situation presented?', 'Imagine how you would handle similar situations based on what you learned from the video/audio, and what actions you would take.', 7),
('Can you recall a specific person or situation from your real-life experiences that was as inspiring as the characters you''ve encountered in these videos/audios?', 'Think about people, experiences, or moments in your own life that have been similarly motivating or inspiring, and describe what made them meaningful.', 8),
('Is there any additional insight you''d like to share regarding these media clippings?', 'Share any other thoughts, reflections, observations, or personal connections you have regarding the videos or audio content.', 9);

-- Create assessment_summary_templates table if it doesn't exist
CREATE TABLE IF NOT EXISTS assessment_summary_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_type assessment_type NOT NULL UNIQUE,
    title TEXT NOT NULL,
    summary_questions JSONB NOT NULL,
    -- Structure: { 
    --   "en": { "question1": "...", "question2": "...", "question3": "..." },
    --   "kn": { "question1": "...", "question2": "...", "question3": "..." }
    -- }
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_assessment_summary_templates_type ON assessment_summary_templates(assessment_type);
CREATE INDEX IF NOT EXISTS idx_assessment_summary_templates_active ON assessment_summary_templates(is_active);

-- Insert or update inspiration assessment summary template
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('inspiration', 'Summary: Things I was Inspired By', 
 '{
   "en": {
     "question1": "List the things that inspired you from these videos and from your own experiences.",
     "question2": "After watching all these videos, which behaviors do you feel you should avoid? Write them down.",
     "question3": "Discuss the similarities between the characters in these videos who inspired you, and the people who have inspired you in real life, with your friends. Then write a summary."
   },
   "kn": {
     "question1": "ಈ ವೀಡಿಯೊಗಳಿಂದ ಮತ್ತು ನಿಮ್ಮ ಸ್ವಂತ ಅನುಭವಗಳಿಂದ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ವಿಷಯಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.",
     "question2": "ಈ ಎಲ್ಲಾ ವೀಡಿಯೊಗಳನ್ನು ನೋಡಿದ ನಂತರ, ನೀವು ತಪ್ಪಿಸಬೇಕಾದ ನಡವಳಿಕೆಗಳು ಯಾವುವು? ಅವುಗಳನ್ನು ಬರೆಯಿರಿ.",
     "question3": "ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಈ ವೀಡಿಯೊಗಳಲ್ಲಿನ ಪಾತ್ರಗಳು ಮತ್ತು ನಿಜ ಜೀವನದಲ್ಲಿ ನಿಮ್ಮನ್ನು ಪ್ರೇರೇಪಿಸಿದ ಜನರ ನಡುವಿನ ಹೋಲಿಕೆಗಳನ್ನು ನಿಮ್ಮ ಸ್ನೇಹಿತರೊಂದಿಗೆ ಚರ್ಚಿಸಿ. ನಂತರ ಒಂದು ಸಾರಾಂಶ ಬರೆಯಿರಿ."
   }
 }'::jsonb)
ON CONFLICT (assessment_type) 
DO UPDATE SET
    title = EXCLUDED.title,
    summary_questions = EXCLUDED.summary_questions,
    updated_at = NOW();

-- Function to get summary template for an assessment
CREATE OR REPLACE FUNCTION get_summary_template(
    p_assessment_type assessment_type
)
RETURNS TABLE (
    id UUID,
    assessment_type assessment_type,
    title TEXT,
    summary_questions JSONB
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        st.id,
        st.assessment_type,
        st.title,
        st.summary_questions
    FROM assessment_summary_templates st
    WHERE st.assessment_type = p_assessment_type 
    AND st.is_active = true;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_summary_template(assessment_type) TO authenticated;

-- Verify data insertion
DO $$
DECLARE
    inspiration_q_count INTEGER;
    summary_template_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO inspiration_q_count FROM inspiration_questions;
    SELECT COUNT(*) INTO summary_template_count FROM assessment_summary_templates WHERE assessment_type = 'inspiration';
    RAISE NOTICE 'Inspiration Questions updated: %', inspiration_q_count;
    RAISE NOTICE 'Summary Template created: %', summary_template_count;
END $$;

