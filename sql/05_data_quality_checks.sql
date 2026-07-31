/*
Data quality checks: missing values and duplicate detection.
*/

/* 9) Missing-value handling: NULL/IS NULL/COALESCE */
SELECT
    o.order_id,
    o.discount_pct,
    COALESCE(o.discount_pct, 0) AS discount_pct_normalized,
    o.sales_rep,
    CASE WHEN o.sales_rep IS NULL OR LTRIM(RTRIM(o.sales_rep)) = ''
         THEN 'Unassigned'
         ELSE o.sales_rep
    END AS sales_rep_bucket
FROM workflow_demo.fact_orders AS o
WHERE o.discount_pct IS NULL
   OR o.sales_rep IS NULL
   OR LTRIM(RTRIM(o.sales_rep)) = ''
ORDER BY o.order_id;

/* 10) Duplicate detection: GROUP BY/HAVING COUNT(*) > 1 */
SELECT
    'orders.source_order_ref' AS duplicate_entity,
    o.source_order_ref AS duplicate_value,
    COUNT(*) AS duplicate_count
FROM workflow_demo.fact_orders AS o
GROUP BY o.source_order_ref
HAVING COUNT(*) > 1;

SELECT
    'customers.crm_lookup_code' AS duplicate_entity,
    c.crm_lookup_code AS duplicate_value,
    COUNT(*) AS duplicate_count
FROM workflow_demo.dim_customers AS c
GROUP BY c.crm_lookup_code
HAVING COUNT(*) > 1;

SELECT
    'products.legacy_sku' AS duplicate_entity,
    p.legacy_sku AS duplicate_value,
    COUNT(*) AS duplicate_count
FROM workflow_demo.dim_products AS p
GROUP BY p.legacy_sku
HAVING COUNT(*) > 1;
