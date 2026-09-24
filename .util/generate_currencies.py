#!/usr/bin/env python3
"""Generate Lua `data.CurrencyByCategory` and `data.Currencies` tables from
extracted CurrencyTypes + CurrencyCategory CSV files.

Given a CurrencyTypes CSV (e.g. CurrencyTypes.12.1.5.69952_enUS.csv), this
script looks for the matching CurrencyCategory CSV (same build/locale, e.g.
CurrencyCategory.12.1.5.69952_enUS.csv) in the same folder, and stops if it
is missing. Category names from CurrencyCategory are used only for comments.

Rows whose Description_lang is empty are commented out in CurrencyByCategory
and get `hide=true` in data.Currencies.
"""

import argparse
import csv
import sys
from pathlib import Path

FILENAME_PREFIX = "CurrencyTypes"
CATEGORY_PREFIX = "CurrencyCategory"


def read_csv(path):
    with path.open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def read_category_names(path):
    return {int(row["ID"]): row["Name_lang"] for row in read_csv(path)}


def read_currency_rows(path):
    rows = {}
    for row in read_csv(path):
        rows[int(row["ID"])] = {
            "name": row["Name_lang"],
            "description": row["Description_lang"].strip(),
            "category": int(row["CategoryID"]),
        }
    return rows


def build_by_category(currency_rows, category_names):
    by_category = {}
    for cid, row in currency_rows.items():
        by_category.setdefault(row["category"], []).append(cid)

    lines = ["\tdata.CurrencyByCategory = {"]
    for category_id in sorted(by_category):
        category_name = category_names.get(category_id, f"Unknown Category {category_id}")
        lines.append(f"\t\t[{category_id}] = {{ -- {category_name}")
        for cid in sorted(by_category[category_id]):
            row = currency_rows[cid]
            prefix = "\t\t\t" if row["description"] else "\t--\t\t"
            lines.append(f"{prefix}{cid}, -- {row['name']}")
        lines.append("\t\t},")
    lines.append("\t}")
    return "\n".join(lines)


def build_currencies(currency_rows, category_names):
    lines = ["\tdata.Currencies = {"]
    for cid in sorted(currency_rows):
        row = currency_rows[cid]
        category_name = category_names.get(row["category"], f"Unknown Category {row['category']}")
        hide_part = ", hide=true" if not row["description"] else ""
        lines.append(f"\t\t[{cid}] = {{ id={cid}, category={row['category']}{hide_part} }}, -- {row['name']}, {category_name}")
    lines.append("\t}")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base_file", help="CurrencyTypes CSV file name or path, e.g. CurrencyTypes.12.1.5.69952_enUS.csv")
    parser.add_argument("--output", help="Write result to this file (default: <Build>.currencies.lua next to the source CSVs)")
    args = parser.parse_args()

    types_path = Path(args.base_file)
    if not types_path.name.startswith(FILENAME_PREFIX):
        print(f"Expected a '{FILENAME_PREFIX}...' file, got '{types_path.name}'", file=sys.stderr)
        sys.exit(1)

    suffix = types_path.name[len(FILENAME_PREFIX):]  # e.g. ".12.1.5.69952_enUS.csv"
    category_path = types_path.with_name(f"{CATEGORY_PREFIX}{suffix}")

    if not category_path.exists():
        print(f"Required file not found: {category_path}", file=sys.stderr)
        sys.exit(1)

    category_names = read_category_names(category_path)
    currency_rows = read_currency_rows(types_path)

    lua_text = build_by_category(currency_rows, category_names) + "\n\n" + build_currencies(currency_rows, category_names)

    build_locale = suffix[1:-4]  # strip leading "." and trailing ".csv"
    output_path = Path(args.output) if args.output else types_path.with_name(f"{build_locale}.currencies.lua")
    with open(output_path, "w", encoding="utf-8", newline="") as f:
        f.write(lua_text.replace("\n", "\r\n") + "\r\n")
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
