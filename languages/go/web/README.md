# Go · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Go](../README.md)

## What this is
A web server on <http://localhost:8080/> that answers `GET /` with the
HTML `<p>Hello, World!</p>`. The browser shows **Hello, World!**

Everything comes from Go's **standard library**: `net/http` is the web
server and `html/template` fills the HTML. Unlike the
[Python web](../../python/web/) (Flask) and [Java web](../../java/web/)
(Spring Boot) versions, no web framework is downloaded. The server sends
the finished HTML itself; compare [../web-vue](../web-vue/), where the
browser builds the page.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Go 1.22 or newer | Go 1.27.3 (Homebrew) | compiles the server; `net/http` and `html/template` come with it |
| `curl` | system `curl` | only for `./run.sh --verify` and for testing by hand |

Go 1.22 is required because `main.go` uses a method in its URL pattern
(`"GET /{$}"`), which Go 1.22 added to `net/http` [3].

## Quick start
```sh
./install.sh   # check / install Go (asks before installing)
./build.sh     # compile into bin/hello-web
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser. Another port: `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks for Go 1.22+ (`go env GOVERSION`). If Go is missing, it shows the install command (Homebrew, the official archive on Linux, or winget) and runs it only if you answer `y`. | The `go` command is the only tool needed. The web server is part of the standard library: "Package http provides HTTP client and server implementations" [1]. |
| `build.sh` | Runs `go build -o bin/hello-web .` | As in [../cli](../cli/README.md#scripts-explained): `go build` compiles the package and its dependencies [4] into one native executable. Here the dependencies are `net/http` and `html/template`, so the executable contains the HTTP server. |
| `run.sh` | Runs `./bin/hello-web` (with `exec`, so Ctrl+C stops the server). `--verify`: starts it in the background, fetches `/` once with `curl`, prints the answer, and stops it (a `trap` makes sure that it stops). | The server must be running for a browser to reach it. There is no separate server program to start, like Tomcat or `flask run`: the executable *is* the server. |

## Folder structure
```text
web/
├── README.md        this file
├── install.sh       checks / installs Go
├── build.sh         compiles with go build
├── run.sh           starts the server
├── screenshot.png   the page in a browser, for "Expected output" below
├── go.mod           the module file: name and minimum Go version
├── main.go          the server
└── bin/             created by build.sh; not committed
    └── hello-web
```
- The same "basic command" layout as [../cli](../cli/README.md#folder-structure) [5].
  No `go.sum`, because nothing is downloaded.
- The HTML template is one line, so it lives in `main.go`. Bigger apps keep
  templates in their own `.html` files and load them with
  `template.ParseFiles`, or build them into the executable with the
  `//go:embed` directive [2][6].

## Step-by-step walkthrough
Open [`main.go`](main.go) next to this list.

1. **The template**:
   `var page = template.Must(template.New("page").Parse("<p>{{.}}</p>"))`.
   `{{.}}` ("dot") stands for the data given when the template runs. `Must`
   "panics if the error is non-nil" and "is intended for use in variable
   initializations" like this one [2], so a broken template stops the
   program at start-up, not at the first request.
2. **Why `html/template` and not `text/template`?** It "implements
   data-driven templates for generating HTML output safe against code
   injection", and "the escaping is contextual" [2]. Try it: with the data
   `<script>alert(1)</script>` the output is
   `<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>`, text that the browser
   shows instead of running. The Python and Java versions return a fixed
   string, so they need no escaping.
3. **The handler**: `func hello(w http.ResponseWriter, r *http.Request)`.
   `net/http` calls it for every matching request. You write the answer to
   `w`; `r` describes the request. `*http.Request` is a **pointer** type:
   the handler receives the request's address, not a copy.
4. **`page.Execute(w, "Hello, World!")`** fills the template and writes it
   to `w`. You do not set the status or the content type: when nothing was
   set, `Write` "calls WriteHeader(http.StatusOK)" and "adds a Content-Type
   set to the result of passing the initial 512 bytes of written data to
   DetectContentType" [1]. That is where `text/html; charset=utf-8` in the
   `curl -i` output below comes from.
5. **Errors are values.** `Execute` returns an `error`; `if err := ...; err
   != nil` checks it in one line. Go has no exceptions, which its FAQ
   explains: "coupling exceptions to a control structure, as in the
   try-catch-finally idiom, results in convoluted code" [7]. `http.Error`
   then "replies to the request with the specified error message and HTTP
   code" [1].
6. **The route**: `http.HandleFunc("GET /{$}", hello)`. Since Go 1.22,
   "Go 1.22 brings two enhancements to the net/http package's router: method
   matching and wildcards" [3]. A pattern with `GET` "matches both GET and HEAD
   requests", and "the pattern "/{$}" matches only the path "/", whereas the
   pattern "/" matches every path" [1]. So `/other` gets `404 Not Found` and
   `POST /` gets `405 Method Not Allowed` (see the `curl` output below).
7. **`http.ListenAndServe("127.0.0.1:"+port, nil)`** "listens on the TCP
   network address addr", and with a `nil` handler "DefaultServeMux is
   used" [1]: the router in which `HandleFunc` registered the handler. `127.0.0.1` means only
   this computer can connect. It "always returns a non-nil error" [1] (for
   example, when the port is already in use), and `log.Fatal` prints it and exits.

## Why this toolchain
- **The standard library is enough.** `net/http` is a full HTTP server
  [1], and since Go 1.22 its router matches methods and path wildcards [3].
  `html/template` makes HTML safe against code injection [2]. This
  repository uses `net/http` + `html/template` because, with them, the
  smallest web app in Go needs no dependencies at all.

- **Go 1.22 minimum:** released 2024-02-06 [8]. The `go 1.22` line in
  `go.mod` makes older toolchains refuse the module [9] instead of
  failing on the pattern at run time.
- **Port 8080** matches the other `web` folders in this repository.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Go 1.27.3. |
| macOS Apple Silicon | ⚠️ not verified | Same commands (`brew install go`). |
| Linux (Debian/Ubuntu) | ⚠️ not verified | Go from the official archive, as in [../cli](../cli/README.md#platform-notes). `curl` may need `sudo apt-get install curl`. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Go with `winget install --id GoLang.Go -e`. Native commands (PowerShell): `go build -o bin\hello-web.exe .`, then `.\bin\hello-web.exe`. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: bin/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
2026/10/31 13:46:59 Listening on http://localhost:8080/
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Date: Sat, 31 Oct 2026 16:46:38 GMT
Content-Length: 20
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/other
404
$ curl -s -o /dev/null -w '%{http_code}\n' -X POST http://localhost:8080/
405
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Package net/http (ServeMux patterns, HandleFunc, ListenAndServe, ResponseWriter.Write, Error). The Go Authors. <https://pkg.go.dev/net/http> (accessed 2026-10-31; also read with `go doc` for Go 1.27.3)
2. Package html/template (and template.Must). The Go Authors. <https://pkg.go.dev/html/template> (accessed 2026-10-31)
3. Routing Enhancements for Go 1.22. Jonathan Amsterdam, The Go Blog, 2024-02-13. <https://go.dev/blog/routing-enhancements> (accessed 2026-10-31)
4. Command go (go build). The Go Authors. <https://pkg.go.dev/cmd/go> (accessed 2026-10-31)
5. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (accessed 2026-10-31)
6. Package embed. The Go Authors. <https://pkg.go.dev/embed> (accessed 2026-10-31)
7. Frequently Asked Questions (Why does Go not have exceptions?). The Go Authors. <https://go.dev/doc/faq> (accessed 2026-10-31)
8. Release History. The Go Authors. <https://go.dev/doc/devel/release> (accessed 2026-10-31)
9. Go Modules Reference (go directive). The Go Authors. <https://go.dev/ref/mod#go-mod-file-go> (accessed 2026-10-31)
