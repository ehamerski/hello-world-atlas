#!/bin/sh
# build.sh - Rust desktop: compile the program into target/release/hello-desktop
#
# WHAT: runs "cargo build --release --locked", which downloads the crates
#       listed in Cargo.lock (first build only), compiles them and
#       src/main.rs, and links everything into one executable file,
#       target/release/hello-desktop. The first build takes several minutes
#       (4 min 18 s on the dev machine): on macOS, eframe brings in 179 crates.
# WHY:  Rust is compiled ahead of time to machine code for your CPU and
#       operating system, like Go and C: the result runs without Rust
#       installed. Unlike Python, nothing is interpreted at run time; unlike
#       Java, there is no virtual machine.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.

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

ok "Built target/release/hello-desktop. Next: ./run.sh"
