# Power BI Artifacts

This folder documents a reproducible Power BI setup without committing a `.pbix` file.

## Files
- `dax-measures.md`: required measures and optional helper columns
- `power-query-m.md`: Power Query M examples for data shaping

## Connect Options
1. CSV path: Load `data/raw/*.csv`.
2. SQL path: Connect to SQL Server tables in schema `workflow_demo`.

## Reconciliation goal
Match core KPIs with SQL queries in `sql/06_reporting_queries.sql` and expected CSV outputs in `data/expected/`.
