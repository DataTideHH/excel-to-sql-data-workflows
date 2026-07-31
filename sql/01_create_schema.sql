/*
Create a compact SQL Server model for Excel/Power Query/DAX equivalence demos.
*/

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'workflow_demo')
BEGIN
    EXEC('CREATE SCHEMA workflow_demo');
END;
GO

IF OBJECT_ID('workflow_demo.fact_orders', 'U') IS NOT NULL DROP TABLE workflow_demo.fact_orders;
IF OBJECT_ID('workflow_demo.dim_products', 'U') IS NOT NULL DROP TABLE workflow_demo.dim_products;
IF OBJECT_ID('workflow_demo.dim_customers', 'U') IS NOT NULL DROP TABLE workflow_demo.dim_customers;
GO

CREATE TABLE workflow_demo.dim_customers (
    customer_id        CHAR(4)         NOT NULL PRIMARY KEY,
    customer_name      NVARCHAR(100)   NOT NULL,
    region             NVARCHAR(20)    NOT NULL,
    segment            NVARCHAR(20)    NOT NULL,
    crm_lookup_code    NVARCHAR(30)    NOT NULL
);
GO

CREATE TABLE workflow_demo.dim_products (
    product_id         CHAR(4)         NOT NULL PRIMARY KEY,
    product_name       NVARCHAR(100)   NOT NULL,
    category           NVARCHAR(40)    NOT NULL,
    list_price         DECIMAL(12, 2)  NOT NULL,
    legacy_sku         NVARCHAR(30)    NOT NULL
);
GO

CREATE TABLE workflow_demo.fact_orders (
    order_id              CHAR(4)         NOT NULL PRIMARY KEY,
    source_order_ref      NVARCHAR(20)    NOT NULL,
    order_date            DATE            NOT NULL,
    customer_id           CHAR(4)         NOT NULL,
    product_id            CHAR(4)         NOT NULL,
    quantity              INT             NOT NULL,
    unit_price            DECIMAL(12, 2)  NOT NULL,
    discount_pct          DECIMAL(5, 2)   NULL,
    sales_rep             NVARCHAR(80)    NULL,
    order_status          NVARCHAR(20)    NOT NULL,
    crm_lookup_code_used  NVARCHAR(30)    NOT NULL,
    CONSTRAINT FK_fact_orders_customer FOREIGN KEY (customer_id)
        REFERENCES workflow_demo.dim_customers (customer_id),
    CONSTRAINT FK_fact_orders_product FOREIGN KEY (product_id)
        REFERENCES workflow_demo.dim_products (product_id)
);
GO

CREATE INDEX IX_fact_orders_date ON workflow_demo.fact_orders(order_date);
CREATE INDEX IX_fact_orders_customer ON workflow_demo.fact_orders(customer_id);
CREATE INDEX IX_fact_orders_status ON workflow_demo.fact_orders(order_status);
GO
