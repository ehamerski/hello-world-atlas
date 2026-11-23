# shellcheck shell=sh
# gnucobol-env.sh - COBOL cli: puts MSYS2's GnuCOBOL on PATH on Windows
#                   (sourced by install.sh, build.sh and run.sh, not run on
#                   its own)
#
# WHY:  on Windows, install.sh installs GnuCOBOL with MSYS2's package
#       manager, and MSYS2's programs live in C:\msys64\ucrt64\bin, which is
#       not on PATH (the GitHub Actions image has MSYS2 but "not added to
#       PATH": https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md).
#       cobc needs that folder for the C compiler it calls (gcc), and the
#       compiled program needs it to find libcob.dll at run time, so all
#       three scripts add it. On macOS and Linux nothing changes.
#       MSYS2_ROOT can point at another MSYS2 install.
# The scripts run with "set -e", so this file ends with "return 0".
MSYS2_ROOT=${MSYS2_ROOT:-/c/msys64}
UCRT64_BIN=$MSYS2_ROOT/ucrt64/bin
case ":$PATH:" in
    *":$UCRT64_BIN:"*) ;;
    *) [ -d "$UCRT64_BIN" ] && PATH="$UCRT64_BIN:$PATH" ;;
esac

# MSYS2's cobc has the install prefix "/ucrt64" compiled in. A POSIX path like
# that only means something inside MSYS2's own shell: cobc.exe and gcc.exe are
# ordinary Windows programs, and for them "/ucrt64/share/gnucobol/config"
# means C:\ucrt64\... ("configuration error: /ucrt64/share/gnucobol/config\
# cobol85.conf: No such file or directory"). cobc reads these variables
# before its built-in paths, so point them at the real folders. cygpath -m
# prints the C:/... form that Windows programs accept. Variables:
# https://gnucobol.sourceforge.io/doc/gnucobol.html (Compiler environment)
if [ -d "$UCRT64_BIN" ] && has_cmd cygpath; then
    UCRT64_DIR=$(cygpath -m "$MSYS2_ROOT/ucrt64")
    COB_CONFIG_DIR=$UCRT64_DIR/share/gnucobol/config
    COB_COPY_DIR=$UCRT64_DIR/share/gnucobol/copy
    COB_CFLAGS="-pipe -I$UCRT64_DIR/include -Wno-unused -fsigned-char -Wno-pointer-sign"
    COB_LIBS="-L$UCRT64_DIR/lib -lcob"
    export COB_CONFIG_DIR COB_COPY_DIR COB_CFLAGS COB_LIBS
fi
export MSYS2_ROOT PATH
return 0
