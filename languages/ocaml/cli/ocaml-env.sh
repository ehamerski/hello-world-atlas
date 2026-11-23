# shellcheck shell=sh
# ocaml-env.sh - OCaml cli: which OCaml version and where it is, shared by
#                install.sh, build.sh and run.sh
#                (sourced, not run: it only sets variables)
#
# WHAT: sets OCAML_VERSION, OCAML_SOURCE_URL and OCAML_SOURCE_SHA256, and
#       puts the Homebrew bin folder first on PATH when it exists.
# WHY:  the scripts must find ocamlopt without your shell setup. Homebrew
#       installs it in <prefix>/bin (and brew itself lives there): /usr/local on macOS Intel, /opt/homebrew
#       on macOS Apple Silicon, /home/linuxbrew/.linuxbrew on Linux.
#
# OCAML_VERSION is the version of the Homebrew formula "ocaml" used here.
# OCAML_SOURCE_SHA256 is the SHA-256 digest of the source archive at
# OCAML_SOURCE_URL, as the formula lists it (version 5.5.2, checked on
# 2026-11-11). Homebrew verifies this digest before it builds. No Homebrew
# bottle is listed for macOS Intel, so Homebrew builds OCaml from that archive.
# The license is LGPL-2.1-only with the OCaml linking exception.
# Source: https://formulae.brew.sh/formula/ocaml

# shellcheck disable=SC2034  # these variables are used by install.sh
OCAML_VERSION=5.5.2
OCAML_SOURCE_URL=https://caml.inria.fr/pub/distrib/ocaml-5.5/ocaml-5.5.2.tar.xz
OCAML_SOURCE_SHA256=5503e1baad8b625da35f1fe71d47558014fa36253ae5f1a22cc3a18fab041e0d
for tf_brew_bin in /usr/local/bin /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
    if [ -x "$tf_brew_bin/ocamlopt" ] || [ -x "$tf_brew_bin/brew" ]; then
        PATH=$tf_brew_bin:$PATH
        export PATH
        break
    fi
done
