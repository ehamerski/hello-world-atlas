#!/usr/bin/env python3
"""scripts/gen-readme.py - build the language tables from languages/*/meta.yml.

WHAT: reads every languages/<language>/meta.yml and rewrites the parts of
  README.md                the language table (one row per language)
  languages/README.md      the implementations table (one row per folder)
that sit between the markers
  <!-- BEGIN GENERATED: <name> -->  ...  <!-- END GENERATED: <name> -->
Everything outside the markers is written by hand and left alone.

WHY: meta.yml is the single source of truth for each language.
Generating the tables keeps them in sync with it, and with the folders on
disk, instead of editing about 70 table rows by hand.

HOW:
  python3 scripts/gen-readme.py           # rewrite the generated parts
  python3 scripts/gen-readme.py --check   # change nothing; exit 1 if stale
The output only depends on the meta.yml files and the folders, so running
it twice gives no diff. --check is what CI runs.

No third-party package is needed. meta.yml uses a small, strict subset of
YAML (documented in languages/README.md, "meta.yml schema"), and the
parser below reads only that subset and stops with an error on anything
else. Every meta.yml is still valid YAML for any other YAML tool (the site
generator, site/scripts/generate.mjs, reads it with a full parser). YAML 1.2.2:
https://yaml.org/spec/1.2.2/
"""

import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LANG_DIR = 'languages'

# Allowed values. The meaning of each one is in languages/README.md.
KINDS = ['cli', 'desktop', 'web', 'web-frontend', 'mobile']
KIND_HEADERS = {'cli': 'cli', 'desktop': 'desktop', 'web': 'web',
                'web-frontend': 'web + separate front end', 'mobile': 'mobile'}
STATUS_ICONS = {'verified': '✅', 'compromise': '🔶',
                'not-verified': '⚠️', 'documented': '📄'}
# Paradigms explained in docs/paradigms.md get a link to their section.
LINKED_PARADIGMS = ['imperative', 'object-oriented', 'functional', 'logic']

LANGUAGE_KEYS = {'name': True, 'year': True, 'year_note': False,
                 'designers': True, 'paradigms': True, 'categories': True,
                 'sources': True, 'influenced_by': False, 'humor': True}
CATEGORY_KEYS = {'folder': True, 'kind': True, 'label': False,
                 'toolchain': True, 'run': True, 'status': True,
                 'note': False}
SOURCE_KEYS = {'title': True, 'url': True}
# influenced_by: one entry per influence, each with its own source and the
# exact words of that source (shown on the website's Genealogy page).
INFLUENCE_KEYS = {'language': True, 'slug': False, 'title': True,
                  'url': True, 'quote': True}
# humor: the language's lines on the website's Off the record page and in
# the box at the end of its page. The jokes are quoted, so each one names
# where it was found; the dictionary entries are our own text.
HUMOR_KEYS = {'line': True, 'label': False, 'jokes': False,
              'dictionary': False}
JOKE_KEYS = {'text': True, 'author': False, 'title': True, 'url': True,
             'accessed': True}
DICTIONARY_KEYS = {'term': True, 'part': False, 'definition': True}


class MetaError(Exception):
    pass


# ---------------------------------------------------------------- parser

def scalar(text, where):
    """A value: "double-quoted string" (JSON escapes), integer, null or
    [] (an empty list; a key with no items would be null in YAML)."""
    if text == 'null':
        return None
    if text == '[]':
        return []
    if re.fullmatch(r'-?[0-9]+', text):
        return int(text)
    if text.startswith('"'):
        try:
            value = json.loads(text)
        except ValueError:
            raise MetaError(f'{where}: invalid quoted string {text}')
        if isinstance(value, str):
            return value
    raise MetaError(f'{where}: write strings in double quotes: {text}')


