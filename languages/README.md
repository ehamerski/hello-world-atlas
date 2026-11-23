# Languages

> Part of [Hello World in many languages](../README.md)

One folder per language. Each one holds:

```text
languages/<language>/README.md      the language: history, milestones, usage, sources
languages/<language>/meta.yml       facts about the language, read by scripts/gen-readme.py
languages/<language>/<category>/    one implementation: README, install.sh, build.sh, run.sh, source
```

The rules for each folder are in [CONTRIBUTING.md](../CONTRIBUTING.md).
The tables in this file and in the [root README](../README.md#languages)
are **generated** from the `meta.yml` files. Do not edit them by hand. After
you change a `meta.yml`, run:

```sh
python3 scripts/gen-readme.py           # rewrite the generated tables
python3 scripts/gen-readme.py --check   # exit 1 if they are out of date (CI)
```

## All implementations
Every folder, with its toolchain, whether it has a `build.sh`, what
`run.sh` does, and a link to its guided walkthrough.
A desktop "window" shows `Hello, World!`; a web URL serves it. Web ports
can be changed with `PORT=...`. New to programming? See
[docs/comparisons.md](../docs/comparisons.md#a-guided-path-through-the-walkthroughs)
for a suggested order of the walkthroughs.

<!-- The generated table lists folder paths and command names as link text, which Vale cannot tell from prose. -->
<!-- vale off -->
<!-- BEGIN GENERATED: implementations-table -->
<!-- Do not edit by hand: run python3 scripts/gen-readme.py (source: languages/*/meta.yml). -->
| # | Folder | Language | Category | Toolchain / framework | `build.sh` | `run.sh` result | Walkthrough |
|---|---|---|---|---|---|---|---|
| 1 | ✅ [ada/cli](ada/cli/) | Ada | cli | GNAT via Alire | yes | prints `Hello, World!` | [read](ada/cli/README.md#step-by-step-walkthrough) |
| 2 | ✅ [algol68/cli](algol68/cli/) | ALGOL 68 | cli | Algol 68 Genie 3.13.4 interpreter, built from source | no | prints `Hello, World!` | [read](algol68/cli/README.md#step-by-step-walkthrough) |
| 3 | ✅ [assembly/cli](assembly/cli/) | Assembly (x86-64) | cli | NASM + `cc` (macOS x86-64) | yes | prints `Hello, World!` | [read](assembly/cli/README.md#step-by-step-walkthrough) |
| 4 | ✅ [bash/cli](bash/cli/) | Bash | cli | GNU Bash 5.3.20 (Homebrew formula `bash`), interpreted: no build step | no | prints `Hello, World!` | [read](bash/cli/README.md#step-by-step-walkthrough) |
| 5 | ✅ [basic/cli](basic/cli/) | BASIC | cli | QB64 Phoenix Edition | yes | prints `Hello, World!` | [read](basic/cli/README.md#step-by-step-walkthrough) |
| 6 | ✅ [c/cli](c/cli/) | C (ANSI C) | cli | system C compiler, `-std=c89` | yes | prints `Hello, World!` | [read](c/cli/README.md#step-by-step-walkthrough) |
| 7 | ✅ [c/desktop](c/desktop/) | C (ANSI C) | desktop | GTK 4, `-std=c99` | yes | window | [read](c/desktop/README.md#step-by-step-walkthrough) |
| 8 | ✅ [c/web](c/web/) | C (ANSI C) | web | GNU libmicrohttpd, `-std=c99` | yes | http://localhost:8080/ | [read](c/web/README.md#step-by-step-walkthrough) |
| 9 | ✅ [csharp/cli](csharp/cli/) | C# | cli | .NET 10 SDK | yes | prints `Hello, World!` | [read](csharp/cli/README.md#step-by-step-walkthrough) |
| 10 | ✅ [csharp/desktop](csharp/desktop/) | C# | desktop | Avalonia | yes | window | [read](csharp/desktop/README.md#step-by-step-walkthrough) |
| 11 | ✅ [csharp/web](csharp/web/) | C# | web | ASP.NET Core | yes | http://localhost:8080/ | [read](csharp/web/README.md#step-by-step-walkthrough) |
| 12 | ✅ [csharp/web-angular](csharp/web-angular/) | C# | web + Angular | ASP.NET Core API + Angular | yes | http://localhost:4200/ (API :8080) | [read](csharp/web-angular/README.md#step-by-step-walkthrough) |
| 13 | ✅ [cpp/cli](cpp/cli/) | C++ | cli | CMake, C++20 | yes | prints `Hello, World!` | [read](cpp/cli/README.md#step-by-step-walkthrough) |
| 14 | ✅ [cpp/desktop](cpp/desktop/) | C++ | desktop | Qt 6 Widgets, CMake | yes | window | [read](cpp/desktop/README.md#step-by-step-walkthrough) |
| 15 | ✅ [cpp/web](cpp/web/) | C++ | web | cpp-httplib, CMake | yes | http://localhost:8080/ | [read](cpp/web/README.md#step-by-step-walkthrough) |
| 16 | ✅ [clipper/cli](clipper/cli/) | Clipper | cli | Harbour | yes | prints `Hello, World!` | [read](clipper/cli/README.md#step-by-step-walkthrough) |
| 17 | ✅ [clojure/cli](clojure/cli/) | Clojure | cli | Clojure CLI 1.12.6.1673 | no | prints `Hello, World!` | [read](clojure/cli/README.md#step-by-step-walkthrough) |
| 18 | ✅ [clojure/desktop](clojure/desktop/) | Clojure | desktop (Swing) | Swing via Java interop, Clojure CLI | no | window | [read](clojure/desktop/README.md#step-by-step-walkthrough) |
| 19 | ✅ [clojure/web](clojure/web/) | Clojure | web (Ring) | Ring + Jetty, Clojure CLI | no | http://localhost:8080/ | [read](clojure/web/README.md#step-by-step-walkthrough) |
| 20 | ✅ [cobol/cli](cobol/cli/) | COBOL | cli | GnuCOBOL | yes | prints `Hello, World!` | [read](cobol/cli/README.md#step-by-step-walkthrough) |
| 21 | ✅ [lisp/cli](lisp/cli/) | Common Lisp | cli | SBCL | yes | prints `Hello, World!` | [read](lisp/cli/README.md#step-by-step-walkthrough) |
| 22 | ✅ [lisp/web](lisp/web/) | Common Lisp | web | Hunchentoot (Quicklisp), SBCL | yes | http://localhost:8080/ | [read](lisp/web/README.md#step-by-step-walkthrough) |
| 23 | ✅ [dart/cli](dart/cli/) | Dart | cli | Dart SDK | no | prints `Hello, World!` | [read](dart/cli/README.md#step-by-step-walkthrough) |
| 24 | ✅ [dart/web](dart/web/) | Dart | web | `dart:io` HttpServer | no | http://localhost:8080/ | [read](dart/web/README.md#step-by-step-walkthrough) |
| 25 | ✅ [dart/mobile-flutter](dart/mobile-flutter/) | Dart | mobile | Flutter 3.47.9 (Android) | yes | prints `Hello, World!` on the Android emulator | [read](dart/mobile-flutter/README.md#step-by-step-walkthrough) |
| 26 | 🔶 [dbase/cli](dbase/cli/) | dBASE | cli | Harbour 3.2.0 (dBASE III-compatible `.prg`) | yes | prints `Hello, World!` | [read](dbase/cli/README.md#step-by-step-walkthrough) |
| 27 | 🔶 [delphi/cli](delphi/cli/) | Delphi (Object Pascal dialect) | cli | Free Pascal 3.2.2 in Delphi mode (`{$mode delphi}`) | yes | prints `Hello, World!` | [read](delphi/cli/README.md#step-by-step-walkthrough) |
| 28 | 🔶 [delphi/desktop](delphi/desktop/) | Delphi (Object Pascal dialect) | desktop | Lazarus 4.8 (LCL, Cocoa) with Free Pascal 3.2.2 | yes | window | [read](delphi/desktop/README.md#step-by-step-walkthrough) |
| 29 | ✅ [eiffel/cli](eiffel/cli/) | Eiffel | cli | Gobo Eiffel 26.03 (gec, Homebrew bottle) | yes | prints `Hello, World!` | [read](eiffel/cli/README.md#step-by-step-walkthrough) |
| 30 | ✅ [elixir/cli](elixir/cli/) | Elixir | cli | Elixir (`elixir hello.exs`) | no | prints `Hello, World!` | [read](elixir/cli/README.md#step-by-step-walkthrough) |
| 31 | ✅ [elixir/web](elixir/web/) | Elixir | web | Mix project, Plug and Bandit from Hex | yes | http://localhost:8080/ | [read](elixir/web/README.md#step-by-step-walkthrough) |
| 32 | ✅ [erlang/cli](erlang/cli/) | Erlang | cli | Erlang/OTP (`escript hello.erl`) | no | prints `Hello, World!` | [read](erlang/cli/README.md#step-by-step-walkthrough) |
| 33 | ✅ [erlang/desktop](erlang/desktop/) | Erlang | desktop | Erlang/OTP, `wx` (`wxWidgets`) | yes | window | [read](erlang/desktop/README.md#step-by-step-walkthrough) |
| 34 | ✅ [erlang/web](erlang/web/) | Erlang | web | Erlang/OTP, `httpd` from `inets` | yes | http://localhost:8080/ | [read](erlang/web/README.md#step-by-step-walkthrough) |
| 35 | ✅ [fsharp/cli](fsharp/cli/) | F# | cli | .NET 10 SDK (`dotnet`), F# 10 | yes | prints `Hello, World!` | [read](fsharp/cli/README.md#step-by-step-walkthrough) |
| 36 | ✅ [fortran/cli](fortran/cli/) | Fortran | cli | GFortran (`gfortran`) | yes | prints `Hello, World!` | [read](fortran/cli/README.md#step-by-step-walkthrough) |
| 37 | ✅ [go/cli](go/cli/) | Go | cli | Go toolchain | yes | prints `Hello, World!` | [read](go/cli/README.md#step-by-step-walkthrough) |
| 38 | ✅ [go/desktop](go/desktop/) | Go | desktop | Fyne | yes | window | [read](go/desktop/README.md#step-by-step-walkthrough) |
| 39 | ✅ [go/web](go/web/) | Go | web | `net/http` + `html/template` (standard library) | yes | http://localhost:8080/ | [read](go/web/README.md#step-by-step-walkthrough) |
| 40 | ✅ [go/web-vue](go/web-vue/) | Go | web + Vue | Go API + Vue (Vite) | yes | http://localhost:4173/ (API :8080) | [read](go/web-vue/README.md#step-by-step-walkthrough) |
| 41 | ✅ [haskell/cli](haskell/cli/) | Haskell | cli | GHC (via GHCup) | yes | prints `Hello, World!` | [read](haskell/cli/README.md#step-by-step-walkthrough) |
| 42 | ✅ [haskell/web](haskell/web/) | Haskell | web | Scotty, Cabal | yes | http://localhost:8080/ | [read](haskell/web/README.md#step-by-step-walkthrough) |
| 43 | ✅ [java/cli](java/cli/) | Java | cli | JDK 21, Maven | yes | prints `Hello, World!` | [read](java/cli/README.md#step-by-step-walkthrough) |
| 44 | ✅ [java/desktop](java/desktop/) | Java | desktop (JavaFX) | JavaFX, Maven | yes | window | [read](java/desktop/README.md#step-by-step-walkthrough) |
| 45 | ✅ [java/desktop-swing](java/desktop-swing/) | Java | desktop (Swing) | Swing (JDK), Maven | yes | window | [read](java/desktop-swing/README.md#step-by-step-walkthrough) |
| 46 | ✅ [java/web](java/web/) | Java | web | Spring Boot, Maven | yes | http://localhost:8080/ | [read](java/web/README.md#step-by-step-walkthrough) |
| 47 | ✅ [java/web-react](java/web-react/) | Java | web + React | Spring Boot API + React (Vite) | yes | http://localhost:4173/ (API :8080) | [read](java/web-react/README.md#step-by-step-walkthrough) |
| 48 | ✅ [julia/cli](julia/cli/) | Julia | cli | Julia 1.13.4 (official tarball, `julia --startup-file=no`) | no | prints `Hello, World!` | [read](julia/cli/README.md#step-by-step-walkthrough) |
| 49 | ✅ [kotlin/cli](kotlin/cli/) | Kotlin | cli | JDK 21, `kotlinc` 2.4.21 | yes | prints `Hello, World!` | [read](kotlin/cli/README.md#step-by-step-walkthrough) |
| 50 | ✅ [kotlin/desktop](kotlin/desktop/) | Kotlin | desktop (Compose) | Compose Multiplatform, Gradle | yes | window | [read](kotlin/desktop/README.md#step-by-step-walkthrough) |
| 51 | ✅ [kotlin/web](kotlin/web/) | Kotlin | web (Ktor) | Ktor (Netty), Gradle | yes | http://localhost:8080/ | [read](kotlin/web/README.md#step-by-step-walkthrough) |
| 52 | ✅ [kotlin/mobile-android](kotlin/mobile-android/) | Kotlin | mobile (Android) | Jetpack Compose, Android Gradle plugin, Android emulator (x86_64) | yes | the app on the Android emulator | [read](kotlin/mobile-android/README.md#step-by-step-walkthrough) |
| 53 | ✅ [lua/cli](lua/cli/) | Lua | cli | Lua 5.5 | no | prints `Hello, World!` | [read](lua/cli/README.md#step-by-step-walkthrough) |
| 54 | 🔶 [lua/desktop](lua/desktop/) | Lua | desktop | LÖVE 11.5 (LuaJIT, Lua 5.1 dialect) | no | window | [read](lua/desktop/README.md#step-by-step-walkthrough) |
| 55 | ✅ [lua/web](lua/web/) | Lua | web | Pegasus, LuaRocks | no | http://localhost:8080/ | [read](lua/web/README.md#step-by-step-walkthrough) |
| 56 | ✅ [node/cli](node/cli/) | Node.js (JavaScript) | cli | Node.js | no | prints `Hello, World!` | [read](node/cli/README.md#step-by-step-walkthrough) |
| 57 | ✅ [node/desktop](node/desktop/) | Node.js (JavaScript) | desktop | Electron | no | window | [read](node/desktop/README.md#step-by-step-walkthrough) |
| 58 | ✅ [node/web](node/web/) | Node.js (JavaScript) | web | Express | no | http://localhost:8080/ | [read](node/web/README.md#step-by-step-walkthrough) |
| 59 | ✅ [objectivec/cli](objectivec/cli/) | Objective-C | cli | clang + Foundation | yes | prints `Hello, World!` | [read](objectivec/cli/README.md#step-by-step-walkthrough) |
| 60 | ✅ [objectivec/desktop](objectivec/desktop/) | Objective-C | desktop | clang + AppKit | yes | window | [read](objectivec/desktop/README.md#step-by-step-walkthrough) |
| 61 | ✅ [objectivec/web](objectivec/web/) | Objective-C | web | clang + Foundation + BSD sockets | yes | http://localhost:8080/ | [read](objectivec/web/README.md#step-by-step-walkthrough) |
| 62 | ✅ [ocaml/cli](ocaml/cli/) | OCaml | cli | OCaml 5.5.2 (`ocamlopt`, Homebrew formula built from source) | yes | prints `Hello, World!` | [read](ocaml/cli/README.md#step-by-step-walkthrough) |
| 63 | ✅ [pascal/cli](pascal/cli/) | Pascal | cli | Free Pascal (ISO 7185 mode) | yes | prints `Hello, World!` | [read](pascal/cli/README.md#step-by-step-walkthrough) |
| 64 | ✅ [pascal/desktop](pascal/desktop/) | Pascal | desktop | Lazarus LCL (`lazbuild`) | yes | window | [read](pascal/desktop/README.md#step-by-step-walkthrough) |
| 65 | ✅ [perl/cli](perl/cli/) | Perl | cli | perl 5 | no | prints `Hello, World!` | [read](perl/cli/README.md#step-by-step-walkthrough) |
| 66 | 🔶 [perl/desktop](perl/desktop/) | Perl | desktop | Tkx (Tcl/Tk) | no | window | [read](perl/desktop/README.md#step-by-step-walkthrough) |
| 67 | ✅ [perl/web](perl/web/) | Perl | web | Mojolicious::Lite | no | http://localhost:8080/ | [read](perl/web/README.md#step-by-step-walkthrough) |
| 68 | ✅ [php/cli](php/cli/) | PHP | cli | `php` CLI | no | prints `Hello, World!` | [read](php/cli/README.md#step-by-step-walkthrough) |
| 69 | ✅ [php/web](php/web/) | PHP | web | PHP built-in server (`php -S`) | no | http://localhost:8080/ | [read](php/web/README.md#step-by-step-walkthrough) |
| 70 | ✅ [prolog/cli](prolog/cli/) | Prolog | cli | SWI-Prolog | no | prints `Hello, World!` | [read](prolog/cli/README.md#step-by-step-walkthrough) |
| 71 | ✅ [prolog/web](prolog/web/) | Prolog | web | SWI-Prolog HTTP libraries | no | http://localhost:8080/ | [read](prolog/web/README.md#step-by-step-walkthrough) |
| 72 | ✅ [pseudocode/portugol](pseudocode/portugol/) | Pseudocode (Portugol) | cli | Delégua interpreter (VisuAlg dialect), via npm | no | prints `Hello, World!` | [read](pseudocode/portugol/README.md#step-by-step-walkthrough) |
| 73 | ✅ [pseudocode/pseint](pseudocode/pseint/) | Pseudocode (PSeInt) | cli | PSeInt | no | prints `Hello, World!` | [read](pseudocode/pseint/README.md#step-by-step-walkthrough) |
| 74 | 📄 [pseudocode/clrs](pseudocode/clrs/) | Pseudocode (CLRS) | cli | none: documented only | – | – (no interpreter) | [read](pseudocode/clrs/README.md#step-by-step-walkthrough) |
| 75 | ✅ [python/cli](python/cli/) | Python | cli | CPython | no | prints `Hello, World!` | [read](python/cli/README.md#step-by-step-walkthrough) |
| 76 | ✅ [python/desktop](python/desktop/) | Python | desktop | tkinter (standard library) | no | window | [read](python/desktop/README.md#step-by-step-walkthrough) |
| 77 | ✅ [python/web](python/web/) | Python | web | Flask | no | http://localhost:8080/ | [read](python/web/README.md#step-by-step-walkthrough) |
| 78 | ✅ [qcl/cli](qcl/cli/) | QCL (Quantum Computation Language) | cli | QCL 0.6.7 interpreter and simulator, built from source (GNU readline) | yes | prints `: Hello, World! ` (QCL adds the prefix and the trailing space) | [read](qcl/cli/README.md#step-by-step-walkthrough) |
| 79 | ✅ [r/cli](r/cli/) | R | cli | R 4.6.2 (`Rscript`, Homebrew formula built from source) | no | prints `Hello, World!` | [read](r/cli/README.md#step-by-step-walkthrough) |
| 80 | ✅ [racket/cli](racket/cli/) | Racket | cli | Racket 9.3 CS (Minimal Racket, `racket hello.rkt`) | no | prints `Hello, World!` | [read](racket/cli/README.md#step-by-step-walkthrough) |
| 81 | ✅ [ruby/cli](ruby/cli/) | Ruby | cli | Ruby (`ruby`) | no | prints `Hello, World!` | [read](ruby/cli/README.md#step-by-step-walkthrough) |
| 82 | ✅ [ruby/desktop](ruby/desktop/) | Ruby | desktop | Ruby/Tk (`tk` gem), Tcl/Tk | no | window | [read](ruby/desktop/README.md#step-by-step-walkthrough) |
| 83 | ✅ [ruby/web](ruby/web/) | Ruby | web | Sinatra, Puma | no | http://localhost:8080/ | [read](ruby/web/README.md#step-by-step-walkthrough) |
| 84 | ✅ [ruby/web-rails](ruby/web-rails/) | Ruby | web (Rails) | Ruby on Rails, Puma | no | http://localhost:8080/ | [read](ruby/web-rails/README.md#step-by-step-walkthrough) |
| 85 | ✅ [rust/cli](rust/cli/) | Rust | cli | Cargo | yes | prints `Hello, World!` | [read](rust/cli/README.md#step-by-step-walkthrough) |
| 86 | ✅ [rust/desktop](rust/desktop/) | Rust | desktop | eframe / egui | yes | window | [read](rust/desktop/README.md#step-by-step-walkthrough) |
| 87 | ✅ [rust/web](rust/web/) | Rust | web | Axum | yes | http://localhost:8080/ | [read](rust/web/README.md#step-by-step-walkthrough) |
| 88 | ✅ [scala/cli](scala/cli/) | Scala | cli | JDK 21, Scala 3.10.1 (`scalac`, `scala`) | yes | prints `Hello, World!` | [read](scala/cli/README.md#step-by-step-walkthrough) |
| 89 | ✅ [simula/cli](simula/cli/) | Simula | cli | GNU Cim 5.1 (Simula 67 compiled to C) | yes | prints `Hello, World!` | [read](simula/cli/README.md#step-by-step-walkthrough) |
| 90 | ✅ [smalltalk/cli](smalltalk/cli/) | Smalltalk | cli | GNU Smalltalk (gst) | no | prints `Hello, World!` | [read](smalltalk/cli/README.md#step-by-step-walkthrough) |
| 91 | ✅ [smalltalk/desktop](smalltalk/desktop/) | Smalltalk | desktop | Pharo 14, Morphic | no | window | [read](smalltalk/desktop/README.md#step-by-step-walkthrough) |
| 92 | ✅ [smalltalk/web](smalltalk/web/) | Smalltalk | web | Pharo 14, Zinc HTTP | no | http://localhost:8080/ | [read](smalltalk/web/README.md#step-by-step-walkthrough) |
| 93 | ✅ [swift/cli](swift/cli/) | Swift | cli | Swift 6 (swiftc) | yes | prints `Hello, World!` | [read](swift/cli/README.md#step-by-step-walkthrough) |
| 94 | ✅ [swift/desktop](swift/desktop/) | Swift | desktop | SwiftUI + AppKit | yes | window | [read](swift/desktop/README.md#step-by-step-walkthrough) |
| 95 | ✅ [swift/web](swift/web/) | Swift | web | Vapor 4 | yes | http://localhost:8080/ | [read](swift/web/README.md#step-by-step-walkthrough) |
| 96 | ✅ [swift/mobile-ios](swift/mobile-ios/) | Swift | mobile | SwiftUI + iOS Simulator (full Xcode) | yes | app in the iOS Simulator | [read](swift/mobile-ios/README.md#step-by-step-walkthrough) |
| 97 | ✅ [typescript/cli](typescript/cli/) | TypeScript | cli | Node.js + TypeScript 7.0.2 (`tsc`) | yes | prints `Hello, World!` | [read](typescript/cli/README.md#step-by-step-walkthrough) |
| 98 | ✅ [typescript/web](typescript/web/) | TypeScript | web | Node.js + TypeScript 7.0.2 (`tsc`), `node:http` | yes | http://localhost:8080/ | [read](typescript/web/README.md#step-by-step-walkthrough) |
| 99 | ✅ [visual-basic/cli](visual-basic/cli/) | Visual Basic (VB.NET) | cli | .NET 10 SDK (`dotnet`), VB.NET | yes | prints `Hello, World!` | [read](visual-basic/cli/README.md#step-by-step-walkthrough) |
| 100 | ✅ [visual-basic/web](visual-basic/web/) | Visual Basic (VB.NET) | web | .NET 10 SDK, ASP.NET Core minimal API in VB.NET | yes | http://localhost:8080 (PORT) | [read](visual-basic/web/README.md#step-by-step-walkthrough) |
| 101 | ✅ [zig/cli](zig/cli/) | Zig | cli | Zig 0.17.0 (`zig build-exe`, official tarball) | yes | prints `Hello, World!` | [read](zig/cli/README.md#step-by-step-walkthrough) |
<!-- END GENERATED: implementations-table -->
<!-- vale on -->

## meta.yml schema
`meta.yml` is the single source of truth for the facts that are shown
outside the language's own README: the root README table, this file, and
the website. Example (`languages/c/meta.yml`, shortened):

```yaml
# languages/c/meta.yml - facts about this language, read by
# scripts/gen-readme.py. Schema: languages/README.md#metayml-schema.
name: "C (ANSI C)"
year: 1972
year_note: "C came into being in 1969–1973, with the most creative period in 1972; standardized as ANSI X3.159-1989 / ISO/IEC 9899:1990"
designers:
  - "Dennis Ritchie"
paradigms:
  - "imperative"
categories:
  - folder: "cli"
    kind: "cli"
    toolchain: "system C compiler, `-std=c89`"
    run: "prints `Hello, World!`"
    status: "verified"
sources:
  - title: "The Development of the C Language. Dennis M. Ritchie, Second History of Programming Languages conference (HOPL-II), ACM, 1993. Author's reprint, archived copy of bell-labs.com (2015-12-31)"
    url: "https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html"
humor:
  label: "C"
  line: "C trusts the programmer completely. `printf` prints whatever it is asked to print, including what nobody meant to ask."
  dictionary:
    - term: "C"
      definition: "a language that gives the programmer enough rope, and the address of the rope."
```

### Language keys
| Key | Required | Value |
|---|---|---|
| `name` | yes | Display name, as in the README title. |
| `other_names` | no | List of other names the language is known by (for example `"Golang"` for Go), for the search on the website's Languages page. A name is listed only when one of the language's `sources` uses it. None of them may be the `name` of another language. |
| `year` | yes | Year the language first appeared, as the README states and cites it (integer). `null` only when no single year exists, and then `year_note` is required. |
| `year_note` | no | One line that explains the year (for example "standardized in 1989"). |
| `designers` | yes | List of the people (or the organization, if no person is named) the README credits with the design. May be empty only if the README explains why. |
| `paradigms` | yes | List, main paradigm first. `imperative`, `object-oriented`, `functional`, and `logic` link to their section of [docs/paradigms.md](../docs/paradigms.md). Other labels (for example `multi-paradigm`, `concurrent`) are shown as plain text. |
| `categories` | yes | List of implementation folders (keys below). Every subfolder that has a `README.md` must be listed, and every entry must exist; the generator stops with an error otherwise. |
| `sources` | yes | List of `title` + `url`: the sources the language README cites for `year` and `designers` (see [About the sources](../docs/sources.md)). |
| `humor` | yes | The language's light side, shown on the [Off the record](../docs/off-the-record.md) page and in a box at the end of the language's page on the website. A mapping with the keys below. |
| `influenced_by` | no | List of languages a source links to this one, for the website's Genealogy page. Each entry has `language` (display name), `title` + `url` (the source) and `quote` (the source's exact words that make the link), all required, and `slug` (the folder under `languages/`) only when that language is in this repository. Leave the key out when no source is found. |

### Humor keys
The text of `line` and of `dictionary` is written for this repository and
follows the tone rule of the [Off the record](../docs/off-the-record.md)
page. A joke in `jokes` is quoted word for word, so it names where it was
found.

| Key | Required | Value |
|---|---|---|
| `line` | yes | One light remark about the language, in one or two sentences (the "One line per language" list). |
| `label` | no | The name shown before `line` when `name` is too long, for example `C` for `C (ANSI C)`. |
| `jokes` | no | List of jokes about this language only. Each entry has `text` (the exact words), `title` and `url` (the page where it was found), and `accessed` (the date the page was read, `YYYY-MM-DD`), all required, and `author` when the source names one. Without `author` the website shows "Origin unknown, found at …". Link to images; never copy them. |
| `dictionary` | no | List of entries about this language for the Improbable Dictionary of Programming: `term` and `definition`, both required, and `part` (part of speech, default `n.`). The definition starts in lower case, as in a dictionary. |

A translation may adapt `humor` instead of translating it (see
[Translations](../i18n/README.md)).

### Category keys
| Key | Required | Value |
|---|---|---|
| `folder` | yes | Subfolder name, for example `cli`, `desktop-swing`, `web-react`. |
| `kind` | yes | Table column: `cli`, `desktop`, `web` (the server sends the HTML), `web-frontend` (a server API plus a separate React/Angular/Vue front end), or `mobile`. |
| `label` | no | Short text for the link when `folder` is not clear enough, for example `Swing`, `React`, `Portugol`. |
| `toolchain` | yes | Compiler, runtime, or framework, in a few words. |
| `run` | yes | What `run.sh` does: ``prints `Hello, World!` ``, `window`, or the URL it serves. |
| `status` | yes | One of the values below. |
| `note` | no | One line, for example why the status is `compromise` or `not-verified`. |

### Status values
| `status` | Shown as | Meaning |
|---|---|---|
| `verified` | ✅ | `scripts/verify-all.sh` passes for this folder on the development machine (macOS Intel). |
| `compromise` | 🔶 | Verified, but with a stand-in for the original toolchain or dialect (for example Delphi-dialect code built with Free Pascal). The README explains the compromise. |
| `not-verified` | ⚠️ | Written and documented, but it cannot run on the development machine (for example iOS without Xcode). The README says where it was or can be checked. |
| `documented` | 📄 | README only, no `run.sh`, because nothing can run it (for example CLRS pseudocode, which has no interpreter). `verify-all.sh` lists it as skipped. |

`documented` is for folders that have no `run.sh` at all, such as
`pseudocode/clrs`.

### Syntax: a strict subset of YAML
`scripts/gen-readme.py` uses only the Python standard library, so it reads
a small, strict subset of [YAML 1.2.2](https://yaml.org/spec/1.2.2/). Any
YAML parser reads the same files the same way. The rules:
- Indent with 2 spaces. No tabs.
- A comment (`#`) goes on its own line.
- Write every string in double quotes (`"..."`), with JSON escapes (`\"`,
  `\\`). Numbers and `null` have no quotes. An empty list is written `[]`.
- Top-level keys hold a value (`key: "value"`) or a list (`key:` followed
  by `  - ` lines). List items are either values (`  - "value"`) or
  mappings (`  - key: "value"`, then `    key: "value"` for the item's
  other keys).
- A top-level key may hold a mapping instead (`humor:` followed by
  `  key: "value"` lines). A key of that mapping may hold a list, written
  as above but two spaces further in.

Anything else (flow style `[a, b]`, multi-line strings, anchors, any other
nesting) makes the generator stop with the file and line number.
