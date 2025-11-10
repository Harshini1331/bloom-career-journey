-- Migration: Add About Me AI Summary Template
-- This migration adds the AI summary template for "About Me" assessment

-- Insert About Me summary template into assessment_summary_templates
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('about_me', 'Summary: About Me', 
 '{
   "en": {
     "question1": "Create a comprehensive summary table based on the student''s responses, organizing their answers into these 15 categories: 1) The friend in my family, 2) My friend outside of my family, 3) What activities am I doing at home?, 4) Activities/aspects I Enjoy during the school hours, 5) Activities/aspects I enjoy outside of the school, 6) Work/activities I enjoy personally, 7) Work/activities I enjoy as a team, 8) Activity that needs to be done in the school but I find difficult, 9) Activity that I find difficult to do after school hours, 10) Activities I must do, 11) Activities that come naturally to me, 12) Activities that don''t come naturally to me, 13) Qualities I like in myself, 14) Qualities that others like in me, 15) Qualities that I need to improve on. For each category, provide a concise summary based on the student''s actual responses.",
     "question2": "Write a brief description of yourself based on the summary. (You can use words, pictures or symbols).",
     "question3": "Based on the summary of \"My Motivation\" and the activities in \"About Me,\" identify the qualities, interests, strengths, and areas for improvement that would help you in each of your career interests. This will help you align better with your career choice."
   },
   "kn": {
     "question1": "ವಿದ್ಯಾರ್ಥಿಯ ಪ್ರತಿಕ್ರಿಯೆಗಳ ಆಧಾರದ ಮೇಲೆ ಸಮಗ್ರ ಸಾರಾಂಶ ಕೋಷ್ಟಕವನ್ನು ರಚಿಸಿ, ಅವರ ಉತ್ತರಗಳನ್ನು ಈ 15 ವಿಭಾಗಗಳಲ್ಲಿ ಸಂಘಟಿಸಿ: 1) ನನ್ನ ಕುಟುಂಬದಲ್ಲಿನ ಸ್ನೇಹಿತ, 2) ನನ್ನ ಕುಟುಂಬದ ಹೊರಗಿನ ನನ್ನ ಸ್ನೇಹಿತ, 3) ನಾನು ಮನೆಯಲ್ಲಿ ಯಾವ ಚಟುವಟಿಕೆಗಳನ್ನು ಮಾಡುತ್ತಿದ್ದೇನೆ?, 4) ಶಾಲೆಯ ಸಮಯದಲ್ಲಿ ನಾನು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳು/ಅಂಶಗಳು, 5) ಶಾಲೆಯ ಹೊರಗೆ ನಾನು ಆನಂದಿಸುವ ಚಟುವಟಿಕೆಗಳು/ಅಂಶಗಳು, 6) ನಾನು ವೈಯಕ್ತಿಕವಾಗಿ ಆನಂದಿಸುವ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳು, 7) ನಾನು ತಂಡವಾಗಿ ಆನಂದಿಸುವ ಕೆಲಸ/ಚಟುವಟಿಕೆಗಳು, 8) ಶಾಲೆಯಲ್ಲಿ ಮಾಡಬೇಕಾದ ಆದರೆ ನನಗೆ ಕಷ್ಟಕರವಾದ ಚಟುವಟಿಕೆ, 9) ಶಾಲೆಯ ನಂತರ ನನಗೆ ಮಾಡಲು ಕಷ್ಟಕರವಾದ ಚಟುವಟಿಕೆ, 10) ನಾನು ಮಾಡಬೇಕಾದ ಚಟುವಟಿಕೆಗಳು, 11) ನನಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರುವ ಚಟುವಟಿಕೆಗಳು, 12) ನನಗೆ ಸ್ವಾಭಾವಿಕವಾಗಿ ಬರದ ಚಟುವಟಿಕೆಗಳು, 13) ನನ್ನಲ್ಲಿ ನನಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳು, 14) ಇತರರಲ್ಲಿ ನನಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳು, 15) ನಾನು ಸುಧಾರಿಸಬೇಕಾದ ಗುಣಗಳು. ಪ್ರತಿ ವಿಭಾಗಕ್ಕೂ, ವಿದ್ಯಾರ್ಥಿಯ ನಿಜವಾದ ಪ್ರತಿಕ್ರಿಯೆಗಳ ಆಧಾರದ ಮೇಲೆ ಸಂಕ್ಷಿಪ್ತ ಸಾರಾಂಶವನ್ನು ಒದಗಿಸಿ.",
     "question2": "ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ ನಿಮ್ಮ ಬಗ್ಗೆ ಸಂಕ್ಷಿಪ್ತ ವಿವರಣೆಯನ್ನು ಬರೆಯಿರಿ. (ನೀವು ಪದಗಳು, ಚಿತ್ರಗಳು ಅಥವಾ ಚಿಹ್ನೆಗಳನ್ನು ಬಳಸಬಹುದು).",
     "question3": "\"ನನ್ನ ಪ್ರೇರಣೆ\" ಮತ್ತು \"ನನ್ನ ಬಗ್ಗೆ\" ನಲ್ಲಿನ ಚಟುವಟಿಕೆಗಳ ಸಾರಾಂಶದ ಆಧಾರದ ಮೇಲೆ, ನಿಮ್ಮ ಪ್ರತಿಯೊಂದು ವೃತ್ತಿ ಆಸಕ್ತಿಗಳಲ್ಲಿ ನಿಮಗೆ ಸಹಾಯ ಮಾಡಬಹುದಾದ ಗುಣಗಳು, ಆಸಕ್ತಿಗಳು, ಶಕ್ತಿಗಳು ಮತ್ತು ಸುಧಾರಣೆಯ ಪ್ರದೇಶಗಳನ್ನು ಗುರುತಿಸಿ. ಇದು ನಿಮ್ಮ ವೃತ್ತಿ ಆಯ್ಕೆಯೊಂದಿಗೆ ನೀವು ಉತ್ತಮವಾಗಿ ಸಮಂಜಸವಾಗಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ."
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
    WHERE assessment_type = 'about_me';
    
    RAISE NOTICE 'About Me Summary Template Update Complete:';
    RAISE NOTICE 'Templates found: %', template_count;
    
    IF template_count = 1 THEN
        RAISE NOTICE '✅ About Me summary template inserted successfully!';
    ELSE
        RAISE WARNING '⚠️ Expected 1 template, found %', template_count;
    END IF;
END $$;

