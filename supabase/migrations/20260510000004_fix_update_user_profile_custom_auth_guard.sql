-- Fix: update_user_profile's custom-auth branch fired even when auth.uid() was
-- set to a different user (e.g. a teacher passing a legacy student's user_id).
-- The second ELSIF now requires auth.uid() IS NULL so only genuinely unauthenticated
-- custom-auth students can use that path; authenticated callers must match p_user_id.

CREATE OR REPLACE FUNCTION public.update_user_profile(
  p_user_id uuid,
  p_full_name text DEFAULT NULL,
  p_gender text DEFAULT NULL,
  p_school text DEFAULT NULL,
  p_profile_picture_url text DEFAULT NULL,
  p_career_goals text DEFAULT NULL,
  p_preferred_language text DEFAULT NULL
)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_result json;
BEGIN
  IF auth.uid() IS NOT NULL AND auth.uid() = p_user_id THEN
    -- Supabase-authenticated user updating their own profile
    NULL;
  ELSIF auth.uid() IS NULL
    AND EXISTS (SELECT 1 FROM student_auth_credentials WHERE user_id = p_user_id AND is_active = true)
  THEN
    -- Custom-auth (legacy NO) student: no Supabase session, authenticated via
    -- authenticate_student RPC. auth.uid() must be NULL for this path to trigger.
    NULL;
  ELSE
    RAISE EXCEPTION 'Permission denied: cannot update profile for user %', p_user_id;
  END IF;

  UPDATE public.users
  SET
    full_name           = COALESCE(p_full_name,           full_name),
    gender              = COALESCE(p_gender,              gender),
    school              = COALESCE(p_school,              school),
    profile_picture_url = COALESCE(p_profile_picture_url, profile_picture_url),
    career_goals        = COALESCE(p_career_goals,        career_goals),
    preferred_language  = COALESCE(p_preferred_language,  preferred_language)
  WHERE id = p_user_id
  RETURNING row_to_json(users.*) INTO v_result;

  IF v_result IS NULL THEN
    RAISE EXCEPTION 'User not found: %', p_user_id;
  END IF;

  RETURN v_result;
END;
$$;
