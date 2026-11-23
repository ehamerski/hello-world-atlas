#!/bin/sh
# scripts/check-product.sh - check that published files hold no work notes.
#
# WHAT: searches every published file for words that belong to how the
#   repository is maintained, not to what a reader needs:
#     gate G<n>   plan §   rev <n>   sub-task   (case-insensitive)
#     a path into the unpublished process/ folder
#     an internal rule number such as R10.8 or "rule R6"
#   and prints each match as file:line:text. A web address that happens
#   to contain /process/ (for example docs.kernel.org/process/) is not a
#   match. When process/check-product-patterns.txt exists, its lines
#   (grep -E, case-insensitive) are searched too; it holds the names that
#   must not appear in the public repository, so it is not published.
#   Without an argument it checks the files git tracks under the paths in
#   scripts/public-paths.txt. With a folder (for example the output of
#   scripts/export-public.sh) it checks every file in that folder.
#
# WHY: the repository, its README files and the website are written for
#   students. Work notes live outside the published paths; this check
#   catches one that slips into a published file before it goes out.
#
# USAGE:
#   scripts/check-product.sh                # the published paths of this checkout
#   scripts/check-product.sh /path/to/dir   # every file in another folder
# Exit code 0 = no match, 1 = at least one match.
#
# This file and the Vale rule with the same word patterns
# (.vale/styles/HelloWorld/WorkNotes.yml) are skipped: they have to name
# the patterns they look for.

set -eu
if [ $# -gt 1 ]; then
    echo "Usage: scripts/check-product.sh [folder]" >&2
    exit 1
fi
# Resolve the folder before moving to the repository root.
DIR=
if [ $# -eq 1 ]; then
    [ -d "$1" ] || { echo "Not a folder: $1" >&2; exit 1; }
    DIR=$(cd -- "$1" && pwd)
fi
cd -- "$(dirname -- "$0")/.."
ROOT=$(pwd)
. ./scripts/common.sh

# grep -E syntax. "rev" must start a word, so "prev 1" does not match.
# "process/" must start a path, so ".../process/" in a URL does not match.
PATTERN='gate G[0-9]|plan §|(^|[^[:alnum:]_])rev [0-9]|sub-task|(^|[^[:alnum:]_./-])process/'
EXTRA=process/check-product-patterns.txt
if [ -f "$EXTRA" ]; then
    while IFS= read -r p; do
        case $p in ''|'#'*) continue ;; esac
        PATTERN="$PATTERN|$p"
    done < "$EXTRA"
fi
# Rule numbers are matched case-sensitively, so CPU registers (r8) and
# release names (R21) do not match: a dotted number (R10.8), or a number
# after "rule", "principle" or "requirement", or after a Markdown file name
# ("notes.md, R28").
RULES='(^|[^[:alnum:]_])R[0-9]+\.[0-9]+|([Rr]ules?|[Pp]rinciples?|[Rr]equirements?) R[0-9]+|\.md, R[0-9]+'
SELF=scripts/check-product.sh
VALE_RULE=.vale/styles/HelloWorld/WorkNotes.yml

LIST=$(mktemp "${TMPDIR:-/tmp}/check-product.XXXXXX")
trap 'rm -f "$LIST" "$LIST.hit"' EXIT INT TERM

if [ -n "$DIR" ]; then
    step "Checking every file in $DIR for work notes"
    cd -- "$DIR"
    # .git holds history and git's own files, not published content.
    find . -type f ! -path './.git/*' | sed 's#^\./##' | sort > "$LIST"
else
    step "Checking the published paths for work notes"
    explain "Paths from scripts/public-paths.txt; files as git tracks them (git ls-files)."
    # shellcheck disable=SC2046  # one pathspec per word is intended
    git ls-files -- $(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$ROOT/scripts/public-paths.txt") > "$LIST"
fi

checked=0
found=0
while IFS= read -r f; do
    [ "$f" = "$SELF" ] && continue
    [ "$f" = "$VALE_RULE" ] && continue
    [ -f "$f" ] || continue
    checked=$((checked + 1))
    # -I skips binary files (images, ZIPs); -n adds the line number.
    : > "$LIST.hit"
    grep -E -i -n -I -- "$PATTERN" "$f" >> "$LIST.hit" 2>/dev/null || true
    grep -E -n -I -- "$RULES" "$f" >> "$LIST.hit" 2>/dev/null || true
    if [ -s "$LIST.hit" ]; then
        sort -t: -k1,1n -u "$LIST.hit" | sed "s#^#$f:#"
        found=$((found + $(sort -t: -k1,1n -u "$LIST.hit" | wc -l)))
    fi
done < "$LIST"

if [ "$found" -gt 0 ]; then
    fail "$found line(s) with work notes in $checked files. Reword them for a reader, or move the file out of the published paths."
fi
ok "No work notes in $checked files."
