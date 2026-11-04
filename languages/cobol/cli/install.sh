#!/bin/sh
# install.sh - COBOL cli: check (and optionally install) GnuCOBOL
#
# WHAT: checks that GnuCOBOL's compiler, "cobc", is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  COBOL is compiled ahead of time. GnuCOBOL translates the COBOL
#       source into C and then calls a C compiler, so "cobc" also needs a
#       working C compiler (the package managers below take care of that,
#       except on macOS, where Apple's Command Line Tools provide it).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/gnucobol
#   https://packages.debian.org/stable/gnucobol
#   https://packages.msys2.org/base/mingw-w64-gnucobol

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check whether GnuCOBOL (cobc) is installed"
explain "WHY: 'cobc' is the GnuCOBOL compiler. It turns hello.cob into C, and"
explain "     then into a program for your computer."
# cobc calls the C compiler; on macOS make sure that one works too.
fix_developer_dir
if has_cmd cobc; then
    ok "GnuCOBOL found: $(cobc --version 2>&1 | head -n 1)"
    exit 0
fi
warn "GnuCOBOL is not installed (no 'cobc' on PATH)."

step "2/2 Install GnuCOBOL"
explain "WHY: GnuCOBOL is a free COBOL compiler packaged by Homebrew, Debian/Ubuntu"
explain "     and MSYS2; the package manager also installs its runtime library (libcob)."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) installs command-line tools on macOS.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "GnuCOBOL" brew install gnucobol || exit 1 ;;
    linux)
        # Debian/Ubuntu: "gnucobol" pulls in the default GnuCOBOL version
        # (gnucobol3). It needs sudo, which is shown, not hidden.
        install_pkg "GnuCOBOL" sudo apt-get install -y gnucobol || exit 1 ;;
    windows)
        explain "Install MSYS2 (https://www.msys2.org/), then in the 'MSYS2 UCRT64' shell:"
        explain "    pacman -S mingw-w64-ucrt-x86_64-gnucobol mingw-w64-ucrt-x86_64-gcc"
        explain "and add C:\\msys64\\ucrt64\\bin to PATH. Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://gnucobol.sourceforge.io/ for downloads." ;;
esac

has_cmd cobc || fail "'cobc' is still not on PATH. Open a new terminal and retry."
ok "GnuCOBOL is ready. Next: ./build.sh"
