# Elixir · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Elixir](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`, like the other web versions (for example
[Haskell](../../haskell/web/)). Any other path gets a plain `404 Not
Found`.

It is a **Mix** project: "Mix is a build tool that ships with Elixir" [1].
It uses two libraries from Hex, the package repository of the Erlang and
Elixir community. **Plug** is described on Hex as "Compose web
applications with functions" [2], and its documentation defines a plug as
"any function that receives a connection and a set of options and returns
a connection" [3]. **Bandit** is "A pure-Elixir HTTP server built for Plug
& WebSock apps" [4]. There is no web framework such as Phoenix: Plug is
enough for one route.

Compare the [cli](../cli/) first: there, one script prints one line. Here,
a supervisor starts the web server, and the server calls a plug for every
request.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Elixir and Mix | 1.20.5 (Homebrew), on Erlang/OTP 29.1.2 | compile and run the project; see [../cli](../cli/README.md#prerequisites) |
| Hex | 2.6.0 (installed by `mix local.hex --force`) | the package manager that downloads the libraries |
| Plug | 1.20.4 (pinned in `mix.lock`) | the plug specification and `Plug.Router` |
| Bandit | 1.14.1 (pinned in `mix.lock`) | the HTTP server |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

Plug 1.20.4 was published on Hex on 2026-11-17 [2], and Bandit 1.14.1 on
2026-10-28 [4]. Plug is licensed Apache-2.0 [2] and Bandit MIT [4]. Plug
and Bandit need six more packages, which `mix.lock` also pins: `hpax`,
`mime`, `plug_crypto`, `telemetry`, `thousand_island`, and `websock`.

## Quick start
```sh
./install.sh   # check Elixir, install Hex, download the libraries (asks before installing)
./build.sh     # compile (about 11 s on the test machine)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks `elixir` and `mix`; if they are missing, offers the install command (see [../cli](../cli/README.md#scripts-explained)). 2. `mix local.hex --force`: "Installs Hex locally" [5]; `--force` "forces installation without a shell prompt" [5]. 3. `mix deps.get`, after asking, when `mix deps` reports a missing or out-of-date dependency: downloads the versions pinned in `mix.lock` into `deps/`. | This version uses libraries, so it needs Hex to fetch them. |
| `build.sh` | `mix compile`: compiles the dependencies (first build only) and `lib/*.ex` into `.beam` files in `_build/`. | Unlike [../cli](../cli/), a Mix project is compiled once and the result is kept; later builds recompile only what changed. |
| `run.sh` | `mix run --no-halt` with `PORT` (default 8080). `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `mix run` "will be compiled if it has not been compiled yet or it is outdated" [6], starts the application, and `--no-halt` "does not halt the system after running the command" [6]. |

**What `install.sh` writes outside this folder.** `mix local.hex --force`
puts the Hex archive in Mix's home folder, `~/.mix` by default: the Mix
documentation says that `MIX_HOME` "stores configuration files and scripts
used by Mix (default: `~/.mix`)" and that `MIX_ARCHIVES` is the directory
for archives (default: `~/.mix/archives`) [7]. On the test machine,
`mix local.hex --force` printed `creating /Users/<user>/.mix/archives/hex-2.6.0`.
The first `mix deps.get` also printed `creating
/Users/<user>/.mix/elixir/1-20-otp-29/rebar3`: a copy of rebar3, an Erlang
build tool that Mix keeps in the same folder, which some Erlang
dependencies need (here, `telemetry`). The script explains this before it
runs the command, and asks first unless `TF_ASSUME_YES=1` is set. No
`sudo` is used.

**Telemetry.** The documentation of Hex's `mix hex.config` lists 22
configuration keys and 19 `HEX_*` environment variables [8]. None of them
is about telemetry, analytics, or usage reporting, and the Mix environment
variables page [7] has none either. So this implementation sets no opt-out.
(Bandit, a library, does emit `telemetry` events inside the program, but
they stay in the program unless code subscribes to them.)

**Pinned versions.** `mix.lock` records the exact version and checksum of
every package. `mix deps.get` reads it, so every student builds the same
code.

## Folder structure
```text
web/
├── README.md              this file
├── install.sh             checks Elixir, installs Hex, mix deps.get
├── build.sh               mix compile
├── run.sh                 starts the server (or checks it with --verify)
├── screenshot.png         the page in a browser (see Expected output)
├── mix.exs                the project file: name, version, dependencies
├── mix.lock               the exact version and checksum of every package
├── .gitignore             keeps _build/ and deps/ out of Git
├── lib/
│   └── hello_web/
│       ├── application.ex starts Bandit under a supervisor
│       └── router.ex      the plug that answers GET /
├── deps/                  created by mix deps.get; not committed
└── _build/                created by mix compile; not committed
```
- This is the layout that `mix new` generates: `mix.exs` at the top and the
  source under `lib/`. The Mix guide says that "All compilation artifacts
  are placed inside the `_build` directory" and that `mix.exs` has "its
  main responsibility is to configure our project" [9]. The folder
  `.gitignore` lists `/_build/` and `/deps/`, the same lines that `mix new`
  writes into its `.gitignore`. The root `.gitignore` of this repository
  has no rule for them.
- **`mix.exs`, block by block.** `project/0` returns a keyword list:
  `app: :hello_web` names the application, `elixir: "~> 1.20"` requires
  Elixir 1.20 or later in the 1.x series, and `deps: deps()` lists the
  libraries. `application/0` has `mod: {HelloWeb.Application, []}`, which
  names the module that starts first, and `extra_applications: [:logger]`.
  `deps/0` lists `{:plug, "~> 1.20"}` and `{:bandit, "~> 1.14"}`.

## Step-by-step walkthrough
Open [`lib/hello_web/application.ex`](lib/hello_web/application.ex) and
[`lib/hello_web/router.ex`](lib/hello_web/router.ex) next to this list.

1. **Modules and `do ... end`.** `defmodule HelloWeb.Application do ...
   end` defines a module, a named group of functions. A block opens with
   `do` and closes with `end`; Elixir has no braces for blocks.
2. **`use Application` and `@impl true`.** An OTP *application* is a
   component that Mix starts. `start/2` is its callback: Mix calls it
   once. OTP is the set of libraries and conventions that comes with
   Erlang, so this is the same structure an [Erlang](../../erlang/web/)
   program has. The Elixir docs say that `start/2` "should start the
   top-level process of the application (which should be the top
   supervisor of the application's supervision tree ...)" [10].
3. **Reading `PORT` with `case`.** `System.get_env("PORT")` returns the
   text or `nil`. The `case` expression matches that value against
   patterns, top to bottom: `nil -> 8080` or `text -> String.to_integer(text)`.
   Pattern matching is the central idea of Elixir: a pattern both tests
   the shape of a value and names its parts. Haskell's
   [`Maybe`](../../haskell/web/README.md#step-by-step-walkthrough) solves
   the same "not set" problem with a type, Elixir with a value, `nil`.
   With `PORT=abc`, `String.to_integer/1` raises an error and the server
   does not start.
4. **The child specification.** `{Bandit, plug: HelloWeb.Router, ip:
   :loopback, port: port}` says which process to start and with which
   options. Bandit's documentation lists them: `:plug` is "The Plug to use
   to handle connections", `:port` is "The TCP port to listen on", and
   `:ip` is "The interface(s) to listen on", with `:loopback` for
   "local loopback (ie: `127.0.0.1`)" [11]. Without `:port`, Bandit
   defaults to 4000 for HTTP [11]. With `:loopback`, other computers
   cannot connect. The documentation's own example puts
   `{Bandit, plug: MyApp.MyPlug}` in the list of children of a
   supervisor [11].
5. **The supervisor.** `Supervisor.start_link(children, strategy:
   :one_for_one, name: HelloWeb.Supervisor)` starts a *supervisor*, "a
   process which supervises other processes". With `:one_for_one`, "if a
   child process terminates, only that process is restarted" [12]. It
   returns `{:ok, pid}`, which is how Mix learns that the start worked.
6. **The pipe operator.** In `router.ex`, `conn |> put_resp_content_type("text/html")
   |> send_resp(200, "...")` equals `send_resp(put_resp_content_type(conn,
   "text/html"), 200, "...")`. The operator "introduces the expression
   on the left-hand side as the first argument to the function call on
   the right-hand side" [13]. Data is immutable: each function returns a
   new connection and `conn` itself does not change.
7. **`Plug.Router`.** `use Plug.Router` adds the route macros. `plug
   :match` finds the route and `plug :dispatch` runs it: the Plug
   documentation says that "`:match` is responsible for finding a matching
   route which is then forwarded to `:dispatch`" [14]. `get "/" do ... end`
   is a route, and `match _ do ... end` catches everything else with a
   `404`.
8. **A `|>` after a `defp`.** Nothing in `lib/` is private, but `mix.exs`
   shows `defp`: "Defines a private function with the given name and
   body", visible only inside its module [13]. `def` defines a public one.

## Why this toolchain
- **Plug is the base of Elixir web programs.** Its specification is small:
  a plug takes a connection and returns a connection [3]. `Plug.Router`
  gives a route in one line, and the router is one file.
- **Bandit is a Plug server written in Elixir** [4]. The Plug project
  lists Cowboy, an Erlang server, as another option; this repository uses
  Bandit because the whole stack, apart from the virtual machine, is
  Elixir code that the student can read.
- **Mix and Hex are the standard tools.** Mix ships with Elixir [1]; Hex
  is the package manager Mix uses to download dependencies [5].
- **The cost: the first build.** On the test machine (2026-11-04),
  `install.sh` took about 9 s (including installing Hex) and the first
  `build.sh`, which compiles Plug, Bandit and their dependencies, about
  11 s. Both need network access the first time. Elixir itself takes much
  longer to install on an Intel Mac (see [../cli](../cli/README.md#prerequisites)).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Elixir 1.20.5, Erlang/OTP 29.1.2, Hex 2.6.0. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; Homebrew installs bottles for Elixir and Erlang [../cli](../cli/README.md#platform-notes). |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs Elixir with the official install script when it is missing, as in [../cli](../cli/README.md#platform-notes). Then it runs `mix local.hex --force` and `mix deps.get`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` installs Elixir with the official install script when it is missing, as in [../cli](../cli/README.md#platform-notes). Then it runs `mix local.hex --force` and `mix deps.get`. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: mix run starts HelloWeb.Application, which starts Bandit on 127.0.0.1
         (this computer only) and keeps the Erlang VM alive with --no-halt.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.

13:10:03.068 [info] Running HelloWeb.Router with Bandit 1.14.1 at 127.0.0.1:8080 (http)
```
The last line is Bandit's startup log, written through Elixir's `Logger`;
its time is the local time of the run [11].

In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
date: Wed, 04 Nov 2026 16:10:07 GMT
content-length: 20
vary: accept-encoding
cache-control: max-age=0, private, must-revalidate
content-type: text/html; charset=utf-8

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

The self-check:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: mix run starts HelloWeb.Application, which starts Bandit on 127.0.0.1
         (this computer only) and keeps the Erlang VM alive with --no-halt.

13:09:41.620 [info] Running HelloWeb.Router with Bandit 1.14.1 at 127.0.0.1:8080 (http)
<p>Hello, World!</p>
```
The last line is the page, fetched by `curl` in `run.sh`. When `run.sh`
stops the server, Elixir logs `[notice] SIGTERM received - shutting down`.

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Introduction to Mix (Mix and OTP). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (accessed 2026-11-04)
2. `plug` package (version 1.20.4). Hex. <https://hex.pm/packages/plug> (accessed 2026-11-19)
3. Plug: the plug specification (version 1.20.4). Plug team, hexdocs.pm. <https://plug.hexdocs.pm/Plug.html> (accessed 2026-11-19)
4. `bandit` package (version 1.14.1). Hex. <https://hex.pm/packages/bandit> (accessed 2026-11-04)
5. `mix local.hex`. Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.Tasks.Local.Hex.html> (accessed 2026-11-04)
6. `mix run`. Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.Tasks.Run.html> (accessed 2026-11-04)
7. Mix (module documentation, environment variables). Mix documentation, hexdocs.pm. <https://mix.hexdocs.pm/Mix.html> (accessed 2026-11-04)
8. `mix hex.config`. Hex documentation, hexdocs.pm. <https://hex.hexdocs.pm/Mix.Tasks.Hex.Config.html> (accessed 2026-11-04)
9. Introduction to Mix (project layout, `_build`, `mix.exs`). Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/introduction-to-mix.html> (accessed 2026-11-04)
10. `Application` callback `start/2`. Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Application.html#c:start/2> (accessed 2026-11-04)
11. Bandit (module documentation: options, supervision tree). Bandit team, hexdocs.pm. <https://bandit.hexdocs.pm/Bandit.html> (accessed 2026-11-04)
12. `Supervisor` (strategies). Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Supervisor.html> (accessed 2026-11-04)
13. `Kernel` (`|>/2`, `def/2`, `defp/2`). Elixir v1.20.5 documentation, hexdocs.pm. <https://elixir.hexdocs.pm/Kernel.html> (accessed 2026-11-04)
14. `Plug.Router`. Plug team, hexdocs.pm. <https://plug.hexdocs.pm/Plug.Router.html> (accessed 2026-11-04)
