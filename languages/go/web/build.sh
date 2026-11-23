#!/bin/sh
# build.sh - Go web: compile the web server into bin/hello-web
#
# WHAT: runs "go build -o bin/hello-web .", which compiles every .go file of
#       the package in this folder (here only main.go), together with the
#       parts of the standard library it uses (net/http, html/template),
#       into one executable file, bin/hello-web.
# WHY:  Go is compiled ahead of time to machine code for your CPU and
#       operating system. Unlike Java there is no virtual machine and no
#       .jar: the result is a native program, like a C program, that runs
#       without Go installed. Unlike Python, nothing is interpreted at run time.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so go.mod and main.go are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/2 Check the build tool"
explain "WHY: building needs the Go toolchain; ./install.sh installs it."
require_cmd go "The go command compiles the code."

step "2/2 Compile with 'go build'"
explain "WHY: 'go build' reads go.mod (the module's name and Go version), compiles"
explain "     package main and links it into one executable. '-o bin/hello-web' names"
explain "     the output file; '.' means: the package in this folder."
go build -o bin/hello-web .

ok "Built bin/hello-web ($(go env GOOS)/$(go env GOARCH)). Next: ./run.sh"
