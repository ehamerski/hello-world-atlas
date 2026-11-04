#!/bin/sh
# install.sh - Rust desktop: check (and optionally install) the Rust toolchain
#
# WHAT: checks that rustc (the compiler) and cargo (the build tool and
#       package manager) are installed and that Rust is 1.95 or newer. If
#       not, shows the official rustup install command and runs it only if
#       you answer "y". Nothing is installed silently and sudo is never used.
# WHY:  Rust is compiled. cargo drives everything: it reads Cargo.toml,
#       downloads the dependencies (eframe, egui and the crates they use) and
#       calls rustc. eframe 0.37 needs Rust 1.95 or newer (its
#       rust-version, copied into this folder's Cargo.toml).
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.
# Sources for the install commands:
#   https://www.rust-lang.org/tools/install
#   https://rust-lang.github.io/rustup/installation/index.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

# The oldest Rust this code builds with (rust-version in Cargo.toml).
RUST_MIN_MINOR=95

# rustup installs into ~/.cargo/bin. A terminal opened before the install
# does not have it on PATH yet, so add it for this script if it exists.
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"

# rust_ok succeeds if cargo and rustc are on PATH and rustc is 1.95 or newer.
# "rustc --version" prints e.g. "rustc 1.98.1 (48a229cea 2026-09-01)";
# sed keeps the minor number (98).
rust_ok() {
    has_cmd cargo && has_cmd rustc || return 1
    rust_minor=$(rustc --version 2>/dev/null | sed -n 's/^rustc 1\.\([0-9][0-9]*\).*/\1/p')
    [ -n "$rust_minor" ] && [ "$rust_minor" -ge "$RUST_MIN_MINOR" ]
}

# On Linux, the window needs the X11/Wayland keyboard and window libraries
# with their development files. eframe's README gives this command for
# Debian/Ubuntu. It needs sudo, so it is only printed, never run.
if [ "$TF_OS" = linux ]; then
    step "Linux only: system libraries for the window"
    explain "WHY: eframe talks to the window system through these C libraries."
    explain "Install them once (Debian/Ubuntu), as shown in eframe's README:"
    explain "    sudo apt-get install libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev libssl-dev"
fi

step "1/2 Check whether Rust 1.$RUST_MIN_MINOR (or newer) is installed"
explain "WHY: cargo downloads eframe and egui, and rustc compiles everything to machine code."
if rust_ok; then
    ok "Rust found: $(rustc --version), $(cargo --version)"
    exit 0
fi
warn "Rust 1.$RUST_MIN_MINOR or newer was not found ('cargo'/'rustc' missing or too old)."
explain "If you installed Rust with rustup, update it with: rustup update"

step "2/2 Install Rust with rustup"
explain "WHY: rustup is the official installer. It puts rustc, cargo, and the standard"
explain "     library in ~/.cargo and ~/.rustup (no sudo) and can update them later."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        # The command published on https://www.rust-lang.org/tools/install.
        # It downloads rustup-init over HTTPS (TLS 1.2 or newer) and runs it.
        install_pkg "Rust (rustup)" sh -c \
            "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" || exit 1 ;;
    windows)
        explain "On Windows, run this command in PowerShell, then reopen Git Bash:"
        explain "    winget install --id Rustlang.Rustup -e"
        explain "rustup also needs the Visual Studio C++ Build Tools; it explains how when it runs."
        exit 1 ;;
    *)
        fail "Unknown OS. Install Rust by hand: https://www.rust-lang.org/tools/install" ;;
esac

[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
rust_ok || fail "Rust is still not on PATH. Open a new terminal and retry."
ok "Rust is ready. Next: ./build.sh"
