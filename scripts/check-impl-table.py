#!/usr/bin/env python3
# check-impl-table.py — fail when the implementations table of a language
# README.md differs from its meta.yml.
#
# WHAT: for each language passed as a command-line argument, reads the table
#       under "## Implementations" in languages/<lang>/README.md. Every row
#       that links a folder must name a category of languages/<lang>/meta.yml,
#       its Toolchain cell must be that category's toolchain text, and its
#       Status cell must be the status icon the generated tables use (for
#       example ✅ for "verified"). Every category must have one row. A row
#       for a missing category has "–" in its Folder and Status cells.
#       Fails (exit 1) on any difference.
# WHY:  meta.yml is the source of every generated table. A table written by
#       hand drifts from it: a status changes in meta.yml, the README keeps
#       the old one, and the language page then contradicts the overview.
# HOW:  python3 scripts/check-impl-table.py python dart swift
#       (called by scripts/check-language.sh step 9)
#
# Uses parse_meta and STATUS_ICONS from gen-readme.py.

import sys
import os
import re
import pathlib

# Import gen-readme.py (same directory).
import importlib.util
spec = importlib.util.spec_from_file_location(
    "gen_readme", os.path.join(os.path.dirname(__file__), "gen-readme.py"))
gen_readme = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen_readme)
parse_meta = gen_readme.parse_meta
STATUS_ICONS = gen_readme.STATUS_ICONS

FOLDER_LINK = re.compile(r'^\[([^\]]+)/\]\(\1/\)$')


def status_text(status):
    """The Status cell for a meta.yml status, for example ✅ for "verified"."""
    return STATUS_ICONS[status]


def cells(line):
    """The cells of one Markdown table row, without the outer pipes."""
    return [c.strip() for c in line.strip().strip('|').split('|')]


def table_rows(readme):
    """The table lines of the "## Implementations" section, or None."""
    lines = readme.read_text(encoding='utf-8').splitlines()
    try:
        start = lines.index('## Implementations')
    except ValueError:
        return None
    rows = []
    for line in lines[start + 1:]:
        if line.startswith('## '):
            break
        if line.startswith('|'):
            rows.append(line)
        elif rows:
            break
    return rows


def check(lang):
    """A list of error messages for languages/<lang>."""
    readme = pathlib.Path(f'languages/{lang}/README.md')
    meta = parse_meta(f'languages/{lang}/meta.yml')
    errors = []
    rows = table_rows(readme)
    if not rows:
        return [f'  {readme}: no table under "## Implementations"']
    head = cells(rows[0])
    for column in ('Folder', 'Toolchain', 'Status'):
        if column not in head:
            errors.append(f'  {readme}: the table has no {column} column')
    if errors:
        return errors
    i_folder = head.index('Folder')
    i_tool = head.index('Toolchain')
    i_status = head.index('Status')
    categories = {c['folder']: c for c in meta['categories']}
    seen = set()
    for row in rows[2:]:
        row_cells = cells(row)
        if len(row_cells) != len(head):
            errors.append(f'  {readme}: row has {len(row_cells)} cells, '
                          f'the header has {len(head)}: {row}')
            continue
        folder_cell = row_cells[i_folder]
        status = row_cells[i_status]
        if folder_cell == '–':
            if status != '–':
                errors.append(f'  {readme}: a row without a folder has '
                              f'status {status!r}, expected "–"')
            continue
        m = FOLDER_LINK.match(folder_cell)
        if not m:
            errors.append(f'  {readme}: Folder cell {folder_cell!r} is not '
                          f'"[name/](name/)" or "–"')
            continue
        folder = m.group(1)
        cat = categories.get(folder)
        if cat is None:
            errors.append(f'  {readme}: folder {folder}/ is not a category '
                          f'in meta.yml')
            continue
        if folder in seen:
            errors.append(f'  {readme}: folder {folder}/ has two rows')
        seen.add(folder)
        if row_cells[i_tool] != cat['toolchain']:
            errors.append(f'  {readme}: {folder}: toolchain '
                          f'{row_cells[i_tool]!r}, meta.yml has '
                          f'{cat["toolchain"]!r}')
        if status != status_text(cat['status']):
            errors.append(f'  {readme}: {folder}: status {status!r}, '
                          f'meta.yml gives {status_text(cat["status"])!r}')
    for folder in categories:
        if folder not in seen:
            errors.append(f'  {readme}: no row for the category {folder}/')
    return errors


errors = []
for lang in sys.argv[1:]:
    if pathlib.Path(f'languages/{lang}/meta.yml').exists():
        errors += check(lang)

if errors:
    print('FAIL: implementations tables that differ from meta.yml:')
    for e in errors:
        print(e)
    sys.exit(1)

print('OK: every implementations table matches meta.yml')
