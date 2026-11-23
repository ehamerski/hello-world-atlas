#!/bin/sh
# install.sh - C cli: check (and optionally install) a C compiler
#
# WHAT: checks that a C compiler is installed ("cc": clang on macOS, gcc on
#       Linux and Windows). If it is missing, shows the install command for
#       your operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  C is compiled ahead of time to machine code. The compiler is the
#       only tool this program needs: printf comes from the C standard
#       library, which every C compiler installation already includes
#       (unlike ../desktop and ../web, which need extra libraries).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://developer.apple.com/xcode/resources/   (Command Line Tools)
#   https://packages.debian.org/stable/build-essential
#   https://www.msys2.org/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/1 Check whether a C compiler is installed"
explain "WHY: 'cc' compiles hello.c into a program for your computer. 'cc' is the"
explain "     traditional Unix name of the C compiler: Apple clang on macOS, usually gcc on Linux."
# On macOS, make sure cc comes from a working developer directory.
fix_developer_dir
if has_cmd cc && cc --version >/dev/null 2>&1; then
    ok "C compiler found: $(cc --version 2>&1 | head -n 1)"
    exit 0
fi
warn "No working C compiler ('cc') was found."

case "$TF_OS" in
    macos-intel|macos-arm)
        # Apple's Command Line Tools contain clang, the linker and the C
        # library headers. xcode-select --install opens Apple's installer.
        install_pkg "Apple's Command Line Tools (clang)" xcode-select --install || exit 1
        fail "Finish Apple's installer window, then run ./install.sh again." ;;
    linux)
        # Debian/Ubuntu: build-essential pulls in gcc, make and the C
        # library headers. It needs sudo, which is shown, not hidden.
        install_pkg "gcc (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
    windows)
        explain "Install MSYS2 (https://www.msys2.org/), then in the 'MSYS2 UCRT64' shell:"
        explain "    pacman -S mingw-w64-ucrt-x86_64-gcc"
        explain "and add C:\\msys64\\ucrt64\\bin to PATH. Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. Install gcc or clang with your system's package manager." ;;
esac

has_cmd cc || fail "'cc' is still not on PATH. Open a new terminal and retry."
ok "C compiler is ready. Next: ./build.sh"
