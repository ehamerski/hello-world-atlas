#!/bin/sh
# install.sh - BASIC cli: check (and optionally install) QB64 Phoenix Edition
#
# WHAT: checks that qb64pe, the QB64 Phoenix Edition compiler, is
#       installed. If it is missing, offers to download its official
#       release and build it into ~/.local/qb64pe-4.7.0 (see
#       qb64pe-env.sh), and does it only if you answer "y". Nothing is
#       installed silently and sudo is never used.
# WHY:  QB64-PE compiles QBasic / QuickBASIC 4.5 programs to native
#       executables (see README.md, "Why this toolchain"). It translates
#       BASIC into C++ and then calls a C++ compiler, so it needs one:
#       on macOS, Apple's Command Line Tools (clang++).
#       QB64-PE is not in Homebrew. Its macOS download is a source package
#       that is compiled on your Mac with "make" (this is what the
#       project's own setup_osx.command does, but that script also
#       opens the editor afterwards, so this script calls make directly).
#       On the development machine the build took about 1 minute (2026-11-01).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); Linux and
# Windows (Git Bash) verified in CI; macOS Apple Silicon and WSL are
# documented but NOT verified.
# Sources for the install commands:
#   https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW
#   https://github.com/QB64-Phoenix-Edition/QB64pe#installation

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm,
# fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QB64PE_VERSION, QB64PE_SHA256, QB64PE_DIR, QB64PE.
# shellcheck source=qb64pe-env.sh
. ./qb64pe-env.sh

# build_qb64pe_macos - macOS: download the official QB64-PE package for
# macOS, check it, unpack it into $QB64PE_DIR and compile it there.
build_qb64pe_macos() {
    qb_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-basic
    qb_tar=qb64pe_osx-$QB64PE_VERSION-GLFW.tar.gz
    qb_url="https://github.com/QB64-Phoenix-Edition/QB64pe/releases/download/v$QB64PE_VERSION-GLFW/$qb_tar"
    explain "Download $qb_tar (about 9 MB) from the QB64-PE project's GitHub"
    explain "releases into $qb_cache; check its SHA-256 checksum, unpack it"
    explain "into $QB64PE_DIR and compile it there with make (no sudo)."
    confirm "Build QB64-PE $QB64PE_VERSION now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd clang++ || fail "Apple's C++ compiler is missing. Run: xcode-select --install"

    mkdir -p "$qb_cache"
    [ -f "$qb_cache/$qb_tar" ] || curl -fL -o "$qb_cache/$qb_tar" "$qb_url"
    # The checksum proves the file is exactly the QB64-PE release.
    echo "$QB64PE_SHA256  $qb_cache/$qb_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $qb_cache/$qb_tar and retry."

    # The archive holds one folder, qb64pe/; strip it so its files land
    # directly in $QB64PE_DIR.
    rm -rf "$QB64PE_DIR"
    mkdir -p "$QB64PE_DIR"
    tar -xzf "$qb_cache/$qb_tar" -C "$QB64PE_DIR" --strip-components 2
    # The same command setup_osx.command runs: OS=osx selects the macOS
    # settings and BUILD_QB64=y builds the qb64pe compiler/editor itself.
    # -j3 runs 3 compile jobs at once, like the project's script.
    (
        cd "$QB64PE_DIR"
        make OS=osx BUILD_QB64=y -j3
    ) || fail "Building QB64-PE failed. See the messages above."
    # Read qb64pe-env.sh again: it now finds $QB64PE_DIR/qb64pe.
    . ./qb64pe-env.sh
}

# install_qb64pe_libs_linux - Linux only: the compiler and the libraries
# QB64-PE needs, to build it and to run it (qb64pe itself links libGLU).
install_qb64pe_libs_linux() {
    install_pkg "the compiler and libraries QB64-PE needs (OpenGL, ALSA, X11, libpng, libcurl)" \
        sudo apt-get install -y build-essential x11-utils mesa-common-dev libglu1-mesa-dev \
        libasound2-dev libpng-dev libcurl4-openssl-dev libx11-dev libxcursor-dev \
        libxrandr-dev libxinerama-dev libxi-dev || exit 1
}

# build_qb64pe_linux - Linux only: the same recipe as macOS (download the
# source package, check it, unpack it, run make), after installing the
# libraries QB64-PE needs. The package list is the Debian/Ubuntu one from
# the release's own setup_lnx.sh.
build_qb64pe_linux() {
    qb_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-basic
    qb_tar=qb64pe_lnx-x64-$QB64PE_VERSION-GLFW.tar.gz
    qb_url="https://github.com/QB64-Phoenix-Edition/QB64pe/releases/download/v$QB64PE_VERSION-GLFW/$qb_tar"
    install_qb64pe_libs_linux
    explain "Download $qb_tar (about 9 MB) from the QB64-PE project's GitHub"
    explain "releases into $qb_cache; check its SHA-256 checksum, unpack it"
    explain "into $QB64PE_DIR and compile it there with make (no sudo)."
    confirm "Build QB64-PE $QB64PE_VERSION now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$qb_cache"
    [ -f "$qb_cache/$qb_tar" ] || curl -fL -o "$qb_cache/$qb_tar" "$qb_url"
    echo "$QB64PE_SHA256_LNX  $qb_cache/$qb_tar" | sha256sum -c - \
        || fail "Checksum mismatch: delete $qb_cache/$qb_tar and retry."

    rm -rf "$QB64PE_DIR"
    mkdir -p "$QB64PE_DIR"
    tar -xzf "$qb_cache/$qb_tar" -C "$QB64PE_DIR" --strip-components 2
    # What setup_lnx.sh runs after installing the packages: OS=lnx selects
    # the Linux settings, BUILD_QB64=y builds the qb64pe compiler itself.
    (
        cd "$QB64PE_DIR"
        make OS=lnx BUILD_QB64=y -j3
    ) || fail "Building QB64-PE failed. See the messages above."
    . ./qb64pe-env.sh
}

