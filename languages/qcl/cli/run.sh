#!/bin/sh
# run.sh - QCL cli: run the Hello World program
#
# WHAT: runs hello.qcl with the QCL interpreter. It prints the text Hello, World!
# WHY:  QCL reads the file, runs the procedure, and prints the line. The output has the
#       interpreter's ": " prefix and a trailing space (see README.md); the text is verbatim.
#       -q skips the start-up banner, -n skips default.qcl, -b 2 sets the number of qubits
#       (the default of 64 is not needed here), and </dev/null closes stdin so that QCL
#       exits after the program instead of waiting for typed commands.
# HOW:  ./run.sh            run it for yourself
#       ./run.sh --verify   self-check used by scripts/verify-all.sh
#                           (for cli it is the same run; it exits by itself)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# documented and NOT verified for this implementation.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QCL, QCL_LIB.
# shellcheck source=qcl-env.sh
. ./qcl-env.sh

require_cmd "$QCL" "The QCL interpreter runs this program. (run ./install.sh first)"

step "Run the program"
explain "WHY: qcl interprets hello.qcl; -b 2 sets the qubit count, -I points at its library."
"$QCL" -q -n -b 2 -I "$QCL_LIB" hello.qcl </dev/null
