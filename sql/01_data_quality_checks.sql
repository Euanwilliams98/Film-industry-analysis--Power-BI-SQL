-- Film industry analysis: data checks and summary queries
-- SQL dialect: MySQL 8.0+

-- 1. Check the size of the dataset and whether movie IDs are unique.
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT id) AS unique_movie_ids
FROM tmdb_5000_movies;

-- 2. Find any movie IDs that appear more than once.
SELECT id, COUNT(*) AS occurrence_count
FROM tmdb_5000_movies
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, id;

-- 3. Check important fields for missing or unusable values.
SELECT
    SUM(title IS NULL OR TRIM(title) = '') AS missing_title,
    SUM(release_date IS NULL) AS missing_release_date,
    SUM(budget IS NULL OR budget <= 0) AS unusable_budget,
    SUM(revenue IS NULL OR revenue <= 0) AS unusable_revenue,
    SUM(vote_average IS NULL) AS missing_rating,
    SUM(vote_count IS NULL OR vote_count <= 0) AS missing_votes
FROM tmdb_5000_movies;

-- 4. Check the ranges of the numeric and date fields.
SELECT
    MIN(budget) AS min_budget,
    MAX(budget) AS max_budget,
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    MIN(vote_average) AS min_rating,
    MAX(vote_average) AS max_rating,
    MIN(release_date) AS earliest_release,
    MAX(release_date) AS latest_release
FROM tmdb_5000_movies;

-- 5. Review films that will be left out of the financial comparisons.
SELECT id, title, budget, revenue
FROM tmdb_5000_movies
WHERE budget IS NULL
   OR revenue IS NULL
   OR budget <= 0
   OR revenue <= 0
ORDER BY title;

-- 6. Check for repeated title and release-date combinations.
-- This is a review list, not proof that the records are duplicates:
-- remakes and re-releases can share similar details.
SELECT title, release_date, COUNT(*) AS occurrence_count
FROM tmdb_5000_movies
GROUP BY title, release_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, title;