# install_qb64pe_windows - Windows only: the release is a 7-Zip archive that
# already holds qb64pe.exe and a MinGW compiler, so it is only unpacked.
# 7-Zip is pre-installed on GitHub's Windows images
# (https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md).
install_qb64pe_windows() {
    qb_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-basic
    qb_7z=qb64pe_win-x64-$QB64PE_VERSION-GLFW.7z
    qb_url="https://github.com/QB64-Phoenix-Edition/QB64pe/releases/download/v$QB64PE_VERSION-GLFW/$qb_7z"
    if has_cmd 7z; then qb_unpack=7z
    elif [ -x "/c/Program Files/7-Zip/7z.exe" ]; then qb_unpack="/c/Program Files/7-Zip/7z.exe"
    else fail "7-Zip was not found. Install it from https://www.7-zip.org/ and retry."; fi
    explain "Download $qb_7z (about 100 MB) from the QB64-PE project's GitHub"
    explain "releases into $qb_cache; check its SHA-256 checksum and unpack it into"
    explain "$QB64PE_DIR (QB64-PE needs a folder it can write to)."
    confirm "Install QB64-PE $QB64PE_VERSION now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$qb_cache"
    [ -f "$qb_cache/$qb_7z" ] || curl -fL -o "$qb_cache/$qb_7z" "$qb_url"
    echo "$QB64PE_SHA256_WIN  $qb_cache/$qb_7z" | sha256sum -c - \
        || fail "Checksum mismatch: delete $qb_cache/$qb_7z and retry."

    qb_tmp=$QB64PE_DIR.unpack
    rm -rf "$QB64PE_DIR" "$qb_tmp"
    mkdir -p "$qb_tmp"
    # cygpath -w: 7-Zip is a Windows program and wants C:\... paths.
    "$qb_unpack" x -y -bso0 -bsp0 "-o$(cygpath -w "$qb_tmp")" "$(cygpath -w "$qb_cache/$qb_7z")" \
        || fail "Unpacking $qb_7z failed."
    # The archive holds one folder with qb64pe.exe in it; keep that folder.
    qb_exe=$(find "$qb_tmp" -maxdepth 2 -name qb64pe.exe | head -n 1)
    [ -n "$qb_exe" ] || fail "qb64pe.exe was not found in $qb_7z."
    mv "$(dirname "$qb_exe")" "$QB64PE_DIR"
    rm -rf "$qb_tmp"
    . ./qb64pe-env.sh
}

step "1/2 Check whether QB64-PE (qb64pe) is installed"
explain "WHY: qb64pe translates hello.bas into C++ and calls the C++ compiler"
explain "     to make a program for your computer."
# qb64pe calls clang++; on macOS make sure that one works too.
fix_developer_dir
if has_cmd "$QB64PE"; then
    # -v prints the version number and exits. It fails when qb64pe cannot
    # start, for example on Linux when the libraries it was built against
    # have been removed: then they are installed again (no new build).
    if ! "$QB64PE" -v >/dev/null 2>&1 && [ "$TF_OS" = linux ]; then
        warn "QB64-PE does not start: $("$QB64PE" -v 2>&1 | head -n 1)"
        install_qb64pe_libs_linux
    fi
    "$QB64PE" -v >/dev/null 2>&1 \
        || fail "QB64-PE does not start: $("$QB64PE" -v 2>&1 | head -n 1)"
    ok "QB64-PE found: $("$QB64PE" -v 2>&1 | head -n 1) ($(command -v "$QB64PE"))"
    exit 0
fi
warn "QB64-PE is not installed (no 'qb64pe' on PATH, nor in $QB64PE_DIR)."

step "2/2 Install QB64-PE $QB64PE_VERSION"
explain "WHY: QB64-PE is not in any package manager; its official release is"
explain "     compiled on your computer (see qb64pe-env.sh)."
case "$TF_OS" in
    macos-intel|macos-arm)
        build_qb64pe_macos ;;
    linux)
        build_qb64pe_linux ;;
    windows)
        install_qb64pe_windows ;;
    *)
        fail "Unknown OS. See https://github.com/QB64-Phoenix-Edition/QB64pe#installation" ;;
esac

[ -x "$QB64PE" ] || fail "'$QB64PE' was not built. See the messages above."
ok "QB64-PE $QB64PE_VERSION is ready in $QB64PE_DIR. Next: ./build.sh"
