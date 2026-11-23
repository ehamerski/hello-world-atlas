# Lua · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Lua](../README.md)

## What this is
A small web server written with Pegasus, an HTTP server library for Lua.
When a browser asks for `http://localhost:8080/`, the server answers with
the HTML `<p>Hello, World!</p>`, which the browser shows as the text
**Hello, World!**. The server sends the HTML itself; there is no separate
front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Lua (`lua`; `lua5.4` on Debian and Ubuntu) | 5.5.1 (Homebrew formula `lua`) | runs `app.lua` |
| LuaRocks | 3.13.0 (Homebrew formula `luarocks`) | the Lua package manager; `install.sh` uses it to install Pegasus into `rocks/` |
| Pegasus | 1.1.0 (`pegasus 1.1.0-0` on LuaRocks) | the web server library |
| LuaSocket, LuaFileSystem, lzlib, mimetypes | 3.1.0-1, 1.9.0-1, 0.4.1.53-4, 1.1.0-2 | the modules that Pegasus requires [1] |
| a C compiler | Apple clang from the Xcode Command Line Tools | LuaSocket, LuaFileSystem, and lzlib contain C code that LuaRocks builds on your computer |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

Pegasus declares these requirements: Lua 5.1 or newer, LuaFileSystem 1.6 or
newer, LuaSocket, lzlib 0.4.1.53-1 or newer, and mimetypes 1.0.0-1 or newer
[1]. `install.sh` installs one fixed version of each, so every install is
the same.

