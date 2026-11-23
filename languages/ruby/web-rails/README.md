# Ruby · web-rails: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Ruby](../README.md)

## What this is
A small web server written with Ruby on Rails. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
The server sends the HTML itself; there is no separate front end.

This is the second web version in the Ruby folder. [../web](../web/) does the
same with Sinatra. The pair shows the difference between a **language** and a
**framework**, and between two sizes of framework (see the next section).

### Language and framework
- **Ruby is a language.** It defines the syntax, the objects, and the
  standard library. The official site describes it as a language of "careful
  balance" [1]. Ruby has no notion of a web request on its own.
- **Rails is a framework written in Ruby.** The Rails guide calls it "a web
  framework built for the Ruby programming language" and recommends learning
  the basics of Ruby first, because "Rails takes advantage of many features
  of Ruby" [2]. A framework is a library with a structure: it decides where
  the code goes, calls your code at the right moment, and brings ready-made
  parts for common tasks. The Rails home page: "Rails is a full-stack
  framework. It ships with all the tools needed to build amazing web apps on
  both the front and back end" [3].
- **Rails is opinionated.** One of its stated principles is "Convention over
  Configuration": Rails "has opinions about the best way to do many things in
  a web application, and defaults to this set of conventions, rather than
  require that you define them yourself" [2]. Another is "The menu is
  omakase": the framework picks the parts of the stack for you [4].
- **Sinatra is a framework too, but a small one.** It calls itself "a DSL for
  quickly creating web applications in Ruby with minimal effort" [5]. It
  gives routes and little else; you choose the rest.

