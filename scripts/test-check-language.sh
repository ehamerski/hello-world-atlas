#!/bin/sh
# scripts/test-check-language.sh - fixture tests for scripts/check-language.sh.
#
# WHAT: copies the repository (the files git knows) into a temporary
#   folder, breaks languages/python/ in one way, and checks that
#   check-language.sh fails with the expected message. The cases:
#   - meta.yml has no humor.line;
#   - a folder listed under categories does not exist;
#   - the main source file has an extension the site does not know;
#   - meta.yml changed, but the generated README tables were not rebuilt;
#   - meta.yml changed a status, but the README implementations table
#     still shows the old one;
#   - another language (zig) was deleted, although languages/APPROVED.txt
#     lists it.
#   The unchanged copy must pass, so a failure comes from the break alone.
#
# WHY: a check that never fails proves nothing. These cases show that each
#   kind of incomplete language is caught.
#
# USAGE: scripts/test-check-language.sh   (exit code 1 if a case is wrong)
# NEEDS: what check-language.sh needs (site/node_modules and Vale).

set -eu
cd -- "$(dirname -- "$0")/.."
ROOT=$(pwd)
. ./scripts/common.sh

[ -d site/node_modules ] || fail "The site's npm packages are missing. Run: (cd site && npm ci)"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/check-language-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT INT TERM

# fixture - a fresh copy of the repository in $TMP/repo, as a git
# repository (the checks list files with git). site/node_modules is linked,
# not copied: nothing here installs packages into it.
fixture() {
    rm -rf "$TMP/repo"
    mkdir "$TMP/repo"
    git ls-files -z --cached --others --exclude-standard | xargs -0 tar -cf - | tar -xf - -C "$TMP/repo"
    ln -s "$ROOT/site/node_modules" "$TMP/repo/site/node_modules"
    (cd "$TMP/repo" && git init -q && git add -A)
}

FAILED=0
# expect_fail "case" "expected message" - run the check on the fixture; it
# must fail and print the message. Run after the fixture was broken.
expect_fail() {
    (cd "$TMP/repo" && git add -A)
    if out=$(NO_COLOR=1 "$TMP/repo/scripts/check-language.sh" python 2>&1); then
        warn "$1: check-language.sh passed, but it should fail"
        FAILED=$((FAILED + 1))
    elif printf '%s\n' "$out" | grep -F -q -- "$2"; then
        ok "$1"
        explain "(expected) $(printf '%s\n' "$out" | grep -F -- "$2" | head -n 1)"
    else
        printf '%s\n' "$out"
        warn "$1: it failed, but without the message: $2"
        FAILED=$((FAILED + 1))
    fi
}

step "The unchanged copy passes"
fixture
if NO_COLOR=1 "$TMP/repo/scripts/check-language.sh" python >"$TMP/out" 2>&1; then
    ok "unchanged languages/python/ passes"
else
    cat "$TMP/out"
    fail "The unchanged copy fails, so the cases below would prove nothing."
fi

step "A missing humor.line fails"
fixture
sed '/^  line: /d' languages/python/meta.yml >"$TMP/repo/languages/python/meta.yml"
expect_fail "missing humor.line" "(humor): missing key line"

step "A missing category folder fails"
fixture
rm -r "$TMP/repo/languages/python/cli"
expect_fail "missing category folder" "languages/python/cli/README.md does not exist"

step "An unknown main-file extension fails"
fixture
mv "$TMP/repo/languages/python/cli/hello.py" "$TMP/repo/languages/python/cli/hello.xyz"
expect_fail "unknown main-file extension" "no comment syntax for hello.xyz"

step "A stale generated README fails"
fixture
sed 's/^year: 1991$/year: 1990/' languages/python/meta.yml >"$TMP/repo/languages/python/meta.yml"
expect_fail "stale generated README" "README.md is out of date"

step "A README implementations table that differs from meta.yml fails"
fixture
sed 's/| ✅ |$/| ⚠️ |/' languages/python/README.md >"$TMP/repo/languages/python/README.md"
expect_fail "stale implementations table" "cli: status '⚠️', meta.yml gives '✅'"

step "A deleted language fails, even when another language is checked"
fixture
rm -r "$TMP/repo/languages/zig"
expect_fail "deleted language" "languages/zig/meta.yml is missing, but zig is listed in languages/APPROVED.txt"

[ "$FAILED" -eq 0 ] || fail "$FAILED case(s) wrong."
step "Done"
ok "All cases behave as expected."
