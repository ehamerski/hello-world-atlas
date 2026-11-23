#!/bin/sh
# build.sh - Elixir web: compile the project with Mix
#
# WHAT: "mix compile" compiles the dependencies (the first time) and the
#       files in lib/ into .beam files (BEAM bytecode) in _build/.
# WHY:  unlike ../cli, whose script is compiled in memory on every run, a
#       Mix project is compiled once and the result is kept in _build/. Mix
#       only recompiles what changed, so later builds are fast. The first
#       build also compiles Plug, Bandit and their dependencies.
#       Mix reads mix.lock, so every student compiles the same versions.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so mix.exs is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts a downloaded Elixir on PATH (Linux and Windows); see elixir-env.sh.
# shellcheck source=elixir-env.sh
. ./elixir-env.sh

step "1/2 Check the build tool"
explain "WHY: building needs mix; ./install.sh installs it with Elixir."
require_cmd mix "Mix compiles the project."
[ -d deps ] || fail "The dependencies are missing (no deps/ folder). Run ./install.sh first."

step "2/2 Compile with 'mix compile'"
explain "WHY: Mix compiles the dependencies in deps/ and then lib/*.ex into"
explain "     _build/dev/lib/*/ebin/*.beam, the code that the BEAM runs."
mix compile

ok "Build finished. Next: ./run.sh"
