-- RPC to update user profile, bypassing RLS for custom-auth students
-- Custom-auth students don't have a real Supabase auth session, so
-- auth.uid() is null and the "Users can update their own profile" policy blocks updates.
-- This SECURITY DEFINER function accepts the user_id explicitly and validates ownership
-- via the student_auth_credentials table (teacher-created students) or auth.uid() match.

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
  -- Validate: either the caller is the user (Supabase auth) or the user has custom auth credentials
  IF auth.uid() IS NOT NULL AND auth.uid() = p_user_id THEN
    -- Supabase-authenticated user updating their own profile: allowed
    NULL;
  ELSIF EXISTS (SELECT 1 FROM student_auth_credentials WHERE user_id = p_user_id AND is_active = true) THEN
    -- Custom-auth student: allowed (they authenticated via student_auth_credentials)
    NULL;
  ELSE
    RAISE EXCEPTION 'Permission denied: cannot update profile for user %', p_user_id;
  END IF;

  UPDATE public.users
  SET
    full_name = COALESCE(p_full_name, full_name),
    gender = COALESCE(p_gender, gender),
    school = COALESCE(p_school, school),
    profile_picture_url = COALESCE(p_profile_picture_url, profile_picture_url),
    career_goals = COALESCE(p_career_goals, career_goals),
    preferred_language = COALESCE(p_preferred_language, preferred_language)
  WHERE id = p_user_id
  RETURNING row_to_json(users.*) INTO v_result;

  IF v_result IS NULL THEN
    RAISE EXCEPTION 'User not found: %', p_user_id;
  END IF;

  RETURN v_result;
END;
$$;
