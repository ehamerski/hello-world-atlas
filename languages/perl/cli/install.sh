#!/bin/sh
# install.sh - Perl cli: check (and optionally install) Perl
#
# WHAT: checks that the perl interpreter is installed. If it is missing,
#       shows the install command for your operating system and runs it
#       only if you answer "y". Nothing is installed silently and sudo is
#       never hidden.
# WHY:  Perl is interpreted: hello.pl is run by the perl program, so that
#       program must be on your PATH. macOS ships Perl with the system, and
#       most Linux distributions do too, so on those systems there is often
#       nothing to install. The cli version needs nothing else.
# HOW:  ./install.sh       (run once; safe to run again)
#       PERL=perl5 ./install.sh   check another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://www.perl.org/get.html
#   https://formulae.brew.sh/formula/perl
#   https://packages.debian.org/stable/perl
#   https://strawberryperl.com/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

TOOL=${PERL:-perl}
TOOL_NAME="Perl 5"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: hello.pl is run by the Perl interpreter ('$TOOL')."
if has_cmd "$TOOL"; then
    # "perl -e" runs the code given on the command line. $^V is Perl's own
    # version, written v5.34.1.
    ok "$TOOL_NAME found: $("$TOOL" -e 'print "perl $^V"')"
    exit 0
fi
warn "$TOOL_NAME is not installed (no '$TOOL' on PATH)."

step "2/2 Install $TOOL_NAME"
explain "WHY: each OS has a standard way to install Perl;"
explain "     a package manager also keeps it up to date."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install perl ;;
    linux)
        # Debian/Ubuntu shown; most distributions already ship perl.
        install_pkg "$TOOL_NAME" sudo apt-get install -y perl ;;
    windows)
        # Strawberry Perl is the Perl distribution for Windows listed on perl.org.
        explain "On Windows, install Strawberry Perl from https://strawberryperl.com/"
        explain "then reopen Git Bash and run this script again."
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://www.perl.org/get.html" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
