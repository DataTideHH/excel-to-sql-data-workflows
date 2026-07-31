# Excel Formula Reference

## Conditional logic
```excel
=IF([@[order_status]]="Completed","Book Revenue","Review")
```

## Lookup
```excel
=XLOOKUP([@[customer_id]],Customers[customer_id],Customers[region],"Missing")
```

## Conditional aggregation
```excel
=SUMIFS(Orders[quantity],Orders[order_status],"Completed")
```

## Conditional counting
```excel
=COUNTIFS(Orders[order_status],"Completed",Orders[sales_rep],"Alex Kim")
```

## Distinct values
```excel
=UNIQUE(Orders[customer_id])
```

## Sorting and Top-N
```excel
=SORTBY(Orders[[order_id]:[unit_price]],Orders[unit_price],-1)
```

## Running total
```excel
=SUM($K$2:K2)
```

## Ranking
```excel
=RANK.EQ([@[revenue]],Orders[revenue],0)
```

## Missing values
```excel
=IFERROR([@[unit_price]]*[@[quantity]],0)
```

## Duplicate detection
```excel
=COUNTIF(Orders[source_order_ref],[@[source_order_ref]])
```

## Interpretation Notes
- These formulas are pedagogical examples; table/column names may need adjustment based on workbook edits.
- Where lookup keys are not unique, document whether first-match behavior is acceptable.
