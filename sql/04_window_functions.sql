/*
Window functions: running totals and ranking.
*/

/* 7) Running totals (deterministic order by month then order_id) */
WITH monthly AS (
    SELECT
        DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1) AS order_month,
        SUM(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0)) AS monthly_revenue
    FROM workflow_demo.fact_orders AS o
    GROUP BY DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1)
)
SELECT
    m.order_month,
    m.monthly_revenue,
    SUM(m.monthly_revenue) OVER (ORDER BY m.order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM monthly AS m
ORDER BY m.order_month;

/* 8) Ranking variants with ties */
WITH order_revenue AS (
    SELECT
        o.order_id,
        c.region,
        CAST(o.quantity * o.unit_price * (1 - COALESCE(o.discount_pct, 0) / 100.0) AS DECIMAL(12, 2)) AS revenue
    FROM workflow_demo.fact_orders AS o
    INNER JOIN workflow_demo.dim_customers AS c
        ON c.customer_id = o.customer_id
)
SELECT
    region,
    order_id,
    revenue,
    RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS dense_rank_no_gaps,
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC, order_id) AS row_number_unique
FROM order_revenue
ORDER BY region, revenue DESC, order_id;
