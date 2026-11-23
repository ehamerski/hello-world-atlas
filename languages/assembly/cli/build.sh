#!/bin/sh
# build.sh - Assembly (x86-64) cli: assemble hello.asm and link bin/hello-cli
#
# WHAT: runs two commands (macOS shown; Linux and Windows use their own
#       source file, object format and linker, chosen below):
#         nasm -f macho64 -o bin/hello.o hello.asm   (assemble)
#         cc -o bin/hello-cli bin/hello.o            (link)
# WHY:  assembling and linking are two separate steps, and here you see both
#       (a C compiler does them in one call and hides them):
#         nasm          translates each instruction into its machine-code
#                       bytes. -f picks the object format: macho64 for
#                       macOS (Mach-O), elf64 for Linux, win64 for Windows.
#         cc            does not compile anything here: given only an object
#                       file, it runs the linker (ld), which adds the C
#                       library (for write()) and the startup code that
#                       calls _main (main on Linux and Windows), and writes
#                       the executable.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine). On Apple Silicon the
# script builds an x86-64 program that runs under Rosetta (NOT verified).
# Linux (hello_linux.asm) and Windows (hello_windows.asm, MSYS2's NASM and gcc)
# are checked by GitHub Actions (.github/workflows/ci-matrix.yml).

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.asm is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows: MSYS2's UCRT64 tools (nasm, gcc) first on PATH (no effect elsewhere).
# shellcheck source=../msys2-env.sh
. ../msys2-env.sh

step "1/3 Check the target and the tools"
explain "WHY: assembly is machine-specific. hello.asm is written for an x86-64 CPU"
explain "     running macOS; other systems need other instructions or conventions"
explain "     (hello_linux.asm, hello_windows.asm)."
# SOURCE, NASM_FORMAT and LINKER are what differ between operating systems:
# the source file (calling convention, symbol names), the object file format
# and the linker driver. The macOS values are the defaults.
SOURCE=hello.asm
NASM_FORMAT=macho64
FORMAT_NOTE='64-bit Mach-O, the object format of macOS'
LINKER=cc
case "$TF_OS" in
    macos-intel)
        ARCH_FLAGS='' ;;
    macos-arm)
        # The Apple Silicon CPU cannot run x86-64 code natively; asking the
        # linker for an x86_64 executable lets Rosetta translate it.
        warn "Apple Silicon: building an x86-64 program for Rosetta (not verified)."
        ARCH_FLAGS='-arch x86_64' ;;
    linux)
        ARCH_FLAGS=''
        SOURCE=hello_linux.asm
        NASM_FORMAT=elf64
        FORMAT_NOTE='64-bit ELF, the object format of Linux' ;;
    windows)
        ARCH_FLAGS=''
        SOURCE=hello_windows.asm
        NASM_FORMAT=win64
        FORMAT_NOTE='64-bit COFF, the object format of Windows'
        # MSYS2's gcc, not a 'cc' from another distribution (see ../msys2-env.sh).
        LINKER=gcc ;;
    *)
        fail "No assembly source for $TF_OS (hello.asm is x86-64 macOS). See README.md, 'Platform notes'." ;;
esac
fix_developer_dir
require_cmd nasm "NASM assembles hello.asm."
require_cmd "$LINKER" "$LINKER links the object file with the C library."

mkdir -p bin

step "2/3 Assemble $SOURCE into bin/hello.o"
explain "WHY: the assembler turns each line of text into machine-code bytes."
explain "     -f $NASM_FORMAT = $FORMAT_NOTE."
# set -x prints the exact command, so you can copy it.
set -x
nasm -f "$NASM_FORMAT" -o bin/hello.o "$SOURCE"
{ set +x; } 2>/dev/null

step "3/3 Link bin/hello.o into bin/hello-cli"
explain "WHY: the object file still has an unresolved name (_write). The linker finds"
explain "     it in the C library and adds the startup code that calls _main (main on Linux and Windows)."
set -x
# shellcheck disable=SC2086  # ARCH_FLAGS is empty or two words, on purpose
$LINKER $ARCH_FLAGS -o bin/hello-cli bin/hello.o
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $(nasm -v | cut -d' ' -f1-3) and $("$LINKER" --version 2>&1 | head -n 1). Next: ./run.sh"
