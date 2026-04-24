# 🎬 Film Industry Analysis - Power BI and SQL  

## 🔍 Overview  
This project was completed as part of a Data Technician Bootcamp. It focuses on using **SQL and Power BI** to clean, analyse, and visualise film industry data, transforming raw datasets into an interactive dashboard that supports data-driven decision-making.  

The analysis explores key areas such as **ROI, revenue, budgets, ratings, genres, decades, and production companies**, providing insights into both commercial and critical performance within the movie industry.

---

## 🚀 Skills Demonstrated  

### ✔️ Data Transformation & Cleaning (SQL + Power Query)  
- Filtered datasets to remove unrealistic or low-quality data (e.g. low budget films)  
- Cleaned and structured data for analysis  
- Handled missing values and ensured consistency  
- Prepared datasets for efficient reporting and dashboard use  

---

### ✔️ Data Modelling & DAX  
- Built structured datasets from SQL outputs  
- Created calculated metrics such as:  
  - ROI (Revenue / Budget)  
  - Average ratings  
  - Total profit by company  
- Applied aggregation and grouping logic for analysis  
- Enabled efficient reporting through structured data models  

---

### ✔️ SQL Data Analysis  

#### 🔹 Top ROI Films
```sql
SELECT title, ROUND(revenue/budget, 2) AS roi
FROM tmdb_5000_movies
WHERE budget > 1000000
ORDER BY roi DESC
LIMIT 10;

<img width="1951" height="1071" alt="Screenshot 2026-03-24 045351" src="https://github.com/user-attachments/assets/e76cdb4f-a94c-4d56-ba01-b261f1ce19b5" />
