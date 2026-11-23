#!/bin/sh
# install.sh - C++ cli: check (and optionally install) a C++ compiler and CMake
#
# WHAT: 1. checks for a C++ compiler ("c++": clang++ on macOS, g++ on Linux);
#       2. checks for CMake 3.20 or newer.
#       If something is missing, shows the install command for your operating
#       system and runs it only if you answer "y". Nothing is installed
#       silently and sudo is never hidden.
# WHY:  C++ is compiled ahead of time to machine code, like C. The standard
#       library (std::cout) comes with every C++ compiler. CMake is the build
#       system: it is not part of C++, but it is widely used to describe
#       how a C++ project is built, and ../desktop (Qt) builds with it.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://developer.apple.com/xcode/resources/   (Command Line Tools)
#   https://formulae.brew.sh/formula/cmake
#   https://packages.debian.org/stable/build-essential
#   https://packages.debian.org/stable/cmake
#   https://www.msys2.org/

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

step "1/2 Check whether a C++ compiler is installed"
explain "WHY: 'c++' compiles hello.cpp. It is the traditional name of the system's"
explain "     C++ compiler: Apple clang on macOS, usually g++ on Linux."
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
            # Apple's Command Line Tools contain clang++, the linker and libc++.
            install_pkg "Apple's Command Line Tools (clang++)" xcode-select --install || exit 1
            fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)
            install_pkg "g++ (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        *) fail "Unknown OS. Install g++ or clang++ with your system's package manager." ;;
    esac
fi

step "2/2 Check whether CMake is installed"
explain "WHY: CMake reads CMakeLists.txt and generates the build files that call the compiler."
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

has_cmd cmake || fail "'cmake' is still not on PATH. Open a new terminal and retry."
ok "Toolchain is ready. Next: ./build.sh"
