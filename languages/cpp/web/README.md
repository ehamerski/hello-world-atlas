# C++ · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C++](../README.md)

## What this is
A web server on **http://localhost:8080** (change it with `PORT`) that
answers `GET /` with the HTML `<p>Hello, World!</p>`. Any other path gets
`404 Not Found`. The server sends the HTML itself; there is no separate
front end. It uses **cpp-httplib** 0.64.0, "A C++11 single-file
header-only cross platform HTTP/HTTPS library" [1], and is compiled as
ISO C++20 with CMake.

It is the C++ twin of the [C `web` version](../../c/web/), which uses GNU
libmicrohttpd. Same port, same answer, same `127.0.0.1` address: only the
language and the library change.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| A C++ compiler (`c++`) | Apple clang 21.0.0 (Command Line Tools) | compiles `hello.cpp` and the server code in `httplib.h` |
| CMake | 4.4.5 (Homebrew) | finds `httplib.h` and the thread library, generates the build files |
| cpp-httplib | 0.64.0 (Homebrew) | the HTTP server: one header file, `httplib.h` |
| curl | system curl | used by `run.sh --verify` to call the server |

## Quick start
```sh
./install.sh          # check for c++, CMake and httplib.h (asks before installing)
./build.sh            # configure and build into build/hello-web
./run.sh              # serve on http://localhost:8080 until Ctrl+C
curl http://localhost:8080/    # in another terminal
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `c++`, `cmake`, and `httplib.h`. If something is missing, it offers `brew install cpp-httplib` (macOS) or `sudo apt-get install -y libcpp-httplib-dev` (Debian/Ubuntu), and runs it only if you answer `y`. On Windows it explains how to copy `httplib.h`. | The C++ standard library has no HTTP server and no sockets, so the server comes from a library. |
| `build.sh` | Runs `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release`, then `cmake --build build`. | Configure finds `httplib.h`; build compiles everything into one executable. |
| `run.sh` | Exports `PORT` (default 8080) and runs `./build/hello-web`. `--verify` starts it in the background, calls it once with `curl`, prints the answer, and stops it. | A server runs until stopped; the self-check lets `scripts/verify-all.sh` run it unattended. |

**Header-only.** All of cpp-httplib is in `httplib.h` (24,321 lines in
version 0.64.0). The compiler builds the server code every time it compiles
`hello.cpp`, so there is no HTTP library to link or to load at run time.
`CMakeLists.txt` only has to find the folder of the header (`find_path`)
and link the thread library (`Threads::Threads`): the server answers
connections from a pool of worker threads (class `ThreadPool` in
`httplib.h`). Homebrew also installs a CMake package, `httplib::httplib`,
but its build has HTTPS and compression switched on, which would add
OpenSSL and zlib to the build; a plain HTTP Hello World program needs neither.

## Folder structure
```text
web/
├── README.md        this file
├── install.sh       checks / installs c++, CMake and cpp-httplib
├── build.sh         configures and builds with CMake
├── run.sh           starts the server (--verify: self-check)
├── CMakeLists.txt   the CMake project: C++20, httplib.h, threads
├── hello.cpp        the server
├── screenshot.png   the page in a browser (see Expected output)
└── build/           created by build.sh; not committed
    └── hello-web
