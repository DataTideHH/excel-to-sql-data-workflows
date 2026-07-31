# Excel Workflow

## Objective
Use Excel Tables and formulas to implement analytical patterns that match SQL and DAX intent.

## Workbook
Generated file: `excel/excel_sql_workflows.xlsx`

Sheets:
- `Customers` (Excel Table)
- `Products` (Excel Table)
- `Orders` (Excel Table)
- `Exercises` (formula patterns)
- `Summary` (core KPI formulas)

## Steps
1. Regenerate raw data and workbook with scripts in `scripts/`.
2. Open the workbook and inspect table structures.
3. Add helper columns in `Orders` as needed for formulas.
4. Compare results with SQL outputs in `sql/06_reporting_queries.sql`.

## Formula examples
- Conditional bucket: `IF` / `IFS`
- Region lookup: `XLOOKUP`
- Conditional sum: `SUMIFS`
- Conditional count: `COUNTIFS`
- Distinct lists: `UNIQUE`
- Running total: expanding `SUM` with anchored range
- Ranking: `RANK.EQ`
- Missing values: `IFERROR`
- Duplicate detection: `COUNTIF`

## Notes
- Keep sort order deterministic before evaluating cumulative formulas.
- Where key columns are not unique, document whether first-match behavior is acceptable.
