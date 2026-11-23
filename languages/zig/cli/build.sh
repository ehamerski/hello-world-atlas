#!/bin/sh
# build.sh - Zig cli: compile the program
#
# WHAT: turns hello.zig into the native program build/hello.
# WHY:  the computer cannot run Zig source directly; the compiler (zig build-exe)
#       translates it into machine code first. The flags are:
#         -femit-bin=build/hello   write the executable to build/hello
#         --cache-dir build/cache  keep the compiler's local cache in build/ too, so this
#                                  folder is the only one the build writes in
#       The default optimization mode is Debug (zig build-exe --help, option -O).
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.zig)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented and NOT verified.
# Source for the flags: zig build-exe --help (Zig 0.17.0).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# ZIG, and PATH with the Zig folder first.
# shellcheck source=zig-env.sh
. ./zig-env.sh

step "1/2 Check the compiler"
explain "WHY: building needs zig; ./install.sh installs it."
require_cmd "$ZIG" "Zig is needed to compile."

step "2/2 Compile hello.zig"
explain "WHY: zig build-exe compiles one file into a program; -femit-bin names the output file."
mkdir -p build
"$ZIG" build-exe hello.zig -femit-bin=build/hello --cache-dir build/cache

ok "Build finished: build/hello. Next: ./run.sh"
