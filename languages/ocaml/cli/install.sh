#!/bin/sh
# install.sh - OCaml cli: check (and optionally install) the OCaml compiler
#
# WHAT: checks that ocamlopt, the OCaml native-code compiler, is installed and
#       is the version this folder pins (ocaml-env.sh). If it is missing,
#       shows the Homebrew command and runs it only if you answer "y".
#       Nothing is installed silently and sudo is never used.
# WHY:  build.sh compiles hello.ml with ocamlopt. The Homebrew formula "ocaml"
#       (version 5.5.2) provides it. Homebrew checks the SHA-256 of the source
#       archive before it builds (see ocaml-env.sh). No bottle is listed for
#       macOS Intel, so the install compiles OCaml from source and takes
#       several minutes.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands: https://formulae.brew.sh/formula/ocaml
# and https://ocaml.org/install

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# OCAML_VERSION and the Homebrew bin folder on PATH.
# shellcheck source=ocaml-env.sh
. ./ocaml-env.sh

step "1/2 Check whether the OCaml compiler (ocamlopt) is installed"
explain "WHY: build.sh needs ocamlopt to turn hello.ml into a native program."
if has_cmd ocamlopt; then
    have=$(ocamlopt -version)
    if [ "$have" = "$OCAML_VERSION" ]; then
        ok "ocamlopt $have found: $(command -v ocamlopt)"
    else
        warn "ocamlopt $have found, but this folder pins $OCAML_VERSION. The program should still build."
    fi
    exit 0
fi
warn "ocamlopt is not installed."

step "2/2 Install OCaml"
explain "WHY: Homebrew is the package manager this folder uses on macOS and Linux."
explain "     It downloads the source archive, checks its SHA-256 ($OCAML_SOURCE_SHA256),"
explain "     and builds it. The build takes several minutes on macOS Intel."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        install_pkg "OCaml $OCAML_VERSION (Homebrew formula ocaml)" brew install ocaml || exit 1 ;;
    *)
        fail "Install OCaml by hand: https://ocaml.org/install (this system is not verified for this implementation)." ;;
esac

# Homebrew may have put ocamlopt in a folder the env file did not know yet.
# shellcheck source=ocaml-env.sh
. ./ocaml-env.sh
has_cmd ocamlopt || fail "ocamlopt is still not on PATH. Open a new terminal and run ./install.sh again."
ok "OCaml $(ocamlopt -version) is ready. Next: ./build.sh"
