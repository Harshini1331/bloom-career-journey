-- Migration: Update Inspiration Videos to 4 videos
-- This migration updates the inspiration_videos table to have only 4 videos instead of 6

-- Delete all existing videos
DELETE FROM inspiration_videos;

-- Insert the 4 new inspirational videos
INSERT INTO inspiration_videos (title, url, youtube_id, description, sequence_number) VALUES
('Inspirational Video 1', 'https://www.youtube.com/watch?v=X9wViEY5tPQ', 'X9wViEY5tPQ', 'First inspirational content for self-reflection', 1),
('Inspirational Video 2', 'https://www.youtube.com/watch?v=Ooy721_K4Mc', 'Ooy721_K4Mc', 'Second inspirational content for self-reflection', 2),
('Inspirational Video 3', 'https://www.youtube.com/watch?v=PP-kmxMY1ts', 'PP-kmxMY1ts', 'Third inspirational content for self-reflection', 3),
('Inspirational Video 4', 'https://www.youtube.com/watch?v=z3PYJ9MfMH4', 'z3PYJ9MfMH4', 'Fourth inspirational content for self-reflection', 4);

