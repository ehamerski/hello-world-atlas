#!/bin/sh
# build.sh - C desktop: compile hello.c and link it with GTK 4 into
#            bin/hello-desktop
#
# WHAT: runs
#         cc -std=c99 -pedantic -Wall -Wextra <GTK's -I flags, as -isystem> \
#            -o bin/hello-desktop hello.c $(pkg-config --libs gtk4)
# WHY:  -std=c99 -pedantic: ISO C99 only; the compiler warns about anything
#       compiler-specific. This folder cannot use C89 like ../cli: GTK's
#       headers (and GLib's, under them) are not valid C89.
#       pkg-config prints the flags for GTK and every library it depends on:
#         --cflags  -I<dir> for each folder with headers (GTK, GLib, Pango,
#                   Cairo, HarfBuzz, ...)
#         --libs    -L<dir> -lgtk-4 -lglib-2.0 ... for the linker
#       -isystem instead of -I: GTK 4.24's own headers use a few C11
#       features, so -pedantic would print dozens of warnings about them.
#       Folders given with -isystem are "system headers", whose warnings
#       the compiler leaves out; hello.c itself is still checked.
#       (https://gcc.gnu.org/onlinedocs/cpp/System-Headers.html; clang
#       accepts the same flag.)
#       Those libraries are linked dynamically: bin/hello-desktop loads them
#       when it starts, so GTK must stay installed. Compare Go's Fyne
#       (../../go/desktop), which is copied into the executable.
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
# PKG_CONFIG_PATH, so a GTK built by install.sh is found too.
# shellcheck source=gtk4-env.sh
. ./gtk4-env.sh

CC=${CC:-cc}

step "1/2 Check the compiler and GTK"
explain "WHY: building needs a C compiler, pkg-config and GTK 4; ./install.sh checks them."
fix_developer_dir
require_cmd "$CC" "The C compiler turns hello.c into an executable."
require_cmd pkg-config "pkg-config finds GTK's flags."
pkg-config --exists gtk4 || fail "GTK 4 was not found. Run ./install.sh first."

step "2/2 Compile hello.c as ISO C99 and link GTK $(pkg-config --modversion gtk4)"
explain "WHY: -std=c99 -pedantic keeps to standard C (GTK's headers need C99); pkg-config"
explain "     adds where GTK's headers and libraries are."
mkdir -p bin
# The pkg-config output is deliberately not quoted: it is a list of flags
# that the shell must split into separate words.
# The sed turns each -I<dir> into -isystem <dir> (see WHY above).
gtk_cflags=$(pkg-config --cflags gtk4 | sed -e 's/^-I/-isystem /' -e 's/ -I/ -isystem /g')
set -x
# shellcheck disable=SC2046,SC2086
"$CC" -std=c99 -pedantic -Wall -Wextra $gtk_cflags \
    -o bin/hello-desktop hello.c $(pkg-config --libs gtk4)
{ set +x; } 2>/dev/null

ok "Built bin/hello-desktop. Next: ./run.sh"
