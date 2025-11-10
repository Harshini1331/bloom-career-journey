-- Migration: Add My Next Project AI Summary Template
-- This migration adds the AI summary template for "My Next Project" assessment

-- Insert My Next Project summary template into assessment_summary_templates
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('my_next_project', 'Summary: My Next Project', 
 '{
   "en": {
     "question1": "Write a brief description of yourself based on the summary.",
     "question2": "Based on the summary of \"My Motivation\" and the activities in \"About Me,\" identify the qualities, interests, strengths, and areas for improvement that would help you in each of your career interests. This will help you align better with your career choice.",
     "question3": ""
   },
   "kn": {
     "question1": "ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ ನಿಮ್ಮ ಬಗ್ಗೆ ಸಂಕ್ಷಿಪ್ತ ವಿವರಣೆಯನ್ನು ಬರೆಯಿರಿ.",
     "question2": "\"ನನ್ನ ಪ್ರೇರಣೆ\" ಮತ್ತು \"ನನ್ನ ಬಗ್ಗೆ\" ನಲ್ಲಿನ ಚಟುವಟಿಕೆಗಳ ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ, ನಿಮ್ಮ ಪ್ರತಿಯೊಂದು ವೃತ್ತಿ ಆಸಕ್ತಿಗಳಲ್ಲಿ ನಿಮಗೆ ಸಹಾಯ ಮಾಡಬಹುದಾದ ಗುಣಗಳು, ಆಸಕ್ತಿಗಳು, ಶಕ್ತಿಗಳು ಮತ್ತು ಸುಧಾರಣೆಯ ಪ್ರದೇಶಗಳನ್ನು ಗುರುತಿಸಿ. ಇದು ನಿಮ್ಮ ವೃತ್ತಿ ಆಯ್ಕೆಯೊಂದಿಗೆ ನೀವು ಉತ್ತಮವಾಗಿ ಸಮಂಜಸವಾಗಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.",
     "question3": ""
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
    WHERE assessment_type = 'my_next_project';
    
    RAISE NOTICE 'My Next Project Summary Template: %', 
        CASE WHEN template_count > 0 THEN 'Created' ELSE 'Not Found' END;
END $$;

