#!/bin/sh
# scripts/stop-all.sh - stop every process this repository started.
#
# WHAT: finds the processes that belong to the implementations of this
#   repository and stops them:
#   - a running scripts/verify-all.sh (only when no folder is given), so it
#     does not go on to the next implementation;
#   - every process whose working directory is inside a languages/<language>/
#     folder,
#     or whose command line contains the path of one: web servers left on
#     port 8080, desktop windows, dev servers (ng, vite), compilers;
#   - the background build servers of .NET (csharp), which keep running
#     after `dotnet build` on purpose (`dotnet build-server shutdown`).
#   Each process gets SIGTERM (a polite "please stop") and, if it is still
#   running 5 seconds later, SIGKILL (cannot be ignored).
#
# WHY: a web run.sh started by hand runs until Ctrl+C, and a step that
#   verify-all.sh kills on timeout can leave its children behind. This
#   script cleans them up without hunting PIDs by hand.
#
# What it does NOT stop: processes outside this repository (other projects,
#   package installs such as `brew install`, editors, terminals, AI agents
#   working at the repository root). It never uses sudo: it only stops your
#   own processes.
#
# USAGE:
#   scripts/stop-all.sh                  # list, ask, then stop everything
#   scripts/stop-all.sh python java/web  # only these folders
#   scripts/stop-all.sh --list           # only show what would be stopped
#   scripts/stop-all.sh --yes            # stop without asking (TF_ASSUME_YES=1)
#
# Platforms: macOS Intel (verified on the dev machine); Linux documented but
# NOT verified (needs `lsof`, otherwise only command lines are checked).

set -u

# Work from the repository root, wherever the script is called from.
cd -- "$(dirname -- "$0")/.." || exit 1
. ./scripts/common.sh
ROOT=$(pwd -P)
LANGS=$ROOT/languages

LIST_ONLY=0
FOLDERS=''
# shellcheck disable=SC2034  # TF_ASSUME_YES is read by confirm in common.sh
for arg in "$@"; do
    case "$arg" in
        --list) LIST_ONLY=1 ;;
        --yes|-y) TF_ASSUME_YES=1 ;;   # read by confirm in common.sh
        -h|--help) sed -n '2,/^$/s/^# \{0,1\}//p' "$0"; exit 0 ;;
        -*) fail "Unknown option: $arg (see --help)" ;;
        *)
            # A folder under languages/, given as java, java/web or
            # languages/java/web.
            dir=${arg%/}
            dir=${dir#languages/}
            case "$dir" in ''|.*|*/.*) fail "'$arg' is not a language folder." ;; esac
            [ -d "languages/$dir" ] || fail "No folder 'languages/$dir' in this repository."
            FOLDERS="$FOLDERS $LANGS/$dir"
            ;;
    esac
done

