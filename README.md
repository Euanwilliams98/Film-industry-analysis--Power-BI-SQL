# Film Industry Analysis | SQL and Power BI

I used the TMDB 5000 Movies dataset to explore film budgets, revenue, profit, return on investment (ROI), ratings, genres and production companies. I used SQL and Power Query to prepare the data, then created a Power BI dashboard to compare the results.

## Questions I looked at

- Which films had the highest return compared with their budgets?
- Which production companies had the highest combined profit in the dataset?
- How did average film budgets change over time?
- Which genres had the highest audience ratings?
- How do the results change when I filter out films with very small budgets or low vote counts?

## Dashboard

![Film Industry Analysis dashboard](https://github.com/user-attachments/assets/e76cdb4f-a94c-4d56-ba01-b261f1ce19b5)

The dashboard includes year and genre filters, KPI cards, ranked comparisons and a trend by decade. The filters make it possible to look at the overall figures or focus on particular films and groups.

## What I did

- Used SQL to look through the data and calculate summary figures.
- Used Power Query to set data types and prepare genre and production-company fields.
- Created DAX measures for revenue, budget, profit, ROI and average rating.
- Added filters and charts to compare films and groups.
- Used minimum budget and vote-count filters for some comparisons.

## Example SQL query

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

I used `NULLIF` to avoid dividing by zero. The budget filter helps leave out films with very small budget figures in this comparison.

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

For group-level ROI, I divided total revenue by total budget rather than taking a simple average of each film's ROI.

## What I found

### Film returns

Snow White and the Seven Dwarfs had the highest film-level ROI shown in the dashboard at around 124 times its budget. Gone with the Wind followed at around 100 times, then Saw at around 87 times.

A high ROI is not the same as the highest cash profit. It compares the reported revenue with the reported budget.

### Production companies

Paramount Pictures had the largest combined profit in the comparison at approximately $26bn, followed by Universal Pictures at around $24bn and Walt Disney Pictures at around $19bn.

### Budgets over time

Average budgets increased across the decades shown, from roughly $5m in the 1960s to around $34m in the 2010s. These figures have not been adjusted for inflation.

### Audience ratings

Western and Documentary were the highest-rated genres shown, both averaging just above 7.0. The overall average rating in the dashboard was 6.11.

## What I learned

This project gave me practice using SQL, Power Query and DAX together. I learned how to calculate profit and ROI, compare results across groups and build a dashboard with filters. It also helped me understand why it is useful to look at more than one measure when comparing film performance.

## Tools used

SQL, MySQL, Power Query, Power BI and DAX.

## Author

Euan Williams

[View my other projects](https://github.com/Euanwilliams98) · [LinkedIn](https://www.linkedin.com/in/euan-williams-081755232/)