# Film Industry Performance Analysis | SQL & Power BI

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/status-complete-2E8B57)

## Project summary

This portfolio project analyses film-industry performance using the **TMDB 5000 Movies dataset**. I used SQL and Power Query to validate and prepare the data, then built an interactive Power BI dashboard to compare commercial performance, audience ratings, genres, decades and production companies.

The aim was to answer a practical question:

> Which films, genres and studios perform most strongly—and how should return, scale and audience reception be interpreted together?

## Business questions

- Which films generated the highest return on investment (ROI)?
- Which production companies generated the greatest total profit?
- How did average film budgets change by decade?
- Which genres received the strongest audience ratings?
- How do minimum-budget and vote-count rules change the reliability of the results?

## Dashboard

![Film Industry Analysis dashboard](https://github.com/user-attachments/assets/e76cdb4f-a94c-4d56-ba01-b261f1ce19b5)

The report contains year and genre filters, headline KPI cards, ranked bar charts and a decade trend. Together, these let a user move from an industry overview to specific films, genres and studios.

## Tools and skills demonstrated

| Area | Evidence |
|---|---|
| SQL | Data profiling, validation, calculated fields, aggregation, filtering and ranking |
| Power Query | Type correction, null handling and preparation of nested genre/company fields |
| Power BI | Interactive slicers, KPI cards, trend analysis and ranked comparisons |
| DAX | Revenue, budget, profit, ROI and rating measures |
| Analytical judgement | Minimum budget and vote-count thresholds to reduce misleading outliers |
| Communication | Business questions, documented assumptions, findings and recommendations |

## Data preparation and quality controls

The raw dataset contains zero values, missing dates and nested text fields. These can produce misleading results if they are treated as valid observations. The analysis therefore:

1. checks row counts, nulls, duplicate IDs and invalid values;
2. excludes zero or missing budgets from ROI calculations;
3. uses a **$1 million minimum budget** for ROI and profitability comparisons;
4. uses a **minimum of 50 votes** for genre-rating comparisons;
5. calculates profit as `revenue - budget` and ROI as `revenue / budget`;
6. derives decade from `release_date`; and
7. treats the dashboard as a descriptive view of the dataset—not a forecast of future success.

The reusable SQL is available in:

- [`sql/01_data_quality_checks.sql`](sql/01_data_quality_checks.sql)
- [`sql/02_analysis_queries.sql`](sql/02_analysis_queries.sql)

## Example SQL

```sql
SELECT
    title,
    budget,
    revenue,
    revenue - budget AS profit,
    ROUND(revenue / NULLIF(budget, 0), 2) AS roi_multiplier
FROM tmdb_5000_movies
WHERE budget >= 1000000
  AND revenue > 0
ORDER BY roi_multiplier DESC
LIMIT 10;
```

`NULLIF` prevents division by zero, while the budget threshold reduces distortion from films with very small or unreliable reported budgets.

## DAX measures

```DAX
Total Revenue = SUM(Movies[revenue])

Total Budget = SUM(Movies[budget])

Total Profit = [Total Revenue] - [Total Budget]

Average Rating = AVERAGE(Movies[vote_average])

ROI Multiplier =
DIVIDE(
    SUM(Movies[revenue]),
    SUM(Movies[budget]),
    BLANK()
)
```

The portfolio uses **ratio of sums** for aggregated ROI so that results are weighted by financial scale. Film-level ROI remains available for title rankings.

## Key findings

### 1. High ROI does not necessarily mean the highest cash profit

*Snow White and the Seven Dwarfs* produced the highest film-level ROI shown in the dashboard at approximately **124×**, followed by *Gone with the Wind* at approximately **100×** and *Saw* at approximately **87×**. These results demonstrate exceptional efficiency relative to reported budget, but they should not be interpreted as the films that generated the most profit in absolute dollars.

### 2. Studio scale and film efficiency tell different stories

Paramount Pictures leads the studio comparison with approximately **$26bn** in cumulative profit, followed by Universal Pictures at approximately **$24bn** and Walt Disney Pictures at approximately **$19bn**. This ranking favours studios represented by many commercially successful films, so it measures portfolio scale as well as title performance.

### 3. Budgets increased substantially over time

The decade view rises from roughly **$5m in the 1960s** and **$13m in the 1980s** to around **$29m in the 1990s** and **$34m in the 2010s**. The pattern indicates increasing production scale, although the figures are nominal and are not adjusted for inflation.

### 4. Audience rating and commercial return are separate outcomes

Western and Documentary are the highest-rated genres shown, both averaging just above **7.0**, while the dashboard-wide average rating is **6.11**. A genre can perform well with audiences without generating the greatest revenue or profit, so rating should be considered alongside financial measures rather than used as a substitute for them.

## Recommendations

- Evaluate projects using both **profit** and **ROI**: profit captures scale, while ROI captures budget efficiency.
- Compare studios using profit per film and film count as well as total profit to avoid rewarding catalogue size alone.
- Apply a minimum vote threshold whenever ratings are compared, and show the sample size beside each result.
- Adjust historical budgets and revenues for inflation before making investment decisions across decades.
- Treat genre as one factor among many; release strategy, franchise strength, marketing and distribution are not represented in this dataset.

## Limitations

- TMDB values may be incomplete or self-reported, particularly for budget and revenue.
- The dashboard covers the films included in this dataset and is not a complete census of the industry.
- Financial values are nominal and do not account for inflation, marketing costs or distribution fees.
- A film can belong to multiple genres or production companies; totals depend on the transformation and attribution method used.
- Correlation in this descriptive analysis does not establish that a genre, budget or studio caused an outcome.

## What I would develop next

- Add inflation-adjusted budget and revenue measures.
- Create a normalised bridge table for films with multiple genres and production companies.
- Add profit margin, median ROI, film count and confidence/sample-size context to tooltips.
- Build a drill-through page for film-level detail and a studio comparison page.
- Test relationships statistically and create a simple, validated revenue model.

## Repository structure

```text
.
├── README.md
├── docs/
│   └── data_dictionary.md
└── sql/
    ├── 01_data_quality_checks.sql
    └── 02_analysis_queries.sql
```

## Author

**Euan Williams** — early-career Business Intelligence and Data Analyst

[GitHub profile](https://github.com/Euanwilliams98)
