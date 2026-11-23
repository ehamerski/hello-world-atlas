# Clojure · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Clojure](../README.md)

## What this is
A web server that answers `GET /` with the HTML `<p>Hello, World!</p>`. It
is built with **Ring**, Clojure's standard web application interface, and
runs on **Jetty**, a Java web server that the Ring Jetty adapter embeds. The
server listens on `127.0.0.1` (this computer only), on the port in the
environment variable `PORT` (default 8080). It runs until you press
Ctrl+C.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Java runtime 21 or newer | Eclipse Temurin 21.0.8 | runs the bytecode of Clojure, Ring, and Jetty |
| Clojure CLI | 1.12.6.1673 (Clojure 1.12.6) | downloads the libraries and starts the JVM; see [../cli](../cli/README.md#prerequisites) |
| `ring/ring-core` | 1.15.6 | Ring's request and response functions [1] |
| `ring/ring-jetty-adapter` | 1.15.6 (it brings Jetty 12.1.14) | "a Ring adapter that uses an embedded Jetty web server" [1][2] |

`curl` is used by `./run.sh --verify`. The libraries come from Clojars and
Maven Central; `install.sh` downloads them with `clojure -P`.

## Quick start
```sh
./install.sh   # check / install Java and the Clojure CLI, download Ring and Jetty
./run.sh       # serve http://localhost:8080/ until Ctrl+C
```
There is no `build.sh`: Clojure compiles the source when it loads it. The
reason is in [../cli](../cli/README.md#why-there-is-no-buildsh).

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Same three steps as [../cli](../cli/README.md#scripts-explained). Step 3, `clojure -P`, also downloads Ring, Jetty, and their dependencies into `~/.m2`. | The first start then needs no download. |
| `run.sh` | Exports `PORT` (default 8080) and runs `clojure -M -m hello.core`, which stays up. With `--verify`, starts the server in the background, fetches the page once with `curl`, and stops the server. | `hello.core` reads `PORT` too, so the script and the server agree. The self-check lets `scripts/verify-all.sh` test the server without waiting for you. |
| `clojure-env.sh` | Sets the CLI version, the installer checksum and `CLOJURE_DIR`. | The same file as in [../cli](../cli/). |

## Folder structure
```text
web/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI, downloads the libraries
├── run.sh           starts the server
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folder and the two Ring libraries
├── screenshot.png   the page in a browser, for "Expected output" below
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
The layout is the one of [../cli](../cli/README.md#folder-structure) [3].

## Step-by-step walkthrough
Open [`core.clj`](src/hello/core.clj) and [`deps.edn`](deps.edn) next to
this list.

1. **`deps.edn`** names the two libraries and their versions. The CLI
   downloads them, and what they need, from Clojars and Maven Central [3].
   Java projects do this in `pom.xml`
   ([java/web](../../java/web/README.md#folder-structure)).
2. **`(:require [ring.adapter.jetty :as jetty])`** loads the namespace that
   starts Jetty and gives it the short name `jetty`. Java's `import` and
   Python's `import ... as ...` are the closest forms.
3. **Ring's model.** The Ring README says that Ring is "inspired by
   Python's WSGI and Ruby's Rack" [1]. The Ring specification says that
   "Handlers are implemented as Clojure functions" and that "A synchronous
   handler takes 1 argument, a request map, and returns a response map" [4].
   An adapter is a function that takes a handler and options and starts a
   server [4]; `run-jetty` is the Jetty adapter.
4. **`handler`** takes the request map (the parameter `_request` is
   unused, and the leading underscore says so) and returns the response
   map: `:status 200`, `:headers` with `Content-Type`, and `:body` with the
   HTML string. Spring Boot ([java/web](../../java/web/)) uses annotated
   classes and methods for the same job; here the handler is one function
   and its result is data.
5. **`-main`.** `(System/getenv "PORT")` calls Java's `System.getenv`. It
   returns `nil` when the variable is not set, and `or` then picks the
   default `"8080"`. `parse-long` turns the text into a number.
6. **`jetty/run-jetty`** starts the server. Its options are a map [5]:
   `:host "127.0.0.1"` listens on this computer only, `:port` is the port,
   and `:join? true` blocks the calling thread until the server ends, so
   `-main` does not return right after starting Jetty. The Jetty adapter
   documents `:host` as "the hostname to listen on", `:port` as "the port to
   listen on (defaults to 80)" and `:join?` as "blocks the thread until
   server ends" [5].
7. **The response header.** The handler sets `text/html; charset=UTF-8`.
   Jetty sends it as `text/html;charset=utf-8`, which means the same (see
   "Expected output").
8. **`./run.sh --verify`** starts the server in the background, polls the
   URL with `curl`, prints the body, and stops the server.

## Why this toolchain
- **Ring is Clojure's web application interface.** Its README calls Ring
  "a Clojure web applications library inspired by Python's WSGI and Ruby's
  Rack" that lets web applications "be constructed of modular components
  that can be shared among a variety of applications, web servers, and web
  frameworks" [1]. It plays the role of Express in
  [Node.js](../../node/web/README.md) and Flask in
  [Python](../../python/web/README.md): a small library, and the page is a
  few lines.
- **Jetty through the Ring adapter.** The adapter embeds Jetty in the
  program, so there is no separate web server to install, as with Spring
  Boot's embedded Tomcat in [java/web](../../java/web/).
- **Versions.** Clojars lists 1.15.6 as the latest release of both
  `ring-core` and `ring-jetty-adapter` [2][6], and the Ring README gives
  `ring/ring-core {:mvn/version "1.15.6"}` in its installation section [1].
  Both libraries are used at the same version because they are released
  together.
- **`ring/ring-core` is listed although the code does not call it.** The
  Ring README describes it as holding "core functions and middleware for
  Ring handlers, requests and responses" [1]. The Jetty adapter already
  depends on it, so the line only makes the dependency visible.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6), Ring 1.15.6, Jetty 12.1.14. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does the same as in [../cli](../cli/README.md#platform-notes). `clojure -P` downloads Ring and Jetty. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does the same as in [../cli](../cli/README.md#platform-notes). `clojure -P` downloads Ring and Jetty. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh --verify` printed, on 2026-11-04 (the three `SLF4J` lines come
from Jetty's logging library, which finds no logging back end and stays
quiet):
```text
==> Start the web server on http://localhost:8080
    WHY: Ring starts the embedded Jetty server on 127.0.0.1 (this computer only).
SLF4J(W): No SLF4J providers were found.
SLF4J(W): Defaulting to no-operation (NOP) logger implementation
SLF4J(W): See https://www.slf4j.org/codes.html#noProviders for further details.
<p>Hello, World!</p>
```
While `./run.sh` runs, `curl -i http://localhost:8080/` printed:
```text
HTTP/1.1 200 OK
Server: Jetty(12.1.14)
Date: Wed, 04 Nov 2026 16:13:22 GMT
Content-Type: text/html;charset=utf-8
Content-Length: 20

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Chrome:
`Google Chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`
while the server ran.)

## Sources
1. Ring README (libraries, installation, "inspired by Python's WSGI and Ruby's Rack"). ring-clojure, GitHub. <https://github.com/ring-clojure/ring> (accessed 2026-11-04)
2. ring/ring-jetty-adapter (latest version 1.15.6). Clojars. <https://clojars.org/ring/ring-jetty-adapter> (accessed 2026-11-04)
3. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (accessed 2026-11-04)
4. The Ring Specification (SPEC.md). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/SPEC.md> (accessed 2026-11-04)
5. `ring.adapter.jetty/run-jetty` source and docstring (options `:host`, `:port`, `:join?`). ring-clojure, GitHub. <https://github.com/ring-clojure/ring/blob/master/ring-jetty-adapter/src/ring/adapter/jetty.clj> (accessed 2026-11-04)
6. ring/ring-core (latest version 1.15.6). Clojars. <https://clojars.org/ring/ring-core> (accessed 2026-11-04)
