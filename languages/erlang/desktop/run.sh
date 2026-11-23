#!/bin/sh
# run.sh - Erlang desktop: open the Hello World window
#
# WHAT: runs hello_wx.main/0 on the BEAM virtual machine; it opens a window
#       that shows: Hello, World!
# WHY:  the window is drawn by wx, the wxWidgets binding that ships with
#       Erlang/OTP. The program is the compiled module in ebin/ (see
#       build.sh).
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once its window is shown
#                           and closes itself after about 2 seconds
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# A desktop app needs a graphical session: it cannot open a window over a
# plain SSH connection or in a CI job without a display.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "ebin" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Erlang/OTP (Windows) on PATH; see erlang-env.sh.
# shellcheck source=erlang-env.sh
. ./erlang-env.sh

require_cmd erl "Erlang/OTP provides erl, which runs this program."
[ -f ebin/hello_wx.beam ] || fail "ebin/hello_wx.beam is missing. Run ./build.sh first."

step "Open the Hello World window"
explain "WHY: wx asks wxWidgets for a native window; the program then waits for its close message."
# erl options:
#   +Bd        Ctrl+C ends the program instead of opening the emulator's break menu
#   -noshell   no interactive Erlang shell: the terminal stays free
#   -pa ebin   add ebin/ to the code path, so erl finds hello_wx.beam
#   -s hello_wx main   call hello_wx:main() (the -run option is the same, but
#              passes its arguments as strings)
#   -s init stop       when main/0 returns, stop the virtual machine
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check inside hello_wx.erl.
    TF_VERIFY=1 erl +Bd -noshell -pa ebin -s hello_wx main -s init stop
else
    explain "Close the window (or press Ctrl+C here) to end the program."
    erl +Bd -noshell -pa ebin -s hello_wx main -s init stop
fi
