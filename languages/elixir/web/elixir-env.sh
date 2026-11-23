# shellcheck shell=sh
# elixir-env.sh - Elixir: where the Elixir and Erlang/OTP that install.sh
#                 downloaded are, shared by install.sh, build.sh and run.sh
#                 (sourced, not run: it only sets variables)
#
# WHAT: sets ELIXIR_VERSION, ELIXIR_OTP_VERSION, ELIXIR_INSTALLER_SHA256 and
#       ELIXIR_INSTALLS, and puts the downloaded Erlang/OTP and Elixir bin
#       folders first on PATH when they exist.
# WHY:  on Linux and Windows the packaged Elixir is too old or missing (apt on
#       Ubuntu has 1.18; mix.exs here needs ~> 1.20), so install.sh runs the
#       official install script from elixir-lang.org, which downloads a
#       precompiled Erlang/OTP and Elixir into ~/.elixir-install/installs
#       without administrator rights. macOS (Homebrew) never creates that
#       folder, so this file changes nothing there.
#
# ELIXIR_INSTALLER_SHA256 is the SHA-256 of
#   https://elixir-lang.org/install.sh
# as checked on 2026-11-05. The script then downloads the OTP and Elixir
# archives named below (see https://elixir-lang.org/install/ , "Install Scripts").
# This file is the same in ../cli and ../web, so each folder stays independent.

# shellcheck disable=SC2034  # these variables are used by install.sh
ELIXIR_VERSION=1.20.5
ELIXIR_OTP_VERSION=29.1
ELIXIR_INSTALLER_SHA256=18859f92620d3b9eaba009e248706c5ee2067d38ccebe482333233726a99e6f8
ELIXIR_INSTALLS=$HOME/.elixir-install/installs
# The folder names are the ones install.sh creates: otp/<otp version> and
# elixir/<elixir version>-otp-<OTP major release>.
if [ -d "$ELIXIR_INSTALLS/otp/$ELIXIR_OTP_VERSION/bin" ] \
   && [ -d "$ELIXIR_INSTALLS/elixir/$ELIXIR_VERSION-otp-${ELIXIR_OTP_VERSION%%.*}/bin" ]; then
    PATH=$ELIXIR_INSTALLS/elixir/$ELIXIR_VERSION-otp-${ELIXIR_OTP_VERSION%%.*}/bin:$ELIXIR_INSTALLS/otp/$ELIXIR_OTP_VERSION/bin:$PATH
fi
export PATH
