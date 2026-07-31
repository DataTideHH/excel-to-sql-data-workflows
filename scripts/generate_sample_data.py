"""Generate deterministic synthetic source data for the repository."""

from __future__ import annotations

import csv
import sys
from pathlib import Path

if __package__ is None or __package__ == "":
    sys.path.append(str(Path(__file__).resolve().parents[1]))

from scripts.data_logic import CUSTOMERS, PRODUCTS, build_orders

ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw"


def _write_csv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        raise ValueError(f"Cannot write empty dataset to {path}")

    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def generate_raw_data() -> None:
    orders = build_orders(total_orders=52)
    _write_csv(RAW_DIR / "customers.csv", CUSTOMERS)
    _write_csv(RAW_DIR / "products.csv", PRODUCTS)
    _write_csv(RAW_DIR / "orders.csv", orders)


if __name__ == "__main__":
    generate_raw_data()
    print("Generated raw CSV data in data/raw")
