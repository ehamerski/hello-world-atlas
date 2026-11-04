#!/bin/sh
# build.sh - Haskell cli: compile hello.hs into bin/hello-cli
#
# WHAT: runs
#         ghc -O -outputdir build -o bin/hello-cli hello.hs
#       GHC compiles hello.hs to machine code and links it with the Haskell
#       runtime system (memory management, the scheduler for lightweight
#       threads) into bin/hello-cli.
# WHY:  Haskell is compiled ahead of time, like C, Go and Rust. The flags:
#         -O                optimize (the default is -O0, no optimization)
#         -outputdir build  put the intermediate files (Main.o, Main.hi,
#                           the module's "interface") in build/ instead of
#                           next to the source
#         -o bin/hello-cli  the name of the executable (default: hello)
#       One file with no libraries needs no build tool. ../web has
#       dependencies, so it uses Cabal instead.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       GHC=ghc-9.10 ./build.sh   use another ghc command
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.hs is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts ~/.ghcup/bin on PATH.
# shellcheck source=ghcup-env.sh
. ./ghcup-env.sh

GHC=${GHC:-ghc}

step "1/2 Check the compiler"
explain "WHY: building needs ghc; ./install.sh installs it."
# GHC calls the system C compiler and linker; on macOS, make sure they
# come from a working developer directory.
fix_developer_dir
require_cmd "$GHC" "GHC turns hello.hs into an executable."

step "2/2 Compile hello.hs"
explain "WHY: -O turns on the optimizer; -outputdir keeps the .o/.hi files in"
explain "     build/; -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$GHC" -O -outputdir build -o bin/hello-cli hello.hs
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $("$GHC" --version). Next: ./run.sh"
