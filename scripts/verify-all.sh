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
#   scripts/verify-all.sh --install c     # let install.sh install what is
#                                         # missing, without asking (CI)
#
# --install runs install.sh with TF_ASSUME_YES=1 instead of
# TF_NONINTERACTIVE=1, so it installs missing toolchains unattended. It is
# meant for throwaway machines such as the GitHub Actions runners of
# .github/workflows/ci-matrix.yml; on your own computer, run install.sh
# yourself so you can read each command before it runs.
#
# A folder whose cold step legitimately takes longer than the default is
# listed in ci/timeouts.yml with its own limit and the reason; every other
# folder keeps the default. A step that hangs still fails, just later.
#
# Folders listed for the current OS in ci/skip.yml are not run. Each one is
# printed as [SKIP] with the reason from that file, so nothing is skipped
# silently.
#
# Each implementation gets its own free PORT and FE_PORT (from 18000, change
# with TF_VERIFY_PORT_BASE), and whatever it leaves running is stopped right
# after it, and again when this script exits for any reason.
#
# Logs of each step are written to .verify/<language>-<category>.log
# (ignored by git). If a run is interrupted, scripts/stop-all.sh stops what
# it left running.

set -u

# Work from the repository root, wherever the script is called from.
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh

INSTALL=0
if [ "${1:-}" = --install ]; then INSTALL=1; shift; fi

TIMEOUT=${TF_VERIFY_TIMEOUT:-300}
SKIP_FILE=ci/skip.yml
TIMEOUT_FILE=ci/timeouts.yml
EXPECTED='Hello, World!'
LOG_DIR=.verify

