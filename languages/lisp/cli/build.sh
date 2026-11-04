#!/bin/sh
# build.sh - Common Lisp cli: save hello.lisp as the executable bin/hello-cli
#
# WHAT: starts SBCL, loads hello.lisp (SBCL compiles each function to
#       machine code as it loads it), then saves the whole running Lisp
#       system, including MAIN, as one executable file:
#         sbcl --non-interactive --no-sysinit --no-userinit \
#              --load hello.lisp \
#              --eval '(sb-ext:save-lisp-and-die "bin/hello-cli"
#                        :executable t :toplevel (function main))'
# WHY:  a Lisp system is an "image": a memory full of functions and data
#       that you change while it runs. There is no separate link step as in
#       C. Instead, SBCL can dump its memory to a file ("save-lisp-and-die":
#       save, then exit). :executable t puts the SBCL runtime in the same
#       file, so it runs without SBCL installed; :toplevel names the
#       function to call at start-up. The options:
#         --non-interactive  exit when done (and on an error) instead of
#                            waiting at the REPL prompt
#         --no-sysinit --no-userinit  skip the system and personal
#                            init files, so the build is the same on every
#                            computer
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.lisp is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

SBCL=${SBCL:-sbcl}

step "1/2 Check SBCL"
explain "WHY: building needs sbcl; ./install.sh installs it."
require_cmd "$SBCL" "SBCL loads hello.lisp and saves the executable."

step "2/2 Load hello.lisp and save the image as bin/hello-cli"
explain "WHY: save-lisp-and-die writes the running Lisp system, with MAIN as its"
explain "     start-up function, into one executable file."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$SBCL" --non-interactive --no-sysinit --no-userinit \
    --load hello.lisp \
    --eval '(sb-ext:save-lisp-and-die "bin/hello-cli" :executable t :toplevel (function main))'
{ set +x; } 2>/dev/null

ok "Built bin/hello-cli with $("$SBCL" --version). Next: ./run.sh"
