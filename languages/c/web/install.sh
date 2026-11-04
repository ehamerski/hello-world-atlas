#!/bin/sh
# install.sh - C web: check (and optionally install) cc, pkg-config and
#              GNU libmicrohttpd
#
# WHAT: 1. checks for a C compiler ("cc");
#       2. checks for pkg-config, the tool that tells the compiler where a
#          library's headers and binary files are;
#       3. checks that libmicrohttpd is installed ("pkg-config --exists").
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  standard C has no networking, so the HTTP server comes from a
#       library. C has no package manager of its own (no Maven, no Go
#       modules, no npm): libraries are installed with the operating
#       system's package manager, here Homebrew, apt or MSYS2's pacman.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/libmicrohttpd
#   https://packages.debian.org/stable/libmicrohttpd-dev
#   https://packages.msys2.org/base/mingw-w64-libmicrohttpd

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# windows_hint - print the manual MSYS2 install commands on
# Windows, where this script does not install anything itself.
windows_hint() {
    explain "Install MSYS2 (https://www.msys2.org/), then in the 'MSYS2 UCRT64' shell:"
    explain "    pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-pkgconf mingw-w64-ucrt-x86_64-libmicrohttpd"
    explain "and add C:\\msys64\\ucrt64\\bin to PATH. Reopen Git Bash."
}

step "1/3 Check the C compiler"
explain "WHY: 'cc' compiles hello.c (see ../cli/install.sh for the details)."
fix_developer_dir
if has_cmd cc && cc --version >/dev/null 2>&1; then
    ok "C compiler found: $(cc --version 2>&1 | head -n 1)"
else
    case "$TF_OS" in
        macos-*) install_pkg "Apple's Command Line Tools (clang)" xcode-select --install || exit 1
                 fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)   install_pkg "gcc (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        windows) windows_hint; exit 1 ;;
        *)       fail "Unknown OS. Install gcc or clang with your package manager." ;;
    esac
fi

step "2/3 Check pkg-config"
explain "WHY: a C library is a header (.h, for the compiler) plus a binary (.dylib/.so/.dll,"
explain "     for the linker). 'pkg-config --cflags --libs libmicrohttpd' prints the -I, -L"
explain "     and -l flags that point the compiler and linker at them."
if has_cmd pkg-config; then
    ok "pkg-config found: $(pkg-config --version)"
else
    case "$TF_OS" in
        macos-*) has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
                 install_pkg "pkg-config (pkgconf)" brew install pkgconf || exit 1 ;;
        linux)   install_pkg "pkg-config" sudo apt-get install -y pkg-config || exit 1 ;;
        windows) windows_hint; exit 1 ;;
        *)       fail "Unknown OS. Install pkg-config with your package manager." ;;
    esac
fi

step "3/3 Check GNU libmicrohttpd"
explain "WHY: libmicrohttpd is the HTTP server library that hello.c calls (MHD_start_daemon)."
if pkg-config --exists libmicrohttpd; then
    ok "libmicrohttpd found: version $(pkg-config --modversion libmicrohttpd)"
else
    case "$TF_OS" in
        macos-*) has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
                 install_pkg "libmicrohttpd" brew install libmicrohttpd || exit 1 ;;
        linux)   # The -dev package holds the header and the .pc file for pkg-config.
                 install_pkg "libmicrohttpd (development files)" \
                     sudo apt-get install -y libmicrohttpd-dev || exit 1 ;;
        windows) windows_hint; exit 1 ;;
        *)       fail "Unknown OS. See https://www.gnu.org/software/libmicrohttpd/" ;;
    esac
    pkg-config --exists libmicrohttpd \
        || fail "pkg-config still cannot find libmicrohttpd. Open a new terminal and retry."
fi
ok "Ready. Next: ./build.sh"
