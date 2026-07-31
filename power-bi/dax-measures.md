# DAX Measures

Assume model tables: `Orders`, `Customers`, `Products`, and `Date`.

## Core Measures

### Total Revenue
```DAX
Total Revenue =
SUMX (
    Orders,
    Orders[quantity] * Orders[unit_price] * ( 1 - COALESCE ( Orders[discount_pct], 0 ) / 100 )
)
```

### Order Count
```DAX
Order Count = COUNTROWS ( Orders )
```

### Average Order Value
```DAX
Average Order Value = DIVIDE ( [Total Revenue], [Order Count] )
```

### Distinct Customers
```DAX
Distinct Customers = DISTINCTCOUNT ( Orders[customer_id] )
```

### Running Total Revenue
```DAX
Running Total Revenue =
VAR CurrentDate = MAX ( 'Date'[Date] )
RETURN
CALCULATE (
    [Total Revenue],
    FILTER ( ALLSELECTED ( 'Date'[Date] ), 'Date'[Date] <= CurrentDate )
)
```

### Revenue Rank
```DAX
Revenue Rank =
RANKX (
    ALLSELECTED ( Customers[region] ),
    [Total Revenue],
    ,
    DESC,
    Dense
)
```

### Completed Revenue
```DAX
Completed Revenue =
CALCULATE ( [Total Revenue], Orders[order_status] = "Completed" )
```

### Discounted Revenue
```DAX
Discounted Revenue =
SUMX (
    Orders,
    Orders[quantity] * Orders[unit_price] * COALESCE ( Orders[discount_pct], 0 ) / 100
)
```

## Optional Calculated Column
```DAX
Revenue =
Orders[quantity] * Orders[unit_price] * ( 1 - COALESCE ( Orders[discount_pct], 0 ) / 100 )
```

## Optional Calculated Column (SWITCH pattern)
```DAX
Revenue Bucket =
SWITCH (
    TRUE(),
    Orders[order_status] = "Completed", "Book Revenue",
    Orders[order_status] = "Pending", "Pipeline",
    "Exclude"
)
```

## Notes
- Running totals require a proper Date dimension and deterministic date ordering.
- `ALLSELECTED` can differ from `ALL` depending on report interactions.
- Tie handling in ranking depends on `Dense` vs `Skip` choices.
