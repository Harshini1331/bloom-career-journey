-- Migration: Ensure get_hobbies_questions RPC function exists
-- This migration ensures the get_hobbies_questions function is available

-- Create or replace the function to return questions in proper order
CREATE OR REPLACE FUNCTION get_hobbies_questions()
RETURNS TABLE (
    id UUID,
    section TEXT,
    question_text TEXT,
    help_text TEXT,
    sequence_number INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        h.id,
        h.section,
        h.question_text,
        h.help_text,
        h.sequence_number
    FROM hobbies_questions h
    WHERE h.is_active = true
    ORDER BY 
        CASE h.section
            WHEN 'section1' THEN 1
            WHEN 'section2' THEN 2
            WHEN 'section3' THEN 3
            ELSE 99
        END,
        h.sequence_number;
END $$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_hobbies_questions() TO authenticated;

-- Verify function exists
DO $$
DECLARE
    func_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public' 
        AND p.proname = 'get_hobbies_questions'
    ) INTO func_exists;
    
    IF func_exists THEN
        RAISE NOTICE '✅ get_hobbies_questions() function exists';
    ELSE
        RAISE NOTICE '⚠️ get_hobbies_questions() function not found';
    END IF;
END $$;

