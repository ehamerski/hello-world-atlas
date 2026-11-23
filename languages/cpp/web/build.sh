#!/bin/sh
# build.sh - C++ web: configure and build hello.cpp with cpp-httplib
#
# WHAT: runs the two CMake steps:
#         cmake -S . -B build -DCMAKE_BUILD_TYPE=Release   (configure)
#         cmake --build build                              (build)
#       and leaves the executable in build/hello-web.
# WHY:  "Configure" reads CMakeLists.txt, finds the compiler, the folder
#       that holds httplib.h and the thread library, and writes build files
#       into build/. "Build" compiles hello.cpp. The whole HTTP server is
#       compiled into the program from the header, so the build takes
#       longer than ../cli (httplib.h 0.64.0 has 24,321 lines), but no server
#       library is needed at run time. Compare ../../c/web, which links
#       libmicrohttpd as a shared library.
# HOW:  ./build.sh                                     (after ./install.sh)
#       CMAKE_PREFIX_PATH=/path/to/prefix ./build.sh   httplib.h is in
#                                                      /path/to/prefix/include
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
explain "WHY: building needs CMake, a C++ compiler and httplib.h; ./install.sh checks them."
fix_developer_dir
require_cmd cmake "CMake generates the build files."

step "2/3 Configure (cmake -S . -B build)"
explain "WHY: CMake finds the folder of httplib.h (find_path) and the thread library,"
explain "     and writes the build files into build/."
# set -x prints the exact command, so you can copy it.
set -x
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
{ set +x; } 2>/dev/null

step "3/3 Build (cmake --build build)"
explain "WHY: compiles hello.cpp together with the server code from httplib.h."
set -x
cmake --build build
{ set +x; } 2>/dev/null

ok "Built build/hello-web. Next: ./run.sh"
