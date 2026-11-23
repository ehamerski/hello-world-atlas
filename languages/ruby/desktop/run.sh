#!/bin/sh
# run.sh - Ruby desktop: open the Hello World window
#
# WHAT: runs hello.rb, which opens a window that shows: Hello, World!
# WHY:  like the cli version, Ruby runs hello.rb directly (no build step).
#       The window itself is drawn by the Tk toolkit, which Ruby reaches
#       through the tk gem. "bundle exec" runs Ruby with exactly the gems
#       that Gemfile.lock lists, from vendor/bundle.
# HOW:  ./run.sh            open the window; close it to end the program
#       ./run.sh --verify   self-check used by scripts/verify-all.sh: the app
#                           prints "Hello, World!" once its window is shown
#                           and closes itself after about 2 seconds
#       RUBY=ruby3.4 ./run.sh   use another interpreter command
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# A desktop app needs a graphical session: it cannot open a window over a
# plain SSH connection or in a CI job without a display.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so Gemfile and hello.rb are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd, is_verify.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Ruby (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-ruby.sh
. ../use-msys2-ruby.sh

RUBY=${RUBY:-ruby}
require_cmd "$RUBY" "Ruby runs this program."
require_cmd bundle "Bundler starts Ruby with the project's gems."
bundle exec "$RUBY" -e 'require "tk"' 2>/dev/null \
    || fail "The tk gem is not installed. Run ./install.sh first."

step "Open the Hello World window"
explain "WHY: Ruby/Tk asks Tk to create a native window; Tk.mainloop keeps it open."
if is_verify "$@"; then
    # TF_VERIFY=1 switches on the self-check inside hello.rb.
    TF_VERIFY=1 bundle exec "$RUBY" hello.rb
else
    explain "Close the window (or press Ctrl+C here) to end the program."
    bundle exec "$RUBY" hello.rb
fi
