# Comparison Matrix

This matrix maps analytical intent to four implementation surfaces used in this repository.

| Pattern | Excel | Power Query | SQL Server | DAX |
|---|---|---|---|---|
| Conditional logic | `IF`, `IFS` | Conditional Column | `CASE` | `IF`, `SWITCH` |
| Lookup/join | `XLOOKUP` | Merge Queries | `LEFT JOIN` | Relationships, `RELATED` |
| Conditional aggregation | `SUMIFS` | Filter + Group | `SUM` + predicates | `CALCULATE(SUM())` |
| Conditional count | `COUNTIF`, `COUNTIFS` | Filter + row count | `COUNT(*)` + predicates | `CALCULATE(COUNTROWS())` |
| Distinct values | `UNIQUE` | Remove Duplicates | `DISTINCT` | `DISTINCT`, `VALUES` |
| Sorting/top-N | `SORT`, `SORTBY`, `LARGE` | Sort + Keep Top Rows | `ORDER BY`, `TOP` | `TOPN`, rank measures |
| Running totals | Expanding `SUM` | Index + cumulative logic | `SUM(...) OVER(...)` | Cumulative measure |
| Ranking | `RANK.EQ` | Grouped index | `RANK`, `DENSE_RANK`, `ROW_NUMBER` | `RANKX` |
| Missing values | blanks, `IFERROR` | null replacement | `NULL`, `COALESCE` | `BLANK()`, `COALESCE` |
| Duplicate detection | `COUNTIF` > 1 | Group + count > 1 | `GROUP BY ... HAVING` | duplicate count measure |

## Important Note
These mappings represent equivalent business intent, not guaranteed identical behavior for all edge cases.
