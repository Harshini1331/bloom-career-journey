-- Migration: Add Dreams Assessment Summary Template
-- This migration adds the AI summary template for the "My Dreams" assessment to the database

-- Insert Dreams summary template into assessment_summary_templates
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('dreams', 'Summary: My Dream Portfolio', 
 '{
   "en": {
     "question1": "Dream",
     "question2": "Which quality, value, strength will help you achieve your dream",
     "question3": "What you will have to do to ensure that the dream doesn''t fail",
     "question4": "What should you study after 10th to achieve this dream (if applicable)"
   },
   "kn": {
     "question1": "ಕನಸು",
     "question2": "ನಿಮ್ಮ ಕನಸನ್ನು ಸಾಧಿಸಲು ನಿಮಗೆ ಸಹಾಯ ಮಾಡುವ ಯಾವ ಗುಣ, ಮೌಲ್ಯ, ಶಕ್ತಿ",
     "question3": "ಕನಸು ವಿಫಲವಾಗದಂತೆ ಮಾಡಲು ನೀವು ಏನು ಮಾಡಬೇಕು",
     "question4": "ಈ ಕನಸನ್ನು ಸಾಧಿಸಲು ನೀವು 10 ನೇ ತರಗತಿಯ ನಂತರ ಏನು ಅಧ್ಯಯನ ಮಾಡಬೇಕು (ಬೇಕಿದ್ದರೆ)"
   }
 }'::jsonb)
ON CONFLICT (assessment_type) 
DO UPDATE SET
    title = EXCLUDED.title,
    summary_questions = EXCLUDED.summary_questions,
    updated_at = NOW();

-- Verify data insertion
DO $$
DECLARE
    dreams_template_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO dreams_template_count FROM assessment_summary_templates WHERE assessment_type = 'dreams';
    
    IF dreams_template_count = 1 THEN
        RAISE NOTICE '✅ Dreams summary template inserted successfully!';
    ELSE
        RAISE NOTICE '⚠️ Dreams summary template count: %', dreams_template_count;
    END IF;
END $$;

