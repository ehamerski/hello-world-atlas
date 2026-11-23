# shellcheck shell=sh
# mojo-env.sh - Perl web: which Mojolicious version to use and where it is
#               installed (sourced, not run: it only sets variables)
#
# WHAT: sets the version, download URL and SHA-256 checksum of the
#       Mojolicious tarball, the local library folder LOCAL_LIB, and
#       PERL5LIB (Perl's module search path) when that folder exists.
# WHY:  install.sh and run.sh both need these values. Keeping them in one
#       file pins the version in one place. The checksum proves that the
#       downloaded file is exactly the release published on CPAN: the same
#       SHA-256 is listed by MetaCPAN's release API
#       (https://fastapi.metacpan.org/v1/release/Mojolicious). The tarball
#       comes from https://cpan.metacpan.org/, CPAN's mirror network. The
#       folder is private to this implementation, so nothing is installed
#       system-wide and no sudo is needed.

# shellcheck disable=SC2034  # these variables are used by install.sh
MOJO_VERSION=9.53
MOJO_SHA256=7a1417d6183929e274885c81e109e3a331c059c33ce1824929c1de81d9fe73bf
MOJO_URL=https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-9.53.tar.gz

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
