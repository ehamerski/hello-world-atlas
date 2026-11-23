# shellcheck shell=sh
# use-msys2-lua.sh - sourced by the install.sh and run.sh of cli and web
# (not run on its own)
#
# WHAT: on Windows, makes lua and luarocks usable from Git Bash. Elsewhere it
#       does nothing.
# WHY:  on Windows, install.sh gets Lua and LuaRocks from MSYS2 (see the
#       install.sh files). MSYS2 is pre-installed on the GitHub windows-latest
#       image but "not added to PATH", and its packages live in
#       C:\msys64\ucrt64\bin. Each script is a separate process, so each one
#       adds that folder itself. It goes at the END of PATH: only lua.exe, the
#       C compiler and their DLLs are needed from there, and Git Bash's own
#       tools must keep winning.
#       The "luarocks" file of the MSYS2 package is a Lua script whose first
#       line (#!/ucrt64/bin/lua.exe) only MSYS2's own shell understands, so
#       Git Bash cannot run it directly: the function below runs it with
#       lua.exe instead.
#       "luarocks path" prints cmd.exe commands (SET LUA_PATH=...) there,
#       which sh cannot run, so rocks_env (below) asks for the bare values
#       (--lr-path, --lr-cpath) and sets the two variables itself.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#msys2
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-lua   (/ucrt64/bin/lua.exe)
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-lua-luarocks   (/ucrt64/bin/luarocks)
#   https://github.com/luarocks/luarocks/blob/main/src/luarocks/cmd/path.lua   (--lr-path, --lr-cpath)
#   https://www.lua.org/manual/5.4/manual.html#pdf-package.path   (";;" adds the default path)
if [ "${TF_OS:-}" = windows ]; then
    PATH="$PATH:/c/msys64/ucrt64/bin"
    export PATH
    # Only once luarocks is installed (the file does not exist before).
    if [ -f /c/msys64/ucrt64/bin/luarocks ]; then
        luarocks() { lua.exe /c/msys64/ucrt64/bin/luarocks "$@"; }
    fi
    # rocks_env TREE: let Lua find the modules installed in TREE. lua.exe
    # ends its lines with CR LF, so tr removes the CR.
    rocks_env() {
        LUA_PATH="$(luarocks --tree "$1" path --lr-path | tr -d '\r');;"
        LUA_CPATH="$(luarocks --tree "$1" path --lr-cpath | tr -d '\r');;"
        export LUA_PATH LUA_CPATH
    }
fi
