"""Generate expected analytical outputs used by tests and documentation."""

from __future__ import annotations

import csv
import sys
from collections import Counter
from decimal import Decimal
from pathlib import Path

if __package__ is None or __package__ == "":
    sys.path.append(str(Path(__file__).resolve().parents[1]))

from scripts.data_logic import revenue_from_order

ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw"
EXPECTED_DIR = ROOT / "data" / "expected"


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        raise ValueError(f"Cannot write empty dataset to {path}")

    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def build_sales_by_region() -> list[dict[str, str]]:
    customers = _read_csv(RAW_DIR / "customers.csv")
    orders = _read_csv(RAW_DIR / "orders.csv")
    region_by_customer = {row["customer_id"]: row["region"] for row in customers}

    totals: dict[str, Decimal] = {}
    for row in orders:
        region = region_by_customer[row["customer_id"]]
        totals[region] = totals.get(region, Decimal("0")) + revenue_from_order(row)

    output: list[dict[str, str]] = []
    for region in sorted(totals):
        output.append(
            {
                "region": region,
                "total_revenue": f"{totals[region]:.2f}",
            }
        )
    return output


def build_monthly_running_total() -> list[dict[str, str]]:
    orders = _read_csv(RAW_DIR / "orders.csv")

    monthly: dict[str, Decimal] = {}
    for row in orders:
        month = row["order_date"][:7]
        monthly[month] = monthly.get(month, Decimal("0")) + revenue_from_order(row)

    running_total = Decimal("0")
    output: list[dict[str, str]] = []
    for month in sorted(monthly):
        month_revenue = monthly[month]
        running_total += month_revenue
        output.append(
            {
                "order_month": month,
                "monthly_revenue": f"{month_revenue:.2f}",
                "running_total_revenue": f"{running_total:.2f}",
            }
        )
    return output


def build_duplicate_checks() -> list[dict[str, str]]:
    customers = _read_csv(RAW_DIR / "customers.csv")
    products = _read_csv(RAW_DIR / "products.csv")
    orders = _read_csv(RAW_DIR / "orders.csv")

    crm_counts = Counter(row["crm_lookup_code"] for row in customers)
    legacy_sku_counts = Counter(row["legacy_sku"] for row in products)
    source_ref_counts = Counter(row["source_order_ref"] for row in orders)

    checks = [
        (
            "customers.crm_lookup_code",
            "CRM-NORTH-1",
            crm_counts["CRM-NORTH-1"],
        ),
        (
            "products.legacy_sku",
            "LEG-PR-01",
            legacy_sku_counts["LEG-PR-01"],
        ),
        (
            "orders.source_order_ref",
            "WEB-1017",
            source_ref_counts["WEB-1017"],
        ),
    ]

    return [
        {"entity": entity, "duplicate_value": value, "duplicate_count": str(count)}
        for entity, value, count in checks
    ]


def generate_expected_results() -> None:
    _write_csv(EXPECTED_DIR / "sales_by_region.csv", build_sales_by_region())
    _write_csv(EXPECTED_DIR / "monthly_running_total.csv", build_monthly_running_total())
    _write_csv(EXPECTED_DIR / "duplicate_checks.csv", build_duplicate_checks())


if __name__ == "__main__":
    generate_expected_results()
    print("Generated expected outputs in data/expected")
