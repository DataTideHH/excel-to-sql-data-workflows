/*
Reusable reporting queries that align with Excel and Power BI outputs.
*/

/* Revenue, order count, and distinct customers */
SELECT
    SUM(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS total_revenue,
    COUNT(*) AS order_count,
    COUNT(DISTINCT o.customer_id) AS distinct_customers,
    AVG(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS average_order_value
FROM workflow_demo.fact_orders AS o;

/* Completed revenue and discounted revenue */
SELECT
    SUM(CASE WHEN o.order_status = 'Completed'
             THEN o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)
             ELSE 0 END) AS completed_revenue,
    SUM(o.quantity * o.unit_price * (COALESCE(o.discount_pct, 0) / 100.0)) AS discounted_revenue
FROM workflow_demo.fact_orders AS o;

/* Sales by region */
SELECT
    c.region,
    CAST(SUM(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS DECIMAL(14, 2)) AS total_revenue
FROM workflow_demo.fact_orders AS o
INNER JOIN workflow_demo.dim_customers AS c
    ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY c.region;

/* Monthly revenue and running total */
WITH monthly AS (
    SELECT
        FORMAT(o.order_date, 'yyyy-MM') AS order_month,
        CAST(SUM(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS DECIMAL(14, 2)) AS monthly_revenue
    FROM workflow_demo.fact_orders AS o
    GROUP BY FORMAT(o.order_date, 'yyyy-MM')
)
SELECT
    m.order_month,
    m.monthly_revenue,
    SUM(m.monthly_revenue) OVER (ORDER BY m.order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM monthly AS m
ORDER BY m.order_month;
