#!/bin/sh
# install.sh - Perl desktop: check Perl and Tcl/Tk, then install Tcl.pm and
#              Tkx into the local folder local/
#
# WHAT: 1. checks that the perl interpreter is installed;
#       2. checks that Tcl/Tk (with its development files) is installed, and
#          shows how to install it if not;
#       3. downloads the CPAN tarballs of Tcl.pm and Tkx, checks their
#          SHA-256 checksums, builds them and installs them into local/
#          (a private Perl library for this folder only).
#       Each install asks first. Nothing is installed silently and sudo is
#       never hidden.
# WHY:  Perl has no GUI toolkit of its own. Tkx drives Tcl/Tk (the same
#       toolkit as Python's tkinter) through Tcl.pm, a module with a small
#       C part, so it has to be compiled against your Tcl. The checksums
#       prove that the files are exactly the releases published on CPAN. The
#       local folder keeps your system Perl untouched.
# HOW:  ./install.sh       (run once; safe to run again)
#       PERL=perl5 ./install.sh      check another interpreter command
#       TCLSH=/path/tclsh ./install.sh   use another Tcl installation
#       TF_ASSUME_YES=1 ./install.sh     answer "yes" to every question
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/tcl-tk
#   https://packages.debian.org/stable/tcl-dev
#   https://packages.debian.org/stable/tk-dev
#   https://packages.ubuntu.com/resolute/tcl8.6-dev   (tclConfig.sh and tcl.h)
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-perl
#   https://metacpan.org/pod/Tcl
#   https://metacpan.org/pod/Tkx
#   https://metacpan.org/pod/ExtUtils::MakeMaker (INSTALL_BASE)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so local/ is created here, not elsewhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows, puts the MSYS2 Perl (and its gcc, make) first on PATH.
# shellcheck source=../use-msys2-perl.sh
. ../use-msys2-perl.sh
# Versions, checksums, URLs and the local folder (shared with run.sh).
# shellcheck source=tkx-env.sh
. ./tkx-env.sh

PERL=${PERL:-perl}

step "1/3 Check whether Perl 5 is installed"
explain "WHY: Tkx is a Perl module, so it needs the Perl interpreter ('$PERL')."
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
            # complete Perl, the GCC compiler and make, and Tcl/Tk 8.6 (for Tcl.pm and Tkx).
            # pacman -Sy refreshes the package lists; -S --needed skips what is
            # installed; the login shell (-l) sets MSYS2 up for pacman.
            # use-msys2-perl.sh then puts C:\msys64\ucrt64\bin first on PATH.
            # Without MSYS2, Strawberry Perl (https://strawberryperl.com/) also
            # has a complete Perl and a compiler.
            [ -x /c/msys64/usr/bin/bash.exe ] \
                || fail "MSYS2 was not found in C:\\msys64. Install it from https://www.msys2.org/ or use Strawberry Perl."
            install_pkg "Perl (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-perl mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-make mingw-w64-ucrt-x86_64-tcl mingw-w64-ucrt-x86_64-tk" || exit 1
            . ../use-msys2-perl.sh ;;
        *)
            fail "Install Perl first: https://www.perl.org/get.html" ;;
    esac
    has_cmd "$PERL" || fail "Perl is still not on PATH. Open a new terminal and retry."
fi

# On macOS the Homebrew tcl-tk formula is the Tcl/Tk to use. Its tclsh is
# looked up by path because /usr/bin/tclsh is Apple's much older Tcl 8.5.
# On Windows it is the one MSYS2 installs (Git Bash has another Tcl, without
# the headers Tcl.pm needs). Elsewhere a plain "tclsh" is used.
if [ -z "${TCLSH:-}" ]; then
    TCLSH=tclsh
    case "$TF_OS" in
        windows) TCLSH=/c/msys64/ucrt64/bin/tclsh.exe ;;
        macos-*)
            if has_cmd brew && [ -x "$(brew --prefix tcl-tk 2>/dev/null)/bin/tclsh" ]; then
                TCLSH=$(brew --prefix tcl-tk)/bin/tclsh
            fi ;;
    esac
fi

step "2/3 Check whether Tcl/Tk is installed"
explain "WHY: Tk draws the window. Tcl.pm is compiled against Tcl's headers and library,"
explain "     and finds them through '$TCLSH' and its tclConfig.sh file."
# tcl_dev_ok: true if Tcl's development files are there. On Debian/Ubuntu
# "tclsh" can be installed without them (package tcl8.6, not tcl8.6-dev), and
# then Tcl.pm cannot find tclConfig.sh and tcl.h.
tcl_dev_ok() {
    case "$TF_OS" in
        linux)   [ -f /usr/include/tcl.h ] || [ -f /usr/include/tcl8.6/tcl.h ] ;;
        windows) [ -f /c/msys64/ucrt64/lib/tclConfig.sh ] ;;
        *)       true ;;
    esac
}
if has_cmd "$TCLSH" && echo 'puts [info patchlevel]' | "$TCLSH" >/dev/null 2>&1 && tcl_dev_ok; then
    ok "Tcl found: $(echo 'puts [info patchlevel]' | "$TCLSH") ($TCLSH)"
