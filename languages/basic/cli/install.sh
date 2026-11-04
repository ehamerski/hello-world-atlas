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
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
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

step "1/2 Check whether QB64-PE (qb64pe) is installed"
explain "WHY: qb64pe translates hello.bas into C++ and calls the C++ compiler"
explain "     to make a program for your computer."
# qb64pe calls clang++; on macOS make sure that one works too.
fix_developer_dir
if has_cmd "$QB64PE"; then
    # -v prints the version number and exits.
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
        # The Linux package's setup_lnx.sh installs the compiler and the
        # OpenGL/ALSA libraries with sudo apt/dnf/pacman, so it is left
        # for you to run, knowingly.
        explain "Download qb64pe_lnx-x64-$QB64PE_VERSION-GLFW.tar.gz from"
        explain "    https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v$QB64PE_VERSION-GLFW"
        explain "unpack it into $QB64PE_DIR and run ./setup_lnx.sh there"
        explain "(it installs g++, OpenGL and ALSA packages with sudo, then builds qb64pe)."
        exit 1 ;;
    windows)
        explain "Download qb64pe_win-x64-$QB64PE_VERSION-GLFW.7z from"
        explain "    https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v$QB64PE_VERSION-GLFW"
        explain "unpack it into a folder with full write permissions (as the QB64-PE"
        explain "README asks) and add that folder to PATH. Reopen Git Bash."
        exit 1 ;;
    *)
        fail "Unknown OS. See https://github.com/QB64-Phoenix-Edition/QB64pe#installation" ;;
esac

[ -x "$QB64PE" ] || fail "'$QB64PE' was not built. See the messages above."
ok "QB64-PE $QB64PE_VERSION is ready in $QB64PE_DIR. Next: ./build.sh"
