-- Check if About Me Summary Template is Updated
-- Run this in Supabase SQL Editor to verify the migration has been applied

-- 1. Check if the template exists
SELECT 
  assessment_type,
  title,
  summary_questions->'en'->>'question1' as question1_en,
  summary_questions->'en'->>'question2' as question2_en,
  summary_questions->'en'->>'question3' as question3_en,
  updated_at
FROM assessment_summary_templates
WHERE assessment_type = 'about_me';

-- 2. Check if Question 1 contains the 15 categories (should contain "15 categories")
SELECT 
  CASE 
    WHEN summary_questions->'en'->>'question1' LIKE '%15 categories%' 
    THEN '✅ NEW TEMPLATE - Migration Applied'
    ELSE '❌ OLD TEMPLATE - Migration Not Applied'
  END as migration_status,
  summary_questions->'en'->>'question1' as question1_preview
FROM assessment_summary_templates
WHERE assessment_type = 'about_me';

-- 3. Full preview of all questions
SELECT 
  'Question 1' as question_number,
  summary_questions->'en'->>'question1' as question_text
FROM assessment_summary_templates
WHERE assessment_type = 'about_me'
UNION ALL
SELECT 
  'Question 2' as question_number,
  summary_questions->'en'->>'question2' as question_text
FROM assessment_summary_templates
WHERE assessment_type = 'about_me'
UNION ALL
SELECT 
  'Question 3' as question_number,
  summary_questions->'en'->>'question3' as question_text
FROM assessment_summary_templates
WHERE assessment_type = 'about_me';

