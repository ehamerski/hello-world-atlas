#!/bin/sh
# build.sh - Pascal cli: compile hello.pas into bin/hello-cli
#
# WHAT: runs
#         fpc -Miso -FEbin -FUbin -ohello-cli hello.pas
#       Free Pascal compiles hello.pas to machine code and links it with its
#       runtime library (the System unit) into bin/hello-cli.
# WHY:  Pascal is compiled ahead of time, like C and Fortran. The flags:
#         -Miso          ISO 7185 Standard Pascal mode (FPC's default
#                        dialect is its own, "fpc"); like -std=c89 in
#                        ../../c/cli
#         -FEbin         put the executable in bin/
#         -FUbin         put the compiled unit files (.o, .ppu) in bin/
#                        too, so the source folder stays clean
#         -ohello-cli    the name of the executable (default: hello,
#                        after the source file)
#       Unlike gcc, FPC also links, so no separate link step is needed.
# HOW:  ./build.sh                  (after ./install.sh; run again after editing)
#       FPC=/path/to/fpc ./build.sh   use another compiler
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.pas is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# Puts $FPC_DIR/bin on PATH if ./install.sh installed Free Pascal there.
# shellcheck source=fpc-env.sh
. ./fpc-env.sh

FPC=${FPC:-fpc}

step "1/2 Check the compiler"
explain "WHY: building needs Free Pascal; ./install.sh checks for it."
# On macOS FPC calls Apple's linker (ld); make sure it comes from a working
# developer directory.
fix_developer_dir
require_cmd "$FPC" "Free Pascal turns hello.pas into an executable."

step "2/2 Compile hello.pas as ISO 7185 Standard Pascal"
explain "WHY: -Miso selects Standard Pascal; -FE/-FU choose the output folders;"
explain "     -o names the executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$FPC" -Miso -FEbin -FUbin -ohello-cli hello.pas
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with Free Pascal $("$FPC" -iV). Next: ./run.sh"