## Quick start
```sh
./install.sh   # check Lua and LuaRocks, install Pegasus into rocks/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks the interpreter and shows how to install it. 2. Checks that `luarocks` is installed. 3. Runs `luarocks --tree ./rocks install <module> <version>` for LuaSocket, LuaFileSystem, lzlib, mimetypes, and Pegasus. Every install step asks first. | Pegasus is a third-party module. In the output of `luarocks help`, the option `--tree` is described as "Which tree to operate on.", so the modules go into the folder `rocks/` of this app and not into the system. |
| `run.sh` | Runs `eval "$(luarocks --tree ./rocks path)"` and then `lua app.lua`. `--verify` starts the server in the background, fetches the page once with `curl`, then stops it. | `luarocks path` prints shell commands that set `LUA_PATH` and `LUA_CPATH` [2], which tell Lua where to find modules. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`, because Lua is run from source, as in the
[cli](../cli/README.md#why-there-is-no-build-step). LuaRocks builds the C
modules of the dependencies during `install.sh`, but the application
itself has nothing to build.

## Folder structure
```text
web/
├── README.md      this file
├── install.sh     checks Lua and LuaRocks, installs Pegasus into rocks/
├── run.sh         starts the server
├── app.lua        the web application
├── .gitignore     keeps rocks/ out of git
└── rocks/         created by install.sh; not committed
```
- `app.lua` is the only source file. A single file is enough for one page.
- `rocks/` is a LuaRocks *tree*: a folder where LuaRocks keeps installed
  modules. The LuaRocks documentation describes the "system" tree and the
  "user" tree [2]; a project-local tree is a third one, chosen with
  `--tree`.
- A larger Pegasus app would add folders for static files and plugins,
  which Pegasus reads from its `location` setting [4]. A single page needs
  neither.

## Step-by-step walkthrough
Open [`app.lua`](app.lua) next to this list.

1. **`local Pegasus = require("pegasus")`** loads the module and returns
   what it exports. `require` "loads the given module" [3]. Unlike the
   [cli](../cli/hello.lua), which uses only the built-in `print`, this
   program depends on a library that LuaRocks installed.
2. **`local port = tonumber(os.getenv("PORT")) or 8080`** reads the port.
   `os.getenv` "returns the value of the process environment variable
   `varname` or fail if the variable is not defined" [3], and "currently,
   `fail` is equal to `nil`" [3]. The operator `or` "returns its first
   argument if this value is different from nil and false; otherwise, `or`
   returns its second argument" [3], so 8080 is the default. `tonumber`
   converts the text to a number [3].
3. **`Pegasus:new({ host = "127.0.0.1", port = port })`** creates the
   server. The braces build a *table*, which "is the sole data-structuring
   mechanism in Lua" [3]. The colon in `Pegasus:new` passes `Pegasus`
   itself as the first argument: "a call `v:name(args)` is syntactic sugar
   for `v.name(v, args)`" [3]. Binding to `127.0.0.1` makes the server
   reachable from this computer only.
4. **`server:start(function(request, response) ... end)`** runs the server.
   The function is called once for every request, like a route handler in
   Express (`app.get("/", ...)`), Flask (`@app.route("/")`), or Go
   (`http.HandleFunc("/", ...)`). Here every URL gets the same answer.
   Pegasus documents that "`start` runs a blocking accept loop" [4], so
   this call does not return. That loop is the difference from the cli
   version, which runs once and exits.
5. **`response:statusCode(200)`, `response:addHeader("Content-Type",
   "text/html")`, `response:write("<p>Hello, World!</p>")`** build the
   response: the status line, a header, and the body. Pegasus documents all
   three methods, and notes that `write` sets `Content-Length` for a string
   body [5]. Without the `Content-Type` header the browser would not know
   that the text is HTML. You can see the result in the `curl -i` output
   below.

## Why this toolchain
- **Pegasus** describes itself as "an http server to work with web
  applications written in Lua language" [6]. Its source says "Minimal,
  embeddable HTTP server with a simple plugin system" [4]. It has a small
  API, and the Hello World page takes 8 lines of code, which suits the aim
  of this repository to keep each program as simple and direct as possible.
  It is licensed under the MIT license [1].
- **Version 1.1.0** is the newest version of Pegasus on LuaRocks on
  2026-11-04 [1].
- **LuaRocks:** the Lua download page says "The main repository of Lua
  modules is LuaRocks" [7]. Its `--tree` option keeps the modules of this app
  separate from every other Lua project on the computer.
- **Pegasus is for learning, not for production.** Its `start` method "runs
  a blocking accept loop", and its own documentation recommends running it
  "in a dedicated OS thread/process if you need concurrency" [4].
- **Supply chain.** LuaRocks.org published an incident report: on
  2026-09-25 it received a report of a remote code execution vulnerability,
  which was fixed on 2026-09-26. The report says "We have not found any
  evidence that existing packages were modified" and recommends upgrading
  LuaRocks "to 3.12 or newer" [8]. This implementation uses LuaRocks
  3.13.0. Pinning versions does not check file hashes, so read the report
  before you install.
- **Port 8080** is the convention of this repository for every web
  implementation. Pegasus itself defaults to 9090 [4].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Lua 5.5.1 and LuaRocks 3.13.0 from Homebrew, Pegasus 1.1.0-0. LuaRocks built the three C modules in about 25 seconds in total. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel (`brew install lua luarocks`). |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `lua5.4` with apt when it is missing, and `luarocks`, `build-essential`, `unzip`, `liblua5.4-dev` and `zlib1g-dev` when LuaRocks is missing. It tells LuaRocks the Lua version, because Debian's `luarocks` is set up for Lua 5.1. Then it builds Pegasus and its modules into `rocks/`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. If Lua or LuaRocks is missing, `install.sh` installs the MSYS2 packages for Lua 5.5, LuaRocks, GCC and zlib with `pacman` (MSYS2 is pre-installed in `C:\msys64`) and adds `C:\msys64\ucrt64\bin` to the end of PATH. Git Bash cannot run MSYS2's `luarocks` file, so the scripts run it with `lua.exe`. Then it builds Pegasus and its modules into `rocks/`. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'luarocks --tree ./rocks path' prints the settings (LUA_PATH, LUA_CPATH)
         that let Lua find the modules in rocks/; 'eval' applies them to this script.
    Then 'lua app.lua' serves on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Pegasus is up on 127.0.0.1:8080
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html
Date: Wed, 04 Nov 2026 16:13:33 GMT

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. `pegasus`: LuaRocks module page. LuaRocks. <https://luarocks.org/modules/evandrolg/pegasus> (accessed 2026-11-04)
2. Using LuaRocks. LuaRocks. <https://github.com/luarocks/luarocks/blob/main/docs/using_luarocks.md> (accessed 2026-11-04)
3. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (accessed 2026-11-04)
4. `src/pegasus/init.lua`, tag v1.1.0. Pegasus.lua. <https://github.com/EvandroLG/pegasus.lua/blob/v1.1.0/src/pegasus/init.lua> (accessed 2026-11-04)
5. `src/pegasus/response.lua`, tag v1.1.0. Pegasus.lua. <https://github.com/EvandroLG/pegasus.lua/blob/v1.1.0/src/pegasus/response.lua> (accessed 2026-11-04)
6. Pegasus.lua. EvandroLG (GitHub). <https://github.com/EvandroLG/pegasus.lua> (accessed 2026-11-04)
7. Download. Lua.org, PUC-Rio. <https://www.lua.org/download.html> (accessed 2026-11-04)
8. LuaRocks.org Security Incident, September 2026. LuaRocks. <https://luarocks.org/security-incident-september-2026> (accessed 2026-11-04)
