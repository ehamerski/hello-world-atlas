#!/bin/sh
# run.sh - Ruby cli: run the Hello World program
#
# WHAT: runs hello.rb, which prints exactly: Hello, World!
# WHY:  Ruby is an interpreted language. There is no build.sh: the ruby
#       program reads hello.rb and runs it directly. (The reference
#       implementation, CRuby, does compile the code to bytecode in memory
#       first, but that happens automatically each time, so you never run a
#       separate compile step.)
# HOW:  ./run.sh            run it
#       ./run.sh --verify   self-check used by scripts/verify-all.sh (for a
#                           cli program it does the same thing)
#       RUBY=ruby3.4 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so "hello.rb" is found from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, has_cmd, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Ruby (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-ruby.sh
. ../use-msys2-ruby.sh

RUBY=${RUBY:-ruby}
require_cmd "$RUBY" "Ruby runs this program."

step "Run the program"
explain "WHY: '$RUBY hello.rb' starts the interpreter, which runs the file top to bottom."
"$RUBY" hello.rb
