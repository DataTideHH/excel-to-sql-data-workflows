/*
Excel/Power Query/DAX equivalent intent examples in SQL Server.
*/

/* 1) Conditional logic: Excel IF/IFS, Power Query conditional column, DAX IF/SWITCH */
SELECT
    o.order_id,
    o.order_status,
    CASE
        WHEN o.order_status = 'Completed' THEN 'Book Revenue'
        WHEN o.order_status = 'Pending' THEN 'Pipeline'
        ELSE 'Exclude from Revenue'
    END AS revenue_bucket
FROM workflow_demo.fact_orders AS o;

/* 2) Lookup / join: Excel XLOOKUP, PQ Merge, DAX RELATED */
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.region
FROM workflow_demo.fact_orders AS o
LEFT JOIN workflow_demo.dim_customers AS c
    ON c.customer_id = o.customer_id;

/*
XLOOKUP versus SQL join behavior with non-unique key:
Joining on crm_lookup_code can multiply rows because dim_customers has duplicates.
*/
SELECT
    o.order_id,
    o.crm_lookup_code_used,
    c.customer_id,
    c.customer_name
FROM workflow_demo.fact_orders AS o
LEFT JOIN workflow_demo.dim_customers AS c
    ON c.crm_lookup_code = o.crm_lookup_code_used
WHERE o.crm_lookup_code_used = 'CRM-NORTH-1'
ORDER BY o.order_id;

/* 3) Conditional aggregation: Excel SUMIFS, DAX CALCULATE(SUM(...)) */
SELECT
    c.region,
    SUM(CASE WHEN o.order_status = 'Completed'
             THEN o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)
             ELSE 0 END) AS completed_revenue
FROM workflow_demo.fact_orders AS o
INNER JOIN workflow_demo.dim_customers AS c
    ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY c.region;

/* 4) Conditional counting: COUNTIF/COUNTIFS, DAX COUNTROWS with CALCULATE */
SELECT
    c.region,
    COUNT(*) AS completed_orders
FROM workflow_demo.fact_orders AS o
INNER JOIN workflow_demo.dim_customers AS c
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.region
ORDER BY c.region;

/* 5) Distinct values: UNIQUE / DISTINCT / VALUES */
SELECT DISTINCT c.region
FROM workflow_demo.dim_customers AS c
ORDER BY c.region;

/* 6) Sorting and Top-N: SORT/SORTBY/LARGE, PQ sort + keep top rows, DAX TOPN */
SELECT TOP (5)
    o.order_id,
    o.order_date,
    o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0) AS revenue
FROM workflow_demo.fact_orders AS o
ORDER BY revenue DESC, o.order_id;