else
    warn "Tcl/Tk is not installed (no working '$TCLSH')."
    case "$TF_OS" in
        macos-intel|macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            explain "On Intel Macs Homebrew builds this from source, which takes a few minutes."
            install_pkg "Tcl/Tk" brew install tcl-tk || exit 1
            TCLSH=$(brew --prefix tcl-tk)/bin/tclsh ;;
        linux)
            # tcl-dev has the headers and tclConfig.sh; tk-dev has Tk and its headers.
            install_pkg "Tcl/Tk" sudo apt-get install -y tcl-dev tk-dev || exit 1 ;;
        windows)
            # Tcl and Tk 8.6 from MSYS2 (tclsh.exe, tclConfig.sh, headers, wish).
            # https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-tcl
            # https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-tk
            install_pkg "Tcl/Tk (MSYS2 packages)" /c/msys64/usr/bin/bash.exe -lc \
                "pacman -Sy --noconfirm --needed mingw-w64-ucrt-x86_64-tcl mingw-w64-ucrt-x86_64-tk" || exit 1 ;;
        *)
            fail "Install Tcl/Tk with its development files, then run this script again." ;;
    esac
    has_cmd "$TCLSH" || fail "Tcl is still not found. Open a new terminal and retry."
fi

# The compiler is needed because Tcl.pm has a C part. On macOS this selects
# a working developer directory if the active one is broken.
fix_developer_dir
has_cmd "${MAKE:-make}" || fail "'make' was not found. On macOS run: xcode-select --install"
has_cmd cc || has_cmd gcc || fail "A C compiler ('cc') was not found. On macOS run: xcode-select --install"

# check_installed: true if Tkx and Tcl.pm load from the local folder.
check_installed() {
    PERL5LIB="$LOCAL_LIB/lib/perl5${PERL5LIB:+$PERL5LIB_SEP$PERL5LIB}" \
        "$PERL" -e 'use Tcl; use Tkx; print "Tcl.pm $Tcl::VERSION, Tkx $Tkx::VERSION"' 2>/dev/null
}

step "3/3 Install Tcl.pm $TCL_PM_VERSION and Tkx $TKX_VERSION into local/"
explain "WHY: the exact versions are pinned and checked by SHA-256, so everyone runs the same code."
if INSTALLED=$(check_installed); then
    ok "Already installed: $INSTALLED"
    ok "Ready. Next: ./run.sh"
    exit 0
fi
has_cmd curl || fail "'curl' was not found. It downloads the CPAN tarballs."
has_cmd shasum || has_cmd sha256sum || fail "Neither 'shasum' nor 'sha256sum' was found."

# sha_check CHECKSUM FILE: stop unless FILE has the given SHA-256 checksum.
# shasum comes with macOS; Linux has sha256sum with the same input format.
sha_check() {
    if has_cmd shasum; then echo "$1  $2" | shasum -a 256 -c - >/dev/null
    else echo "$1  $2" | sha256sum -c - >/dev/null; fi
}

# install_dist NAME VERSION URL SHA256 [MAKEFILE.PL OPTIONS]: download, check,
# unpack in a temporary folder, build and install one CPAN distribution.
install_dist() {
    d_name=$1; d_version=$2; d_url=$3; d_sha=$4; shift 4
    d_tar=$d_name-$d_version.tar.gz
    explain "Download $d_url"
    mkdir -p local/src
    [ -f "local/src/$d_tar" ] || curl -fsSL -o "local/src/$d_tar" "$d_url"
    # The checksum proves the file is exactly the release CPAN lists.
    sha_check "$d_sha" "local/src/$d_tar" \
        || fail "Checksum mismatch: delete local/src/$d_tar and retry."
    ok "$d_tar matches its SHA-256 checksum"
    d_tmp=$(mktemp -d "${TMPDIR:-/tmp}/tkx-build.XXXXXX")
    tar -xzf "local/src/$d_tar" -C "$d_tmp"
    # Build in a subshell so this script stays in its own folder.
    # "perl Makefile.PL" writes a Makefile; INSTALL_BASE chooses the folder
    # that "make install" copies to. Perl's usual build steps, as in
    # "./configure && make && make install" in C projects.
    (
        cd "$d_tmp/$d_name-$d_version"
        "$PERL" Makefile.PL INSTALL_BASE="$LOCAL_LIB" "$@" >"$d_tmp/$d_name.log" 2>&1 \
            && "${MAKE:-make}" >>"$d_tmp/$d_name.log" 2>&1 \
            && "${MAKE:-make}" install >>"$d_tmp/$d_name.log" 2>&1
    ) || { tail -n 30 "$d_tmp/$d_name.log" >&2; fail "Building $d_name failed. The full log is $d_tmp/$d_name.log"; }
    rm -rf "$d_tmp"
    ok "$d_name $d_version installed into local/"
}

# Tcl.pm first (Tkx depends on it). --tclsh tells its Makefile.PL which Tcl
# to build against (it reads tclConfig.sh through that tclsh).
if confirm "Download, build and install Tcl.pm and Tkx into local/ (about a minute)?"; then
    install_dist Tcl "$TCL_PM_VERSION" "$TCL_PM_URL" "$TCL_PM_SHA256" --tclsh "$TCLSH"
    # Tkx needs Tcl.pm when it is built, so put the new local library on PERL5LIB.
    PERL5LIB="$LOCAL_LIB/lib/perl5${PERL5LIB:+$PERL5LIB_SEP$PERL5LIB}"
    export PERL5LIB
    install_dist Tkx "$TKX_VERSION" "$TKX_URL" "$TKX_SHA256"
else
    warn "Skipped. Re-run this script when you are ready to install Tcl.pm and Tkx."
    exit 1
fi

# On failure, load the modules once more with the error shown, to say why.
INSTALLED=$(check_installed) || { "$PERL" -e 'use Tcl; use Tkx;' || true
    fail "Tkx does not load from local/. See the Platform notes in README.md."; }
ok "Installed: $INSTALLED"
ok "Ready. Next: ./run.sh"
