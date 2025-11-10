
-- Migration: Update create_notification_secure to impersonate recipient for RLS
DROP FUNCTION IF EXISTS create_notification_secure(UUID, TEXT, TEXT, TEXT, TEXT);

CREATE FUNCTION create_notification_secure(
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
BEGIN
    -- Impersonate the notification recipient so RLS policies that rely on auth.uid() pass
    PERFORM set_config('request.jwt.claim.sub', p_user_id::text, true);
    PERFORM set_config('request.jwt.claim.role', 'authenticated', true);

    INSERT INTO notifications (user_id, type, title, message, link, created_at)
    VALUES (
        p_user_id,
        p_type::notifications.type%TYPE,
        p_title,
        p_message,
        NULLIF(p_link, ''),
        NOW()
    )
    RETURNING id INTO v_notification_id;

    RETURN v_notification_id;
END;
$$;

GRANT EXECUTE ON FUNCTION create_notification_secure(UUID, TEXT, TEXT, TEXT, TEXT) TO authenticated;
