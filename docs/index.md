---
title: Excel to SQL Data Workflows
description: Equivalent analytical intent across Excel, Power Query, SQL Server and Power BI
---

# Excel to SQL Data Workflows

**One bounded sales-order scenario, four analytical tools, and one shared business logic.**

[View repository](https://github.com/DataTideHH/excel-to-sql-data-workflows) · [View CI](https://github.com/DataTideHH/excel-to-sql-data-workflows/actions/workflows/python-quality.yml) · [Download the Excel workbook](https://github.com/DataTideHH/excel-to-sql-data-workflows/raw/main/excel/excel_sql_workflows.xlsx) · [DataTideHH portfolio](https://datatidehh.de/)

---

## Project purpose

This project shows how the same analytical questions can be expressed across:

- Excel formulas and Tables
- Power Query M
- Microsoft SQL Server T-SQL
- Power BI DAX

> The project compares **equivalent analytical intent, not literal one-to-one translation**.

The important question is not whether four expressions look alike. It is whether they preserve the same business meaning while respecting each tool's execution model, context rules and data semantics.

---

## What the project demonstrates

| Area | Evidence |
|---|---|
| Cross-tool reasoning | One business scenario implemented across Excel, Power Query, T-SQL and DAX |
| Reproducibility | Six deterministic CSV artifacts and one byte-stable Excel workbook |
| Automated verification | 19 pytest tests plus Ruff |
| Cross-platform CI | Windows and Ubuntu matrix with committed-artifact drift checks |
| Data-quality thinking | Missing values, duplicate lookup keys and ambiguous joins are included intentionally |
| Honest scope | Synthetic data, no `.pbix`, and no claim of a production data platform |

The generated workbook is created without Excel automation or macros. Its ZIP package is normalized after generation so that the committed binary can be reproduced consistently across Windows and Linux.

---

## Business scenario

The repository uses a deterministic fictional sales-order dataset containing:

- 52 orders
- 12 customers
- 7 products
- 5 regions
- multiple reporting months
- quantity, unit price and discount data
- order status and sales-representative fields
- selected missing values
- deliberate duplicate lookup values

These controlled edge cases make it possible to compare not only syntax, but also the consequences of different semantics.

---

## Comparison map

| Analytical intent | Excel | SQL Server | Power Query | Power BI / DAX |
|---|---|---|---|---|
| Conditional category | `IF` / `IFS` | `CASE` | Conditional Column | `IF` / `SWITCH` |
| Lookup | `XLOOKUP` | `LEFT JOIN` | Merge Queries | Relationship / `RELATED` |
| Conditional sum | `SUMIFS` | `SUM` + predicates / `GROUP BY` | Filter + Group By | `CALCULATE(SUM(...))` |
| Conditional count | `COUNTIF` / `COUNTIFS` | `COUNT(*)` with predicates | Filter + Row Count | `CALCULATE(COUNTROWS(...))` |
| Unique values | `UNIQUE` | `DISTINCT` | Remove Duplicates | `DISTINCT` / `VALUES` |
| Sort and top-N | `SORT` / `SORTBY` / `LARGE` | `ORDER BY` + `TOP` | Sort + Keep Top Rows | `TOPN` / rank measure |
| Running total | Expanding `SUM` | Windowed `SUM` | Indexed cumulative logic | Cumulative measure |
| Ranking | `RANK.EQ` | `RANK` / `DENSE_RANK` / `ROW_NUMBER` | Grouped index | `RANKX` |
| Missing values | Blanks + `IFERROR` | `NULL` / `COALESCE` | `null` handling | `BLANK()` / `COALESCE` |
| Duplicate detection | `COUNTIF` | `GROUP BY ... HAVING` | Group By + count | Duplicate-count measure |

Read the complete [comparison matrix](comparison-matrix.md) for the detailed mapping.

---

## Semantic differences that matter

Similar-looking operations can produce different results:

- `XLOOKUP` normally returns one match, while a SQL join can multiply rows when the lookup key is not unique.
- Excel blanks, empty text, SQL `NULL`, Power Query `null` and DAX `BLANK()` are related but not interchangeable.
- Excel calculations are primarily cell-context based.
- SQL evaluates set-based query logic.
- Power Query is a refresh-time transformation pipeline.
- DAX depends on row context, filter context and model relationships.
- Running totals require deterministic ordering.
- Ranking functions differ in tie handling.
- Numeric precision, rounding, filtering and text comparison can vary by engine and configuration.

Read [Semantic Differences](semantic-differences.md) for the full discussion.

---

## Strongest artifacts

### Excel

- [Generated workbook](https://github.com/DataTideHH/excel-to-sql-data-workflows/raw/main/excel/excel_sql_workflows.xlsx)
- [Workbook guide](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/excel/README.md)
- [Formula reference](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/excel/formulas-reference.md)

### SQL Server

- [Excel and SQL equivalents](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/sql/03_excel_sql_equivalents.sql)
- [Window functions](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/sql/04_window_functions.sql)
- [Data-quality checks](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/sql/05_data_quality_checks.sql)
- [Reporting queries](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/sql/06_reporting_queries.sql)

### Power BI

- [DAX measures](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/power-bi/dax-measures.md)
- [Power Query M](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/power-bi/power-query-m.md)
- [Data-model guidance](data-model.md)

### Reproducibility and quality

- [Python quality workflow](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/.github/workflows/python-quality.yml)
- [Sample-data tests](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/tests/test_sample_data.py)
- [Expected-result tests](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/tests/test_expected_results.py)
- [Workbook generator](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/scripts/generate_excel_workbook.py)

---

## Suggested reviewer path

1. Scan the [comparison matrix](comparison-matrix.md).
2. Read [Semantic Differences](semantic-differences.md).
3. Inspect the source data under [`data/raw`](https://github.com/DataTideHH/excel-to-sql-data-workflows/tree/main/data/raw) and expected outputs under [`data/expected`](https://github.com/DataTideHH/excel-to-sql-data-workflows/tree/main/data/expected).
4. Compare the [Excel workbook](https://github.com/DataTideHH/excel-to-sql-data-workflows/raw/main/excel/excel_sql_workflows.xlsx) with the [T-SQL equivalents](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/sql/03_excel_sql_equivalents.sql).
5. Review the [DAX measures](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/power-bi/dax-measures.md) and [Power Query M](https://github.com/DataTideHH/excel-to-sql-data-workflows/blob/main/power-bi/power-query-m.md).
6. Inspect the automated tests and successful Windows/Ubuntu CI matrix.

---

## Local verification

Windows PowerShell 7:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe scripts/generate_sample_data.py
.\.venv\Scripts\python.exe scripts/generate_expected_results.py
.\.venv\Scripts\python.exe scripts/generate_excel_workbook.py
.\.venv\Scripts\python.exe -m ruff check .
.\.venv\Scripts\python.exe -m pytest
git diff --exit-code data/raw data/expected excel/excel_sql_workflows.xlsx
```

The final command verifies that regenerated artifacts match the committed CSV files and workbook exactly.

---

## Scope limits

- The data is synthetic and contains no real customer information.
- The repository does not contain a `.pbix` file.
- It is not a formula converter or production BI platform.
- The T-SQL scripts are documented and reviewed, but have not yet been runtime-tested against a live SQL Server instance in this repository.
- The SQL load script assumes local file access permissions for `BULK INSERT`.

These boundaries keep the project compact, reviewable and technically honest.

---

## Portfolio context

This is a focused Data/BI portfolio project. Its value lies in translating business logic across tools, documenting semantic differences, designing controlled data-quality edge cases and proving reproducible outputs through automated tests and cross-platform CI.

The project complements the broader [DataTideHH portfolio](https://datatidehh.de/) without presenting a learning repository as an enterprise analytics product.
