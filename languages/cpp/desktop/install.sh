#!/bin/sh
# install.sh - C++ desktop: check (and optionally install) c++, CMake and Qt 6
#
# WHAT: 1. checks for a C++ compiler ("c++");
#       2. checks for CMake;
#       3. checks that Qt 6 (the qtbase module, which contains Widgets) is
#          installed where CMake can find it.
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  standard C++ has no windows or graphics, so the window comes from a
#       library, Qt 6. Like C, C++ has no official package manager: the
#       library comes from the operating system's package manager. Only
#       qtbase is needed (Core, Gui, Widgets), not the whole Qt framework.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/qtbase
#   https://formulae.brew.sh/formula/cmake
#   https://packages.debian.org/stable/qt6-base-dev
#   https://packages.msys2.org/base/mingw-w64-qt6-base

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
    explain "    pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-qt6-base"
    explain "and add C:\\msys64\\ucrt64\\bin to PATH. Reopen Git Bash."
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
explain "WHY: Qt's build support is written for CMake (find_package(Qt6), qt_add_executable)."
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

step "3/3 Check whether Qt 6 (qtbase) is installed"
explain "WHY: Qt Widgets draws the window. CMake finds Qt through its Qt6Config.cmake file."
# qt6_config - print the path of Qt6Config.cmake, the file find_package(Qt6)
# in CMakeLists.txt looks for, if it is in one of the usual places.
qt6_config() {
    for qc_dir in ${CMAKE_PREFIX_PATH:-} "$(brew --prefix qtbase 2>/dev/null || true)" \
                  /usr/local /opt/homebrew /usr /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu; do
        for qc_file in "$qc_dir/lib/cmake/Qt6/Qt6Config.cmake" "$qc_dir/cmake/Qt6/Qt6Config.cmake"; do
            [ -f "$qc_file" ] && { echo "$qc_file"; return 0; }
        done
    done
    return 1
}
if qc_found=$(qt6_config); then
    ok "Qt 6 found: $qc_found"
    exit 0
fi
warn "Qt 6 was not found."
case "$TF_OS" in
    macos-*)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        # qtbase is the Qt module with Core, Gui and Widgets; the "qt"
        # formula would install every Qt module. Homebrew has no ready-made
        # (bottled) qtbase for Intel Macs, so there it is compiled from
        # source, which takes a long time.
        install_pkg "Qt 6 base (qtbase)" brew install qtbase || exit 1 ;;
    linux)
        install_pkg "Qt 6 base (qt6-base-dev)" sudo apt-get install -y qt6-base-dev || exit 1 ;;
    windows) windows_hint; exit 1 ;;
    *) fail "Unknown OS. Install Qt 6 from https://www.qt.io/download-open-source." ;;
esac
ok "Toolchain is ready. Next: ./build.sh"