def parse_meta(path):
    """Parse the meta.yml subset into dicts and lists.

    Accepted lines (2-space indent, no tabs, comments only on their own line):
      key: value              top-level scalar (or [] for an empty list)
      key:                    top-level list follows, at least one item
        - value               list of scalars
        - key: value          list of mappings: first key of an item...
          key: value          ...and the item's other keys
    A top-level "key:" may hold a mapping instead of a list (used by humor):
      key:
        key: value            a scalar inside the mapping
        key:                  a list inside the mapping, written as above
          - key: value        but two spaces further in
            key: value
    """
    data = {}
    opened = []         # (container, key, where) of "key:" lines needing items
    mapping = None      # the top-level mapping being filled, or None
    current = None      # the list being filled, or None
    pad = ''            # indent of that list: '' at top level, '  ' in a mapping
    item = None         # the mapping being filled inside that list
    with open(path, encoding='utf-8') as f:
        lines = f.read().split('\n')
    for number, line in enumerate(lines, 1):
        where = f'{path}:{number}'
        if '\t' in line:
            raise MetaError(f'{where}: use spaces, not tabs')
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        m = re.fullmatch(r'([a-z_]+):(?: (.+))?', line)
        if m:                                   # top-level key
            key, value = m.groups()
            if key in data:
                raise MetaError(f'{where}: duplicate key {key}')
            if value is None:
                current = data[key] = []
                opened.append((data, key, where))
            else:
                data[key], current = scalar(value, where), None
            mapping, pad, item = None, '', None
            continue
        m = re.fullmatch(r'  ([a-z_]+):(?: (.+))?', line)
        if m and (mapping is not None or (current == [] and pad == '')):
            if mapping is None:                 # the "key:" above is a mapping
                parent = next(k for k in data if data[k] is current)
                mapping = data[parent] = {}
            key, value = m.groups()
            if key in mapping:
                raise MetaError(f'{where}: duplicate key {key}')
            if value is None:
                current = mapping[key] = []
                opened.append((mapping, key, where))
            else:
                mapping[key], current = scalar(value, where), None
            pad, item = '  ', None
            continue
        m = re.fullmatch(pad + r'  - ([a-z_]+): (.+)', line)
        if m and current is not None:           # first key of a mapping item
            item = {m.group(1): scalar(m.group(2), where)}
            current.append(item)
            continue
        m = re.fullmatch(pad + r'  - (.+)', line)
        if m and current is not None:           # scalar list item
            current.append(scalar(m.group(1), where))
            item = None
            continue
        m = re.fullmatch(pad + r'    ([a-z_]+): (.+)', line)
        if m and item is not None:              # next key of a mapping item
            if m.group(1) in item:
                raise MetaError(f'{where}: duplicate key {m.group(1)}')
            item[m.group(1)] = scalar(m.group(2), where)
            continue
        raise MetaError(f'{where}: not in the meta.yml subset: {line!r}')
    for container, key, where in opened:
        if not container[key]:
            raise MetaError(f'{where}: {key}: has no items (YAML reads that '
                            f'as null); write {key}: [] for an empty list')
    return data


# ------------------------------------------------------------ validation

def check_keys(mapping, allowed, where):
    if not isinstance(mapping, dict):
        raise MetaError(f'{where}: expected "key: value" entries')
    for key in mapping:
        if key not in allowed:
            raise MetaError(f'{where}: unknown key {key}')
    for key, required in allowed.items():
        if required and key not in mapping:
            raise MetaError(f'{where}: missing key {key}')


def check_humor(humor, path):
    where = f'{path} (humor)'
    check_keys(humor, HUMOR_KEYS, where)
    for key, keys in (('jokes', JOKE_KEYS), ('dictionary', DICTIONARY_KEYS)):
        if not isinstance(humor.get(key, []), list):
            raise MetaError(f'{where}: {key} must be a list')
        for entry in humor.get(key, []):
            check_keys(entry, keys, f'{where} ({key})')
    for joke in humor.get('jokes', []):
        if not re.fullmatch(r'[0-9]{4}-[0-9]{2}-[0-9]{2}', str(joke['accessed'])):
            raise MetaError(f'{where}: accessed must be a date, YYYY-MM-DD')


