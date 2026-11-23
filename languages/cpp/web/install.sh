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
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/cpp-httplib
#   https://formulae.brew.sh/formula/cmake
#   https://packages.debian.org/stable/libcpp-httplib-dev
#   https://github.com/yhirose/cpp-httplib   (Windows: httplib.h from the v0.64.0 tag)
#   https://packages.ubuntu.com/search?keywords=libcpp-httplib-dev   (Linux: a compiled library, see CMakeLists.txt)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows: MSYS2's UCRT64 tools and DLLs first on PATH (no effect elsewhere).
# shellcheck source=../msys2-env.sh
. ../msys2-env.sh

step "1/3 Check whether a C++ compiler is installed"
explain "WHY: 'c++' compiles hello.cpp (Apple clang on macOS, usually g++ on Linux)."
fix_developer_dir
if [ "$TF_OS" = windows ]; then
    # Not just any 'c++': it must be MSYS2's g++, the compiler of its libraries.
    msys2_ensure "g++ and the build tools" gcc cmake ninja
    ok "C++ compiler found: $(g++ --version 2>&1 | head -n 1)"
elif has_cmd c++ && c++ --version >/dev/null 2>&1; then
    ok "C++ compiler found: $(c++ --version 2>&1 | head -n 1)"
else
    warn "No working C++ compiler ('c++') was found."
    case "$TF_OS" in
        macos-*)
            install_pkg "Apple's Command Line Tools (clang++)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)
            install_pkg "g++ (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        *) fail "Unknown OS. Install g++ or clang++ with your system's package manager." ;;
    esac
fi

step "2/3 Check whether CMake is installed"
explain "WHY: CMake finds httplib.h and generates the build files."
if [ "$TF_OS" = windows ]; then
    # Installed with the compiler above (MSYS2's cmake and ninja); the
    # Visual Studio CMake on a Windows runner would pick MSVC, not g++.
    ok "CMake found: $(cmake --version | head -n 1)"
elif has_cmd cmake; then
    ok "CMake found: $(cmake --version | head -n 1)"
else
    warn "CMake was not found."
    case "$TF_OS" in
        macos-*)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "CMake" brew install cmake || exit 1 ;;
        linux)
            install_pkg "CMake" sudo apt-get install -y cmake || exit 1 ;;
        *) fail "Unknown OS. Install CMake from https://cmake.org/download/." ;;
    esac
fi

step "3/3 Check whether cpp-httplib (httplib.h) is installed"
explain "WHY: hello.cpp includes <httplib.h>; the whole library is that one header."
# httplib_header - print the path of httplib.h if it is in one of the
# usual include folders (the same folders CMake's find_path searches).
httplib_header() {
    for hh_dir in ${CMAKE_PREFIX_PATH:-} "$(brew --prefix 2>/dev/null || true)" /usr/local /opt/homebrew /usr \
                  "$MSYS2_ROOT/ucrt64"; do
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
    windows)
        # MSYS2 has no cpp-httplib package (https://packages.msys2.org/ has
        # none), but the library is one header: download the release of the
        # project's git tag into MSYS2's include folder, where g++ and CMake
        # (find_path) look. The version is pinned and the SHA-256 checked: the
        # project publishes no checksum, so this one was computed from the
        # v0.64.0 file on 2026-11-04 and is the same as the file in
        # Homebrew's cpp-httplib 0.64.0.
        hh_version=0.64.0
        hh_sha256=805169049e6a6e9ba7729d7e01d14ced825029c88a277586602a6b38df4d5357
        hh_url=https://raw.githubusercontent.com/yhirose/cpp-httplib/v$hh_version/httplib.h
        hh_dest=$MSYS2_ROOT/ucrt64/include/httplib.h
        install_pkg "cpp-httplib $hh_version (httplib.h)" curl -fL -o "$hh_dest" "$hh_url" || exit 1
        echo "$hh_sha256  $hh_dest" | sha256sum -c - \
            || { rm -f "$hh_dest"; fail "Checksum mismatch for $hh_dest; it was deleted. Retry."; } ;;
    *) fail "Unknown OS. Download httplib.h from https://github.com/yhirose/cpp-httplib." ;;
esac
ok "Toolchain is ready. Next: ./build.sh"
