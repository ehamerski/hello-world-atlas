# shellcheck shell=sh
# tkx-env.sh - Perl desktop: which Tcl.pm and Tkx versions to use and where
#              they are installed (sourced, not run: it only sets variables)
#
# WHAT: sets the version, download URL and SHA-256 checksum of the two CPAN
#       tarballs, the local library folder LOCAL_LIB, and PERL5LIB (Perl's
#       module search path) when that folder exists.
# WHY:  install.sh and run.sh both need these values. Keeping them in one
#       file means the versions are pinned in one place. The checksums
#       prove that the downloaded files are exactly the releases published
#       on CPAN: the same SHA-256 values are listed by MetaCPAN's release
#       API (https://fastapi.metacpan.org/v1/release/Tcl and .../Tkx).
#       Both tarballs sit on https://cpan.metacpan.org/, CPAN's mirror
#       network. The folder is private to this implementation, so nothing
#       is installed system-wide and no sudo is needed.

# shellcheck disable=SC2034  # these variables are used by install.sh
TCL_PM_VERSION=1.53
TCL_PM_SHA256=5644f8a8c22f3cf21d70941036f24ca1aa0fe0e50066ef0863365e3aa6f25c9d
TCL_PM_URL=https://cpan.metacpan.org/authors/id/V/VK/VKON/Tcl-1.53.tar.gz
TKX_VERSION=1.10
TKX_SHA256=6a437b8f99a4f25b640e1fc30c0d69c308abe4831fb9b5a1eedcfdbb821a0a94
TKX_URL=https://cpan.metacpan.org/authors/id/C/CA/CAC/Tkx-1.10.tar.gz

# The local library. "perl Makefile.PL INSTALL_BASE=..." puts modules under
# $LOCAL_LIB/lib/perl5 (the layout that local::lib also uses).
# On Windows the Perl is a native program (MSYS2 ucrt64, see
# ../use-msys2-perl.sh): it needs a Windows-style path (cygpath -m prints
# C:/folder/...) and separates the folders of PERL5LIB with ";", not ":".
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*) LOCAL_LIB=$(cygpath -m "$(pwd)")/local; PERL5LIB_SEP=';' ;;
    *)                    LOCAL_LIB=$(pwd)/local; PERL5LIB_SEP=':' ;;
esac
if [ -d "$LOCAL_LIB/lib/perl5" ]; then
    PERL5LIB=$LOCAL_LIB/lib/perl5${PERL5LIB:+$PERL5LIB_SEP$PERL5LIB}
fi
export LOCAL_LIB PERL5LIB
