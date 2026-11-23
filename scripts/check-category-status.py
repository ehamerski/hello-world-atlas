#!/usr/bin/env python3
# check-category-status.py — fail when a category's meta.yml has a non-verified
# status and no matching ci/skip.yml entry (with reason + source) for the current OS.
#
# WHAT: reads ci/skip.yml and languages/<lang>/meta.yml for each language passed
#       as a command-line argument. Fails (exit 1) if any category:
#         1. has status == "not-verified", AND
#         2. has no ci/skip.yml entry for the current OS (or "all") that has
#            both a reason and a source.
# WHY:  a not-verified status means the implementation was never confirmed to
#       work. It is only allowed when ci/skip.yml documents the reason (for
#       example, the toolchain is not available on the CI runner).
#       "documented" (intentionally no executable) and "compromise" (works with
#       a known caveat) are acceptable statuses and are NOT flagged by this check.
# HOW:  python3 scripts/check-category-status.py python dart swift
#       (called by scripts/check-language.sh step 6)
#
# Source for ci/skip.yml format: scripts/verify-all.sh
# Uses parse_meta from gen-readme.py (the project's own YAML subset parser).

import sys
import os
import pathlib
import platform
import re

# Add the scripts/ directory to the path so we can import gen-readme.py.
sys.path.insert(0, os.path.dirname(__file__))
import importlib.util
spec = importlib.util.spec_from_file_location(
    "gen_readme", os.path.join(os.path.dirname(__file__), "gen-readme.py"))
gen_readme = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen_readme)
parse_meta = gen_readme.parse_meta

# --- detect current OS name used in ci/skip.yml ---
uname = platform.system().lower()
if uname == "darwin":
    os_name = "macos"
elif uname == "linux":
    os_name = "linux"
else:
    os_name = "windows"


def parse_skip_yml(path: pathlib.Path) -> list:
    """Parse ci/skip.yml with a simple line-by-line parser.

    ci/skip.yml uses a plain key: value format with unquoted strings.
    Returns a list of dicts, one per skip entry.
    """
    if not path.exists():
        return []
    skips = []
    current = None
    for line in path.read_text().splitlines():
        # Start of a new skip entry
        m = re.match(r'^  - folder: (.+)', line)
        if m:
            current = {"folder": m.group(1).strip()}
            skips.append(current)
            continue
        if current is None:
            continue
        for key in ("os", "reason", "source"):
            m = re.match(rf'^    {key}: (.+)', line)
            if m:
                current[key] = m.group(1).strip().strip('"')
                break
    return skips


skips = parse_skip_yml(pathlib.Path("ci/skip.yml"))


def is_skipped(folder: str) -> bool:
    """Return True if folder has a valid skip entry for the current OS."""
    for s in skips:
        if s.get("folder") == folder:
            if s.get("os") in (os_name, "all"):
                return bool(s.get("reason", "").strip()) and \
                       bool(s.get("source", "").strip())
    return False


errors = []
for lang in sys.argv[1:]:
    meta_path = f"languages/{lang}/meta.yml"
    if not pathlib.Path(meta_path).exists():
        continue
    try:
        data = parse_meta(meta_path)
    except Exception as e:
        print(f"  WARNING: could not parse {meta_path}: {e}", file=sys.stderr)
        continue
    for cat in data.get("categories", []) or []:
        if not isinstance(cat, dict):
            continue
        folder = cat.get("folder", "")
        status = cat.get("status", "")
        full = f"languages/{lang}/{folder}"
        # Only flag "not-verified": documented (no run.sh) and compromise
        # (works with a known caveat) are acceptable without a skip entry.
        if status == "not-verified" and not is_skipped(full):
            errors.append(
                f"  {full}: status={status!r} and no ci/skip.yml entry "
                f"for os={os_name!r} with reason+source"
            )

if errors:
    print("FAIL: not-verified categories with no ci/skip.yml explanation:")
    for e in errors:
        print(e)
    sys.exit(1)

print(f"OK: all categories are verified or have a ci/skip.yml entry (os={os_name})")
