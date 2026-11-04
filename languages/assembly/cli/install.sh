#!/bin/sh
# install.sh - Assembly (x86-64) cli: check (and optionally install) NASM
#
# WHAT: checks the two tools this program needs and offers to install the
#       one that is missing, running the command only if you answer "y".
#       Nothing is installed silently and sudo is never hidden.
#         1. a linker driver ("cc": Apple clang on macOS), which links the
#            object file with the C library;
#         2. NASM, the Netwide Assembler, which turns hello.asm (text) into
#            an object file (machine code).
# WHY:  an assembler is to assembly what a compiler is to C: it translates
#       the source into machine code. NASM is not part of Apple's Command
#       Line Tools, so it comes from Homebrew. The program prints through
#       write() from the C library, so it is linked like a C program, with cc.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine). hello.asm is x86-64
# macOS code: on Apple Silicon, Linux and Windows the tools install, but the
# program needs changes or Rosetta (see README.md, "Platform notes").
# Sources for the install commands:
#   https://formulae.brew.sh/formula/nasm
#   https://packages.debian.org/stable/nasm
#   https://developer.apple.com/xcode/resources/   (Command Line Tools)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the linker driver (cc)"
explain "WHY: NASM only makes an object file. 'cc' calls the system linker (ld), which"
explain "     joins it with the C library (where write() lives) into an executable."
fix_developer_dir
if has_cmd cc && cc --version >/dev/null 2>&1; then
    ok "cc found: $(cc --version 2>&1 | head -n 1)"
else
    warn "No working 'cc' was found."
    case "$TF_OS" in
        macos-*)
            # Apple's Command Line Tools contain clang, ld and the C library.
            install_pkg "Apple's Command Line Tools (clang, ld)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)
            install_pkg "gcc and ld (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        *)
            fail "Install a C compiler and linker for your system (see README.md)." ;;
    esac
fi

step "2/2 Check the assembler (nasm)"
explain "WHY: 'nasm' translates the instructions in hello.asm into machine code."
if has_cmd nasm; then
    ok "NASM found: $(nasm -v)"
    ok "Toolchain is ready. Next: ./build.sh"
    exit 0
fi
warn "NASM is not installed (no 'nasm' on PATH)."

case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh) has a ready-made NASM package.
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "NASM (Homebrew)" brew install nasm || exit 1 ;;
    linux)
        # Debian/Ubuntu package "nasm". It needs sudo, which is shown.
        install_pkg "NASM" sudo apt-get install -y nasm || exit 1 ;;
    windows)
        explain "Download the installer from https://www.nasm.us/ (or, in MSYS2:"
        explain "    pacman -S mingw-w64-ucrt-x86_64-nasm)"
        explain "Note: Windows uses a different calling convention; see README.md."
        exit 1 ;;
    *)
        fail "Unknown OS. Get NASM from https://www.nasm.us/." ;;
esac

has_cmd nasm || fail "'nasm' is still not on PATH. Open a new terminal and retry."
ok "NASM is ready: $(nasm -v). Next: ./build.sh"
