#!/usr/bin/env python3
"""
bed_tabcheck.py — validate and (optionally) fix BED delimiter issues.

Usage:
  # Just check (no changes), default: treat 4+ spaces as "a tab"
  python3 bed_tabcheck.py input.bed

  # Fix in place (make a .bak backup)
  python3 bed_tabcheck.py input.bed --fix --inplace --backup

  # Write fixed output to a new file
  python3 bed_tabcheck.py input.bed --fix -o fixed.bed

  # Treat ANY run of 2+ spaces as a delimiter
  python3 bed_tabcheck.py input.bed --fix --any-run

  # Require exactly 6 columns after fixing
  python3 bed_tabcheck.py input.bed --expected-cols 6

Notes:
- Lines starting with '#' or blank lines are ignored for validation.
- By default, only runs of >= 4 spaces are converted to tabs; change with --spaces N or use --any-run.
"""

import argparse
import os
import re
import sys
from typing import Tuple

def process_line(line: str, spaces: int, any_run: bool, squeeze_tabs: bool, do_fix: bool) -> Tuple[str, dict]:
    """
    Returns (possibly modified line, stats dict).
    Stats keys: had_tab, had_space_run, mixed, changed
    """
    raw = line.rstrip("\n")
    stats = {"had_tab": ("\t" in raw), "had_space_run": False, "mixed": False, "changed": False}

    # Skip comments/blank lines from validation
    if not raw or raw.lstrip().startswith("#"):
        return line, stats

    # Detect runs of spaces that look like delimiters
    if any_run:
        space_pat = r" {2,}"
    else:
        space_pat = rf" {{{spaces},}}"

    has_space_run = re.search(space_pat, raw) is not None
    stats["had_space_run"] = has_space_run
    stats["mixed"] = stats["had_tab"] and has_space_run

    new = raw
    if do_fix and has_space_run:
        # Replace delimiter-like runs of spaces between non-tab characters with a tab.
        # We avoid turning single spaces inside a field into tabs.
        # Heuristic: only replace space runs that are *between* non-space characters or at field boundaries.
        # Simple and effective for BED: collapse every run of N+ spaces to a single tab.
        new = re.sub(space_pat, "\t", new)
        stats["changed"] = (new != raw)

    if do_fix and squeeze_tabs:
        # Collapse accidental multiple tabs to single
        newer = re.sub(r"\t{2,}", "\t", new)
        if newer != new:
            stats["changed"] = True
        new = newer

    return (new + "\n"), stats


def validate_columns(line: str, expected: int = None, min_cols: int = None, max_cols: int = None) -> Tuple[bool, int]:
    raw = line.rstrip("\n")
    if not raw or raw.lstrip().startswith("#"):
        return True, 0
    fields = raw.split("\t")
    nf = len(fields)
    ok = True
    if expected is not None:
        ok = ok and (nf == expected)
    if min_cols is not None:
        ok = ok and (nf >= min_cols)
    if max_cols is not None:
        ok = ok and (nf <= max_cols)
    return ok, nf


def main():
    ap = argparse.ArgumentParser(description="Validate and fix tab delimiters in BED files.")
    ap.add_argument("input", help="Input BED file")
    ap.add_argument("-o", "--output", help="Write output to this file (implies --fix)")
    ap.add_argument("--fix", action="store_true", help="Convert space runs to tabs")
    ap.add_argument("--inplace", action="store_true", help="Overwrite the input file (implies --fix)")
    ap.add_argument("--backup", action="store_true", help="Create input.bed.bak before overwriting")
    ap.add_argument("--spaces", type=int, default=4, help="Treat runs of >= N spaces as a delimiter (default: 4)")
    ap.add_argument("--any-run", action="store_true", help="Treat ANY run of 2+ spaces as a delimiter")
    ap.add_argument("--squeeze-tabs", action="store_true", help="Collapse multiple tabs to a single tab")
    ap.add_argument("--expected-cols", type=int, help="Require exactly this many columns after splitting on tabs")
    ap.add_argument("--min-cols", type=int, help="Require at least this many columns")
    ap.add_argument("--max-cols", type=int, help="Require at most this many columns")
    args = ap.parse_args()

    if args.output:
        args.fix = True
    if args.inplace:
        args.fix = True
    if args.inplace and args.output:
        print("Choose either --inplace or --output, not both.", file=sys.stderr)
        sys.exit(2)

    # Read all lines
    try:
        with open(args.input, "r", encoding="utf-8") as fh:
            lines = fh.readlines()
    except FileNotFoundError:
        print(f"File not found: {args.input}", file=sys.stderr)
        sys.exit(2)

    # Process
    out_lines = []
    total = len(lines)
    changed = 0
    had_space_only = 0
    mixed_count = 0
    no_tab_count = 0
    bad_col_lines = []
    col_counts = set()

    for idx, line in enumerate(lines, start=1):
        new_line, st = process_line(
            line,
            spaces=args.spaces,
            any_run=args.any_run,
            squeeze_tabs=args.squeeze_tabs,
            do_fix=args.fix
        )
        out_lines.append(new_line)
        if st["changed"]:
            changed += 1
        if st["had_space_run"] and not st["had_tab"]:
            had_space_only += 1
        if st["mixed"]:
            mixed_count += 1
        if not st["had_tab"] and (line.strip() and not line.lstrip().startswith("#")):
            no_tab_count += 1

        # Column validation
        ok, nf = validate_columns(new_line, args.expected_cols, args.min_cols, args.max_cols)
        if nf:
            col_counts.add(nf)
        if not ok:
            bad_col_lines.append(idx)

    # Write output if requested
    if args.inplace:
        if args.backup:
            bak = args.input + ".bak"
            with open(bak, "w", encoding="utf-8") as fh:
                fh.writelines(lines)
        with open(args.input, "w", encoding="utf-8") as fh:
            fh.writelines(out_lines)
    elif args.output:
        with open(args.output, "w", encoding="utf-8") as fh:
            fh.writelines(out_lines)

    # Report
    print(f"[bed_tabcheck] Lines: {total}")
    print(f"[bed_tabcheck] Lines with ONLY space-runs (no tabs): {had_space_only}")
    print(f"[bed_tabcheck] Lines with MIXED tabs & space-runs:    {mixed_count}")
    print(f"[bed_tabcheck] Non-comment, non-empty lines lacking any tab: {no_tab_count}")
    if changed:
        target = args.input if args.inplace else (args.output or "(not written; use --fix to write)")
        print(f"[bed_tabcheck] Lines changed (fixed): {changed}  -> wrote: {target}")
    else:
        print("[bed_tabcheck] No changes made.")

    # Column summary
    if col_counts:
        pretty = ", ".join(str(n) for n in sorted(col_counts))
        print(f"[bed_tabcheck] Observed column counts (tab-split): {pretty}")
    if bad_col_lines:
        print(f"[bed_tabcheck] Lines failing column constraints: {len(bad_col_lines)}")
        # Show up to 20 offending lines to keep output tidy
        preview = bad_col_lines[:20]
        print(f"  First {len(preview)} bad lines:", ", ".join(map(str, preview)))
        if len(bad_col_lines) > len(preview):
            print(f"  ... and {len(bad_col_lines) - len(preview)} more")

    # Exit code: 0 if clean OR fixed; 1 if issues remain and not fixed
    issues = (had_space_only + mixed_count + no_tab_count + len(bad_col_lines)) > 0
    if issues and not (args.fix and (args.inplace or args.output)):
        sys.exit(1)
    sys.exit(0)


if __name__ == "__main__":
    main()

