#!/bin/sh
# build.sh - Rust cli: compile the program into target/release/hello-cli
#
# WHAT: runs "cargo build --release --locked", which compiles src/main.rs
#       into one executable file, target/release/hello-cli.
# WHY:  Rust is compiled ahead of time to machine code for your CPU and
#       operating system, like Go and C: the result runs without Rust
#       installed. Unlike Python, nothing is interpreted at run time; unlike
#       Java, there is no virtual machine.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so Cargo.toml is found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# Same PATH fix as install.sh: rustup installs into ~/.cargo/bin.
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"

step "1/2 Check the build tool"
explain "WHY: building needs cargo and rustc; ./install.sh installs them."
require_cmd cargo "cargo builds Rust packages."

step "2/2 Compile with 'cargo build --release --locked'"
explain "WHY: cargo reads Cargo.toml and calls rustc. '--release' turns on the"
explain "     optimizer (a faster program; a debug build goes to target/debug)."
explain "     '--locked' uses exactly the versions written in Cargo.lock."
cargo build --release --locked

ok "Built target/release/hello-cli. Next: ./run.sh"
