# Ruby · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Ruby](../README.md)

## What this is
A small web server written with Sinatra. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
The server sends the HTML itself; there is no separate front end.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (Homebrew `ruby`) | runs Sinatra and `app.rb` |
| Bundler (`bundle`) | 4.0.20 (installed with Ruby) | installs the pinned gems into `vendor/bundle` and runs Ruby with them |
| Sinatra | 4.2.1 (pinned in `Gemfile`) | the web framework |
| Puma | 8.1.1 (pinned in `Gemfile`) | the web server that Sinatra starts |
| Rackup | 2.3.1 (pinned in `Gemfile`) | the library that connects Sinatra to the server |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

`Gemfile.lock` also pins the other gems that these three need (Rack, Tilt,
and others), with their checksums.

## Quick start
```sh
./install.sh   # check Ruby and Bundler, install the gems into vendor/bundle (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks Ruby and Bundler and shows how to install Ruby. 2. Runs `bundle config set --local path vendor/bundle`. 3. Runs `bundle install`, which installs the versions in `Gemfile.lock`. Steps that install something ask first. | Sinatra is a third-party gem. The Sinatra README calls Bundler "the recommended way" to run an application with a particular Sinatra version [1]. `path vendor/bundle` keeps the gems in this folder, not in your system Ruby; `--local` saves the setting in this folder's `.bundle/config` [2]. |
| `run.sh` | Starts `bundle exec ruby app.rb` on `PORT`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | The Sinatra README: "Sinatra applications can be run directly" with `ruby myapp.rb` [1]. `bundle exec` runs Ruby with the gems in `Gemfile.lock` [3]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`, because Ruby is interpreted, as in the
[cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web/
├── README.md       this file
├── install.sh      checks Ruby and Bundler, installs the gems
├── run.sh          starts the server
├── app.rb          the web application (Sinatra's classic style)
├── Gemfile         the gems this app needs, with pinned versions
├── Gemfile.lock    the exact versions Bundler chose, with checksums (committed)
├── .gitignore      keeps vendor/ and .bundle/ out of git
├── .bundle/        created by install.sh: Bundler settings for this folder
└── vendor/bundle/  created by install.sh: the installed gems
```
- `app.rb` uses the classic style: routes are written at the top level of
  the file. Sinatra also has a modular style, in which an app is a class
  [1]. A single page needs only the classic style.
- `Gemfile` lists the gems and where to download them (`source`) [4].
- `Gemfile.lock` "writes the exact version of every gem, direct or
  transitive, into the lockfile" [5]. Bundler maintains it; nobody edits it
  by hand.
- `.bundle/` and `vendor/` are not committed: they hold settings for your
  computer and downloaded code.

## Step-by-step walkthrough
Open [`app.rb`](app.rb) next to this list.

1. **`require "sinatra"`** loads the library. Unlike the
   [cli](../cli/hello.rb), which uses only the built-in `puts`, this
   program depends on a gem from RubyGems.
2. **`set :port, ...` and `set :bind, ...`** change two settings. The
   Sinatra README describes `port` as the "Port to listen on" and `bind` as
   the "IP address to bind to" [1]. `app.rb` reads the port from the `PORT`
   environment variable, with 8080 as the default, and binds to `127.0.0.1`,
   which only this computer can reach.
3. **`get "/" do ... end`** defines a route: "In Sinatra, a route is an HTTP
   method paired with a URL-matching pattern. Each route is associated with
   a block" [1]. Other frameworks in this repository register routes in
   their own way: Flask uses `@app.route("/")`, Express uses
   `app.get("/", ...)`, and Spring Boot uses `@GetMapping("/")`. A block is
   a piece of code between `do` and `end` that Ruby hands to a method; here
   Sinatra keeps it and runs it for each matching request.
4. **`"<p>Hello, World!</p>"`**: "The return value of a route block
   determines at least the response body ... Most commonly, this is a
   string" [1]. In Ruby a block returns its last expression, so no `return`
   is needed. You can see the HTML content type in the `curl -i` output
   below.
5. **No server code.** The file never starts a server by itself. When it
   ends, Sinatra starts one, because the application "can be run directly"
   [1]. That server (Puma) waits for requests. This is the biggest
   difference from the cli version, which runs once and exits.

## Why this toolchain
- **Sinatra** describes itself as "a DSL for quickly creating web
  applications in Ruby with minimal effort" [6]. A Hello World page takes
  six lines of code, which suits the aim of this repository to keep each
  program as simple and direct as possible. A comparison with the
  full-stack [Rails](../web-rails/README.md) version is on the
  [language page](../README.md#comparing-the-categories).
- **Puma** is the server that the Sinatra README installs in its own
  quick-start command, `gem install sinatra rackup puma`, and lists as the
  default of the `-s` (server) option: "specify rack server/handler
  (default is puma)" [1]. Sinatra's site adds: "It is recommended to also
  run gem install puma, which Sinatra will pick up if available" [6].
  WEBrick, the other common choice, was not needed.
- **Rackup** is installed in the same README command [1]; it supplies the
  handlers through which Sinatra starts a Rack server such as Puma.
- **Port 8080** is the convention of this repository for every web
  implementation. Sinatra's own default is 4567 [1].
- **Development settings.** With no environment set, Sinatra runs in
  development mode [1] and prints a log line per request. A production
  deployment needs more settings, which are out of scope for a Hello World
  program.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Ruby 4.0.7, Sinatra 4.2.1, Puma 8.1.1. Puma and its dependency nio4r have a C part: `bundle install` compiled both on this machine in a few seconds. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `ruby-full` and `build-essential` with apt when `ruby` is missing [7], and `bundler` when `bundle` is missing. Then it installs the gems into `vendor/bundle`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. The Ruby of the runner image has no Bundler, so `install.sh` installs the MSYS2 packages for Ruby 4.0 (with Bundler), GCC and `make` with `pacman` (MSYS2 is pre-installed in `C:\msys64`) and puts `C:\msys64\ucrt64\bin` first on PATH. A small `bundle` wrapper in `languages/ruby/msys2-bin` lets Git Bash start Bundler, and gems with a C part (Puma) are built with MSYS2's `make`. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'ruby app.rb' loads Sinatra, which serves the app with Puma on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
== Sinatra (v4.2.1) has taken the stage on 8080 for development with backup from Puma
Puma starting in single mode...
* Puma version: 8.1.1 ("Puma Psychosis")
* Ruby version: ruby 4.0.7 (2026-09-15 revision 229531a6cf) +PRISM [x86_64-darwin23]
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 8413
* Listening on http://127.0.0.1:8080
Use Ctrl-C to stop
```
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
content-type: text/html;charset=utf-8
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
content-length: 20

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. Sinatra README. Sinatra project. <https://github.com/sinatra/sinatra#readme> (accessed 2026-11-04)
2. bundle config. Bundler documentation, RubyGems Guides. <https://guides.rubygems.org/command-reference/bundle-config/> (accessed 2026-11-04)
3. Using Bundler in applications. RubyGems Guides. <https://guides.rubygems.org/using_bundler_in_applications/> (accessed 2026-11-04)
4. Gemfile. RubyGems Guides. <https://guides.rubygems.org/gemfile/> (accessed 2026-11-04)
5. How Gemfile.lock works. RubyGems Guides. <https://guides.rubygems.org/gemfile-lock/> (accessed 2026-11-04)
6. Sinatra. Sinatra project. <https://sinatrarb.com/> and <https://sinatrarb.com/intro.html> (accessed 2026-11-04)
7. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (accessed 2026-11-04)
