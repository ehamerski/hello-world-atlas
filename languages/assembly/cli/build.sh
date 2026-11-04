#!/bin/sh
# build.sh - Assembly (x86-64) cli: assemble hello.asm and link bin/hello-cli
#
# WHAT: runs two commands:
#         nasm -f macho64 -o bin/hello.o hello.asm   (assemble)
#         cc -o bin/hello-cli bin/hello.o            (link)
# WHY:  assembling and linking are two separate steps, and here you see both
#       (a C compiler does them in one call and hides them):
#         nasm          translates each instruction into its machine-code
#                       bytes. -f macho64 picks the object format of 64-bit
#                       macOS (Mach-O); Linux would use -f elf64.
#         cc            does not compile anything here: given only an object
#                       file, it runs the linker (ld), which adds the C
#                       library (for write()) and the startup code that
#                       calls _main, and writes the executable.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine). On Apple Silicon the
# script builds an x86-64 program that runs under Rosetta (NOT verified).
# Linux and Windows need a different source (see README.md, "Platform notes").

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.asm is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/3 Check the target and the tools"
explain "WHY: assembly is machine-specific. hello.asm is written for an x86-64 CPU"
explain "     running macOS; other systems need other instructions or conventions."
case "$TF_OS" in
    macos-intel)
        ARCH_FLAGS='' ;;
    macos-arm)
        # The Apple Silicon CPU cannot run x86-64 code natively; asking the
        # linker for an x86_64 executable lets Rosetta translate it.
        warn "Apple Silicon: building an x86-64 program for Rosetta (not verified)."
        ARCH_FLAGS='-arch x86_64' ;;
    *)
        fail "hello.asm targets x86-64 macOS. See README.md, 'Platform notes', for $TF_OS." ;;
esac
fix_developer_dir
require_cmd nasm "NASM assembles hello.asm."
require_cmd cc "cc links the object file with the C library."

mkdir -p bin

step "2/3 Assemble hello.asm into bin/hello.o"
explain "WHY: the assembler turns each line of text into machine-code bytes."
explain "     -f macho64 = 64-bit Mach-O, the object format of macOS."
# set -x prints the exact command, so you can copy it.
set -x
nasm -f macho64 -o bin/hello.o hello.asm
{ set +x; } 2>/dev/null

step "3/3 Link bin/hello.o into bin/hello-cli"
explain "WHY: the object file still has an unresolved name (_write). The linker finds"
explain "     it in the C library and adds the startup code that calls _main."
set -x
# shellcheck disable=SC2086  # ARCH_FLAGS is empty or two words, on purpose
cc $ARCH_FLAGS -o bin/hello-cli bin/hello.o
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $(nasm -v | cut -d' ' -f1-3) and $(cc --version 2>&1 | head -n 1). Next: ./run.sh"
