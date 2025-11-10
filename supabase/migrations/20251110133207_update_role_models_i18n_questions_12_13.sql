-- Migration: Update Role Models i18n function to include questions 12 and 13
-- This migration updates the get_role_models_questions_i18n function to include
-- questions 12 and 13 (general reflection questions)

-- Update the function to include questions 12 and 13
CREATE OR REPLACE FUNCTION public.get_role_models_questions_i18n(p_lang text)
RETURNS jsonb
LANGUAGE sql
STABLE
AS $$
  SELECT jsonb_agg(
    jsonb_build_object(
      'key', 'rm_q' || i,
      'text', public.get_translation('role_models_question', 'rm_q' || i::text, p_lang)
    )
  )
  FROM generate_series(1,13) AS g(i);
$$;

-- Verify the function was updated
DO $$
DECLARE
    func_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public' 
        AND p.proname = 'get_role_models_questions_i18n'
    ) INTO func_exists;
    
    IF func_exists THEN
        RAISE NOTICE '✅ Role Models i18n function updated successfully to include questions 12 and 13';
    ELSE
        RAISE WARNING '⚠️ Role Models i18n function not found';
    END IF;
END $$;

