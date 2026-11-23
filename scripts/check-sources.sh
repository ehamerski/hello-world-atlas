#!/bin/sh
# scripts/check-sources.sh - request every external URL cited in the
# published files and report the ones that do not answer.
#
# WHAT: collects every http(s) URL from the Markdown, YAML, shell and site
#   files git knows (tracked, or new and not ignored), asks each server for
#   it with curl, and prints a summary. A URL counts as good when the final
#   status is 2xx after redirects. If the first try fails, it is retried
#   once with a browser User-Agent, because some sites refuse the default
#   curl one. HTTP 429 means "too many requests": the page probably exists,
#   so it is listed as "retry later" and does not fail the run. HTTP 401, 403
#   and 999 from a site that serves browsers (publishers and registries that
#   block robots) are listed for a manual check and do not fail the run.
#
# WHY: every cited source must still say what our text claims (a dead link
#   is a lost citation). Sites move and reorganise, so this is run before a
#   release. It needs the network and takes several minutes, so
#   scripts/check-links.sh does NOT call it.
#
# HOW:
#   scripts/check-sources.sh               # every URL in every published file
#   scripts/check-sources.sh languages/dart   # only files under these paths
#   TF_SOURCES_JOBS=8 scripts/check-sources.sh   # parallel requests (default 8)
# Exit code 0 = no failing URL, 1 = at least one failing URL.
# Files with example, placeholder or local-only URLs are skipped: see the
# filters below.

set -u
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh

require_cmd curl "curl is needed to request the URLs"

JOBS=${TF_SOURCES_JOBS:-8}
UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'
TMP=$(mktemp -d "${TMPDIR:-/tmp}/check-sources.XXXXXX") || exit 1
trap 'rm -rf "$TMP"' EXIT INT TERM

# --------------------------------------------------------------- collect ---
step "Collecting URLs"
explain "Why: the list is built from the same files a reader sees, so a dead"
explain "link anywhere in them is found."
# Without arguments: the published paths (scripts/public-paths.txt), the
# files a reader sees.
if [ "$#" -gt 0 ]; then
    paths="$*"
else
    paths=$(sed -e 's/#.*//' -e '/^[[:space:]]*$/d' scripts/public-paths.txt)
fi
# i18n/ repeats the URLs of the English files, which are checked instead.
# Lockfiles and vendored folders hold registry URLs that are not citations.
# shellcheck disable=SC2086
git ls-files -co --exclude-standard -- $paths 2>/dev/null |
    grep -E '\.(md|yml|yaml|sh|mjs|astro|ts|cff)$' |
    grep -v -E '^(i18n/|scripts/check-sources\.sh|\.github/|\.vale/)|node_modules/|package-lock' |
    while IFS= read -r f; do
        [ -f "$f" ] && grep -E -o 'https?://[^] <>"'"'"'`)}\\,;|]+' "$f" |
            sed -e 's/[.:!?*_]*$//' -e 's/&amp$//' |
            awk -v f="$f" '{ print $0 "\t" f }'
    done |
    # Keep only URLs with a real host name; this drops "https://" and
    # "http://x" fragments found in prose and code.
    grep -E '^https?://[A-Za-z0-9][A-Za-z0-9-]*(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}(:[0-9]+)?([/?#]|\t)' |
    # Skip example and template placeholder URLs, and base URLs that a
    # script or text completes before use (a download folder, an apt
    # repository, a default repository address).
    grep -v -E '^https?://([^/]*\.)?example\.(com|org|net)|[{}<$]' |
    grep -v -E '^https://(dl\.google\.com/android/repository|storage\.googleapis\.com/download\.dartlang\.org/linux/debian|github\.com/ehamerski/hello-world-atlas/blob/main)\t' |
    sort -u > "$TMP/pairs"
cut -f1 "$TMP/pairs" | sort -u > "$TMP/urls"
total=$(wc -l < "$TMP/urls" | tr -d ' ')
ok "$total distinct URLs in $(cut -f2 "$TMP/pairs" | sort -u | wc -l | tr -d ' ') files"

# --------------------------------------------------------------- request ---
step "Requesting every URL ($JOBS at a time)"
explain "Why: a 2xx answer after redirects means the page still exists."
# Hand the function to xargs through a small helper script so it also runs
# under /bin/sh on macOS and Linux.
cat > "$TMP/probe.sh" <<PROBE
#!/bin/sh
UA='$UA'
url=\$1
code=\$(curl -s -o /dev/null -L -m 30 -w '%{http_code}' "\$url" 2>/dev/null)
case "\$code" in
    2??) ;;
    *) code=\$(curl -s -o /dev/null -L -m 30 -A "\$UA" -w '%{http_code}' "\$url" 2>/dev/null) ;;
esac
# 000 = no answer at all (timeout, reset). Servers are sometimes slow, so
# wait and ask once more before calling it a failure.
if [ "\$code" = 000 ]; then
    sleep 5
    code=\$(curl -s -o /dev/null -L -m 45 -A "\$UA" -w '%{http_code}' "\$url" 2>/dev/null)
fi
printf '%s %s\n' "\$code" "\$url"
PROBE
chmod +x "$TMP/probe.sh"
tr '\n' '\0' < "$TMP/urls" | xargs -0 -n 1 -P "$JOBS" "$TMP/probe.sh" > "$TMP/results"

# --------------------------------------------------------------- summary ---
step "Summary"
good=$(grep -c -E '^2[0-9][0-9] ' "$TMP/results")
later=$(grep -c -E '^429 ' "$TMP/results")
grep -E '^(401|403|999) ' "$TMP/results" | sort -k2 > "$TMP/blocked"
blocked=$(wc -l < "$TMP/blocked" | tr -d ' ')
grep -v -E '^(2[0-9][0-9]|429|401|403|999) ' "$TMP/results" | sort -k2 > "$TMP/bad"
bad=$(wc -l < "$TMP/bad" | tr -d ' ')
explain "answered 2xx : $good"
explain "retry later (429) : $later"
explain "refused robots (401/403/999) : $blocked"
explain "failed : $bad"

if [ "$later" -gt 0 ]; then
    warn "429 - the server is rate-limiting; run again later for these:"
    grep -E '^429 ' "$TMP/results" | sort -k2 | sed 's/^/    /'
fi
if [ "$blocked" -gt 0 ]; then
    warn "These sites refuse robots even with a browser User-Agent. Open them in a browser; they are not counted as failures:"
    sed 's/^/    /' "$TMP/blocked"
fi
if [ "$bad" -gt 0 ]; then
    printf '%s[error]%s These URLs did not answer 2xx (000 = unreachable), with the files citing them:\n' "$TF_RED" "$TF_RESET" >&2
    while IFS= read -r line; do
        url=${line#* }
        printf '  %s\n' "$line"
        awk -F '\t' -v u="$url" '$1 == u { print "      in " $2 }' "$TMP/pairs"
    done < "$TMP/bad"
    exit 1
fi
ok "0 failing URLs"
