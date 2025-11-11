-- Ensure custom student authentication works from the public (unauthenticated) sign-in page
-- 1) Create or replace the authenticate_student RPC with SECURITY DEFINER
-- 2) Grant EXECUTE to both 'anon' and 'authenticated' roles
-- 3) Keep logic minimal: match identifier on email or mobile, check active flag and plaintext temporary password

DO $$
BEGIN
  -- Drop existing function if signature mismatches; ignore errors
  IF EXISTS (
    SELECT 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'authenticate_student'
      AND pg_get_function_identity_arguments(p.oid) = 'identifier text, password text'
  ) THEN
    -- Function with expected signature exists; we'll replace it below
    NULL;
  ELSE
    -- Try to drop any variant to avoid ambiguity
    PERFORM 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'authenticate_student';
    IF FOUND THEN
      EXECUTE 'DROP FUNCTION IF EXISTS public.authenticate_student CASCADE';
    END IF;
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.authenticate_student(
  identifier text,
  password text
)
RETURNS TABLE(
  user_id uuid,
  full_name text,
  email text,
  mobile text,
  role text
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    u.id,
    u.full_name::text,
    u.email::text,
    u.mobile::text,
    u.role::text
  FROM public.users u
  JOIN public.student_auth_credentials sac ON sac.user_id = u.id
  WHERE sac.is_active = true
    AND sac.password_hash = password
    AND (
      (sac.email IS NOT NULL AND lower(sac.email) = lower(identifier)) OR
      (sac.mobile IS NOT NULL AND sac.mobile = identifier)
    )
  LIMIT 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute to both anon (for sign-in page) and authenticated (for any in-app calls)
GRANT EXECUTE ON FUNCTION public.authenticate_student(text, text) TO anon;
GRANT EXECUTE ON FUNCTION public.authenticate_student(text, text) TO authenticated;

-- Helpful comment for future maintainers
COMMENT ON FUNCTION public.authenticate_student(text, text)
IS 'Authenticates students using public.student_auth_credentials by email or mobile with a temporary/plaintext password; SECURITY DEFINER so it can be called before auth.';


