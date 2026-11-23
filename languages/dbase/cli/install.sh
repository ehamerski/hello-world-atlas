#!/bin/sh
# install.sh - dBASE III Plus cli: check (and optionally install) Harbour 3.2.0
#
# WHAT: checks that hbmk2 (the Harbour build tool) is installed. If it is missing,
#       offers to download the official Harbour 3.2.0 source release, check its
#       SHA-256 digest, build it with make and install it into your home folder.
#       Nothing is installed without your "y", and sudo is never used.
# WHY:  dBASE III Plus (Ashton-Tate, 1980s) is proprietary DOS software, so it is not
#       installed here. Its .prg programs are compiled by Harbour, an open-source
#       xBase compiler that runs dBASE-style commands. See README.md, "Why this toolchain".
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). Linux (Debian/Ubuntu,
# build-essential) is documented and NOT verified for this implementation. Windows
# is NOT verified: this script stops and points to the official Windows build.
# Sources for the install steps: https://github.com/harbour/core/releases/tag/v3.2.0
# and https://github.com/harbour/core#how-to-build-and-install-harbour-from-source

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# HB_VERSION, HB_SRC_SHA256, HB_DIR.
# shellcheck source=harbour-env.sh
. ./harbour-env.sh

# build_harbour_from_source - download the Harbour 3.2.0 source release, check it,
# build it with make and install it into $HB_DIR (no sudo).
build_harbour_from_source() {
    hb_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-dbase
    hb_tar=harbour-$HB_VERSION.src.tar.gz
    hb_url="https://github.com/harbour/core/releases/download/v$HB_VERSION/$hb_tar"
    explain "Download $hb_tar (about 15 MB) from the Harbour project's GitHub releases"
    explain "into $hb_cache, check its SHA-256 digest, build it with make and install it"
    explain "into $HB_DIR (no sudo)."
    confirm "Build Harbour $HB_VERSION from source now (several minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd make || fail "'make' is missing. macOS: xcode-select --install; Linux: install build-essential."
    has_cmd cc || fail "No C compiler ('cc'). macOS: xcode-select --install; Linux: install build-essential."

    mkdir -p "$hb_cache"
    [ -f "$hb_cache/$hb_tar" ] || curl -fL -o "$hb_cache/$hb_tar" "$hb_url"
    # The checksum proves the file is exactly the Harbour release.
    echo "$HB_SRC_SHA256  $hb_cache/$hb_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $hb_cache/$hb_tar and retry."

    # The archive has no top folder, so unpack it into an empty temporary one.
    hb_src=$(mktemp -d)
    tar -xzf "$hb_cache/$hb_tar" -C "$hb_src"
    # HB_INSTALL_PREFIX puts the result in your home folder, not /usr/local.
    # HB_BUILD_CONTRIBS=no skips the optional contrib libraries (GUI, SSL, databases),
    # which Hello World does not need and which need extra system packages.
    (
        cd "$hb_src"
        make install HB_INSTALL_PREFIX="$HB_DIR" HB_BUILD_CONTRIBS=no
    ) || fail "Building Harbour failed. See the messages above."
    rm -rf "$hb_src"
    # Read harbour-env.sh again: it now puts $HB_DIR/bin on PATH.
    . ./harbour-env.sh
}

step "1/2 Check whether Harbour (hbmk2) is installed"
explain "WHY: hbmk2 compiles hello.prg (dBASE-style) into a program, through C."
# Harbour calls the C compiler; on macOS make sure that one works too.
fix_developer_dir
if has_cmd hbmk2; then
    # -build prints the Harbour build information, which starts with the version.
    ok "Harbour found: $(hbmk2 -build 2>&1 | grep -m 1 'Harbour') ($(command -v hbmk2))"
    exit 0
fi
warn "Harbour is not installed (no 'hbmk2' on PATH, nor in $HB_DIR/bin)."

step "2/2 Install Harbour $HB_VERSION"
explain "WHY: no package manager ships a current Harbour, so it is built from the official source."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        build_harbour_from_source ;;
    *)
        fail "Windows is not verified for this implementation. Get the Harbour Windows build from https://github.com/harbour/core/releases/tag/v$HB_VERSION" ;;
esac

has_cmd hbmk2 || fail "'hbmk2' is still not on PATH. Open a new terminal and retry."
ok "Harbour $HB_VERSION is ready in $HB_DIR. Next: ./build.sh"
