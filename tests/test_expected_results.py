from __future__ import annotations

import csv
from decimal import Decimal
from pathlib import Path

from scripts.generate_expected_results import (
    build_duplicate_checks,
    build_monthly_running_total,
    build_sales_by_region,
)

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_DIR = ROOT / "data" / "expected"


def _read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def test_sales_by_region_matches_builder() -> None:
    expected = _read_csv(EXPECTED_DIR / "sales_by_region.csv")
    rebuilt = build_sales_by_region()
    assert expected == rebuilt


def test_monthly_running_total_matches_builder() -> None:
    expected = _read_csv(EXPECTED_DIR / "monthly_running_total.csv")
    rebuilt = build_monthly_running_total()
    assert expected == rebuilt


def test_duplicate_checks_match_builder() -> None:
    expected = _read_csv(EXPECTED_DIR / "duplicate_checks.csv")
    rebuilt = build_duplicate_checks()
    assert expected == rebuilt


def test_running_total_is_monotonic() -> None:
    rows = _read_csv(EXPECTED_DIR / "monthly_running_total.csv")
    totals = [Decimal(row["running_total_revenue"]) for row in rows]
    assert totals == sorted(totals)


def test_monthly_running_total_consistency() -> None:
    rows = _read_csv(EXPECTED_DIR / "monthly_running_total.csv")
    cumulative = Decimal("0")
    for row in rows:
        cumulative += Decimal(row["monthly_revenue"])
        assert Decimal(row["running_total_revenue"]) == cumulative


def test_duplicate_counts_expected_values() -> None:
    rows = _read_csv(EXPECTED_DIR / "duplicate_checks.csv")
    by_entity = {row["entity"]: int(row["duplicate_count"]) for row in rows}

    assert by_entity["customers.crm_lookup_code"] == 2
    assert by_entity["products.legacy_sku"] == 2
    assert by_entity["orders.source_order_ref"] == 3
