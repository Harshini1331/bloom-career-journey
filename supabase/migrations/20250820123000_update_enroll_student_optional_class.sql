-- Make class_id optional when enrolling an existing student
CREATE OR REPLACE FUNCTION public.enroll_student_by_user_id(
  teacher_user_id uuid,
  student_user_id uuid,
  class_id uuid DEFAULT NULL
)
RETURNS void AS $$
DECLARE
  v_teacher_id uuid;
  v_teacher_school uuid;
  v_student_school uuid;
  v_class_school uuid;
BEGIN
  IF auth.uid() IS NULL OR auth.uid() <> teacher_user_id THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  SELECT t.id, t.school_id INTO v_teacher_id, v_teacher_school
  FROM public.teachers t
  WHERE t.user_id = teacher_user_id;

  IF v_teacher_id IS NULL THEN
    RAISE EXCEPTION 'Teacher profile not found';
  END IF;

  SELECT u.school_id INTO v_student_school FROM public.users u WHERE u.id = student_user_id;
  IF v_student_school IS NULL THEN
    RAISE EXCEPTION 'Student user not found';
  END IF;

  -- Cross-school protection: student must match teacher school
  IF v_teacher_school <> v_student_school THEN
    RAISE EXCEPTION 'Cross-school enrollment is not allowed';
  END IF;

  -- If a class is provided, ensure the class belongs to the same school
  IF class_id IS NOT NULL THEN
    SELECT c.school_id INTO v_class_school FROM public.classes c WHERE c.id = class_id;
    IF v_class_school IS NULL OR v_class_school <> v_teacher_school THEN
      RAISE EXCEPTION 'Class does not belong to teacher school';
    END IF;
  END IF;

  INSERT INTO public.students (user_id, class_id, teacher_id, enrollment_status, enrollment_date)
  VALUES (student_user_id, class_id, v_teacher_id, 'active', now())
  ON CONFLICT (user_id) DO UPDATE
    SET class_id = EXCLUDED.class_id,
        teacher_id = EXCLUDED.teacher_id,
        enrollment_status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION public.enroll_student_by_user_id(uuid, uuid, uuid) TO authenticated;

