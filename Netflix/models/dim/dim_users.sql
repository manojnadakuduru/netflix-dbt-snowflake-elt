-- PURPOSE: Create a dimensional table of all unique users who have interacted with movies
-- Combines users from both ratings and tags to get complete user list
WITH ratings AS (
  SELECT DISTINCT user_id FROM {{ ref('src_ratings') }}
),

tags AS (
  SELECT DISTINCT user_id FROM {{ ref('src_tags') }}
)
-- Combine users from both sources to capture all active users
-- UNION automatically removes duplicates if a user appears in both sources
SELECT DISTINCT user_id
FROM (
  SELECT * FROM ratings
  UNION
  SELECT * FROM tags
)

--Here outer Distinct is redundant as UNION already removes duplicates.