def load_language(lang):
    """Read and check languages/<lang>/meta.yml against the folders."""
    path = os.path.join(LANG_DIR, lang, 'meta.yml')
    meta = parse_meta(path)
    check_keys(meta, LANGUAGE_KEYS, path)
    if meta['year'] is not None and not isinstance(meta['year'], int):
        raise MetaError(f'{path}: year must be an integer or null')
    if meta['year'] is None and 'year_note' not in meta:
        raise MetaError(f'{path}: year is null, so year_note must say why')
    for key in ('designers', 'paradigms', 'categories', 'sources'):
        if not isinstance(meta[key], list):
            raise MetaError(f'{path}: {key} must be a list')
    if not meta['paradigms'] or not meta['sources']:
        raise MetaError(f'{path}: paradigms and sources must not be empty')
    for source in meta['sources']:
        check_keys(source, SOURCE_KEYS, f'{path} (sources)')
    if not isinstance(meta.get('influenced_by', []), list):
        raise MetaError(f'{path}: influenced_by must be a list')
    for influence in meta.get('influenced_by', []):
        check_keys(influence, INFLUENCE_KEYS, f'{path} (influenced_by)')
        slug = influence.get('slug')
        if slug is not None and not os.path.isfile(
                os.path.join(LANG_DIR, slug, 'meta.yml')):
            raise MetaError(f'{path}: influenced_by slug {slug!r} is not a '
                            f'folder of {LANG_DIR}/')
    check_humor(meta['humor'], path)
    folders = []
    for cat in meta['categories']:
        check_keys(cat, CATEGORY_KEYS, f'{path} (categories)')
        if cat['kind'] not in KINDS:
            raise MetaError(f'{path}: kind {cat["kind"]!r} is not one of {KINDS}')
        if cat['status'] not in STATUS_ICONS:
            raise MetaError(f'{path}: status {cat["status"]!r} is not one of '
                            f'{list(STATUS_ICONS)}')
        folder = os.path.join(LANG_DIR, lang, cat['folder'])
        if not os.path.isfile(os.path.join(folder, 'README.md')):
            raise MetaError(f'{path}: {folder}/README.md does not exist')
        has_run = os.path.isfile(os.path.join(folder, 'run.sh'))
        if has_run == (cat['status'] == 'documented'):
            raise MetaError(f'{path}: {folder}: status "documented" is for '
                            'folders without run.sh, and only for them')
        cat['build'] = os.path.isfile(os.path.join(folder, 'build.sh'))
        folders.append(cat['folder'])
    # Every implementation folder on disk must be listed, so none is missed.
    for entry in sorted(os.listdir(os.path.join(LANG_DIR, lang))):
        if (os.path.isfile(os.path.join(LANG_DIR, lang, entry, 'README.md'))
                and entry not in folders):
            raise MetaError(f'{path}: folder {entry}/ is not under categories')
    meta['lang'] = lang
    return meta


def load_all():
    langs = sorted(d for d in os.listdir(LANG_DIR)
                   if os.path.isfile(os.path.join(LANG_DIR, d, 'meta.yml')))
    metas = [load_language(lang) for lang in langs]
    # Sorted by display name, so the order never depends on the file system.
    return sorted(metas, key=lambda m: (m['name'].casefold(), m['lang']))


# ------------------------------------------------------------- rendering

def rel(target, from_dir):
    """Relative link from the folder of a generated file to target."""
    link = os.path.relpath(target, from_dir or '.')
    return link + '/' if target.endswith('/') else link


def paradigm_cell(meta, from_dir):
    words = []
    for p in meta['paradigms']:
        if p in LINKED_PARADIGMS:
            words.append(f'[{p}]({rel("docs/paradigms.md", from_dir)}#{p})')
        else:
            words.append(p)
    return ' / '.join(words)


def impl_link(meta, cat, from_dir, text):
    path = f'{LANG_DIR}/{meta["lang"]}/{cat["folder"]}/'
    return f'{STATUS_ICONS[cat["status"]]} [{text}]({rel(path, from_dir)})'


