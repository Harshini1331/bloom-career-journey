-- Phone-only auth migration: update authenticate_student and search_students RPCs
-- authenticate_student: remove email matching branch (keep for legacy NO student backfill)
-- search_students: remove email branch, change mobile to partial match, drop email return column

-- ─── 1. authenticate_student — phone only ───────────────────────────────────

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'authenticate_student'
  ) THEN
    EXECUTE 'DROP FUNCTION IF EXISTS public.authenticate_student CASCADE';
  END IF;
END $$;

CREATE OR REPLACE FUNCTION public.authenticate_student(
  identifier text,
  password text
)
RETURNS TABLE(
  user_id uuid,
  full_name text,
  mobile text,
  role text
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    u.full_name::text,
    u.mobile::text,
    u.role::text
  FROM public.users u
  JOIN public.student_auth_credentials sac ON sac.user_id = u.id
  WHERE sac.is_active = true
    AND sac.password_hash = password
    AND sac.mobile IS NOT NULL
    AND sac.mobile = identifier
  LIMIT 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute to both anon and authenticated (needed for legacy NO student sign-in)
GRANT EXECUTE ON FUNCTION public.authenticate_student(text, text) TO anon;
GRANT EXECUTE ON FUNCTION public.authenticate_student(text, text) TO authenticated;

COMMENT ON FUNCTION public.authenticate_student(text, text)
IS 'Authenticates legacy NO students using student_auth_credentials by mobile only (phone-only auth migration). Temporary — to be removed after NO student backfill is complete.';


-- ─── 2. search_students — phone only with partial match ──────────────────────

DROP FUNCTION IF EXISTS search_students(uuid, text);

CREATE OR REPLACE FUNCTION search_students(teacher_user_id uuid, query text)
RETURNS TABLE (
  student_user_id uuid,
  full_name text,
  mobile text,
  preferred_language text,
  current_class_id uuid,
  current_class text,
  mentor_name text,
  is_default_mentor boolean
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_teacher_state uuid;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> teacher_user_id THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT t.state_id INTO v_teacher_state
  FROM public.teachers t
  WHERE t.user_id = teacher_user_id;

  IF v_teacher_state IS NULL THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT
    u.id AS student_user_id,
    u.full_name,
    COALESCE(u.mobile::text, ''::text) AS mobile,
    COALESCE(u.preferred_language::text, 'en'::text) AS preferred_language,
    s.class_id AS current_class_id,
    COALESCE(c.name::text, ''::text) AS current_class,
    COALESCE(mu.full_name::text, 'None'::text) AS mentor_name,
    COALESCE(mt.is_default, false) AS is_default_mentor
  FROM public.users u
  LEFT JOIN public.students s ON s.user_id = u.id
  LEFT JOIN public.classes c ON c.id = s.class_id
  LEFT JOIN public.teachers mt ON mt.id = s.teacher_id
  LEFT JOIN public.users mu ON mu.id = mt.user_id
  WHERE u.role = 'student'
    AND u.state_id = v_teacher_state
    AND (
      (u.mobile IS NOT NULL AND u.mobile ILIKE '%' || query || '%') OR
      (u.full_name ILIKE '%' || query || '%')
    )
  ORDER BY u.full_name ASC
  LIMIT 50;
END;
$$;

GRANT EXECUTE ON FUNCTION search_students(uuid, text) TO authenticated;
