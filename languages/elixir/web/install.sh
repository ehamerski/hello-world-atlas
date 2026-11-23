#!/bin/sh
# install.sh - Elixir web: check Elixir and Mix, install Hex, download the dependencies
#
# WHAT: 1. checks that elixir and mix are installed; if they are missing,
#          shows the install command for your operating system and runs it
#          only if you answer "y" (sudo is never hidden);
#       2. installs Hex, the Erlang and Elixir package manager, with
#          "mix local.hex --force";
#       3. downloads the dependencies (Plug, Bandit and what they need) with
#          "mix deps.get" into the folder deps/ (the first run also puts
#          rebar3, an Erlang build tool, into ~/.mix).
# WHY:  this version uses libraries, so it needs Mix, the build tool that
#       ships with Elixir, and Hex, the package manager that Mix uses to
#       download them. mix.lock pins the exact version of every package, so
#       every student gets the same code.
#       "mix local.hex --force" writes the Hex archive into ~/.mix (Mix's
#       home folder, MIX_HOME); --force skips the question that Mix would
#       ask. This script explains that first, outside of your project. Hex
#       needs no sudo. Neither Mix nor Hex has a telemetry or analytics
#       setting in their documentation, so there is no opt-out to set.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://elixir-lang.org/install/
#   https://formulae.brew.sh/formula/elixir
#   https://mix.hexdocs.pm/Mix.Tasks.Local.Hex.html

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so mix.exs and mix.lock are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, confirm, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# ELIXIR_VERSION, ELIXIR_OTP_VERSION, ELIXIR_INSTALLER_SHA256; puts a downloaded
# Elixir on PATH.
# shellcheck source=elixir-env.sh
. ./elixir-env.sh

# unzip_shim - Git Bash on the Windows runner has no unzip, but the install
# script below calls "unzip -q FILE -d DIR". This puts a tiny unzip on PATH
# (for this script only) that forwards to 7-Zip, which the GitHub Windows
# image has. 7z: x = extract with paths, -o<dir> = output folder (no space),
# -y = yes to all.
# https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md
unzip_shim() {
    has_cmd 7z || fail "Neither unzip nor 7z was found. Install one of them first."
    ex_shim=$(mktemp -d)
    printf '%s\n' '#!/bin/sh' \
        '# usage: unzip -q FILE -d DIR (the only form the install script uses)' \
        'exec 7z x -y "-o$4" "$2" >/dev/null' > "$ex_shim/unzip"
    chmod +x "$ex_shim/unzip"
    PATH=$ex_shim:$PATH
}

# install_elixir_script - the official "install script" of elixir-lang.org:
# download install.sh, check its SHA-256, and run it. It downloads a
# precompiled Erlang/OTP and Elixir into ~/.elixir-install/installs (no sudo).
# On Ubuntu it fetches Erlang/OTP from builds.hex.pm; on Windows it unpacks
# the OTP zip from github.com/erlang/otp and needs unzip (see below).
# Sources:
#   https://elixir-lang.org/install/   ("Install Scripts")
#   https://github.com/elixir-lang/elixir-lang.github.com/blob/main/public/install.sh
install_elixir_script() {
    ex_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-elixir
    explain "Download the official install script https://elixir-lang.org/install.sh into"
    explain "$ex_cache, check its SHA-256 checksum, and run it:"
    explain "    sh install.sh elixir@$ELIXIR_VERSION otp@$ELIXIR_OTP_VERSION"
    explain "It puts Erlang/OTP and Elixir into $ELIXIR_INSTALLS (no sudo)."
    confirm "Install Elixir $ELIXIR_VERSION and Erlang/OTP $ELIXIR_OTP_VERSION now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is missing. Install it first."
    # The install script needs unzip. The Windows image has 7-Zip but Git Bash
    # has no unzip, so a small unzip shim is put on PATH (see unzip_shim above).
    if ! has_cmd unzip; then
        unzip_shim
    fi

    mkdir -p "$ex_cache"
    [ -f "$ex_cache/install.sh" ] || curl -fL -o "$ex_cache/install.sh" https://elixir-lang.org/install.sh
    echo "$ELIXIR_INSTALLER_SHA256  $ex_cache/install.sh" | sha256sum -c - \
        || fail "Checksum mismatch: delete $ex_cache/install.sh and retry."

    sh "$ex_cache/install.sh" "elixir@$ELIXIR_VERSION" "otp@$ELIXIR_OTP_VERSION" \
        || fail "The Elixir install script failed. See the messages above."
    # Read elixir-env.sh again: it now puts the downloaded Elixir on PATH.
    . ./elixir-env.sh
}

step "1/3 Check whether Elixir and Mix are installed"
explain "WHY: 'mix' downloads the dependencies and compiles the project, and it"
explain "     runs on the 'elixir' toolchain. Mix ships with Elixir."
if has_cmd elixir && has_cmd mix; then
    ok "Elixir found: $(elixir --version 2>&1 | tail -n 1) ($(command -v elixir))"
else
    warn "Elixir or Mix is not installed."
    case "$TF_OS" in
        macos-intel|macos-arm)
            # Homebrew (https://brew.sh). On Intel Macs there is no ready-made
            # package (bottle) for elixir or erlang, so Homebrew compiles both
            # from source: about 15 minutes for Erlang (plus about 7 minutes
            # for wxWidgets) and about 2 minutes for Elixir on the dev machine.
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            explain "On an Intel Mac this compiles Erlang and Elixir from source and takes a while."
            install_pkg "Elixir (and Erlang/OTP)" brew install elixir || exit 1 ;;
        linux|windows)
            # The official install script (see install_elixir_script above):
            # apt on Ubuntu has Elixir 1.18 and mix.exs needs ~> 1.20, and
            # Windows has no package manager inside Git Bash.
            install_elixir_script ;;
        *)
            fail "Unknown OS. See https://elixir-lang.org/install/" ;;
    esac
    has_cmd elixir && has_cmd mix \
        || fail "'elixir' or 'mix' is still not on PATH. Open a new terminal and retry."
fi

step "2/3 Install Hex"
explain "WHY: Hex is the package manager that Mix uses to download Plug and Bandit."
explain "     The next command is 'mix local.hex --force'. It downloads the Hex archive"
explain "     and writes it to ~/.mix (the folder in MIX_HOME, if you set it). It"
explain "     changes nothing outside that folder. --force skips Mix's question"
explain "     'Shall I install Hex?', so this script can run without a keyboard."
if confirm "Install Hex now (writes to ~/.mix)?"; then
    mix local.hex --force
else
    # Hex may already be there from an earlier run, so check before giving up.
    mix hex.info >/dev/null 2>&1 \
        || fail "Hex is not installed. Run 'mix local.hex --force' yourself, then re-run this script."
    ok "Hex is already installed."
fi

step "3/3 Download the dependencies"
explain "WHY: 'mix deps.get' reads mix.exs and mix.lock, downloads the exact pinned"
explain "     versions of Plug, Bandit and their dependencies from Hex, and"
explain "     unpacks them into deps/ (not committed to Git). The first time, Mix"
explain "     also puts a copy of rebar3, an Erlang build tool, into ~/.mix."
# "mix deps" lists each locked dependency and says "run \"mix deps.get\"" for
# any that is missing or does not match mix.lock. grep reads all of the output
# (no -q), so mix never writes to a closed pipe.
if mix deps 2>&1 | grep 'mix deps.get' >/dev/null; then
    install_pkg "the dependencies from mix.lock" mix deps.get || exit 1
else
    ok "Dependencies already match mix.lock."
fi

ok "Dependencies are ready. Next: ./build.sh"
