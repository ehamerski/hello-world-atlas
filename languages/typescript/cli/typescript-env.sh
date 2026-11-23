# shellcheck shell=sh
# typescript-env.sh - TypeScript cli: which Node.js and which TypeScript, shared by
#                     install.sh, build.sh and run.sh (sourced, not run: it only
#                     sets variables and PATH)
#
# WHAT: sets TS_NODE_MIN_MAJOR (the oldest Node.js major version this example
#       accepts) and, when "node" is not on PATH, puts the folder of an installed
#       Node.js first on PATH: Homebrew's folders, then the newest version that
#       nvm installed in $NVM_DIR (default ~/.nvm).
# WHY:  the scripts must find Node.js and npm even in a shell that has a short
#       PATH, for example "env -i HOME=$HOME PATH=/usr/bin:/bin ./run.sh".
#       The TypeScript compiler itself is not found through PATH: it is a
#       package that npm installs into node_modules/ (versions are pinned in
#       package.json and package-lock.json, which also records a SHA-512 integrity
#       value for every package).
#
# Node.js is not downloaded by these scripts. If you have none, install.sh shows
# the official ways to get it and stops. This file is the same in ../web, so
# each folder stays independent.

# shellcheck disable=SC2034  # used by install.sh
TS_NODE_MIN_MAJOR=24
if ! command -v node >/dev/null 2>&1; then
    for ts_dir in /opt/homebrew/bin /usr/local/bin; do
        if [ -x "$ts_dir/node" ]; then PATH=$ts_dir:$PATH; break; fi
    done
fi
if ! command -v node >/dev/null 2>&1; then
    ts_nvm=${NVM_DIR:-$HOME/.nvm}/versions/node
    if [ -d "$ts_nvm" ]; then
        # Newest version first: sort numerically on major, minor and patch.
        ts_ver=$(ls -1 "$ts_nvm" | sed 's/^v//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -n 1)
        if [ -n "$ts_ver" ] && [ -x "$ts_nvm/v$ts_ver/bin/node" ]; then
            PATH=$ts_nvm/v$ts_ver/bin:$PATH
        fi
    fi
fi
export PATH
