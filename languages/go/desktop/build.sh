#!/bin/sh
# build.sh - Go desktop: compile the program (and Fyne) into bin/hello-desktop
#
# WHAT: runs "go build -o bin/hello-desktop .". The first time, Go downloads
#       Fyne and the modules it needs (the exact versions are in go.mod and
#       go.sum), compiles them, compiles Fyne's C code with cgo, and links
#       everything into one executable, bin/hello-desktop.
# WHY:  Go compiles ahead of time to machine code, as in ../cli. The Go
#       linker copies every Go package the program uses, Fyne included, into
#       the one executable, so no Fyne files have to be installed to run it,
#       unlike ../../java/desktop, which needs the JavaFX jars next to the
#       JVM. Only the operating system's own libraries (Cocoa and OpenGL on
#       macOS) are loaded at run time.
#       The first build takes about a minute; later builds reuse Go's build
#       cache and take seconds.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so go.mod and main.go are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the build tools"
explain "WHY: building needs Go and a C compiler for cgo; ./install.sh checks both."
require_cmd go "The go command compiles the code."
# On macOS, make sure cgo finds a working clang (see scripts/common.sh).
fix_developer_dir

step "2/2 Download Fyne and compile with 'go build'"
explain "WHY: 'go build' reads go.mod, downloads the modules listed there into Go's module"
explain "     cache ($(go env GOMODCACHE)), checks them against go.sum, compiles"
explain "     Go and C code, and links bin/hello-desktop. The first build takes about a minute."
# macOS's linker may print "ld: warning: ignoring duplicate libraries: '-lobjc'".
# It is only a warning: two of Fyne's C files ask for the same system library.
go build -o bin/hello-desktop .

ok "Built bin/hello-desktop ($(go env GOOS)/$(go env GOARCH)). Next: ./run.sh"
