# Power Query M Examples

## Load CSV tables
```m
let
    Source = Csv.Document(
        File.Contents("C:\\path\\to\\excel-to-sql-data-workflows\\data\\raw\\orders.csv"),
        [Delimiter=",", Columns=11, Encoding=65001, QuoteStyle=QuoteStyle.Csv]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"order_id", type text},
            {"source_order_ref", type text},
            {"order_date", type date},
            {"customer_id", type text},
            {"product_id", type text},
            {"quantity", Int64.Type},
            {"unit_price", type number},
            {"discount_pct", type number},
            {"sales_rep", type text},
            {"order_status", type text},
            {"crm_lookup_code_used", type text}
        }
    )
in
    Typed
```

## Replace null discounts and add revenue
```m
let
    ReplacedNulls = Table.ReplaceValue(Typed, null, 0, Replacer.ReplaceValue, {"discount_pct"}),
    AddedRevenue = Table.AddColumn(
        ReplacedNulls,
        "revenue",
        each [quantity] * [unit_price] * (1 - [discount_pct] / 100),
        type number
    )
in
    AddedRevenue
```

## Conditional column (order classification)
```m
let
    WithBucket = Table.AddColumn(
        Orders,
        "revenue_bucket",
        each if [order_status] = "Completed" then "Book Revenue"
             else if [order_status] = "Pending" then "Pipeline"
             else "Exclude",
        type text
    )
in
    WithBucket
```

## Merge with Customers (LEFT JOIN intent)
```m
let
    Merged = Table.NestedJoin(
        Orders,
        {"customer_id"},
        Customers,
        {"customer_id"},
        "Customers",
        JoinKind.LeftOuter
    ),
    Expanded = Table.ExpandTableColumn(Merged, "Customers", {"region", "segment"}, {"region", "segment"})
in
    Expanded
```

## Group by region for revenue
```m
let
    Grouped = Table.Group(
        OrdersWithRevenue,
        {"region"},
        {{"total_revenue", each List.Sum([revenue]), type number}}
    )
in
    Grouped
```

## Duplicate checks
```m
let
    Grouped = Table.Group(
        Orders,
        {"source_order_ref"},
        {{"duplicate_count", each Table.RowCount(_), Int64.Type}}
    ),
    DuplicatesOnly = Table.SelectRows(Grouped, each [duplicate_count] > 1)
in
    DuplicatesOnly
```

## Running total pattern (monthly)
```m
let
    Sorted = Table.Sort(MonthlyRevenue, {{"order_month", Order.Ascending}}),
    Indexed = Table.AddIndexColumn(Sorted, "idx", 0, 1, Int64.Type),
    Running = Table.AddColumn(
        Indexed,
        "running_total_revenue",
        each List.Sum(List.FirstN(Indexed[monthly_revenue], [idx] + 1)),
        type number
    ),
    RemovedIndex = Table.RemoveColumns(Running, {"idx"})
in
    RemovedIndex
```