# The folders whose processes are stopped: the ones given, or every
# languages/<language>/ folder with a README.md (as in verify-all.sh).
if [ -z "$FOLDERS" ]; then
    ALL=1
    for dir in languages/*/; do
        dir=${dir%/}
        [ -f "$dir/README.md" ] && FOLDERS="$FOLDERS $ROOT/$dir"
    done
else
    ALL=0
fi

# Never stop this script itself or what started it (your shell, or an
# agent whose working directory is the repository root).
SELF_CHAIN=''
sc_pid=$$
while [ -n "$sc_pid" ] && [ "$sc_pid" -gt 1 ]; do
    SELF_CHAIN="$SELF_CHAIN $sc_pid "
    sc_pid=$(ps -o ppid= -p "$sc_pid" 2>/dev/null | tr -d ' ')
done

# list_cwds - print "PID DIRECTORY" for each of your processes.
# lsof -d cwd reports the working directory (macOS, Linux); on Linux
# without lsof, /proc/<pid>/cwd gives the same information.
list_cwds() {
    if has_cmd lsof; then
        lsof -nP -w -a -u "$(id -u)" -d cwd -Fpn 2>/dev/null |
            awk '/^p/ { pid = substr($0, 2) } /^n/ { print pid, substr($0, 2) }'
    elif [ -d /proc ]; then
        for lc_dir in /proc/[0-9]*; do
            lc_cwd=$(readlink "$lc_dir/cwd" 2>/dev/null) &&
                echo "${lc_dir#/proc/} $lc_cwd"
        done
    fi
}

# find_pids - print the PIDs to stop, one per line.
find_pids() {
    {
        # Processes working inside one of the folders.
        list_cwds | while read -r fp_pid fp_cwd; do
            for fp_dir in $FOLDERS; do
                case "$fp_cwd/" in "$fp_dir"/*) echo "$fp_pid" ;; esac
            done
        done
        # Processes started with the path of one of the folders.
        ps -A -o pid= -o command= | while read -r fp_pid fp_cmd; do
            for fp_dir in $FOLDERS; do
                case "$fp_cmd" in *"$fp_dir"/*) echo "$fp_pid" ;; esac
            done
        done
        # verify-all.sh runs from the repository root, so it is matched by
        # name (its timeout watchers are copies of it with the same name).
        if [ "$ALL" = 1 ]; then
            list_cwds | while read -r fp_pid fp_cwd; do
                [ "$fp_cwd" = "$ROOT" ] || continue
                ps -o command= -p "$fp_pid" 2>/dev/null |
                    grep -q 'scripts/verify-all\.sh' && echo "$fp_pid"
            done
        fi
    } | sort -un | while read -r fp_pid; do
        case "$SELF_CHAIN" in *" $fp_pid "*) continue ;; esac
        # An AI coding agent working in a language folder is not ours to stop.
        case "$(ps -o comm= -p "$fp_pid" 2>/dev/null)" in
            ''|*claude*) continue ;;
        esac
        echo "$fp_pid"
    done
}

# is_selected LANGUAGE - true when LANGUAGE (or one of its folders) is selected.
is_selected() {
    for is_dir in $FOLDERS; do
        case "$is_dir/" in "$LANGS/$1"/*) return 0 ;; esac
    done
    return 1
}

# The dotnet command: on PATH, or the user-level install of csharp/install.sh.
DOTNET=''
if has_cmd dotnet; then DOTNET=dotnet
elif [ -x "$HOME/.dotnet/dotnet" ]; then DOTNET=$HOME/.dotnet/dotnet
fi

if [ "$ALL" = 1 ]; then
    step "Looking for processes started from this repository"
else
    step "Looking for processes started from:$(echo "$FOLDERS" | sed "s|$LANGS/||g")"
fi
explain "WHY: servers and windows started by run.sh keep running until they are stopped."

PIDS=$(find_pids)
if [ -n "$PIDS" ]; then
    # shellcheck disable=SC2086  # one PID per word
    ps -o pid= -o etime= -o command= -p "$(echo $PIDS | tr ' ' ,)" |
        cut -c1-160 | sed 's/^/    /'
else
    ok "No running process found."
fi

DOTNET_SERVERS=0
if is_selected csharp && [ -n "$DOTNET" ] &&
   pgrep -u "$(id -u)" -f 'MSBuild\.dll.*nodeReuse:true|VBCSCompiler|rzc\.dll' >/dev/null; then
    DOTNET_SERVERS=1
    explain ".NET build servers are running (MSBuild, Roslyn compiler, Razor)."
fi

if [ -z "$PIDS" ] && [ "$DOTNET_SERVERS" = 0 ]; then
    exit 0
fi
if [ "$LIST_ONLY" = 1 ]; then
    explain "Listed only (--list). Run without --list to stop them."
    exit 0
fi
if ! confirm "Stop them?"; then
    warn "Nothing stopped. Answer y, or run with --yes."
    exit 1
fi

if [ -n "$PIDS" ]; then
    step "Stopping $(echo "$PIDS" | wc -l | tr -d ' ') process(es)"
    explain "WHY: SIGTERM lets each program close cleanly (free the port, save files)."
    # shellcheck disable=SC2086
    kill $PIDS 2>/dev/null
    tries=5
    while [ "$tries" -gt 0 ]; do
        LEFT=''
        for pid in $PIDS; do kill -0 "$pid" 2>/dev/null && LEFT="$LEFT $pid"; done
        [ -z "$LEFT" ] && break
        sleep 1; tries=$((tries - 1))
    done
    if [ -n "$LEFT" ]; then
        warn "Still running after 5 s, forcing (SIGKILL):$LEFT"
        # shellcheck disable=SC2086
        kill -9 $LEFT 2>/dev/null
    fi
    ok "Processes stopped"
fi

if [ "$DOTNET_SERVERS" = 1 ]; then
    step "Stopping the .NET build servers"
    explain "WHY: 'dotnet build' keeps them running to make the next build faster."
    if DOTNET_CLI_TELEMETRY_OPTOUT=1 "$DOTNET" build-server shutdown >/dev/null 2>&1; then
        ok ".NET build servers stopped"
    else
        warn "'dotnet build-server shutdown' failed; they stop by themselves after a few minutes."
    fi
fi
exit 0
