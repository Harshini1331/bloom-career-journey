-- Migration: Add Simplified Kannada Help Text Translations for All Assessments
-- Simplified for rural grade 8 students - using simple, everyday Kannada words
-- Short sentences, clear meaning, avoiding technical or literary words

-- ============================================================================
-- 1. DREAMS ASSESSMENT - Simplified Kannada Help Text (18 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Your Dreams & Future Goals
('dreams_help', 'question1', 'kn', 'ನಿಮ್ಮ ಭವಿಷ್ಯದ ಬಗ್ಗೆ ಏನು ಸಾಧಿಸಲು ಬಯಸುತ್ತೀರಿ ಎಂದು ಯೋಚಿಸಿ. ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಏನು ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_help', 'question2', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಏನು ಕಲಿಯಲು ಬಯಸುತ್ತೀರಿ? ಯಾವ ವಿಷಯಗಳು ನಿಮಗೆ ಇಷ್ಟ? ಯಾವ ಪದವಿ ಅಥವಾ ಕಲಿಕೆ ನೀವು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_help', 'question3', 'kn', 'ನೀವು ಯಾವ ಕೆಲಸ ಮಾಡಲು ಬಯಸುತ್ತೀರಿ? ನಿಮಗೆ ಸಂತೋಷ ಮತ್ತು ತೃಪ್ತಿ ನೀಡುವ ಕೆಲಸ ಯಾವುದು?', NOW()),
('dreams_help', 'question4', 'kn', 'ನೀವು ಆಟವನ್ನು ಇಷ್ಟಪಡುತ್ತಿದ್ದರೆ, ಯಾವ ಆಟವನ್ನು ವೃತ್ತಿಯಾಗಿ ಆಡಲು ಬಯಸುತ್ತೀರಿ? ಈ ಆಟದ ಬಗ್ಗೆ ನಿಮಗೆ ಏನು ಇಷ್ಟ?', NOW()),
('dreams_help', 'question5', 'kn', 'ನೀವು ಬರಹಗಾರರಾಗಿದ್ದರೆ, ಯಾವ ರೀತಿಯ ಬರಹ ಬರೆಯಲು ಬಯಸುತ್ತೀರಿ? ಕಥೆ, ಕವಿತೆ, ಸುದ್ದಿ, ಅಥವಾ ಬೇರೆ?', NOW()),
('dreams_help', 'question6', 'kn', 'ನೀವು ಸಂಗೀತ ಇಷ್ಟಪಡುತ್ತಿದ್ದರೆ, ಹಾಡುವುದರಲ್ಲಿ ಅಥವಾ ವಾದ್ಯಗಳಲ್ಲಿ ಯಾವುದು?', NOW()),

-- Section 2: Career & Life Aspirations
('dreams_help', 'question7', 'kn', 'ನೀವು ಯಾವ ಕಾಲೇಜಿಗೆ ಹೋಗಲು ಬಯಸುತ್ತೀರಿ? ಅಲ್ಲಿ ಏನು ಕಲಿಯಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_help', 'question8', 'kn', 'ನೀವು ಇತರರಿಗೆ ಸಹಾಯ ಮಾಡಲು ಬಯಸಿದರೆ, ಯಾರಿಗೆ ಅಥವಾ ಯಾವ ವಿಷಯಕ್ಕೆ ಸಹಾಯ ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_help', 'question9', 'kn', 'ನೀವು ಜಗತ್ತಿನಲ್ಲಿ ಎಲ್ಲಾದರೂ ವಾಸಿಸಲು ಸಾಧ್ಯವಿದ್ದರೆ, ಎಲ್ಲಿ ವಾಸಿಸಲು ಬಯಸುತ್ತೀರಿ? ಏಕೆ?', NOW()),
('dreams_help', 'question10', 'kn', 'ನೀವು ಕಲಾವಿದರಾಗಿದ್ದರೆ, ಯಾವ ರೀತಿಯ ಕಲೆ ಮಾಡಲು ಬಯಸುತ್ತೀರಿ? ಬಣ್ಣ ಬಳಿಯುವುದು, ಚಿತ್ರ ತೆಗೆಯುವುದು, ನೃತ್ಯ, ಅಥವಾ ಬೇರೆ?', NOW()),
('dreams_help', 'question11', 'kn', 'ನೀವು ಪ್ರಯಾಣಿಸಲು ಇಷ್ಟಪಡುತ್ತಿದ್ದರೆ, ಪ್ರಯಾಣದಲ್ಲಿ ನಿಮಗೆ ಏನು ಇಷ್ಟ? ಹೊಸ ಸ್ಥಳಗಳು, ಜನರು, ಪ್ರಕೃತಿ, ಅಥವಾ ಬೇರೆ?', NOW()),
('dreams_help', 'question12', 'kn', 'ನೀವು ಒಂದು ದಿನ ಯಾರೊಂದಿಗೆ ಕಲಿಯಲು ಬಯಸುತ್ತೀರಿ? ಅವರಲ್ಲಿ ನಿಮಗೆ ಏನು ಇಷ್ಟ?', NOW()),

-- Section 3: Making Dreams Reality
('dreams_help', 'question13', 'kn', 'ನೀವು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ಬಯಸುತ್ತೀರಾ? ಅದಕ್ಕಾಗಿ ಕಷ್ಟಪಡಲು ಸಿದ್ಧರಿದ್ದೀರಾ?', NOW()),
('dreams_help', 'question14', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ನಿಮಗೆ ಏನು ಬೇಕು? ಒಂದು ಕನಸನ್ನು ಆರಿಸಿ ಮತ್ತು ಅದನ್ನು ನಿಜವಾಗಿಸಲು ಏನು ಬೇಕು ಎಂದು ಬರೆಯಿರಿ.', NOW()),
('dreams_help', 'question15', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ನೀವು ಯಾವ ಮೊದಲ ಹೆಜ್ಜೆಗಳನ್ನು ಇಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_help', 'question16', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ನಿಮಗೆ ಧನಾತ್ಮಕ ಮನಸ್ಥಿತಿ ಮತ್ತು ಪ್ರೇರಣೆ ಇದೆಯೇ?', NOW()),
('dreams_help', 'question17', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸುವಾಗ ಬರಬಹುದಾದ ತೊಂದರೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿದ್ದೀರಾ? ಹಾಗಿದ್ದರೆ, ಅವು ಯಾವುವು?', NOW()),
('dreams_help', 'question18', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಕಲಿಯುತ್ತಿರುವ ವಿಷಯಗಳು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ ಎಂದು ನೀವು ಭಾವಿಸುತ್ತೀರಾ? ಹಾಗಿದ್ದರೆ, ಹೇಗೆ?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 2. SCHOOL LEARNING ASSESSMENT - Simplified Kannada Help Text (21 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: School Experience (Questions 1-4)
('school_help', 'question1', 'kn', 'ಹೌದು ಅಥವಾ ಇಲ್ಲ ಎಂದು ಹೇಳಿ, ನಂತರ ಏಕೆ ಎಂದು ವಿವರಿಸಿ. ಉದಾಹರಣೆ: "ಹೌದು, ನನ್ನ ಸ್ನೇಹಿತರನ್ನು ನೋಡಲು ಮತ್ತು ಹೊಸ ವಿಷಯಗಳನ್ನು ಕಲಿಯಲು ಇಷ್ಟ."', NOW()),
('school_help', 'question2', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಏನು ಕಲಿಯಲು ಇಷ್ಟಪಡುತ್ತೀರಿ? ಯಾವ ವಿಷಯಗಳು ಅಥವಾ ಚಟುವಟಿಕೆಗಳು ನಿಮಗೆ ಇಷ್ಟ?', NOW()),
('school_help', 'question3', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ಕಲಿಯಲು ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ಕಾರಣಗಳು ಯಾವುವು? ಯಾವ ತೊಂದರೆಗಳು ಬರುತ್ತವೆ?', NOW()),
('school_help', 'question4', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮ್ಮ ಉತ್ತಮ ಸ್ನೇಹಿತರು ಯಾರು? ಅವರು ನಿಮ್ಮ ಉತ್ತಮ ಸ್ನೇಹಿತರಾಗಲು ಏನು ಮಾಡಿದರು?', NOW()),

-- Section 2: Subjects & Learning Preferences (Questions 5-8)
('school_help', 'question5', 'kn', 'ನಿಮಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳನ್ನು ಬರೆಯಿರಿ. ಯಾವ ವಿಷಯಗಳು ನಿಮಗೆ ಇಷ್ಟ?', NOW()),
('school_help', 'question6', 'kn', 'ಈ ವಿಷಯಗಳು ನಿಮಗೆ ಇಷ್ಟವಾಗಲು ಏನು ಮಾಡಿದೆ? ಏಕೆ ಇಷ್ಟ?', NOW()),
('school_help', 'question7', 'kn', 'ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ವಿಷಯಗಳನ್ನು ಬರೆಯಿರಿ.', NOW()),
('school_help', 'question8', 'kn', 'ಈ ವಿಷಯಗಳಲ್ಲಿ ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ಕಾರಣ ಏನು? ಈ ವಿಷಯಗಳನ್ನು ಕಲಿಯುವಾಗ ನಿಮಗೆ ಯಾವ ತೊಂದರೆಗಳು ಬರುತ್ತವೆ?', NOW()),

-- Section 3: Academic Performance & Learning Methods (Questions 9-12)
('school_help', 'question9', 'kn', 'ಯಾವ ವಿಷಯಗಳಲ್ಲಿ ನೀವು ಚೆನ್ನಾಗಿ ಅಂಕಗಳನ್ನು ಪಡೆಯುತ್ತೀರಿ?', NOW()),
('school_help', 'question10', 'kn', 'ಯಾವ ವಿಷಯಗಳಲ್ಲಿ ನಿಮಗೆ ಹೆಚ್ಚು ಅಂಕಗಳನ್ನು ಪಡೆಯಲು ಕಷ್ಟವಾಗುತ್ತದೆ?', NOW()),
('school_help', 'question11', 'kn', 'ಕೆಳಗಿನಲ್ಲಿ ನಿಮಗೆ ಇಷ್ಟವಾದ ಕಲಿಕೆಯ ವಿಧಾನಗಳನ್ನು ಗುರುತಿಸಿ. ನೀವು ಹೇಗೆ ಚೆನ್ನಾಗಿ ಕಲಿಯುತ್ತೀರಿ?', NOW()),
('school_help', 'question12', 'kn', 'ನೀವು ಒಂಟಿಯಾಗಿ ಅಥವಾ ಗುಂಪಿನಲ್ಲಿ ಓದಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ಏಕೆ?', NOW()),

-- Section 4: School Relationships & Experiences (Questions 13-16)
('school_help', 'question13', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮ್ಮ ಸ್ನೇಹಿತರಿಂದ ನೀವು ಏನು ಕಲಿಯುತ್ತೀರಿ? ಇತ್ತೀಚೆಗೆ ನೀವು ಏನು ಕಲಿತಿದ್ದೀರಿ?', NOW()),
('school_help', 'question14', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ಶೈಕ್ಷಣಿಕ ವಿಷಯಗಳ ಹೊರತಾಗಿ ನಿಮಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳು ಯಾವುವು?', NOW()),
('school_help', 'question15', 'kn', 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಶಿಕ್ಷಕರು ಯಾರು? ಏಕೆ? ಈ ಶಿಕ್ಷಕರು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಿದ್ದಾರೆ?', NOW()),
('school_help', 'question16', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮಗೆ ಯಶಸ್ಸು ಅಥವಾ ಹೆಮ್ಮೆ ತಂದಿದ್ದ ಘಟನೆ ಯಾವುದು? ಅದು ಏನು?', NOW()),

-- Section 5: Future & Reflection (Questions 17-21)
('school_help', 'question17', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಕಲಿತ ವಿಷಯಗಳು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತವೆ?', NOW()),
('school_help', 'question18', 'kn', 'ನಿಮ್ಮ ಶಾಲೆಯಲ್ಲಿ ನೀವು ಬದಲಾಯಿಸಲು ಬಯಸುವ ಒಂದು ವಿಷಯ ಯಾವುದು? ಏಕೆ?', NOW()),
('school_help', 'question19', 'kn', 'ನೀವು ಅಭ್ಯಾಸ ಮಾಡಲು ಬೇರೆ ಸ್ಥಳವಿದೆಯೇ? ಅದು ಏಕೆ ಬೇಕು?', NOW()),
('school_help', 'question20', 'kn', 'ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಕಲಿಯುವುದರಲ್ಲಿ ಶಾಲೆಯು ಮುಖ್ಯವಾದದ್ದೇ? ನಿಮ್ಮ ಅಭಿಪ್ರಾಯ ಬರೆಯಿರಿ.', NOW()),
('school_help', 'question21', 'kn', 'ನೀವು ನಿಮ್ಮ ತಂದೆತಾಯಿಗಳೊಂದಿಗೆ ಶಾಲೆಯ ಕೆಲಸಗಳು ಮತ್ತು ನೀವು ಕಲಿತ ವಿಷಯಗಳ ಬಗ್ಗೆ ಮಾತನಾಡಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ನೀವು ಏನು ಮಾತನಾಡುತ್ತೀರಿ?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 3. HOBBIES ASSESSMENT - Simplified Kannada Help Text (14 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Hobbies & Interests (Questions 1-7)
('hobbies_help', 'question1', 'kn', 'ಶಾಲೆಯ ಕೆಲಸ ಅಥವಾ ಮನೆಯ ಕೆಲಸ ಮಾಡದ ಸಮಯದಲ್ಲಿ ನೀವು ಏನು ಮಾಡುತ್ತೀರಿ ಎಂದು ಯೋಚಿಸಿ. ಓದುವುದು, ಆಟ ಆಡುವುದು, ಚಿತ್ರ ಬರೆಯುವುದು, ಸಂಗೀತ ಕೇಳುವುದು, ಸ್ನೇಹಿತರೊಂದಿಗೆ ಸಮಯ ಕಳೆಯುವುದು, ಅಥವಾ ಬೇರೆ ಚಟುವಟಿಕೆಗಳು.', NOW()),
('hobbies_help', 'question2', 'kn', 'ನೀವು ನಿಯಮಿತವಾಗಿ ಮಾಡುವ ಚಟುವಟಿಕೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಓದುವುದು, ವಾದ್ಯಗಳನ್ನು ನುಡಿಸುವುದು, ಆಟ, ಚಿತ್ರ ಬರೆಯುವುದು, ಬರೆಯುವುದು, ಅಡಿಗೆ, ಅಥವಾ ಬೇರೆ ಆಸಕ್ತಿಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.', NOW()),
('hobbies_help', 'question3', 'kn', 'ಯಾವ ಹವ್ಯಾಸ ಅಥವಾ ಚಟುವಟಿಕೆ ನಿಮಗೆ ಹೆಚ್ಚು ಸಂತೋಷ ಮತ್ತು ತೃಪ್ತಿ ನೀಡುತ್ತದೆ ಎಂದು ಯೋಚಿಸಿ. ಈ ಹವ್ಯಾಸವು ನಿಮಗೆ ವಿಶೇಷವಾಗಿ ಮಾಡುವ ವಿಷಯವೇನು?', NOW()),
('hobbies_help', 'question4', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳು ಕಾಲಾನಂತರದಲ್ಲಿ ಬದಲಾಗಿದೆಯೇ ಎಂದು ಯೋಚಿಸಿ. ನೀವು ಮೊದಲು ಬೇರೆ ಹವ್ಯಾಸಗಳನ್ನು ಹೊಂದಿದ್ದೀರಾ?', NOW()),
('hobbies_help', 'question5', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳಿಗೆ ಏನು ಪ್ರೇರಣೆ ನೀಡಿದೆ ಎಂದು ಯೋಚಿಸಿ. ಕುಟುಂಬದವರು, ಸ್ನೇಹಿತರು, ಶಿಕ್ಷಕರು, ಅಥವಾ ಬೇರೆ ಜನರು ನಿಮಗೆ ಈ ಚಟುವಟಿಕೆಗಳನ್ನು ಕಲಿಸಿದ್ದಾರೆಯೇ? ಪುಸ್ತಕಗಳು, ಚಲನಚಿತ್ರಗಳು, ಸಂಗೀತ, ಅಥವಾ ಬೇರೆ ಮೂಲಗಳಿಂದ ಪ್ರೇರಣೆ ಪಡೆದಿದ್ದೀರಾ?', NOW()),
('hobbies_help', 'question6', 'kn', 'ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಇದೇ ರೀತಿಯ ಚಟುವಟಿಕೆಗಳನ್ನು ಇಷ್ಟಪಡುವ ಜನರು ಯಾರು? ಕುಟುಂಬದವರು, ಸ್ನೇಹಿತರು, ಸಹಪಾಠಿಗಳು, ಅಥವಾ ಬೇರೆ ಜನರು.', NOW()),
('hobbies_help', 'question7', 'kn', 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಹವ್ಯಾಸವನ್ನು ಮಾಡುವಾಗ ನೀವು ಹೇಗೆ ಭಾವಿಸುತ್ತೀರಿ? ಅದು ನಿಮಗೆ ವಿಶ್ರಾಂತಿ ನೀಡುತ್ತದೆಯೇ, ಶಕ್ತಿ ನೀಡುತ್ತದೆಯೇ, ಆತ್ಮವಿಶ್ವಾಸ ನೀಡುತ್ತದೆಯೇ, ಅಥವಾ ಸಂತೋಷ ನೀಡುತ್ತದೆಯೇ?', NOW()),

-- Section 2: Talents & Practice (Questions 8-10)
('hobbies_help', 'question8', 'kn', 'ನಿಮಗೆ ಸುಲಭವಾಗಿ ಬರುವ ನೈಸರ್ಗಿಕ ಸಾಮರ್ಥ್ಯಗಳು ಅಥವಾ ಕೌಶಲ್ಯಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ಹಾಡುವುದು, ಚಿತ್ರ ಬರೆಯುವುದು, ಸಮಸ್ಯೆಗಳನ್ನು ಪರಿಹರಿಸುವುದು, ಮಾತನಾಡುವುದು, ಆಟ, ಸೃಜನಶೀಲ ಯೋಚನೆ, ಅಥವಾ ಬೇರೆ ಬಲಗಳು.', NOW()),
('hobbies_help', 'question9', 'kn', 'ನಿಮ್ಮ ಪ್ರತಿಭೆಯನ್ನು ಚೆನ್ನಾಗಿ ಮಾಡಲು ನೀವು ಹೇಗೆ ಅಭ್ಯಾಸ ಮಾಡುತ್ತೀರಿ? ನೀವು ಏನು ಕಲಿಯುತ್ತೀರಿ ಅಥವಾ ತರಬೇತಿ ಪಡೆಯುತ್ತೀರಿ?', NOW()),
('hobbies_help', 'question10', 'kn', 'ನಿಮಗೆ ಸಹಾಯ ಮತ್ತು ಅವಕಾಶಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿ. ನಿಮ್ಮ ಕುಟುಂಬ, ಶಾಲೆ, ಅಥವಾ ಸಮುದಾಯವು ನಿಮ್ಮ ಹವ್ಯಾಸಗಳು ಮತ್ತು ಪ್ರತಿಭೆಗಳನ್ನು ಅಭ್ಯಾಸ ಮಾಡಲು ಮತ್ತು ತೋರಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆಯೇ?', NOW()),

-- Section 3: Support & Career Connection (Questions 11-14)
('hobbies_help', 'question11', 'kn', 'ನಿಮ್ಮ ಆಸಕ್ತಿಗಳ ಬಗ್ಗೆ ನಿಮ್ಮ ತಂದೆತಾಯಿಗಳು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತಾರೆ? ಹಣ, ಸಮಯ, ಮಾರ್ಗದರ್ಶನ, ಅಥವಾ ಬೇರೆ ರೀತಿಯಲ್ಲಿ?', NOW()),
('hobbies_help', 'question12', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳು ಮತ್ತು ನಿಮ್ಮ ನೈಸರ್ಗಿಕ ಪ್ರತಿಭೆಗಳ ನಡುವೆ ಸಂಬಂಧವಿದೆಯೇ?', NOW()),
('hobbies_help', 'question13', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳಲ್ಲಿ ಭವಿಷ್ಯದಲ್ಲಿ ವೃತ್ತಿಯಾಗಿ ಮಾಡಬಹುದಾದವುಗಳು ಯಾವುವು? ಈ ಹವ್ಯಾಸಗಳನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಲು ಏನು ಮಾಡಬೇಕು?', NOW()),
('hobbies_help', 'question14', 'kn', 'ತಮ್ಮ ಹವ್ಯಾಸಗಳನ್ನು ಅಥವಾ ಆಸಕ್ತಿಗಳನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಿದ ನಿಮಗೆ ತಿಳಿದಿರುವ ಜನರು ಯಾರು? ಅವರು ಯಾವ ಹವ್ಯಾಸ ಮತ್ತು ಹೇಗೆ ಮಾಡಿದರು?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
    dreams_help_count INTEGER;
    school_help_count INTEGER;
    hobbies_help_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO dreams_help_count
    FROM content_translations
    WHERE resource_type = 'dreams_help' AND lang = 'kn';
    
    SELECT COUNT(*) INTO school_help_count
    FROM content_translations
    WHERE resource_type = 'school_help' AND lang = 'kn';
    
    SELECT COUNT(*) INTO hobbies_help_count
    FROM content_translations
    WHERE resource_type = 'hobbies_help' AND lang = 'kn';
    
    RAISE NOTICE 'Simplified Kannada Help Text Translations Added:';
    RAISE NOTICE 'Dreams: % help texts', dreams_help_count;
    RAISE NOTICE 'School Learning: % help texts', school_help_count;
    RAISE NOTICE 'Hobbies: % help texts', hobbies_help_count;
    
    IF dreams_help_count >= 18 AND school_help_count >= 21 AND hobbies_help_count >= 14 THEN
        RAISE NOTICE '✅ All simplified Kannada help text translations added successfully!';
    ELSE
        RAISE WARNING '⚠️ Some help text translations may be missing. Check counts above.';
    END IF;
END $$;

