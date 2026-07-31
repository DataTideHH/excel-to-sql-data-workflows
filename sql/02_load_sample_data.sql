/*
Load deterministic sample data from committed CSV files.

Usage:
1) Run 01_create_schema.sql first.
2) Set @data_root to this repository's data/raw folder.
3) Ensure SQL Server service account can read those files.
*/

DECLARE @data_root NVARCHAR(4000) = N'C:\path\to\excel-to-sql-data-workflows\data\raw';

TRUNCATE TABLE workflow_demo.fact_orders;
TRUNCATE TABLE workflow_demo.dim_products;
TRUNCATE TABLE workflow_demo.dim_customers;

DECLARE @sql NVARCHAR(MAX);

SET @sql = N'
BULK INSERT workflow_demo.dim_customers
FROM ''' + @data_root + N'\customers.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''0x0a'',
    CODEPAGE = ''65001'',
    TABLOCK
);';
EXEC sp_executesql @sql;

SET @sql = N'
BULK INSERT workflow_demo.dim_products
FROM ''' + @data_root + N'\products.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''0x0a'',
    CODEPAGE = ''65001'',
    TABLOCK
);';
EXEC sp_executesql @sql;

IF OBJECT_ID('tempdb..#fact_orders_stage', 'U') IS NOT NULL
    DROP TABLE #fact_orders_stage;

CREATE TABLE #fact_orders_stage (
    order_id             NVARCHAR(20),
    source_order_ref     NVARCHAR(50),
    order_date           NVARCHAR(50),
    customer_id          NVARCHAR(20),
    product_id           NVARCHAR(20),
    quantity             NVARCHAR(20),
    unit_price           NVARCHAR(40),
    discount_pct         NVARCHAR(40),
    sales_rep            NVARCHAR(80),
    order_status         NVARCHAR(30),
    crm_lookup_code_used NVARCHAR(40)
);

SET @sql = N'
BULK INSERT #fact_orders_stage
FROM ''' + @data_root + N'\orders.csv''
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''0x0a'',
    CODEPAGE = ''65001'',
    TABLOCK
);';
EXEC sp_executesql @sql;

INSERT INTO workflow_demo.fact_orders (
    order_id,
    source_order_ref,
    order_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    sales_rep,
    order_status,
    crm_lookup_code_used
)
SELECT
    CAST(LTRIM(RTRIM(order_id)) AS CHAR(4)) AS order_id,
    LTRIM(RTRIM(source_order_ref)) AS source_order_ref,
    CAST(TRY_CONVERT(DATE, LTRIM(RTRIM(order_date)), 23) AS DATE) AS order_date,
    CAST(LTRIM(RTRIM(customer_id)) AS CHAR(4)) AS customer_id,
    CAST(LTRIM(RTRIM(product_id)) AS CHAR(4)) AS product_id,
    CAST(TRY_CONVERT(INT, LTRIM(RTRIM(quantity))) AS INT) AS quantity,
    CAST(TRY_CONVERT(DECIMAL(12, 2), LTRIM(RTRIM(unit_price))) AS DECIMAL(12, 2)) AS unit_price,
    CAST(TRY_CONVERT(DECIMAL(5, 2), NULLIF(LTRIM(RTRIM(discount_pct)), '')) AS DECIMAL(5, 2)) AS discount_pct,
    NULLIF(LTRIM(RTRIM(sales_rep)), '') AS sales_rep,
    LTRIM(RTRIM(order_status)) AS order_status,
    LTRIM(RTRIM(crm_lookup_code_used)) AS crm_lookup_code_used
FROM #fact_orders_stage;

SELECT
    (SELECT COUNT(*) FROM workflow_demo.dim_customers) AS customers,
    (SELECT COUNT(*) FROM workflow_demo.dim_products) AS products,
    (SELECT COUNT(*) FROM workflow_demo.fact_orders) AS orders;
