-- Migration: Add Hobbies (Talents and Hobbies) AI Summary Template
-- This migration adds the AI summary template for "My Talents and Hobbies" assessment
-- The summary consists of two portfolio tables: Hobbies Portfolio and Talents Portfolio

-- Insert Hobbies summary template into assessment_summary_templates
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('hobbies', 'Summary: My Talents and Hobbies', 
 '{
   "en": {
     "question1": "Hobbies Portfolio (stored as JSON array)",
     "question2": "Hobbies",
     "question3": "I would like to turn this hobby into a career",
     "question4": "Careers that are compatible with these hobbies",
     "question5": "People you know who have turned their hobbies into careers",
     "question6": "Talents Portfolio (stored as JSON array)",
     "question7": "Talents",
     "question8": "Do you want to turn your talent into a career?",
     "question9": "Careers that match your talents",
     "question10": "People you know who have turned their talents into careers"
   },
   "kn": {
     "question1": "ಹವ್ಯಾಸಗಳ ಪೋರ್ಟ್ಫೋಲಿಯೋ (JSON ಶ್ರೇಣಿಯಾಗಿ ಸಂಗ್ರಹಿಸಲಾಗಿದೆ)",
     "question2": "ಹವ್ಯಾಸಗಳು",
     "question3": "ನಾನು ಈ ಹವ್ಯಾಸವನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಲು ಬಯಸುತ್ತೇನೆ",
     "question4": "ಈ ಹವ್ಯಾಸಗಳೊಂದಿಗೆ ಹೊಂದಿಕೊಳ್ಳುವ ವೃತ್ತಿಗಳು",
     "question5": "ತಮ್ಮ ಹವ್ಯಾಸಗಳನ್ನು ವೃತ್ತಿಗಳಾಗಿ ಮಾಡಿದ ನಿಮಗೆ ತಿಳಿದಿರುವ ಜನರು",
     "question6": "ಪ್ರತಿಭೆಗಳ ಪೋರ್ಟ್ಫೋಲಿಯೋ (JSON ಶ್ರೇಣಿಯಾಗಿ ಸಂಗ್ರಹಿಸಲಾಗಿದೆ)",
     "question7": "ಪ್ರತಿಭೆಗಳು",
     "question8": "ನಿಮ್ಮ ಪ್ರತಿಭೆಯನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಲು ನೀವು ಬಯಸುತ್ತೀರಾ?",
     "question9": "ನಿಮ್ಮ ಪ್ರತಿಭೆಗಳೊಂದಿಗೆ ಹೊಂದಿಕೊಳ್ಳುವ ವೃತ್ತಿಗಳು",
     "question10": "ತಮ್ಮ ಪ್ರತಿಭೆಗಳನ್ನು ವೃತ್ತಿಗಳಾಗಿ ಮಾಡಿದ ನಿಮಗೆ ತಿಳಿದಿರುವ ಜನರು"
   }
 }'::jsonb)
ON CONFLICT (assessment_type) 
DO UPDATE SET
    title = EXCLUDED.title,
    summary_questions = EXCLUDED.summary_questions,
    updated_at = NOW();

-- Verify insertion
DO $$
DECLARE
    template_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO template_count 
    FROM assessment_summary_templates 
    WHERE assessment_type = 'hobbies';
    
    RAISE NOTICE 'Hobbies Summary Template: %', 
        CASE WHEN template_count > 0 THEN 'Created' ELSE 'Not Found' END;
END $$;

