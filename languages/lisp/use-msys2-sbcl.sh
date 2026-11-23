# shellcheck shell=sh disable=SC2034  # sourced: build.sh and run.sh use EXE
# use-msys2-sbcl.sh - sourced by every install.sh, build.sh and run.sh of this
# language (not run on its own)
#
# WHAT: on Windows, makes SBCL findable and sets EXE=.exe; elsewhere EXE is
#       empty and nothing else happens. Also defines native_path.
# WHY:  on Windows, install.sh gets SBCL from MSYS2 (see install.sh). MSYS2 is
#       pre-installed on the GitHub windows-latest image but "not added to
#       PATH", and its packages live in C:\msys64\ucrt64\bin. Each script is a
#       separate process, so each one must add that folder itself. It goes at
#       the END of PATH: only sbcl.exe and its DLLs are needed from there, and
#       Git Bash's own tools must keep winning.
#       Windows programs are named *.exe; sbcl saves its executables under the
#       exact name it is given, so the scripts add $EXE themselves.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#msys2
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-sbcl  (/ucrt64/bin/sbcl.exe)
EXE=''
if [ "${TF_OS:-}" = windows ]; then
    EXE=.exe
    PATH="$PATH:/c/msys64/ucrt64/bin"
    export PATH
fi

# native_path PATH - the path in the form a native Windows program (sbcl.exe)
# understands: Git Bash's /c/Users/x is not a path for it, C:/Users/x is.
# Elsewhere the path is returned unchanged.
native_path() {
    if [ "${TF_OS:-}" = windows ]; then cygpath -m "$1"; else printf '%s\n' "$1"; fi
}
