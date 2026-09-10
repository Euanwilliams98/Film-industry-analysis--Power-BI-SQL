-- Film Industry Analysis: portfolio queries
-- SQL dialect: MySQL 8+

-- Rules: positive revenue and budget >= $1m for financial comparisons;
-- at least 50 votes for ratings; ROI = revenue / budget; profit = revenue - budget.

-- 1. Portfolio-level KPIs.
SELECT
    COUNT(*) AS analysed_films,
    ROUND(SUM(revenue) / 1000000000, 2) AS total_revenue_bn,
    ROUND(SUM(budget) / 1000000000, 2) AS total_budget_bn,
    ROUND(SUM(revenue - budget) / 1000000000, 2) AS total_profit_bn,
    ROUND(AVG(vote_average), 2) AS average_rating,
    ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2) AS portfolio_roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000 AND revenue > 0;

-- 2. Top films by ROI multiplier.
SELECT title, release_date, budget, revenue,
       revenue - budget AS profit,
       ROUND(revenue / NULLIF(budget, 0), 2) AS roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000 AND revenue > 0
ORDER BY roi_multiplier DESC
LIMIT 10;

-- 3. Top films by absolute profit: a useful counterpoint to ROI.
SELECT title, release_date, budget, revenue,
       revenue - budget AS profit,
       ROUND(revenue / NULLIF(budget, 0), 2) AS roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000 AND revenue > 0
ORDER BY profit DESC
LIMIT 10;

-- 4. Budget and performance by decade.
SELECT
    FLOOR(YEAR(release_date) / 10) * 10 AS decade,
    COUNT(*) AS film_count,
    ROUND(AVG(budget) / 1000000, 2) AS average_budget_m,
    ROUND(AVG(revenue) / 1000000, 2) AS average_revenue_m,
    ROUND(AVG(revenue - budget) / 1000000, 2) AS average_profit_m,
    ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2) AS portfolio_roi_multiplier
FROM tmdb_5000_movies
WHERE release_date IS NOT NULL AND budget >= 1000000 AND revenue > 0
GROUP BY decade
ORDER BY decade;

-- 5. Rating results by the prepared genre field.
-- If genres contains raw TMDB JSON, first normalise it in Power Query or a bridge table.
SELECT genres AS genre, COUNT(*) AS film_count, SUM(vote_count) AS total_votes,
       ROUND(AVG(vote_average), 2) AS average_rating
FROM tmdb_5000_movies
WHERE vote_count >= 50 AND genres IS NOT NULL AND TRIM(genres) <> ''
GROUP BY genres
HAVING COUNT(*) >= 5
ORDER BY average_rating DESC, film_count DESC;

-- 6. Studio profitability using the prepared production-company field.
-- Document an allocation rule for films with multiple companies to avoid double-counting.
SELECT production_companies AS production_company, COUNT(*) AS film_count,
       ROUND(SUM(revenue - budget) / 1000000000, 2) AS total_profit_bn,
       ROUND(AVG(revenue - budget) / 1000000, 2) AS average_profit_m,
       ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2) AS portfolio_roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000 AND revenue > 0
  AND production_companies IS NOT NULL AND TRIM(production_companies) <> ''
GROUP BY production_companies
HAVING COUNT(*) >= 3
ORDER BY total_profit_bn DESC
LIMIT 10;

-- 7. Relationship between budget band and performance.
WITH classified_films AS (
    SELECT
        CASE
            WHEN budget < 10000000 THEN '$1m-$10m'
            WHEN budget < 50000000 THEN '$10m-$50m'
            WHEN budget < 100000000 THEN '$50m-$100m'
            ELSE '$100m+'
        END AS budget_band,
        budget, revenue, vote_average
    FROM tmdb_5000_movies
    WHERE budget >= 1000000 AND revenue > 0
)
SELECT budget_band, COUNT(*) AS film_count,
       ROUND(AVG(budget) / 1000000, 2) AS average_budget_m,
       ROUND(AVG(revenue - budget) / 1000000, 2) AS average_profit_m,
       ROUND(SUM(revenue) / NULLIF(SUM(budget), 0), 2) AS portfolio_roi_multiplier,
       ROUND(AVG(vote_average), 2) AS average_rating
FROM classified_films
GROUP BY budget_band
ORDER BY MIN(budget);
