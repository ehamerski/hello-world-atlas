#!/bin/sh
# scripts/package-downloads.sh - make one ZIP per implementation.
#
# WHAT: for every implementation folder languages/<language>/<category>/
#   (a folder with a README.md), writes
#     <out>/hello-world-<language>-<category>.zip
#   that holds, under a top folder hello-world-<language>-<category>/:
#     languages/<language>/<category>/   the implementation
#     scripts/common.sh                  the helpers its scripts source
#     LICENSE
#   and a <out>/SHA256SUMS file with the checksum of every ZIP.
#   The paths are the same as in the repository, so the scripts' relative
#   `. ../../../scripts/common.sh` works after unzipping.
#
# WHY: a student downloads one example and runs
#   install.sh -> build.sh -> run.sh, without cloning the whole repository.
#   The ZIP must hold no compilers, dependencies, or build output.
#
# HOW: `git archive` packs only the files git tracks, at a commit, so build
#   output (node_modules/, target/, .venv/, ...) can never get in. Because
#   every file gets the commit's time, the same commit always gives the same
#   ZIP bytes and the same SHA256SUMS.
#   Reference: https://git-scm.com/docs/git-archive
#
# USAGE:
#   scripts/package-downloads.sh                    # into site/public/downloads
#   scripts/package-downloads.sh dist/downloads     # into another folder
#   REF=v1.0.0 scripts/package-downloads.sh         # from another commit or tag
# The ZIPs are build output: they are git-ignored and never committed.

set -eu
cd -- "$(dirname -- "$0")/.."
. ./scripts/common.sh

OUT=${1:-site/public/downloads}
REF=${REF:-HEAD}

step "Packaging every implementation at $REF into $OUT"
explain "Only committed files are packed. Uncommitted changes are not in the ZIPs."
require_cmd git "git is needed to read the committed files."

# sha256 FILE... - print "<hash>  <file>" lines. macOS ships shasum,
# Linux (GNU coreutils) ships sha256sum; both print the same format.
if has_cmd sha256sum; then
    sha256() { sha256sum "$@"; }
elif has_cmd shasum; then
    sha256() { shasum -a 256 "$@"; }
else
    fail "Neither sha256sum nor shasum was found, so the checksums cannot be written."
fi

rm -rf "$OUT"
mkdir -p "$OUT"

# Implementation folders = languages/<language>/<category>/README.md at REF.
folders=$(git ls-tree -r --name-only "$REF" -- languages |
    sed -n 's|^\(languages/[^/]*/[^/]*\)/README\.md$|\1|p')
[ -n "$folders" ] || fail "No implementation folders found at $REF."

count=0
for dir in $folders; do
    name=$(printf '%s\n' "$dir" | sed 's|^languages/\([^/]*\)/\([^/]*\)$|hello-world-\1-\2|')
    if [ -n "$(git status --porcelain -- "$dir")" ]; then
        warn "$dir has uncommitted changes; the ZIP holds the committed version."
    fi
    git archive --format=zip --prefix="$name/" -o "$OUT/$name.zip" \
        "$REF" -- "$dir" scripts/common.sh LICENSE
    count=$((count + 1))
done

# Checksums let a student check the download: sha256sum -c SHA256SUMS
(cd "$OUT" && sha256 ./*.zip | sed 's|\./||' > SHA256SUMS)
ok "$count ZIP files and SHA256SUMS written to $OUT"
