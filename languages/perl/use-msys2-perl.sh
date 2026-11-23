# shellcheck shell=sh
# use-msys2-perl.sh - sourced by every install.sh and run.sh of this language
# (not run on its own)
#
# WHAT: on Windows, makes the Perl that install.sh got from MSYS2 the one that
#       runs. Elsewhere, or while that Perl is not installed, it does nothing.
# WHY:  the "perl" that comes with Git for Windows (Git Bash) is a trimmed
#       copy: it has no ExtUtils::MakeMaker, the module that "perl
#       Makefile.PL" needs to build Tcl.pm, Tkx and Mojolicious, and it has no
#       compiler. So on Windows, install.sh gets a complete Perl, GCC, make
#       and Tcl/Tk from MSYS2 (see install.sh). MSYS2 is pre-installed on the
#       GitHub windows-latest image but "not added to PATH", and its packages
#       live in C:\msys64\ucrt64\bin. Each script is a separate process, so
#       each one adds that folder itself, at the START of PATH so that this
#       Perl wins over Git's. The folder holds only what the packages bring.
#       MAKE: this Perl's make program is "mingw32-make" (its Config says so),
#       so the scripts that run make use that name.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#msys2
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-perl   (/ucrt64/bin/perl.exe)
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-make   (/ucrt64/bin/mingw32-make.exe)
if [ "${TF_OS:-}" = windows ] && [ -x /c/msys64/ucrt64/bin/perl.exe ]; then
    PATH="/c/msys64/ucrt64/bin:$PATH"
    MAKE=mingw32-make
    export PATH MAKE
fi
