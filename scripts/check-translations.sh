#!/bin/sh
# scripts/check-translations.sh - report the state of every translation.
#
# WHAT: for each locale folder i18n/<tag>/ and each English file that is
#   translated on the website, prints one line:
#     current    the translation was made from the English file as it is now
#     outdated   the English file changed after the translation was made
#     missing    no translation yet (the site shows the English page)
#   then the coverage per locale: the share of files that are *current*, in
#   total and per tier:
#     T1  Home, the reader pages in docs/ and the site's own strings
#     T2  language pages (README.md) and their meta.yml
#     T3  implementation pages, the implementations table, CONTRIBUTING.md
#   A file under i18n/<tag>/ that matches no English file is an *orphan*.
#
# HOW IT KNOWS: every translated file starts with
#     source: <path of the English file>
#     source_sha: <git blob hash of that English file>
#   (YAML front matter in Markdown; top-level keys in a .yml file).
#   The script computes the blob hash of the English file today with
#   `git hash-object` and compares. https://git-scm.com/docs/git-hash-object
#   To record the hash when translating: git hash-object <English file>
#
# WHY: English is the source of truth. When an English page changes, its
#   translation must be redone, and about 150 files cannot be tracked by hand.
#   Problems are warnings, not errors: an English change never breaks the
#   build because a translation is behind. The exit code is 0 unless the
#   script itself is used incorrectly.
#
# USAGE:
#   scripts/check-translations.sh            # every locale in i18n/
#   scripts/check-translations.sh pt-BR      # one locale
# On GitHub Actions (GITHUB_ACTIONS=true) outdated and orphan files are also
# printed as workflow warnings:
# https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-commands#setting-a-warning-message

set -eu
cd -- "$(dirname -- "$0")/.."
. ./scripts/common.sh

if [ $# -gt 1 ]; then
    echo "Usage: scripts/check-translations.sh [locale]" >&2
    exit 2
fi

# The English files the site translates, one per line, in the same set as
# site/scripts/generate.mjs: the README files, the reader pages in docs/,
# each meta.yml and the site's own strings.
english_files() {
    git ls-files --cached --others --exclude-standard -- \
        README.md CONTRIBUTING.md 'docs/*.md' 'languages/*' site/site-ui.yml |
        grep -E '^(README\.md|CONTRIBUTING\.md|docs/[^/]+\.md|languages/README\.md|languages/[^/]+/(README\.md|meta\.yml)|languages/[^/]+/[^/]+/README\.md|site/site-ui\.yml)$' |
        sort
}

# tier FILE - T1, T2 or T3 (see the header).
tier() {
    case $1 in
        README.md|docs/*|site/site-ui.yml) echo T1 ;;
        languages/README.md|CONTRIBUTING.md) echo T3 ;;
        languages/*/*/README.md) echo T3 ;;
        *) echo T2 ;;
    esac
}

# translation_of TAG FILE - where the translation of FILE lives. The site's
# strings sit at the top of the locale folder; everything else mirrors the
# repository path.
translation_of() {
    case $2 in
        site/site-ui.yml) echo "i18n/$1/site-ui.yml" ;;
        *) echo "i18n/$1/$2" ;;
    esac
}

# field FILE KEY - the value of KEY in FILE's front matter (Markdown) or top
# level (YAML), without quotes; empty if absent.
field() {
    awk -v key="$2" '
        NR == 1 && /^---[ \t]*$/ { fm = 1; next }
        fm && /^---[ \t]*$/ { exit }
        index($0, key ":") == 1 {
            v = substr($0, length(key) + 2)
            gsub(/^[ \t]+|[ \t]+$/, "", v); gsub(/^["\047]|["\047]$/, "", v)
            print v; exit
        }
        !fm && NR > 1 && /^---/ { exit }
    ' "$1"
}

annotate() {
    [ "${GITHUB_ACTIONS:-}" = true ] && printf '::warning file=%s::%s\n' "$1" "$2"
    return 0
}

percent() { [ "$2" -gt 0 ] && echo $(( $1 * 100 / $2 )) || echo 0; }

if [ $# -eq 1 ]; then
    [ -d "i18n/$1" ] || fail "No locale folder i18n/$1."
    LOCALES=$1
else
    LOCALES=$(find i18n -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort)
fi
[ -n "$LOCALES" ] || { ok "No locale folders in i18n/; nothing to check."; exit 0; }

ENGLISH=$(english_files)
for tag in $LOCALES; do
    step "Translations: $tag (English source -> i18n/$tag/)"
    total=0; current=0; outdated=0; missing=0
    t1=0; t1c=0; t2=0; t2c=0; t3=0; t3c=0
    for src in $ENGLISH; do
        dest=$(translation_of "$tag" "$src")
        t=$(tier "$src")
        total=$((total + 1))
        case $t in T1) t1=$((t1 + 1)) ;; T2) t2=$((t2 + 1)) ;; T3) t3=$((t3 + 1)) ;; esac
        if [ ! -f "$dest" ]; then
            state=missing; missing=$((missing + 1))
        else
            recorded=$(field "$dest" source_sha)
            named=$(field "$dest" source)
            [ "$named" = "$src" ] || warn "$dest: 'source: $named' should be 'source: $src'"
            if [ "$recorded" = "$(git hash-object -- "$src")" ]; then
                state=current; current=$((current + 1))
                case $t in T1) t1c=$((t1c + 1)) ;; T2) t2c=$((t2c + 1)) ;; T3) t3c=$((t3c + 1)) ;; esac
            else
                state=outdated; outdated=$((outdated + 1))
                annotate "$dest" "outdated: $src changed after this translation (source_sha ${recorded:-none})"
            fi
        fi
        printf '%-9s %s  %s\n' "$state" "$t" "$src"
    done

    # Files in the locale folder that translate nothing.
    orphans=0
    for f in $(git ls-files --cached --others --exclude-standard -- "i18n/$tag/"); do
        case $f in */.gitkeep) continue ;; esac
        rel=${f#"i18n/$tag/"}
        [ "$rel" = site-ui.yml ] && rel=site/site-ui.yml
        if ! printf '%s\n' "$ENGLISH" | grep -qxF -- "$rel"; then
            printf '%-9s %s  %s\n' orphan '--' "$f"
            annotate "$f" "orphan: no English file $rel"
            orphans=$((orphans + 1))
        fi
    done

    summary="$tag: $current of $total current ($(percent "$current" "$total")%), $outdated outdated, $missing missing, $orphans orphan"
    summary="$summary; T1 $(percent "$t1c" "$t1")%, T2 $(percent "$t2c" "$t2")%, T3 $(percent "$t3c" "$t3")%"
    if [ "$current" -eq "$total" ] && [ "$orphans" -eq 0 ]; then ok "$summary"; else warn "$summary"; fi
done
exit 0
