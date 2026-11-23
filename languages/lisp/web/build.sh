#!/bin/sh
# build.sh - Common Lisp web: build the executable bin/hello-web
#
# WHAT: starts SBCL and, in one session:
#         1. loads Quicklisp ($QUICKLISP_HOME/setup.lisp);
#         2. (ql:quickload :hunchentoot) downloads Hunchentoot and the
#            libraries it needs (first build only; they are kept in
#            $QUICKLISP_HOME/dists/), then compiles and loads them;
#         3. loads server.lisp;
#         4. saves the whole running Lisp system as bin/hello-web, with
#            HELLO-WEB:MAIN as its start-up function, as in ../cli.
# WHY:  the result is one executable that contains SBCL, Hunchentoot and
#       server.lisp, so ./run.sh needs neither Quicklisp nor the network.
#       Before loading Hunchentoot, the build adds :hunchentoot-no-ssl to
#       *FEATURES* (the list of features the reader checks for #+ and #-):
#       Hunchentoot then leaves out HTTPS support and the OpenSSL bindings
#       it would otherwise load, which a localhost Hello World does not need.
#       --non-interactive: exit when done (and on errors) instead of waiting
#       at the REPL; --no-sysinit --no-userinit: ignore init files, so the
#       build is the same on every computer.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so server.lisp is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QUICKLISP_HOME.
# shellcheck source=quicklisp-env.sh
. ../use-msys2-sbcl.sh
. ./quicklisp-env.sh

SBCL=${SBCL:-sbcl}

step "1/2 Check SBCL and Quicklisp"
explain "WHY: building needs sbcl and Quicklisp; ./install.sh installs both."
require_cmd "$SBCL" "SBCL compiles the libraries and server.lisp."
[ -f "$QUICKLISP_HOME/setup.lisp" ] \
    || fail "Quicklisp is not installed in $QUICKLISP_HOME (run ./install.sh first)."

step "2/2 Load Hunchentoot and server.lisp, save the image as bin/hello-web$EXE"
explain "WHY: quickload downloads Hunchentoot and the libraries it needs"
explain "     the first time; save-lisp-and-die writes everything into one executable."
mkdir -p bin
# set -x prints the exact command, so you can copy it.
set -x
"$SBCL" --non-interactive --no-sysinit --no-userinit \
    --eval '(push :hunchentoot-no-ssl *features*)' \
    --load "$QUICKLISP_NATIVE/setup.lisp" \
    --eval '(ql:quickload :hunchentoot)' \
    --load server.lisp \
    --eval '(sb-ext:save-lisp-and-die "bin/hello-web'"$EXE"'" :executable t :toplevel (function hello-web:main))'
{ set +x; } 2>/dev/null

ok "Built bin/hello-web$EXE with $("$SBCL" --version). Next: ./run.sh"
