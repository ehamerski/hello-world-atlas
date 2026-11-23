#!/bin/sh
# install.sh - Erlang desktop: check (and optionally install) Erlang/OTP and wx
#
# WHAT: checks that erl (the Erlang virtual machine), erlc (the compiler) and
#       the wx application (the window toolkit) are installed. If something
#       is missing, shows the install command for your operating system and
#       runs it only if you answer "y". Nothing is installed silently and
#       sudo is never hidden.
# WHY:  hello_wx.erl is compiled by erlc and runs on the BEAM virtual machine.
#       The window is drawn by wx, the Erlang binding to the wxWidgets
#       toolkit. wx is part of Erlang/OTP (OTP is the Open Telecom Platform,
#       Erlang's standard library and tools). Homebrew installs wxWidgets as
#       a dependency of erlang, and Debian ships wx as a separate package,
#       erlang-wx.
# HOW:  ./install.sh       (run once; safe to run again)
#       TF_ASSUME_YES=1 ./install.sh   answer "y" to the install question
#
# Time (wx comes with erlang; the Homebrew formula depends on wxwidgets@3.2): on an Intel Mac, Homebrew has no ready-made package (bottle) for
# erlang, so it builds Erlang and wxWidgets from source: about 25 minutes
# (7 minutes for wxWidgets, 15 for Erlang on the development machine). On
# Apple Silicon and Linux, Homebrew installs a bottle in a short time.
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://www.erlang.org/downloads
#   https://formulae.brew.sh/formula/erlang
#   https://packages.debian.org/stable/erlang-wx

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# OTP_VERSION, OTP_WIN_ZIP_SHA256, OTP_DIR; puts a downloaded Erlang/OTP on PATH.
# shellcheck source=erlang-env.sh
. ./erlang-env.sh

# have_wx - true if the "wx" application is part of this Erlang installation.
# code:lib_dir(wx) returns {error, bad_name} when the application is absent.
have_wx() {
    erl -noshell -eval 'halt(case code:lib_dir(wx) of {error, _} -> 1; _ -> 0 end).'
}

# install_otp_windows - download the official 64-bit Erlang/OTP zip from the
# erlang/otp release on GitHub, check its SHA-256 and unpack it into $OTP_DIR
# (no administrator rights). The zip includes wx and inets. The Visual C++
# runtime it needs (vcruntime140.dll) is part of the GitHub Windows image.
# Sources:
#   https://github.com/erlang/otp/releases/tag/OTP-29.1.2
#   https://www.erlang.org/downloads
install_otp_windows() {
    otp_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-erlang
    otp_zip=otp_win64_$OTP_VERSION.zip
    otp_url="https://github.com/erlang/otp/releases/download/OTP-$OTP_VERSION/$otp_zip"
    explain "Download $otp_zip from the Erlang/OTP release on GitHub into $otp_cache,"
    explain "check its SHA-256 checksum, and unpack it into $OTP_DIR (no admin rights)."
    confirm "Install Erlang/OTP $OTP_VERSION into $OTP_DIR now?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }
    has_cmd curl || fail "curl is missing. Install it first."
    has_cmd unzip || has_cmd 7z || fail "unzip or 7z is needed to unpack the zip."

    mkdir -p "$otp_cache"
    [ -f "$otp_cache/$otp_zip" ] || curl -fL -o "$otp_cache/$otp_zip" "$otp_url"
    echo "$OTP_WIN_ZIP_SHA256  $otp_cache/$otp_zip" | sha256sum -c - \
        || fail "Checksum mismatch: delete $otp_cache/$otp_zip and retry."

    rm -rf "$OTP_DIR"
    mkdir -p "$OTP_DIR"
    if has_cmd unzip; then
        unzip -q "$otp_cache/$otp_zip" -d "$OTP_DIR"
    else
        # Git Bash has no unzip; 7-Zip is on the GitHub Windows image.
        # 7z: x = extract with paths, -o<dir> = output folder (no space), -y = yes to all.
        7z x -y "-o$OTP_DIR" "$otp_cache/$otp_zip" >/dev/null
    fi
    # Read erlang-env.sh again: it now puts $OTP_DIR/bin on PATH.
    . ./erlang-env.sh
}

step "1/2 Check whether Erlang/OTP and wx are installed"
explain "WHY: erlc compiles hello_wx.erl, erl runs it, and the wx application opens the window."
if has_cmd erl && has_cmd erlc && have_wx; then
    # system_info(otp_release) is the major OTP version, for example "29".
    ok "Erlang/OTP found: release $(erl -noshell -eval 'io:format("~s", [erlang:system_info(otp_release)]), halt().') ($(command -v erl))"
    exit 0
fi
warn "Erlang/OTP is not installed (erl or erlc is missing from PATH, or wx is missing)."

step "2/2 Install Erlang/OTP"
explain "WHY: each OS packages Erlang/OTP differently. Homebrew and apt are the ones erlang.org lists."
case "$TF_OS" in
    macos-intel|macos-arm)
        # Homebrew (https://brew.sh). On Intel Macs there is no bottle, so
        # this compiles Erlang and wxWidgets from source (about 25 minutes).
        has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
        if [ "$TF_OS" = macos-intel ]; then
            explain "This Mac is Intel: Homebrew builds Erlang from source, which takes about 25 minutes."
        fi
        install_pkg "Erlang/OTP and wx" brew install erlang || exit 1 ;;
    linux)
        # Debian shown (erlang.org lists the erlang package; erlang-wx is the wx package on Debian). Other distributions:
        # https://www.erlang.org/downloads
        install_pkg "Erlang/OTP and wx" sudo apt-get install -y erlang erlang-wx || exit 1 ;;
    windows)
        # The official zip, unpacked into your home folder (see above).
        install_otp_windows ;;
    *)
        fail "Unknown OS. See https://www.erlang.org/downloads" ;;
esac

has_cmd erl && has_cmd erlc && have_wx \
    || fail "Erlang/OTP or wx is still missing. Open a new terminal and retry."
ok "Erlang/OTP is ready. Next: ./build.sh"
