-- Migration: Add Tamil Translations for All Assessments (Except Inspiration, which has its own file)
-- Language: ta (Tamil)
-- Style: Simple, clear Tamil for rural grade 8 students.
-- NOTE:
--  - Question text is translated; help text is kept in English for now (fallback).
--  - Frontend for some assessments (Dreams, Hobbies, About Me, Role Models) already uses
--    lang-aware RPCs, so these questions will immediately appear in Tamil when lang='ta'.
--  - For others (School Learning, Career Guidance, Holland), these translations prepare
--    the data model; wiring UI can be done with a small frontend change later.

-- ============================================================================
-- 1. DREAMS ASSESSMENT - Tamil Questions (18 questions)
--    resource_type: 'dreams_question', resource_key: 'question1'..'question18'
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Your Dreams & Future Goals
('dreams_question', 'question1', 'ta', 'உங்கள் எதிர்காலத்தைப் பற்றி உங்கள் கனவுகள் என்ன?', NOW()),
('dreams_question', 'question2', 'ta', 'படிப்பில் உங்கள் இலக்குகள் என்ன? நீங்கள் என்ன கற்றுக்கொள்ள விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question3', 'ta', 'எந்த வேலை/தொழிலில் நீங்கள் செல்ல வேண்டுமென்று கனவு காண்கிறீர்கள்?', NOW()),
('dreams_question', 'question4', 'ta', 'நீங்கள் தொழில்முறை அளவில் எந்த விளையாட்டை விளையாட விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question5', 'ta', 'நீங்கள் எழுத்தாளராக இருந்தால், எந்த வகை எழுத்தை செய்ய விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question6', 'ta', 'இசையில் நீங்கள் எந்த துறையை அதிகம் கற்றுக்கொள்ள விரும்புகிறீர்கள்? (பாடல் / வாத்தியம்)', NOW()),

-- Section 2: Career & Life Aspirations
('dreams_question', 'question7', 'ta', 'நீங்கள் செல்ல விரும்பும் கல்லூரி எது?', NOW()),
('dreams_question', 'question8', 'ta', 'நீங்கள் மற்றவர்களுக்கு அல்லது சமுதாயத்திற்கு சேவை செய்ய வேண்டுமென்றால், யாருக்கு அல்லது எந்த காரணத்திற்காகச் சேவை செய்ய விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question9', 'ta', 'உலகத்தில் எங்கே வேண்டுமானாலும் வாழ வாய்ப்பு கிடைத்தால், நீங்கள் எங்கே வாழ விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question10', 'ta', 'நீங்கள் ஒருவரைப் போல கலைஞராக இருந்தால், எந்த வகை கலை செய்ய விரும்புகிறீர்கள்?', NOW()),
('dreams_question', 'question11', 'ta', 'உங்களுக்கு பயணம் செல்ல விருப்பமா? இருந்தால், பயணத்தில் உங்களுக்கு மிகவும் பிடித்தது என்ன?', NOW()),
('dreams_question', 'question12', 'ta', 'ஒரு நாளுக்கு யாருடன் சேர்ந்து கற்றுக்கொள்ள விரும்புகிறீர்கள்? ஏன்?', NOW()),

