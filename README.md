# SQL Analytics & Practice Collection 

## Overview
This repository contains a comprehensive collection of SQL scripts, queries, and analytical problems I have developed and practiced. It covers everything from core database operations to advanced data transformation, analytical query optimization, and real-world business case studies.

---

## 📂 Repository Structure & Key Topics

| File | Description & Key Concepts Covered |
| :--- | :--- |
| **`Window_functions.sql`** | Advanced analytical functions: `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LEAD()`, `LAG()`, running totals, and moving averages. |
| **`CTE.sql`** | Common Table Expressions for modular, readable code and complex multi-step queries. |
| **`Subqueries.sql`** | Scalar, correlated, and nested subqueries in `WHERE`, `FROM`, and `SELECT` clauses. |
| **`Case_when.sql`** | Conditional logic, data binning, segmentations, and custom metric categorization. |
| **`Joins_union.sql`** | Relational data merging (`INNER`, `LEFT`, `RIGHT`, `FULL OUTER JOIN`) and set operations (`UNION`, `UNION ALL`). |
| **`String_functions.sql`** | Data cleaning and text parsing using `CONCAT`, `SUBSTRING`, `TRIM`, `REPLACE`, `LOWER/UPPER`, and pattern matching. |
| **`Date_Time.sql`** | Date arithmetic, filtering, formatting, and time-series aggregations (`EXTRACT`, `DATE_TRUNC`, `DATE_DIFF`). |
| **`Nested_bigquery.sql`** | Handling nested and repeated fields (`STRUCT`, `ARRAY`, `UNNEST`) tailored for Google BigQuery. |
| **`Optimization.sql`** | Query performance tuning, efficient filtering, indexing strategies, and reducing execution time. |
| **`marketing_performance_analysis.sql`** | End-to-end SQL case study analyzing marketing performance metrics, conversion rates, and ROI. |

---
### 💼 End-to-End SQL Case Studies

| Case Study File | Description & Concepts Used |
| :--- | :--- |
| **`user_activity_email_performance_case.sql`** | **Comprehensive User & Email Activity Analysis:** <br>• Built a unified dataset merging user account metrics and email interaction metrics (sent, opened, clicked) using `UNION ALL` to prevent granularity conflicts. <br>• Applied multi-level `CTE`s for modular logic and complex data aggregation. <br>• Used Window Functions (`SUM() OVER`, `DENSE_RANK() OVER`) to calculate total country-level performance and rank top 10 markets. <br>• Prepared data structure for Looker Studio visualization. |