def language_table(metas, from_dir):
    """Root README: one row per language, one column per kind in use."""
    kinds = [k for k in KINDS
             if any(c['kind'] == k for m in metas for c in m['categories'])]
    impls = [c for m in metas for c in m['categories']]
    runnable = sum(1 for c in impls if c['status'] != 'documented')
    out = [f'**{len(impls)} implementations** in **{len(metas)} languages**: '
           f'{runnable} run with `scripts/verify-all.sh`, '
           f'{len(impls) - runnable} documented only.',
           '',
           'Status: ' + ' · '.join(f'{icon} {status.replace("-", " ")}'
                                   for status, icon in STATUS_ICONS.items())
           + ' · – not implemented (the language README explains why).',
           '',
           '| Language | Year | Designers | Paradigm | '
           + ' | '.join(KIND_HEADERS[k] for k in kinds) + ' |',
           '|---' * (4 + len(kinds)) + '|']
    for m in metas:
        readme = rel(f'{LANG_DIR}/{m["lang"]}/README.md', from_dir)
        cells = [f'[{m["name"]}]({readme})',
                 '–' if m['year'] is None else str(m['year']),
                 ', '.join(m['designers']) or '–',
                 paradigm_cell(m, from_dir)]
        for k in kinds:
            links = [impl_link(m, c, from_dir, c.get('label', c['folder']))
                     for c in m['categories'] if c['kind'] == k]
            cells.append(' · '.join(links) or '–')
        out.append('| ' + ' | '.join(cells) + ' |')
    return '\n'.join(out)


def category_name(cat):
    if cat['kind'] == 'web-frontend':
        return f'web + {cat.get("label", "front end")}'
    if 'label' in cat and cat['kind'] != 'cli':
        return f'{cat["kind"]} ({cat["label"]})'
    return cat['kind']


def implementations_table(metas, from_dir):
    """languages/README.md: one row per implementation folder."""
    out = ['| # | Folder | Language | Category | Toolchain / framework '
           '| `build.sh` | `run.sh` result | Walkthrough |',
           '|---|---|---|---|---|---|---|---|']
    n = 0
    for m in metas:
        for c in m['categories']:
            n += 1
            folder = f'{m["lang"]}/{c["folder"]}'
            path = rel(f'{LANG_DIR}/{folder}/', from_dir)
            name = m['name']
            if 'label' in c and c['kind'] == 'cli':
                name += f' ({c["label"]})'
            documented = c['status'] == 'documented'
            out.append('| ' + ' | '.join([
                str(n),
                f'{STATUS_ICONS[c["status"]]} [{folder}]({path})',
                name,
                category_name(c),
                c['toolchain'],
                '–' if documented else ('yes' if c['build'] else 'no'),
                c['run'],
                f'[read]({path}README.md#step-by-step-walkthrough)',
            ]) + ' |')
    return '\n'.join(out)


# ------------------------------------------------------- marker handling

def replace_block(text, name, body, path):
    begin = f'<!-- BEGIN GENERATED: {name} -->'
    end = f'<!-- END GENERATED: {name} -->'
    if text.count(begin) != 1 or text.count(end) != 1:
        raise MetaError(f'{path}: needs exactly one {begin} and one {end}')
    head, rest = text.split(begin)
    _, tail = rest.split(end)
    note = ('<!-- Do not edit by hand: run python3 scripts/gen-readme.py '
            '(source: languages/*/meta.yml). -->')
    return f'{head}{begin}\n{note}\n{body}\n{end}{tail}'


def main(argv):
    check = argv[1:] == ['--check']
    if argv[1:] and not check:
        print('usage: python3 scripts/gen-readme.py [--check]', file=sys.stderr)
        return 2
    os.chdir(ROOT)
    try:
        metas = load_all()
        targets = {
            'README.md': ('language-table', language_table(metas, '')),
            os.path.join(LANG_DIR, 'README.md'):
                ('implementations-table', implementations_table(metas, LANG_DIR)),
        }
        stale = []
        for path, (name, body) in targets.items():
            with open(path, encoding='utf-8') as f:
                old = f.read()
            new = replace_block(old, name, body, path)
            if new == old:
                continue
            stale.append(path)
            if not check:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(new)
    except (MetaError, OSError) as error:
        print(f'gen-readme: {error}', file=sys.stderr)
        return 1
    if check:
        for path in stale:
            print(f'gen-readme: {path} is out of date; run '
                  'python3 scripts/gen-readme.py', file=sys.stderr)
        if not stale:
            print(f'gen-readme: up to date ({len(metas)} languages)')
        return 1 if stale else 0
    print(f'gen-readme: {len(metas)} languages; updated: '
          + (', '.join(stale) or 'nothing (already up to date)'))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
