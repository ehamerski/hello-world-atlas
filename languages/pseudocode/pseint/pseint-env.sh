# shellcheck shell=sh
# pseint-env.sh - PSeInt: which release to use and where its interpreter
#                 is, shared by install.sh and run.sh (sourced, not run: it
#                 only sets variables)
#
# WHAT: sets PSEINT_VERSION, PSEINT_DIR, PSEINT_PKG (the archive name for
#       this OS), PSEINT_SHA256 (its checksum) and PSEINT (the path of the
#       interpreter, or empty when it is not installed).
# WHY:  PSeInt has no Homebrew formula and no Debian package (checked
#       2026-11-01). Its author publishes ready-made archives on
#       SourceForge that only need to be unpacked ("No necesita
#       instalación, solo descomprimir y ejecutar", "it needs no
#       installation, just unpack and run", PSeInt download page), so
#       install.sh unpacks one into PSEINT_DIR, a folder in your home
#       directory (no sudo needed).
#
# The archive holds the editor (a GUI) and the interpreter, a separate
# command-line program also called "pseint". The editor itself starts that
# interpreter to run your algorithm; run.sh starts it directly.
#
# The checksums are the SHA-256 values SourceForge publishes for each file
# of release 20250314 (https://sourceforge.net/projects/pseint/files/20250314/,
# checked 2026-11-01). The mi64 one also matched the file downloaded on the
# dev machine.

# shellcheck disable=SC2034  # PSEINT_PKG and PSEINT_SHA256 are used by install.sh
PSEINT_VERSION=20250314
# Override with: PSEINT_DIR=/some/dir ./install.sh (and the same for run.sh)
PSEINT_DIR=${PSEINT_DIR:-$HOME/.local/pseint-$PSEINT_VERSION}

# Archive name, checksum and interpreter path differ per OS:
#   mi64 = macOS Intel 64-bit, ma64 = macOS Apple Silicon, l64 = Linux 64-bit.
case "$TF_OS" in
    macos-intel)
        PSEINT_PKG=pseint-mi64-$PSEINT_VERSION.tgz
        PSEINT_SHA256=f09d19adc0f5a959894ae87a7491eac25e6953f27c9a418b13c3e9171e87a722
        PSEINT_BIN=$PSEINT_DIR/pseint.app/Contents/Resources/pseint ;;
    macos-arm)
        PSEINT_PKG=pseint-ma64-$PSEINT_VERSION.tgz
        PSEINT_SHA256=d9c624b42d0282d9e34091c2fcabb05663d533d5ddbebb1615d681955fdf282d
        PSEINT_BIN=$PSEINT_DIR/pseint.app/Contents/Resources/pseint ;;
    linux)
        PSEINT_PKG=pseint-l64-$PSEINT_VERSION.tgz
        PSEINT_SHA256=871312634da8e1a0e45b0badbdcb8a0e67dbe51e4bf8cf5fe3ff37fd9817191b
        PSEINT_BIN=$PSEINT_DIR/pseint/bin/pseint ;;
    *)
        PSEINT_PKG=''; PSEINT_SHA256=''; PSEINT_BIN='' ;;
esac

# Use the unpacked interpreter if it is there. Override: PSEINT=/path/to/pseint
if [ -z "${PSEINT:-}" ] && [ -n "$PSEINT_BIN" ] && [ -x "$PSEINT_BIN" ]; then
    PSEINT=$PSEINT_BIN
fi
PSEINT=${PSEINT:-}
