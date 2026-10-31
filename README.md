# Film Industry Performance Analysis | SQL and Power BI

I used the TMDB 5000 Movies dataset to explore how films perform commercially and with audiences. I worked with SQL and Power Query to prepare the data, then built a Power BI dashboard to compare budgets, revenue, profit, return on investment (ROI), ratings, genres and production companies.

The main question I wanted to explore was how to compare a film's financial return with its budget and audience reception, without treating one measure as the whole picture.

## Questions I explored

- Which films had the highest return relative to their budgets?
- Which production companies had the largest combined profit in the dataset?
- How did average film budgets change across decades?
- Which genres had the highest audience ratings?
- How do budget and vote-count thresholds affect the results?

## Dashboard

![Film Industry Analysis dashboard](https://github.com/user-attachments/assets/e76cdb4f-a94c-4d56-ba01-b261f1ce19b5)

The report includes year and genre filters, KPI cards, ranked comparisons and a decade trend. Users can move from the overall figures to individual films, genres and studios.

## How I approached the project

- Used SQL to inspect the data, check values and calculate summary measures.
- Used Power Query to correct data types, handle nulls and prepare genre and production-company fields.
- Created DAX measures for revenue, budget, profit, ROI and average rating.
- Added filters and visuals to compare films and groups.
- Applied minimum budget and vote-count rules where appropriate to reduce the effect of unreliable or unusual records.

## Example SQL

\`\`\`sql
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
\`\`\`

The \`NULLIF\` check prevents division by zero. The budget filter also reduces the effect of films with very small or potentially incomplete budget figures.

## DAX measures

\`\`\`DAX
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
\`\`\`

For group-level ROI, I used total revenue divided by total budget. This gives more weight to films with larger budgets than taking a simple average of each film's ROI.

## What I found

### Film returns

Snow White and the Seven Dwarfs had the highest film-level ROI shown in the dashboard at around 124 times its budget. Gone with the Wind followed at around 100 times, then Saw at around 87 times.

A high ROI does not necessarily mean the highest cash profit. It shows the return compared with the amount reported as the budget.

### Production companies

Paramount Pictures had the largest combined profit in the comparison at approximately $26bn, followed by Universal Pictures at around $24bn and Walt Disney Pictures at around $19bn.

These totals are affected by how many films each company has in the dataset. Comparing profit per film as well as total profit would give a fairer view of performance.

### Budgets over time

Average budgets increased across the decades shown, from roughly $5m in the 1960s to around $34m in the 2010s. These are nominal figures, so inflation has not been taken into account.

### Audience ratings

Western and Documentary were the highest-rated genres shown, both averaging just above 7.0. The overall average rating in the dashboard was 6.11.

Ratings and commercial performance measure different things, so I would look at them together rather than assume a highly rated genre will also generate the most revenue.

## Things to bear in mind

- TMDB budget and revenue figures may be missing or incomplete.
- The dataset is not a complete record of the film industry.
- Financial figures are not adjusted for inflation and do not include all marketing or distribution costs.
- Films can have more than one genre or production company, so the way those values are allocated affects group totals.
- The analysis shows patterns in the dataset; it does not prove that a particular genre, budget or studio caused a result.

## Repository structure

\`\`\`text
.
├── README.md
├── docs/
│   └── data_dictionary.md
└── sql/
    ├── 01_data_quality_checks.sql
    └── 02_analysis_queries.sql
\`\`\`

## Tools

SQL, MySQL, Power Query, Power BI and DAX.

## Author

Euan Williams

[View my other projects](https://github.com/Euanwilliams98) · [LinkedIn](https://www.linkedin.com/in/euan-williams-081755232/)