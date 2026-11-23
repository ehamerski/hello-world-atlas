#!/bin/sh
# install.sh - Racket cli: check (and optionally install) Racket 9.3
#
# WHAT: checks that Racket is installed in $RACKET_PREFIX (see racket-env.sh). If it is
#       missing, offers to download the project's Minimal Racket tarball, check its
#       SHA-256 digest, and unpack it into $RACKET_PREFIX. Nothing is downloaded or
#       installed without your "y", and sudo is never used.
# WHY:  Racket is interpreted from source: the racket program reads hello.rkt, compiles
#       the module in memory, and runs it. Minimal Racket is the smallest official
#       distribution. It has the racket and raco programs and the core libraries,
#       and that is all this program needs.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). The tarball is for
# macOS x86_64; macOS Apple Silicon, Linux and Windows (Git Bash / WSL) are documented
# but NOT verified and need another file from the same download page.
# The project publishes a SHA-256 digest on its release page and no signature.
# Source: https://download.racket-lang.org/releases/9.3/ (digest and URL in racket-env.sh)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# RACKET_VERSION, RACKET_FILE, RACKET_URL, RACKET_SHA256, RACKET_PREFIX, RACKET_BIN.
# shellcheck source=racket-env.sh
. ./racket-env.sh

# install_racket - download the tarball, check it, and unpack it into $RACKET_PREFIX (no sudo).
install_racket() {
    racket_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-racket
    explain "Download $RACKET_FILE (about 46 MB) from download.racket-lang.org into"
    explain "$racket_cache, check its SHA-256 digest, and unpack it into $RACKET_PREFIX."
    confirm "Install Racket $RACKET_VERSION now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    has_cmd curl || fail "curl is missing. Install it, then run this script again."
    has_cmd shasum || fail "shasum is missing; it checks the download."
    mkdir -p "$racket_cache"
    [ -f "$racket_cache/$RACKET_FILE" ] || curl -fL -o "$racket_cache/$RACKET_FILE" "$RACKET_URL"
    # The checksum proves the file is exactly the Racket 9.3 tarball from the release page.
    echo "$RACKET_SHA256  $racket_cache/$RACKET_FILE" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $racket_cache/$RACKET_FILE and retry."

    # Unpack to a temporary folder first, so a failed unpack never leaves a half-installed prefix.
    mkdir -p "$(dirname -- "$RACKET_PREFIX")"
    racket_tmp=$(mktemp -d "$(dirname -- "$RACKET_PREFIX")/.racket-unpack.XXXXXX")
    tar -xzf "$racket_cache/$RACKET_FILE" -C "$racket_tmp" \
        || { rm -rf "$racket_tmp"; fail "Unpacking failed. Delete $racket_cache/$RACKET_FILE and retry."; }
    mkdir -p "$RACKET_PREFIX"
    # The tarball holds one folder, racket/, which becomes $RACKET_PREFIX/racket.
    rm -rf "$RACKET_PREFIX/racket"
    mv "$racket_tmp/racket" "$RACKET_PREFIX/racket"
    rm -rf "$racket_tmp"
}

step "1/2 Check whether Racket is installed"
explain "WHY: hello.rkt is run by the racket program ($RACKET_BIN/racket)."
if [ -x "$RACKET_BIN/racket" ]; then
    ok "Racket found: $("$RACKET_BIN/racket" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "Racket is not installed in $RACKET_PREFIX."

step "2/2 Install Racket $RACKET_VERSION"
explain "WHY: the project distributes Racket as a tarball, so it is unpacked in your home folder (see racket-env.sh)."
case "$TF_OS" in
    macos-intel)
        install_racket ;;
    macos-arm|linux)
        fail "This script has the macOS Intel tarball only. Pick the file for your system at https://download.racket-lang.org/releases/$RACKET_VERSION/ and unpack it into $RACKET_PREFIX." ;;
    *)
        fail "This operating system is not verified. See https://download.racket-lang.org/releases/$RACKET_VERSION/" ;;
esac

[ -x "$RACKET_BIN/racket" ] || fail "'$RACKET_BIN/racket' was not found after unpacking. See the messages above."
ok "Racket $RACKET_VERSION is ready in $RACKET_PREFIX. Next: ./run.sh"
