# Data dictionary

This project uses the TMDB 5000 Movies dataset. The table documents the fields used and their main quality considerations.

| Field | Expected type | Use | Quality consideration |
|---|---|---|---|
| `id` | Whole number | Unique movie identifier | Check for duplicate IDs |
| `title` | Text | Film labels and rankings | Blank and duplicate titles require review |
| `release_date` | Date | Year filtering and decade grouping | Missing dates are excluded from time analysis |
| `budget` | Whole number / currency | Cost, profit and ROI | Zero often means unavailable data |
| `revenue` | Whole number / currency | Revenue, profit and ROI | Zero often means unavailable data |
| `vote_average` | Decimal number | Audience-rating comparison | Interpret alongside `vote_count` |
| `vote_count` | Whole number | Rating reliability threshold | Low counts can make averages unstable |
| `genres` | Text / nested JSON | Genre filter and comparison | Use a film–genre bridge table for multiple values |
| `production_companies` | Text / nested JSON | Studio comparison | Multi-value attribution can double-count profit |

## Calculated fields

| Metric | Definition | Interpretation |
|---|---|---|
| Profit | `revenue - budget` | Absolute commercial return before unrecorded costs |
| Film ROI multiplier | `revenue / budget` | Revenue generated for each budget dollar |
| Portfolio ROI multiplier | `SUM(revenue) / SUM(budget)` | Scale-weighted ROI across a selected group |
| Decade | `FLOOR(YEAR(release_date) / 10) * 10` | Release year grouped into ten-year periods |

## Recommended model improvement

For a future version, use a star schema with a `Movies` fact table plus `Genres`, `Production Companies`, `Movie Genre` and `Movie Company` bridge tables. This supports accurate many-to-many filtering and makes the attribution method explicit.
