# shellcheck shell=sh
# scala-env.sh - Scala cli: where the Scala 3 compiler is, shared by
#                install.sh, build.sh and run.sh (sourced, not run: it only
#                sets variables and PATH)
#
# WHAT: sets SCALA_VERSION, SCALA_ASSET, SCALA_TGZ_SHA256 and SCALA_DIR, and
#       puts $SCALA_DIR/bin first on PATH when install.sh installed the
#       compiler there.
# WHY:  the Scala 3 compiler (scalac) and the runner (scala) are launcher
#       scripts plus JVM libraries. The Scala project publishes them as a
#       plain tar.gz file on GitHub, which needs no installer and no
#       administrator password. install.sh unpacks it into SCALA_DIR, a
#       folder in your home directory.
#
# SCALA_TGZ_SHA256 is the SHA-256 checksum of the release archive for your
# system. Each value matches the digest that GitHub shows for that release asset
# (checked on 2026-11-20) at https://github.com/scala/scala3/releases/tag/3.10.1
# and in the GitHub API (https://api.github.com/repos/scala/scala3/releases/tags/3.10.1).
# Only the macOS Intel archive was downloaded and run for this folder; the other
# three digests are copied from the same page and are NOT verified by a run.
# On another system (Windows), SCALA_ASSET stays empty and install.sh says so.

# shellcheck disable=SC2034  # SCALA_ASSET and SCALA_TGZ_SHA256 are used by install.sh
SCALA_VERSION=3.10.1
SCALA_ASSET=
SCALA_TGZ_SHA256=
case "$(uname -s)-$(uname -m)" in
    Darwin-x86_64)
        SCALA_ASSET=scala3-$SCALA_VERSION-x86_64-apple-darwin
        SCALA_TGZ_SHA256=a80ec7c3d4e6cdf0b67a25279e59ed578951f125a7af74113964291aeaf479e1 ;;
    Darwin-arm64)
        SCALA_ASSET=scala3-$SCALA_VERSION-aarch64-apple-darwin
        SCALA_TGZ_SHA256=a9909997376605d50b95e5ae664f621e36580a01cdb2fa53e34297bf4976ca3a ;;
    Linux-x86_64)
        SCALA_ASSET=scala3-$SCALA_VERSION-x86_64-pc-linux
        SCALA_TGZ_SHA256=54e644dc759b86d0d8124e1b9d91f0dfaf19935c5d1d4199cde48b873c3ee64d ;;
    Linux-aarch64)
        SCALA_ASSET=scala3-$SCALA_VERSION-aarch64-pc-linux
        SCALA_TGZ_SHA256=dd352acf3b66d166252ac027dfd9e4a29f33ca9fb1c16494476b58ca9d64b67c ;;
esac
# Override with: SCALA_DIR=/some/dir ./install.sh (and the same for build.sh)
SCALA_DIR=${SCALA_DIR:-$HOME/.local/${SCALA_ASSET:-scala3-$SCALA_VERSION}}
if [ -x "$SCALA_DIR/bin/scalac" ]; then
    PATH=$SCALA_DIR/bin:$PATH
fi
export SCALA_DIR PATH
