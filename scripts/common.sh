#!/bin/sh
# scripts/common.sh - shared helpers for every install.sh / build.sh / run.sh
#
# WHAT: small POSIX sh functions that every implementation script sources:
#   - output helpers (step / explain / ok / warn / fail) so every script
#     tells the student WHAT it is doing and WHY;
#   - OS detection (macos-intel, macos-arm, linux, windows) so install.sh can
#     suggest the right package manager;
#   - has_cmd / require_cmd to check whether a tool is installed;
#   - confirm / install_pkg so nothing is installed (and sudo is never run)
#     without the student agreeing first;
#   - the DEVELOPER_DIR fix for macOS compilers.
#
# HOW TO USE (from <lang>/<category>/<script>.sh):
#   . "$(dirname "$0")/../../scripts/common.sh"
#
# WHY POSIX sh: it runs unchanged with /bin/sh on macOS and Linux and in
# Git Bash / WSL on Windows. Reference: POSIX Shell Command Language,
# https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html
#
# Environment variables understood by these helpers:
#   TF_ASSUME_YES=1   answer "yes" to every confirm (unattended installs)
#   TF_NONINTERACTIVE=1  never prompt; confirm answers "no" and the install
#                     command is only printed (used by scripts/verify-all.sh)
#   NO_COLOR=1        disable colors (convention: https://no-color.org/)

# ---------------------------------------------------------------- output ---
# Colors only when writing to a terminal and NO_COLOR is not set.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    TF_BOLD=$(printf '\033[1m'); TF_BLUE=$(printf '\033[34m')
    TF_GREEN=$(printf '\033[32m'); TF_YELLOW=$(printf '\033[33m')
    TF_RED=$(printf '\033[31m'); TF_RESET=$(printf '\033[0m')
else
    TF_BOLD=''; TF_BLUE=''; TF_GREEN=''; TF_YELLOW=''; TF_RED=''; TF_RESET=''
fi

# step "title"     - announce a numbered step of the script.
step()    { printf '\n%s==> %s%s\n' "$TF_BOLD$TF_BLUE" "$*" "$TF_RESET"; }
# explain "text"   - say WHY the current step is needed (teaching output).
explain() { printf '    %s\n' "$*"; }
ok()      { printf '%s[ok]%s %s\n' "$TF_GREEN" "$TF_RESET" "$*"; }
warn()    { printf '%s[warn]%s %s\n' "$TF_YELLOW" "$TF_RESET" "$*" >&2; }
# fail "message"   - print an error and stop the script with exit code 1.
fail()    { printf '%s[error]%s %s\n' "$TF_RED" "$TF_RESET" "$*" >&2; exit 1; }

# ------------------------------------------------------------ detection ---
# detect_os prints one of: macos-intel, macos-arm, linux, windows, unknown.
detect_os() {
    case "$(uname -s)" in
        Darwin)
            case "$(uname -m)" in
                arm64) echo macos-arm ;;
                *)     echo macos-intel ;;
            esac ;;
        Linux)
            # WSL reports Linux and behaves like Linux.
            echo linux ;;
        MINGW*|MSYS*|CYGWIN*)
            # Git Bash (MSYS2) or Cygwin on Windows.
            echo windows ;;
        *)  echo unknown ;;
    esac
}
TF_OS=$(detect_os)

# has_cmd NAME - true if NAME is an executable on PATH.
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# require_cmd NAME "hint" - stop with a helpful message if NAME is missing.
require_cmd() {
    has_cmd "$1" || fail "'$1' was not found. $2 (run ./install.sh first)"
}

# ------------------------------------------------------------- installs ---
# confirm "question" - ask y/N. Respects TF_ASSUME_YES and TF_NONINTERACTIVE.
confirm() {
    [ "${TF_ASSUME_YES:-}" = 1 ] && return 0
    [ "${TF_NONINTERACTIVE:-}" = 1 ] && return 1
    [ -t 0 ] || return 1   # no keyboard attached: never assume yes
    printf '%s [y/N] ' "$*"
    read -r tf_answer || return 1
    case "$tf_answer" in y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}

# install_pkg "description" CMD... - show the install command, ask, then run
# it. If the student says no, the command is only printed so they can run it
# themselves. Commands that need sudo are shown as such: nothing is hidden.
install_pkg() {
    tf_desc=$1; shift
    explain "To install $tf_desc, the command is:"
    explain "    $*"
    if confirm "Run it now?"; then
        "$@" || fail "Installing $tf_desc failed. Try the command above by hand."
        ok "$tf_desc installed"
    else
        warn "Skipped. Run the command above yourself, then re-run this script."
        return 1
    fi
}

# ---------------------------------------------------- macOS compiler fix ---
# fix_developer_dir - on macOS, make sure clang/make come from a working
# developer directory. If xcode-select points at a missing or broken Xcode,
# compilers fail with "xcrun: error". Setting DEVELOPER_DIR overrides the
# active developer directory for this process only (see `man xcode-select`,
# section ENVIRONMENT). Nothing system-wide is changed.
fix_developer_dir() {
    case "$TF_OS" in macos-*) ;; *) return 0 ;; esac
    if xcrun --find clang >/dev/null 2>&1; then
        return 0
    fi
    if [ -d /Library/Developer/CommandLineTools ]; then
        DEVELOPER_DIR=/Library/Developer/CommandLineTools
        export DEVELOPER_DIR
        warn "The active developer directory has no working clang; using $DEVELOPER_DIR for this run."
    else
        warn "No Apple compiler found. Install the Command Line Tools with: xcode-select --install"
    fi
}

# ------------------------------------------------------------- verify mode ---
# is_verify ARGS... - true when the script was called with --verify.
# scripts/verify-all.sh passes --verify to run.sh so that web and desktop
# apps check themselves and exit instead of waiting for the user.
is_verify() {
    for tf_arg in "$@"; do [ "$tf_arg" = --verify ] && return 0; done
    return 1
}

# wait_for_http URL [SECONDS] - poll URL until it answers (default 30 s), then
# print the response body. Used by web run.sh scripts in --verify mode: the
# server needs a moment to start before it can answer.
wait_for_http() {
    require_cmd curl "curl is used to call the local web server."
    tf_tries=${2:-30}
    while [ "$tf_tries" -gt 0 ]; do
        if curl -fsS "$1" 2>/dev/null; then echo; return 0; fi
        tf_tries=$((tf_tries - 1))
        sleep 1
    done
    warn "No answer from $1"
    return 1
}
