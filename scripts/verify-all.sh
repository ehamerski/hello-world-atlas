#!/bin/sh
# scripts/verify-all.sh - run every implementation and report pass/fail.
#
# WHAT: finds every languages/<language>/<category>/run.sh and, for each
#   folder, runs
#   install.sh  -> check that the toolchain is present (never installs: the
#                  script runs with TF_NONINTERACTIVE=1, so it only reports)
#   build.sh    -> compile, only if the folder has one
#   run.sh --verify -> run the program; CLI programs print, web and
#                  desktop programs check themselves and exit
# An implementation PASSES when all steps exit with code 0 and the output of
# run.sh contains "Hello, World!".
# Folders with a README.md but no run.sh (documented only, for example
# languages/pseudocode/clrs) are listed as skipped.
#
# WHY: this is the project's local continuous integration (CI) check. It
# must pass before any change is merged, so earlier work keeps running.
#
# USAGE:
#   scripts/verify-all.sh                 # every implementation
#   scripts/verify-all.sh python java/web # only these folders; the
#                                         # languages/ prefix is optional
#   TF_VERIFY_TIMEOUT=600 scripts/verify-all.sh   # seconds per step (default 300)
#
# Logs of each step are written to .verify/<language>-<category>.log
# (ignored by git).

set -u

# Work from the repository root, wherever the script is called from.
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh

TIMEOUT=${TF_VERIFY_TIMEOUT:-300}
EXPECTED='Hello, World!'
LOG_DIR=.verify

# run_with_timeout SECONDS CMD... - POSIX sh has no `timeout` command (macOS
# does not ship GNU coreutils), so start CMD in the background and kill it
# if it is still running after SECONDS. The watcher sleeps 1 second at a
# time, so at most one short `sleep 1` outlives it.
# Note: on timeout only CMD itself is killed; a run.sh that starts a server
# must stop it with `trap` (see docs/templates/impl/run.sh).
run_with_timeout() {
    rt_secs=$1; shift
    "$@" &
    rt_pid=$!
    (
        while [ "$rt_secs" -gt 0 ] && kill -0 "$rt_pid" 2>/dev/null; do
            sleep 1; rt_secs=$((rt_secs - 1))
        done
        if [ "$rt_secs" -eq 0 ] && kill "$rt_pid" 2>/dev/null; then
            echo "### timed out: killed after ${TIMEOUT}s" >&2
        fi
    ) &
    rt_watch=$!
    wait "$rt_pid"
    rt_rc=$?
    # Stop the watcher now instead of letting it notice on its next tick.
    kill "$rt_watch" 2>/dev/null
    wait "$rt_watch" 2>/dev/null
    return "$rt_rc"
}

# with_prefix [PATH...] - print each PATH, adding "languages/" when PATH
# does not exist as given but does below languages/ (so "python/cli" and
# "languages/python/cli" both work). No PATH means all of languages/.
with_prefix() {
    if [ $# -eq 0 ]; then set -- languages; fi
    for wp_path in "$@"; do
        wp_path=${wp_path%/}
        if [ ! -e "$wp_path" ] && [ -e "languages/$wp_path" ]; then
            wp_path=languages/$wp_path
        fi
        echo "$wp_path"
    done
}

# list_impls [PATH...] - print every folder that has a run.sh, at
# languages/<language>/<category>, sorted. Paths come from with_prefix, one
# per line (no implementation folder has a space in its name).
list_impls() {
    for li_path in $(with_prefix "$@"); do
        find "$li_path" -name run.sh -type f -not -path '*/node_modules/*'
    done | sed 's|^\./||; s|/run\.sh$||' \
         | awk -F/ 'NF == 3 && $1 == "languages"' \
         | sort -u
}

# list_documented_only [PATH...] - languages/<language>/<variant> folders
# that have a README.md but no run.sh (for example pseudocode/clrs: no
# interpreter exists). They are listed as skipped, so they are never
# silently missed.
list_documented_only() {
    for ld_path in $(with_prefix "$@"); do
        find "$ld_path" -name README.md -type f -not -path '*/node_modules/*'
    done | sed 's|^\./||; s|/README\.md$||' \
         | awk -F/ 'NF == 3 && $1 == "languages"' \
         | sort -u | while read -r ld_dir; do
               [ -f "$ld_dir/run.sh" ] || echo "$ld_dir"
           done
}

# verify_one DIR LOG - run the three steps of one implementation.
verify_one() {
    vo_dir=$1; vo_log=$2
    for vo_script in install.sh build.sh run.sh; do
        [ -f "$vo_dir/$vo_script" ] || {
            # build.sh is optional (interpreted languages have nothing to build).
            [ "$vo_script" = build.sh ] && continue
            echo "missing $vo_script" >>"$vo_log"; return 1
        }
        [ -x "$vo_dir/$vo_script" ] || {
            echo "$vo_script is not executable (chmod +x)" >>"$vo_log"; return 1
        }
        vo_args=''
        [ "$vo_script" = run.sh ] && vo_args=--verify
        echo "### $vo_script $vo_args" >>"$vo_log"
        # shellcheck disable=SC2086  # vo_args is empty or a single word
        ( cd -- "$vo_dir" && TF_NONINTERACTIVE=1 NO_COLOR=1 \
            run_with_timeout "$TIMEOUT" ./$vo_script $vo_args ) >>"$vo_log" 2>&1 || {
            echo "### $vo_script failed (exit $?)" >>"$vo_log"; return 1
        }
    done
    # The run.sh section of the log must contain the expected greeting.
    sed -n '/^### run\.sh/,$p' "$vo_log" | grep -qF "$EXPECTED" || {
        echo "### run.sh output does not contain '$EXPECTED'" >>"$vo_log"; return 1
    }
}

step "Verifying implementations (timeout ${TIMEOUT}s per step, OS: $TF_OS)"
explain "Each folder runs install.sh (check only), build.sh (if any) and run.sh --verify."

IMPLS=$(list_impls "$@")
if [ -z "$IMPLS" ]; then
    ok "No implementations found yet. Nothing to verify."
    exit 0
fi

mkdir -p "$LOG_DIR"
PASSED=0; FAILED=0; FAILED_LIST=''
for dir in $IMPLS; do
    log="$LOG_DIR/$(echo "${dir#languages/}" | tr / -).log"
    : >"$log"
    if verify_one "$dir" "$log"; then
        ok "$dir"
        PASSED=$((PASSED + 1))
    else
        printf '%s[FAIL]%s %s  (see %s)\n' "$TF_RED" "$TF_RESET" "$dir" "$log"
        FAILED=$((FAILED + 1)); FAILED_LIST="$FAILED_LIST $dir"
    fi
done

SKIPPED=0
for dir in $(list_documented_only "$@"); do
    explain "[SKIP] $dir  (documented only: README, no run.sh)"
    SKIPPED=$((SKIPPED + 1))
done

step "Summary: $PASSED passed, $FAILED failed, $SKIPPED documented only"
if [ "$FAILED" -gt 0 ]; then
    explain "Failed:$FAILED_LIST"
    exit 1
fi
exit 0
