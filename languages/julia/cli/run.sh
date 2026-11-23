#!/bin/sh
# run.sh - Julia cli: run the Hello World program
#
# WHAT: runs hello.jl with the Julia interpreter. It prints exactly: Hello, World!
# WHY:  Julia has no separate build step. The julia program reads hello.jl, compiles
#       each function with its just-in-time (JIT) compiler, and runs it. The flag
#       --startup-file=no skips your personal startup.jl, so your own settings cannot
#       change what the program prints.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented and NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# JULIA, and PATH with the Julia folder first.
# shellcheck source=julia-env.sh
. ./julia-env.sh

require_cmd "$JULIA" "The Julia interpreter runs this program."

step "Run the program"
explain "WHY: julia compiles and runs hello.jl; --startup-file=no ignores your startup.jl."
"$JULIA" --startup-file=no hello.jl
