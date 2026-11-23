#!/bin/sh
# install.sh - Perl web: check Perl, then install Mojolicious into local/
#
# WHAT: 1. checks that the perl interpreter is installed (and shows how to
#          install it if not);
#       2. downloads the CPAN tarball of Mojolicious, checks its SHA-256
#          checksum, builds it and installs it into local/ (a private Perl
#          library for this folder only).
#       The install asks first. Nothing is installed silently and sudo is
#       never hidden.
# WHY:  Mojolicious is a third-party module, not part of Perl. Installing it
#       in a local folder keeps it out of your system Perl, so this app
#       cannot break (or be broken by) other projects. The checksum proves
#       that the file is exactly the release published on CPAN.
#       Mojolicious is written in Perl only (no C code), so there is nothing
#       to compile: "make" only copies files.
# HOW:  ./install.sh       (run once; safe to run again)
#       PERL=perl5 ./install.sh      use another interpreter command
#       TF_ASSUME_YES=1 ./install.sh     answer "yes" to every question
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://metacpan.org/pod/Mojolicious
#   https://metacpan.org/pod/ExtUtils::MakeMaker (INSTALL_BASE)
#   https://formulae.brew.sh/formula/perl
#   https://packages.debian.org/stable/perl
#   https://strawberryperl.com/
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-perl

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so local/ is created here, not elsewhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, confirm.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Perl (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-perl.sh
. ../use-msys2-perl.sh
# Version, checksum, URL and the local folder (shared with run.sh).
# shellcheck source=mojo-env.sh
. ./mojo-env.sh

PERL=${PERL:-perl}

step "1/2 Check whether Perl 5 is installed"
explain "WHY: Mojolicious is a Perl module, so it needs the Perl interpreter ('$PERL')."
# On Windows, Perl counts as installed only if it can build modules (it has
# ExtUtils::MakeMaker): the Perl of Git Bash cannot, MSYS2's Perl can.
if has_cmd "$PERL" && { [ "$TF_OS" != windows ] || "$PERL" -MExtUtils::MakeMaker -e 1 2>/dev/null; }; then
    ok "Perl 5 found: $("$PERL" -e 'print "perl $^V"')"
else
    warn "Perl 5 is not installed (no '$PERL' on PATH)."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "Perl 5" brew install perl || exit 1 ;;
        linux)
            install_pkg "Perl 5" sudo apt-get install -y perl || exit 1 ;;
        windows)
            # MSYS2 comes with the GitHub windows-latest image. It packages a
            # complete Perl, the GCC compiler and make.
            # pacman -Sy refreshes the package lists; -S --needed skips what is
            # installed; the login shell (-l) sets MSYS2 up for pacman.
            # use-msys2-perl.sh then puts C:\msys64\ucrt64\bin first on PATH.
            # Without MSYS2, Strawberry Perl (https://strawberryperl.com/) also
            # has a complete Perl and a compiler.
            [ -x /c/msys64/usr/bin/bash.exe ] \
                || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use Strawberry Perl."
            install_pkg "Perl (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-perl mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-make" || exit 1
            . ../use-msys2-perl.sh ;;
        *)
            fail "Install Perl first: https://www.perl.org/get.html" ;;
    esac
    has_cmd "$PERL" || fail "Perl is still not on PATH. Open a new terminal and retry."
fi

# check_installed: true if Mojolicious loads from the local folder.
check_installed() {
    PERL5LIB="$LOCAL_LIB/lib/perl5${PERL5LIB:+$PERL5LIB_SEP$PERL5LIB}" \
        "$PERL" -e 'use Mojolicious; print "Mojolicious $Mojolicious::VERSION"' 2>/dev/null
}

step "2/2 Install Mojolicious $MOJO_VERSION into local/"
explain "WHY: the exact version is pinned and checked by SHA-256, so everyone runs the same code."
if INSTALLED=$(check_installed); then
    ok "Already installed: $INSTALLED"
    ok "Ready. Next: ./run.sh"
    exit 0
fi
has_cmd curl || fail "'curl' was not found. It downloads the CPAN tarball."
has_cmd "${MAKE:-make}" || fail "'make' was not found. On macOS run: xcode-select --install"
has_cmd shasum || has_cmd sha256sum || fail "Neither 'shasum' nor 'sha256sum' was found."

# sha_check CHECKSUM FILE: stop unless FILE has the given SHA-256 checksum.
# shasum comes with macOS; Linux has sha256sum with the same input format.
sha_check() {
    if has_cmd shasum; then echo "$1  $2" | shasum -a 256 -c - >/dev/null
    else echo "$1  $2" | sha256sum -c - >/dev/null; fi
}

if ! confirm "Download Mojolicious $MOJO_VERSION from CPAN and install it into local/?"; then
    warn "Skipped. Re-run this script when you are ready to install Mojolicious."
    exit 1
fi

tarball=Mojolicious-$MOJO_VERSION.tar.gz
explain "Download $MOJO_URL"
mkdir -p local/src
[ -f "local/src/$tarball" ] || curl -fsSL -o "local/src/$tarball" "$MOJO_URL"
# The checksum proves the file is exactly the release CPAN lists.
sha_check "$MOJO_SHA256" "local/src/$tarball" \
    || fail "Checksum mismatch: delete local/src/$tarball and retry."
ok "$tarball matches its SHA-256 checksum"

build=$(mktemp -d "${TMPDIR:-/tmp}/mojo-build.XXXXXX")
tar -xzf "local/src/$tarball" -C "$build"
# Build in a subshell so this script stays in its own folder.
# "perl Makefile.PL" writes a Makefile; INSTALL_BASE chooses the folder that
# "make install" copies to. These are Perl's usual build steps, like
# "./configure && make && make install" in C projects.
(
    cd "$build/Mojolicious-$MOJO_VERSION"
    "$PERL" Makefile.PL INSTALL_BASE="$LOCAL_LIB" >"$build/build.log" 2>&1 \
        && "${MAKE:-make}" >>"$build/build.log" 2>&1 \
        && "${MAKE:-make}" install >>"$build/build.log" 2>&1
) || { tail -n 30 "$build/build.log" >&2; fail "Building Mojolicious failed. The full log is $build/build.log"; }
rm -rf "$build"

INSTALLED=$(check_installed) || fail "Mojolicious does not load from local/. See the Platform notes in README.md."
ok "Installed: $INSTALLED"
ok "Ready. Next: ./run.sh"
