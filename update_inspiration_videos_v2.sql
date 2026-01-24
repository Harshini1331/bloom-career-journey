-- ALter table to support language
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'inspiration_sources' AND column_name = 'lang') THEN
        ALTER TABLE inspiration_sources ADD COLUMN lang VARCHAR(10) DEFAULT 'en';
    END IF;
END $$;

-- Clear existing data to avoid duplicates/confusion
DELETE FROM inspiration_sources;

-- Insert Tamil Videos
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'Tamil Inspiration Video 1', 1, 'ta'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'Tamil Inspiration Video 2', 2, 'ta'),
('Video 3', 'https://youtu.be/G87ylRECJzY?si=HyhMM4-ggplVLO2i', 'Tamil Inspiration Video 3', 3, 'ta'),
('Video 4', 'https://youtu.be/X9wViEY5tPQ?si=qDOuMSUatButKwZk', 'Tamil Inspiration Video 4', 4, 'ta'),
('Video 5', 'https://youtu.be/3jQaBseeraY?si=n-s9lwqlpYfmS7t7', 'Tamil Inspiration Video 5', 5, 'ta'),
('Video 6', 'https://youtu.be/GPeeZ6viNgY?si=sg4hFF33p3cF4X25', 'Tamil Inspiration Video 6', 6, 'ta');

-- Insert English Videos
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'English Inspiration Video 1', 1, 'en'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'English Inspiration Video 2', 2, 'en'),
('Video 3', 'https://youtu.be/Tf5c0ZMg2q8?si=tbEbN8oBp5ecjK3P', 'English Inspiration Video 3', 3, 'en'),
('Video 4', 'https://youtu.be/X9wViEY5tPQ?si=qDOuMSUatButKwZk', 'English Inspiration Video 4', 4, 'en'),
('Video 5', 'https://youtu.be/PP-kmxMY1ts?si=AqtDd0e6RFLA99up', 'English Inspiration Video 5', 5, 'en'),
('Video 6', 'https://youtu.be/GPeeZ6viNgY?si=sg4hFF33p3cF4X25', 'English Inspiration Video 6', 6, 'en');

-- Insert Kannada Videos
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'Kannada Inspiration Video 1', 1, 'kn'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'Kannada Inspiration Video 2', 2, 'kn'),
('Video 3', 'https://www.youtube.com/watch?v=z3PYJ9MfMH4', 'Kannada Inspiration Video 3', 3, 'kn'),
('Video 4', 'https://youtu.be/X9wViEY5tPQ?si=qDOuMSUatButKwZk', 'Kannada Inspiration Video 4', 4, 'kn'),
('Video 5', 'https://youtu.be/qbP8uQBs0vY?si=3fi2qXLJ9X-cAsmJ', 'Kannada Inspiration Video 5', 5, 'kn'),
('Video 6', 'https://youtu.be/GPeeZ6viNgY?si=sg4hFF33p3cF4X25', 'Kannada Inspiration Video 6', 6, 'kn');

-- Update the RPC to accept language parameter
CREATE OR REPLACE FUNCTION get_inspiration_videos(p_lang TEXT DEFAULT 'en')
RETURNS SETOF inspiration_sources
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT *
  FROM inspiration_sources
  WHERE lang = p_lang
  ORDER BY sequence_number;
$$;
