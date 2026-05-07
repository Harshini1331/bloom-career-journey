-- Fix: get_or_create_chat_channel had no internal auth check, allowing any
-- authenticated user to open a channel between arbitrary student/teacher pairs.
-- Now the function verifies the caller is one of the two participants.

CREATE OR REPLACE FUNCTION public.get_or_create_chat_channel(p_student_id uuid, p_teacher_id uuid)
RETURNS public.chat_channels
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_channel public.chat_channels;
  v_student_user_id uuid;
  v_teacher_user_id uuid;
BEGIN
  -- Resolve the user_ids for both sides of the channel
  SELECT s.user_id INTO v_student_user_id
  FROM public.students s
  WHERE s.id = p_student_id;

  SELECT t.user_id INTO v_teacher_user_id
  FROM public.teachers t
  WHERE t.id = p_teacher_id;

  -- Caller must be one of the two participants
  IF auth.uid() IS NULL
     OR (auth.uid() <> v_student_user_id AND auth.uid() <> v_teacher_user_id)
  THEN
    RAISE EXCEPTION 'Unauthorized: caller is not a participant in this channel';
  END IF;

  SELECT * INTO v_channel
  FROM public.chat_channels
  WHERE student_id = p_student_id AND teacher_id = p_teacher_id
  LIMIT 1;

  IF v_channel.id IS NULL THEN
    INSERT INTO public.chat_channels(student_id, teacher_id)
    VALUES (p_student_id, p_teacher_id)
    RETURNING * INTO v_channel;
  END IF;

  RETURN v_channel;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_or_create_chat_channel(uuid, uuid) TO authenticated;
