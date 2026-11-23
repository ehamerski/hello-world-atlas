# shellcheck shell=sh disable=SC2034  # sourced: build.sh and run.sh use CABAL_PROJECT_OPTS
# cabal-project.sh - Haskell web: which Cabal project file to use, shared by
#                    build.sh and run.sh (sourced, not run on its own)
#
# WHAT: sets CABAL_PROJECT_OPTS, a list of options for every "cabal" command.
#       It is empty on macOS and Linux (Cabal reads cabal.project.freeze).
#       On Windows it selects a copy of the freeze file in which the zlib
#       package is built from its bundled C source.
# WHY:  cabal.project.freeze pins "zlib -bundled-c-zlib +pkg-config": the zlib
#       package then needs the pkg-config program and a zlib library already
#       installed, which is normal on macOS and Linux but not on Windows
#       ("pkg-config package zlib-any is needed but no pkg-config executable
#       was found"). The zlib package's "bundled-c-zlib" flag compiles zlib's
#       own C files instead, which is the documented way on Windows:
#       https://hackage.haskell.org/package/zlib-0.7.1.1 (Flags). Every
#       package version stays exactly as pinned; only these two flags change.
#       Cabal reads "<project file>.freeze" next to the project file
#       (https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html),
#       so the Windows copies are generated here, from the real freeze file.
#       They are not tracked by git (see .gitignore).
#       The Windows project file also says "jobs: 1": with several packages
#       installed at the same time, two of them could update the package
#       store's package.cache together, and one failed with "you don't have
#       permission to modify this file". One at a time is slower but safe.
#       "jobs" is described on the same page.
# The scripts run with "set -e", so this file ends with "return 0".
CABAL_PROJECT_OPTS=
if [ "$TF_OS" = windows ]; then
    printf 'packages: .\njobs: 1\n' > cabal.project.windows
    sed 's/zlib -bundled-c-zlib +non-blocking-ffi +pkg-config/zlib +bundled-c-zlib +non-blocking-ffi -pkg-config/' \
        cabal.project.freeze > cabal.project.windows.freeze
    CABAL_PROJECT_OPTS=--project-file=cabal.project.windows
fi
return 0
