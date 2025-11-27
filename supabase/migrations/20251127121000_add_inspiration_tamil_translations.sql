-- Migration: Add Tamil Translations for Inspiration Assessment
-- Simple, student-friendly Tamil for grade 8 level

-- ============================================================================
-- INSPIRATION ASSESSMENT - Tamil Questions (9 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question 1
('inspiration_question', 'question1', 'ta', 'இந்த வீடியோ/ஆடியோவில் உங்களுக்கு மிகவும் பிடித்தது அல்லது அதிகம் உங்களை ஊக்கப்படுத்தியது எந்த பகுதி?', NOW()),
-- Question 2
('inspiration_question', 'question2', 'ta', 'இந்த வீடியோ/ஆடியோவிலிருந்து நீங்கள் எந்த நல்ல குணங்களையும் மதிப்புகளையும் கற்றுக் கொள்ளலாம்?', NOW()),
-- Question 3
('inspiration_question', 'question3', 'ta', 'இந்த வீடியோ/ஆடியோவில் இருக்கும் எந்த குணங்கள் அல்லது மதிப்புகளை உங்கள் வாழ்க்கையில் சேர்க்க விருப்பப்படுகிறீர்கள்?', NOW()),
-- Question 4
('inspiration_question', 'question4', 'ta', 'இந்த வீடியோக்கள்/ஆடியோக்களில் இருக்கும் எந்த முக்கிய அம்சங்கள் அல்லது கருத்துகள் உங்கள் வாழ்க்கையில் நல்ல மாற்றத்தை கொண்டு வர உதவலாம்?', NOW()),
-- Question 5
('inspiration_question', 'question5', 'ta', 'இந்த வீடியோக்களில் வரும் எந்த கதாபாத்திரத்துடன் நீங்கள் உங்களையே ஒப்பிட்டுக் கொண்டீர்களா? இருந்தால், எந்த கதாபாத்திரம்? ஏன் அந்த கதாபாத்திரம் உங்களுக்கு நெருக்கமாக தோன்றியது?', NOW()),
-- Question 6
('inspiration_question', 'question6', 'ta', 'இந்த வீடியோ/ஆடியோவில் நீங்கள் விரும்பிய மதிப்புகள் அல்லது குணங்களை நீங்கள் உங்கள் வாழ்க்கையில் எப்போதாவது காட்டியிருக்கிறீர்களா? சுருக்கமாக ஒரு உதாரணத்தை எழுதுங்கள்.', NOW()),
-- Question 7
('inspiration_question', 'question7', 'ta', 'இந்த வீடியோ/ஆடியோவில் உங்களை மிகவும் உற்சாகப்படுத்திய அல்லது சிந்திக்க வைத்த பகுதியைப் பற்றி எழுதுங்கள்.', NOW()),
-- Question 8
('inspiration_question', 'question8', 'ta', 'உங்கள் வாழ்க்கையில் இந்த வீடியோக்களில் உள்ள கதாபாத்திரங்களைப் போல உங்களை ஊக்கப்படுத்திய ஒருவர் அல்லது ஒரு நிகழ்வு உங்களுக்கு நினைவுக்கு வருகிறதா? இருந்தால், அதைச் சுருக்கமாக எழுதுங்கள்.', NOW()),
-- Question 9
('inspiration_question', 'question9', 'ta', 'இந்த வீடியோக்கள்/ஆடியோ குறித்து நீங்கள் கூடுதலாக பகிர்ந்து கொள்ள விரும்பும் ஏதேனும் மற்ற எண்ணங்கள் அல்லது உணர்வுகள் உள்ளனவா?', NOW())

ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- INSPIRATION ASSESSMENT - Tamil Help Text (9 questions)
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Question 1
('inspiration_help', 'question1', 'ta', 'உங்களுக்கு பிடித்த அல்லது உங்களுக்கு ஊக்கம் தந்த குறிப்பிட்ட தருணங்கள், உரைகள், காட்சிகள் அல்லது செய்திகளை நினைத்துப் பாருங்கள்.', NOW()),
-- Question 2
('inspiration_help', 'question2', 'ta', 'வீடியோ/ஆடியோவில் காட்டப்பட்ட நல்ல குணங்கள், மதிப்புகள், நெறிமுறைகள் போன்றவற்றை அடையாளம் கண்டு எழுதுங்கள்.', NOW()),
-- Question 3
('inspiration_help', 'question3', 'ta', 'வீடியோ/ஆடியோவில் இருந்து நீங்கள் உங்கள் தினசரி வாழ்க்கையில் பழக விரும்பும் அல்லது வளர்த்துக் கொள்ள விரும்பும் குணங்கள், மதிப்புகள் பற்றி யோசிக்கவும்.', NOW()),
-- Question 4
('inspiration_help', 'question4', 'ta', 'இந்த உள்ளடக்கத்தில் இருந்து உங்கள் வளர்ச்சி, முன்னேற்றம் அல்லது நல்ல மாற்றங்களுக்கு உதவக்கூடிய யோசனைகள், வழிகள் அல்லது முக்கிய குறிப்புகளை எழுதுங்கள்.', NOW()),
-- Question 5
('inspiration_help', 'question5', 'ta', 'உங்களுக்கு நெருக்கமாக உணரப்பட்ட கதாபாத்திரங்கள் யார், அவர்கள் போல நீங்கள் ஏன் உணர்ந்தீர்கள், உங்களுக்கும் அவர்களுக்கும் உள்ள ஒற்றுமைகள் என்ன என்பதை எழுதுங்கள்.', NOW()),
-- Question 6
('inspiration_help', 'question6', 'ta', 'வீடியோவில் நீங்கள் விரும்பிய மதிப்புகள் அல்லது குணங்களை நீங்கள் உங்கள் உண்மையான வாழ்க்கையில் காட்டிய ஒரு சம்பவத்தை/நிகழ்வை சுருக்கமாக எழுதுங்கள்.', NOW()),
-- Question 7
('inspiration_help', 'question7', 'ta', 'வீடியோ/ஆடியோவில் இருந்து நீங்கள் கற்றுக் கொண்டதின் அடிப்படையில், அந்த நிலைமையில் நீங்கள் இருந்தால் எப்படி நடந்திருப்பீர்கள், என்ன செயலில் இறங்கியிருப்பீர்கள் என்று கற்பனை செய்து எழுதுங்கள்.', NOW()),
-- Question 8
('inspiration_help', 'question8', 'ta', 'உங்கள் வாழ்க்கையில் உங்களை இதே மாதிரி ஊக்கப்படுத்தியவர்கள், அனுபவங்கள் அல்லது சிறப்பு தருணங்கள் என்ன? அவை ஏன் உங்களுக்கு முக்கியமாக உணர்ந்தது என்பதை எழுதுங்கள்.', NOW()),
-- Question 9
('inspiration_help', 'question9', 'ta', 'இந்த வீடியோக்கள்/ஆடியோ பற்றிய உங்கள் பிற எண்ணங்கள், கவனிப்புகள், உணர்வுகள் அல்லது தனிப்பட்ட அனுபவங்களை சுதந்திரமாக பகிர்ந்து எழுதுங்கள்.', NOW())

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
    WHERE resource_type = 'inspiration_question' AND lang = 'ta';
    
    SELECT COUNT(*) INTO inspiration_help_count
    FROM content_translations
    WHERE resource_type = 'inspiration_help' AND lang = 'ta';
    
    RAISE NOTICE 'Tamil Translations Added for Inspiration Assessment:';
    RAISE NOTICE 'Inspiration Questions (ta): % translations', inspiration_q_count;
    RAISE NOTICE 'Inspiration Help Text (ta): % translations', inspiration_help_count;
END $$;


