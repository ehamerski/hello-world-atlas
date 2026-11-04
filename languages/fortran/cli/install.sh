#!/bin/sh
# install.sh - Fortran cli: check (and optionally install) gfortran
#
# WHAT: checks that gfortran, the GNU Fortran compiler, is installed. If it
#       is missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  Fortran is compiled ahead of time to machine code, so a Fortran
#       compiler is the only tool this program needs. gfortran is part of
#       GCC, the GNU Compiler Collection. On macOS, Homebrew ships it inside
#       its "gcc" formula: Apple's Command Line Tools have no Fortran
#       compiler.
#       Homebrew has no ready-made gcc package (bottle) for Intel Macs, so
#       there it compiles GCC from source: expect it to take a long time.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/gcc
#   https://packages.debian.org/stable/gfortran
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-gcc-fortran

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The compiler command; FC is the usual name for "the Fortran compiler" in
# build tools such as make (like CC for C). Override: FC=gfortran-16 ./install.sh
FC=${FC:-gfortran}

step "1/2 Check whether gfortran is installed"
explain "WHY: '$FC' compiles hello.f90 into a program for your computer."
if has_cmd "$FC"; then
    ok "gfortran found: $("$FC" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "gfortran is not installed (no '$FC' on PATH)."

step "2/2 Install gfortran"
explain "WHY: gfortran comes with GCC; each OS packages it differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh): the "gcc" formula contains gfortran.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        if [ "$TF_OS" = macos-intel ]; then
            warn "On Intel Macs, Homebrew builds GCC from source; this can take several hours."
        fi
        install_pkg "gfortran (Homebrew gcc)" brew install gcc || exit 1 ;;
    linux)
        # Debian/Ubuntu package "gfortran". It needs sudo, which is shown.
        install_pkg "gfortran" sudo apt-get install -y gfortran || exit 1 ;;
    windows)
        explain "Install MSYS2 (https://www.msys2.org/), then in the 'MSYS2 UCRT64' shell:"
        explain "    pacman -S mingw-w64-ucrt-x86_64-gcc-fortran"
        explain "and add C:\\msys64\\ucrt64\\bin to PATH. Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://fortran-lang.org/compilers/ for Fortran compilers." ;;
esac

has_cmd "$FC" || fail "'$FC' is still not on PATH. Open a new terminal and retry."
ok "gfortran is ready. Next: ./build.sh"
