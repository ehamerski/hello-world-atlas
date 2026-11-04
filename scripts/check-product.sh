#!/bin/sh
# scripts/check-product.sh - check that published files hold no work notes.
#
# WHAT: searches every published file for words that belong to how the
#   repository is maintained, not to what a reader needs:
#     MYA-<n>   gate G<n>   plan §   rev <n>   TwinForge   sub-task
#   (case-insensitive) and prints each match as file:line:text.
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
# This file and the Vale rule with the same patterns
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
PATTERN='MYA-[0-9]+|gate G[0-9]|plan §|(^|[^[:alnum:]_])rev [0-9]|TwinForge|sub-task'
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
    if grep -E -i -n -I -- "$PATTERN" "$f" > "$LIST.hit" 2>/dev/null; then
        sed "s#^#$f:#" "$LIST.hit"
        found=$((found + $(wc -l < "$LIST.hit")))
    fi
done < "$LIST"

if [ "$found" -gt 0 ]; then
    fail "$found line(s) with work notes in $checked files. Reword them for a reader, or move the file out of the published paths."
fi
ok "No work notes in $checked files."
