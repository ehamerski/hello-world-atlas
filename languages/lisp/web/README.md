# Common Lisp · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Common Lisp](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`, like the other web versions (for example
[Python](../../python/web/)). Any other path gets Hunchentoot's own
`404 Not Found` page.

The server is **Hunchentoot**, "a web server written in Common Lisp and at
the same time a toolkit for building dynamic websites" [1]. It is a
library, not part of SBCL, so it comes from **Quicklisp**, "a library
manager for Common Lisp" that can "download, install, and load any of
over 1,500 libraries" [3]. Quicklisp is the Common Lisp counterpart of
`pip` for Python or `npm` for Node.js.

As in [../cli](../cli/), `build.sh` loads everything into a running SBCL
and saves that Lisp as one executable, `bin/hello-web`. This one contains
SBCL, Hunchentoot, the libraries Hunchentoot needs, and
[`server.lisp`](server.lisp).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| SBCL | 2.6.10 (Homebrew `sbcl`) | compiles Hunchentoot and `server.lisp`, then saves the executable; installed exactly as for [../cli](../cli/README.md#prerequisites) |
| Quicklisp | installer `quicklisp.lisp` from the Quicklisp website, in `~/quicklisp/`; library list ("dist") of 2026-01-01 | downloads Hunchentoot and its libraries during `build.sh` |
| Hunchentoot | 1.3.1 (from Quicklisp) | the web server library |
| `curl` | 8.7.1 (ships with macOS) | downloads the Quicklisp installer; used by `./run.sh --verify` |

Quicklisp's page says "The libraries were last updated on January 1,
2026", and "The current version is 1.3.1" on Hunchentoot's page [3][1].
Quicklisp is not a program on your `PATH`: it is Lisp code in a folder,
which SBCL loads with `(load "~/quicklisp/setup.lisp")` [3]. Its installer
uses `quicklisp/` in your home folder by default [4], and `install.sh`
keeps that default. Quicklisp and the network are needed only to
**build**; `run.sh` needs neither.

## Quick start
```sh
./install.sh   # check SBCL, install Quicklisp into ~/quicklisp/ (asks first)
./build.sh     # download + load Hunchentoot, load server.lisp, save bin/hello-web
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks `sbcl` (if it is missing, runs [../cli/install.sh](../cli/install.sh)). 2. Checks for `~/quicklisp/setup.lisp`. 3. If Quicklisp is missing, asks, then downloads `https://beta.quicklisp.org/quicklisp.lisp`, checks its SHA-256, and runs `sbcl --non-interactive --no-sysinit --no-userinit --load quicklisp.lisp --eval '(quicklisp-quickstart:install :path "<home>/quicklisp/")'`. No `sudo`. | Quicklisp installs itself: "To install Quicklisp, download `quicklisp.lisp` and load it", then evaluate `(quicklisp-quickstart:install)` [3]. The checksum is the one published on the Quicklisp page [3], so a changed file is refused. `install.sh` does not run `(ql:add-to-init-file)`, which would "append code to your Lisp's init file" [3]; `build.sh` loads Quicklisp itself. |
| `quicklisp-env.sh` | Sets `QUICKLISP_HOME` (default `~/quicklisp`), the installer URL and its SHA-256. Read by `install.sh` and `build.sh`, not run on its own. | Both scripts must agree on where Quicklisp is. `QUICKLISP_HOME=/some/path ./install.sh` uses another folder. |
| `build.sh` | Runs `sbcl --non-interactive --no-sysinit --no-userinit --eval '(push :hunchentoot-no-ssl *features*)' --load ~/quicklisp/setup.lisp --eval '(ql:quickload :hunchentoot)' --load server.lisp --eval '(sb-ext:save-lisp-and-die "bin/hello-web" :executable t :toplevel (function hello-web:main))'` and prints it (`set -x`). | `ql:quickload` is the step that downloads: "Quicklisp will automatically download any supporting software it needs to load the system" [3]. The first build downloads Hunchentoot and its libraries into `~/quicklisp/dists/`; later builds reuse them. The SBCL options are explained in [../cli](../cli/README.md#scripts-explained). |
| `run.sh` | Exports `PORT` (default 8080) and runs `./bin/hello-web`. `--verify` starts it in the background, fetches the page once with `curl`, and stops it. | The executable is the server: there is no separate server program to start. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

**Why `:hunchentoot-no-ssl`.** Hunchentoot's documentation says: "You can
compile Hunchentoot without SSL support - and thus without the need to
have CL+SSL - if you add :HUNCHENTOOT-NO-SSL to *FEATURES* before you
compile it" [1]. `*features*` is "a list of symbols, called features, that
correspond to some aspect of the implementation or environment" [14].
Hunchentoot's system file then leaves out `cl+ssl` and its `ssl` file
(`:if-feature (:not :hunchentoot-no-ssl)` in `hunchentoot.asd` [2]). A
server on `127.0.0.1` for a Hello World does not need HTTPS. That is why
the `push` comes **before** `ql:quickload` in `build.sh`.

## Folder structure
```text
web/
├── README.md          this file
├── install.sh         checks SBCL, installs Quicklisp
├── quicklisp-env.sh   where Quicklisp lives + installer checksum (sourced)
├── build.sh           loads Hunchentoot and server.lisp, saves bin/hello-web
├── run.sh             starts the server (or checks it with --verify)
├── server.lisp        the program: package, handler, main
├── screenshot.png     the page in a browser (see Expected output)
└── bin/               created by build.sh; not committed (see ../../../.gitignore)
    └── hello-web
```
Outside the repository, `install.sh` creates `~/quicklisp/` (Quicklisp
itself), and `build.sh` adds the downloaded libraries to
`~/quicklisp/dists/quicklisp/software/`. Delete `~/quicklisp/` to remove
them all; it is shared by every Lisp project on your computer.

## Step-by-step walkthrough
Open [`server.lisp`](server.lisp) next to this list. Read
[../cli](../cli/README.md#step-by-step-walkthrough) first: lists,
`defun` and `format` work the same here.

1. **A package.** `(defpackage :hello-web (:use :cl) (:export #:main))`
   creates a namespace for names; `defpackage` "creates a package as
   specified and returns the package" [8]. `(:use :cl)` makes the standard
   names (`defun`, `format`, and others) usable without a prefix, and `:export`
   makes `main` public, so `build.sh` can write `hello-web:main`.
   `(in-package :hello-web)` makes it "the current package" [9] for the
   rest of the file. Hunchentoot's names keep their prefix
   (`hunchentoot:start`) so you can see where they come from.
2. **The handler is a macro call.**
   `(hunchentoot:define-easy-handler (say-hello :uri "/") () ...)`
   "Defines a handler as if by DEFUN and optionally registers it with a
   URI" [1]. It is a macro: Lisp passes it the code as lists, and it
   returns new code, "a form to be evaluated in place of the original
   argument form" [10]. Here that new code defines a function `say-hello`
   and registers it for `/`. This only works because Lisp code is data.
   The empty list `()` means the handler reads no request parameters.
3. **The body is the reply.** Handlers work "by eventually returning the
   response body in the form of a string" [1]. The last form,
   `"<p>Hello, World!</p>"`, is the value of the function, so it is the
   page. There is no `print` and no `return`: in Lisp, the value of the
   last expression is the result, as in the functional languages.
4. **One side effect: the header.**
   `(setf (hunchentoot:content-type*) "text/html; charset=utf-8")`.
   `setf` "changes the value of place to be newvalue" [11]; here the place
   is the reply's Content-Type header. Hunchentoot's default is already
   `"text/html"` [2]; writing it shows where headers are set.
5. **`main`: the port.** `let*` binds local variables one after another
   [12]. `(sb-ext:posix-getenv "PORT")` returns the value of `PORT`, "or
   nil if there is none" [5]; `(or ... "8080")` picks the default then,
   and `parse-integer` turns the text into a number [13]. The standard has
   no function for environment variables, so this one is an SBCL
   extension (`sb-ext`).
6. **`main`: the server object.** `make-instance` "creates and returns a
   new instance of the given class" [15], here a Hunchentoot
   `easy-acceptor`. This is CLOS, Common Lisp's object system: the third
   paradigm in one small file. `:address "127.0.0.1"` means "the server
   only receives connections for that address" [2], so only this computer
   can connect.
7. **`main`: start, then wait.** `hunchentoot:start` "Starts acceptor so
   that it begins accepting connections. Returns the acceptor" [1]: it
   does not block. On a Lisp with threads, such as this SBCL, the default
   taskmaster "starts one thread for listening to incoming requests and
   one thread for each incoming connection" [1]. So `main` must not return; it sleeps in a loop,
   `(loop (sleep 60))`.
8. **Ctrl+C.** `handler-case` runs the loop with a handler, like
   try/catch: when a matching condition is signaled, "control is
   transferred to the body of the relevant error-clause" [16]. The clause
   for `sb-sys:interactive-interrupt`, the condition this program catches
   for Ctrl+C, calls `hunchentoot:stop`, which "Stops the acceptor so that
   it no longer accepts requests" [1], and then
   `(sb-ext:exit :code 0 :abort t)`. With `:abort t`, "SBCL exits
   immediately" without unwinding the other threads [5]. On the test
   machine, sending Ctrl+C (SIGINT) to `bin/hello-web` ended it with exit
   code 0.
9. **The image again.** Steps 1 to 8 ran inside SBCL during `build.sh`,
   and `save-lisp-and-die` saved the result with `hello-web:main` as the
   start-up function, as in [../cli](../cli/README.md#scripts-explained).
   During development you would instead load the code at the REPL and
   work on the server while it runs. Common-Lisp.net describes "a flexible
   run-time environment that allows modification and debugging of running
   applications (excellent for server-side development ...)" [17].

## Why this toolchain
- **Hunchentoot** is a complete web server in Lisp: no C library and no
  separate server process. Its documentation starts a server with one line,
  `(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port
  4242))` [1], and `define-easy-handler` adds a page in three lines.
- **Quicklisp** installs Common Lisp libraries. Its page shows
  how to load systems with `(ql:quickload "system-name")` and that it
  works "with your existing Common Lisp implementation" [3], here SBCL.
- **Build once, run offline.** Doing the Quicklisp work in `build.sh`
  makes `run.sh` start a finished executable, with no Quicklisp and no
  network. The price is size: `bin/hello-web` is 48,175,232 bytes on the
  test machine, because the whole Lisp system is inside.
- **Port 8080 on 127.0.0.1**: the repository's convention for every web
  version. Hunchentoot's own default is port 80 ("Use the :port initarg if
  you don't want to listen on the default http port 80" [1]), and
  "depending on your operating system you might need special privileges
  to listen on port 80" [2].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | SBCL 2.6.10 from Homebrew (built from source, no Intel bottle [6]), Quicklisp in `~/quicklisp`, Hunchentoot 1.3.1. `otool -L bin/hello-web` lists `libSystem.B.dylib` and Homebrew's `libzstd.1.dylib` (Homebrew's SBCL depends on `zstd` [6]). |
| macOS Apple Silicon | ⚠️ not verified | `brew install sbcl` installs a pre-built bottle [6]. Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` runs the cli `install.sh` (which installs `sbcl` with apt when missing), then downloads `quicklisp.lisp`, checks its SHA-256, and installs Quicklisp into `~/quicklisp`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 package `sbcl` with `pacman` when `sbcl` is missing (through the cli `install.sh`). It then downloads `quicklisp.lisp`, checks its SHA-256, and installs Quicklisp into `~/quicklisp`. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: bin/hello-web starts Hunchentoot on 127.0.0.1 (this computer only); it
         answers GET / and logs each request to the terminal.
Listening on http://localhost:8080/
127.0.0.1 - [2026-11-01 19:43:43] "GET / HTTP/1.1" 200 20 "-" "curl/8.7.1"
<p>Hello, World!</p>
```
The `127.0.0.1 - [...]` line is Hunchentoot's access log; the last line is
the page that `curl` received.

With the server running (`./run.sh` in another terminal):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Date: Sun, 01 Nov 2026 22:43:51 GMT
Server: Hunchentoot 1.3.1
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
```
`curl -i http://localhost:8080/nope` gets `HTTP/1.1 404 Not Found` and a
small HTML error page from Hunchentoot. Press Ctrl+C in the server's
terminal to stop it.

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-02 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Hunchentoot - The Common Lisp web server formerly known as TBNL (home page and reference: installation, `easy-acceptor`, `define-easy-handler`, request handlers, `start`, `stop`, taskmasters). Edi Weitz, edicl. <https://edicl.github.io/hunchentoot/> (accessed 2026-11-01)
2. Hunchentoot v1.3.1 source: `specials.lisp` (`*default-content-type*`), `acceptor.lisp` (`:address`, `:port`), `hunchentoot.asd` (`:hunchentoot-no-ssl`). edicl, GitHub. <https://github.com/edicl/hunchentoot/tree/v1.3.1> (accessed 2026-11-01)
3. Quicklisp beta. Quicklisp. <https://www.quicklisp.org/beta/> (accessed 2026-11-01)
4. Quicklisp installer `quicklisp.lisp` (`*home*` and `install :path`). Quicklisp. <https://beta.quicklisp.org/quicklisp.lisp> (accessed 2026-11-01)
5. SBCL 2.6.10 User Manual (`sb-ext:posix-getenv`; `sb-ext:exit`; 3.6.1 Saving a Core Image). SBCL. <https://www.sbcl.org/manual/> (accessed 2026-11-01)
6. `sbcl` formula. Homebrew. <https://formulae.brew.sh/formula/sbcl> (accessed 2026-11-01)
7. Download (platform table). SBCL. <https://www.sbcl.org/platform-table.html> (accessed 2026-11-01)
8. Common Lisp HyperSpec, Macro DEFPACKAGE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defpkg.htm> (accessed 2026-11-01)
9. Common Lisp HyperSpec, Macro IN-PACKAGE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_in_pkg.htm> (accessed 2026-11-01)
10. Common Lisp HyperSpec, Glossary: M ("macro function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_m.htm> (accessed 2026-11-01)
11. Common Lisp HyperSpec, Macro SETF, PSETF. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_setf_.htm> (accessed 2026-11-01)
12. Common Lisp HyperSpec, Special Operator LET, LET*. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_let_l.htm> (accessed 2026-11-01)
13. Common Lisp HyperSpec, Function PARSE-INTEGER. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_parse_.htm> (accessed 2026-11-01)
14. Common Lisp HyperSpec, Variable *FEATURES*. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/v_featur.htm> (accessed 2026-11-01)
15. Common Lisp HyperSpec, Standard Generic Function MAKE-INSTANCE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_mk_ins.htm> (accessed 2026-11-01)
16. Common Lisp HyperSpec, Macro HANDLER-CASE. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_hand_1.htm> (accessed 2026-11-01)
17. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (accessed 2026-11-01)
18. Package `sbcl` (trixie). Debian. <https://packages.debian.org/stable/sbcl> (accessed 2026-11-01)
