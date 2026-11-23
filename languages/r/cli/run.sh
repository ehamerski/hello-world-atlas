#!/bin/sh
# run.sh - R cli: run the Hello World program
#
# WHAT: runs hello.R, which prints exactly: Hello, World!
# WHY:  R is interpreted: there is no build step. Rscript is the command
#       that runs an R file non-interactively. It reads hello.R, evaluates it,
#       and exits. The "R" command starts an interactive session instead, and
#       prints a version banner first. Rscript prints no banner.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Source: https://cran.r-project.org/doc/manuals/r-release/R-intro.html
#         (appendix "Invoking R", section "Scripting with R")

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=r-env.sh
. ./r-env.sh

require_cmd Rscript "R runs this program."

step "Run the program"
explain "WHY: 'Rscript hello.R' starts R without a session and evaluates the file."
Rscript hello.R