```

## Step-by-step walkthrough
Open [`hello.cpp`](hello.cpp) next to
[`../../c/web/hello.c`](../../c/web/hello.c).

1. **The port.** `std::getenv("PORT")` is C's `getenv`; the C++ part is
   `std::stoi`, which turns the text into an `int` and **throws an
   exception** for text that is not a number. The `try { ... } catch`
   block handles that. C's `atoi` has no way to report an error and
   returns 0. `if (const char *text = std::getenv("PORT"))` declares a
   variable inside the `if`, which C89 does not allow.
2. **`httplib::Server server;`** The server is an object on the stack.
   C++ destroys it automatically when `main` ends. The C version creates a
   daemon with `MHD_start_daemon` and must stop it with `MHD_stop_daemon`.
3. **The handler is a lambda.**
   ```cpp
   server.Get("/", [](const httplib::Request &, httplib::Response &res) {
       res.set_content("<p>Hello, World!</p>", "text/html; charset=utf-8");
   });
   ```
   `[]` starts a lambda: an unnamed function written in place, which C++
   compiles into "an unnamed function object" [2]. Its parameters are
   *references* (`&`): the handler works on the library's own request and
   response objects, without copies and without pointer syntax. The C
   version writes a separate function with eight parameters
   (`answer(void *cls, struct MHD_Connection *connection, const char
   *url, ...)`) and compares the path itself with `strcmp(url, "/")`.
   Here the route is the first argument of `Get`, and paths with no
   handler get 404 from the library.
4. **`res.set_content(body, content_type)`** sets the body and the
   `Content-Type` header. In C this takes three calls:
   `MHD_create_response_from_buffer_static`, `MHD_add_response_header`,
   `MHD_queue_response`, then `MHD_destroy_response` to free it.
5. **`server.listen("127.0.0.1", port)`** binds to this computer only and
   serves until the program is stopped; it returns `false` if the port
   cannot be used. cpp-httplib "uses 'blocking' socket I/O" and "Only
   HTTP/1.1 is supported" [1]. That is enough for a Hello World program. The
   C version fills a `struct sockaddr_in` by hand (`memset`, `htons`,
   `htonl`) to get the same address.
6. **Size and libraries.** `build/hello-web` is 695,672 bytes on the test
   machine (macOS Intel): the server code from the header is compiled into it.
   `otool -L` lists only `libc++` and `libSystem`. The C version is 9,472
   bytes but needs `libmicrohttpd` installed wherever it runs. This is the
   classic trade-off between header-only and shared libraries.

## Why this toolchain
**Crow** [3] and **cpp-httplib** [1] are both C++ libraries for HTTP
servers. This folder uses cpp-httplib for the following reasons:

- **One file, no dependencies.** cpp-httplib is "single-file
  header-only" [1]. Crow's macOS setup asks for a second library, Asio: run
  `brew install asio`, then add header search paths for both Crow and
  Asio [3]. For the smallest
  possible example, one header is simpler to explain and to install.
- **Same bottle on every Mac.** Homebrew ships cpp-httplib as a single
  platform-independent bottle (`all`) [4], so it installs in seconds on an
  Intel Mac. (Qt in [../desktop](../desktop/) had no Intel bottle and was
  compiled from source.)
- **Packaged on Linux:** Debian has `libcpp-httplib-dev` [5].
- **License:** MIT [1].
- **Limits:** blocking I/O and HTTP/1.1 only [1]. Crow is a framework "for
  creating HTTP or Websocket web services" [3]. A WebSocket or
  high-concurrency service would favor Crow; a Hello World program needs
  neither.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | Apple clang 21.0.0, CMake 4.4.5, cpp-httplib 0.64.0 (Homebrew). `./run.sh --verify` printed `<p>Hello, World!</p>`; `curl -i` showed `HTTP/1.1 200 OK` and `Content-Type: text/html; charset=utf-8`, and `/nope` gave `404 Not Found`. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; the Homebrew bottle is the same file [4]. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `build-essential`, `cmake` and `libcpp-httplib-dev` with apt when missing [5]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs the UCRT64 packages `gcc`, `cmake` and `ninja` with `pacman` when missing. MSYS2 has no cpp-httplib package, so it downloads `httplib.h` 0.64.0 from the cpp-httplib repository [1], checks its SHA-256, and puts it in `C:\msys64\ucrt64\include`. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: build/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
Listening on http://localhost:8080
<p>Hello, World!</p>
```
`Listening on ...` is printed by the server; `<p>Hello, World!</p>` is
the `curl` answer.

With `./run.sh` running, open <http://localhost:8080/> in a browser:

![The page in a browser](screenshot.png)

(Taken on 2026-11-01 on macOS Intel with headless Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. cpp-httplib (README: description, blocking I/O, HTTP/1.1, examples, license, releases). Yuji Hirose. <https://github.com/yhirose/cpp-httplib> (accessed 2026-11-01)
2. Lambda expressions. cppreference.com. <https://en.cppreference.com/w/cpp/language/lambda> (accessed 2026-11-01)
3. Crow: home page and macOS setup. CrowCpp. <https://crowcpp.org/master/>, <https://crowcpp.org/master/getting_started/setup/macos/> (accessed 2026-11-01)
4. cpp-httplib (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/cpp-httplib> (accessed 2026-11-01)
5. Package libcpp-httplib-dev (stable). Debian. <https://packages.debian.org/stable/libcpp-httplib-dev> (accessed 2026-11-01)
