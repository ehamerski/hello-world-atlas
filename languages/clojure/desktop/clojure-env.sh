# shellcheck shell=sh
# clojure-env.sh - Clojure: where the Clojure CLI is, shared by install.sh
#                  and run.sh (sourced, not run: it only sets variables)
#
# WHAT: sets CLOJURE_CLI_VERSION, CLOJURE_INSTALLER_SHA256 and CLOJURE_DIR,
#       and puts $CLOJURE_DIR/bin first on PATH when install.sh installed
#       the Clojure CLI there.
# WHY:  the Clojure CLI (the clojure and clj commands) is not part of the
#       JDK. Homebrew has it in a tap, but the official POSIX installer
#       works on macOS and Linux alike and accepts --prefix, so install.sh
#       can put the CLI in a folder in your home directory (no sudo
#       needed). The Clojure language itself is a JAR file that the CLI
#       downloads from Maven Central the first time it is needed.
#
# CLOJURE_INSTALLER_SHA256 is the SHA-256 of the versioned installer
#   https://github.com/clojure/brew-install/releases/download/1.12.6.1673/posix-install.sh
# checked on the dev machine (2026-11-04). The installer then verifies the
# SHA-256 of the tools tarball it downloads by itself.
# This file is the same in ../cli, ../desktop and ../web, so each folder
# stays independent.

# shellcheck disable=SC2034  # the SHA-256 variables are used by install.sh
# CLOJURE_MSI_SHA256 is the SHA-256 GitHub lists for clojure-1.12.6.1673.msi in
#   https://github.com/casselc/clj-msi/releases/tag/v1.12.6.1673 (Windows only).
CLOJURE_CLI_VERSION=1.12.6.1673
CLOJURE_MSI_SHA256=c218dcd6e23357d8e8952901379b664cf7808ddc1b6064f7370930c286301c4c
CLOJURE_INSTALLER_SHA256=fa47904c4f65326eb014c8e00b7a0d189a0e9acd7b61d47edaafab9f2fb681b0
# Override with: CLOJURE_DIR=/some/dir ./install.sh (and the same for run.sh)
CLOJURE_DIR=${CLOJURE_DIR:-$HOME/.local/clojure-1.12.6}
if [ -x "$CLOJURE_DIR/bin/clojure" ]; then
    PATH=$CLOJURE_DIR/bin:$PATH
fi
# On Windows the clj-msi installer puts clojure.exe in the install folder
# (layout confirmed in CI; see install.sh).
if [ -x "$CLOJURE_DIR/clojure.exe" ]; then
    PATH=$CLOJURE_DIR:$PATH
fi
export CLOJURE_DIR PATH
