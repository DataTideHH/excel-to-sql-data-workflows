# Power BI Workflow

## Objective
Produce the same core KPIs as Excel and SQL while highlighting DAX filter-context behavior.

## Build Steps
1. Import CSVs from `data/raw` or connect to SQL schema `workflow_demo`.
2. Configure relationships from `Customers` and `Products` to `Orders`.
3. Add DAX measures from `power-bi/dax-measures.md`.
4. Validate totals against `data/expected` CSV files.
5. Build one report page with KPI cards, trend line, and regional breakdown.

## Suggested Report Layout
- KPI cards: Total Revenue, Order Count, Average Order Value, Distinct Customers
- Clustered column chart: Revenue by Region
- Line chart: Monthly Revenue and Running Total Revenue
- Table: Top 10 orders by revenue with rank
- Slicers: Region, Segment, Order Status, Sales Rep

## Reconciliation Checklist
- Confirm missing discount handling (treat blank as 0)
- Confirm order status filter scope for completed revenue
- Confirm deterministic date sorting for running totals
- Confirm duplicate-key joins are not used in baseline KPI measures
