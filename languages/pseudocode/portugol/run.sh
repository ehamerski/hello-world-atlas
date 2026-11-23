#!/bin/sh
# run.sh - Pseudocode (Portugol / VisuAlg): run ola-mundo.alg with Delégua
#
# WHAT: runs
#         delegua --dialeto visualg ola-mundo.alg
#       which prints exactly: Hello, World!
# WHY:  VisuAlg pseudocode is interpreted: there is no build step, the
#       interpreter reads the algorithm and executes it, like Python runs a
#       .py file. "--dialeto visualg" ("dialect") tells Delégua to read the
#       file as VisuAlg; without it, Delégua expects its own language.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does exactly the same thing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so ola-mundo.alg and node_modules/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

[ -x node_modules/.bin/delegua ] || fail "Delégua was not found. Run ./install.sh first."

step "Run ola-mundo.alg with the Delégua interpreter (VisuAlg dialect)"
explain "WHY: Delégua reads the pseudocode and executes it, line by line."
node_modules/.bin/delegua --dialeto visualg ola-mundo.alg
