#!/bin/sh
# run.sh - Smalltalk cli: run the Hello World program
#
# WHAT: runs hello.st, which prints exactly: Hello, World!
# WHY:  GNU Smalltalk (gst) is an interpreter. It reads hello.st and
#       evaluates each statement. Unlike compiled languages, there is no
#       separate build step.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check (for cli, same as normal run)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash) are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd gst "GNU Smalltalk runs this program."

step "Run the program"
explain "WHY: 'gst hello.st' starts the interpreter, which reads and evaluates the file."
gst hello.st
