#!/bin/sh
# run.sh - Elixir cli: run the Hello World program
#
# WHAT: runs "elixir hello.exs", which prints exactly: Hello, World!
# WHY:  there is no build.sh. The elixir command compiles hello.exs in
#       memory, loads the result into the BEAM (the Erlang virtual machine)
#       and runs it. The Elixir docs say that with "elixir" (instead of
#       "elixirc") code "was compiled and loaded into memory, but no .beam
#       file was written to disk". Nothing is written to disk.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.exs is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Elixir on PATH (Linux and Windows); see elixir-env.sh.
# shellcheck source=elixir-env.sh
. ./elixir-env.sh

require_cmd elixir "Elixir runs hello.exs."

step "Run the program"
explain "WHY: elixir compiles hello.exs in memory, runs it on the BEAM, and exits"
explain "     when the script ends."
elixir hello.exs
