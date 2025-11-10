-- Migration: Sync Role Models Questions Translations
-- This migration ensures English and Kannada translations exist in content_translations
-- for all 13 role models questions (rm_q1 through rm_q13)

-- First, ensure English translations exist for questions 1-11 from role_models_questions table
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'role_models_question',
    'rm_q' || r.sequence_number::text,
    'en',
    r.question_text,
    NOW()
FROM role_models_questions r
WHERE r.sequence_number BETWEEN 1 AND 11
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- Insert English translations for questions 12 and 13 (general reflection questions)
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
('role_models_question', 'rm_q12', 'en', 'Do you notice any similarities between your personality traits and those of your role models?', NOW()),
('role_models_question', 'rm_q13', 'en', 'How do you intend to cultivate and incorporate some of the qualities exhibited by your role models into your own life?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- Insert Kannada translations for all 13 questions
-- Simplified for rural grade 8 students - using simple, everyday Kannada words
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question 1
('role_models_question', 'rm_q1', 'kn', 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯ ಹೆಸರು ಏನು?', NOW()),

-- Question 2
('role_models_question', 'rm_q2', 'kn', 'ನೀವು ಈ ವ್ಯಕ್ತಿಯನ್ನು ವೈಯಕ್ತಿಕವಾಗಿ ತಿಳಿದಿದ್ದೀರಾ? ಹಾಗಿದ್ದರೆ, ಅವರು ನಿಮ್ಮ ಕುಟುಂಬದವರೇ, ಸಂಬಂಧಿಕರೇ, ಶಾಲೆಯವರೇ, ಗ್ರಾಮದವರೇ, ಅಥವಾ ಪರಿಚಿತರೇ?', NOW()),

-- Question 3
('role_models_question', 'rm_q3', 'kn', 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯಲ್ಲಿ ನೀವು ಏನು ಚೆನ್ನಾಗಿ ಇದೆ ಎಂದು ಭಾವಿಸುತ್ತೀರಿ? ನಿಮಗೆ ಇಷ್ಟವಾದ ಗುಣಗಳನ್ನು ಬರೆಯಿರಿ. ಅವರು ನಿಮಗೆ ವಿಶೇಷರಾಗಿ ಮಾಡುವ ವಿಷಯವೇನು?', NOW()),

-- Question 4
('role_models_question', 'rm_q4', 'kn', 'ಅವರು ಏನು ಕೆಲಸ ಮಾಡುತ್ತಾರೆ?', NOW()),

-- Question 5
('role_models_question', 'rm_q5', 'kn', 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳಲ್ಲಿ ಇರುವ ಸಾಮರ್ಥ್ಯಗಳನ್ನು ನೋಡಿ, ನೀವು ಕಲಿಯಲು ಬಯಸುವ ಕಲಿಕೆಗಳು ಯಾವುವು?', NOW()),

-- Question 6
('role_models_question', 'rm_q6', 'kn', 'ನಿಮ್ಮ ಭವಿಷ್ಯದ ಕೆಲಸದ ಬಗ್ಗೆ ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಯೊಂದಿಗೆ ಮಾತನಾಡಿದ್ದೀರಾ? ಹಾಗಿದ್ದರೆ, ಏನು ಮಾತನಾಡಿದ್ದೀರಿ?', NOW()),

-- Question 7
('role_models_question', 'rm_q7', 'kn', 'ಮಾತನಾಡದಿದ್ದರೆ, ನಿಮ್ಮ ಕನಸಿನ ಕೆಲಸದ ಬಗ್ಗೆ ಅವರ ಅಭಿಪ್ರಾಯ ಕೇಳುವುದರ ಬಗ್ಗೆ ಯೋಚಿಸಿದ್ದೀರಾ?', NOW()),

-- Question 8
('role_models_question', 'rm_q8', 'kn', 'ನಿಮ್ಮ ಕನಸಿನ ಕೆಲಸದ ಬಗ್ಗೆ ಅವರು ಏನು ಹೇಳುತ್ತಾರೆ?', NOW()),

-- Question 9
('role_models_question', 'rm_q9', 'kn', 'ನಿಮ್ಮ ಭವಿಷ್ಯದ ಕೆಲಸವನ್ನು ಆರಿಸಲು ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳು ನಿಮಗೆ ಸಹಾಯ ಮಾಡಬಹುದೇ?', NOW()),

-- Question 10
('role_models_question', 'rm_q10', 'kn', 'ಮೇಲಿನ ಪ್ರಶ್ನೆಗೆ ಹೌದು ಎಂದಿದ್ದರೆ, ಅವರು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು?', NOW()),

-- Question 11
('role_models_question', 'rm_q11', 'kn', 'ಮೇಲಿನ ಪ್ರಶ್ನೆಗಳ ಹೊರತಾಗಿ ನೀವು ಹೇಳಲು ಬಯಸುವ ವಿಷಯವೇನಾದರೂ ಇದೆಯೇ?', NOW()),

-- Question 12 (General Reflection)
('role_models_question', 'rm_q12', 'kn', 'ನಿಮ್ಮ ಗುಣಗಳು ಮತ್ತು ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳ ಗುಣಗಳ ನಡುವೆ ಏನಾದರೂ ಹೋಲಿಕೆ ಇದೆಯೇ?', NOW()),

-- Question 13 (General Reflection)
('role_models_question', 'rm_q13', 'kn', 'ನಿಮ್ಮ ಆದರ್ಶ ವ್ಯಕ್ತಿಗಳಲ್ಲಿ ಇರುವ ಗುಣಗಳನ್ನು ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಹೇಗೆ ಬೆಳೆಸಲು ಬಯಸುತ್ತೀರಿ?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- Verify translations were inserted
DO $$
DECLARE
    en_count INTEGER;
    kn_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO en_count
    FROM content_translations
    WHERE resource_type = 'role_models_question'
    AND resource_key LIKE 'rm_q%'
    AND lang = 'en';
    
    SELECT COUNT(*) INTO kn_count
    FROM content_translations
    WHERE resource_type = 'role_models_question'
    AND resource_key LIKE 'rm_q%'
    AND lang = 'kn';
    
    RAISE NOTICE 'Role Models Translations Sync Complete:';
    RAISE NOTICE 'English translations: %', en_count;
    RAISE NOTICE 'Kannada translations: %', kn_count;
    
    IF en_count >= 13 AND kn_count >= 13 THEN
        RAISE NOTICE '✅ All translations synced successfully!';
    ELSE
        RAISE WARNING '⚠️ Expected 13 translations for each language, found EN: %, KN: %', en_count, kn_count;
    END IF;
END $$;