# run_with_timeout SECONDS CMD... - POSIX sh has no `timeout` command (macOS
# does not ship GNU coreutils), so start CMD in the background and kill it
# if it is still running after SECONDS. The watcher sleeps 1 second at a
# time, so at most one short `sleep 1` outlives it.
# Note: on timeout only CMD itself is killed; a run.sh that starts a server
# must stop it with `trap` (see docs/templates/impl/run.sh).
run_with_timeout() {
    rt_secs=$1; rt_total=$1; shift
    "$@" &
    rt_pid=$!
    (
        while [ "$rt_secs" -gt 0 ] && kill -0 "$rt_pid" 2>/dev/null; do
            sleep 1; rt_secs=$((rt_secs - 1))
        done
        if [ "$rt_secs" -eq 0 ] && kill "$rt_pid" 2>/dev/null; then
            echo "### timed out: killed after ${rt_total}s" >&2
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

# skip_reason DIR - print the reason when ci/skip.yml lists DIR for this OS
# (or for "all"), and nothing otherwise. Each entry of that file is a block
# of "key: value" lines starting with "- folder:", so awk can read it
# without a YAML library. macos-intel and macos-arm both match "macos".
skip_reason() {
    [ -f "$SKIP_FILE" ] || return 0
    awk -v dir="$1" -v os="${TF_OS%%-*}" '
        function val(line) {
            sub(/^[^:]*:[ \t]*/, "", line); gsub(/^"|"$/, "", line); return line
        }
        function check() {
            if (f == dir && (o == os || o == "all")) { print r; found = 1; exit }
        }
        /^[ \t]*- folder:/ { check(); f = val($0); o = ""; r = "" }
        /^[ \t]*os:/       { o = val($0) }
        /^[ \t]*reason:/   { r = val($0) }
        END { if (!found) check() }
    ' "$SKIP_FILE"
}

# step_timeout DIR - print the seconds each step of DIR may take: the value
# from ci/timeouts.yml (same "- folder:" block format as ci/skip.yml, keys
# folder and seconds), or the default TIMEOUT when DIR is not listed.
step_timeout() {
    st_val=''
    [ -f "$TIMEOUT_FILE" ] && st_val=$(awk -v dir="$1" '
        function val(line) { sub(/^[^:]*:[ \t]*/, "", line); gsub(/^"|"$/, "", line); return line }
        /^[ \t]*- folder:/ { f = val($0) }
        /^[ \t]*seconds:/  { if (f == dir) { print val($0); exit } }
    ' "$TIMEOUT_FILE")
    echo "${st_val:-$TIMEOUT}"
}

# port_in_use PORT - true when something already listens on TCP PORT.
port_in_use() {
    has_cmd lsof && lsof -nP -iTCP:"$1" -sTCP:LISTEN >/dev/null 2>&1
}

# NEXT_PORT is the next candidate for pick_ports. verify-all.sh uses its own
# range (18000 and up) instead of the 8080 default of the run.sh scripts, so
# a server you started by hand on 8080 cannot make a verification fail.
NEXT_PORT=${TF_VERIFY_PORT_BASE:-18000}

# pick_ports - choose a free PORT and FE_PORT for the next implementation
# (every implementation gets its own pair, so one cannot collide with
# another, even if a previous one leaked a process).
pick_ports() {
    pp_found=''
    while [ "$(echo "$pp_found" | wc -w | tr -d ' ')" -lt 2 ]; do
        port_in_use "$NEXT_PORT" || pp_found="$pp_found $NEXT_PORT"
        NEXT_PORT=$((NEXT_PORT + 1))
    done
    # shellcheck disable=SC2086  # two words
    set -- $pp_found
    PORT=$1; FE_PORT=$2
    export PORT FE_PORT
}

# cleanup_impl DIR - stop whatever the implementation left running: the
# listeners on its two ports (they are unique to this implementation) and
# every process started from its folder (scripts/stop-all.sh).
cleanup_impl() {
    if has_cmd lsof; then
        # shellcheck disable=SC2046  # one PID per word
        co_pids=$(lsof -t -nP -iTCP:"$PORT" -iTCP:"$FE_PORT" -sTCP:LISTEN 2>/dev/null | sort -u)
        # shellcheck disable=SC2086
        [ -n "$co_pids" ] && { kill $co_pids 2>/dev/null; sleep 1; kill -9 $co_pids 2>/dev/null; }
    fi
    ./scripts/stop-all.sh --yes "${1#languages/}" >/dev/null 2>&1
    return 0
}

# cleanup_all - runs on every exit (also Ctrl+C or a kill): nothing started
# by this script stays running.
# Only the implementation that was running is stopped, so a server you
# started by hand in another folder is left alone.
CURRENT_DIR=''
cleanup_all() {
    trap '' INT TERM HUP
    [ -n "$CURRENT_DIR" ] && cleanup_impl "$CURRENT_DIR"
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
        # Check only (TF_NONINTERACTIVE=1), or install unattended with
        # --install (TF_ASSUME_YES=1). build.sh and run.sh install nothing.
        vo_mode=TF_NONINTERACTIVE=1
        [ "$INSTALL" = 1 ] && [ "$vo_script" = install.sh ] && vo_mode=TF_ASSUME_YES=1
        # Read the limit here: the subshell below runs inside the folder, where
        # the relative path of ci/timeouts.yml does not exist.
        vo_timeout=$(step_timeout "$vo_dir")
        echo "### $vo_script $vo_args" >>"$vo_log"
        # shellcheck disable=SC2086  # vo_args is empty or a single word
        ( cd -- "$vo_dir" && export NO_COLOR=1 "${vo_mode?}" &&
            run_with_timeout "$vo_timeout" ./$vo_script $vo_args ) >>"$vo_log" 2>&1 || {
            echo "### $vo_script failed (exit $?)" >>"$vo_log"; return 1
        }
    done
    # The run.sh section of the log must contain the expected greeting.
    sed -n '/^### run\.sh/,$p' "$vo_log" | grep -qF "$EXPECTED" || {
        echo "### run.sh output does not contain '$EXPECTED'" >>"$vo_log"; return 1
    }
}

step "Verifying implementations (timeout ${TIMEOUT}s per step, OS: $TF_OS)"
[ "$INSTALL" = 1 ] && explain "--install: install.sh installs missing toolchains without asking."
explain "Each folder runs install.sh (check only), build.sh (if any) and run.sh --verify."

IMPLS=$(list_impls "$@")
if [ -z "$IMPLS" ]; then
    ok "No implementations found yet. Nothing to verify."
    exit 0
fi

mkdir -p "$LOG_DIR"
trap cleanup_all EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP
PASSED=0; FAILED=0; FAILED_LIST=''; OS_SKIPPED=0
for dir in $IMPLS; do
    reason=$(skip_reason "$dir")
    if [ -n "$reason" ]; then
        printf '%s[SKIP]%s %s  (%s: %s)\n' "$TF_YELLOW" "$TF_RESET" "$dir" "$SKIP_FILE" "$reason"
        OS_SKIPPED=$((OS_SKIPPED + 1))
        continue
    fi
    log="$LOG_DIR/$(echo "${dir#languages/}" | tr / -).log"
    : >"$log"
    CURRENT_DIR=$dir
    pick_ports
    echo "### ports: PORT=$PORT FE_PORT=$FE_PORT" >>"$log"
    verify_one "$dir" "$log"; vr=$?
    cleanup_impl "$dir"; CURRENT_DIR=''
    if [ "$vr" = 0 ]; then
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

step "Summary: $PASSED passed, $FAILED failed, $OS_SKIPPED skipped on $TF_OS, $SKIPPED documented only"
if [ "$FAILED" -gt 0 ]; then
    explain "Failed:$FAILED_LIST"
    exit 1
fi
exit 0
