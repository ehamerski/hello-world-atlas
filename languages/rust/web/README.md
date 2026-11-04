# Rust · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Rust](../README.md)

## What this is
A web server on <http://localhost:8080/> (port set by `PORT`, default
`8080`) that answers `GET /` with the HTML `<p>Hello, World!</p>`. The
server sends the HTML itself; there is no separate front end.

Rust's standard library has no HTTP server (Go's has `net/http`), so two
crates (libraries) do the work:
- **Axum**, "an HTTP routing and request-handling library that focuses on
  ergonomics and modularity" [1]: it maps `/` to a function.
- **Tokio**, the asynchronous runtime that runs that function, "an
  event-driven, non-blocking I/O platform for writing asynchronous
  applications with the Rust programming language" [2].

Compare [../cli](../cli/): `main` no longer ends after one line. It starts
a server and waits for requests until you press Ctrl+C.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Rust 1.85 or newer (`rustc` + `cargo`) | Rust 1.98.1 (Homebrew) | builds the program; downloads the crates |
| Axum | 0.8.9 (published 2026-04-14) [9] | routing and HTML responses; downloaded by `cargo build` |
| Tokio | 1.54.1 (published 2026-10-21) [9] | the async runtime; downloaded by `cargo build` |
| curl | 8.x (macOS built-in) | only for `./run.sh --verify` |

