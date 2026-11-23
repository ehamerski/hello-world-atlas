#!/bin/sh
# build.sh - C++ cli: configure and build hello.cpp with CMake
#
# WHAT: runs the two CMake steps:
#         cmake -S . -B build -DCMAKE_BUILD_TYPE=Release   (configure)
#         cmake --build build                              (build)
#       and leaves the executable in build/hello-cli.
# WHY:  CMake works in two steps. "Configure" reads CMakeLists.txt, finds
#       the compiler, checks that it supports C++20 and writes Makefiles
#       into build/. "Build" runs those Makefiles, which call the compiler.
#       Everything generated goes into build/, so the source folder stays
#       clean (an "out-of-source" build). Compare ../../c/cli/build.sh,
#       which calls the compiler directly.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       CXX=g++ ./build.sh     use another compiler (delete build/ first)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so CMakeLists.txt is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows: MSYS2's UCRT64 tools and DLLs first on PATH (no effect elsewhere).
# shellcheck source=../msys2-env.sh
. ../msys2-env.sh

step "1/3 Check the tools"
explain "WHY: building needs CMake and a C++ compiler; ./install.sh checks for both."
fix_developer_dir
require_cmd cmake "CMake generates the build files."

step "2/3 Configure (cmake -S . -B build)"
explain "WHY: CMake reads CMakeLists.txt, checks the compiler for C++20 support"
explain "     and writes the build files into build/. Release turns on optimization."
# set -x prints the exact command, so you can copy it.
set -x
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
{ set +x; } 2>/dev/null

step "3/3 Build (cmake --build build)"
explain "WHY: runs the generated build files, which compile and link hello.cpp."
set -x
cmake --build build
{ set +x; } 2>/dev/null

ok "Built build/hello-cli. Next: ./run.sh"
