-- Fix: create_notification_secure had no relationship check between the caller
-- and the notification recipient. Any authenticated user could spam any user_id.
-- Now the function enforces:
--   - Self-notification is always allowed (auth.uid() = p_user_id)
--   - Teacher may notify their own students
--   - Student may notify their own teacher
--   - Admin may notify anyone
-- This covers every legitimate call site: assessment approval/rejection (teacher→student),
-- profile card approval/rejection (teacher→student), and chat (bidirectional).

DROP FUNCTION IF EXISTS public.create_notification_secure(UUID, TEXT, TEXT, TEXT, TEXT);

CREATE FUNCTION public.create_notification_secure(
    p_user_id UUID,
    p_type TEXT,
    p_title TEXT,
    p_message TEXT,
    p_link TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_notification_id UUID;
    v_original_sub TEXT;
    v_original_role TEXT;
    v_caller_uid UUID;
BEGIN
    v_caller_uid := auth.uid();

    IF v_caller_uid IS NULL THEN
        RAISE EXCEPTION 'Unauthorized: unauthenticated caller';
    END IF;

    -- Verify the caller has a legitimate relationship with the recipient
    IF v_caller_uid <> p_user_id THEN
        IF NOT (
            -- Admin can notify anyone
            EXISTS (SELECT 1 FROM public.users WHERE id = v_caller_uid AND role = 'admin')
            OR
            -- Teacher notifying one of their students
            EXISTS (
                SELECT 1 FROM public.students s
                JOIN public.teachers t ON t.id = s.teacher_id
                WHERE s.user_id = p_user_id AND t.user_id = v_caller_uid
            )
            OR
            -- Student notifying their assigned teacher
            EXISTS (
                SELECT 1 FROM public.students s
                JOIN public.teachers t ON t.id = s.teacher_id
                WHERE s.user_id = v_caller_uid AND t.user_id = p_user_id
            )
        ) THEN
            RAISE EXCEPTION 'Unauthorized: no relationship between caller and recipient';
        END IF;
    END IF;

    -- Capture current claims before impersonating the recipient
    v_original_sub  := current_setting('request.jwt.claim.sub',  true);
    v_original_role := current_setting('request.jwt.claim.role', true);

    PERFORM set_config('request.jwt.claim.sub',  COALESCE(p_user_id::text, ''), true);
    PERFORM set_config('request.jwt.claim.role', 'authenticated',               true);

    INSERT INTO public.notifications (user_id, type, title, message, link, created_at)
    VALUES (
        p_user_id,
        p_type::notification_type,
        p_title,
        p_message,
        NULLIF(p_link, ''),
        NOW()
    )
    RETURNING id INTO v_notification_id;

    -- Restore original claims
    PERFORM set_config('request.jwt.claim.sub',  COALESCE(v_original_sub,  ''), true);
    PERFORM set_config('request.jwt.claim.role', COALESCE(v_original_role, ''), true);

    RETURN v_notification_id;
END;
$$;

GRANT EXECUTE ON FUNCTION public.create_notification_secure(UUID, TEXT, TEXT, TEXT, TEXT) TO authenticated;
