#!/bin/sh
# scripts/export-public.sh - copy the published files of a release into a
# folder, ready to become one commit of the public repository.
#
# WHAT: takes the paths listed in scripts/public-paths.txt (an allowlist)
#   at one commit or tag, and only those, and:
#   - with --dry-run, prints the files it would export and changes nothing;
#   - otherwise writes them into <target>, checks that every language and
#     category of languages/APPROVED.txt is in it (scripts/approved.py
#     --export), and runs scripts/check-product.sh on the result.
#   <target> is either a new or empty folder, or a clone of the public
#   repository. In a clone, every file except .git/ is replaced by the
#   export and staged with `git add -A`, so `git status` shows exactly what
#   the release changes. The script never commits or pushes: a person reads
#   the result first, then commits it as one commit for the release.
#
# WHY: the public repository holds the finished product (languages/, the
#   reader docs/, site/, scripts/), one commit per release and no other
#   history. An allowlist means a file is published only when it is listed
#   on purpose; anything else in this repository stays here.
#   `git archive` reads committed files only, so uncommitted changes and
#   ignored build output can never be exported.
#   Reference: https://git-scm.com/docs/git-archive
#
# USAGE:
#   scripts/export-public.sh --dry-run                  # list what HEAD would export
#   scripts/export-public.sh --dry-run --ref v2.0.0     # ... at a tag
#   scripts/export-public.sh ../public-export           # export HEAD into a folder
#   scripts/export-public.sh --ref v2.0.0 ../hello-world-public   # into a clone
# Then, in a clone:
#   git -C ../hello-world-public commit -m "release v2.0.0"

set -eu
cd -- "$(dirname -- "$0")/.."
. ./scripts/common.sh

REF=HEAD
DRY_RUN=0
TARGET=
while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        --ref) [ $# -ge 2 ] || fail "--ref needs a commit or tag."; REF=$2; shift ;;
        -*) fail "Unknown option: $1 (use --dry-run or --ref <commit>)" ;;
        *) [ -z "$TARGET" ] || fail "Give only one target folder."; TARGET=$1 ;;
    esac
    shift
done
[ "$DRY_RUN" = 1 ] || [ -n "$TARGET" ] || fail "Give a target folder, or use --dry-run."

require_cmd git "git is needed to read the committed files."
require_cmd python3 "Install Python 3 from https://www.python.org/downloads/."
git rev-parse --verify --quiet "$REF^{commit}" >/dev/null || fail "Not a commit or tag: $REF"

# The allowlist, without comments and blank lines.
PATHS=$(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' scripts/public-paths.txt)

if [ "$DRY_RUN" = 1 ]; then
    step "Files that $REF would publish (dry run, nothing is written)"
    # shellcheck disable=SC2086  # one pathspec per word is intended
    git ls-tree -r --name-only "$REF" -- $PATHS
    # shellcheck disable=SC2086
    explain "$(git ls-tree -r --name-only "$REF" -- $PATHS | wc -l | tr -d ' ') files from: $(echo $PATHS)"
    exit 0
fi

step "Preparing $TARGET"
if [ -d "$TARGET/.git" ]; then
    explain "A git clone: its files are replaced by the export; .git/ (the history) is kept."
    find "$TARGET" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
elif [ -d "$TARGET" ] && [ -n "$(ls -A "$TARGET")" ]; then
    fail "$TARGET is not empty and not a git clone; refusing to delete its files."
else
    mkdir -p "$TARGET"
fi

step "Exporting $REF"
explain "git archive packs only committed files under the allowlisted paths."
# shellcheck disable=SC2086
git archive --format=tar "$REF" -- $PATHS | tar -x -f - -C "$TARGET"
ok "$(find "$TARGET" -type f ! -path "$TARGET/.git/*" | wc -l | tr -d ' ') files written to $TARGET"

python3 scripts/approved.py --export "$TARGET" ||
    fail "The export misses an approved language or category (listed above)."

scripts/check-product.sh "$TARGET"

if [ -d "$TARGET/.git" ]; then
    git -C "$TARGET" add -A
    step "Changes staged in $TARGET (not committed)"
    git -C "$TARGET" status --short
    explain "Read the changes, then commit them as one release commit:"
    explain "  git -C $TARGET commit -m \"release <version>\""
fi
