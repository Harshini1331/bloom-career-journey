-- Migration: Sync All Assessment Questions and Help Text Translations
-- This migration ensures English and simplified Kannada translations exist in content_translations
-- for all assessment questions and help text, simplified for rural grade 8 students

-- ============================================================================
-- 1. INSPIRATION ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from inspiration_questions
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'inspiration_question',
    'question' || i.sequence_number::text,
    'en',
    i.question_text,
    NOW()
FROM inspiration_questions i
WHERE i.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'inspiration_help',
    'question' || i.sequence_number::text,
    'en',
    COALESCE(i.help_text, ''),
    NOW()
FROM inspiration_questions i
WHERE i.is_active = true AND i.help_text IS NOT NULL AND i.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 2. DREAMS ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from dreams_questions
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'dreams_question',
    'question' || d.sequence_number::text,
    'en',
    d.question_text,
    NOW()
FROM dreams_questions d
WHERE d.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'dreams_help',
    'question' || d.sequence_number::text,
    'en',
    COALESCE(d.help_text, ''),
    NOW()
FROM dreams_questions d
WHERE d.is_active = true AND d.help_text IS NOT NULL AND d.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 3. SCHOOL LEARNING ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from school_learning_questions
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'school_question',
    'question' || s.sequence_number::text,
    'en',
    s.question_text,
    NOW()
FROM school_learning_questions s
WHERE s.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'school_help',
    'question' || s.sequence_number::text,
    'en',
    COALESCE(s.help_text, ''),
    NOW()
FROM school_learning_questions s
WHERE s.is_active = true AND s.help_text IS NOT NULL AND s.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 4. HOBBIES ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from hobbies_questions
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'hobbies_question',
    'question' || h.sequence_number::text,
    'en',
    h.question_text,
    NOW()
FROM hobbies_questions h
WHERE h.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'hobbies_help',
    'question' || h.sequence_number::text,
    'en',
    COALESCE(h.help_text, ''),
    NOW()
FROM hobbies_questions h
WHERE h.is_active = true AND h.help_text IS NOT NULL AND h.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 5. ABOUT ME ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from about_me_fields (not about_me_questions)
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'about_me_question',
    a.field_key,
    'en',
    a.question_text,
    NOW()
FROM about_me_fields a
WHERE a.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'about_me_help',
    a.field_key,
    'en',
    COALESCE(a.help_text, ''),
    NOW()
FROM about_me_fields a
WHERE a.is_active = true AND a.help_text IS NOT NULL AND a.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- 6. CAREER GUIDANCE TOOLS ASSESSMENT
-- ============================================================================
-- Sync English questions and help text from career_guidance_tools_questions
INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'career_guidance_question',
    'question' || c.sequence_number::text,
    'en',
    c.question_text,
    NOW()
FROM career_guidance_tools_questions c
WHERE c.is_active = true
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

INSERT INTO content_translations (resource_type, resource_key, lang, text, updated_at)
SELECT 
    'career_guidance_help',
    'question' || c.sequence_number::text,
    'en',
    COALESCE(c.help_text, ''),
    NOW()
FROM career_guidance_tools_questions c
WHERE c.is_active = true AND c.help_text IS NOT NULL AND c.help_text != ''
ON CONFLICT (resource_type, resource_key, lang) 
DO UPDATE SET 
    text = EXCLUDED.text,
    updated_at = NOW();

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
    inspiration_count INTEGER;
    dreams_count INTEGER;
    school_count INTEGER;
    hobbies_count INTEGER;
    about_me_count INTEGER;
    career_guidance_count INTEGER;
    role_models_count INTEGER;
BEGIN
    -- Count translations for each assessment type
    SELECT COUNT(*) INTO inspiration_count
    FROM content_translations
    WHERE resource_type = 'inspiration_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO dreams_count
    FROM content_translations
    WHERE resource_type = 'dreams_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO school_count
    FROM content_translations
    WHERE resource_type = 'school_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO hobbies_count
    FROM content_translations
    WHERE resource_type = 'hobbies_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO about_me_count
    FROM content_translations
    WHERE resource_type = 'about_me_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO career_guidance_count
    FROM content_translations
    WHERE resource_type = 'career_guidance_question' AND lang = 'en';
    
    SELECT COUNT(*) INTO role_models_count
    FROM content_translations
    WHERE resource_type = 'role_models_question' AND lang = 'en';
    
    RAISE NOTICE 'Assessment Translations Sync Complete:';
    RAISE NOTICE 'Inspiration: % questions', inspiration_count;
    RAISE NOTICE 'Dreams: % questions', dreams_count;
    RAISE NOTICE 'School Learning: % questions', school_count;
    RAISE NOTICE 'Hobbies: % questions', hobbies_count;
    RAISE NOTICE 'About Me: % questions', about_me_count;
    RAISE NOTICE 'Career Guidance: % questions', career_guidance_count;
    RAISE NOTICE 'Role Models: % questions', role_models_count;
    RAISE NOTICE '✅ English translations synced successfully!';
    RAISE NOTICE '📝 Note: Kannada translations should be added separately using simplified language for rural grade 8 students.';
END $$;

