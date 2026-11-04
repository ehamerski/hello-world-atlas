#!/bin/sh
# build.sh - Haskell web: download the libraries and compile with Cabal
#
# WHAT: 1. "cabal update" downloads the index of Hackage, the Haskell package
#          repository (the list of every package and version);
#       2. "cabal build" reads hello-web.cabal and cabal.project.freeze,
#          downloads Scotty and every package it needs (first build only),
#          compiles them and app/Main.hs, and links the executable
#          hello-web inside dist-newstyle/.
# WHY:  unlike ../cli, this program uses libraries, so it needs a build
#       tool, the way Rust uses Cargo and Java uses Maven. Cabal keeps the
#       compiled libraries in a shared store in your home folder (on macOS
#       ~/.cabal/store, or ~/.local/state/cabal/store with the XDG layout),
#       so other projects reuse them.
#       cabal.project.freeze pins the exact version of every package (like
#       Cargo.lock or package-lock.json), so every student builds the same
#       code. The first build downloads and compiles the libraries and takes
#       a while; later builds only recompile Main.hs.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello-web.cabal is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts ~/.ghcup/bin on PATH.
# shellcheck source=ghcup-env.sh
. ./ghcup-env.sh

CABAL=${CABAL:-cabal}

step "1/3 Check the build tools"
explain "WHY: building needs cabal and ghc; ./install.sh installs them."
# GHC calls the system C compiler and linker, and some packages contain C
# code; on macOS, make sure they come from a working developer directory.
fix_developer_dir
require_cmd "$CABAL" "Cabal downloads the libraries and builds the program."
require_cmd ghc "Cabal calls GHC to compile."

step "2/3 Update the Hackage package index"
explain "WHY: Cabal needs the list of packages and versions on Hackage to find"
explain "     Scotty and its dependencies. The first download is large; later"
explain "     updates only fetch what changed."
"$CABAL" update

step "3/3 Build with 'cabal build'"
explain "WHY: Cabal downloads and compiles every package pinned in"
explain "     cabal.project.freeze, then compiles app/Main.hs."
"$CABAL" build

# list-bin prints the path of the executable inside dist-newstyle/.
ok "Built $("$CABAL" list-bin hello-web). Next: ./run.sh"
