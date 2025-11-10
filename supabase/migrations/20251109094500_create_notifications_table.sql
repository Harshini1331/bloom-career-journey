-- Migration: Create notifications table and policies
DO $$
BEGIN
    CREATE TYPE notification_type AS ENUM (
        'summary_approved',
        'teacher_message',
        'assessment_submitted',
        'system'
    );
EXCEPTION
    WHEN duplicate_object THEN NULL;
END;
$$;

CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type notification_type NOT NULL DEFAULT 'system',
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    link TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_notifications_user_created_at
    ON notifications(user_id, created_at DESC);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS notifications_select_own ON notifications;
CREATE POLICY notifications_select_own
    ON notifications
    FOR SELECT
    TO authenticated
    USING (user_id = auth.uid());

DROP POLICY IF EXISTS notifications_update_mark_read ON notifications;
CREATE POLICY notifications_update_mark_read
    ON notifications
    FOR UPDATE
    TO authenticated
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS notifications_insert_self ON notifications;
CREATE POLICY notifications_insert_self
    ON notifications
    FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());
