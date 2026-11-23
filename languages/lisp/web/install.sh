#!/bin/sh
# install.sh - Common Lisp web: check (and optionally install) SBCL and Quicklisp
#
# WHAT: 1. checks that sbcl (Steel Bank Common Lisp) is installed, as in
#          ../cli/install.sh, and shows the install command if it is not;
#       2. checks that Quicklisp is installed in ~/quicklisp/. If it is not,
#          downloads Quicklisp's installer, checks its SHA-256 checksum,
#          and installs it, only if you answer "y". No sudo is needed.
# WHY:  the web server, Hunchentoot, is a library, not part of SBCL.
#       Quicklisp is the library manager the Common Lisp community uses
#       (like pip for Python or npm for Node): build.sh asks it to
#       download Hunchentoot and the libraries Hunchentoot needs.
# HOW:  ./install.sh       (run once; safe to run again)
#       QUICKLISP_HOME=/path ./install.sh   use another Quicklisp folder
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/sbcl
#   https://www.sbcl.org/platform-table.html
#   https://www.quicklisp.org/beta/

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QUICKLISP_HOME, QUICKLISP_URL, QUICKLISP_SHA256.
# shellcheck source=quicklisp-env.sh
. ../use-msys2-sbcl.sh
. ./quicklisp-env.sh

SBCL=${SBCL:-sbcl}

step "1/3 Check whether SBCL is installed"
explain "WHY: '$SBCL' compiles server.lisp and the libraries, and saves the executable."
if has_cmd "$SBCL"; then
    ok "SBCL found: $("$SBCL" --version) ($(command -v "$SBCL"))"
else
    warn "SBCL is not installed (no '$SBCL' on PATH)."
    explain "It is installed exactly as for the cli version:"
    ../cli/install.sh || exit 1
fi

step "2/3 Check whether Quicklisp is installed in $QUICKLISP_HOME"
explain "WHY: Quicklisp downloads Hunchentoot and the libraries it needs."
if [ -f "$QUICKLISP_HOME/setup.lisp" ]; then
    ok "Quicklisp found in $QUICKLISP_HOME"
    exit 0
fi
warn "Quicklisp is not installed (no $QUICKLISP_HOME/setup.lisp)."

step "3/3 Install Quicklisp into $QUICKLISP_HOME"
explain "WHY: Quicklisp installs itself: SBCL loads the installer file"
explain "     quicklisp.lisp and calls its INSTALL function. The commands are:"
explain "    curl -fL -o quicklisp.lisp $QUICKLISP_URL"
explain "    sbcl --non-interactive --load quicklisp.lisp \\"
explain "         --eval '(quicklisp-quickstart:install :path \"$QUICKLISP_HOME/\")'"
confirm "Install Quicklisp into $QUICKLISP_HOME now?" \
    || { warn "Skipped. Run the commands above yourself, then re-run this script."; exit 1; }

ql_tmp=$(mktemp -d)
curl -fsSL -o "$ql_tmp/quicklisp.lisp" "$QUICKLISP_URL"
# The checksum proves the file is exactly the one Quicklisp publishes.
# macOS has shasum, Git Bash and Linux have sha256sum (Git Bash may have both).
if has_cmd sha256sum; then ql_sha="sha256sum -c -"; else ql_sha="shasum -a 256 -c -"; fi
echo "$QUICKLISP_SHA256  $ql_tmp/quicklisp.lisp" | $ql_sha \
    || fail "Checksum mismatch for quicklisp.lisp. Check https://www.quicklisp.org/beta/"
# :path must end with "/" so Lisp reads it as a folder, not a file name.
"$SBCL" --non-interactive --no-sysinit --no-userinit \
    --load "$(native_path "$ql_tmp")/quicklisp.lisp" \
    --eval "(quicklisp-quickstart:install :path \"$QUICKLISP_NATIVE/\")"
rm -rf "$ql_tmp"

[ -f "$QUICKLISP_HOME/setup.lisp" ] || fail "Quicklisp was not installed. See the messages above."
ok "Quicklisp is ready in $QUICKLISP_HOME. Next: ./build.sh"
