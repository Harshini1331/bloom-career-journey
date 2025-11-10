-- Migration: Add Simplified Kannada Translations for All Assessments
-- Simplified for rural grade 8 students - using simple, everyday Kannada words
-- Short sentences, clear meaning, avoiding technical or literary words

-- ============================================================================
-- 1. INSPIRATION ASSESSMENT - Simplified Kannada Questions
-- ============================================================================
-- Note: These will be synced from inspiration_questions table via the sync migration
-- Adding simplified Kannada translations here for reference
-- (Inspiration questions are typically loaded via i18n RPC which uses content_translations)

-- ============================================================================
-- 2. DREAMS ASSESSMENT - Simplified Kannada Questions (18 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Your Dreams & Future Goals
('dreams_question', 'question1', 'kn', 'ನಿಮ್ಮ ಭವಿಷ್ಯದ ಬಗ್ಗೆ ನಿಮ್ಮ ಕನಸುಗಳು ಯಾವುವು?', NOW()),
('dreams_question', 'question2', 'kn', 'ನಿಮ್ಮ ಶಾಲೆಯ ಗುರಿಗಳು ಯಾವುವು? ನೀವು ಏನು ಕಲಿಯಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question3', 'kn', 'ನೀವು ಯಾವ ಕೆಲಸವನ್ನು ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question4', 'kn', 'ನೀವು ಯಾವ ಆಟವನ್ನು ವೃತ್ತಿಯಾಗಿ ಆಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question5', 'kn', 'ನೀವು ಬರಹಗಾರರಾಗಿದ್ದರೆ, ಯಾವ ವಿಷಯದ ಬಗ್ಗೆ ಬರೆಯಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question6', 'kn', 'ನೀವು ಸಂಗೀತ ಕಲಿಯಲು ಬಯಸಿದರೆ, ಹಾಡುವುದರಲ್ಲಿ ಅಥವಾ ವಾದ್ಯಗಳಲ್ಲಿ ಯಾವುದು?', NOW()),

-- Section 2: Career & Life Aspirations
('dreams_question', 'question7', 'kn', 'ನೀವು ಯಾವ ಕಾಲೇಜಿಗೆ ಹೋಗಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question8', 'kn', 'ನೀವು ಇತರರಿಗೆ ಸಹಾಯ ಮಾಡಲು ಬಯಸಿದರೆ, ಯಾರಿಗೆ ಅಥವಾ ಯಾವ ವಿಷಯಕ್ಕೆ ಸಹಾಯ ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question9', 'kn', 'ನೀವು ಜಗತ್ತಿನಲ್ಲಿ ಎಲ್ಲಾದರೂ ವಾಸಿಸಲು ಸಾಧ್ಯವಿದ್ದರೆ, ಎಲ್ಲಿ ವಾಸಿಸಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question10', 'kn', 'ನೀವು ಕಲಾವಿದರಾಗಿದ್ದರೆ, ಯಾವ ರೀತಿಯ ಕಲೆಯನ್ನು ಮಾಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question11', 'kn', 'ನೀವು ಪ್ರಯಾಣಿಸಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ಹಾಗಿದ್ದರೆ, ಪ್ರಯಾಣದಲ್ಲಿ ನಿಮಗೆ ಏನು ಇಷ್ಟ?', NOW()),
('dreams_question', 'question12', 'kn', 'ನೀವು ಒಂದು ದಿನ ಯಾರೊಂದಿಗೆ ಕಲಿಯಲು ಬಯಸುತ್ತೀರಿ? ಏಕೆ?', NOW()),

-- Section 3: Making Dreams Reality
('dreams_question', 'question13', 'kn', 'ನೀವು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ಬಯಸುತ್ತೀರಾ?', NOW()),
('dreams_question', 'question14', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ನಿಮಗೆ ಏನು ಬೇಕು? ಒಂದು ಕನಸನ್ನು ಆರಿಸಿ ಮತ್ತು ಹೇಗೆ ನಿಜವಾಗಿಸಬಹುದು ಎಂದು ಬರೆಯಿರಿ.', NOW()),
('dreams_question', 'question15', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ನಿಜವಾಗಿಸಲು ನೀವು ಯಾವ ಮೊದಲ ಹೆಜ್ಜೆಗಳನ್ನು ಇಡಲು ಬಯಸುತ್ತೀರಿ?', NOW()),
('dreams_question', 'question16', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ನಿಮಗೆ ಧನಾತ್ಮಕ ಮನಸ್ಥಿತಿ ಮತ್ತು ಪ್ರೇರಣೆ ಇದೆಯೇ?', NOW()),
('dreams_question', 'question17', 'kn', 'ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸುವಾಗ ಬರಬಹುದಾದ ತೊಂದರೆಗಳ ಬಗ್ಗೆ ಯೋಚಿಸಿದ್ದೀರಾ? ಹಾಗಿದ್ದರೆ, ಅವು ಯಾವುವು?', NOW()),
('dreams_question', 'question18', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಕಲಿಯುತ್ತಿರುವ ವಿಷಯಗಳು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತವೆ ಎಂದು ನೀವು ಭಾವಿಸುತ್ತೀರಾ? ಹಾಗಿದ್ದರೆ, ಹೇಗೆ?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 3. SCHOOL LEARNING ASSESSMENT - Simplified Kannada Questions (21 questions)
-- ============================================================================
-- Note: School Learning has 21 questions across 5 sections
-- These are synced from school_learning_questions table
-- Adding simplified Kannada translations here
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: School Experience (Questions 1-4)
('school_question', 'question1', 'kn', 'ನೀವು ಶಾಲೆಗೆ ಬರಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ಏಕೆ?', NOW()),
('school_question', 'question2', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಏನು ಕಲಿಯಲು ಇಷ್ಟಪಡುತ್ತೀರಿ?', NOW()),
('school_question', 'question3', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ಕಲಿಯಲು ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ಕಾರಣಗಳು ಯಾವುವು?', NOW()),
('school_question', 'question4', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮ್ಮ ಉತ್ತಮ ಸ್ನೇಹಿತರು ಯಾರು? ಅವರು ನಿಮ್ಮ ಉತ್ತಮ ಸ್ನೇಹಿತರಾಗಲು ಏನು ಮಾಡಿದರು?', NOW()),

-- Section 2: Subjects & Learning Preferences (Questions 5-8)
('school_question', 'question5', 'kn', 'ನಿಮಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳು ಯಾವುವು?', NOW()),
('school_question', 'question6', 'kn', 'ಈ ವಿಷಯಗಳು ನಿಮಗೆ ಇಷ್ಟವಾಗಲು ಏನು ಮಾಡಿದೆ?', NOW()),
('school_question', 'question7', 'kn', 'ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ವಿಷಯಗಳು ಯಾವುವು?', NOW()),
('school_question', 'question8', 'kn', 'ಈ ವಿಷಯಗಳಲ್ಲಿ ನಿಮಗೆ ಇಷ್ಟವಿಲ್ಲದ ಕಾರಣ ಏನು? ಈ ವಿಷಯಗಳನ್ನು ಕಲಿಯುವಾಗ ನಿಮಗೆ ಯಾವ ತೊಂದರೆಗಳು ಬರುತ್ತವೆ?', NOW()),

-- Section 3: Academic Performance & Learning Methods (Questions 9-12)
('school_question', 'question9', 'kn', 'ಯಾವ ವಿಷಯಗಳಲ್ಲಿ ನೀವು ಚೆನ್ನಾಗಿ ಅಂಕಗಳನ್ನು ಪಡೆಯುತ್ತೀರಿ?', NOW()),
('school_question', 'question10', 'kn', 'ಯಾವ ವಿಷಯಗಳಲ್ಲಿ ನಿಮಗೆ ಹೆಚ್ಚು ಅಂಕಗಳನ್ನು ಪಡೆಯಲು ಕಷ್ಟವಾಗುತ್ತದೆ?', NOW()),
('school_question', 'question11', 'kn', 'ಕೆಳಗಿನಲ್ಲಿ ನಿಮಗೆ ಇಷ್ಟವಾದ ಕಲಿಕೆಯ ವಿಧಾನಗಳನ್ನು ಗುರುತಿಸಿ: (a) ವೀಡಿಯೊ ನೋಡುವುದು (b) ಓದುವುದು (c) ಕೇಳುವುದು (d) ಪ್ರಯೋಗ ಮಾಡುವುದು (e) ಚರ್ಚೆ ಮಾಡುವುದು (f) ಗುಂಪು ಚರ್ಚೆ (g) ಬರೆಯುವುದು (h) ಓದಿ ನೆನಪಿಟ್ಟುಕೊಳ್ಳುವುದು (i) ಇತರರಿಗೆ ಕಲಿಸುವುದು (j) ಬೇರೆ ವಿಧಾನ', NOW()),
('school_question', 'question12', 'kn', 'ನೀವು ಒಂಟಿಯಾಗಿ ಅಥವಾ ಗುಂಪಿನಲ್ಲಿ ಓದಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ಏಕೆ?', NOW()),

-- Section 4: School Relationships & Experiences (Questions 13-16)
('school_question', 'question13', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮ್ಮ ಸ್ನೇಹಿತರಿಂದ ನೀವು ಏನು ಕಲಿಯುತ್ತೀರಿ? ಇತ್ತೀಚೆಗೆ ನೀವು ಏನು ಕಲಿತಿದ್ದೀರಿ?', NOW()),
('school_question', 'question14', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ಶೈಕ್ಷಣಿಕ ವಿಷಯಗಳ ಹೊರತಾಗಿ ನಿಮಗೆ ಇಷ್ಟವಾದ ವಿಷಯಗಳು ಯಾವುವು?', NOW()),
('school_question', 'question15', 'kn', 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಶಿಕ್ಷಕರು ಯಾರು? ಏಕೆ? ಈ ಶಿಕ್ಷಕರು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಿದ್ದಾರೆ?', NOW()),
('school_question', 'question16', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನಿಮಗೆ ಯಶಸ್ಸು ಅಥವಾ ಹೆಮ್ಮೆ ತಂದಿದ್ದ ಘಟನೆ ಯಾವುದು? ಅದು ಏನು?', NOW()),

-- Section 5: Future & Reflection (Questions 17-21)
('school_question', 'question17', 'kn', 'ಶಾಲೆಯಲ್ಲಿ ನೀವು ಕಲಿತ ವಿಷಯಗಳು ನಿಮ್ಮ ಕನಸುಗಳನ್ನು ಸಾಧಿಸಲು ಹೇಗೆ ಸಹಾಯ ಮಾಡುತ್ತವೆ?', NOW()),
('school_question', 'question18', 'kn', 'ನಿಮ್ಮ ಶಾಲೆಯಲ್ಲಿ ನೀವು ಬದಲಾಯಿಸಲು ಬಯಸುವ ಒಂದು ವಿಷಯ ಯಾವುದು? ಏಕೆ?', NOW()),
('school_question', 'question19', 'kn', 'ನೀವು ಅಭ್ಯಾಸ ಮಾಡಲು ಬೇರೆ ಸ್ಥಳವಿದೆಯೇ? ಅದು ಏಕೆ ಬೇಕು?', NOW()),
('school_question', 'question20', 'kn', 'ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಕಲಿಯುವುದರಲ್ಲಿ ಶಾಲೆಯು ಮುಖ್ಯವಾದದ್ದೇ? ನಿಮ್ಮ ಅಭಿಪ್ರಾಯ ಬರೆಯಿರಿ.', NOW()),
('school_question', 'question21', 'kn', 'ನೀವು ನಿಮ್ಮ ತಂದೆತಾಯಿಗಳೊಂದಿಗೆ ಶಾಲೆಯ ಕೆಲಸಗಳು ಮತ್ತು ನೀವು ಕಲಿತ ವಿಷಯಗಳ ಬಗ್ಗೆ ಮಾತನಾಡಲು ಇಷ್ಟಪಡುತ್ತೀರಾ? ನೀವು ಏನು ಮಾತನಾಡುತ್ತೀರಿ?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 4. HOBBIES ASSESSMENT - Simplified Kannada Questions (14 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Hobbies & Interests (Questions 1-7)
('hobbies_question', 'question1', 'kn', 'ನಿಮ್ಮ ಖಾಲಿ ಸಮಯದಲ್ಲಿ ನೀವು ಏನು ಮಾಡುತ್ತೀರಿ?', NOW()),
('hobbies_question', 'question2', 'kn', 'ನಿಮಗೆ ಯಾವುದಾದರೂ ಹವ್ಯಾಸಗಳಿವೆಯೇ? ನಿಮ್ಮಲ್ಲಿ ಇರುವ ಒಳ್ಳೆಯ ಅಭ್ಯಾಸಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.', NOW()),
('hobbies_question', 'question3', 'kn', 'ಮೇಲಿನ ಪಟ್ಟಿಯಲ್ಲಿ ನಿಮಗೆ ಇಷ್ಟವಾದುದು ಯಾವುದು? ಏಕೆ?', NOW()),
('hobbies_question', 'question4', 'kn', 'ನೀವು ನಿಮ್ಮ ಹವ್ಯಾಸಗಳನ್ನು ಬದಲಾಯಿಸಿದ್ದೀರಾ?', NOW()),
('hobbies_question', 'question5', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳಿಗೆ ಏನು ಪ್ರೇರಣೆ ನೀಡಿದೆ? ನಿಮ್ಮ ಜೀವನದಲ್ಲಿ ಯಾರಾದರೂ ನಿಮಗೆ ಈ ಹವ್ಯಾಸಗಳನ್ನು ಕಲಿಸಿದ್ದಾರೆಯೇ?', NOW()),
('hobbies_question', 'question6', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳುವ ನಿಮ್ಮ ಸುತ್ತಲಿನ ಜನರು ಯಾರು?', NOW()),
('hobbies_question', 'question7', 'kn', 'ನಿಮ್ಮ ನೆಚ್ಚಿನ ಹವ್ಯಾಸವನ್ನು ಮಾಡುವಾಗ ನೀವು ಹೇಗೆ ಭಾವಿಸುತ್ತೀರಿ? ಅದು ನಿಮಗೆ ವಿಶ್ರಾಂತಿ ನೀಡುತ್ತದೆಯೇ ಅಥವಾ ಆತ್ಮವಿಶ್ವಾಸ ನೀಡುತ್ತದೆಯೇ?', NOW()),

-- Section 2: Talents & Practice (Questions 8-10)
('hobbies_question', 'question8', 'kn', 'ನಿಮ್ಮ ಪ್ರತಿಭೆಗಳನ್ನು ಪಟ್ಟಿ ಮಾಡಿ.', NOW()),
('hobbies_question', 'question9', 'kn', 'ನಿಮ್ಮ ಪ್ರತಿಭೆಯನ್ನು ಚೆನ್ನಾಗಿ ಮಾಡಲು ನೀವು ಅಭ್ಯಾಸ ಮಾಡುತ್ತೀರಾ? ಹಾಗಿದ್ದರೆ, ಹೇಗೆ?', NOW()),
('hobbies_question', 'question10', 'kn', 'ನಿಮ್ಮ ಹವ್ಯಾಸಗಳು ಮತ್ತು ಪ್ರತಿಭೆಗಳನ್ನು ಮನೆಯಲ್ಲಿ, ಶಾಲೆಯಲ್ಲಿ ಅಥವಾ ಬೇರೆಡೆ ಅಭ್ಯಾಸ ಮಾಡಲು ನಿಮಗೆ ಅವಕಾಶ ಸಿಗುತ್ತದೆಯೇ? ಅವುಗಳನ್ನು ತೋರಿಸಲು ಅವಕಾಶ ಸಿಗುತ್ತದೆಯೇ?', NOW()),

-- Section 3: Support & Career Connection (Questions 11-14)
('hobbies_question', 'question11', 'kn', 'ನಿಮ್ಮ ಪ್ರತಿಭೆಗಳು ಮತ್ತು ಹವ್ಯಾಸಗಳನ್ನು ಬೆಳೆಸಲು ನಿಮ್ಮ ತಂದೆತಾಯಿಗಳು ನಿಮಗೆ ಸಹಾಯ ಮಾಡುತ್ತಾರೆಯೇ? ಹೇಗೆ?', NOW()),
('hobbies_question', 'question12', 'kn', 'ನಿಮ್ಮ ನೈಸರ್ಗಿಕ ಪ್ರತಿಭೆಗಳೊಂದಿಗೆ ಹೊಂದಿಕೊಳ್ಳುವ ಹವ್ಯಾಸಗಳು ನಿಮಗೆ ಇವೆಯೇ?', NOW()),
('hobbies_question', 'question13', 'kn', 'ಭವಿಷ್ಯದಲ್ಲಿ ವೃತ್ತಿಯಾಗಿ ಮಾಡಬಹುದಾದ ಹವ್ಯಾಸಗಳು ನಿಮಗೆ ಇವೆಯೇ? ಹಾಗಿದ್ದರೆ, ಈ ಹವ್ಯಾಸಗಳನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಲು ಏನು ಮಾಡಬೇಕು?', NOW()),
('hobbies_question', 'question14', 'kn', 'ತಮ್ಮ ಹವ್ಯಾಸಗಳನ್ನು ಅಥವಾ ಆಸಕ್ತಿಗಳನ್ನು ವೃತ್ತಿಯಾಗಿ ಮಾಡಿದ ನಿಮಗೆ ತಿಳಿದಿರುವ ಜನರು ಯಾರು? ಅವರು ಯಾವ ಹವ್ಯಾಸ ಮತ್ತು ಹೇಗೆ ಮಾಡಿದರು?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
    dreams_kn_count INTEGER;
    school_kn_count INTEGER;
    hobbies_kn_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO dreams_kn_count
    FROM content_translations
    WHERE resource_type = 'dreams_question' AND lang = 'kn';
    
    SELECT COUNT(*) INTO school_kn_count
    FROM content_translations
    WHERE resource_type = 'school_question' AND lang = 'kn';
    
    SELECT COUNT(*) INTO hobbies_kn_count
    FROM content_translations
    WHERE resource_type = 'hobbies_question' AND lang = 'kn';
    
    RAISE NOTICE 'Simplified Kannada Translations Added:';
    RAISE NOTICE 'Dreams: % questions', dreams_kn_count;
    RAISE NOTICE 'School Learning: % questions', school_kn_count;
    RAISE NOTICE 'Hobbies: % questions', hobbies_kn_count;
    
    IF dreams_kn_count >= 18 AND school_kn_count >= 21 AND hobbies_kn_count >= 14 THEN
        RAISE NOTICE '✅ All simplified Kannada translations added successfully!';
    ELSE
        RAISE WARNING '⚠️ Some translations may be missing. Check counts above.';
    END IF;
END $$;