Rust 1.85 is the minimum because `Cargo.toml` uses edition 2024 (see
[../cli](../cli/README.md#prerequisites)); Tokio 1.54.1 declares the same
minimum and Axum 0.8.9 declares 1.80 [9]. Axum, Tokio, and the 46 crates
they need (48 compiled on macOS in total, counted with `cargo tree`) are
dependencies of this project, not tools on your computer, so `install.sh`
does not install them: `cargo build` does.

## Quick start
```sh
./install.sh   # check / install Rust (asks before installing)
./build.sh     # download the crates and compile (first time: about 40 s)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Then open <http://localhost:8080/> or run `curl http://localhost:8080/`.
Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Same check as [../cli](../cli/README.md#scripts-explained): Rust 1.85+, or the rustup install command if missing. | Rust is compiled. |
| `build.sh` | Runs `cargo build --release --locked` | The first build downloads every crate listed in `Cargo.lock` from crates.io into Cargo's cache (`~/.cargo/registry`), compiles them, and then compiles `src/main.rs`. `--locked` makes it fail instead of quietly picking other versions [4]. On the test machine, the first build took about 40 seconds; later builds recompile only `main.rs`. |
| `run.sh` | Exports `PORT` (default 8080) and runs `./target/release/hello-web`. With `--verify` it starts the server in the background, fetches `/` once with `curl` (waiting up to 10 s), prints the answer, and stops the server. | The executable already contains Axum, Tokio, and hyper, so there is no separate server program (compare Tomcat inside Spring Boot in [../../java/web](../../java/web/)). `exec` replaces the script with the server, so Ctrl+C stops the server directly. |

## Folder structure
```text
web/
├── README.md        this file
├── install.sh       checks / installs Rust
├── build.sh         downloads the crates and compiles
├── run.sh           starts the server
├── screenshot.png   the page in a browser, for "Expected output" below
├── Cargo.toml       the manifest: name, edition, and the dependencies axum and tokio
├── Cargo.lock       the exact version of all 48 crates (written by cargo)
├── src/
│   └── main.rs      the program
└── target/          created by build.sh; not committed
    └── release/
        └── hello-web
```
- The same Cargo layout as [../cli](../cli/README.md#folder-structure):
  "The default executable file is src/main.rs" [3].
- **`[dependencies]`** in `Cargo.toml` has two lines. `axum = "0.8"` is a
  caret requirement, "the default version requirement strategy" [5]. For
  versions below 1.0 the second number counts as the major one:
  "0.2.3 := >=0.2.3, <0.3.0" [5], so `"0.8"` accepts 0.8.9 but never 0.9.
- **`features = [...]`** on Tokio: "Features of dependencies can be enabled
  within the dependency declaration" [6]. Tokio turns off most of its parts
  by default; this program needs the multi-threaded runtime
  (`rt-multi-thread`), the `#[tokio::main]` attribute (`macros`), and TCP
  (`net`).
- **`Cargo.lock`** lists every crate with its version and checksum, so every
  student builds the same code. It is committed [7], like `go.sum` in
  [../../go/desktop](../../go/desktop/) and `package-lock.json` in npm
  projects. Downloaded crates are not in this folder (unlike
  `node_modules/`): Cargo keeps one shared cache in `~/.cargo/registry`.

## Step-by-step walkthrough
Open [`src/main.rs`](src/main.rs) next to this list.

1. **`use axum::{Router, response::Html, routing::get};`** brings three
   names from the `axum` crate into scope, like Go's `import` or Python's
   `from ... import`.
2. **`async fn hello() -> Html<&'static str>`** is the handler.
   - `async fn` does not run its body right away: it returns a *future*
     that a runtime runs later. "Rust lets you choose [a runtime] depending
     on your requirements, rather than providing one" [8]; this program
     chooses Tokio. While one request waits for the network, Tokio runs
     others on the same threads.
   - `Html(...)` is "An HTML response", which will "automatically get
     Content-Type: text/html" [1].
   - `&'static str` is a borrowed string that lives as long as the program:
     the text is a constant inside the executable.
   - There is no `return` and no semicolon on the last line: a Rust block's
     last expression is its value.
3. **`#[tokio::main]`** "Marks async function to be executed by the selected
   runtime" [2]. The async book explains it: it "initializes the Tokio
   runtime and starts an async task for running the code in main" [8].
   Without it, `main` could not be `async`.
4. **`std::env::var("PORT").unwrap_or_else(|_| "8080".to_string())`** reads
   the port. `env::var` returns a `Result`: `Ok(value)` or `Err` when the
   variable is not set. `unwrap_or_else` turns an `Err` into the default.
   Rust has no `null` and no exceptions: a missing value is an ordinary
   return value that the code must handle (compare Go's `if port == ""`).
5. **`Router::new().route("/", get(hello))`** maps `GET /` to `hello`. Any
   other path gets `404 Not Found`. "get routes will also be called for
   HEAD requests but will have the response body removed" [1].
6. **`TcpListener::bind(&addr).await.expect(...)`** listens on
   `127.0.0.1:8080`, this computer only. `.await` waits for the future
   without blocking a thread; `.expect` stops the program with that
   message if binding fails, for example when the port is already in use.
7. **`axum::serve(listener, app).await`** "Serve[s] the service with the
   supplied listener" [1], forever, until the program is stopped.

## Why this toolchain
- **Usage:** in the Stack Overflow
  Developer Survey 2026, 3.6% of the 10,281 respondents to the web
  frameworks question used Axum, and 70.6% of those want to keep using it
  ("admired") [10]. It lives in the Tokio project's GitHub organization
  (`github.com/tokio-rs/axum`) [1].
- **Axum builds on the Tokio stack instead of inventing its own:** "axum is
  designed to work with tokio and hyper" and "doesn't have its own
  middleware system but instead uses tower::Service" [1]. Learning it
  teaches the libraries most async Rust code uses.
- **Small code:** the whole server is 15 lines of Rust without comments,
  close to [../../go/web](../../go/web/) (23) and
  [../../python/web](../../python/web/) (Flask).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Rust 1.98.1, Axum 0.8.9, Tokio 1.54.1. The executable is 1.6 MB. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Rust with rustup and a C linker, as in [../cli](../cli/README.md#platform-notes). No other system library is needed. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Rust with rustup and the MSVC Build Tools, as in [../cli](../cli/README.md#platform-notes). The executable is `target\release\hello-web.exe`; native commands (PowerShell): `cargo build --release --locked`, then `$env:PORT=8080; .\target\release\hello-web.exe`. |

## Expected output
`./run.sh` prints the following lines and keeps running:
```text
==> Start the web server on http://localhost:8080
    WHY: target/release/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
```

In a browser, the page looks like this:

![A browser page showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 on macOS Intel with headless Chrome:
`--headless=new --screenshot --window-size=640,240`.)

`curl -i http://localhost:8080/` shows the headers Axum sends:
```text
HTTP/1.1 200 OK
content-type: text/html; charset=utf-8
content-length: 20
date: Sat, 31 Oct 2026 21:26:29 GMT

<p>Hello, World!</p>
```

## Sources
1. `axum` 0.8.9 documentation (crate overview, `Html`, `routing::get`, `serve`). docs.rs. <https://docs.rs/axum/0.8.9/axum/> (accessed 2026-10-31)
2. `tokio` 1.54.1 documentation (crate overview, attribute macro `main`). docs.rs. <https://docs.rs/tokio/1.54.1/tokio/> (accessed 2026-10-31)
3. The Cargo Book: Package Layout. The Rust Project. <https://doc.rust-lang.org/cargo/guide/project-layout.html> (accessed 2026-10-31)
4. The Cargo Book: `cargo build` (`--release`, `--locked`). The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-build.html> (accessed 2026-10-31)
5. The Cargo Book: Specifying Dependencies (caret requirements). The Rust Project. <https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html> (accessed 2026-10-31)
6. The Cargo Book: Features (dependency features). The Rust Project. <https://doc.rust-lang.org/cargo/reference/features.html> (accessed 2026-10-31)
7. The Cargo Book: Cargo.toml vs Cargo.lock. The Rust Project. <https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html> (accessed 2026-10-31)
8. Asynchronous Programming in Rust: async and await. The Rust Async Working Group. <https://rust-lang.github.io/async-book/part-guide/async-await.html> (accessed 2026-10-31)
9. crates.io API: `axum` 0.8.9, `tokio` 1.54.1 (publish date, `rust_version`). crates.io. <https://crates.io/api/v1/crates/axum/0.8.9> and <https://crates.io/api/v1/crates/tokio/1.54.1> (accessed 2026-10-31)
10. Stack Overflow Developer Survey 2026: Technology data (web frameworks and technologies). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
