#!/bin/sh
# build.sh - C++ desktop: configure and build hello.cpp against Qt 6
#
# WHAT: runs the two CMake steps:
#         cmake -S . -B build -DCMAKE_BUILD_TYPE=Release   (configure)
#         cmake --build build                              (build)
#       and leaves the executable in build/hello-desktop.
# WHY:  "Configure" reads CMakeLists.txt, finds the compiler and Qt 6
#       (find_package(Qt6 ... Widgets)) and writes build files into build/.
#       "Build" compiles hello.cpp and links it with the Qt libraries.
#       Compare ../../c/desktop/build.sh, where pkg-config prints the GTK
#       flags and cc is called by hand.
# HOW:  ./build.sh                       (after ./install.sh)
#       CMAKE_PREFIX_PATH=/path/to/Qt ./build.sh   use a Qt installed elsewhere
#                                        (for example by Qt's online installer)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so CMakeLists.txt is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/3 Check the tools"
explain "WHY: building needs CMake, a C++ compiler and Qt 6; ./install.sh checks them."
fix_developer_dir
require_cmd cmake "CMake generates the build files."

step "2/3 Configure (cmake -S . -B build)"
explain "WHY: CMake finds Qt 6 through its Qt6Config.cmake file and writes the build"
explain "     files into build/. CMAKE_PREFIX_PATH (if set) tells it where else to look."
# set -x prints the exact command, so you can copy it.
set -x
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
{ set +x; } 2>/dev/null

step "3/3 Build (cmake --build build)"
explain "WHY: compiles hello.cpp and links it with Qt Widgets, Gui and Core."
set -x
cmake --build build
{ set +x; } 2>/dev/null

ok "Built build/hello-desktop. Next: ./run.sh"
