-- Film industry analysis: queries used to explore the TMDB dataset
-- SQL dialect: MySQL 8.0+
--
-- Financial comparisons use films with a recorded budget of at least $1m
-- and positive revenue. Rating comparisons use films with at least 50 votes.
-- ROI is revenue divided by budget; profit is revenue minus budget.

-- 1. Overall figures for the films included in the financial analysis.
-- Ratings are averaged separately so films with fewer than 50 votes do not
-- affect the rating KPI.
SELECT
    COUNT(*) AS analysed_films,
    ROUND(SUM(revenue) / 1000000000, 2) AS total_revenue_bn,
    ROUND(SUM(budget) / 1000000000, 2) AS total_budget_bn,
    ROUND(SUM(revenue - budget) / 1000000000, 2) AS total_profit_bn,
    ROUND(AVG(CASE WHEN vote_count >= 50 THEN vote_average END), 2)
        AS average_rating_50_plus_votes,
    SUM(vote_count >= 50) AS films_in_rating_average,
    ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2)
        AS portfolio_roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000
  AND revenue > 0;

-- 2. Films with the highest revenue-to-budget ratio.
SELECT
    title,
    release_date,
    budget,
    revenue,
    revenue - budget AS profit,
    ROUND(revenue / NULLIF(budget, 0), 2) AS roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000
  AND revenue > 0
ORDER BY roi_multiplier DESC
LIMIT 10;

-- 3. Films with the highest absolute profit.
-- This is a useful comparison because high ROI does not always mean
-- the largest amount of profit.
SELECT
    title,
    release_date,
    budget,
    revenue,
    revenue - budget AS profit,
    ROUND(revenue / NULLIF(budget, 0), 2) AS roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000
  AND revenue > 0
ORDER BY profit DESC
LIMIT 10;

-- 4. Average budget, revenue and profit by release decade.
SELECT
    FLOOR(YEAR(release_date) / 10) * 10 AS decade,
    COUNT(*) AS film_count,
    ROUND(AVG(budget) / 1000000, 2) AS average_budget_m,
    ROUND(AVG(revenue) / 1000000, 2) AS average_revenue_m,
    ROUND(AVG(revenue - budget) / 1000000, 2) AS average_profit_m,
    ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2)
        AS portfolio_roi_multiplier
FROM tmdb_5000_movies
WHERE release_date IS NOT NULL
  AND budget >= 1000000
  AND revenue > 0
GROUP BY decade
ORDER BY decade;

-- 5. Average audience rating by genre.
-- TMDB stores genres as a JSON array. JSON_TABLE turns each genre into
-- its own row so a film can be included under each genre it belongs to.
-- Genre totals should not be added together because films can have
-- more than one genre.
SELECT
    genre_rows.genre,
    COUNT(DISTINCT m.id) AS film_count,
    SUM(m.vote_count) AS total_votes,
    ROUND(AVG(m.vote_average), 2) AS average_rating
FROM tmdb_5000_movies AS m
JOIN JSON_TABLE(
    m.genres,
    '$[*]' COLUMNS (
        genre VARCHAR(100) PATH '$.name'
    )
) AS genre_rows
WHERE m.vote_count >= 50
  AND JSON_VALID(m.genres)
GROUP BY genre_rows.genre
HAVING COUNT(DISTINCT m.id) >= 5
ORDER BY average_rating DESC, film_count DESC;

-- 6. Production-company comparison.
-- A film can list several production companies. Each listed company is
-- shown against the full film result here, so company totals are not
-- additive and should not be combined into one industry-wide total.
SELECT
    company_rows.production_company,
    COUNT(DISTINCT m.id) AS film_count,
    ROUND(SUM(m.revenue - m.budget) / 1000000000, 2)
        AS attributed_profit_bn,
    ROUND(AVG(m.revenue - m.budget) / 1000000, 2)
        AS average_film_profit_m,
    ROUND(
        SUM(m.revenue) / NULLIF(SUM(m.budget), 0),
        2
    ) AS portfolio_roi_multiplier
FROM tmdb_5000_movies AS m
JOIN JSON_TABLE(
    m.production_companies,
    '$[*]' COLUMNS (
        production_company VARCHAR(200) PATH '$.name'
    )
) AS company_rows
WHERE m.budget >= 1000000
  AND m.revenue > 0
  AND JSON_VALID(m.production_companies)
GROUP BY company_rows.production_company
HAVING COUNT(DISTINCT m.id) >= 3
ORDER BY attributed_profit_bn DESC
LIMIT 10;

-- 7. Compare results across budget bands.
WITH classified_films AS (
    SELECT
        CASE
            WHEN budget < 10000000 THEN '$1m-$10m'
            WHEN budget < 50000000 THEN '$10m-$50m'
            WHEN budget < 100000000 THEN '$50m-$100m'
            ELSE '$100m+'
        END AS budget_band,
        budget,
        revenue,
        vote_average,
        vote_count
    FROM tmdb_5000_movies
    WHERE budget >= 1000000
      AND revenue > 0
)
SELECT
    budget_band,
    COUNT(*) AS film_count,
    ROUND(AVG(budget) / 1000000, 2) AS average_budget_m,
    ROUND(AVG(revenue - budget) / 1000000, 2) AS average_profit_m,
    ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2)
        AS portfolio_roi_multiplier,
    ROUND(AVG(CASE WHEN vote_count >= 50 THEN vote_average END), 2)
        AS average_rating_50_plus_votes
FROM classified_films
GROUP BY budget_band
ORDER BY MIN(budget);
