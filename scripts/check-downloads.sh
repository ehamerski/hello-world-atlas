#!/bin/sh
# scripts/check-downloads.sh - check that every download ZIP is complete.
#
# WHAT: unpacks every hello-world-*.zip and, inside each one, checks that
#   - every shell script passes `sh -n` (it parses), and
#   - every file that a script of the implementation sources
#     (`. ../../../scripts/common.sh`, `. ../msys2-env.sh`, `. ./x-env.sh`)
#     is in the ZIP, and so is every file those helpers source in turn, and
#   - when a script puts the language's msys2-bin/ folder on PATH (a line
#     of code, not a comment, that names msys2-bin), that folder is in the ZIP.
#   A script runs from its own folder and a helper runs in the shell that
#   sourced it, so every path is read relative to the implementation folder.
#
# WHY: a student downloads one ZIP and runs install.sh -> build.sh -> run.sh
#   without the rest of the repository. A helper left out of the ZIP makes
#   the first script stop with "No such file or directory".
#
# HOW: POSIX sh + unzip.
#   scripts/check-downloads.sh                        # pack every ZIP into a temporary folder, then check them
#   scripts/check-downloads.sh site/public/downloads  # check ZIPs that are already packed
# Exit code 0 = every ZIP is complete, 1 = at least one problem.

set -u
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh

require_cmd unzip "unzip is needed to unpack the ZIP files."

work=$(mktemp -d "${TMPDIR:-/tmp}/check-downloads.XXXXXX") || fail "Cannot create a temporary folder."
trap 'rm -rf "$work"' EXIT INT TERM

if [ $# -gt 0 ]; then
    zips=$1
else
    zips=$work/zips
    scripts/package-downloads.sh "$zips" || fail "scripts/package-downloads.sh failed."
fi

step "Checking every ZIP in $zips"
explain "Each ZIP is unpacked; its scripts must parse and every sourced file must be inside."

problems=0
count=0
problem() {
    printf '%s[error]%s %s\n' "$TF_RED" "$TF_RESET" "$*" >&2
    problems=$((problems + 1))
}

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

for zip in "$zips"/hello-world-*.zip; do
    [ -f "$zip" ] || fail "No hello-world-*.zip files in $zips."
    name=$(basename "$zip" .zip)
    count=$((count + 1))
    rm -rf "$work/unpacked"
    mkdir -p "$work/unpacked"
    if ! unzip -q "$zip" -d "$work/unpacked"; then
        problem "$name.zip: cannot be unpacked."
        continue
    fi
    top=$work/unpacked/$name
    if [ ! -d "$top" ]; then
        problem "$name.zip: has no top folder $name/."
        continue
    fi
    # The implementation folder is the only languages/<language>/<category>/
    # folder with a README.md.
    impl=$(cd "$top" && find languages -mindepth 3 -maxdepth 3 -name README.md | sed 's|/README\.md$||')
    if [ "$(printf '%s\n' "$impl" | grep -c .)" -ne 1 ]; then
        problem "$name.zip: expected one implementation folder, found: ${impl:-none}"
        continue
    fi

    # Every script in the ZIP parses.
    for script in $(cd "$top" && find . -name '*.sh' -type f | sed 's|^\./||'); do
        sh -n "$top/$script" 2>/dev/null || problem "$name.zip: $script does not pass sh -n."
    done

    # Every sourced file is inside, following helpers that source others.
    todo=$(cd "$top" && ls "$impl"/*.sh 2>/dev/null)
    seen=
    while [ -n "$todo" ]; do
        next=
        for file in $todo; do
            # shellcheck disable=SC2013  # one path per line, never with spaces
            for rel in $(sed -n 's|^[[:space:]]*\.[[:space:]][[:space:]]*\([^[:space:];]*\).*|\1|p' "$top/$file"); do
                path=$(normalize "$impl/$rel")
                case " $seen " in *" $path "*) continue ;; esac
                seen="$seen $path"
                if [ -f "$top/$path" ]; then
                    next="$next $path"
                else
                    problem "$name.zip: $file sources $rel, but $path is not in the ZIP."
                fi
            done
            if grep -v '^[[:space:]]*#' "$top/$file" | grep -q 'msys2-bin' &&
                [ ! -d "$top/${impl%/*}/msys2-bin" ]; then
                problem "$name.zip: $file uses msys2-bin, but ${impl%/*}/msys2-bin is not in the ZIP."
            fi
        done
        todo=$next
    done
done

if [ "$problems" -gt 0 ]; then
    fail "$problems problem(s) in $count ZIP files."
fi
ok "$count ZIP files: every script parses and every sourced file is inside."
