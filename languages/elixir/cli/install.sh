#!/bin/sh
# install.sh - Elixir cli: check (and optionally install) Elixir
#
# WHAT: checks that elixir, the Elixir command, is installed. If it is
#       missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  hello.exs is compiled in memory and run by the elixir command, which
#       needs Erlang/OTP (the Erlang runtime and its virtual machine, the
#       BEAM). Homebrew's elixir formula depends on the erlang formula, so
#       one install brings both. The cli version needs nothing else.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://elixir-lang.org/install/
#   https://formulae.brew.sh/formula/elixir

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
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

step "1/2 Check whether Elixir is installed"
explain "WHY: the 'elixir' command compiles hello.exs in memory and runs it."
if has_cmd elixir; then
    # "elixir --version" prints the Erlang/OTP line first, then a blank line,
    # then "Elixir 1.20.5 (compiled with Erlang/OTP 29)"; tail -n 1 keeps the last line.
    ok "Elixir found: $(elixir --version 2>&1 | tail -n 1) ($(command -v elixir))"
    exit 0
fi
warn "Elixir is not installed (no 'elixir' on PATH)."

step "2/2 Install Elixir"
explain "WHY: each OS packages Elixir differently."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh). On Intel Macs Homebrew has no ready-made
        # package (bottle) for elixir or erlang, so it compiles both from
        # source: about 15 minutes for Erlang (plus about 7 minutes for
        # wxWidgets, a dependency of Erlang) and about 2 minutes for Elixir
        # on the dev machine.
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

has_cmd elixir || fail "'elixir' is still not on PATH. Open a new terminal and retry."
ok "$(elixir --version 2>&1 | tail -n 1) is ready. Next: ./run.sh"
