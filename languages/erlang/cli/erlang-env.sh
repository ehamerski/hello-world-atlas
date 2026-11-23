# shellcheck shell=sh
# erlang-env.sh - Erlang: where a downloaded Erlang/OTP is, shared by
#                 install.sh, build.sh and run.sh (sourced, not run)
#
# WHAT: sets OTP_VERSION, OTP_WIN_ZIP_SHA256 and OTP_DIR, and puts
#       $OTP_DIR/bin first on PATH when install.sh unpacked Erlang/OTP there.
# WHY:  on Windows there is no package manager in Git Bash, so install.sh
#       unpacks the official 64-bit zip that erlang.org publishes. Each script
#       is a separate process, so each one sources this file to find it again.
#       macOS (Homebrew) and Linux (apt) put erl on PATH by themselves and
#       never create $OTP_DIR, so this file changes nothing there.
#
# OTP_WIN_ZIP_SHA256 is the SHA-256 that GitHub lists for otp_win64_29.1.2.zip in
#   https://github.com/erlang/otp/releases/tag/OTP-29.1.2
# This file is the same in every Erlang folder, so each one stays independent.

# shellcheck disable=SC2034  # OTP_WIN_ZIP_SHA256 is used by install.sh
OTP_VERSION=29.1.2
OTP_WIN_ZIP_SHA256=4efe9772a84c6c1ef75377e9326815584958776c905f2bf687b62509e2d809c0
# Override with: OTP_DIR=/some/dir ./install.sh (and the same for build.sh, run.sh)
OTP_DIR=${OTP_DIR:-$HOME/.local/otp-$OTP_VERSION}
# erl.exe is the Windows launcher inside the zip's bin folder.
if [ -f "$OTP_DIR/bin/erl.exe" ]; then
    PATH=$OTP_DIR/bin:$PATH
fi
export OTP_DIR PATH
