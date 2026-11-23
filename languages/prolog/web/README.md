# Prolog · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Prolog](../README.md)

## What this is
A small web server written in Prolog. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
It is one file, [`server.pl`](server.pl), run by SWI-Prolog. The HTTP
server comes from SWI-Prolog's own libraries, so nothing is downloaded
besides SWI-Prolog itself.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| SWI-Prolog (`swipl`) | 10.0.2 (Homebrew `swi-prolog` 10.0.2) | runs `server.pl`; includes the HTTP server libraries |
| `curl` | the system `curl` | only for `./run.sh --verify` and for testing by hand |

The libraries `library(http/thread_httpd)` and `library(http/http_dispatch)`
are part of SWI-Prolog's HTTP package [1]; they were present in the
Homebrew installation without any extra step. Install notes for
SWI-Prolog itself (no Homebrew bottle on Intel Macs [2]) are in the
[cli README](../cli/README.md#prerequisites).

## Quick start
```sh
./install.sh   # check / install SWI-Prolog (asks before installing)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Same check as in the [`cli` version](../cli/README.md#scripts-explained): runs `swipl --version`, and, if it is missing, offers the install command for your operating system and runs it only if you answer `y`. | SWI-Prolog is the only thing to install; the HTTP libraries come with it. |
| `run.sh` | Exports `PORT` (default 8080) and runs `swipl server.pl`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `server.pl` reads the same `PORT` variable, so script and server agree. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`: SWI-Prolog compiles the file in memory when it
loads it, as explained in [../cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md       this file
├── install.sh      checks / installs SWI-Prolog
├── run.sh          starts the server (or --verify)
├── screenshot.png  the page in a browser (see Expected output)
└── server.pl       the web server: one handler, one main/0
```
- One file is enough. The SWI-Prolog manual's own server skeleton is a
  single file: "If this file is loaded as main file (using e.g.,
  `swipl server.pl`) it creates a simple server that listens on port
  8080" [1]. This repository uses the same file name.
- Nothing is generated, so nothing needs to be ignored by Git.
  `screenshot.png` is only for this README.

## Step-by-step walkthrough
Open [`server.pl`](server.pl) next to this list. Read the
[`cli` walkthrough](../cli/README.md#step-by-step-walkthrough) first: it
explains clauses, rules, goals, and `initialization(main, main)`.

1. **Load the libraries.** `:- use_module(library(http/thread_httpd)).`
   is a directive that loads a library. All its exported predicates "are
   imported into the module from which this predicate is called" [3], like
   `import` in Java or Python. `thread_httpd` "is responsible for accepting
   and managing connections"; `http_dispatch` "associates the path of the
   HTTP request with a handler that services this particular path" [1].
2. **`:- initialization(main, main).`** works as in the `cli` version: after loading,
   Prolog proves `main` [4]. The difference is in step 5: this `main`
   never finishes.
3. **Register the handler: `:- http_handler(root(.), say_hello, []).`**
   This directive runs while the file loads and adds a route.
   `http_handler/3` will "Register Closure as a handler for HTTP
   requests" [5]. `root(.)` is the path `/` (the root of the server); the
   path can be "an absolute path such as `'/home.html'` or a term
   Alias(Relative)" [5]. The second argument is only the predicate name
   `say_hello`, without arguments. For each matching request "Closure is
   called as below, where Request is the parsed HTTP request:
   `call(Closure, Request)`" [5]. So the server builds the goal
   `say_hello(Request)` and proves it. The last argument, `[]`, is the
   (empty) list of options. Express (`app.get("/", ...)`) and Flask
   (`@app.route("/")`) do the same job with a function; in Prolog the
   handler is a predicate.
4. **The handler is a rule:**
   ```prolog
   say_hello(_Request) :-
       format("Content-type: text/html; charset=UTF-8~n~n"),
       format("<p>Hello, World!</p>").
   ```
   Read it as "`say_hello(Request)` is true if these two `format` goals
   are true". When the server calls it, the head `say_hello(_Request)` is
   *unified* with the goal `say_hello(Request)`, so the variable
   `_Request` is bound to the request. Names that start with an uppercase
   letter or `_` are variables [6]; the `_` also tells the reader that
   this one is not used. The handler is called "with the parsed request
   ... as argument and `current_output` set to a temporary buffer". Like a
   CGI script, "it must write a header declaring at least the
   Content-type field and a body" [1]. The first `format` writes that
   header and an empty line (`~n~n`), and the second writes the body. The
   response is a *side effect* of proving the goal, not a return value.
5. **`main/0`** has three parts:
   - **Read the port.** `( getenv('PORT', Value) -> atom_number(Value,
     Port) ; Port = 8080 )` is Prolog's if-then-else. `getenv/2` will "Get
     environment variable" and "Fails silently if the variable does not
     exist" [7]. If it succeeds, `atom_number/2` converts the text to a
     number [8]. If it fails, Prolog takes the else branch, and
     `Port = 8080` *unifies* `Port` with 8080. A Prolog variable cannot be
     changed afterwards: "After binding a variable, it cannot be
     modified" [9]. Failing is not an error here; it is how a test says
     "no".
   - **Start the server.** `http_server(http_dispatch,
     [port(localhost:Port)])`. `http_server/2` will "Create the server",
     made of "a small Prolog thread accepting new connection on Port and
     dispatching these to a pool of workers"; the port option can be "a
     port (integer) or a term Host : Port" [10]. With `localhost:Port` the
     server only listens on this computer: `lsof` showed
     `TCP 127.0.0.1:<port> (LISTEN)` on the test machine. The default pool
     is "five workers" [10]. `http_dispatch` is the goal each request is
     passed to; it looks up the handler registered in step 3.
   - **Wait.** `http_server/2` returns at once, and when `main` succeeds
     the program would halt "with status 0" [4], stopping the server.
     So `main` ends with `thread_get_message(_)`, which "blocks execution
     until a term that unifies to Term arrives in the queue" [11]. No
     message is ever sent, so it waits until you press Ctrl+C.

Compare the [`cli` version](../cli/hello.pl): there `main` succeeds at once and
Prolog halts; here the server's threads own the work and `main` must
block.

## Why this toolchain
- **SWI-Prolog's HTTP libraries** are the server the SWI-Prolog manual
  documents and uses in its own examples [1]. They ship with SWI-Prolog,
  so the web version needs no package manager, no download, and no extra
  install step.
- **`format/1` instead of `library(http/html_write)`**:
  `html_write` "translates a Prolog term into an HTML document", and the
  manual's examples build pages with its `reply_html_page/2` [1]. This
  server writes the header and the HTML with `format/1` instead, because
  it shows what an HTTP reply is made of, with no HTML library in
  between. The manual says "writing an HTML reply this way is
  deprecated", because code that copies request data into the page "is
  subject to injection attacks" [1]. This handler writes only a fixed
  string, so that risk does not apply; a larger application should use
  `html_write`.
- **Port 8080** is the repository's convention for every web implementation,
  and also the port of the manual's own example server [1].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | SWI-Prolog 10.0.2 from Homebrew, built from source (no Intel bottle) [2]. |
| macOS Apple Silicon | ⚠️ not verified | `brew install swi-prolog` installs a pre-built bottle [2]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `swi-prolog-nox` with apt when `swipl` is missing. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 packages `swi-prolog-core` and `swi-prolog-packages` with `pacman` when `swipl` is missing. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: swipl loads server.pl and proves 'main', which starts SWI-Prolog's
         HTTP server on 127.0.0.1 (this computer only) and waits.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
% Started server at http://localhost:8080/
Listening on http://localhost:8080/
```
The line starting with `%` is printed by SWI-Prolog's server library; the
`Listening on ...` line comes from `main` in `server.pl`.

In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Sun, 01 Nov 2026 22:49:45 GMT
Content-Type: text/html; charset=UTF-8
Connection: Keep-Alive
Content-Length: 20

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

The self-check:
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: swipl loads server.pl and proves 'main', which starts SWI-Prolog's
         HTTP server on 127.0.0.1 (this computer only) and waits.
% Started server at http://localhost:8080/
Listening on http://localhost:8080/
<p>Hello, World!</p>
```

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-02 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. SWI-Prolog HTTP support: 3 The HTTP server libraries. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=httpserver> (accessed 2026-11-01)
2. `swi-prolog` formula. Homebrew. <https://formulae.brew.sh/formula/swi-prolog> (accessed 2026-11-01)
3. SWI-Prolog Reference Manual: use_module/1. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=use_module/1> (accessed 2026-11-01)
4. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (accessed 2026-11-01)
5. http_handler/3. SWI-Prolog (`library(http/http_dispatch)`). <https://www.swi-prolog.org/pldoc/doc_for?object=http_handler/3> (accessed 2026-11-01)
6. SWI-Prolog Reference Manual: 2.15 The SWI-Prolog syntax (variables). SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=syntax> (accessed 2026-11-01)
7. SWI-Prolog Reference Manual: getenv/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=getenv/2> (accessed 2026-11-01)
8. SWI-Prolog Reference Manual: atom_number/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=atom_number/2> (accessed 2026-11-01)
9. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (accessed 2026-11-01)
10. http_server/2. SWI-Prolog (`library(http/thread_httpd)`). <https://www.swi-prolog.org/pldoc/doc_for?object=http_server/2> (accessed 2026-11-01)
11. SWI-Prolog Reference Manual: thread_get_message/1. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=thread_get_message/1> (accessed 2026-11-01)
