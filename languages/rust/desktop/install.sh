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
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
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
# with their development files. eframe's README gives the first five
# packages for Debian/Ubuntu:
#   https://github.com/emilk/egui/tree/main/crates/eframe#linux
# The others are needed to RUN the program, not to build it:
#   - libxkbcommon-x11-0: winit loads libxkbcommon-x11.so at start-up and
#     panics without it ("Library libxkbcommon-x11.so could not be loaded",
#     seen on a bare GitHub Actions runner);
#   - mesa-vulkan-drivers, libgl1-mesa-dri, libvulkan1, libegl1: egui draws
#     with wgpu, which needs a Vulkan or OpenGL driver. On a machine with no
#     GPU (a CI runner, a virtual machine) Mesa's software renderers
#     (lavapipe for Vulkan, llvmpipe for OpenGL) provide one.
#     Package pages: https://packages.ubuntu.com/search?keywords=mesa-vulkan-drivers
# apt-get needs sudo, so the command is shown and runs only if you agree.
LINUX_PKGS="libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev libssl-dev libxkbcommon-x11-0 mesa-vulkan-drivers libgl1-mesa-dri libvulkan1 libegl1"
if [ "$TF_OS" = linux ]; then
    step "Linux only: system libraries for the window"
    explain "WHY: eframe talks to the window system through these C libraries."
    # dpkg -s fails for a package that is not installed.
    missing=
    for pkg in $LINUX_PKGS; do
        dpkg -s "$pkg" >/dev/null 2>&1 || missing="$missing $pkg"
    done
    if [ -z "$missing" ]; then
        ok "All system libraries are installed."
    else
        # $missing is deliberately unquoted: one argument per package.
        # shellcheck disable=SC2086
        install_pkg "the window libraries" sudo apt-get install -y $missing \
            || warn "Continuing without them: the build may fail."
    fi
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
        # The script behind the command on https://www.rust-lang.org/tools/install,
        # saved to a file first (HTTPS, TLS 1.2 or newer) so you can read it
        # before it runs. It downloads rustup-init and runs it.
        rustup_script=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-rust/rustup-init.sh
        install_pkg "rustup's installer script (download only)" \
            curl --proto '=https' --tlsv1.2 -fsSL --create-dirs https://sh.rustup.rs -o "$rustup_script" || exit 1
        explain "The script is saved in $rustup_script; you can read it before the next step."
        install_pkg "Rust (rustup)" sh "$rustup_script" || exit 1 ;;
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
