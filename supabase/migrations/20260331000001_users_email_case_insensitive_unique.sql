-- Add case-insensitive unique index on users.email
-- Prevents duplicate accounts like Bruno@gmail.com and bruno@gmail.com
-- Also normalize existing emails to lowercase

UPDATE users SET email = LOWER(TRIM(email)) WHERE email IS NOT NULL AND email != LOWER(TRIM(email));

CREATE UNIQUE INDEX IF NOT EXISTS users_email_lower_unique ON users (LOWER(email)) WHERE email IS NOT NULL;
