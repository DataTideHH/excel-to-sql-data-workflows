# Semantic Differences

## Why Similar-Looking Logic Diverges

### Lookup behavior
- `XLOOKUP` typically returns a single value (first/selected match).
- SQL joins return all matching rows, which can multiply records when lookup keys are not unique.
- This repository includes duplicate `crm_lookup_code` values in customers to demonstrate this effect.

### Missing value semantics
- Excel can represent a visually empty cell, an empty string `""`, or an error.
- SQL `NULL` means unknown/missing and follows three-valued logic.
- Power Query `null` is a literal missing marker in M.
- DAX `BLANK()` is a distinct semantic value and can behave differently from `0` or `""`.

### Evaluation model
- Worksheet formulas compute in cell context with implicit references.
- SQL computes over sets based on declarative query logic.
- DAX behavior is governed by row context and filter context.
- Power Query is a stepwise transformation pipeline evaluated during refresh.

### Distinctness and blanks
- Excel `UNIQUE`, SQL `DISTINCT`, and DAX `VALUES` can produce different outputs when blanks or context are involved.

### Ranking ties
- SQL `RANK` introduces gaps after ties.
- SQL `DENSE_RANK` avoids gaps.
- SQL `ROW_NUMBER` always produces unique sequence numbers.
- Excel `RANK.EQ` and DAX `RANKX` need tie-breaking design choices when unique ordering matters.

### Running totals and ordering
- Running totals require stable sort keys.
- Ambiguous ordering can produce inconsistent totals across tools.

### Numeric precision and rounding
- Excel display rounding may hide stored precision.
- SQL decimal expressions may retain precision differently.
- DAX and M numeric types can produce small floating-point differences in some transformations.

### Filter context and visibility
- Excel worksheet filters, SQL `WHERE`, and Power BI report/page/visual filters are not equivalent mechanisms.
- The same measure can differ when filter context differs.

### Text comparison and case sensitivity
- SQL comparison behavior depends on collation.
- Power Query and DAX case behavior depends on function choice and model settings.
- Excel comparisons may appear case-insensitive in common scenarios.
