#!/bin/sh
# build.sh - QCL cli: check the syntax of hello.qcl
#
# WHAT: runs the QCL interpreter in syntax-check mode on hello.qcl and fails if it reports
#       an error. QCL has no separate compile step: qcl reads and runs the source itself.
# WHY:  QCL reports a syntax error with a line starting "!", but it still exits with
#       status 0. So this script reads the output itself, to catch the error before run.sh.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.qcl)
#
# Platforms: macOS Intel (verified on the development machine). Linux and Windows are
# documented and NOT verified for this implementation.
# Source for the options: qcl --help (QCL 0.6.7): -q skips the start-up banner, -n skips
# default.qcl, --syntax=y checks the syntax only.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QCL, QCL_LIB.
# shellcheck source=qcl-env.sh
. ./qcl-env.sh

step "1/2 Check the interpreter"
explain "WHY: building needs qcl; ./install.sh installs it."
[ -x "$QCL" ] || fail "qcl was not found at $QCL. Run ./install.sh first."

step "2/2 Check the syntax of hello.qcl"
explain "WHY: qcl reports a syntax error on a line that starts with !; its exit status is 0 anyway."
# </dev/null closes stdin so that qcl does not wait for typed commands.
out=$("$QCL" -q -n -I "$QCL_LIB" --syntax=y hello.qcl </dev/null 2>&1) || true
if printf '%s\n' "$out" | grep -q '^!'; then
    printf '%s\n' "$out"
    fail "QCL found an error in hello.qcl (see above)."
fi

ok "Syntax of hello.qcl is correct. Next: ./run.sh"
