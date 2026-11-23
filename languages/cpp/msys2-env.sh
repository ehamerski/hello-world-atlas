# shellcheck shell=sh
# msys2-env.sh - C++: use MSYS2's UCRT64 toolchain on Windows (sourced by
#                install.sh, build.sh and run.sh; it does nothing elsewhere)
#
# WHAT: on Windows, puts C:\msys64\ucrt64\bin first on PATH, makes g++ the
#       compiler CMake uses (CXX) with the Ninja generator (CMAKE_GENERATOR),
#       and defines msys2_ensure, which installs missing MSYS2 packages
#       through install_pkg.
# WHY:  C has no package manager of its own. On Windows, GTK 4 and
#       libmicrohttpd come from MSYS2 (https://www.msys2.org/), which builds
#       every package with one compiler family. A program must be compiled
#       by that same family (UCRT64 gcc), or its libraries and DLLs do not
#       match. Git Bash does not know about MSYS2, and the machine may
#       already have other tools with the same names: GitHub's Windows
#       runners have a MinGW 'cc' and a pkg-config written in Perl (from
#       Strawberry Perl) that fails to start. Putting MSYS2 first on PATH
#       makes the right tool win, and also lets the program find the DLLs of
#       the libraries it was linked with when it runs.
#       CMake needs the same care: on a machine with Visual Studio it picks
#       the Visual Studio generator and MSVC by default, and MSVC rejects the
#       GCC-style flags (-Wextra) of CMakeLists.txt. CMAKE_GENERATOR and CXX
#       are the documented environment variables that choose them:
#       https://cmake.org/cmake/help/latest/envvar/CMAKE_GENERATOR.html
#       https://cmake.org/cmake/help/latest/envvar/CXX.html
#       MSYS2 is pre-installed on GitHub's Windows images, in C:\msys64 but
#       not on PATH:
#       https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md
# HOW:  . ../msys2-env.sh     (after . ../../../scripts/common.sh)
#       MSYS2_ROOT=/d/msys64 ./install.sh   if MSYS2 is not in C:\msys64
#
# Sources:
#   https://www.msys2.org/docs/environments/   (UCRT64 is the default; its tools live in ucrt64/bin)
#   https://www.msys2.org/docs/package-management/   (pacman -S, -Sy refreshes the package lists)
#   https://packages.msys2.org/   (package names: mingw-w64-ucrt-x86_64-<name>)

MSYS2_ROOT=${MSYS2_ROOT:-/c/msys64}
export MSYS2_ROOT

if [ "$TF_OS" = windows ]; then
    PATH="$MSYS2_ROOT/ucrt64/bin:$PATH"
    CXX=${CXX:-g++}
    CMAKE_GENERATOR=${CMAKE_GENERATOR:-Ninja}
    export PATH CXX CMAKE_GENERATOR
fi

# msys2_ensure "description" NAME... - make sure the MSYS2 UCRT64 packages
# mingw-w64-ucrt-x86_64-NAME are installed. Already installed: nothing
# happens. Otherwise the pacman command is shown and run by install_pkg
# (only with consent, or with TF_ASSUME_YES=1). It runs pacman inside MSYS2's
# own bash (-l: a login shell, which sets up MSYS2's PATH), because pacman
# needs the MSYS2 environment.
msys2_ensure() {
    me_desc=$1; shift
    [ -x "$MSYS2_ROOT/usr/bin/bash.exe" ] \
        || fail "MSYS2 was not found in $MSYS2_ROOT. Install it from https://www.msys2.org/ first."
    me_missing=''
    for me_name in "$@"; do
        # pacman -Q asks the local package database (no network).
        "$MSYS2_ROOT/usr/bin/bash.exe" -lc "pacman -Q mingw-w64-ucrt-x86_64-$me_name" >/dev/null 2>&1 \
            || me_missing="$me_missing mingw-w64-ucrt-x86_64-$me_name"
    done
    [ -z "$me_missing" ] && return 0
    # -S install, -y refresh the package lists first (a stale list can ask
    # for an old file that the mirrors no longer have), --needed skips what is
    # already installed, --noconfirm answers pacman's own questions.
    install_pkg "$me_desc (MSYS2 UCRT64)" \
        "$MSYS2_ROOT/usr/bin/bash.exe" -lc "pacman -Sy --noconfirm --needed$me_missing" || exit 1
}
