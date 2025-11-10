-- Migration: Add Role Models AI Summary Template
-- This migration adds the AI summary template for "My Role Models" assessment

-- Insert Role Models summary template into assessment_summary_templates
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('role_models', 'Summary: My Role Models', 
 '{
   "en": {
     "question1": "Write down 5 to 10 questions you would like to ask your role models about career guidance."
   },
   "kn": {
     "question1": "ನಿಮ್ಮ ಪಾತ್ರ ಮಾದರಿಗಳಿಂದ ವೃತ್ತಿ ಮಾರ್ಗದರ್ಶನದ ಕುರಿತಾಗಿ ನೀವು ಕೇಳಲು ಬಯಸುವ 5 ರಿಂದ 10 ಪ್ರಶ್ನೆಗಳನ್ನು ಬರೆಯಿರಿ."
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
    WHERE assessment_type = 'role_models';
    
    RAISE NOTICE 'Role Models Summary Template: %', 
        CASE WHEN template_count > 0 THEN 'Created' ELSE 'Not Found' END;
END $$;

