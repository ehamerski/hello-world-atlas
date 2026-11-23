#!/usr/bin/env python3
# check-missing-categories.py — fail when a language is missing cli, desktop
# or web and its README.md does not explain why.
#
# WHAT: for each language passed as a command-line argument, reads
#       languages/<lang>/meta.yml to find which category folders are listed,
#       then checks that every missing category from {cli, desktop, web} is
#       explained in languages/<lang>/README.md. Fails (exit 1) on any
#       missing explanation.
# WHY:  a language that silently omits a category looks incomplete. The README
#       must tell the student why — for example, Dart has no desktop version
#       because desktop GUI for Dart requires Flutter.
# HOW:  python3 scripts/check-missing-categories.py python dart swift
#       (called by scripts/check-language.sh step 7)
#
# Uses parse_meta from gen-readme.py (the project's own YAML subset parser).

import sys
import os
import re
import pathlib

# Import parse_meta from gen-readme.py (same directory).
import importlib.util
spec = importlib.util.spec_from_file_location(
    "gen_readme", os.path.join(os.path.dirname(__file__), "gen-readme.py"))
gen_readme = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen_readme)
parse_meta = gen_readme.parse_meta

REQUIRED = ["cli", "desktop", "web"]

# Patterns that count as "explaining" a missing category in the README.
EXPLAIN_PATTERNS = {
    "cli":     re.compile(
        r"why there is no (desktop or )?cli|no cli version|no cli implementation|"
        r"does not (have|include|provide) a? cli|cli is not|"
        r"no desktop or (web and )?cli|no cli or",
        re.IGNORECASE,
    ),
    "desktop": re.compile(
        r"why there is no (desktop|desktop or web|web or desktop)|"
        r"no desktop version|no desktop implementation|"
        r"does not (have|include|provide) a? desktop|desktop is not|"
        r"desktop gui|desktop.*flutter|flutter.*desktop|"
        r"no desktop or web|not implemented.*desktop",
        re.IGNORECASE,
    ),
    "web":     re.compile(
        r"why there is no (web|desktop or web|web or desktop)|"
        r"no web version|no web implementation|"
        r"does not (have|include|provide) a? web|web is not|"
        r"no desktop or web|not implemented.*web",
        re.IGNORECASE,
    ),
}

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

    # Collect the category kinds AND folder names that are present.
    # Some languages use non-standard folder names but standard kinds
    # (e.g. pseudocode/portugol has kind: "cli", not folder: "cli").
    present_kinds = set()
    present_folders = set()
    for cat in data.get("categories", []) or []:
        if isinstance(cat, dict):
            present_folders.add(cat.get("folder", ""))
            present_kinds.add(cat.get("kind", ""))

    readme = pathlib.Path(f"languages/{lang}/README.md")
    readme_text = readme.read_text() if readme.exists() else ""

    for cat in REQUIRED:
        if cat in present_folders or cat in present_kinds:
            continue
        # Category is absent — check that README explains it.
        pattern = EXPLAIN_PATTERNS.get(cat)
        if pattern and not pattern.search(readme_text):
            errors.append(
                f"  languages/{lang}: missing {cat!r} category and "
                f"README.md does not explain why"
            )

if errors:
    print("FAIL: missing categories with no explanation in README.md:")
    for e in errors:
        print(e)
    sys.exit(1)

print("OK: all missing categories are explained in README.md")
