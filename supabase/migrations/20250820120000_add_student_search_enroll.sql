-- RPCs for counsellor (teacher) to search and enroll existing students safely

-- Function: search_students(teacher_user_id uuid, query text)
-- Returns students within the teacher's school that match the query
-- Match rules: exact mobile OR ILIKE match on email/full_name
CREATE OR REPLACE FUNCTION public.search_students(
  teacher_user_id uuid,
  query text
)
RETURNS TABLE (
  student_user_id uuid,
  full_name text,
  mobile text,
  email text,
  current_class text
) AS $$
DECLARE
  v_teacher_school uuid;
BEGIN
  -- Ensure caller is the same as the teacher_user_id
  IF auth.uid() IS NULL OR auth.uid() <> teacher_user_id THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  -- Resolve teacher's school
  SELECT t.school_id INTO v_teacher_school
  FROM public.teachers t
  WHERE t.user_id = teacher_user_id;

  IF v_teacher_school IS NULL THEN
    -- No school assigned, return empty set
    RETURN;
  END IF;

  RETURN QUERY
  SELECT u.id AS student_user_id,
         u.full_name,
         COALESCE(u.mobile, '') AS mobile,
         COALESCE(u.email, '')  AS email,
         COALESCE(c.name, '')   AS current_class
  FROM public.users u
  LEFT JOIN public.students s ON s.user_id = u.id
  LEFT JOIN public.classes  c ON c.id = s.class_id
  WHERE u.role = 'student'
    AND u.school_id = v_teacher_school
    AND (
      (u.mobile IS NOT NULL AND u.mobile = query) OR
      (u.email  IS NOT NULL AND u.email ILIKE '%' || query || '%') OR
      (u.full_name ILIKE '%' || query || '%')
    )
  ORDER BY u.full_name ASC
  LIMIT 50;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.search_students(uuid, text) TO authenticated;

-- Function: enroll_student_by_user_id(teacher_user_id uuid, student_user_id uuid, class_id uuid)
-- Links a student to a teacher and class within the same school.
CREATE OR REPLACE FUNCTION public.enroll_student_by_user_id(
  teacher_user_id uuid,
  student_user_id uuid,
  class_id uuid
)
RETURNS void AS $$
DECLARE
  v_teacher_id uuid;
  v_teacher_school uuid;
  v_class_school uuid;
  v_student_school uuid;
BEGIN
  -- Auth check
  IF auth.uid() IS NULL OR auth.uid() <> teacher_user_id THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT t.id, t.school_id INTO v_teacher_id, v_teacher_school
  FROM public.teachers t
  WHERE t.user_id = teacher_user_id;

  IF v_teacher_id IS NULL THEN
    RAISE EXCEPTION 'Teacher profile not found';
  END IF;

  SELECT c.school_id INTO v_class_school FROM public.classes c WHERE c.id = class_id;
  IF v_class_school IS NULL THEN
    RAISE EXCEPTION 'Class not found';
  END IF;

  SELECT u.school_id INTO v_student_school FROM public.users u WHERE u.id = student_user_id;
  IF v_student_school IS NULL THEN
    RAISE EXCEPTION 'Student user not found';
  END IF;

  -- Cross-school protection
  IF v_teacher_school <> v_class_school OR v_teacher_school <> v_student_school THEN
    RAISE EXCEPTION 'Cross-school enrollment is not allowed';
  END IF;

  -- Upsert student enrollment
  INSERT INTO public.students (user_id, class_id, teacher_id, enrollment_status, enrollment_date)
  VALUES (student_user_id, class_id, v_teacher_id, 'active', now())
  ON CONFLICT (user_id) DO UPDATE
    SET class_id = EXCLUDED.class_id,
        teacher_id = EXCLUDED.teacher_id,
        enrollment_status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.enroll_student_by_user_id(uuid, uuid, uuid) TO authenticated;


