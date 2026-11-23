---
source: languages/README.md
source_sha: e96d6f327528ed482a3d8825f901eba3e20b1d86
---
# Linguagens

> Parte de [Hello World em várias linguagens](../README.md)

Uma pasta por linguagem. Cada uma contém:

```text
languages/<language>/README.md      the language: history, milestones, usage, sources
languages/<language>/meta.yml       facts about the language, read by scripts/gen-readme.py
languages/<language>/<category>/    one implementation: README, install.sh, build.sh, run.sh, source
```

As regras de cada pasta estão em [CONTRIBUTING.md](../CONTRIBUTING.md).
As tabelas deste arquivo e do [README da raiz](../README.md#languages) são
**geradas** a partir dos arquivos `meta.yml`. Não as edite manualmente.
Depois de alterar um `meta.yml`, execute:

```sh
python3 scripts/gen-readme.py           # rewrite the generated tables
python3 scripts/gen-readme.py --check   # exit 1 if they are out of date (CI)
```

## Todas as implementações
Todas as pastas, com sua toolchain, a indicação de que têm ou não um
`build.sh`, o que o `run.sh` faz e um link para o passo a passo guiado.
Uma "janela" desktop mostra `Hello, World!`; uma URL web o serve. As portas
web podem ser alteradas com `PORT=...`. Quem está começando a programar
encontra em
[docs/comparisons.md](../docs/comparisons.md#a-guided-path-through-the-walkthroughs)
uma ordem sugerida para os passos a passo.

<!-- The generated table lists folder paths and command names as link text, which Vale cannot tell from prose. -->
<!-- vale off -->
<!-- BEGIN GENERATED: implementations-table -->
<!-- Do not edit by hand: run python3 scripts/gen-readme.py (source: languages/*/meta.yml). -->
| # | Pasta | Linguagem | Categoria | Toolchain / framework | `build.sh` | Resultado de `run.sh` | Passo a passo |
|---|---|---|---|---|---|---|---|
| 1 | ✅ [ada/cli](ada/cli/) | Ada | cli | GNAT via Alire | sim | imprime `Hello, World!` | [ler](ada/cli/README.md#step-by-step-walkthrough) |
| 2 | ✅ [algol68/cli](algol68/cli/) | ALGOL 68 | cli | Algol 68 Genie 3.13.4 interpreter, built from source | não | imprime `Hello, World!` | [ler](algol68/cli/README.md#step-by-step-walkthrough) |
| 3 | ✅ [assembly/cli](assembly/cli/) | Assembly (x86-64) | cli | NASM + `cc` (macOS x86-64) | sim | imprime `Hello, World!` | [ler](assembly/cli/README.md#step-by-step-walkthrough) |
| 4 | ✅ [bash/cli](bash/cli/) | Bash | cli | GNU Bash 5.3.20 (Homebrew formula `bash`), interpreted: no build step | não | imprime `Hello, World!` | [ler](bash/cli/README.md#step-by-step-walkthrough) |
| 5 | ✅ [basic/cli](basic/cli/) | BASIC | cli | QB64 Phoenix Edition | sim | imprime `Hello, World!` | [ler](basic/cli/README.md#step-by-step-walkthrough) |
| 6 | ✅ [c/cli](c/cli/) | C (ANSI C) | cli | system C compiler, `-std=c89` | sim | imprime `Hello, World!` | [ler](c/cli/README.md#step-by-step-walkthrough) |
| 7 | ✅ [c/desktop](c/desktop/) | C (ANSI C) | desktop | GTK 4, `-std=c99` | sim | janela | [ler](c/desktop/README.md#step-by-step-walkthrough) |
| 8 | ✅ [c/web](c/web/) | C (ANSI C) | web | GNU libmicrohttpd, `-std=c99` | sim | http://localhost:8080/ | [ler](c/web/README.md#step-by-step-walkthrough) |
| 9 | ✅ [csharp/cli](csharp/cli/) | C# | cli | .NET 10 SDK | sim | imprime `Hello, World!` | [ler](csharp/cli/README.md#step-by-step-walkthrough) |
| 10 | ✅ [csharp/desktop](csharp/desktop/) | C# | desktop | Avalonia | sim | janela | [ler](csharp/desktop/README.md#step-by-step-walkthrough) |
| 11 | ✅ [csharp/web](csharp/web/) | C# | web | ASP.NET Core | sim | http://localhost:8080/ | [ler](csharp/web/README.md#step-by-step-walkthrough) |
| 12 | ✅ [csharp/web-angular](csharp/web-angular/) | C# | web + Angular | ASP.NET Core API + Angular | sim | http://localhost:4200/ (API :8080) | [ler](csharp/web-angular/README.md#step-by-step-walkthrough) |
| 13 | ✅ [cpp/cli](cpp/cli/) | C++ | cli | CMake, C++20 | sim | imprime `Hello, World!` | [ler](cpp/cli/README.md#step-by-step-walkthrough) |
| 14 | ✅ [cpp/desktop](cpp/desktop/) | C++ | desktop | Qt 6 Widgets, CMake | sim | janela | [ler](cpp/desktop/README.md#step-by-step-walkthrough) |
| 15 | ✅ [cpp/web](cpp/web/) | C++ | web | cpp-httplib, CMake | sim | http://localhost:8080/ | [ler](cpp/web/README.md#step-by-step-walkthrough) |
| 16 | ✅ [clipper/cli](clipper/cli/) | Clipper | cli | Harbour | sim | imprime `Hello, World!` | [ler](clipper/cli/README.md#step-by-step-walkthrough) |
| 17 | ✅ [clojure/cli](clojure/cli/) | Clojure | cli | Clojure CLI 1.12.6.1673 | não | imprime `Hello, World!` | [ler](clojure/cli/README.md#step-by-step-walkthrough) |
| 18 | ✅ [clojure/desktop](clojure/desktop/) | Clojure | desktop (Swing) | Swing via interop com Java, Clojure CLI | não | janela | [ler](clojure/desktop/README.md#step-by-step-walkthrough) |
| 19 | ✅ [clojure/web](clojure/web/) | Clojure | web (Ring) | Ring + Jetty, Clojure CLI | não | http://localhost:8080/ | [ler](clojure/web/README.md#step-by-step-walkthrough) |
| 20 | ✅ [cobol/cli](cobol/cli/) | COBOL | cli | GnuCOBOL | sim | imprime `Hello, World!` | [ler](cobol/cli/README.md#step-by-step-walkthrough) |
| 21 | ✅ [lisp/cli](lisp/cli/) | Common Lisp | cli | SBCL | sim | imprime `Hello, World!` | [ler](lisp/cli/README.md#step-by-step-walkthrough) |
| 22 | ✅ [lisp/web](lisp/web/) | Common Lisp | web | Hunchentoot (Quicklisp), SBCL | sim | http://localhost:8080/ | [ler](lisp/web/README.md#step-by-step-walkthrough) |
| 23 | ✅ [dart/cli](dart/cli/) | Dart | cli | Dart SDK | não | imprime `Hello, World!` | [ler](dart/cli/README.md#step-by-step-walkthrough) |
| 24 | ✅ [dart/web](dart/web/) | Dart | web | `dart:io` HttpServer | não | http://localhost:8080/ | [ler](dart/web/README.md#step-by-step-walkthrough) |
| 25 | ✅ [dart/mobile-flutter](dart/mobile-flutter/) | Dart | mobile | Flutter 3.47.9 (Android) | sim | imprime `Hello, World!` no emulador Android | [ler](dart/mobile-flutter/README.md#step-by-step-walkthrough) |
| 26 | 🔶 [dbase/cli](dbase/cli/) | dBASE | cli | Harbour 3.2.0 (dBASE III-compatible `.prg`) | sim | imprime `Hello, World!` | [ler](dbase/cli/README.md#step-by-step-walkthrough) |
| 27 | 🔶 [delphi/cli](delphi/cli/) | Delphi (Object Pascal dialect) | cli | Free Pascal 3.2.2 in Delphi mode (`{$mode delphi}`) | sim | imprime `Hello, World!` | [ler](delphi/cli/README.md#step-by-step-walkthrough) |
| 28 | 🔶 [delphi/desktop](delphi/desktop/) | Delphi (Object Pascal dialect) | desktop | Lazarus 4.8 (LCL, Cocoa) with Free Pascal 3.2.2 | sim | janela | [ler](delphi/desktop/README.md#step-by-step-walkthrough) |
| 29 | ✅ [eiffel/cli](eiffel/cli/) | Eiffel | cli | Gobo Eiffel 26.03 (gec, Homebrew bottle) | sim | imprime `Hello, World!` | [ler](eiffel/cli/README.md#step-by-step-walkthrough) |
| 30 | ✅ [elixir/cli](elixir/cli/) | Elixir | cli | Elixir (`elixir hello.exs`) | não | imprime `Hello, World!` | [ler](elixir/cli/README.md#step-by-step-walkthrough) |
| 31 | ✅ [elixir/web](elixir/web/) | Elixir | web | Mix project, Plug and Bandit from Hex | sim | http://localhost:8080/ | [ler](elixir/web/README.md#step-by-step-walkthrough) |
| 32 | ✅ [erlang/cli](erlang/cli/) | Erlang | cli | Erlang/OTP (`escript hello.erl`) | não | imprime `Hello, World!` | [ler](erlang/cli/README.md#step-by-step-walkthrough) |
| 33 | ✅ [erlang/desktop](erlang/desktop/) | Erlang | desktop | Erlang/OTP, `wx` (`wxWidgets`) | sim | janela | [ler](erlang/desktop/README.md#step-by-step-walkthrough) |
| 34 | ✅ [erlang/web](erlang/web/) | Erlang | web | Erlang/OTP, `httpd` from `inets` | sim | http://localhost:8080/ | [ler](erlang/web/README.md#step-by-step-walkthrough) |
| 35 | ✅ [fsharp/cli](fsharp/cli/) | F# | cli | .NET 10 SDK (`dotnet`), F# 10 | sim | imprime `Hello, World!` | [ler](fsharp/cli/README.md#step-by-step-walkthrough) |
| 36 | ✅ [fortran/cli](fortran/cli/) | Fortran | cli | GFortran (`gfortran`) | sim | imprime `Hello, World!` | [ler](fortran/cli/README.md#step-by-step-walkthrough) |
| 37 | ✅ [go/cli](go/cli/) | Go | cli | Go toolchain | sim | imprime `Hello, World!` | [ler](go/cli/README.md#step-by-step-walkthrough) |
| 38 | ✅ [go/desktop](go/desktop/) | Go | desktop | Fyne | sim | janela | [ler](go/desktop/README.md#step-by-step-walkthrough) |
| 39 | ✅ [go/web](go/web/) | Go | web | `net/http` + `html/template` (standard library) | sim | http://localhost:8080/ | [ler](go/web/README.md#step-by-step-walkthrough) |
| 40 | ✅ [go/web-vue](go/web-vue/) | Go | web + Vue | Go API + Vue (Vite) | sim | http://localhost:4173/ (API :8080) | [ler](go/web-vue/README.md#step-by-step-walkthrough) |
| 41 | ✅ [haskell/cli](haskell/cli/) | Haskell | cli | GHC (via GHCup) | sim | imprime `Hello, World!` | [ler](haskell/cli/README.md#step-by-step-walkthrough) |
| 42 | ✅ [haskell/web](haskell/web/) | Haskell | web | Scotty, Cabal | sim | http://localhost:8080/ | [ler](haskell/web/README.md#step-by-step-walkthrough) |
| 43 | ✅ [java/cli](java/cli/) | Java | cli | JDK 21, Maven | sim | imprime `Hello, World!` | [ler](java/cli/README.md#step-by-step-walkthrough) |
| 44 | ✅ [java/desktop](java/desktop/) | Java | desktop (JavaFX) | JavaFX, Maven | sim | janela | [ler](java/desktop/README.md#step-by-step-walkthrough) |
| 45 | ✅ [java/desktop-swing](java/desktop-swing/) | Java | desktop (Swing) | Swing (JDK), Maven | sim | janela | [ler](java/desktop-swing/README.md#step-by-step-walkthrough) |
| 46 | ✅ [java/web](java/web/) | Java | web | Spring Boot, Maven | sim | http://localhost:8080/ | [ler](java/web/README.md#step-by-step-walkthrough) |
| 47 | ✅ [java/web-react](java/web-react/) | Java | web + React | Spring Boot API + React (Vite) | sim | http://localhost:4173/ (API :8080) | [ler](java/web-react/README.md#step-by-step-walkthrough) |
| 48 | ✅ [julia/cli](julia/cli/) | Julia | cli | Julia 1.13.4 (official tarball, `julia --startup-file=no`) | não | imprime `Hello, World!` | [ler](julia/cli/README.md#step-by-step-walkthrough) |
| 49 | ✅ [kotlin/cli](kotlin/cli/) | Kotlin | cli | JDK 21, `kotlinc` 2.4.21 | sim | imprime `Hello, World!` | [ler](kotlin/cli/README.md#step-by-step-walkthrough) |
| 50 | ✅ [kotlin/desktop](kotlin/desktop/) | Kotlin | desktop (Compose) | Compose Multiplatform, Gradle | sim | janela | [ler](kotlin/desktop/README.md#step-by-step-walkthrough) |
| 51 | ✅ [kotlin/web](kotlin/web/) | Kotlin | web (Ktor) | Ktor (Netty), Gradle | sim | http://localhost:8080/ | [ler](kotlin/web/README.md#step-by-step-walkthrough) |
| 52 | ✅ [kotlin/mobile-android](kotlin/mobile-android/) | Kotlin | mobile (Android) | Jetpack Compose, Android Gradle plugin, Android emulator (x86_64) | sim | a aplicação no emulador Android | [ler](kotlin/mobile-android/README.md#step-by-step-walkthrough) |
| 53 | ✅ [lua/cli](lua/cli/) | Lua | cli | Lua 5.5 | não | imprime `Hello, World!` | [ler](lua/cli/README.md#step-by-step-walkthrough) |
| 54 | 🔶 [lua/desktop](lua/desktop/) | Lua | desktop | LÖVE 11.5 (LuaJIT, Lua 5.1 dialect) | não | janela | [ler](lua/desktop/README.md#step-by-step-walkthrough) |
| 55 | ✅ [lua/web](lua/web/) | Lua | web | Pegasus, LuaRocks | não | http://localhost:8080/ | [ler](lua/web/README.md#step-by-step-walkthrough) |
| 56 | ✅ [node/cli](node/cli/) | Node.js (JavaScript) | cli | Node.js | não | imprime `Hello, World!` | [ler](node/cli/README.md#step-by-step-walkthrough) |
| 57 | ✅ [node/desktop](node/desktop/) | Node.js (JavaScript) | desktop | Electron | não | janela | [ler](node/desktop/README.md#step-by-step-walkthrough) |
| 58 | ✅ [node/web](node/web/) | Node.js (JavaScript) | web | Express | não | http://localhost:8080/ | [ler](node/web/README.md#step-by-step-walkthrough) |
| 59 | ✅ [objectivec/cli](objectivec/cli/) | Objective-C | cli | clang + Foundation | sim | imprime `Hello, World!` | [ler](objectivec/cli/README.md#step-by-step-walkthrough) |
| 60 | ✅ [objectivec/desktop](objectivec/desktop/) | Objective-C | desktop | clang + AppKit | sim | janela | [ler](objectivec/desktop/README.md#step-by-step-walkthrough) |
| 61 | ✅ [objectivec/web](objectivec/web/) | Objective-C | web | clang + Foundation + BSD sockets | sim | http://localhost:8080/ | [ler](objectivec/web/README.md#step-by-step-walkthrough) |
| 62 | ✅ [ocaml/cli](ocaml/cli/) | OCaml | cli | OCaml 5.5.2 (`ocamlopt`, Homebrew formula built from source) | sim | imprime `Hello, World!` | [ler](ocaml/cli/README.md#step-by-step-walkthrough) |
| 63 | ✅ [pascal/cli](pascal/cli/) | Pascal | cli | Free Pascal (ISO 7185 mode) | sim | imprime `Hello, World!` | [ler](pascal/cli/README.md#step-by-step-walkthrough) |
| 64 | ✅ [pascal/desktop](pascal/desktop/) | Pascal | desktop | Lazarus LCL (`lazbuild`) | sim | janela | [ler](pascal/desktop/README.md#step-by-step-walkthrough) |
| 65 | ✅ [perl/cli](perl/cli/) | Perl | cli | perl 5 | não | imprime `Hello, World!` | [ler](perl/cli/README.md#step-by-step-walkthrough) |
| 66 | 🔶 [perl/desktop](perl/desktop/) | Perl | desktop | Tkx (Tcl/Tk) | não | janela | [ler](perl/desktop/README.md#step-by-step-walkthrough) |
| 67 | ✅ [perl/web](perl/web/) | Perl | web | Mojolicious::Lite | não | http://localhost:8080/ | [ler](perl/web/README.md#step-by-step-walkthrough) |
| 68 | ✅ [php/cli](php/cli/) | PHP | cli | `php` CLI | não | imprime `Hello, World!` | [ler](php/cli/README.md#step-by-step-walkthrough) |
| 69 | ✅ [php/web](php/web/) | PHP | web | PHP built-in server (`php -S`) | não | http://localhost:8080/ | [ler](php/web/README.md#step-by-step-walkthrough) |
| 70 | ✅ [prolog/cli](prolog/cli/) | Prolog | cli | SWI-Prolog | não | imprime `Hello, World!` | [ler](prolog/cli/README.md#step-by-step-walkthrough) |
| 71 | ✅ [prolog/web](prolog/web/) | Prolog | web | SWI-Prolog HTTP libraries | não | http://localhost:8080/ | [ler](prolog/web/README.md#step-by-step-walkthrough) |
| 72 | ✅ [pseudocode/portugol](pseudocode/portugol/) | Pseudocode (Portugol) | cli | Delégua interpreter (VisuAlg dialect), via npm | não | imprime `Hello, World!` | [ler](pseudocode/portugol/README.md#step-by-step-walkthrough) |
| 73 | ✅ [pseudocode/pseint](pseudocode/pseint/) | Pseudocode (PSeInt) | cli | PSeInt | não | imprime `Hello, World!` | [ler](pseudocode/pseint/README.md#step-by-step-walkthrough) |
| 74 | 📄 [pseudocode/clrs](pseudocode/clrs/) | Pseudocode (CLRS) | cli | none: documented only | – | – (sem interpretador) | [ler](pseudocode/clrs/README.md#step-by-step-walkthrough) |
| 75 | ✅ [python/cli](python/cli/) | Python | cli | CPython | não | imprime `Hello, World!` | [ler](python/cli/README.md#step-by-step-walkthrough) |
| 76 | ✅ [python/desktop](python/desktop/) | Python | desktop | tkinter (standard library) | não | janela | [ler](python/desktop/README.md#step-by-step-walkthrough) |
| 77 | ✅ [python/web](python/web/) | Python | web | Flask | não | http://localhost:8080/ | [ler](python/web/README.md#step-by-step-walkthrough) |
| 78 | ✅ [qcl/cli](qcl/cli/) | QCL (Quantum Computation Language) | cli | QCL 0.6.7 interpreter and simulator, built from source (GNU readline) | sim | imprime `: Hello, World! ` (o QCL acrescenta o prefixo e o espaço final) | [ler](qcl/cli/README.md#step-by-step-walkthrough) |
| 79 | ✅ [r/cli](r/cli/) | R | cli | R 4.6.2 (`Rscript`, Homebrew formula built from source) | não | imprime `Hello, World!` | [ler](r/cli/README.md#step-by-step-walkthrough) |
| 80 | ✅ [racket/cli](racket/cli/) | Racket | cli | Racket 9.3 CS (Minimal Racket, `racket hello.rkt`) | não | imprime `Hello, World!` | [ler](racket/cli/README.md#step-by-step-walkthrough) |
| 81 | ✅ [ruby/cli](ruby/cli/) | Ruby | cli | Ruby (`ruby`) | não | imprime `Hello, World!` | [ler](ruby/cli/README.md#step-by-step-walkthrough) |
| 82 | ✅ [ruby/desktop](ruby/desktop/) | Ruby | desktop | Ruby/Tk (`tk` gem), Tcl/Tk | não | janela | [ler](ruby/desktop/README.md#step-by-step-walkthrough) |
| 83 | ✅ [ruby/web](ruby/web/) | Ruby | web | Sinatra, Puma | não | http://localhost:8080/ | [ler](ruby/web/README.md#step-by-step-walkthrough) |
| 84 | ✅ [ruby/web-rails](ruby/web-rails/) | Ruby | web (Rails) | Ruby on Rails, Puma | não | http://localhost:8080/ | [ler](ruby/web-rails/README.md#step-by-step-walkthrough) |
| 85 | ✅ [rust/cli](rust/cli/) | Rust | cli | Cargo | sim | imprime `Hello, World!` | [ler](rust/cli/README.md#step-by-step-walkthrough) |
| 86 | ✅ [rust/desktop](rust/desktop/) | Rust | desktop | eframe / egui | sim | janela | [ler](rust/desktop/README.md#step-by-step-walkthrough) |
| 87 | ✅ [rust/web](rust/web/) | Rust | web | Axum | sim | http://localhost:8080/ | [ler](rust/web/README.md#step-by-step-walkthrough) |
| 88 | ✅ [scala/cli](scala/cli/) | Scala | cli | JDK 21, Scala 3.10.1 (`scalac`, `scala`) | sim | imprime `Hello, World!` | [ler](scala/cli/README.md#step-by-step-walkthrough) |
| 89 | ✅ [simula/cli](simula/cli/) | Simula | cli | GNU Cim 5.1 (Simula 67 compiled to C) | sim | imprime `Hello, World!` | [ler](simula/cli/README.md#step-by-step-walkthrough) |
| 90 | ✅ [smalltalk/cli](smalltalk/cli/) | Smalltalk | cli | GNU Smalltalk (gst) | não | imprime `Hello, World!` | [ler](smalltalk/cli/README.md#step-by-step-walkthrough) |
| 91 | ✅ [smalltalk/desktop](smalltalk/desktop/) | Smalltalk | desktop | Pharo 14, Morphic | não | janela | [ler](smalltalk/desktop/README.md#step-by-step-walkthrough) |
| 92 | ✅ [smalltalk/web](smalltalk/web/) | Smalltalk | web | Pharo 14, Zinc HTTP | não | http://localhost:8080/ | [ler](smalltalk/web/README.md#step-by-step-walkthrough) |
| 93 | ✅ [swift/cli](swift/cli/) | Swift | cli | Swift 6 (swiftc) | sim | imprime `Hello, World!` | [ler](swift/cli/README.md#step-by-step-walkthrough) |
| 94 | ✅ [swift/desktop](swift/desktop/) | Swift | desktop | SwiftUI + AppKit | sim | janela | [ler](swift/desktop/README.md#step-by-step-walkthrough) |
| 95 | ✅ [swift/web](swift/web/) | Swift | web | Vapor 4 | sim | http://localhost:8080/ | [ler](swift/web/README.md#step-by-step-walkthrough) |
| 96 | ✅ [swift/mobile-ios](swift/mobile-ios/) | Swift | mobile | SwiftUI + iOS Simulator (full Xcode) | sim | a aplicação no iOS Simulator | [ler](swift/mobile-ios/README.md#step-by-step-walkthrough) |
| 97 | ✅ [typescript/cli](typescript/cli/) | TypeScript | cli | Node.js + TypeScript 7.0.2 (`tsc`) | sim | imprime `Hello, World!` | [ler](typescript/cli/README.md#step-by-step-walkthrough) |
| 98 | ✅ [typescript/web](typescript/web/) | TypeScript | web | Node.js + TypeScript 7.0.2 (`tsc`), `node:http` | sim | http://localhost:8080/ | [ler](typescript/web/README.md#step-by-step-walkthrough) |
| 99 | ✅ [visual-basic/cli](visual-basic/cli/) | Visual Basic (VB.NET) | cli | .NET 10 SDK (`dotnet`), VB.NET | sim | imprime `Hello, World!` | [ler](visual-basic/cli/README.md#step-by-step-walkthrough) |
| 100 | ✅ [visual-basic/web](visual-basic/web/) | Visual Basic (VB.NET) | web | .NET 10 SDK, ASP.NET Core minimal API in VB.NET | sim | http://localhost:8080 (PORT) | [ler](visual-basic/web/README.md#step-by-step-walkthrough) |
| 101 | ✅ [zig/cli](zig/cli/) | Zig | cli | Zig 0.17.0 (`zig build-exe`, official tarball) | sim | imprime `Hello, World!` | [ler](zig/cli/README.md#step-by-step-walkthrough) |
<!-- END GENERATED: implementations-table -->
<!-- vale on -->

## Esquema do meta.yml
O `meta.yml` é a fonte única dos fatos exibidos fora do README da própria
linguagem: a tabela do README da raiz, este arquivo e o site. Exemplo
(`languages/c/meta.yml`, abreviado):

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

### Chaves da linguagem
| Chave | Obrigatória | Valor |
|---|---|---|
| `name` | sim | Nome de exibição, como no título do README. |
| `other_names` | não | Lista de outros nomes pelos quais a linguagem é conhecida (por exemplo `"Golang"` para Go), para a busca na página Linguagens do site. Um nome só é listado quando uma das `sources` da linguagem o usa. Nenhum deles pode ser o `name` de outra linguagem. |
| `year` | sim | Ano em que a linguagem surgiu, como o README o informa e cita (inteiro). `null` somente quando não existe um ano único e, nesse caso, `year_note` é obrigatório. |
| `year_note` | não | Uma linha que explica o ano (por exemplo, "padronizada em 1989"). |
| `designers` | sim | Lista das pessoas (ou da organização, se nenhuma pessoa for nomeada) a quem o README atribui o projeto da linguagem. Pode ficar vazia somente se o README explicar o motivo. |
| `paradigms` | sim | Lista, com o paradigma principal primeiro. `imperative`, `object-oriented`, `functional` e `logic` têm link para sua seção em [docs/paradigms.md](../docs/paradigms.md). Os demais rótulos (por exemplo, `multi-paradigm`, `concurrent`) são exibidos como texto simples. |
| `categories` | sim | Lista das pastas de implementação (chaves abaixo). Toda subpasta que tem um `README.md` deve constar da lista, e toda entrada deve existir; caso contrário, o gerador termina com erro. |
| `sources` | sim | Lista de `title` + `url`: as fontes que o README da linguagem cita para `year` e `designers` (consulte [Sobre as fontes](../docs/sources.md)). |
| `humor` | sim | O lado leve da linguagem, exibido na página [Off the record](../docs/off-the-record.md) e em um quadro ao final da página da linguagem no site. Um mapeamento com as chaves abaixo. |
| `influenced_by` | não | Lista de linguagens que uma fonte relaciona a esta, para a página Genealogy do site. Cada entrada tem `language` (nome de exibição), `title` + `url` (a fonte) e `quote` (as palavras exatas da fonte que estabelecem a relação), todos obrigatórios, e `slug` (a pasta em `languages/`) somente quando essa linguagem está neste repositório. Omita a chave quando nenhuma fonte for encontrada. |

### Chaves de humor
O texto de `line` e de `dictionary` é escrito para este repositório e
segue a regra de tom da página [Off the record](../docs/off-the-record.md).
Uma piada em `jokes` é citada palavra por palavra, de modo que informa onde
foi encontrada.

| Chave | Obrigatória | Valor |
|---|---|---|
| `line` | sim | Uma observação leve sobre a linguagem, em uma ou duas frases (a lista "One line per language"). |
| `label` | não | O nome exibido antes de `line` quando `name` é longo demais, por exemplo `C` para `C (ANSI C)`. |
| `jokes` | não | Lista de piadas somente sobre esta linguagem. Cada entrada tem `text` (as palavras exatas), `title` e `url` (a página em que foi encontrada) e `accessed` (a data em que a página foi lida, `YYYY-MM-DD`), todos obrigatórios, e `author` quando a fonte indica um. Sem `author`, o site exibe "Origin unknown, found at …". Use links para imagens; nunca as copie. |
| `dictionary` | não | Lista de entradas sobre esta linguagem para o Improbable Dictionary of Programming: `term` e `definition`, ambos obrigatórios, e `part` (classe gramatical, padrão `n.`). A definição começa em minúscula, como em um dicionário. |

Uma tradução pode adaptar o `humor` em vez de traduzi-lo (consulte
[Traduções](../i18n/README.md)).

### Chaves de categoria
| Chave | Obrigatória | Valor |
|---|---|---|
| `folder` | sim | Nome da subpasta, por exemplo `cli`, `desktop-swing`, `web-react`. |
| `kind` | sim | Coluna da tabela: `cli`, `desktop`, `web` (o servidor envia o HTML), `web-frontend` (uma API de servidor mais um front-end React/Angular/Vue separado) ou `mobile`. |
| `label` | não | Texto curto para o link quando `folder` não é claro o suficiente, por exemplo `Swing`, `React`, `Portugol`. |
| `toolchain` | sim | Compilador, runtime ou framework, em poucas palavras. |
| `run` | sim | O que o `run.sh` faz: ``prints `Hello, World!` ``, `window` ou a URL que serve. |
| `status` | sim | Um dos valores abaixo. |
| `note` | não | Uma linha, por exemplo o motivo de o status ser `compromise` ou `not-verified`. |

### Valores de status
| `status` | Exibido como | Significado |
|---|---|---|
| `verified` | ✅ | `scripts/verify-all.sh` passa para esta pasta na máquina de desenvolvimento (macOS Intel). |
| `compromise` | 🔶 | Verificado, mas com um substituto da toolchain ou do dialeto original (por exemplo, código no dialeto Delphi compilado com Free Pascal). O README explica o compromisso. |
| `not-verified` | ⚠️ | Escrito e documentado, mas não pode ser executado na máquina de desenvolvimento (por exemplo, iOS sem Xcode). O README informa onde foi ou pode ser verificado. |
| `documented` | 📄 | Somente README, sem `run.sh`, porque nada pode executá-lo (por exemplo, o pseudocódigo do CLRS, que não tem interpretador). O `verify-all.sh` o lista como ignorado. |

`documented` destina-se às pastas que não têm nenhum `run.sh`, como
`pseudocode/clrs`.

### Sintaxe: um subconjunto estrito de YAML
O `scripts/gen-readme.py` usa somente a biblioteca padrão do Python, de
modo que lê um subconjunto pequeno e estrito do
[YAML 1.2.2](https://yaml.org/spec/1.2.2/). Qualquer analisador de YAML lê
os mesmos arquivos da mesma forma. As regras:
- Indente com 2 espaços. Sem tabulações.
- Um comentário (`#`) fica em sua própria linha.
- Escreva toda string entre aspas duplas (`"..."`), com escapes de JSON
  (`\"`, `\\`). Números e `null` não levam aspas. Uma lista vazia é escrita
  `[]`.
- As chaves de nível superior contêm um valor (`key: "value"`) ou uma lista
  (`key:` seguida de linhas `  - `). Os itens de uma lista são valores
  (`  - "value"`) ou mapeamentos (`  - key: "value"`, depois
  `    key: "value"` para as demais chaves do item).
- Uma chave de nível superior pode conter, em vez disso, um mapeamento
  (`humor:` seguida de linhas `  key: "value"`). Uma chave desse mapeamento
  pode conter uma lista, escrita como acima, mas com mais dois espaços de
  recuo.

Qualquer outra forma (estilo de fluxo `[a, b]`, strings de várias linhas,
âncoras, qualquer outro aninhamento) faz o gerador terminar com o nome do
arquivo e o número da linha.
