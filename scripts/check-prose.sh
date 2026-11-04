#!/bin/sh
# scripts/check-prose.sh - check the published Markdown against the style guide.
#
# WHAT: runs Vale (a prose linter) on every published Markdown file: the
#   files git knows (tracked, or new and not ignored) under the paths in
#   scripts/public-paths.txt. The rules are in .vale.ini and .vale/styles/:
#   US English spelling plus the project vocabulary, filler words,
#   contractions, British spellings, preferred terms, and the markers of
#   internal work notes.
#
# WHY: docs/contributing/style-guide.md is the standard for every page.
#   Vale applies the part of it that a program can check, so a reviewer can
#   spend their time on clarity and facts.
#
# USAGE:
#   scripts/check-prose.sh                 # every published Markdown file
#   scripts/check-prose.sh docs/paradigms.md languages/python   # only these
# Exit code 0 = no alert at level warning or error, 1 = at least one.
#
# Vale: https://vale.sh/docs/ (install: https://vale.sh/docs/install)

set -eu
cd -- "$(dirname -- "$0")/.."
ROOT=$(pwd)
. ./scripts/common.sh

has_cmd vale || fail "Vale was not found. Install it from https://vale.sh/docs/install (macOS: brew install vale)."

step "Checking the published Markdown files with Vale"
explain "Rules: .vale.ini and .vale/styles/ (see docs/contributing/style-guide.md, section 9)."
if [ $# -gt 0 ]; then
    # shellcheck disable=SC2046  # one pathspec per word is intended
    set -- $(git ls-files --cached --others --exclude-standard -- "$@" | grep '\.md$' || true)
else
    # shellcheck disable=SC2046
    # i18n/<tag>/ holds translations; Vale checks English only.
    set -- $(git ls-files --cached --others --exclude-standard -- $(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$ROOT/scripts/public-paths.txt") | grep '\.md$' | grep -v '^i18n/[^/]*/')
fi
[ $# -gt 0 ] || fail "No tracked Markdown file matches."
explain "$# files."
# --no-exit: count the alerts here, so the summary below is always printed.
out=$(vale --no-exit --output=line "$@")
if [ -n "$out" ]; then
    printf '%s\n' "$out"
    fail "$(printf '%s\n' "$out" | wc -l | tr -d ' ') alerts. Fix the text, or add a correct word to .vale/styles/config/vocabularies/HelloWorld/accept.txt."
fi
ok "No alerts in $# files."