-- Section 3: Making Dreams Reality
('dreams_question', 'question13', 'ta', 'உங்கள் கனவுகளை நிஜமாக்க வேண்டும் என்று நீங்கள் விரும்புகிறீர்களா?', NOW()),
('dreams_question', 'question14', 'ta', 'உங்கள் கனவுகளை நிஜமாக்க என்ன என்ன விஷயங்கள் தேவை என்று நீங்கள் நினைக்கிறீர்கள்? (ஒரு கனவை எடுத்துக் கொண்டு எழுதி விளக்கவும்)', NOW()),
('dreams_question', 'question15', 'ta', 'உங்கள் கனவுகளை நனவாக்க நீங்கள் முதலில் எத்தனை படிகளை எடுக்கப் போகிறீர்கள்?', NOW()),
('dreams_question', 'question16', 'ta', 'உங்கள் கனவுகளை அடைய உங்களுக்கு நல்ல மனநிலை மற்றும் ஊக்கமுண்டு என்று நீங்கள் நம்புகிறீர்களா?', NOW()),
('dreams_question', 'question17', 'ta', 'உங்கள் கனவுகளை அடையும் வழியில் எப்படிப்பட்ட தடைகள் அல்லது சிரமங்கள் வந்தாலும் இருக்கலாம் என்று நீங்கள் யோசித்துள்ளீர்களா? இருந்தால் அவை என்ன?', NOW()),
('dreams_question', 'question18', 'ta', 'நீங்கள் தற்போது பள்ளியில் கற்றுக் கொண்டிருக்கும் கல்வி மற்றும் அறிவு, உங்கள் கனவுகளை அடைய உதவும் என்று நினைக்கிறீர்களா? இருந்தால் எப்படி?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- 2. SCHOOL LEARNING ASSESSMENT - Tamil Questions (21 questions)
--    resource_type: 'school_question', resource_key: 'question1'..'question21'
--    NOTE: UI currently uses hard-coded English; these translations will be
--          used once we switch labels to use i18n content.
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: School Experience (1–5)
('school_question', 'question1', 'ta', 'உங்களுக்கு பள்ளிக்கு வருவது பிடிக்கிறதா? ஏன்?', NOW()),
('school_question', 'question2', 'ta', 'பள்ளியில் நீங்கள் என்ன கற்றுக்கொள்ள விரும்புகிறீர்கள்?', NOW()),
('school_question', 'question3', 'ta', 'பள்ளியில் படிப்பது பிடிக்காமல் இருக்கக் காரணங்கள் ஏதேனும் உள்ளனவா?', NOW()),
('school_question', 'question4', 'ta', 'பள்ளியில் உங்கள் மிக நெருக்கமான நண்பர்கள் யார்? அவர்கள் எந்த குணங்கள்/அனுபவங்கள் காரணமாக உங்கள் நல்ல நண்பர்களாக இருக்கிறார்கள்?', NOW()),
('school_question', 'question5', 'ta', 'நீங்கள் கற்றுக்கொள்ள விரும்பும் பாடங்கள்/தலைப்புகள் எவை? எழுதுங்கள்.', NOW()),

-- Section 2: Learning Preferences & Challenges (6–12)
('school_question', 'question6',  'ta', 'இந்த பாடங்கள் அல்லது தலைப்புகள் உங்களை ஏன் ஈர்க்கின்றன? காரணங்களை எழுதுங்கள்.', NOW()),
('school_question', 'question7',  'ta', 'நீங்கள் கற்றுக்கொள்ள விரும்பாத பாடங்கள் எவை?', NOW()),
('school_question', 'question8',  'ta', 'மேலே குறிப்பிடப்பட்ட பாடங்களில் உங்களுக்கு குறைந்த ஆர்வம் இருப்பதற்கு காரணம் என்ன? அவற்றை கற்றுக்கொள்ளும்போது எந்த சிரமங்களை எதிர்கொள்கிறீர்கள்?', NOW()),
('school_question', 'question9',  'ta', 'நீங்கள் எத்தகைய பாடங்களில் நல்ல மதிப்பெண்கள் பெறுகிறீர்கள்?', NOW()),
('school_question', 'question10', 'ta', 'எந்த பாடங்களில் அதிக மதிப்பெண்கள் பெறுவது உங்களுக்கு கஷ்டமாக இருக்கிறது?', NOW()),
('school_question', 'question11', 'ta', 'கீழே கொடுக்கப்பட்டுள்ள எந்த வகை கற்றல் முறைகள் உங்களை அதிகம் ஈர்க்கின்றன? (உங்களுக்கு பொருந்தும் அனைத்தையும் ✔ வைத்து குறியிடுங்கள்)', NOW()),
('school_question', 'question12', 'ta', 'நீங்கள் தனியாக படிப்பதற்கு விரும்புகிறீர்களா அல்லது குழுவில் படிப்பதற்கு விரும்புகிறீர்களா? ஏன்? காரணத்தை எழுதுங்கள்.', NOW()),

-- Section 3: Learning from Others & School Life (13–16)
('school_question', 'question13', 'ta', 'நீங்கள் பள்ளியில் உங்கள் நண்பர்களிடமிருந்து கற்றுக்கொள்கிறீர்களா? சமீபத்தில் அவர்களிடமிருந்து நீங்கள் கற்றுக் கொண்ட சில விஷயங்களை எழுதுங்கள்.', NOW()),
('school_question', 'question14', 'ta', 'பாடங்களைக் காட்டிலும், பள்ளியில் உங்களுக்கு மிகவும் பிடித்த விஷயங்கள் எவை?', NOW()),
('school_question', 'question15', 'ta', 'உங்களுக்கு மிகவும் பிடித்த ஆசிரியர் யார்? ஏன்? அந்த ஆசிரியர் உங்களை எப்படி பாதித்து உதவியுள்ளார்?', NOW()),
('school_question', 'question16', 'ta', 'பள்ளியில் நீங்கள் மிகவும் வெற்றி பெற்றதாக அல்லது பெருமை பட்டதாக உணர்ந்த ஒரு நிகழ்வு இருந்ததா? அது என்ன?', NOW()),

-- Section 4: School''s Impact & Future (17–21)
('school_question', 'question17', 'ta', 'பள்ளியில் நீங்கள் கற்றுக் கொண்ட விஷயங்கள் உங்கள் கனவுகள் மற்றும் இலக்குகளை அடைய எப்படி உதவும்? விளக்குங்கள்.', NOW()),
('school_question', 'question18', 'ta', 'உங்கள் பள்ளியில் மாற்ற வேண்டும் என்று நீங்கள் விரும்பும் ஒரு விஷயம் என்ன? காரணங்களைக் குறிப்பிடுங்கள்.', NOW()),
('school_question', 'question19', 'ta', 'உங்களுக்கு படிப்பு/பயிற்சி செய்ய தனி இடம் இருக்கிறதா? இருந்தால் அது ஏன் அவசியம் என்று நினைக்கிறீர்கள்?', NOW()),
('school_question', 'question20', 'ta', 'உங்கள் வாழ்க்கையில் கற்றலுக்கு பள்ளி ஒரு முக்கிய பங்கு வகிக்கிறதா? உங்கள் கருத்தை எழுதுங்கள்.', NOW()),
('school_question', 'question21', 'ta', 'பள்ளி செயல்பாடுகள் மற்றும் நீங்கள் கற்றுக் கொண்ட விஷயங்களைப் பற்றி உங்கள் பெற்றோருடன் பேச நீங்கள் விரும்புகிறீர்களா? அவர்களுடன் எந்த விஷயங்களைப் பற்றி பேசுகிறீர்கள்?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- 3. HOBBIES ASSESSMENT - Tamil Questions (14 questions)
--    resource_type: 'hobbies_question', resource_key: 'question1'..'question14'
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section 1: Hobbies & Interests (1–7)
('hobbies_question', 'question1',  'ta', 'உங்கள் ஓய்வு நேரத்தில் (காலையிலோ மாலையிலோ) நீங்கள் எந்த வேலை/செயல்களைச் செய்கிறீர்கள்?', NOW()),
('hobbies_question', 'question2',  'ta', 'உங்களுக்கு எப்படிப்பட்ட பொழுதுபோக்குகள் உள்ளன? உங்களிடம் உள்ள நல்ல பழக்கங்களைப் பட்டியலிடுங்கள்.', NOW()),
('hobbies_question', 'question3',  'ta', 'மேலே எழுதியவற்றில் உங்களுக்கு மிகவும் பிடித்த பொழுதுபோக்கு எது? ஏன்?', NOW()),
('hobbies_question', 'question4',  'ta', 'நீங்கள் முன்பு வைத்திருந்த சில பொழுதுபோக்குகளை மாற்றியிருக்கிறீர்களா அல்லது விட்டுவிட்டீர்களா?', NOW()),
('hobbies_question', 'question5',  'ta', 'உங்கள் பொழுதுபோக்குகளுக்கு யார் அல்லது எந்த விஷயம் உங்களுக்கு ஊக்கம் அளித்தது? யாரிடமிருந்து இந்தப் பொழுதுபோக்குகளை கற்றுக்கொண்டீர்கள்?', NOW()),
('hobbies_question', 'question6',  'ta', 'உங்கள் சுற்றுப்புறத்தில் (குடும்பம், நண்பர்கள்) உங்களுடைய போன்ற பொழுதுபோக்குகள் கொண்டவர்கள் உள்ளனவா? யார்?', NOW()),
('hobbies_question', 'question7',  'ta', 'உங்களுக்கு மிகவும் பிடித்த பொழுதுபோக்கைச் செய்யும்போது நீங்கள் எப்படி உணர்கிறீர்கள்? அது உங்களுக்கு ஓய்வு தருகிறதா அல்லது நம்பிக்கையை அதிகரிக்கிறதா?', NOW()),

-- Section 2: Talents & Practice (8–10)
('hobbies_question', 'question8',  'ta', 'உங்களிடம் உள்ள திறமைகளை (Talents) பட்டியலிடுங்கள்.', NOW()),
('hobbies_question', 'question9',  'ta', 'இந்த திறமைகளை மேம்படுத்த நீங்கள் பயிற்சி செய்கிறீர்களா? இருந்தால் எப்படி?', NOW()),
('hobbies_question', 'question10', 'ta', 'உங்கள் வீட்டில், பள்ளியில் அல்லது வேறு இடங்களில் உங்கள் பொழுதுபோக்குகள் மற்றும் திறமைகளைப் பயிற்சி செய்ய உங்களுக்கு வாய்ப்பு கிடைக்கிறதா? அவற்றை காட்டுவதற்கும் வாய்ப்பு கிடைக்கிறதா?', NOW()),

-- Section 3: Support & Career Connection (11–14)
('hobbies_question', 'question11', 'ta', 'உங்கள் திறமைகள் மற்றும் பொழுதுபோக்குகளை வளர்க்க உங்கள் பெற்றோர் உங்களுக்கு ஆதரவு தருகிறார்களா? எப்படி?', NOW()),
('hobbies_question', 'question12', 'ta', 'உங்கள் இயல்பான திறமைகளுக்கு ஏற்ப பொருந்தும் பொழுதுபோக்குகள் உங்களுக்கு உள்ளனவா?', NOW()),
('hobbies_question', 'question13', 'ta', 'உங்கள் சில பொழுதுபோக்குகளை எதிர்காலத்தில் தொழிலாக (வாழ்க்கைத் தொழில்) மாற்ற முடியும் என்று நீங்கள் நினைக்கிறீர்களா? இருந்தால், அதை தொழிலாக மாற்ற என்ன செய்ய வேண்டும்?', NOW()),
('hobbies_question', 'question14', 'ta', 'தங்களுடைய பொழுதுபோக்கு அல்லது ஆர்வத்தை தொழிலாக மாற்றியவர்களை நீங்கள் அறிவீர்களா? யார், அவர்கள் எந்தப் பொழுதுபோக்கை எப்படித் தொழிலாக மாற்றினர்?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- 4. ABOUT ME ASSESSMENT - Tamil Questions
--    resource_type: 'about_me_question', resource_key = field_key from about_me_fields
--    These keys match those used in the Kannada migration.
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
-- Section A: My Personal Space
('about_me_question', 'family_comfort_discuss',        'ta', 'உங்கள் குடும்பத்தில், உங்கள் எண்ணங்கள் மற்றும் உணர்வுகளை திறந்த மனதுடன் பகிர்ந்து கொள்ள நீங்கள் அதிகமாக நம்பும் நபர் யார்? ஏன் அவருடன் இவ்வளவு சுலபமாக பேச முடிகிறது?', NOW()),
('about_me_question', 'outside_family_individuals',    'ta', 'குடும்பத்தைத் தாண்டி, உங்கள் கருத்துகள் மற்றும் உணர்வுகளை மனமுவந்து பகிர்ந்து கொள்ள நீங்கள் யாரிடம் பேசுகிறீர்கள்?', NOW()),
('about_me_question', 'domestic_chores',               'ta', 'நீங்கள் வீட்டில் அடிக்கடி செய்யும் வேலைகள் என்னென்ன?', NOW()),

-- Section B: Activities You Enjoy
('about_me_question', 'enjoyable_school_hours',        'ta', 'பள்ளியில் உங்களுக்கு மிகவும் பிடித்து மகிழ்ச்சி தரும் செயல்பாடுகள்/பாடங்கள் எவை?', NOW()),
('about_me_question', 'enjoyable_pre_post_school',     'ta', 'பள்ளிக்கு வருவதற்கு முன் மற்றும் பள்ளி முடிந்த பிறகு நீங்கள் செய்ய அதிகம் விரும்பும் செயல்பாடுகள் எவை?', NOW()),
('about_me_question', 'independent_activities',        'ta', 'நீங்கள் தனியாக செய்ய விரும்பும் வேலைகள் அல்லது செயல்பாடுகள் எவை?', NOW()),
('about_me_question', 'proactive_activities',          'ta', 'யாரும் சொல்லாமல் நீங்கள் முன்வந்து செய்யும் வேலைகள் அல்லது செயல்கள் எவை? ஏன் அவற்றில் நீங்கள் இவ்வளவு சுறுசுறுப்பாக இருக்கிறீர்கள் என்று நினைக்கிறீர்கள்?', NOW()),

-- Section C: Tasks you find challenging
('about_me_question', 'challenging_school_tasks',      'ta', 'பள்ளியில் உங்களுக்கு சிரமமாகும் அல்லது சவாலாக இருக்கும் பாடங்கள்/வேலைகளை எழுதுங்கள்.', NOW()),
('about_me_question', 'challenging_outside_school',    'ta', 'பள்ளிக்குப் புறம்பாக உங்கள் தினசரி வாழ்க்கையில் உங்களுக்கு சிரமமாக இருக்கும் வேலைகள்/செயல்பாடுகள் எவை?', NOW()),
('about_me_question', 'dislike_compelled_tasks',       'ta', 'உங்களுக்கு பிடிக்காதிருந்தாலும் கட்டாயமாக செய்ய வேண்டிய வேலைகளை பட்டியலிடுங்கள்.', NOW()),
('about_me_question', 'natural_work_activities',       'ta', 'உங்களால் இயல்பாக எளிதாக செய்யப்படும் வேலைகள்/செயல்பாடுகள் எவை?', NOW()),
('about_me_question', 'not_natural_tasks',             'ta', 'உங்களுக்கு இயல்பாக வராமல், அதிக முயற்சி எடுக்க வேண்டிய வேலைகள் எவை?', NOW()),

-- Section D: Understanding More About You
('about_me_question', 'qualities_love_about_self',     'ta', 'உங்களுக்குள் நீங்கள் மிகவும் விரும்பும் மற்றும் மதிக்கும் குணங்கள் என்னவென்ன?', NOW()),
('about_me_question', 'qualities_others_appreciate',   'ta', 'உங்கள் பெற்றோர், ஆசிரியர்கள், நண்பர்கள் மற்றும் உறவினர்கள் – நீங்கள் கருதும்போது – உங்களின் எந்த குணங்களைப் பற்றி பெரும்பாலும் பாராட்டுகிறார்கள்?', NOW()),
('about_me_question', 'traits_improve_change',         'ta', 'உங்களுக்குள் நீங்கள் மேம்படுத்த வேண்டும் அல்லது மாற்ற வேண்டும் என்று நினைக்கும் குணங்கள் என்னென்ன?', NOW()),
('about_me_question', 'qualities_others_want_develop', 'ta', 'உங்களைப் பற்றிப் பிறர் (குடும்பம், ஆசிரியர்கள், நண்பர்கள்) மேம்படுத்த வேண்டும் என்று கூறும் குணங்கள் எவை?', NOW()),
('about_me_question', 'aspire_to_be',                  'ta', 'உங்கள் வாழ்க்கையில் நீங்கள் யாராக/எப்படிப்பட்ட மனிதராக ஆகவேண்டும் என்று கனவு காண்கிறீர்கள்?', NOW()),
('about_me_question', 'proud_moment',                  'ta', 'உங்கள் மீது நீங்கள் மிகவும் பெருமை கொண்ட ஒரு நிகழ்வை நினைவில் கொள்ளுங்கள். நீங்கள் என்ன சாதித்தீர்கள்? அது ஏன் முக்கியமானது?', NOW()),
('about_me_question', 'challenge_overcome',            'ta', 'சமீபத்தில் நீங்கள் எதிர்கொண்ட ஒரு சவால் அல்லது தடை பற்றி நினைத்துப் பாருங்கள். அதை நீங்கள் எப்படி கடந்து வந்தீர்கள்? அதில் இருந்து என்ன கற்றுக் கொண்டீர்கள்?', NOW()),
('about_me_question', 'misunderstood_moment',          'ta', 'மற்றவர்கள் உங்களை சரியாகப் புரிந்து கொள்ளவில்லை என்று நீங்கள் உணர்ந்த ஒரு சம்பவத்தை நினைவில் கொள்ளுங்கள். நீங்கள் அதை எப்படி சமாளித்தீர்கள்? அதிலிருந்து என்ன கற்றுக் கொண்டீர்கள்?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- 5. ROLE MODELS ASSESSMENT - Tamil Questions
--    resource_type: 'role_models_question', resource_key: 'rm_q1'..'rm_q13'
--    These are used via get_role_models_questions_i18n in the frontend.
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
('role_models_question', 'rm_q1',  'ta', '1. உங்கள் முன்மாதிரி (Role Model) யார்? அவரின் முழு பெயரை எழுதுங்கள்.', NOW()),
('role_models_question', 'rm_q2',  'ta', '2. இந்த நபர் உங்களுக்குத் தெரிந்தவரா? அவர் உங்கள் குடும்பம், உறவினர், பள்ளி, சமூகம் அல்லது வெறும் அறிமுகம் உள்ளவர் தானா? அல்லது அது பிரபலமான நபரா?', NOW()),
('role_models_question', 'rm_q3',  'ta', '3. இந்த முன்மாதிரியில் உங்களுக்கு மிகவும் பிடித்த குணங்கள் என்ன? நீங்கள் விரும்பும் குணங்களை பட்டியலிட்டு, அவை ஏன் உங்களுக்குப் பெரிதாகத் தெரியின்றன என்று எழுதுங்கள்.', NOW()),
('role_models_question', 'rm_q4',  'ta', '4. அவர்களின் தொழில்/வேலை என்ன?', NOW()),
('role_models_question', 'rm_q5',  'ta', '5. உங்கள் முன்மாதிரியின் திறமைகளைப் பார்த்து, நீங்கள் உங்களுக்குள் வளர்க்க விரும்பும் திறமைகள் அல்லது குணங்கள் எவை?', NOW()),
('role_models_question', 'rm_q6',  'ta', '6. நீங்கள் உங்கள் கனவு தொழில்கள் பற்றி உங்கள் முன்மாதிரியுடன் நேரடியாகப் பேசிவிட்டீர்களா? பேசினால், என்ன பற்றி பேசினீர்கள்?', NOW()),
('role_models_question', 'rm_q7',  'ta', '7. பேசவில்லை என்றால், உங்கள் கனவுத் தொழில் பற்றி அவர்களின் கருத்தை கேட்பது நன்றாக இருக்கும் என்று நீங்கள் நினைக்கிறீர்களா?', NOW()),
('role_models_question', 'rm_q8',  'ta', '8. உங்கள் கனவு வேலை/தொழிலைப் பற்றி உங்கள் முன்மாதிரி என்ன கருத்து கொண்டிருக்கிறார் என்று நீங்கள் நினைக்கிறீர்கள்? அல்லது அவர்கள் என்ன கூறியுள்ளனர்?', NOW()),
('role_models_question', 'rm_q9',  'ta', '9. உங்கள் முன்மாதிரி உங்களுக்கு தொழில் தேர்வில் வழிகாட்ட உதவ வாய்ப்பு இருக்கிறதா?', NOW()),
('role_models_question', 'rm_q10', 'ta', '10. மேலே உள்ள கேள்விக்கு உங்கள் பதில் "ஆம்" என்றால், அவர்கள் உங்களுக்கு எப்படி உதவ முடியும் என்று நீங்கள் நினைக்கிறீர்கள்?', NOW()),
('role_models_question', 'rm_q11', 'ta', '11. மேலே உள்ள கேள்விகளில் வராத, இந்த முன்மாதிரி பற்றிக் கூற வேண்டிய ஏதேனும் மற்ற விஷயங்கள் உள்ளனவா?', NOW()),
('role_models_question', 'rm_q12', 'ta', '12. உங்களுடைய தனித்தன்மை/குணங்களுக்கும் உங்கள் முன்மாதிரிகளின் குணங்களுக்கும் இடையில் ஏதேனும் ஒற்றுமைகள் இருக்கின்றனவா? இருந்தால், அவை என்ன?', NOW()),
('role_models_question', 'rm_q13', 'ta', '13. உங்கள் முன்மாதிரிகள் காட்டும் நல்ல குணங்களை உங்கள் வாழ்க்கையிலும் வளர்த்துக் கொள்ள நீங்கள் என்ன செய்ய திட்டமிடுகிறீர்கள்?', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- 6. CAREER GUIDANCE TOOLS ASSESSMENT - Tamil Questions
--    resource_type: 'career_guidance_question', resource_key: 'question1'..'question7'
--    Frontend currently reads directly from table; these translations will be
--    useful once an i18n RPC is introduced.
-- ============================================================================
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at) VALUES
('career_guidance_question', 'question1', 'ta', 'கேரியர் சார்ட் மற்றும் கேரியர் பிளானரை பார்க்கும் முன், இத்தனை விதமான வேலை வாய்ப்புகள் இருப்பதைக் குறித்து முன்பே நீங்கள் தெரிந்திருந்தீர்களா?', NOW()),
('career_guidance_question', 'question2', 'ta', 'இந்தப் பயிற்சியில் நீங்கள் அறிந்துகொண்ட, முன்பெல்லாம் தெரியாத 5 புதிய தொழில் வாய்ப்புகளை பட்டியலிடுங்கள்.', NOW()),
('career_guidance_question', 'question3', 'ta', 'கேரியர் சார்டில் ஒன்றுக்கு மேற்பட்ட பாதை (பாடப்பிரிவு) மூலம் அடையக்கூடிய 2 தொழில்களை எழுதுங்கள்.', NOW()),
('career_guidance_question', 'question4', 'ta', 'உங்களுக்கு பிடித்த ஒரு தொழிலைத் தேர்ந்தெடுத்து, அதை அடைவதற்கான படிப்பு, தகுதி, தேர்வுகள், வேலை வாய்ப்பு போன்ற சேர்க்கை செயல்முறையைச் சுருக்கமாக எழுதுங்கள்.', NOW()),
('career_guidance_question', 'question5', 'ta', 'ILP இணையதளத்தைப் பார்த்து, கேரியர் வழிகாட்டுதலுக்குத் தேவையான எந்த எந்த தகவல்கள் கிடைக்கின்றன என்பதை பட்டியலிடுங்கள்.', NOW()),
('career_guidance_question', 'question6', 'ta', 'ILP-இன் மொபைல் அப்ளிகேஷன் ஆன்ட்ராய்டு ப்ளே ஸ்டோரில் கிடைக்கிறதா?', NOW()),
('career_guidance_question', 'question7', 'ta', 'ILP-இன் மொபைல் வாட்ஸ்அப் சாட்-பாட் எண்ணை (WhatsApp number) எழுதுங்கள்.', NOW())
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();


-- ============================================================================
-- VERIFICATION
-- Simple notices to quickly check that Tamil rows exist.
-- ============================================================================
DO $$
DECLARE
    v_dreams_ta   INTEGER;
    v_school_ta   INTEGER;
    v_hobbies_ta  INTEGER;
    v_about_ta    INTEGER;
    v_roles_ta    INTEGER;
    v_cg_ta       INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_dreams_ta
    FROM content_translations
    WHERE resource_type = 'dreams_question' AND lang = 'ta';

    SELECT COUNT(*) INTO v_school_ta
    FROM content_translations
    WHERE resource_type = 'school_question' AND lang = 'ta';

    SELECT COUNT(*) INTO v_hobbies_ta
    FROM content_translations
    WHERE resource_type = 'hobbies_question' AND lang = 'ta';

    SELECT COUNT(*) INTO v_about_ta
    FROM content_translations
    WHERE resource_type = 'about_me_question' AND lang = 'ta';

    SELECT COUNT(*) INTO v_roles_ta
    FROM content_translations
    WHERE resource_type = 'role_models_question' AND lang = 'ta';

    SELECT COUNT(*) INTO v_cg_ta
    FROM content_translations
    WHERE resource_type = 'career_guidance_question' AND lang = 'ta';

    RAISE NOTICE 'Tamil Translations Added (ta):';
    RAISE NOTICE '  Dreams questions: %', v_dreams_ta;
    RAISE NOTICE '  School questions: %', v_school_ta;
    RAISE NOTICE '  Hobbies questions: %', v_hobbies_ta;
    RAISE NOTICE '  About Me questions: %', v_about_ta;
    RAISE NOTICE '  Role Models questions: %', v_roles_ta;
    RAISE NOTICE '  Career Guidance questions: %', v_cg_ta;
END $$;


