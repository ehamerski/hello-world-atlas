#!/bin/sh
# build.sh - C web: compile hello.c and link it with libmicrohttpd into
#            bin/hello-web
#
# WHAT: runs
#         cc -std=c99 -pedantic-errors -Wall -Wextra $(pkg-config --cflags libmicrohttpd) \
#            -o bin/hello-web hello.c $(pkg-config --libs libmicrohttpd)
# WHY:  -std=c99 -pedantic-errors: only ISO C99, nothing compiler-specific.
#       This folder cannot use C89 like ../cli: microhttpd.h uses "long
#       long" and <stdint.h>, which C99 added (with -std=c89 the compiler
#       warns: "'long long' is an extension when C99 mode is not enabled").
#       pkg-config prints the flags for the library:
#         --cflags  -I<dir>: where the compiler finds microhttpd.h
#         --libs    -L<dir> -lmicrohttpd: where the linker finds the library
#       The library is linked dynamically: bin/hello-web loads
#       libmicrohttpd.dylib (.so on Linux) when it starts, so the library
#       must stay installed. Compare Go, which copies everything into the
#       executable.
# HOW:  ./build.sh             (after ./install.sh; run again after editing)
#       CC=gcc ./build.sh      use another compiler
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so hello.c is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

CC=${CC:-cc}

step "1/2 Check the compiler and the library"
explain "WHY: building needs a C compiler, pkg-config and libmicrohttpd; ./install.sh checks them."
fix_developer_dir
require_cmd "$CC" "The C compiler turns hello.c into an executable."
require_cmd pkg-config "pkg-config finds libmicrohttpd's flags."
pkg-config --exists libmicrohttpd || fail "libmicrohttpd was not found. Run ./install.sh first."

step "2/2 Compile hello.c as ISO C99 and link libmicrohttpd"
explain "WHY: -std=c99 -pedantic-errors rejects non-standard C (microhttpd.h needs C99's"
explain "     'long long'); pkg-config adds where microhttpd.h and the library are."
mkdir -p bin
# The pkg-config output is deliberately not quoted: it is a list of flags
# that the shell must split into separate words.
set -x
# shellcheck disable=SC2046
"$CC" -std=c99 -pedantic-errors -Wall -Wextra $(pkg-config --cflags libmicrohttpd) \
    -o bin/hello-web hello.c $(pkg-config --libs libmicrohttpd)
{ set +x; } 2>/dev/null

ok "Built bin/hello-web with libmicrohttpd $(pkg-config --modversion libmicrohttpd). Next: ./run.sh"
