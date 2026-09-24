#!/usr/bin/env python3
"""Generate a Lua `data.CurrencyCategories` table from extracted CurrencyCategory CSV files.

Each CSV lives under .data and is named:
    <DatabaseName>.<BuildNumber>_<Locale>.csv
e.g. CurrencyCategory.12.1.5.69952_enUS.csv

Given one such file, this script finds every other locale file that shares the
same database name and build number, merges their localized names, and prints
(or writes) the corresponding `data.CurrencyCategories = { ... }` Lua snippet.
Pass --hide-flag to mark rows whose Flags column equals that value as hidden;
if omitted, no rows are marked hidden (the hidden Flags value varies by client version).
"""

import argparse
import csv
import re
import sys
from pathlib import Path

# Preferred output order; any locale not listed here is appended alphabetically.
LOCALE_ORDER = ["enUS", "deDE", "esES", "esMX", "frFR", "itIT", "koKR", "ptBR", "ruRU", "zhCN", "zhTW"]

FILENAME_RE = re.compile(r"^(?P<db>.+)\.(?P<build>[0-9.]+)_(?P<locale>[A-Za-z]+)\.csv$", re.IGNORECASE)


def parse_filename(name):
    match = FILENAME_RE.match(name)
    if not match:
        raise ValueError(f"Filename '{name}' does not match expected pattern '<Database>.<Build>_<Locale>.csv'")
    return match.group("db"), match.group("build"), match.group("locale")


def find_sibling_files(data_dir, db_name, build):
    return sorted(data_dir.glob(f"{db_name}.{build}_*.csv"))


def read_csv(path):
    rows = {}
    with path.open(encoding="utf-8-sig", newline="") as f:
        for row in csv.DictReader(f):
            rows[int(row["ID"])] = row
    return rows


def lua_escape(value):
    return value.replace("\\", "\\\\").replace('"', '\\"')


def build_lua(base_rows, locale_names, locale_order, hide_flag):
    lines = ["\tdata.CurrencyCategories = {"]
    for cid in sorted(base_rows):
        parts = []
        for locale in locale_order:
            names = locale_names.get(locale, {})
            if cid in names:
                parts.append(f'{locale}="{lua_escape(names[cid])}"')
        flags = int(base_rows[cid]["Flags"] or 0)
        hide_part = " hide=true," if hide_flag is not None and flags == hide_flag else ""
        lines.append(f"\t\t[{cid}] = {{ {','.join(parts)},{hide_part} }},")
    lines.append("\t}")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base_file", help="Base CSV file name or path, e.g. CurrencyCategory.12.1.5.69952_enUS.csv")
    parser.add_argument("--data-dir", help="Directory containing the CSV files (default: LibCurrencyInfo/.data next to this script, or the base file's own directory)")
    parser.add_argument("--output", help="Write result to this file (default: <DatabaseName>.<Build>.lua next to the source CSVs)")
    parser.add_argument("--hide-flag", type=int, default=None, help="Flags value that marks a category as hidden (hide=true). Omit to mark nothing hidden, since the hidden Flags value differs between client versions.")
    args = parser.parse_args()

    script_dir = Path(__file__).resolve().parent
    default_data_dir = script_dir.parent / ".data"

    base_path = Path(args.base_file)
    if args.data_dir:
        data_dir = Path(args.data_dir)
    elif base_path.parent != Path("."):
        data_dir = base_path.parent
    else:
        data_dir = default_data_dir

    db_name, build, base_locale = parse_filename(base_path.name)

    files = find_sibling_files(data_dir, db_name, build)
    if not files:
        print(f"No files found matching {db_name}.{build}_*.csv in {data_dir}", file=sys.stderr)
        sys.exit(1)

    locale_names = {}
    base_rows = None
    for file in files:
        _, _, locale = parse_filename(file.name)
        rows = read_csv(file)
        locale_names[locale] = {cid: row["Name_lang"] for cid, row in rows.items()}
        if locale == base_locale:
            base_rows = rows

    if base_rows is None:
        base_rows = read_csv(files[0])

    locale_order = [loc for loc in LOCALE_ORDER if loc in locale_names]
    locale_order += sorted(loc for loc in locale_names if loc not in LOCALE_ORDER)

    lua_text = build_lua(base_rows, locale_names, locale_order, args.hide_flag)

    output_path = Path(args.output) if args.output else data_dir / f"{db_name}.{build}.lua"
    with open(output_path, "w", encoding="utf-8", newline="") as f:
        f.write(lua_text.replace("\n", "\r\n") + "\r\n")
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
