#!/bin/sh
# run.sh - Perl desktop: open the Hello World window
#
# WHAT: runs hello.pl, which opens a window showing: Hello, World!
# WHY:  Perl is interpreted, so there is no build.sh. The program needs Tkx,
#       which install.sh put in the local folder local/; tkx-env.sh adds
#       that folder to PERL5LIB, the list of folders where Perl looks for
#       modules (like PYTHONPATH in Python or CLASSPATH in Java).
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the
#                           app prints Hello, World! and closes after 2 s
#       PERL=perl5 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.pl and local/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, is_verify, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Perl (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-perl.sh
. ../use-msys2-perl.sh
# Sets PERL5LIB to the local library when it exists.
# shellcheck source=tkx-env.sh
. ./tkx-env.sh

PERL=${PERL:-perl}
require_cmd "$PERL" "Perl runs this program."
[ -d local/lib/perl5 ] || fail "Tkx is not installed in local/. Run ./install.sh first."

step "Open the Hello World window"
explain "WHY: Tkx asks Tk to create a native window; MainLoop keeps it open."
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check inside hello.pl.
    TF_VERIFY=1 "$PERL" hello.pl
else
    explain "Close the window (or press Ctrl+C here) to end the program."
    "$PERL" hello.pl
fi
