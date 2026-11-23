#!/usr/bin/env python3
"""scripts/approved.py - read languages/APPROVED.txt and check against it.

WHAT: languages/APPROVED.txt is the approved list of languages and
implementation folders. This script reads it and:
  python3 scripts/approved.py --check
      checks the folders under languages/: every listed language has a
      meta.yml, every listed category has a folder with a README.md (and a
      run.sh unless it is marked documented), every folder with a README.md
      is listed, and the number of languages equals the number of lines;
  python3 scripts/approved.py --folders
      prints one languages/<language>/<category> line per listed category;
  python3 scripts/approved.py --counts
      prints "<implementations> <languages>";
  python3 scripts/approved.py --site site/dist
      checks a built site: a page per listed language and a download ZIP
      per listed category;
  python3 scripts/approved.py --export <folder>
      checks an exported copy against the APPROVED.txt inside it: the list
      is there, and every listed meta.yml and folder is in it.
Exit code 0 = everything matches, 1 = something is missing or extra.
scripts/gen-readme.py imports read() from this file.

WHY: every generator scans languages/*/meta.yml, so a deleted language
would vanish from every table and page without any error. A committed list
turns that silent loss into a failing check.

No third-party package is needed.
"""

import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIST = os.path.join('languages', 'APPROVED.txt')
WAVES = ('1', '2', '3')


class ApprovedError(Exception):
    pass


def read(root=ROOT):
    """Return {language: [(category, documented), ...]} from APPROVED.txt."""
    path = os.path.join(root, LIST)
    langs = {}
    with open(path, encoding='utf-8') as f:
        for number, line in enumerate(f, 1):
            words = line.split('#', 1)[0].split()
            if not words:
                continue
            where = f'{LIST}:{number}'
            if len(words) < 3:
                raise ApprovedError(f'{where}: expected <language> <wave> '
                                    '<category>...')
            lang, wave, cats = words[0], words[1], words[2:]
            if wave not in WAVES:
                raise ApprovedError(f'{where}: wave {wave!r} is not one of '
                                    f'{", ".join(WAVES)}')
            if lang in langs:
                raise ApprovedError(f'{where}: {lang} is listed twice')
            entries = []
            for cat in cats:
                name, _, mark = cat.partition(':')
                if mark not in ('', 'documented'):
                    raise ApprovedError(f'{where}: unknown mark {mark!r} '
                                        f'on {name}')
                if name in [e[0] for e in entries]:
                    raise ApprovedError(f'{where}: {lang}/{name} is listed '
                                        'twice')
                entries.append((name, mark == 'documented'))
            langs[lang] = entries
    if not langs:
        raise ApprovedError(f'{LIST}: no languages listed')
    return langs


def folders(langs):
    return [f'languages/{lang}/{cat}'
            for lang in sorted(langs) for cat, _ in langs[lang]]


def check_tree(langs):
    """Compare the list with the folders under languages/."""
    errors = []
    on_disk = sorted(d for d in os.listdir('languages')
                     if os.path.isdir(os.path.join('languages', d)))
    for lang in sorted(langs):
        if not os.path.isfile(os.path.join('languages', lang, 'meta.yml')):
            errors.append(f'languages/{lang}/meta.yml is missing, but '
                          f'{lang} is listed in {LIST}')
            continue
        for cat, documented in langs[lang]:
            folder = os.path.join('languages', lang, cat)
            if not os.path.isfile(os.path.join(folder, 'README.md')):
                errors.append(f'{folder}/README.md is missing, but '
                              f'{lang}/{cat} is listed in {LIST}')
            elif os.path.isfile(os.path.join(folder, 'run.sh')) == documented:
                errors.append(f'{folder}: marked documented in {LIST} '
                              'means no run.sh, and only then')
    for lang in on_disk:
        base = os.path.join('languages', lang)
        if lang not in langs:
            if os.path.isfile(os.path.join(base, 'meta.yml')):
                errors.append(f'{base}/ has a meta.yml but is not listed '
                              f'in {LIST}')
            continue
        listed = [cat for cat, _ in langs[lang]]
        for entry in sorted(os.listdir(base)):
            if (os.path.isfile(os.path.join(base, entry, 'README.md'))
                    and entry not in listed):
                errors.append(f'{base}/{entry}/ has a README.md but is not '
                              f'listed in {LIST}')
    with_meta = [d for d in on_disk
                 if os.path.isfile(os.path.join('languages', d, 'meta.yml'))]
    if len(with_meta) != len(langs):
        errors.append(f'{len(with_meta)} languages have a meta.yml, but '
                      f'{LIST} lists {len(langs)}')
    return errors


def check_site(langs, dist):
    """A page per listed language, a ZIP per listed category."""
    errors = []
    for lang in sorted(langs):
        page = os.path.join(dist, 'languages', lang, 'index.html')
        if not os.path.isfile(page):
            errors.append(f'{page} is missing')
        for cat, _ in langs[lang]:
            zip_path = os.path.join(dist, 'downloads',
                                    f'hello-world-{lang}-{cat}.zip')
            if not os.path.isfile(zip_path):
                errors.append(f'{zip_path} is missing')
    return errors


def check_export(langs, target):
    """Every listed meta.yml and implementation folder is in the export."""
    errors = []
    for lang in sorted(langs):
        if not os.path.isfile(os.path.join(target, 'languages', lang,
                                           'meta.yml')):
            errors.append(f'{target}/languages/{lang}/meta.yml is missing')
        for cat, _ in langs[lang]:
            if not os.path.isfile(os.path.join(target, 'languages', lang,
                                               cat, 'README.md')):
                errors.append(f'{target}/languages/{lang}/{cat}/README.md '
                              'is missing')
    return errors


def main(argv):
    mode, args = argv[1:2], argv[2:]
    usage = ('usage: python3 scripts/approved.py '
             '[--check | --folders | --counts | --site DIST | --export DIR]')
    if mode not in (['--check'], ['--folders'], ['--counts'],
                    ['--site'], ['--export']) or \
            len(args) != (1 if mode[0] in ('--site', '--export') else 0):
        print(usage, file=sys.stderr)
        return 2
    # Paths given on the command line are read from the caller's folder.
    target = os.path.abspath(args[0]) if args else None
    os.chdir(ROOT)
    try:
        langs = read(target if mode == ['--export'] else ROOT)
    except (ApprovedError, OSError) as error:
        print(f'approved: {error}', file=sys.stderr)
        return 1
    if mode == ['--folders']:
        print('\n'.join(folders(langs)))
        return 0
    if mode == ['--counts']:
        print(len(folders(langs)), len(langs))
        return 0
    if mode == ['--check']:
        errors = check_tree(langs)
    elif mode == ['--site']:
        errors = check_site(langs, target)
    else:
        errors = check_export(langs, target)
    for error in errors:
        print(f'approved: {error}', file=sys.stderr)
    if errors:
        return 1
    print(f'approved: {len(folders(langs))} implementations in '
          f'{len(langs)} languages, as listed in {LIST}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
