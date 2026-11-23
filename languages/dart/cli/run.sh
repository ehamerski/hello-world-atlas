#!/bin/sh
# run.sh - Dart cli: run the Hello World program
#
# WHAT: runs hello.dart, which prints exactly: Hello, World!
# WHY:  Dart can run source files directly (the `dart` command compiles to
#       an intermediate kernel format in memory, then runs it on the Dart VM).
#       There is no separate build step for a simple script.
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check (for cli, same as normal run)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash) are documented but NOT verified.

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

require_cmd dart "The Dart SDK runs this program."

step "Run the program"
explain "WHY: 'dart hello.dart' compiles and runs the file in one step."
dart hello.dart
