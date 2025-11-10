-- Migration: Add Simplified Kannada Translations for Inspiration Assessment
-- Simplified for rural grade 8 students - using simple, everyday Kannada words
-- Short sentences, clear meaning, avoiding technical or literary words

-- ============================================================================
-- INSPIRATION ASSESSMENT - Simplified Kannada Questions (9 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question 1
('inspiration_question', 'question1', 'kn', 'ವೀಡಿಯೊ/ಆಡಿಯೊದಲ್ಲಿ ನಿಮಗೆ ಹೆಚ್ಚು ಇಷ್ಟವಾದ ಅಥವಾ ಪ್ರೇರಣೆ ನೀಡಿದ ಭಾಗಗಳು ಯಾವುವು?', NOW()),
-- Question 2
('inspiration_question', 'question2', 'kn', 'ಈ ವೀಡಿಯೊ/ಆಡಿಯೊದಿಂದ ನೀವು ಯಾವ ಗುಣಗಳು ಮತ್ತು ಮೌಲ್ಯಗಳನ್ನು ಕಲಿಯಬಹುದು?', NOW()),
-- Question 3
('inspiration_question', 'question3', 'kn', 'ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ನೀವು ಯಾವ ಗುಣಗಳು ಅಥವಾ ಮೌಲ್ಯಗಳನ್ನು ಸೇರಿಸಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
-- Question 4
('inspiration_question', 'question4', 'kn', 'ಈ ವೀಡಿಯೊಗಳಿಂದ ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಧನಾತ್ಮಕ ಬದಲಾವಣೆಗಳನ್ನು ತರಬಹುದಾದ ಮುಖ್ಯ ವಿಷಯಗಳು ಯಾವುವು?', NOW()),
-- Question 5
('inspiration_question', 'question5', 'kn', 'ನೀವು ಈ ವೀಡಿಯೊಗಳಲ್ಲಿ ಯಾವುದೇ ಪಾತ್ರಗಳೊಂದಿಗೆ ನಿಮ್ಮನ್ನು ಗುರುತಿಸಿಕೊಂಡಿದ್ದೀರಾ? ಹಾಗಿದ್ದರೆ, ಯಾವ ಪಾತ್ರ ಮತ್ತು ಏಕೆ?', NOW()),
-- Question 6
('inspiration_question', 'question6', 'kn', 'ನೀವು ನಿಜ ಜೀವನದಲ್ಲಿ ನೀವು ಇಷ್ಟಪಡುವ ಮೌಲ್ಯಗಳನ್ನು ತೋರಿಸಿದ್ದೀರಾ? ಸಂಕ್ಷಿಪ್ತವಾಗಿ ವಿವರಿಸಿ', NOW()),
-- Question 7
('inspiration_question', 'question7', 'kn', 'ವೀಡಿಯೊ/ಆಡಿಯೊದಲ್ಲಿ ನಿಮಗೆ ಹೆಚ್ಚು ಪ್ರೇರಣೆ ನೀಡಿದ ಅಥವಾ ಸ್ಫೂರ್ತಿ ನೀಡಿದ ಭಾಗದ ಬಗ್ಗೆ ಬರೆಯಿರಿ.', NOW()),
-- Question 8
('inspiration_question', 'question8', 'kn', 'ನಿಮ್ಮ ನಿಜ ಜೀವನದಲ್ಲಿ ಈ ವೀಡಿಯೊಗಳಲ್ಲಿನ ಪಾತ್ರಗಳಂತೆ ಪ್ರೇರಣೆ ನೀಡಿದ ವ್ಯಕ್ತಿ ಅಥವಾ ಸನ್ನಿವೇಶವನ್ನು ನೀವು ನೆನಪಿಸಿಕೊಳ್ಳಬಹುದೇ?', NOW()),
-- Question 9
('inspiration_question', 'question9', 'kn', 'ಈ ವೀಡಿಯೊಗಳ ಬಗ್ಗೆ ನೀವು ಹಂಚಿಕೊಳ್ಳಲು ಬಯಸುವ ಬೇರೆ ಯೋಚನೆಗಳು ಯಾವುವು?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- INSPIRATION ASSESSMENT - Simplified Kannada Help Text (9 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question 1
('inspiration_help', 'question1', 'kn', 'ನಿಮಗೆ ಇಷ್ಟವಾದ ಅಥವಾ ಪ್ರೇರಣೆ ನೀಡಿದ ನಿರ್ದಿಷ್ಟ ಕ್ಷಣಗಳು, ಸಂದೇಶಗಳು ಅಥವಾ ವಿಷಯಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ.', NOW()),
-- Question 2
('inspiration_help', 'question2', 'kn', 'ವೀಡಿಯೊದಲ್ಲಿ ತೋರಿಸಿದ ಧನಾತ್ಮಕ ಗುಣಗಳು, ಮೌಲ್ಯಗಳು ಅಥವಾ ತತ್ವಗಳನ್ನು ಗುರುತಿಸಿ.', NOW()),
-- Question 3
('inspiration_help', 'question3', 'kn', 'ವೀಡಿಯೊದಿಂದ ನಿಮ್ಮ ದೈನಂದಿನ ಜೀವನದಲ್ಲಿ ಅಭಿವೃದ್ಧಿಪಡಿಸಲು ಅಥವಾ ಅಭ್ಯಾಸ ಮಾಡಲು ಬಯಸುವ ಗುಣಗಳು ಅಥವಾ ಮೌಲ್ಯಗಳನ್ನು ಯೋಚಿಸಿ.', NOW()),
-- Question 4
('inspiration_help', 'question4', 'kn', 'ನಿಮ್ಮ ಬೆಳವಣಿಗೆ, ಸುಧಾರಣೆ ಅಥವಾ ಧನಾತ್ಮಕ ಬದಲಾವಣೆಗಳಿಗೆ ಸಹಾಯ ಮಾಡಬಹುದಾದ ವಿಷಯಗಳಿಂದ ನಿರ್ದಿಷ್ಟ ಅಂಶಗಳು, ತಂತ್ರಗಳು ಅಥವಾ ಒಳನೋಟಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ.', NOW()),
-- Question 5
('inspiration_help', 'question5', 'kn', 'ನಿಮಗೆ ಸಂಬಂಧಿಸಿದ ಪಾತ್ರಗಳು, ನೀವು ಅವರೊಂದಿಗೆ ಸಂಪರ್ಕಿಸಿದ ಕಾರಣ ಮತ್ತು ನೀವು ಹಂಚಿಕೊಂಡ ಹೋಲಿಕೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ.', NOW()),
-- Question 6
('inspiration_help', 'question6', 'kn', 'ನೀವು ವೀಡಿಯೊದಿಂದ ಇಷ್ಟಪಡುವ ಗುಣಗಳು, ಮೌಲ್ಯಗಳು ಅಥವಾ ನಡವಳಿಕೆಗಳನ್ನು ತೋರಿಸಿದ ನಿಜ ಜೀವನದ ಉದಾಹರಣೆ ಅಥವಾ ಅನುಭವವನ್ನು ಹಂಚಿಕೊಳ್ಳಿ.', NOW()),
-- Question 7
('inspiration_help', 'question7', 'kn', 'ವೀಡಿಯೊ/ಆಡಿಯೊದಿಂದ ನೀವು ಕಲಿತದ್ದರ ಆಧಾರದ ಮೇಲೆ ನೀವು ಹೇಗೆ ನಿಭಾಯಿಸುತ್ತೀರಿ ಮತ್ತು ಯಾವ ಕ್ರಮಗಳನ್ನು ತೆಗೆದುಕೊಳ್ಳುತ್ತೀರಿ ಎಂದು ಊಹಿಸಿ.', NOW()),
-- Question 8
('inspiration_help', 'question8', 'kn', 'ನಿಮ್ಮ ಸ್ವಂತ ಜೀವನದಲ್ಲಿ ಇದೇ ರೀತಿಯಲ್ಲಿ ಪ್ರೇರಣೆ ನೀಡಿದ ಜನರು, ಅನುಭವಗಳು ಅಥವಾ ಕ್ಷಣಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ ಮತ್ತು ಅವುಗಳನ್ನು ಅರ್ಥಪೂರ್ಣವಾಗಿ ಮಾಡಿದ್ದನ್ನು ವಿವರಿಸಿ.', NOW()),
-- Question 9
('inspiration_help', 'question9', 'kn', 'ವೀಡಿಯೊಗಳು ಅಥವಾ ಆಡಿಯೊ ವಿಷಯದ ಬಗ್ಗೆ ನೀವು ಹೊಂದಿರುವ ಬೇರೆ ಯೋಚನೆಗಳು, ಪ್ರತಿಬಿಂಬಗಳು, ವೀಕ್ಷಣೆಗಳು ಅಥವಾ ವೈಯಕ್ತಿಕ ಸಂಪರ್ಕಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಿ.', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
    inspiration_q_count INTEGER;
    inspiration_help_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO inspiration_q_count
    FROM content_translations
    WHERE resource_type = 'inspiration_question' AND lang = 'kn';
    
    SELECT COUNT(*) INTO inspiration_help_count
    FROM content_translations
    WHERE resource_type = 'inspiration_help' AND lang = 'kn';
    
    RAISE NOTICE 'Simplified Kannada Translations Added:';
    RAISE NOTICE 'Inspiration Questions: % translations', inspiration_q_count;
    RAISE NOTICE 'Inspiration Help Text: % translations', inspiration_help_count;
    
    IF inspiration_q_count >= 9 AND inspiration_help_count >= 9 THEN
        RAISE NOTICE '✅ All simplified Kannada translations for Inspiration assessment added successfully!';
    ELSE
        RAISE WARNING '⚠️ Some translations may be missing. Check counts above.';
    END IF;
END $$;

