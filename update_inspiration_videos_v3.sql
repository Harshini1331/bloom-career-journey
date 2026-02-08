-- ALter table to support language if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'inspiration_sources' AND column_name = 'lang') THEN
        ALTER TABLE inspiration_sources ADD COLUMN lang VARCHAR(10) DEFAULT 'en';
    END IF;
END $$;

-- Clear existing data to replace with new set (only 3 videos per language)
DELETE FROM inspiration_sources;

-- Insert English Videos
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'English Inspiration Video 1', 1, 'en'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'English Inspiration Video 2', 2, 'en'),
('Video 3', 'https://youtu.be/G87ylRECJzY?si=HyhMM4-ggplVLO2i', 'English Inspiration Video 3', 3, 'en');

-- Insert Tamil Videos (Same as English as requested)
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'Tamil Inspiration Video 1', 1, 'ta'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'Tamil Inspiration Video 2', 2, 'ta'),
('Video 3', 'https://youtu.be/G87ylRECJzY?si=HyhMM4-ggplVLO2i', 'Tamil Inspiration Video 3', 3, 'ta');

-- Insert Kannada Videos (Unique 3rd video)
INSERT INTO inspiration_sources (title, url, description, sequence_number, lang) VALUES
('Video 1', 'https://youtu.be/U7-HlfpvQIA?si=_gakjQozpgbZC2aQ', 'Kannada Inspiration Video 1', 1, 'kn'),
('Video 2', 'https://www.youtube.com/watch?v=xqb1hfgfcl8', 'Kannada Inspiration Video 2', 2, 'kn'),
('Video 3', 'https://www.youtube.com/watch?v=z3PYJ9MfMH4', 'Kannada Inspiration Video 3', 3, 'kn');

-- Ensure the RPC function is up to date (handling lang param)
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
