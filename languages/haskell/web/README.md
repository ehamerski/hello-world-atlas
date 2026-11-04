# Haskell · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Haskell](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`, like the other web versions (for example
[Python](../../python/web/)). Any other path gets Scotty's built-in
`404 Not Found` page.

It is written with **Scotty**, a "Haskell web framework inspired by Ruby's
Sinatra, using WAI and Warp" [1]. Scotty describes itself as "the cheap and
cheerful way to write RESTful, declarative web applications" [1]. The HTTP
server inside is **Warp**, "A fast, light-weight web server for WAI
applications" [2]. The project is a **Cabal** package: "Cabal is a system
for building and packaging Haskell libraries and programs" [3]. GHC
compiles everything into one native executable.

Compare the [cli](../cli/) first: there, `main` is an `IO` action that
prints one line. Here, `main` is an `IO` action that runs a web server.
The program is still built from pure values and functions; see the
[walkthrough](#step-by-step-walkthrough).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| GHC | 9.10.3 (GHCup) | compiles the libraries and `app/Main.hs` |
| cabal-install (`cabal`) | 3.16.1.0 (GHCup) | downloads the libraries from Hackage and builds the package |
| Scotty | 0.30 (pinned in `cabal.project.freeze`) | the web framework |
| Warp | 3.4.19 (pinned in `cabal.project.freeze`) | the HTTP server Scotty runs on |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

GHC and Cabal come from GHCup, "the main installer for the general purpose
language Haskell" [4]; see [../cli](../cli/README.md#prerequisites). Scotty
0.30 was uploaded to Hackage on 2026-01-07 [1], and Warp 3.4.19 on
2026-10-29 [2].

## Quick start
```sh
./install.sh   # check / install GHC and Cabal with GHCup (asks before installing)
./build.sh     # download the libraries and build (first build on the test machine: about 8.5 min)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/>, or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `ghc --version` and `cabal --version`. If either is missing, shows GHCup's official command [4] and runs it only if you answer `y` (details in [../cli](../cli/README.md#scripts-explained)). | This version uses libraries, so it needs Cabal as well as GHC. GHCup installs both. |
| `build.sh` | 1. `cabal update`: "updates the state of the package index" [5], the list of every package and version on Hackage. 2. `cabal build`: "Compile targets within the project" [5]. It reads `hello-web.cabal` and `cabal.project.freeze`, downloads and compiles every library (first build only), then compiles `app/Main.hs` and links `hello-web`. 3. Prints where the executable is with `cabal list-bin hello-web` ("List the path to a single executable" [5]). | Like Cargo for Rust or Maven for Java, Cabal finds, downloads and builds the dependencies. |
| `run.sh` | Finds the executable with `cabal list-bin hello-web` and runs it with `PORT` (default 8080). `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | The executable is the server: there is no separate server program to install (compare [Go](../../go/web/) and [Rust](../../rust/web/)). |
| `ghcup-env.sh` | Not run on its own: the scripts read it. It adds `~/.ghcup/bin` to `PATH`. | Same as in [../cli](../cli/README.md#scripts-explained). |

**Where things go.** The project's build output goes into
`dist-newstyle/` (the folder that `cabal clean` removes [5]). The compiled
libraries go into Cabal's *store* in your home folder, so other projects
can reuse them. By default the store is under `~/.local/state/cabal` on
Unix, but if a `~/.cabal` folder already exists Cabal keeps using it [6].
On the test machine, that was `~/.cabal/store`.

**Pinned versions.** `cabal.project.freeze` was written by `cabal freeze`,
which "writes out a freeze file which records all of the versions and flags
that are picked by the solver" [5]. Cabal reads it as part of the project
configuration [7], so every student builds the same library versions, like
`Cargo.lock` or `package-lock.json`. For programs (not libraries) the Cabal
docs say "it is recommended that you distribute the `cabal.project.freeze`
file in your source repository" [5]. Its last line, `index-state`, fixes
the Hackage index state "the solver uses to compute install-plans" [7].
The file lists 133 packages, counting those that ship with GHC, such as
`base`.

## Folder structure
```text
web/
├── README.md              this file
├── install.sh             checks / installs GHC and Cabal with GHCup
├── build.sh               cabal update + cabal build
├── run.sh                 starts the server (or checks it with --verify)
├── ghcup-env.sh           adds ~/.ghcup/bin to PATH (read by the scripts)
├── screenshot.png         the page in a browser (see Expected output)
├── hello-web.cabal        the package description
├── cabal.project.freeze   the exact version of every package
├── app/
│   └── Main.hs            the program: routes + main
└── dist-newstyle/         created by cabal build; not committed (see ../../../.gitignore)
```
- There is no `cabal.project` file. Then "cabal-install fabricates an
  ephemeral project" that uses the `.cabal` file in this folder [7].
- **`hello-web.cabal`, line by line:**
  - `cabal-version: 3.0` must be the first line: since 2.2 "this field is
    only valid if fully contained in the very first line of a package
    description" [8].
  - `executable hello-web` builds a program (not a library) called
    `hello-web`. `main-is: Main.hs` and `hs-source-dirs: app` say where
    `main` is. As the Cabal docs put it: "By convention, a Haskell program
    must have a module called `Main` which exports an IO action named
    `main`" [8].
  - `build-depends` lists the libraries. `scotty ^>= 0.30` uses the caret
    operator for "PVP-style major upper bounds" [8]: it means
    `>= 0.30 && < 0.31`.
  - `default-language: Haskell2010` picks the language standard [8].
  - `ghc-options: -Wall -threaded`. `-Wall` "Turns on all warning options
    that indicate potentially suspicious code" [9]. `-threaded` means "Link
    the program with the "threaded" version of the runtime system" [10].

## Step-by-step walkthrough
Open [`app/Main.hs`](app/Main.hs) next to this list.

1. **`{-# LANGUAGE OverloadedStrings #-}`.** A `LANGUAGE` pragma turns on
   a language feature for one file; it "must precede the module keyword"
   [11]. "Normally a string literal has type `String`" [12]; with
   `OverloadedStrings` "a string literal has type `(IsString a) => a`"
   [12], so `"/"` can be a route pattern and the HTML can be Scotty's text
   type. Scotty's docs say "most of the code snippets below depend on the
   OverloadedStrings language pragma" [13].
2. **Imports** name exactly what is used, from three packages: Warp
   (`setHost`, `setPort`, `defaultSettings`), `base` (`lookupEnv`) and
   Scotty (the rest).
3. **`app :: ScottyM ()` is a value, not a running server.** This is the
   functional idea of the program. The types from Scotty's docs [13]:

   ```haskell
   get  :: RoutePattern -> ActionM () -> ScottyM ()
   html :: Text -> ActionM ()
   ```

   `html "<p>Hello, World!</p>"` is a value: an *action* that sets the
   response body and "Also sets "Content-Type" header to "text/html;
   charset=utf-8"" [13]. `get "/"` is a function that takes that action and
   returns a *route*. So `app` is only data: a description of the web app.
   Defining it does not open a port or print anything. A bigger app would
   list several routes in a `do` block, which combines them into one
   `ScottyM ()` value.
4. **`$` saves parentheses.** In the Prelude it is defined as
   `f $ x = f x`, with the lowest precedence (`infixr 0`) [14]. So
   `get "/" $ html "..."` is the same as `get "/" (html "...")`.
5. **`main :: IO ()` with `do`.** "A do expression provides a more
   conventional syntax for monadic programming" [15]: the lines are `IO`
   actions, run one after another. This is the only part of the program
   that talks to the outside world, and its type says so. The runtime
   system performs `main` when the program starts, exactly as in the
   [cli](../cli/README.md#step-by-step-walkthrough).
6. **`portVar <- lookupEnv "PORT"`.** `lookupEnv :: String -> IO (Maybe
   String)` returns "the value of the environment variable `var`, or
   `Nothing` if there is no such value" [16]. The `<-` runs the action and
   names its result. Haskell has no `null`: the `Maybe` type makes the
   code handle the "not set" case.
7. **`let port = maybe 8080 read portVar :: Int`** is pure: `let` only
   names a value. `maybe n f Nothing = n` and `maybe n f (Just x) = f x`
   [14], so the result is `8080` or the text turned into a number by
   `read`. If `read` cannot parse the text it stops the program with
   `error "Prelude.read: no parse"` [14]. **Try it:** with `PORT=abc ./run.sh`
   the server stops at once with `hello-web: Prelude.read: no parse`.
8. **`setHost "127.0.0.1" . setPort port $ defaultSettings`.** Warp's
   setters have types like `setPort :: Port -> Settings -> Settings` [17]:
   they do not change a settings object; they return a new one. `.` is
   function composition, `f . g = \ x -> f (g x)` [14], so `setPort` runs
   first, then `setHost`. Without these, Warp would use port 3000 and
   "HostIPv4" [17]. With `"127.0.0.1"` it binds "to the IPv4 local host
   only" [17], so other computers cannot connect.
9. **`defaultOptions { settings = warp }`** is a record update. It "creates
   a new value in which the specified field values replace those in the
   existing value" [15]: `defaultOptions` itself does not change. Values in
   Haskell are never modified in place.
10. **`scottyOpts defaultOptions { settings = warp } app`.** `scottyOpts
    :: Options -> ScottyM () -> IO ()` will "Run a scotty application using
    the warp server, passing extra options" [13]. It takes the pure
    description `app` and turns it into one `IO` action that serves
    requests forever. Because `verbose` is `1` by default, Scotty prints a
    "startup banner" [13] (`Setting phasers to stun...`, see below).

## Why this toolchain
- **Scotty is small.** A route is one line, `get "/" $ html ...`, and the
  whole server fits in one file, as the Hello World on its Hackage page
  shows [1]. Scotty is "set up by default for development mode" [13]; a production
  server would change its settings.
- **Cabal is Haskell's packaging system** [3], installed by GHCup with
  GHC. It downloads packages from Hackage, which the Cabal page calls "the
  Haskell Package Database" [3].
- **The cost: the first build.** Scotty and Warp need many other
  packages. The first `./build.sh` downloads and compiles all of them
  (507 s, about 8.5 min, on the test machine on 2026-11-01, with an
  empty Cabal folder, including the Hackage index download). Later builds
  reuse the store and only recompile `app/Main.hs`.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | GHC 9.10.3, cabal-install 3.16.1.0, GHCup 0.2.6.2. The link step prints `ld: warning: -U option is redundant when using -undefined dynamic_lookup`; the build still succeeds and the server works. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; GHC has an AArch64 macOS build [18]. See the GHCup note on LLVM in [../cli](../cli/README.md#platform-notes). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Same commands. Install the system packages GHCup lists first [19] (see [../cli](../cli/README.md#platform-notes)). |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install GHC and Cabal with GHCup's PowerShell command [4]. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: hello-web runs Scotty on Warp, listening on 127.0.0.1 (this
         computer only), and answers GET /.
<p>Hello, World!</p>
```
The last line is the page, fetched by `curl` in `run.sh`.

With `./run.sh` in a terminal, the server prints two more lines (the first
from `putStrLn` in `main`, the second is Scotty's startup banner) and keeps
running until Ctrl+C:
```text
$ ./run.sh

==> Start the web server on http://localhost:8080
    WHY: hello-web runs Scotty on Warp, listening on 127.0.0.1 (this
         computer only), and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
Setting phasers to stun... (port 8080) (ctrl-c to quit)
```
In `--verify` mode those two lines do not appear. The server's output
goes into a pipe there, not a terminal, and "The default buffering mode
when a handle is opened is implementation-dependent" [20]. With GHC the
lines stayed in the output buffer, and the server was stopped before the
buffer was written out.

In a second terminal:
```text
$ curl -i http://127.0.0.1:8080/
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Sun, 01 Nov 2026 22:43:27 GMT
Server: Warp/3.4.19
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
```
Any other path, for example `curl -i http://127.0.0.1:8080/nope`, gets
`HTTP/1.1 404 Not Found` and the body `<h1>404: File Not Found!</h1>` from
Scotty.

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-02 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. `scotty`: Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp (version 0.30). Hackage. <https://hackage.haskell.org/package/scotty> (accessed 2026-11-01)
2. warp: A fast, light-weight web server for WAI applications (version 3.4.19). Hackage. <https://hackage.haskell.org/package/warp> (accessed 2026-11-01)
3. The Haskell Cabal: Overview. haskell.org. <https://www.haskell.org/cabal/> (accessed 2026-11-01)
4. GHCup (home page: install commands). haskell.org. <https://www.haskell.org/ghcup/> (accessed 2026-11-01)
5. Cabal User Guide: Commands (update, build, list-bin, freeze, clean). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-commands.html> (accessed 2026-11-01)
6. Cabal User Guide: Configuration (directories, XDG and `~/.cabal`). Cabal developers. <https://cabal.readthedocs.io/en/stable/config.html> (accessed 2026-11-01)
7. Cabal User Guide: cabal.project Reference (configuration sources, implicit project, index-state). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html> (accessed 2026-11-01)
8. Cabal User Guide: Package Description (cabal-version, main-is, build-depends, `^>=`, default-language). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html> (accessed 2026-11-01)
9. GHC 9.10.3 User's Guide: Warnings and sanity-checking (-Wall). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/using-warnings.html> (accessed 2026-11-01)
10. GHC 9.10.3 User's Guide: Options related to a particular phase (-threaded). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/phases.html> (accessed 2026-11-01)
11. Haskell 2010 Language Report, Chapter 12: Compiler Pragmas (12.3 Language extensions). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch12.html> (accessed 2026-11-01)
12. GHC 9.10.3 User's Guide: Overloaded string literals. GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/exts/overloaded_strings.html> (accessed 2026-11-01)
13. `Web.Scotty` (`scotty-0.30` API documentation: `get`, `html`, `scottyOpts`, `Options`). Hackage. <https://hackage.haskell.org/package/scotty-0.30/docs/Web-Scotty.html> (accessed 2026-11-01)
14. Haskell 2010 Language Report, Chapter 9: Standard Prelude (`$`, `.`, `maybe`, `read`). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch9.html> (accessed 2026-11-01)
15. Haskell 2010 Language Report, Chapter 3: Expressions (3.14 Do Expressions, 3.15.3 Updates Using Field Labels). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch3.html> (accessed 2026-11-01)
16. `System.Environment` (`base-4.20.2.0` API documentation: `lookupEnv`). Hackage. <https://hackage.haskell.org/package/base-4.20.2.0/docs/System-Environment.html> (accessed 2026-11-01)
17. `Network.Wai.Handler.Warp` (`warp-3.4.19` API documentation: `setPort`, `setHost`, `HostPreference`). Hackage. <https://hackage.haskell.org/package/warp-3.4.19/docs/Network-Wai-Handler-Warp.html> (accessed 2026-11-01)
18. GHC 9.10.3 download page (binary distributions). GHC developers, haskell.org. <https://www.haskell.org/ghc/download_ghc_9_10_3.html> (accessed 2026-11-01)
19. GHCup: System requirements. haskell.org. <https://www.haskell.org/ghcup/install/reqs/> (accessed 2026-11-01)
20. Haskell 2010 Language Report, Chapter 41: System.IO (41.4.3 Buffering Operations). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch41.html> (accessed 2026-11-01)
