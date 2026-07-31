# excel-to-sql-data-workflows

A compact reference project that demonstrates equivalent analytical intent across Excel formulas, Power Query M, SQL Server T-SQL, and Power BI DAX.

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

## Repository Structure
```text
excel-to-sql-data-workflows/
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
pip install -r requirements.txt
python scripts/generate_sample_data.py
python scripts/generate_expected_results.py
python scripts/generate_excel_workbook.py
```

## Excel Workbook Generation
Generate `excel/excel_sql_workflows.xlsx` from committed CSV files:

```powershell
python scripts/generate_excel_workbook.py
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
ruff check .
pytest
```

Tests verify deterministic generation, schema constraints, key relationships, revenue calculations, grouped outputs, duplicate checks, and running totals.

## Suggested Reviewer Path
1. Read `docs/comparison-matrix.md` and `docs/semantic-differences.md`.
2. Inspect source data under `data/raw`.
3. Review SQL patterns in `sql/03_excel_sql_equivalents.sql` and `sql/04_window_functions.sql`.
4. Open `excel/excel_sql_workflows.xlsx` and compare workbook formulas with SQL.
5. Review `power-bi/dax-measures.md` and `power-bi/power-query-m.md`.
6. Run tests.

## Limitations and Scope
- Synthetic data only; no real customer information.
- No `.pbix` committed.
- Not a formula translator and not a production BI platform.
- SQL load script assumes local file access permissions for `BULK INSERT`.
