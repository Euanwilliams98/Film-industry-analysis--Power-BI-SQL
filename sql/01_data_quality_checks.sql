-- Film Industry Analysis: data-quality checks
-- SQL dialect: MySQL 8+

-- 1. Confirm dataset size and ID coverage.
SELECT COUNT(*) AS row_count, COUNT(DISTINCT id) AS unique_movie_ids
FROM tmdb_5000_movies;

-- 2. Identify duplicate movie IDs.
SELECT id, COUNT(*) AS occurrence_count
FROM tmdb_5000_movies
GROUP BY id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, id;

-- 3. Profile missing or unusable values in important fields.
SELECT
    SUM(title IS NULL OR TRIM(title) = '') AS missing_title,
    SUM(release_date IS NULL) AS missing_release_date,
    SUM(budget IS NULL OR budget <= 0) AS unusable_budget,
    SUM(revenue IS NULL OR revenue <= 0) AS unusable_revenue,
    SUM(vote_average IS NULL) AS missing_rating,
    SUM(vote_count IS NULL OR vote_count <= 0) AS missing_votes
FROM tmdb_5000_movies;

-- 4. Check numeric ranges for impossible or suspicious values.
SELECT
    MIN(budget) AS min_budget, MAX(budget) AS max_budget,
    MIN(revenue) AS min_revenue, MAX(revenue) AS max_revenue,
    MIN(vote_average) AS min_rating, MAX(vote_average) AS max_rating,
    MIN(release_date) AS earliest_release, MAX(release_date) AS latest_release
FROM tmdb_5000_movies;

-- 5. Inspect records excluded from financial analysis.
SELECT id, title, budget, revenue
FROM tmdb_5000_movies
WHERE budget IS NULL OR revenue IS NULL OR budget <= 0 OR revenue <= 0
ORDER BY title;

-- 6. Check for exact duplicate film records.
SELECT title, release_date, COUNT(*) AS occurrence_count
FROM tmdb_5000_movies
GROUP BY title, release_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, title;