| | [web](../web/) (Sinatra) | web-rails (this folder) |
|---|---|---|
| Lines of Ruby (no comments) | 6 (`app.rb`) | 18 (`config.ru`) |
| Entry point | `ruby app.rb`: Sinatra starts its own server when the file ends | `rackup config.ru`: the Rack command starts Puma, which calls the app |
| Route | `get "/" do ... end` | `root to: "hello#index"` in a routes table |
| Handler | a block | an action (a method) of a controller class |
| Structure imposed | none: one file, one block | Rails::Application, a router, a controller, and naming conventions |
| Loaded by the program | `sinatra` | `action_controller/railtie` (routing and controllers only) |
| Gems installed (`bundle list`) | 11 (3 direct) | 44 (4 direct, plus Rails' own libraries) |
| Typical project | one file | many files and folders made by `rails new` [6] |

The Rails version here is not a complete Rails project. A project made with
`rails new` spreads this code over many files and folders (`app/controllers`,
`config/routes.rb`, `config/application.rb`, and more) [6]. `config.ru`
keeps only what an HTML page needs, so you can read the whole program at
once. The file says so in its comments.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (Homebrew `ruby`) | runs Rails and `config.ru` |
| Bundler (`bundle`) | 4.0.20 (installed with Ruby) | installs the pinned gems into `vendor/bundle` and runs Ruby with them |
| Railties | 8.1.4.1 (pinned in `Gemfile`) | the core of Rails: `Rails::Application` and the start-up sequence |
| Action Pack | 8.1.4.1 (pinned in `Gemfile`) | the router (Action Dispatch) and controllers (Action Controller) |
| Puma | 8.1.1 (pinned in `Gemfile`) | the web server |
| Rackup | 2.3.1 (pinned in `Gemfile`) | the `rackup` command, which reads `config.ru` and starts Puma |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

`Gemfile.lock` also pins the other gems that these need (Rack, Active
Support, Action View, and others), with their versions.

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
| `install.sh` | 1. Checks Ruby and Bundler and shows how to install Ruby. 2. Runs `bundle config set --local path vendor/bundle`. 3. Runs `bundle install`, which installs the versions in `Gemfile.lock`. Steps that install something ask first. | Rails is a set of third-party gems, not part of Ruby. `path vendor/bundle` keeps the gems in this folder, not in your system Ruby; `--local` saves the setting in this folder's `.bundle/config` [7]. |
| `run.sh` | Starts `bundle exec rackup --host 127.0.0.1 --port $PORT --server puma config.ru`. `--verify` starts it in the background, fetches the page once with `curl`, then stops it. | `rackup` is the command that runs a Rack application from a `config.ru` file, and a Rails application is one [8]. `bundle exec` runs Ruby with the gems in `Gemfile.lock` [9]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

There is no `build.sh`, because Ruby is interpreted, as in the
[cli](../cli/README.md#why-there-is-no-build-step).

## Folder structure
```text
web-rails/
├── README.md       this file
├── install.sh      checks Ruby and Bundler, installs the gems
├── run.sh          starts the server
├── config.ru       the whole Rails application (a Rack "rackup" file)
├── Gemfile         the gems this app needs, with pinned versions
├── Gemfile.lock    the exact versions Bundler chose (committed)
├── screenshot.png  the page in a browser (see Expected output)
├── .gitignore      keeps vendor/ and .bundle/ out of git
├── .bundle/        created by install.sh: Bundler settings for this folder
└── vendor/bundle/  created by install.sh: the installed gems
```
- `config.ru` is the entry point of a Rack application. The Rails guides
  describe Rack as the interface between Ruby web servers and Ruby web
  frameworks, and say that a Rack application's entry point is "stored in a
  `config.ru` file" [8]. Sinatra and Rails are both Rack frameworks, so the
  same `rackup` command and the same server serve either.
- `Gemfile` lists the gems and where to download them (`source`) [10]. It
  names `railties` and `actionpack` instead of the `rails` gem, which would
  bring Active Record, Active Job, Action Mailer, and the other
  frameworks. This program has no database, mail, or jobs.
- `Gemfile.lock` "writes the exact version of every gem, direct or
  transitive, into the lockfile" [11]. Bundler maintains it.
- The layout of a full Rails project is described in the Getting Started
  guide [6]. This program does not follow it on purpose: one file is easier
  to read first.

## Step-by-step walkthrough
Open [`config.ru`](config.ru) next to this list.

1. **`require "action_controller/railtie"`** loads two parts of Rails:
   the application base class and Action Controller. A railtie is how a
   Rails framework plugs into the start-up sequence. The line that
   `rails new` generates loads every framework; this one loads only what
   the page needs [12].
2. **`class HelloApp < Rails::Application`** defines the application. Each
   Rails app is a subclass of `Rails::Application`, and its settings go in
   the class body. `config.load_defaults 8.1` selects the default values of
   Rails 8.1: "config.load_defaults loads default configuration values for a
   target version and all versions prior" [13]. `config.eager_load = false`
   loads code on demand. `config.secret_key_base` gets a random value for
   each run, because this app sets no cookies.
3. **`HelloApp.initialize!`** runs the start-up sequence: it reads the
   settings, builds the router, and loads the frameworks.
4. **`Rails.application.routes.draw do ... root to: "hello#index" end`**
   fills the routes table. "You can specify what Rails should route '/' to
   with the root method: root to: "pages#main"" [14]. The value
   `"hello#index"` means: the `index` action of `HelloController`. The
   name `hello` becomes `HelloController` by a naming rule, one example of
   convention over configuration [2]. In Sinatra the route and the handler
   are one block; in Rails they are two pieces that a name connects.
5. **`class HelloController < ActionController::Base`** is the controller.
   Its public methods are actions. The Getting Started guide shows the same
   shape: `class ProductsController < ApplicationController` with an
   `index` method [6]. A full app inherits from its own
   `ApplicationController`; this program uses the base class directly.
6. **`render html: "<p>Hello, World!</p>".html_safe`** sends the string as an
   HTML page. Rails escapes HTML in a string by default, so that text from a
   user cannot add a script to the page. `html_safe` marks this string as
   trusted. A real Rails app would render a template (an `.erb` file,
   "Embedded Ruby") instead of a string [6].
7. **`run HelloApp`** tells Rack which object is the application: "A Rack
   app is an object which implements a call method" [8]. `Rails::Application`
   has one, so the server calls it for each request. Sinatra needs no such
   line in `app.rb`, because it starts its own server.

## Why this toolchain
- **Rails** is the best-known web framework of the Ruby community: the
  Stack Overflow Developer Survey 2026 lists Ruby on Rails with 5.7% of the
  583 of 10,281 respondents who answered the web frameworks question [15],
  and Ruby itself is the language of Rails (see the
  [language page](../README.md#market-usage-today) for the market figures).
  The Rails site calls it a framework that "scales from PROMPT to IPO" and
  gives its current version as 8.1.4.1, released 2026-11-04 [3]. That is the
  version in `Gemfile`.
- **Why not `rails new`?** The generator is the usual way to start a Rails
  project, and the Getting Started guide documents it [6]. It creates dozens
  of files, a database setup, and a Docker setup, which hide the one idea
  this repository wants to show. The Rails contributors use the same kind of
  single-file program for bug reports: their guide offers "bug report
  templates" as "a starting point" [16].
- **Railties and Action Pack, not the `rails` gem.** The `rails` gem is the
  bundle of all the Rails frameworks. These two gems are the smallest set
  that gives a router and a controller. Everything else is left out on
  purpose, so the install is smaller and the program is shorter.
- **Puma and Rackup** are the same pair as in [../web](../web/), so the two
  web versions differ only in the framework. The Rails guide shows Puma as
  the server of a Rack app: "gem install puma", then "puma" [8].
- **Port 8080** is the convention of this repository for every web
  implementation. The Getting Started guide serves on 3000 [6].
- **Development settings.** With no environment set, Rails runs in
  development mode and logs each request to the terminal (see the output
  below). A production deployment needs more settings, which are out of
  scope for a Hello World program.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-19) | Ruby 4.0.7, Rails 8.1.4.1 (railties, actionpack), Puma 8.1.1. Puma and nio4r have a C part, which `bundle install` compiled on this machine. Nokogiri came as a precompiled gem for `x86_64-darwin`. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `ruby-full` and `build-essential` with apt when `ruby` is missing [17], and `bundler` when `bundle` is missing. Then it installs the gems into `vendor/bundle`. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. The Ruby of the runner image has no Bundler, so `install.sh` installs the MSYS2 packages for Ruby 4.0 (with Bundler), GCC and `make` with `pacman` (MSYS2 is pre-installed in `C:\msys64`) and puts `C:\msys64\ucrt64\bin` first on PATH. A small `bundle` wrapper in `languages/ruby/msys2-bin` lets Git Bash start Bundler, and gems with a C part are built with MSYS2's `make`. On Windows, the Gemfile adds the `tzinfo-data` gem. WSL not verified; it behaves like Linux. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C). The `INFO` and `DEBUG`
lines appear when a request arrives:
```text
==> Start the web server on http://localhost:8080
    WHY: 'rackup' loads config.ru and serves the Rails app with Puma on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Puma starting in single mode...
* Puma version: 8.1.1 ("Puma Psychosis")
* Ruby version: ruby 4.0.7 (2026-09-15 revision 229531a6cf) +PRISM [x86_64-darwin23]
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 49128
* Listening on http://127.0.0.1:8080
Use Ctrl-C to stop
I, [2026-11-04T20:55:21.786037 #49128]  INFO -- : Started GET "/" for 127.0.0.1 at 2026-11-04 20:55:21 -0300
I, [2026-11-04T20:55:21.841262 #49128]  INFO -- : Processing by HelloController#index as HTML
D, [2026-11-04T20:55:21.856905 #49128] DEBUG -- :   Rendering html template
I, [2026-11-04T20:55:21.857119 #49128]  INFO -- :   Rendered html template (Duration: 0.0ms | GC: 0.0ms)
I, [2026-11-04T20:55:21.857558 #49128]  INFO -- : Completed 200 OK in 16ms (Views: 13.4ms | GC: 0.0ms)
```
In a second terminal (the headers Rails adds are shortened here):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
x-frame-options: SAMEORIGIN
content-type: text/html; charset=utf-8
content-length: 20

<p>Hello, World!</p>
```
A browser also asks for `/favicon.ico`. The app has no route for it, so the
log shows a `RoutingError` for that request and the server answers 404. The
page is not affected.

The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-11-04 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. About Ruby. Ruby community. <https://www.ruby-lang.org/en/about/> (accessed 2026-11-04)
2. Getting Started with Rails. Ruby on Rails Guides. <https://guides.rubyonrails.org/getting_started.html> (accessed 2026-11-04)
3. Ruby on Rails. Rails team. <https://rubyonrails.org/> (accessed 2026-11-04)
4. The Rails Doctrine. David Heinemeier Hansson, rubyonrails.org. <https://rubyonrails.org/doctrine> (accessed 2026-11-04)
5. Sinatra. Sinatra project. <https://sinatrarb.com/> (accessed 2026-11-04)
6. Getting Started with Rails: Creating Your First Rails App, Directory Structure, Model-View-Controller Basics. Ruby on Rails Guides. <https://guides.rubyonrails.org/getting_started.html#creating-your-first-rails-app> (accessed 2026-11-04)
7. bundle config. Bundler documentation, RubyGems Guides. <https://guides.rubygems.org/command-reference/bundle-config/> (accessed 2026-11-04)
8. Rails on Rack. Ruby on Rails Guides. <https://guides.rubyonrails.org/rails_on_rack.html> (accessed 2026-11-04)
9. Using Bundler in applications. RubyGems Guides. <https://guides.rubygems.org/using_bundler_in_applications/> (accessed 2026-11-04)
10. Gemfile. RubyGems Guides. <https://guides.rubygems.org/gemfile/> (accessed 2026-11-04)
11. How Gemfile.lock works. RubyGems Guides. <https://guides.rubygems.org/gemfile-lock/> (accessed 2026-11-04)
12. Configuring Rails Applications. Ruby on Rails Guides. <https://guides.rubyonrails.org/configuring.html> (accessed 2026-11-04)
13. Configuring Rails Applications: Versioned Default Values. Ruby on Rails Guides. <https://guides.rubyonrails.org/configuring.html#versioned-default-values> (accessed 2026-11-04)
14. Rails Routing from the Outside In: Using root. Ruby on Rails Guides. <https://guides.rubyonrails.org/routing.html> (accessed 2026-11-04)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-04)
16. Contributing to Ruby on Rails: Reporting an Issue. Ruby on Rails Guides. <https://guides.rubyonrails.org/contributing_to_ruby_on_rails.html> (accessed 2026-11-04)
17. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (accessed 2026-11-04)
