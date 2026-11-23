# shellcheck shell=sh
# use-msys2-swipl.sh - sourced by every install.sh and run.sh of this language
# (not run on its own)
#
# WHAT: on Windows, makes swipl findable. Elsewhere it does nothing.
# WHY:  on Windows, install.sh gets SWI-Prolog from MSYS2 (see install.sh).
#       MSYS2 is pre-installed on the GitHub windows-latest image but "not
#       added to PATH", and its packages live in C:\msys64\ucrt64\bin. Each
#       script is a separate process, so each one adds that folder itself. It
#       goes at the END of PATH: only swipl.exe and its DLLs are needed from
#       there, and Git Bash's own tools must keep winning.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#msys2
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-swi-prolog-core  (/ucrt64/bin/swipl.exe)
if [ "${TF_OS:-}" = windows ]; then
    PATH="$PATH:/c/msys64/ucrt64/bin"
    export PATH
fi
