# Erlang · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Erlang](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`, like the other web versions (for example
[Elixir](../../elixir/web/)). Any other path gets a `404` response.

The server is **httpd**, from the `inets` application of Erlang/OTP. The
documentation describes it as "An implementation of an HTTP 1.1 compliant
web server, as defined in RFC 2616" [1]. It ships with Erlang/OTP, so
nothing is downloaded: there is no package manager step, unlike the
[Elixir web](../../elixir/web/) version, which needs Plug and Bandit from
Hex.

The program is one compiled module, `hello_httpd`. It does two jobs:
`main/0` starts the server, and `do/1` is the function that `httpd` calls
for every request. Compare the [cli](../cli/) version first: there, one
script prints one line.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Erlang/OTP (`erl`, `erlc`) | 29.1.2 (Homebrew `erlang` 29.1.2), as in [../cli](../cli/README.md#prerequisites) | compiles the module and runs it on the BEAM |
| `inets` application | 9.8.1, part of Erlang/OTP 29.1.2 | contains `httpd` |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

On Intel Macs, Homebrew builds Erlang from source, which took about 15
minutes plus about 7 minutes for `wxWidgets`, a dependency, on the test
machine (2026-11-01) [2]. See [../cli](../cli/README.md#prerequisites).

## Quick start
```sh
./install.sh   # check / install Erlang/OTP and inets (asks before installing)
./build.sh     # erlc: hello_httpd.erl -> ebin/hello_httpd.beam
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `erl`, `erlc`, and the `inets` application (`code:lib_dir(inets)` fails when it is absent). If something is missing, offers the install command (see [../cli](../cli/README.md#scripts-explained)). | The program needs the compiler and `inets`. |
| `build.sh` | Runs `erlc -Wall -o ebin hello_httpd.erl`. | The BEAM runs bytecode. For a `.erl` file, `erlc` "generates a `.beam` file" [3], and `-o` is "The directory where the compiler is to place the output files" [3]. `-Wall` enables all warnings (see `erlc -h`). |
| `run.sh` | Runs `erl +Bd -noshell -pa ebin -s hello_httpd main` with `PORT` (default 8080). `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `-pa ebin` "Adds the specified directories to the beginning of the code path", and `-s` "Makes `init` call the specified function" [4]. `main/0` never returns, so the server keeps running. |

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks / installs Erlang/OTP and inets
├── build.sh           erlc -> ebin/hello_httpd.beam
├── run.sh             starts the server (or checks it with --verify)
├── hello_httpd.erl    the program (teaching comments)
├── screenshot.png     the page in a browser (see Expected output)
├── .gitignore         keeps ebin/ and *.beam out of Git
└── ebin/              created by build.sh; not committed
    └── hello_httpd.beam
```
- `ebin/` is the folder for compiled code in the layout that Erlang/OTP
  documents: "`ebin` - Required. Contains the Erlang object code, the
  `.beam` files" [5].
- There is no project file and no lock file: the only dependency is
  Erlang/OTP itself.

## Step-by-step walkthrough
Open [`hello_httpd.erl`](hello_httpd.erl) next to this list.

1. **`-module(hello_httpd).`** names the module, and
   `-export([main/0, do/1]).` makes two functions callable from outside.
   `do/1` must be exported, or `httpd` could not reach it.
2. **`-include_lib("inets/include/httpd.hrl").`** reads the header that
   defines the record `#mod{}`, the data of one request. A record is a
   tuple with named fields: "a record is not a true data type", because
   "record expressions are translated to tuple expressions during
   compilation" [6].
3. **Reading `PORT` with `case`.** `os:getenv("PORT")` returns the text, or
   `false` when the variable is not set. The `case` expression matches
   that value against patterns, top to bottom: `false -> 8080` or
   `Text -> list_to_integer(Text)`. "The expression `Expr` is evaluated
   and the patterns `Pattern` are sequentially matched against the result"
   [7]. The name `Text` starts with an uppercase letter, so it is a
   variable that takes any other value. With `PORT=abc`, `list_to_integer/1`
   fails and the server does not start.
4. **`ok = inets:start(),`** starts the `inets` application. An
   application is a component of Erlang/OTP [8]. The `ok =` on the left is
   an assertion by pattern matching: "If the matching fails, a `badmatch`
   run-time error occurs" [7]. If `start/0` returned anything but `ok`,
   the program would stop with a clear error. Erlang code does not usually
   check for errors by hand.
5. **`inets:start(httpd, Properties)`** starts one HTTP server. The
   properties are a list of `{Key, Value}` tuples:
   - `port` is where it listens. `server_root` and `document_root` are
     mandatory: the documentation lists `port`, `server_root`, and
     `document_root` as the required properties [1]. This server sends no file, so the
     current folder, `"."`, is enough.
   - `server_name` is the name the server reports. If it is not given, it
     "defaults to `net_adm:localhost()`" [1].
   - `bind_address` is `{127, 0, 0, 1}`, an IP address as a tuple of its
     four numbers. The default is `any` [1]. With `{127, 0, 0, 1}`, other
     computers cannot connect.
   - `modules` "Defines which modules the HTTP server uses when handling
     requests" [1]. Its default list has `mod_get`, `mod_dir`, and others.
     Here the list has one entry, `?MODULE`, a macro that the compiler
     replaces with `hello_httpd`.
6. **Waiting.** `io:format("Listening on http://localhost:~w/~n", [Port])`
   prints the port: `~w` "Writes data with the standard syntax" [9].
   Then `receive never -> ok end` blocks forever, because no message
   matches the pattern `never`. `httpd` runs in other processes, so this
   process only has to stay alive. Ctrl+C ends the program.
7. **`do/1`, the callback.** "When a valid request reaches `httpd`, it
   calls `do/1` in each module, defined by the configuration option of
   `Module`" [1]. The first clause,
   `do(#mod{method = "GET", request_uri = "/"})`, takes two fields out of
   the record in the head of the function, and it matches only a `GET` of
   `/`. The second clause, `do(_ModData)`, matches everything else:
   Erlang tries the clauses from top to bottom.
8. **The answer.** The return value is `{proceed, [{response, {response,
   Head, Body}}]}`. The documentation lists the return values and the
   `{response, Head, Body}` data, and says: "It is strongly advised to use
   NewDataFormat in the return value of `do/1`" [1]. `Head` is a list of
   `{Key, Value}` tuples: the status `code`, the `content_type`, and the
   `content_length`. The body is a string, which is a list of characters
   [6].
9. **Processes.** In Erlang, "each thread of execution is called a
   process", and processes "share no data" [10]. The program starts no
   process of its own for requests: `httpd` runs in other processes, so
   the process of `main/0` only has to stay alive.

**Try it:** change the body to `<h1>Hello, World!</h1>`, or add a clause for `"/hello"` before the last one, then run
`./build.sh && ./run.sh`.

## Why this toolchain
- **`httpd` ships with Erlang/OTP** [1], so this version is the smallest
  web program of the repository in dependencies: no download, no lock
  file.
- **A module and `erlc`** are the normal way to build Erlang code, which
  the [cli](../cli/) escript hides.
- **The cost: the API is low level.** The program builds the headers by
  hand, which a framework would do for it. Erlang has frameworks, but this
  repository keeps to the standard distribution.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Erlang/OTP 29.1.2, `inets` 9.8.1 from Homebrew. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. Homebrew installs a bottle [2]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `erlang` with apt when `erl`, `erlc` or the `inets` application is missing, as in [../cli](../cli/README.md#platform-notes). |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` unpacks the official 64-bit Erlang/OTP zip into `~/.local/otp-29.1.2` when it is missing, as in [../cli](../cli/README.md#platform-notes). The zip includes `inets`. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: erl runs hello_httpd:main(), which starts inets and its httpd server on
         127.0.0.1 (this computer only) and waits.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
```

In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Wed, 04 Nov 2026 23:55:29 GMT
Server: inets/9.8.1
Content-Type: text/html; charset=UTF-8
Content-Length: 20

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

The self-check:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: erl runs hello_httpd:main(), which starts inets and its httpd server on
         127.0.0.1 (this computer only) and waits.
Listening on http://localhost:8080/
<p>Hello, World!</p>
```
The last line is the page, fetched by `curl` in `run.sh`. When `run.sh`
stops the server, Erlang logs `SIGTERM received - shutting down`.

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. httpd. Erlang/OTP documentation, inets. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/inets/httpd.html> (accessed 2026-11-04)
2. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (accessed 2026-11-04)
3. erlc. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erlc_cmd.html> (accessed 2026-11-04)
4. `erl` (`-pa`, `-s`, `-noshell`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (accessed 2026-11-04)
5. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (accessed 2026-11-04)
6. Data types (atom, record, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (accessed 2026-11-04)
7. Expressions (`case`, pattern matching). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (accessed 2026-11-04)
8. Design principles (applications, supervision trees). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/design_principles.html> (accessed 2026-11-04)
9. `io` (control sequence `~w`). Erlang/OTP documentation, stdlib. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/stdlib/io.html> (accessed 2026-11-04)
10. Conc prog (processes). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (accessed 2026-11-04)
