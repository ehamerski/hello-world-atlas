#!/bin/sh
# run.sh - Erlang cli: run the Hello World program
#
# WHAT: runs "escript hello.erl", which prints exactly: Hello, World!
# WHY:  escript reads hello.erl, compiles it in memory with the Erlang
#       compiler, and runs its main/1 function on the BEAM virtual machine.
#       No .beam file is written, so there is no build.sh.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   same output (a cli program checks itself)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.erl" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Erlang/OTP (Windows) on PATH; see erlang-env.sh.
# shellcheck source=erlang-env.sh
. ./erlang-env.sh

require_cmd escript "Erlang/OTP provides escript, which runs hello.erl."

step "Run the program"
explain "WHY: escript compiles hello.erl in memory and calls main/1; there is no build step."
# --verify needs nothing extra: the program prints the text and ends.
escript hello.erl
