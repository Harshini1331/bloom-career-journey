-- Migration: Create security definer RPC for notifications
-- Allows any authenticated user to enqueue a notification for another user

CREATE OR REPLACE FUNCTION create_notification_secure(
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
