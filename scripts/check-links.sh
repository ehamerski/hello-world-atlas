#!/bin/sh
# scripts/check-links.sh - check that every relative link in the Markdown
# files resolves.
#
# WHAT: reads every Markdown file git knows (tracked, or new and not
#   ignored) and, for each link
#   [text](target) or reference definition [label]: target
# whose target is a relative path (not http:, https:, mailto:), checks that
#   - the file or folder exists, relative to the Markdown file, and
#   - a "#anchor" part matches a heading of the target Markdown file.
# Links inside fenced code blocks (```) are ignored: they are examples.
# A translation i18n/<tag>/<path> keeps the links of the English file <path>
# unchanged, so its links are resolved from the English file's folder
# (except "#anchor" alone, which points to its own translated headings).
# docs/templates/ is skipped: its links are written for the folder a
# template is copied to (languages/<language>/ or
# languages/<language>/<category>/), not for docs/templates itself.
# External HTTPS links are NOT fetched here; the source audit before each
# release checks them (docs/sources.md), because sites change and rate-limit
# robots.
#
# WHY: the root README lists every implementation, and every link must
# resolve. With 47 implementations and about 70 README files, a moved folder
# or a renamed heading is easy to miss in a manual review.
#
# HOW: POSIX sh + awk only, so it runs wherever the other scripts run.
#   scripts/check-links.sh               # every tracked *.md file
#   scripts/check-links.sh README.md docs   # only these files / folders
# Exit code 0 = no broken links, 1 = at least one broken link.
#
# Anchors follow GitHub's rule for heading IDs: lowercase, drop
# punctuation, spaces become "-", a repeated heading gets "-1", "-2", ...
# Reference: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#section-links

set -u
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh

# links FILE - print "target" for every relative link in FILE, one per line.
links() {
    awk '
        BEGIN { after_blank = 1 }
        /^[ \t]*(```|~~~)/ { fence = !fence; next }
        fence { next }
        {
            line = $0
            # [label]: target  (reference definition). It cannot interrupt
            # a paragraph, so only a line after a blank line (or another
            # definition) counts; "... [3]: it is" inside prose does not.
            if (after_blank && match(line, /^ ? ? ?\[[^\]]+\]:[ \t]+[^ \t]+/)) {
                def = substr(line, RSTART, RLENGTH)
                sub(/^[ \t]*\[[^\]]+\]:[ \t]+/, "", def)
                print def
                after_blank = 1; next
            }
            after_blank = (line ~ /^[ \t]*$/)
            # Inline code can show link syntax as an example: drop it.
            gsub(/`[^`]*`/, "", line)
            # [text](target "optional title")
            while (match(line, /\]\([^)]*\)/)) {
                t = substr(line, RSTART + 2, RLENGTH - 3)
                line = substr(line, RSTART + RLENGTH)
                sub(/[ \t].*$/, "", t)
                gsub(/^<|>$/, "", t)
                print t
            }
        }
    ' "$1" | grep -v -E '^(https?:|mailto:|$)' || true
}

# anchors FILE - print the GitHub heading id of every heading in FILE.
# LC_ALL=C makes awk work on bytes, so the octal UTF-8 sequences below match.
anchors() {
    LC_ALL=C awk '
        /^[ \t]*(```|~~~)/ { fence = !fence; next }
        fence { next }
        /^#+[ \t]/ {
            h = $0
            sub(/^#+[ \t]+/, "", h); sub(/[ \t]+#*[ \t]*$/, "", h)
            gsub(/\]\([^)]*\)/, "]", h)        # [text](url) -> text
            h = tolower(h)
            # Common non-ASCII punctuation (UTF-8 bytes): · — – ’ “ ” → ✅ 📄
            gsub(/\302\267|\342\200\224|\342\200\223|\342\200\231|\342\200\234|\342\200\235|\342\206\222|\342\234\205|\360\237\223\204/, "", h)
            # Keep letters, digits, space, "-", "_" and other non-ASCII bytes.
            gsub(/[^a-z0-9 _\200-\377-]/, "", h)
            gsub(/ /, "-", h)
            n = seen[h]++
            print (n ? h "-" n : h)
        }
        # <a id="x"> / <a name="x"> anchors written by hand.
        {
            line = $0
            while (match(line, /<a (id|name)="[^"]+"/)) {
                a = substr(line, RSTART, RLENGTH)
                sub(/^<a (id|name)="/, "", a); sub(/"$/, "", a)
                print a
                line = substr(line, RSTART + RLENGTH)
            }
        }
    ' "$1"
}

step "Checking relative links in Markdown files"
explain "Each [text](path#anchor) must point to an existing file and heading."

if [ $# -eq 0 ]; then
    set -- .
fi
FILES=$(git ls-files --cached --others --exclude-standard -- "$@" | grep '\.md$' | grep -v '^docs/templates/')

CHECKED=0; BROKEN=0
for md in $FILES; do
    dir=$(dirname -- "$md")
    case $md in i18n/*/*) src=${md#i18n/*/}; dir=$(dirname -- "$src") ;; esac
    for target in $(links "$md"); do
        CHECKED=$((CHECKED + 1))
        path=${target%%#*}
        anchor=''
        case $target in *'#'*) anchor=${target#*#} ;; esac
        # "#anchor" alone points into the same file.
        if [ -z "$path" ]; then dest=$md; else dest=$dir/$path; fi
        if [ ! -e "$dest" ]; then
            printf '%s[broken]%s %s -> %s (no such file)\n' "$TF_RED" "$TF_RESET" "$md" "$target"
            BROKEN=$((BROKEN + 1)); continue
        fi
        if [ -n "$anchor" ] && [ -f "$dest" ]; then
            case $dest in *.md) ;; *) continue ;; esac
            anchors "$dest" | grep -qxF -- "$anchor" || {
                printf '%s[broken]%s %s -> %s (no such heading)\n' "$TF_RED" "$TF_RESET" "$md" "$target"
                BROKEN=$((BROKEN + 1))
            }
        fi
    done
done

step "Summary: $CHECKED relative links checked, $BROKEN broken"
[ "$BROKEN" -eq 0 ]
