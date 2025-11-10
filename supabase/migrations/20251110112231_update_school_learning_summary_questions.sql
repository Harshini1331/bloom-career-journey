-- Migration: Update School Learning Assessment Summary Questions
-- This migration ensures the AI summary questions match the required format

-- Update School Learning summary template with the correct questions
INSERT INTO assessment_summary_templates (assessment_type, title, summary_questions) VALUES
('school_learning', 'Summary: Subjects I like', 
 '{
   "en": {
     "question1": "Subjects I like",
     "question2": "Careers that are possible of the subjects that I like",
     "question3": "Subjects I don''t like",
     "question4": "Careers that are possible if I improve in those subjects which I don''t like",
     "question5": "Things I am good at besides academics at school",
     "question6": "How will improving these skills help me with my career"
   },
   "kn": {
     "question1": "ನನಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳು",
     "question2": "ನನಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳಿಂದ ಸಾಧ್ಯವಾದ ವೃತ್ತಿಗಳು",
     "question3": "ನನಗೆ ಇಷ್ಟವಿಲ್ಲದ ವಿಷಯಗಳು",
     "question4": "ನನಗೆ ಇಷ್ಟವಿಲ್ಲದ ಆ ವಿಷಯಗಳಲ್ಲಿ ನಾನು ಸುಧಾರಿಸಿದರೆ ಸಾಧ್ಯವಾದ ವೃತ್ತಿಗಳು",
     "question5": "ಶಾಲೆಯಲ್ಲಿ ಶೈಕ್ಷಣಿಕ ಚಟುವಟಿಕೆಗಳ ಹೊರತಾಗಿ ನಾನು ಚೆನ್ನಾಗಿ ಮಾಡುವ ವಿಷಯಗಳು",
     "question6": "ಈ ಕೌಶಲ್ಯಗಳನ್ನು ಸುಧಾರಿಸುವುದು ನನ್ನ ವೃತ್ತಿಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತದೆ"
   }
 }'::jsonb)
ON CONFLICT (assessment_type) 
DO UPDATE SET
    title = EXCLUDED.title,
    summary_questions = EXCLUDED.summary_questions,
    updated_at = NOW();

-- Verify data update
DO $$
DECLARE
    school_learning_template_count INTEGER;
    template_data jsonb;
BEGIN
    SELECT COUNT(*) INTO school_learning_template_count
    FROM assessment_summary_templates 
    WHERE assessment_type = 'school_learning';
    
    SELECT summary_questions INTO template_data
    FROM assessment_summary_templates 
    WHERE assessment_type = 'school_learning'
    LIMIT 1;
    
    IF school_learning_template_count = 1 THEN
        RAISE NOTICE '✅ School Learning summary template updated successfully!';
        RAISE NOTICE 'Template data: %', template_data;
    ELSE
        RAISE NOTICE '⚠️ School Learning summary template count: %', school_learning_template_count;
    END IF;
END $$;


