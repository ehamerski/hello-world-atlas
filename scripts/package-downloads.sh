#!/bin/sh
# scripts/package-downloads.sh - make one ZIP per implementation.
#
# WHAT: for every implementation folder languages/<language>/<category>/
#   (a folder with a README.md), writes
#     <out>/hello-world-<language>-<category>.zip
#   that holds, under a top folder hello-world-<language>-<category>/:
#     languages/<language>/<category>/   the implementation
#     every file its scripts source      scripts/common.sh, and helpers such
#                                        as scripts/use-runner-jdk.sh or
#                                        languages/<language>/msys2-env.sh
#     languages/<language>/msys2-bin/    if the language has one
#     LICENSE, LICENSE-docs, NOTICE      the licenses (the last two only at
#                                        commits that have them)
#   and a <out>/SHA256SUMS file with the checksum of every ZIP.
#   It fails when the number of ZIPs differs from the number of categories
#   in languages/APPROVED.txt at the same commit.
#   The paths are the same as in the repository, so the scripts' relative
#   `. ../../../scripts/common.sh` and `. ../msys2-env.sh` work after
#   unzipping. The sourced files are read from the scripts' own
#   `. <path>` lines, so a new helper is packed without editing this file.
#   scripts/check-downloads.sh unpacks every ZIP and checks the result.
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

# The license files every ZIP holds. LICENSE-docs and NOTICE are newer than
# the first releases, so they are packed only when REF has them.
notices=LICENSE
for f in LICENSE-docs NOTICE; do
    if git cat-file -e "$REF:$f" 2>/dev/null; then notices="$notices $f"; fi
done

# normalize PATH - print PATH with every "." and "dir/.." removed.
normalize() {
    printf '%s\n' "$1" | awk -F/ '{
        n = 0
        for (i = 1; i <= NF; i++) {
            if ($i == "" || $i == ".") continue
            if ($i == ".." && n > 0 && part[n] != "..") { n--; continue }
            part[++n] = $i
        }
        out = part[1]
        for (i = 2; i <= n; i++) out = out "/" part[i]
        print out
    }'
}

# sourced DIR - print every file outside DIR that the scripts in DIR source
# at REF, and the files those helpers source in turn. A script runs from its
# own folder, and a helper runs in the shell that sourced it, so every
# ". <path>" line is read relative to DIR.
sourced() {
    todo=$(git ls-tree --name-only "$REF" -- "$1/" | grep '\.sh$' || true)
    seen=
    while [ -n "$todo" ]; do
        next=
        for file in $todo; do
            for rel in $(git show "$REF:$file" |
                sed -n 's|^[[:space:]]*\.[[:space:]][[:space:]]*\([^[:space:];]*\).*|\1|p'); do
                path=$(normalize "$1/$rel")
                case " $seen " in *" $path "*) continue ;; esac
                git cat-file -e "$REF:$path" 2>/dev/null ||
                    fail "$file sources $rel, but $path is not in git at $REF."
                seen="$seen $path"
                next="$next $path"
                case $path in "$1"/*) ;; *) printf '%s\n' "$path" ;; esac
            done
        done
        todo=$next
    done
}

count=0
for dir in $folders; do
    name=$(printf '%s\n' "$dir" | sed 's|^languages/\([^/]*\)/\([^/]*\)$|hello-world-\1-\2|')
    if [ -n "$(git status --porcelain -- "$dir")" ]; then
        warn "$dir has uncommitted changes; the ZIP holds the committed version."
    fi
    extra=$(sourced "$dir")
    # msys2-bin/ holds Windows-only wrappers that the language's
    # use-msys2-*.sh helper puts first on PATH; it is not sourced.
    lang=${dir%/*}
    if git cat-file -e "$REF:$lang/msys2-bin" 2>/dev/null; then
        extra="$extra $lang/msys2-bin"
    fi
    # shellcheck disable=SC2086  # $extra and $notices are lists of paths without spaces
    git archive --format=zip --prefix="$name/" -o "$OUT/$name.zip" \
        "$REF" -- "$dir" scripts/common.sh $extra $notices
    count=$((count + 1))
done

# Every approved implementation gets a ZIP, and only those. A line of
# languages/APPROVED.txt is <language> <wave> <category>..., so its
# categories are the words after the second one. Older commits have no list.
if git cat-file -e "$REF:languages/APPROVED.txt" 2>/dev/null; then
    approved=$(git show "$REF:languages/APPROVED.txt" |
        sed 's/#.*//' | awk 'NF >= 3 { n += NF - 2 } END { print n + 0 }')
    [ "$count" -eq "$approved" ] ||
        fail "$count ZIP files written, but languages/APPROVED.txt lists $approved implementations."
else
    warn "$REF has no languages/APPROVED.txt, so the number of ZIPs is not checked."
fi

# Checksums let a student check the download: sha256sum -c SHA256SUMS
(cd "$OUT" && sha256 ./*.zip | sed 's|\./||' > SHA256SUMS)
ok "$count ZIP files and SHA256SUMS written to $OUT"
