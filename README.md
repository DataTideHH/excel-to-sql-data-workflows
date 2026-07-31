# excel-to-sql-data-workflows

A compact portfolio project showing how the same analytical questions can be expressed across Excel formulas, Power Query M, SQL Server T-SQL, and Power BI DAX.

It is about equivalent analytical intent, not literal one-to-one translation. The point of the repository is to show where the tools align, where they diverge, and how those differences affect business logic.

## What This Shows Early
- Cross-tool comparison on one bounded sales-order scenario instead of disconnected examples.
- Deterministic artifact generation for six CSV outputs and one Excel workbook.
- GitHub Actions matrix passing on Windows and Ubuntu with Python 3.12, Ruff, 19 pytest tests, and committed-artifact drift verification.

## Start Here
If you are reviewing this repository quickly:
- Recruiter or hiring manager: read [Purpose](#purpose), [What This Shows Early](#what-this-shows-early), and [Suggested Reviewer Path](#suggested-reviewer-path).
- Technical reviewer: start with `docs/comparison-matrix.md`, `docs/semantic-differences.md`, `sql/03_excel_sql_equivalents.sql`, `sql/04_window_functions.sql`, and `tests/test_sample_data.py`.

## Purpose
This repository helps reviewers compare how the same business analysis tasks are implemented in different tools. It is intentionally bounded to a small synthetic sales-order scenario and does not position itself as a production data platform.

## Technologies
- Python 3.12
- CSV datasets
- Excel Tables + formulas
- Power Query M
- Microsoft SQL Server (T-SQL)
- Power BI Desktop + DAX
- pytest + ruff
- GitHub Actions

## Strongest Technical Evidence
- The generated data and workbook are reproducible, including cross-platform artifact checks in CI.
- Tests cover deterministic generation, schema constraints, key relationships, grouped analytical outputs, duplicate detection, exact LF CSV output, and byte-stable workbook packaging.
- The workbook is generated without Excel automation or macros and is normalized after save for byte-stable ZIP packaging.

## Business Scenario
A deterministic fictional sales-order dataset includes:
- 52 orders
- 12 customers
- 7 products
- 5 regions
- order dates across multiple months
- quantity, unit price, discount percentage, sales rep, order status
- missing values in selected fields
- deliberate duplicate lookup values for semantic edge-case demonstrations

## Comparison Matrix
These are equivalences in analytical intent, not guaranteed identical operations.

| Analytical intent | Excel | SQL | Power Query | DAX |
|---|---|---|---|---|
| Conditional category | `IF` / `IFS` | `CASE` | Conditional Column | `IF` / `SWITCH` |
| Lookup | `XLOOKUP` | `LEFT JOIN` | Merge Queries | Relationship / `RELATED` |
| Conditional sum | `SUMIFS` | `SUM` + `WHERE` / `GROUP BY` | Filter + Group By | `CALCULATE(SUM(...))` |
| Conditional count | `COUNTIF` / `COUNTIFS` | `COUNT(*)` with predicates | Filter + Row Count | `CALCULATE(COUNTROWS(...))` |
| Unique values | `UNIQUE` | `DISTINCT` | Remove Duplicates | `DISTINCT` / `VALUES` |
| Sort and top-N | `SORT` / `SORTBY` / `LARGE` | `ORDER BY` + `TOP` | Sort + Keep Top Rows | `TOPN` / rank measure |
| Running total | Expanding `SUM` | `SUM(...) OVER(...)` | Indexed cumulative logic | Cumulative measure |
| Ranking | `RANK.EQ` | `RANK` / `DENSE_RANK` / `ROW_NUMBER` | Grouped index | `RANKX` |
| Missing values | Blanks + `IFERROR` | `NULL`, `IS NULL`, `COALESCE` | `null` handling | `BLANK()`, `COALESCE` |
| Duplicate detection | `COUNTIF` | `GROUP BY ... HAVING COUNT(*) > 1` | Group By + count | Duplicate count measure |

## Key Semantic Lessons
- `XLOOKUP` usually returns one result; SQL joins can multiply rows if keys are not unique.
- Excel blanks, empty text, SQL `NULL`, Power Query `null`, and DAX `BLANK()` are related but not identical.
- Excel formulas are primarily cell-context based.
- SQL is set-based declarative query logic.
- DAX semantics depend on row context and filter context.
- Power Query is a refresh-time transformation pipeline.
- `UNIQUE`, `DISTINCT`, and `VALUES` can differ around blanks and evaluation context.
- Running totals require deterministic ordering.
- Ranking functions treat ties differently.
- Numeric precision, decimal handling, and rounding can diverge by engine.
- Filtering behavior differs between worksheet filters, SQL predicates, and Power BI filter context.
- Case sensitivity and text comparison depend on engine configuration and collation settings.

## Equivalent Intent vs Literal Translation
- This repository compares the same business task across tools, not syntax conversion in isolation.
- Some mappings are close equivalents, such as `SUMIFS` and grouped SQL aggregations with predicates.
- Some mappings intentionally expose semantic differences, especially lookups with non-unique keys, blank or null handling, ranking ties, and running totals that depend on stable ordering.
- Reviewers should expect similar analytical goals with different execution models, not interchangeable code.

## Repository Structure
```text
excel-to-sql-data-workflows/
├── .gitattributes
├── .github/workflows/python-quality.yml
├── data/
│   ├── raw/
│   │   ├── customers.csv
│   │   ├── products.csv
│   │   └── orders.csv
│   └── expected/
│       ├── sales_by_region.csv
│       ├── monthly_running_total.csv
│       └── duplicate_checks.csv
├── docs/
├── excel/
├── power-bi/
├── scripts/
├── sql/
├── tests/
├── .gitignore
├── LICENSE
├── pyproject.toml
├── requirements.txt
└── README.md
```

## Reproducible Setup (Windows PowerShell 7)
```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe scripts/generate_sample_data.py
.\.venv\Scripts\python.exe scripts/generate_expected_results.py
.\.venv\Scripts\python.exe scripts/generate_excel_workbook.py
```

## Excel Workbook Generation
Generate `excel/excel_sql_workflows.xlsx` from committed CSV files:

```powershell
.\.venv\Scripts\python.exe scripts/generate_excel_workbook.py
```

## SQL Server Execution Instructions
1. Run `sql/01_create_schema.sql`.
2. Open `sql/02_load_sample_data.sql` and set `@data_root` to your local `data/raw` folder.
3. Run `sql/02_load_sample_data.sql`.
4. Execute `sql/03` through `sql/06` scripts for comparisons and reports.

## Power BI Connection Instructions
1. Open Power BI Desktop.
2. Load `data/raw/*.csv` using Get Data, or connect to SQL Server tables in schema `workflow_demo`.
3. Apply transformations described in `power-bi/power-query-m.md`.
4. Create measures from `power-bi/dax-measures.md`.
5. Use `docs/data-model.md` for relationship setup and report layout.

## Testing and Quality
```powershell
.\.venv\Scripts\python.exe -m ruff check .
.\.venv\Scripts\python.exe -m pytest
git diff --exit-code data/raw data/expected excel/excel_sql_workflows.xlsx
```

Tests verify deterministic generation, schema constraints, key relationships, revenue calculations, grouped outputs, duplicate checks, running totals, exact LF CSV line endings, workbook byte stability, canonical ZIP metadata, and workbook loadability after normalization.

## Suggested Reviewer Path
1. Read `docs/comparison-matrix.md` for the cross-tool map.
2. Read `docs/semantic-differences.md` to see where similar-looking logic diverges.
3. Inspect the synthetic source data in `data/raw` and expected outputs in `data/expected`.
4. Review `sql/03_excel_sql_equivalents.sql` and `sql/04_window_functions.sql` for the clearest T-SQL comparisons.
5. Open `excel/excel_sql_workflows.xlsx` and compare its formulas and tables with the SQL patterns.
6. Review `power-bi/dax-measures.md` and `power-bi/power-query-m.md` for the Power BI side of the same scenario.
7. Run the quality commands if you want to verify deterministic regeneration locally.

## Limitations and Scope
- Synthetic data only; no real customer information.
- No `.pbix` committed.
- Not a formula translator and not a production BI platform.
- T-SQL scripts are documented and reviewed, but not yet runtime-tested against a live SQL Server instance in this repository.
- SQL load script assumes local file access permissions for `BULK INSERT`.
