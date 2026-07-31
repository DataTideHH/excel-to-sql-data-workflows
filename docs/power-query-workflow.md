# Power Query Workflow

## Objective
Recreate core Excel and SQL transformations in Power Query M with transparent refresh-time steps.

## Suggested Steps in Power BI or Excel Power Query
1. Load `customers.csv`, `products.csv`, and `orders.csv`.
2. Set explicit data types (date, whole number, decimal number, text).
3. Replace null discounts with `0`.
4. Merge Orders with Customers and Products using key columns.
5. Add `Revenue` column: `quantity * unit_price * (1 - discount_pct / 100)`.
6. Group for regional totals and monthly summaries.
7. Build duplicate checks using Group By + row count.

## M Patterns Covered
- Conditional column
- Merge Queries
- Filter rows
- Group and aggregate
- Remove duplicates
- Sort and keep top rows
- Index + cumulative pattern

Reference snippets are available in `power-bi/power-query-m.md`.
