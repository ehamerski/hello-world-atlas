#!/bin/sh
# install.sh - Dart web: check (and optionally install) the Dart SDK
#
# WHAT: checks that the Dart SDK is installed. If it is missing, shows the
#       official install command for your operating system and runs it only
#       if you answer "y". Nothing is installed silently and sudo is never
#       hidden.
# WHY:  Dart is a compiled language: server.dart is run by the `dart` command,
#       which includes the Dart VM and the frontend compiler. The web version
#       uses only dart:io, which is part of the standard library — no packages.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash) are documented but NOT verified.
# Sources for the install commands:
#   https://dart.dev/get-dart
#   https://formulae.brew.sh/formula/dart-sdk

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

TOOL="dart"
TOOL_NAME="Dart SDK"

step "1/2 Check whether $TOOL_NAME is installed"
explain "WHY: server.dart is run by the Dart VM ('$TOOL')."
if has_cmd "$TOOL"; then
    ok "$TOOL_NAME found: $("$TOOL" --version 2>&1 | head -n 1)"
    exit 0
fi
warn "$TOOL_NAME is not installed."

step "2/2 Install $TOOL_NAME"
explain "WHY: the Dart SDK includes the VM, compiler and standard library."
case "$TF_OS" in
    macos-intel|macos-arm)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "$TOOL_NAME" brew install dart-sdk ;;
    linux)
        # The Dart team provides an APT repository (dart.dev/get-dart).
        # Debian/Ubuntu: save Google's signing key to a file, add it and the
        # repository, then install.
        dart_key=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-dart/linux_signing_key.pub
        install_pkg "apt-transport-https" sudo apt-get install -y apt-transport-https || exit 1
        install_pkg "Google's signing key (download only)" \
            curl -fsSL --create-dirs https://dl-ssl.google.com/linux/linux_signing_key.pub -o "$dart_key" || exit 1
        # Google publishes the primary key's fingerprint, not a digest of the file:
        # the file changes when Google adds a rotated signing subkey.
        # Source: https://www.google.com/linuxrepositories/
        has_cmd gpg || fail "gpg is missing. Install it with: sudo apt-get install gnupg"
        gpg --show-keys --with-colons "$dart_key" 2>/dev/null \
            | grep -q '^fpr:*EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796:' \
            || fail "$dart_key is not Google's signing key (fingerprint mismatch)."
        ok "Key fingerprint matches Google's: EB4C 1BFD 4F04 2F6D DDCC EC91 7721 F63B D38B 4796"
        explain "The key is saved in $dart_key; 'gpg --show-keys $dart_key' shows it."
        install_pkg "the Dart APT key" sudo gpg --yes --dearmor -o /usr/share/keyrings/dart.gpg "$dart_key" || exit 1
        install_pkg "the Dart repository" sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list' || exit 1
        install_pkg "$TOOL_NAME" sh -c 'sudo apt-get update && sudo apt-get install -y dart' || exit 1 ;;
    windows)
        explain "On Windows run this in PowerShell:"
        explain "    winget install --id Google.DartSDK"
        exit 1 ;;
    *)
        fail "Unknown OS. Install $TOOL_NAME by hand: https://dart.dev/get-dart" ;;
esac

has_cmd "$TOOL" || fail "$TOOL_NAME is still not on PATH. Open a new terminal and retry."
ok "$TOOL_NAME is ready. Next: ./run.sh"
