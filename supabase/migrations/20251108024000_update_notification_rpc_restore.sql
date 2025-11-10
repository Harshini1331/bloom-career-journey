
-- Migration: Restore previous claims after inserting notifications
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
    v_original_sub TEXT;
    v_original_role TEXT;
BEGIN
    -- Capture current claims
    v_original_sub := current_setting('request.jwt.claim.sub', true);
    v_original_role := current_setting('request.jwt.claim.role', true);

    -- Impersonate the notification recipient
    PERFORM set_config('request.jwt.claim.sub', COALESCE(p_user_id::text, ''), true);
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

    -- Restore previous claims
    IF v_original_sub IS NULL OR v_original_sub = '' THEN
        PERFORM reset_config('request.jwt.claim.sub');
    ELSE
        PERFORM set_config('request.jwt.claim.sub', v_original_sub, true);
    END IF;

    IF v_original_role IS NULL OR v_original_role = '' THEN
        PERFORM reset_config('request.jwt.claim.role');
    ELSE
        PERFORM set_config('request.jwt.claim.role', v_original_role, true);
    END IF;

    RETURN v_notification_id;
END;
$$;

GRANT EXECUTE ON FUNCTION create_notification_secure(UUID, TEXT, TEXT, TEXT, TEXT) TO authenticated;
