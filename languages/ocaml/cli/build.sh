#!/bin/sh
# build.sh - OCaml cli: compile hello.ml into a native program
#
# WHAT: runs ocamlopt on hello.ml and writes the program to build/hello.
# WHY:  ocamlopt is the OCaml native-code compiler: it turns the source into
#       machine code, so build/hello runs without the OCaml toolchain.
#       The "ocaml" command is a different tool, the toplevel (an interactive
#       loop that can also run a script), and the bytecode compiler is ocamlc.
#       ocamlopt writes its intermediate files (hello.cmi, hello.cmx,
#       hello.o) next to the source. Copying the source into build/ keeps
#       the source folder clean.
# HOW:  ./build.sh         (after ./install.sh; run again after editing hello.ml)
#
# Platforms: macOS Intel (verified on the development machine); macOS Apple
# Silicon, Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Source: https://ocaml.org/manual/5.5/native.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# shellcheck source=ocaml-env.sh
. ./ocaml-env.sh

# ocamlopt calls the C compiler and the assembler; make them usable on macOS.
fix_developer_dir

step "1/2 Check the compiler"
explain "WHY: building needs ocamlopt; ./install.sh installs it."
require_cmd ocamlopt "The OCaml native-code compiler is needed."

step "2/2 Compile hello.ml"
explain "WHY: the -o option names the executable (hello, written in build/)."
explain "     It compiles hello.ml to assembly, assembles it, and links it."
mkdir -p build
cp hello.ml build/hello.ml
(
    cd build
    ocamlopt -o hello hello.ml
)
rm -f build/hello.ml

[ -x build/hello ] || fail "ocamlopt did not produce build/hello. See the messages above."
ok "Build finished: build/hello. Next: ./run.sh"
