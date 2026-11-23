#!/bin/sh
# scripts/check-language.sh - check that a language folder is complete.
#
# WHAT: first, for the whole languages/ folder, even when only some
#   languages are named:
#   0. approved list  - every language and category in languages/APPROVED.txt
#                       has its meta.yml, folder and README.md, every folder
#                       with a README.md is listed, and the number of
#                       languages matches (scripts/approved.py --check).
#   Then, for languages/<lang>/, in this order:
#   1. meta.yml       - valid against the schema (languages/README.md,
#                       "meta.yml schema"), humor.line included; every
#                       folder under categories has a README.md and a run.sh
#                       (only "documented" folders have no run.sh), and every
#                       folder with a README.md is listed
#                       (scripts/gen-readme.py --validate);
#   2. site tables    - the site knows the comment syntax and the code
#                       highlighting of each main source file
#                       (site/scripts/generate.mjs --check);
#   3. README tables  - the generated tables in README.md and
#                       languages/README.md match every meta.yml
#                       (scripts/gen-readme.py --check);
#   4. measured facts - site/data/facts.json has the current counts of each
#                       implementation, and a run time for each command-line
#                       one (site/scripts/measure-facts.mjs --check);
#   5. prose          - its Markdown follows the style guide
#                       (scripts/check-prose.sh languages/<lang>);
#   6. statuses       - a not-verified status is explained in ci/skip.yml
#                       (scripts/check-category-status.py);
#   7. categories     - a missing cli, desktop or web is explained in the
#                       language README (scripts/check-missing-categories.py);
#   8. screenshots    - every web*, desktop* and mobile-* folder has a
#                       screenshot.png, or its README says why there is
#                       "no screenshot";
#   9. implementations table - the table in the language README.md has the
#                       toolchain and status of each category in meta.yml
#                       (scripts/check-impl-table.py).
#   Every check runs, even after one fails, and the summary lists the ones
#   that failed. Exit code 0 = the language is complete, 1 = it is not.
#
# WHY: adding a language touches many files: meta.yml, the folders, the
#   generated tables, the site tables, the measured facts. A checklist is
#   easy to skip; a check is not. CONTRIBUTING.md calls a language done
#   when this script passes for it.
#
# USAGE:
#   scripts/check-language.sh              # every folder of languages/ with a meta.yml
#   scripts/check-language.sh python ruby  # only these languages
#
# NEEDS: python3 (standard library only), Node.js with the site's npm
#   packages (scripts/build-site.sh installs them, or: cd site && npm ci),
#   and Vale (https://vale.sh/docs/install) for the prose check.

set -eu
cd -- "$(dirname -- "$0")/.."
. ./scripts/common.sh

require_cmd python3 "Install Python 3 from https://www.python.org/downloads/."
require_cmd node "Install Node.js LTS from https://nodejs.org/."
[ -d site/node_modules ] || fail "The site's npm packages are missing. Run: (cd site && npm ci)"

if [ $# -eq 0 ]; then
    # Every language is a folder of languages/ with a meta.yml.
    # shellcheck disable=SC2046  # one word per folder name is intended
    set -- $(for f in languages/*/meta.yml; do basename "$(dirname "$f")"; done)
fi
for lang in "$@"; do
    case "$lang" in
        */*|.*|'') fail "Give a language folder name, for example: python (got: $lang)" ;;
    esac
    [ -f "languages/$lang/meta.yml" ] || fail "languages/$lang/meta.yml does not exist."
done

FAILED=''
# run "name" CMD... - run one check; remember its name if it fails.
run() {
    tf_name=$1; shift
    if "$@"; then
        ok "$tf_name"
    else
        warn "$tf_name: FAILED"
        FAILED="$FAILED
    - $tf_name"
    fi
}

step "Checking $# language(s): $*"

step "0. The approved list of languages and categories"
explain "languages/APPROVED.txt lists every language and folder; a deleted or unlisted one must not pass unnoticed."
run "approved list" python3 scripts/approved.py --check

step "1. meta.yml and the implementation folders"
explain "meta.yml is the source of every table and page, so it must follow the schema and match the folders on disk."
run "meta.yml and folders" python3 scripts/gen-readme.py --validate "$@"

step "2. The site's tables know each main source file"
explain "An unknown file extension still builds, but the page then has no Anatomy section and no line counts."
run "site tables" node site/scripts/generate.mjs --check "$@"

step "3. The generated README tables are up to date"
explain "README.md and languages/README.md list every language; a new or changed meta.yml must be regenerated."
run "README tables" python3 scripts/gen-readme.py --check

step "4. The facts of each implementation are measured"
explain "The Measured facts page reads site/data/facts.json; it must match the files and include run times."
run "measured facts" node site/scripts/measure-facts.mjs --check --only "$(echo "$@" | tr ' ' ',')"

step "5. The Markdown follows the style guide"
explain "The READMEs are published on the site, so they follow docs/contributing/style-guide.md."
# shellcheck disable=SC2046  # one path per language is intended
run "prose" scripts/check-prose.sh $(for lang in "$@"; do echo "languages/$lang"; done)

step "6. All category statuses are either verified or skipped in ci/skip.yml"
explain "A not-verified status is only allowed when ci/skip.yml documents the reason and a source."
run "category verification status" python3 scripts/check-category-status.py "$@"

step "7. Missing categories are explained in the language README"
explain "If cli, desktop, or web is absent, the language README.md must say why."
run "missing category explanations" python3 scripts/check-missing-categories.py "$@"

# check_screenshots LANG... - every web, desktop or mobile folder has a
# screenshot.png, or a README that says why it has none.
check_screenshots() {
    tf_missing=0
    for tf_lang in "$@"; do
        for tf_dir in languages/"$tf_lang"/web*/ languages/"$tf_lang"/desktop*/ languages/"$tf_lang"/mobile-*/; do
            [ -d "$tf_dir" ] || continue
            [ -f "${tf_dir}screenshot.png" ] && continue
            grep -q -i 'no screenshot' "${tf_dir}README.md" 2>/dev/null && continue
            echo "    ${tf_dir%/}: no screenshot.png and no stated reason" >&2
            tf_missing=$((tf_missing + 1))
        done
    done
    [ "$tf_missing" -eq 0 ]
}

step "8. Web, desktop and mobile folders show the result"
explain "Expected output shows screenshot.png; a folder without one must say why (CONTRIBUTING.md)."
run "screenshots" check_screenshots "$@"

step "9. The implementations table of each language README matches meta.yml"
explain "The table is written by hand; meta.yml is the source, so a changed status or toolchain must reach it too."
run "implementations table" python3 scripts/check-impl-table.py "$@"

if [ -n "$FAILED" ]; then
    fail "Not complete. These checks failed (their messages are above):$FAILED"
fi
step "Done"
ok "Complete: $*"
