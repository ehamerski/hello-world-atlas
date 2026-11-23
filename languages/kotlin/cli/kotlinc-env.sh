# shellcheck shell=sh
# kotlinc-env.sh - Kotlin cli: where the Kotlin compiler is, shared by
#                  install.sh and build.sh (sourced, not run: it only sets
#                  variables)
#
# WHAT: sets KOTLINC_VERSION, KOTLINC_ZIP_SHA256 and KOTLINC_DIR, and puts
#       $KOTLINC_DIR/bin first on PATH when install.sh installed the
#       compiler there.
# WHY:  the Kotlin compiler, kotlinc, is a separate program from the JDK.
#       JetBrains publishes it as a plain zip file on GitHub, which
#       needs no installer and no administrator password. install.sh
#       unpacks it into KOTLINC_DIR, a folder in your home directory.
#
# KOTLINC_ZIP_SHA256 is the SHA-256 checksum of kotlin-compiler-2.4.21.zip. It
# was computed on the dev machine (2026-11-04) and matches the digest that
# GitHub shows for that release asset at
# https://github.com/JetBrains/kotlin/releases/tag/v2.4.21
# Only this folder needs the compiler: ../desktop and ../web use Gradle,
# which downloads its own Kotlin compiler.

# shellcheck disable=SC2034  # KOTLINC_ZIP_SHA256 is used by install.sh
KOTLINC_VERSION=2.4.21
KOTLINC_ZIP_SHA256=7cc140e76daf416a0424a5557f99afd7ca89ebd463ea1101261e3e01c33e75cd
# Override with: KOTLINC_DIR=/some/dir ./install.sh (and the same for build.sh)
KOTLINC_DIR=${KOTLINC_DIR:-$HOME/.local/kotlinc-$KOTLINC_VERSION}
if [ -x "$KOTLINC_DIR/bin/kotlinc" ]; then
    PATH=$KOTLINC_DIR/bin:$PATH
fi
export KOTLINC_DIR PATH
