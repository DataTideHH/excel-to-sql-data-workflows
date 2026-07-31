"""Shared deterministic data generation logic for the project."""

from __future__ import annotations

from datetime import date, timedelta
from decimal import ROUND_HALF_UP, Decimal


def _money(value: Decimal) -> Decimal:
    return value.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)


CUSTOMERS: list[dict[str, str]] = [
    {
        "customer_id": "C001",
        "customer_name": "Northwind Outfitters",
        "region": "North",
        "segment": "Retail",
        "crm_lookup_code": "CRM-NORTH-1",
    },
    {
        "customer_id": "C002",
        "customer_name": "Harbor Supply Co",
        "region": "West",
        "segment": "Wholesale",
        "crm_lookup_code": "CRM-WEST-1",
    },
    {
        "customer_id": "C003",
        "customer_name": "Blue Ridge Stores",
        "region": "East",
        "segment": "Retail",
        "crm_lookup_code": "CRM-EAST-1",
    },
    {
        "customer_id": "C004",
        "customer_name": "Prairie Goods",
        "region": "Central",
        "segment": "Enterprise",
        "crm_lookup_code": "CRM-CENTRAL-1",
    },
    {
        "customer_id": "C005",
        "customer_name": "Summit Retail Group",
        "region": "North",
        "segment": "Enterprise",
        "crm_lookup_code": "CRM-NORTH-2",
    },
    {
        "customer_id": "C006",
        "customer_name": "Citywide Shop",
        "region": "South",
        "segment": "Retail",
        "crm_lookup_code": "CRM-SOUTH-1",
    },
    {
        "customer_id": "C007",
        "customer_name": "Delta Industrial",
        "region": "South",
        "segment": "Wholesale",
        "crm_lookup_code": "CRM-SOUTH-2",
    },
    {
        "customer_id": "C008",
        "customer_name": "Maple Home",
        "region": "East",
        "segment": "Retail",
        "crm_lookup_code": "CRM-EAST-2",
    },
    {
        "customer_id": "C009",
        "customer_name": "Evergreen Markets",
        "region": "West",
        "segment": "Retail",
        "crm_lookup_code": "CRM-WEST-2",
    },
    {
        "customer_id": "C010",
        "customer_name": "Pioneer Commerce",
        "region": "Central",
        "segment": "Wholesale",
        "crm_lookup_code": "CRM-CENTRAL-2",
    },
    {
        "customer_id": "C011",
        "customer_name": "Lakeside Outfit",
        "region": "North",
        "segment": "Retail",
        "crm_lookup_code": "CRM-NORTH-1",
    },
    {
        "customer_id": "C012",
        "customer_name": "Harbor Supply Co",
        "region": "South",
        "segment": "Enterprise",
        "crm_lookup_code": "CRM-SOUTH-3",
    },
]


PRODUCTS: list[dict[str, str]] = [
    {
        "product_id": "P001",
        "product_name": "Wireless Mouse",
        "category": "Accessories",
        "list_price": "24.00",
        "legacy_sku": "LEG-AC-01",
    },
    {
        "product_id": "P002",
        "product_name": "Mechanical Keyboard",
        "category": "Accessories",
        "list_price": "79.00",
        "legacy_sku": "LEG-AC-02",
    },
    {
        "product_id": "P003",
        "product_name": "USB-C Dock",
        "category": "Peripherals",
        "list_price": "129.00",
        "legacy_sku": "LEG-PR-01",
    },
    {
        "product_id": "P004",
        "product_name": "27in Monitor",
        "category": "Displays",
        "list_price": "269.00",
        "legacy_sku": "LEG-DP-01",
    },
    {
        "product_id": "P005",
        "product_name": "Noise Cancelling Headset",
        "category": "Audio",
        "list_price": "149.00",
        "legacy_sku": "LEG-AU-01",
    },
    {
        "product_id": "P006",
        "product_name": "Portable SSD 1TB",
        "category": "Storage",
        "list_price": "139.00",
        "legacy_sku": "LEG-PR-01",
    },
    {
        "product_id": "P007",
        "product_name": "Webcam 4K",
        "category": "Peripherals",
        "list_price": "99.00",
        "legacy_sku": "LEG-PR-03",
    },
]


def build_orders(total_orders: int = 52) -> list[dict[str, str]]:
    """Create a deterministic set of orders across multiple months."""
    reps = ["Alex Kim", "Jordan Lee", "Morgan Patel", "Riley Chen", "Casey Brooks"]
    statuses = ["Completed", "Completed", "Completed", "Pending", "Cancelled"]
    discount_cycle = ["0", "5", "10", "15"]

    customer_by_id = {row["customer_id"]: row for row in CUSTOMERS}
    product_by_id = {row["product_id"]: row for row in PRODUCTS}

    start_date = date(2026, 1, 3)
    customer_ids = [row["customer_id"] for row in CUSTOMERS]
    product_ids = [row["product_id"] for row in PRODUCTS]

    orders: list[dict[str, str]] = []
    for index in range(1, total_orders + 1):
        order_id = f"O{index:03d}"
        source_ref = f"WEB-{1000 + index}"
        if index in {18, 36}:  # intentional duplicates for quality checks
            source_ref = "WEB-1017"

        customer_id = customer_ids[index % len(customer_ids)]
        product_id = product_ids[(index * 2) % len(product_ids)]

        list_price = Decimal(product_by_id[product_id]["list_price"])
        factor = Decimal("0.92") + Decimal(index % 4) * Decimal("0.03")
        unit_price = _money(list_price * factor)

        discount_pct = "" if index % 11 == 0 else discount_cycle[index % len(discount_cycle)]
        sales_rep = "" if index % 13 == 0 else reps[index % len(reps)]
        status = statuses[index % len(statuses)]

        crm_lookup_code = customer_by_id[customer_id]["crm_lookup_code"]
        if index % 14 == 0:
            crm_lookup_code = "CRM-NORTH-1"

        order_date = start_date + timedelta(days=index * 4)

        orders.append(
            {
                "order_id": order_id,
                "source_order_ref": source_ref,
                "order_date": order_date.isoformat(),
                "customer_id": customer_id,
                "product_id": product_id,
                "quantity": str((index % 5) + 1),
                "unit_price": f"{unit_price:.2f}",
                "discount_pct": discount_pct,
                "sales_rep": sales_rep,
                "order_status": status,
                "crm_lookup_code_used": crm_lookup_code,
            }
        )
    return orders


def revenue_from_order(row: dict[str, str]) -> Decimal:
    """Return rounded order revenue after discount."""
    quantity = Decimal(row["quantity"])
    unit_price = Decimal(row["unit_price"])
    discount_pct = Decimal(row["discount_pct"] or "0")
    gross = quantity * unit_price
    net = gross * (Decimal("1") - discount_pct / Decimal("100"))
    return _money(net)
