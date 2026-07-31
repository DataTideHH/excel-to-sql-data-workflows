# Data Model

## Source Files
- `data/raw/customers.csv`
- `data/raw/products.csv`
- `data/raw/orders.csv`

## Logical Entities

### Customers (`dim_customers`)
- `customer_id` (PK)
- `customer_name`
- `region`
- `segment`
- `crm_lookup_code` (not unique by design)

### Products (`dim_products`)
- `product_id` (PK)
- `product_name`
- `category`
- `list_price`
- `legacy_sku` (not unique by design)

### Orders (`fact_orders`)
- `order_id` (PK)
- `source_order_ref` (contains duplicates by design)
- `order_date`
- `customer_id` (FK to customers)
- `product_id` (FK to products)
- `quantity`
- `unit_price`
- `discount_pct` (nullable)
- `sales_rep` (nullable)
- `order_status`
- `crm_lookup_code_used`

## Power BI Relationship Proposal
- `Customers[customer_id]` 1:* `Orders[customer_id]`
- `Products[product_id]` 1:* `Orders[product_id]`

Use single-direction filters from dimensions to fact for baseline clarity.

## Recommended Date Handling
Create a Date table with continuous daily dates and relate:
- `Date[Date]` 1:* `Orders[order_date]`

Use this for running totals and time intelligence consistency.

## Reconciliation Guidance
Use the same revenue formula in every tool:
- `Revenue = quantity * unit_price * (1 - discount_pct/100)` with missing discount treated as `0`.
