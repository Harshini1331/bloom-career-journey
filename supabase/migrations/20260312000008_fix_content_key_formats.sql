-- ============================================================
-- Fix content_translations key format mismatches
-- Generated: 2026-03-18T00:42:57.812Z
-- Aligns DB keys with what components actually query.
-- ============================================================

BEGIN;

-- ============================================================
-- FIX 1: Re-insert school_learning_option rows
-- (deleted by clean slate, not in sheet dump)
-- ============================================================

INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'visual', 'en', $$Observe the experiment and explain by relating it with suitable illustrative pictures (audio-visual medium).$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'visual', 'kn', $$ವಿಡಿಯೋಗಳನ್ನು ವೀಕ್ಷಿಸುವುದು ಅಥವಾ ಚಿತ್ರಗಳ ಮೂಲಕ ತಿಳಿಯುವುದು (ದೃಶ್ಯ ಮಾಧ್ಯಮ)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'visual', 'ta', $$வீடியோக்களைப் பார்ப்பது அல்லது படங்களின் மூலம் புரிந்துகொள்வது (காட்சி முறை)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'visual', 'hi', $$वीडियो देखकर या चित्रों के माध्यम से समझना (दृश्य-श्रव्य माध्यम)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'audio', 'en', $$Oral explanation (audio medium).$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'audio', 'kn', $$ವಿವರಣೆಗಳನ್ನು ಆಲಿಸುವುದು (ಶ್ರವಣ ಮಾಧ್ಯಮ)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'audio', 'ta', $$விளக்கங்களைக் கேட்டுப் புரிந்துகொள்வது (ஒலி முறை)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'audio', 'hi', $$मौखिक व्याख्या सुनकर सीखना (श्रवण माध्यम)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'experimenting', 'en', $$Learning through experiment / experiential learning.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'experimenting', 'kn', $$ಪ್ರಯೋಗ ಅಥವಾ ಚಟುವಟಿಕೆಗಳ ಮೂಲಕ ಕಲಿಯುವುದು (ಅನುಭವಾತ್ಮಕ)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'experimenting', 'ta', $$சோதனைகள் அல்லது செய்முறைப் பயிற்சிகள் மூலம் கற்றல் (அனுபவ முறை)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'experimenting', 'hi', $$प्रयोग या गतिविधियों के माध्यम से सीखना (अनुभवात्मक)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'discuss', 'en', $$Discussion / Reasoning.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'discuss', 'kn', $$ವಿಷಯಗಳ ಬಗ್ಗೆ ಚರ್ಚಿಸುವುದು ಅಥವಾ ತಾರ್ಕಿಕವಾಗಿ ಯೋಚಿಸುವುದು$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'discuss', 'ta', $$கருத்துகளை விவாதிப்பது அல்லது தர்க்கரீதியாகச் சிந்திப்பது$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'discuss', 'hi', $$चर्चा करना या तर्कसंगत ढंग से सोचना$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'groupDiscussions', 'en', $$Group discussion.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'groupDiscussions', 'kn', $$ಸ್ನೇಹಿತರೊಂದಿಗೆ ಗುಂಪು ಚರ್ಚೆ ಮಾಡುವುದು$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'groupDiscussions', 'ta', $$நண்பர்களுடன் குழுவாக விவாதிப்பது$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'groupDiscussions', 'hi', $$मित्रों के साथ समूह चर्चा करना$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'presentation', 'en', $$Presentation.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'presentation', 'kn', $$ಪ್ರಸ್ತುತಿ ಮಾಡುವುದು$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'presentation', 'ta', $$கருத்தரங்கு வழங்குதல்$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'presentation', 'hi', $$प्रस्तुतिकरण (प्रेज़ेंटेशन)$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'rolePlay', 'en', $$Oral practice through role play.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'rolePlay', 'kn', $$ಪಾತ್ರಾಭಿನಯದ ಮೂಲಕ ಮೌಖಿಕ ಅಭ್ಯಾಸ$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'rolePlay', 'ta', $$பாத்திர நடிப்பு மூலம் பேச்சுப் பயிற்சி$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'rolePlay', 'hi', $$भूमिका अभिनय के माध्यम से मौखिक अभ्यास$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'teaching', 'en', $$I learn by teaching others.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'teaching', 'kn', $$ಇತರರಿಗೆ ಕಲಿಸುವ ಮೂಲಕ ಅಥವಾ ವಿವರಿಸುವ ಮೂಲಕ ಕಲಿಯುವುದು$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'teaching', 'ta', $$மற்றவர்களுக்குக் கற்பிப்பதன் மூலம் அல்லது விளக்குவதன் மூலம் கற்றல்$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'teaching', 'hi', $$दूसरों को सिखाकर या समझाकर सीखना$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'other', 'en', $$Any other method that applies to you.$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'other', 'kn', $$ನಿಮಗೆ ಅನ್ವಯಿಸುವ ಬೇರೆ ಯಾವುದೇ ವಿಧಾನ$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'other', 'ta', $$உங்களுக்குப் பொருந்தும் வேறு ஏதேனும் முறை$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('school_learning_option', 'other', 'hi', $$आप पर लागू होने वाली कोई अन्य विधि$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;

-- ============================================================
-- FIX 2: Role Models questions — resource_type needs trailing "s"
-- Component queries role_models_questions (plural)
-- ============================================================

UPDATE content_translations
SET resource_type = 'role_models_questions'
WHERE resource_type = 'role_models_question';

-- Role Models question keys: question_N → rm_qN
UPDATE content_translations SET resource_key = 'rm_q1'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'rm_q2'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'rm_q3'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'rm_q4'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'rm_q5'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'rm_q6'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'rm_q7'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'rm_q8'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'rm_q9'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'rm_q10'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'rm_q11'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'rm_q12'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'rm_q13'
WHERE resource_type = 'role_models_questions' AND resource_key = 'question_13';

-- Role Models help keys: question_N → rm_help_qN
UPDATE content_translations SET resource_key = 'rm_help_q1'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'rm_help_q2'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'rm_help_q3'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'rm_help_q4'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'rm_help_q5'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'rm_help_q6'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'rm_help_q7'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'rm_help_q8'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'rm_help_q9'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'rm_help_q10'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'rm_help_q11'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'rm_help_q12'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'rm_help_q13'
WHERE resource_type = 'role_models_help' AND resource_key = 'question_13';

-- ============================================================
-- FIX 3: Role Models module — add tab labels
-- Sheet only has RM1 section title. RM2/RM3 derived by number.
-- ============================================================

INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm1', 'en', $$Role Model - 1$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm1', 'kn', $$ಮಾದರಿ ವ್ಯಕ್ತಿ - 1$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm1', 'ta', $$முன்மாதிரி - 1$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm1', 'hi', $$प्रेरणास्रोत - 1$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm2', 'en', $$Role Model - 2$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm2', 'kn', $$ಮಾದರಿ ವ್ಯಕ್ತಿ - 2$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm2', 'ta', $$முன்மாதிரி - 2$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm2', 'hi', $$प्रेरणास्रोत - 2$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm3', 'en', $$Role Model - 3$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm3', 'kn', $$ಮಾದರಿ ವ್ಯಕ್ತಿ - 3$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm3', 'ta', $$முன்மாதிரி - 3$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('role_models_module', 'tab_rm3', 'hi', $$प्रेरणास्रोत - 3$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;

-- ============================================================
-- FIX 4: About Me sections — move to about_me_module resource_type
-- and rename section_1_title → section_a_title, etc.
-- ============================================================

UPDATE content_translations
SET resource_type = 'about_me_module'
WHERE resource_type = 'about_me_section';

UPDATE content_translations SET resource_key = 'section_a_title'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_1_title';
UPDATE content_translations SET resource_key = 'section_b_title'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_2_title';
UPDATE content_translations SET resource_key = 'section_c_title'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_3_title';
UPDATE content_translations SET resource_key = 'section_d_title'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_4_title';
UPDATE content_translations SET resource_key = 'section_a_subtitle'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_1_subtitle';
UPDATE content_translations SET resource_key = 'section_b_subtitle'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_2_subtitle';
UPDATE content_translations SET resource_key = 'section_c_subtitle'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_3_subtitle';
UPDATE content_translations SET resource_key = 'section_d_subtitle'
WHERE resource_type = 'about_me_module' AND resource_key = 'section_4_subtitle';

-- ============================================================
-- FIX 5: Dreams module — add "quote" key from sheet title_text
-- ============================================================

INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('dreams_module', 'quote', 'kn', $$“ನೀವು ನಿದ್ರೆ ಮಾಡುವಾಗ ಕಾಣುವುದು ಕನಸಲ್ಲ, ಯಾವ ಕನಸು ನಿಮ್ಮನ್ನು ನಿದ್ರಿಸಲು ಬಿಡುವುದಿಲ್ಲವೋ ಅದೇ ನಿಜವಾದ ಕನಸು.” - ಡಾ. ಎ. ಪಿ. ಜೆ. ಅಬ್ದುಲ್ ಕಲಾಮ್$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('dreams_module', 'quote', 'ta', $$“தூக்கத்தில் வருவதல்ல கனவு; உன்னைத் தூங்கவிடாமல் செய்வதே கனவு.” - டாக்டர் ஏ.பி.ஜே. அப்துல் கலாம்$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('dreams_module', 'quote', 'en', $$“Dream is not that which you see while sleeping, it is something that does not let you sleep.” - Dr. A.P.J. Abdul Kalam$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;
INSERT INTO content_translations (resource_type, resource_key, lang, text)
VALUES ('dreams_module', 'quote', 'hi', $$"सपना वह नहीं है जो आप नींद में देखते हैं, सपना वह है जो आपको सोने नहीं देता।"
— डॉ. ए. पी. जे. अब्दुल कलाम$$)
ON CONFLICT (resource_type, resource_key, lang) DO UPDATE SET text = EXCLUDED.text;

-- ============================================================
-- FIX 6: Remove underscores in question/help/summary keys
-- Components expect questionN not question_N
-- ============================================================

UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'inspiration_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'inspiration_help' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'school_learning_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'school_learning_help' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'dreams_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'dreams_help' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'hobbies_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'hobbies_help' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'about_me_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'about_me_help' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'question_30';
UPDATE content_translations SET resource_key = 'question1'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_1';
UPDATE content_translations SET resource_key = 'question2'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_2';
UPDATE content_translations SET resource_key = 'question3'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_3';
UPDATE content_translations SET resource_key = 'question4'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_4';
UPDATE content_translations SET resource_key = 'question5'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_5';
UPDATE content_translations SET resource_key = 'question6'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_6';
UPDATE content_translations SET resource_key = 'question7'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_7';
UPDATE content_translations SET resource_key = 'question8'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_8';
UPDATE content_translations SET resource_key = 'question9'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_9';
UPDATE content_translations SET resource_key = 'question10'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_10';
UPDATE content_translations SET resource_key = 'question11'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_11';
UPDATE content_translations SET resource_key = 'question12'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_12';
UPDATE content_translations SET resource_key = 'question13'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_13';
UPDATE content_translations SET resource_key = 'question14'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_14';
UPDATE content_translations SET resource_key = 'question15'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_15';
UPDATE content_translations SET resource_key = 'question16'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_16';
UPDATE content_translations SET resource_key = 'question17'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_17';
UPDATE content_translations SET resource_key = 'question18'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_18';
UPDATE content_translations SET resource_key = 'question19'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_19';
UPDATE content_translations SET resource_key = 'question20'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_20';
UPDATE content_translations SET resource_key = 'question21'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_21';
UPDATE content_translations SET resource_key = 'question22'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_22';
UPDATE content_translations SET resource_key = 'question23'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_23';
UPDATE content_translations SET resource_key = 'question24'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_24';
UPDATE content_translations SET resource_key = 'question25'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_25';
UPDATE content_translations SET resource_key = 'question26'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_26';
UPDATE content_translations SET resource_key = 'question27'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_27';
UPDATE content_translations SET resource_key = 'question28'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_28';
UPDATE content_translations SET resource_key = 'question29'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_29';
UPDATE content_translations SET resource_key = 'question30'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'question_30';

-- Fix summary_question_N → summary_questionN (summary question keys)
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'inspiration_summary_question' AND resource_key = 'summary_question_20';
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'about_me_summary_question' AND resource_key = 'summary_question_20';
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'dreams_summary_question' AND resource_key = 'summary_question_20';
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'school_learning_summary_question' AND resource_key = 'summary_question_20';
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'hobbies_summary_question' AND resource_key = 'summary_question_20';
UPDATE content_translations SET resource_key = 'summary_question1'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_1';
UPDATE content_translations SET resource_key = 'summary_question2'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_2';
UPDATE content_translations SET resource_key = 'summary_question3'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_3';
UPDATE content_translations SET resource_key = 'summary_question4'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_4';
UPDATE content_translations SET resource_key = 'summary_question5'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_5';
UPDATE content_translations SET resource_key = 'summary_question6'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_6';
UPDATE content_translations SET resource_key = 'summary_question7'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_7';
UPDATE content_translations SET resource_key = 'summary_question8'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_8';
UPDATE content_translations SET resource_key = 'summary_question9'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_9';
UPDATE content_translations SET resource_key = 'summary_question10'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_10';
UPDATE content_translations SET resource_key = 'summary_question11'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_11';
UPDATE content_translations SET resource_key = 'summary_question12'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_12';
UPDATE content_translations SET resource_key = 'summary_question13'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_13';
UPDATE content_translations SET resource_key = 'summary_question14'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_14';
UPDATE content_translations SET resource_key = 'summary_question15'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_15';
UPDATE content_translations SET resource_key = 'summary_question16'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_16';
UPDATE content_translations SET resource_key = 'summary_question17'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_17';
UPDATE content_translations SET resource_key = 'summary_question18'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_18';
UPDATE content_translations SET resource_key = 'summary_question19'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_19';
UPDATE content_translations SET resource_key = 'summary_question20'
WHERE resource_type = 'role_models_summary_question' AND resource_key = 'summary_question_20';

COMMIT;
