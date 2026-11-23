#!/bin/sh
# build.sh - Erlang web: compile the program
#
# WHAT: turns hello_httpd.erl into hello_httpd.beam in the folder ebin/.
# WHY:  the BEAM virtual machine runs bytecode, not source code. erlc, the
#       Erlang compiler, translates each module (.erl) into a .beam file.
#       ebin/ ("erlang binaries") is the folder that OTP's design rules use
#       for compiled code; erl finds it through the -pa option in run.sh.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so the paths below work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Erlang/OTP (Windows) on PATH; see erlang-env.sh.
# shellcheck source=erlang-env.sh
. ./erlang-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs erlc, which comes with Erlang/OTP; ./install.sh installs it."
require_cmd erlc "Erlang/OTP provides the compiler erlc."

step "2/2 Compile hello_httpd.erl"
explain "WHY: -o ebin puts the .beam file in ebin/ instead of the current folder;"
explain "     -Wall turns on all the compiler's warnings."
mkdir -p ebin
erlc -Wall -o ebin hello_httpd.erl

ok "Build finished: ebin/hello_httpd.beam. Next: ./run.sh"
