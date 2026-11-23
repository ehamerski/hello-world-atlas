# Hello World in many programming languages

A teaching repository. It shows how each programming language writes the
Hello World program in the simplest and most direct way, as a command-line
program (**cli**), a **desktop** window, a **web** application (some with a
separate front end), and, for a few languages, a **mobile** app. It also
covers the history, milestones, market usage, and importance of each
language.

**Website:** every page of this repository is also a website. Build and
preview it locally with `scripts/build-site.sh --preview` (see
[how the website is built](site/README.md)).

## Quick start
Every implementation folder has the same scripts, and each one explains
what it does and why while it runs:
```sh
cd languages/<language>/<category>   # e.g. languages/python/cli
./install.sh                         # check the toolchain; asks before installing anything
./build.sh                           # compile (compiled languages only)
./run.sh                             # run it
```
Check every implementation at once with `scripts/verify-all.sh`, and every
relative link in the READMEs with `scripts/check-links.sh`.
Stop everything this repository left running (web servers, windows, a
verify run) with `scripts/stop-all.sh`, or `scripts/stop-all.sh java` for one
language (`--list` only shows them).

**Platforms:** verified on macOS Intel, the development machine (each
README's Platform notes give the date). The last CI run with GitHub Actions, on 2026-11-06,
verified 67 of them on Linux (Ubuntu) and 66 on Windows (Git Bash); the
implementations added after it are not verified in CI. macOS Apple Silicon
and WSL are documented in each README but marked **not verified**
([Platform support](docs/platform-support.md)).

## Languages
<!-- BEGIN GENERATED: language-table -->
<!-- Do not edit by hand: run python3 scripts/gen-readme.py (source: languages/*/meta.yml). -->
**101 implementations** in **47 languages**: 100 run with `scripts/verify-all.sh`, 1 documented only.

Status: ✅ verified · 🔶 compromise · ⚠️ not verified · 📄 documented · – not implemented (the language README explains why).

| Language | Year | Designers | Paradigm | cli | desktop | web | web + separate front end | mobile |
|---|---|---|---|---|---|---|---|---|
| [Ada](languages/ada/README.md) | 1983 | Jean D. Ichbiah | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/ada/cli/) | – | – | – | – |
| [ALGOL 68](languages/algol68/README.md) | 1968 | A. van Wijngaarden, B. J. Mailloux, J. E. L. Peck, C. H. A. Koster | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/algol68/cli/) | – | – | – | – |
| [Assembly (x86-64)](languages/assembly/README.md) | 1949 | David Wheeler | [imperative](docs/paradigms.md#imperative) / low-level | ✅ [cli](languages/assembly/cli/) | – | – | – | – |
| [Bash](languages/bash/README.md) | 1989 | Brian Fox | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/bash/cli/) | – | – | – | – |
| [BASIC](languages/basic/README.md) | 1964 | John Kemeny, Thomas Kurtz | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/basic/cli/) | – | – | – | – |
| [C (ANSI C)](languages/c/README.md) | 1972 | Dennis Ritchie | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/c/cli/) | ✅ [desktop](languages/c/desktop/) | ✅ [web](languages/c/web/) | – | – |
| [C#](languages/csharp/README.md) | 2000 | Anders Hejlsberg | [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/csharp/cli/) | ✅ [desktop](languages/csharp/desktop/) | ✅ [web](languages/csharp/web/) | ✅ [Angular](languages/csharp/web-angular/) | – |
| [C++](languages/cpp/README.md) | 1985 | Bjarne Stroustrup | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/cpp/cli/) | ✅ [desktop](languages/cpp/desktop/) | ✅ [web](languages/cpp/web/) | – | – |
| [Clipper](languages/clipper/README.md) | 1985 | Brian Russell, Barry ReBell | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/clipper/cli/) | – | – | – | – |
| [Clojure](languages/clojure/README.md) | 2007 | Rich Hickey | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/clojure/cli/) | ✅ [Swing](languages/clojure/desktop/) | ✅ [Ring](languages/clojure/web/) | – | – |
| [COBOL](languages/cobol/README.md) | 1959 | CODASYL | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/cobol/cli/) | – | – | – | – |
| [Common Lisp](languages/lisp/README.md) | 1958 | John McCarthy | multi-paradigm / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/lisp/cli/) | – | ✅ [web](languages/lisp/web/) | – | – |
| [Dart](languages/dart/README.md) | 2011 | Lars Bak | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/dart/cli/) | – | ✅ [web](languages/dart/web/) | – | ✅ [mobile-flutter](languages/dart/mobile-flutter/) |
| [dBASE](languages/dbase/README.md) | 1981 | Wayne Ratliff | [imperative](docs/paradigms.md#imperative) | 🔶 [cli](languages/dbase/cli/) | – | – | – | – |
| [Delphi (Object Pascal dialect)](languages/delphi/README.md) | 1995 | Anders Hejlsberg | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | 🔶 [cli](languages/delphi/cli/) | 🔶 [desktop](languages/delphi/desktop/) | – | – | – |
| [Eiffel](languages/eiffel/README.md) | 1986 | Bertrand Meyer, Jean-Marc Nerson | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/eiffel/cli/) | – | – | – | – |
| [Elixir](languages/elixir/README.md) | 2012 | José Valim | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/elixir/cli/) | – | ✅ [web](languages/elixir/web/) | – | – |
| [Erlang](languages/erlang/README.md) | 1986 | Joe Armstrong, Robert Virding, Mike Williams | [functional](docs/paradigms.md#functional) / concurrent | ✅ [cli](languages/erlang/cli/) | ✅ [desktop](languages/erlang/desktop/) | ✅ [web](languages/erlang/web/) | – | – |
| [F#](languages/fsharp/README.md) | 2002 | Don Syme | [functional](docs/paradigms.md#functional) / multi-paradigm | ✅ [cli](languages/fsharp/cli/) | – | – | – | – |
| [Fortran](languages/fortran/README.md) | 1957 | John Backus | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/fortran/cli/) | – | – | – | – |
| [Go](languages/go/README.md) | 2009 | Robert Griesemer, Rob Pike, Ken Thompson | [imperative](docs/paradigms.md#imperative) / concurrent | ✅ [cli](languages/go/cli/) | ✅ [desktop](languages/go/desktop/) | ✅ [web](languages/go/web/) | ✅ [Vue](languages/go/web-vue/) | – |
| [Haskell](languages/haskell/README.md) | 1990 | Haskell committee | [functional](docs/paradigms.md#functional) | ✅ [cli](languages/haskell/cli/) | – | ✅ [web](languages/haskell/web/) | – | – |
| [Java](languages/java/README.md) | 1995 | James Gosling | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/java/cli/) | ✅ [JavaFX](languages/java/desktop/) · ✅ [Swing](languages/java/desktop-swing/) | ✅ [web](languages/java/web/) | ✅ [React](languages/java/web-react/) | – |
| [Julia](languages/julia/README.md) | 2012 | Jeff Bezanson, Stefan Karpinski, Viral B. Shah, Alan Edelman | multi-paradigm / [imperative](docs/paradigms.md#imperative) / [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/julia/cli/) | – | – | – | – |
| [Kotlin](languages/kotlin/README.md) | 2011 | JetBrains | [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/kotlin/cli/) | ✅ [Compose](languages/kotlin/desktop/) | ✅ [Ktor](languages/kotlin/web/) | – | ✅ [Android](languages/kotlin/mobile-android/) |
| [Lua](languages/lua/README.md) | 1993 | Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes | multi-paradigm / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/lua/cli/) | 🔶 [desktop](languages/lua/desktop/) | ✅ [web](languages/lua/web/) | – | – |
| [Node.js (JavaScript)](languages/node/README.md) | 2009 | Ryan Dahl | multi-paradigm / event-driven | ✅ [cli](languages/node/cli/) | ✅ [desktop](languages/node/desktop/) | ✅ [web](languages/node/web/) | – | – |
| [Objective-C](languages/objectivec/README.md) | – | Brad Cox, Tom Love | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/objectivec/cli/) | ✅ [desktop](languages/objectivec/desktop/) | ✅ [web](languages/objectivec/web/) | – | – |
| [OCaml](languages/ocaml/README.md) | 1996 | Xavier Leroy, Damien Doligez, Jérôme Vouillon, Didier Rémy | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/ocaml/cli/) | – | – | – | – |
| [Pascal](languages/pascal/README.md) | 1970 | Niklaus Wirth | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/pascal/cli/) | ✅ [desktop](languages/pascal/desktop/) | – | – | – |
| [Perl](languages/perl/README.md) | 1987 | Larry Wall | multi-paradigm / [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/perl/cli/) | 🔶 [desktop](languages/perl/desktop/) | ✅ [web](languages/perl/web/) | – | – |
| [PHP](languages/php/README.md) | 1995 | Rasmus Lerdorf | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/php/cli/) | – | ✅ [web](languages/php/web/) | – | – |
| [Prolog](languages/prolog/README.md) | 1972 | Alain Colmerauer, Philippe Roussel | [logic](docs/paradigms.md#logic) | ✅ [cli](languages/prolog/cli/) | – | ✅ [web](languages/prolog/web/) | – | – |
| [Pseudocode](languages/pseudocode/README.md) | – | – | [imperative](docs/paradigms.md#imperative) / teaching | ✅ [Portugol](languages/pseudocode/portugol/) · ✅ [PSeInt](languages/pseudocode/pseint/) · 📄 [CLRS](languages/pseudocode/clrs/) | – | – | – | – |
| [Python](languages/python/README.md) | 1991 | Guido van Rossum | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/python/cli/) | ✅ [desktop](languages/python/desktop/) | ✅ [web](languages/python/web/) | – | – |
| [QCL (Quantum Computation Language)](languages/qcl/README.md) | 1998 | Bernhard Oemer | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/qcl/cli/) | – | – | – | – |
| [R](languages/r/README.md) | 1993 | Ross Ihaka, Robert Gentleman | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/r/cli/) | – | – | – | – |
| [Racket](languages/racket/README.md) | 1995 | PLT (the Racket project team) | [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) / language-oriented | ✅ [cli](languages/racket/cli/) | – | – | – | – |
| [Ruby](languages/ruby/README.md) | 1995 | Yukihiro Matsumoto | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/ruby/cli/) | ✅ [desktop](languages/ruby/desktop/) | ✅ [web](languages/ruby/web/) · ✅ [Rails](languages/ruby/web-rails/) | – | – |
| [Rust](languages/rust/README.md) | 2015 | Graydon Hoare | multi-paradigm / systems | ✅ [cli](languages/rust/cli/) | ✅ [desktop](languages/rust/desktop/) | ✅ [web](languages/rust/web/) | – | – |
| [Scala](languages/scala/README.md) | 2003 | Martin Odersky | multi-paradigm / [functional](docs/paradigms.md#functional) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/scala/cli/) | – | – | – | – |
| [Simula](languages/simula/README.md) | 1967 | Ole-Johan Dahl, Kristen Nygaard | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/simula/cli/) | – | – | – | – |
| [Smalltalk](languages/smalltalk/README.md) | 1972 | Adele Goldberg, Dan Ingalls, Ted Kaehler, Larry Tesler, Xerox PARC | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/smalltalk/cli/) | ✅ [desktop](languages/smalltalk/desktop/) | ✅ [web](languages/smalltalk/web/) | – | – |
| [Swift](languages/swift/README.md) | 2014 | Chris Lattner | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/swift/cli/) | ✅ [desktop](languages/swift/desktop/) | ✅ [web](languages/swift/web/) | – | ✅ [mobile-ios](languages/swift/mobile-ios/) |
| [TypeScript](languages/typescript/README.md) | 2012 | Anders Hejlsberg | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/typescript/cli/) | – | ✅ [web](languages/typescript/web/) | – | – |
| [Visual Basic (VB.NET)](languages/visual-basic/README.md) | 2002 | Microsoft | [object-oriented](docs/paradigms.md#object-oriented) / [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/visual-basic/cli/) | – | ✅ [web](languages/visual-basic/web/) | – | – |
| [Zig](languages/zig/README.md) | 2016 | Andrew Kelley | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/zig/cli/) | – | – | – | – |
<!-- END GENERATED: language-table -->

Every folder with its toolchain and walkthrough is listed in
[All implementations](languages/README.md#all-implementations). The table
above is generated from each language's `meta.yml`
([schema](languages/README.md#metayml-schema)).

## Going further
- [Paradigms](docs/paradigms.md): the four core paradigms
  (imperative, object-oriented, functional, logic), plus concurrency and
  quantum, what each one means,
  and which languages represent them
- [Comparisons](docs/comparisons.md): the implementations side by
  side: every cli Hello World, build models, web servers, desktop
  toolkits, and a guided reading path
- [AI and a new paradigm](docs/ai-new-paradigm.md): will AI give birth
  to a new programming paradigm? The essay argues yes (intent-oriented
  programming), explains how it would work, and gives the counter-arguments
- [Platform support](docs/platform-support.md): where the
  programs are verified, and how
- [Contributing](CONTRIBUTING.md): conventions and how to contribute

## Sources
Each language and implementation README has its own **Sources** section,
following the rules in [About the sources](docs/sources.md).

## License
Two licenses cover the project's own work, copyright (c) 2026 Eduardo
Hamerski:
- **Code** (source files, scripts, configuration, and the code blocks in
  the documents) is released under the **MIT License**, in the
  [LICENSE file](LICENSE).
- **Prose and images** (the text of the Markdown documents and of the
  website made from them, the screenshots, and the site icon) are released
  under the
  **[Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**,
  in the [LICENSE-docs file](LICENSE-docs).

A few files come from other projects and keep their own licenses: the
Gradle Wrapper and the Flutter template files in
`languages/dart/mobile-flutter/`, and the fonts the website bundles.
The [NOTICE file](NOTICE) lists them.

To cite this repository, use its [citation file](CITATION.cff) (GitHub
shows it as "Cite this repository").
