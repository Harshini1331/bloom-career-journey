-- Migration: Cleanup Duplicate Videos
-- Remove duplicate videos from inspiration_videos table

-- Delete duplicate videos, keeping only the first occurrence of each URL
DELETE FROM inspiration_videos 
WHERE id NOT IN (
    SELECT MIN(id) 
    FROM inspiration_videos 
    GROUP BY url
);

-- Reset sequence numbers to be consecutive
UPDATE inspiration_videos 
SET sequence_number = subquery.new_sequence
FROM (
    SELECT id, ROW_NUMBER() OVER (ORDER BY sequence_number) as new_sequence
    FROM inspiration_videos
) AS subquery
WHERE inspiration_videos.id = subquery.id;
