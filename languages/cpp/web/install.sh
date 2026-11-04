#!/bin/sh
# install.sh - C++ web: check (and optionally install) c++, CMake and
#              cpp-httplib
#
# WHAT: 1. checks for a C++ compiler ("c++");
#       2. checks for CMake;
#       3. checks that cpp-httplib's header, httplib.h, is installed.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  the C++ standard library has no HTTP server (nor sockets), so the
#       server comes from a library. cpp-httplib is "header-only": installing
#       it just copies one header file, httplib.h. Nothing is compiled
#       ahead of time, so Homebrew's package is the same on every Mac.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/cpp-httplib
#   https://formulae.brew.sh/formula/cmake
#   https://packages.debian.org/stable/libcpp-httplib-dev
#   https://github.com/yhirose/cpp-httplib   (Windows: copy httplib.h)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

windows_hint() {
    explain "Install MSYS2 (https://www.msys2.org/), then in the 'MSYS2 UCRT64' shell:"
    explain "    pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake"
    explain "and add C:\\msys64\\ucrt64\\bin to PATH. MSYS2 has no cpp-httplib package:"
    explain "copy httplib.h from https://github.com/yhirose/cpp-httplib/releases into"
    explain "C:\\msys64\\ucrt64\\include. Reopen Git Bash."
}

step "1/3 Check whether a C++ compiler is installed"
explain "WHY: 'c++' compiles hello.cpp (Apple clang on macOS, usually g++ on Linux)."
fix_developer_dir
if has_cmd c++ && c++ --version >/dev/null 2>&1; then
    ok "C++ compiler found: $(c++ --version 2>&1 | head -n 1)"
else
    warn "No working C++ compiler ('c++') was found."
    case "$TF_OS" in
        macos-*)
            install_pkg "Apple's Command Line Tools (clang++)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)
            install_pkg "g++ (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        windows) windows_hint; exit 1 ;;
        *) fail "Unknown OS. Install g++ or clang++ with your system's package manager." ;;
    esac
fi

step "2/3 Check whether CMake is installed"
explain "WHY: CMake finds httplib.h and generates the build files."
if has_cmd cmake; then
    ok "CMake found: $(cmake --version | head -n 1)"
else
    warn "CMake was not found."
    case "$TF_OS" in
        macos-*)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "CMake" brew install cmake || exit 1 ;;
        linux)
            install_pkg "CMake" sudo apt-get install -y cmake || exit 1 ;;
        windows) windows_hint; exit 1 ;;
        *) fail "Unknown OS. Install CMake from https://cmake.org/download/." ;;
    esac
fi

step "3/3 Check whether cpp-httplib (httplib.h) is installed"
explain "WHY: hello.cpp includes <httplib.h>; the whole library is that one header."
# httplib_header - print the path of httplib.h if it is in one of the
# usual include folders (the same folders CMake's find_path searches).
httplib_header() {
    for hh_dir in ${CMAKE_PREFIX_PATH:-} "$(brew --prefix 2>/dev/null || true)" /usr/local /opt/homebrew /usr; do
        [ -f "$hh_dir/include/httplib.h" ] && { echo "$hh_dir/include/httplib.h"; return 0; }
    done
    return 1
}
if hh_found=$(httplib_header); then
    # The version is a #define at the top of the header.
    ok "cpp-httplib found: $hh_found ($(grep -m 1 'define CPPHTTPLIB_VERSION ' "$hh_found" | cut -d '"' -f 2))"
    exit 0
fi
warn "cpp-httplib was not found."
case "$TF_OS" in
    macos-*)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "cpp-httplib" brew install cpp-httplib || exit 1 ;;
    linux)
        install_pkg "cpp-httplib (libcpp-httplib-dev)" sudo apt-get install -y libcpp-httplib-dev || exit 1 ;;
    windows) windows_hint; exit 1 ;;
    *) fail "Unknown OS. Download httplib.h from https://github.com/yhirose/cpp-httplib." ;;
esac
ok "Toolchain is ready. Next: ./build.sh"
