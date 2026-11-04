# Hello World in many programming languages

A teaching repository. It shows how each programming language writes the
Hello World program in the simplest and most direct way, as a command-line
program (**cli**), a **desktop** window, and a **web** application. It also
covers the history, milestones, market usage, and importance of each
language.

**Website:** every page of this repository is also a website. Build and
preview it locally with `scripts/build-site.sh --preview` (see
[site/README.md](site/README.md)).

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

**Platforms:** verified on macOS Intel (the development machine). macOS Apple
Silicon, Linux and Windows (Git Bash or WSL) are documented in each README
but marked **not verified**.

## Languages
<!-- BEGIN GENERATED: language-table -->
<!-- Do not edit by hand: run python3 scripts/gen-readme.py (source: languages/*/meta.yml). -->
**47 implementations** in **20 languages**: 46 run with `scripts/verify-all.sh`, 1 documented only.

Status: ✅ verified · 🔶 compromise · ⚠️ not verified · 📄 documented · – not implemented (the language README explains why).

| Language | Year | Designers | Paradigm | cli | desktop | web | web + separate front end |
|---|---|---|---|---|---|---|---|
| [Ada](languages/ada/README.md) | 1983 | Jean D. Ichbiah | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/ada/cli/) | – | – | – |
| [Assembly (x86-64)](languages/assembly/README.md) | 1949 | David Wheeler | [imperative](docs/paradigms.md#imperative) / low-level | ✅ [cli](languages/assembly/cli/) | – | – | – |
| [BASIC](languages/basic/README.md) | 1964 | John Kemeny, Thomas Kurtz | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/basic/cli/) | – | – | – |
| [C (ANSI C)](languages/c/README.md) | 1972 | Dennis Ritchie | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/c/cli/) | ✅ [desktop](languages/c/desktop/) | ✅ [web](languages/c/web/) | – |
| [C#](languages/csharp/README.md) | 2000 | Anders Hejlsberg | [object-oriented](docs/paradigms.md#object-oriented) / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/csharp/cli/) | ✅ [desktop](languages/csharp/desktop/) | ✅ [web](languages/csharp/web/) | ✅ [Angular](languages/csharp/web-angular/) |
| [C++](languages/cpp/README.md) | 1985 | Bjarne Stroustrup | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/cpp/cli/) | ✅ [desktop](languages/cpp/desktop/) | ✅ [web](languages/cpp/web/) | – |
| [Clipper](languages/clipper/README.md) | 1985 | Brian Russell, Barry ReBell | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/clipper/cli/) | – | – | – |
| [COBOL](languages/cobol/README.md) | 1959 | CODASYL | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/cobol/cli/) | – | – | – |
| [Common Lisp](languages/lisp/README.md) | 1958 | John McCarthy | multi-paradigm / [functional](docs/paradigms.md#functional) | ✅ [cli](languages/lisp/cli/) | – | ✅ [web](languages/lisp/web/) | – |
| [Fortran](languages/fortran/README.md) | 1957 | John Backus | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/fortran/cli/) | – | – | – |
| [Go](languages/go/README.md) | 2009 | Robert Griesemer, Rob Pike, Ken Thompson | [imperative](docs/paradigms.md#imperative) / concurrent | ✅ [cli](languages/go/cli/) | ✅ [desktop](languages/go/desktop/) | ✅ [web](languages/go/web/) | ✅ [Vue](languages/go/web-vue/) |
| [Haskell](languages/haskell/README.md) | 1990 | Haskell committee | [functional](docs/paradigms.md#functional) | ✅ [cli](languages/haskell/cli/) | – | ✅ [web](languages/haskell/web/) | – |
| [Java](languages/java/README.md) | 1995 | James Gosling | [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/java/cli/) | ✅ [JavaFX](languages/java/desktop/) · ✅ [Swing](languages/java/desktop-swing/) | ✅ [web](languages/java/web/) | ✅ [React](languages/java/web-react/) |
| [Node.js (JavaScript)](languages/node/README.md) | 2009 | Ryan Dahl | multi-paradigm / event-driven | ✅ [cli](languages/node/cli/) | ✅ [desktop](languages/node/desktop/) | ✅ [web](languages/node/web/) | – |
| [Pascal](languages/pascal/README.md) | 1970 | Niklaus Wirth | [imperative](docs/paradigms.md#imperative) | ✅ [cli](languages/pascal/cli/) | ✅ [desktop](languages/pascal/desktop/) | – | – |
| [PHP](languages/php/README.md) | 1995 | Rasmus Lerdorf | [imperative](docs/paradigms.md#imperative) / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/php/cli/) | – | ✅ [web](languages/php/web/) | – |
| [Prolog](languages/prolog/README.md) | 1972 | Alain Colmerauer, Philippe Roussel | [logic](docs/paradigms.md#logic) | ✅ [cli](languages/prolog/cli/) | – | ✅ [web](languages/prolog/web/) | – |
| [Pseudocode](languages/pseudocode/README.md) | – | – | [imperative](docs/paradigms.md#imperative) / teaching | ✅ [Portugol](languages/pseudocode/portugol/) · ✅ [PSeInt](languages/pseudocode/pseint/) · 📄 [CLRS](languages/pseudocode/clrs/) | – | – | – |
| [Python](languages/python/README.md) | 1991 | Guido van Rossum | multi-paradigm / [object-oriented](docs/paradigms.md#object-oriented) | ✅ [cli](languages/python/cli/) | ✅ [desktop](languages/python/desktop/) | ✅ [web](languages/python/web/) | – |
| [Rust](languages/rust/README.md) | 2015 | Graydon Hoare | multi-paradigm / systems | ✅ [cli](languages/rust/cli/) | ✅ [desktop](languages/rust/desktop/) | ✅ [web](languages/rust/web/) | – |
<!-- END GENERATED: language-table -->

Every folder with its toolchain and walkthrough is listed in
[languages/README.md](languages/README.md#all-implementations). The table
above is generated from each language's `meta.yml`
([schema](languages/README.md#metayml-schema)).

## Going further
- [docs/paradigms.md](docs/paradigms.md): the four paradigms
  (imperative, object-oriented, functional, logic), what each one means,
  and which languages represent them
- [docs/comparisons.md](docs/comparisons.md): the implementations side by
  side: every cli Hello World, build models, web servers, desktop
  toolkits, and a guided reading path
- [docs/ai-new-paradigm.md](docs/ai-new-paradigm.md): will AI give birth
  to a new programming paradigm? The essay argues yes (intent-oriented
  programming), explains how it would work, and gives the counter-arguments
- [docs/platform-support.md](docs/platform-support.md): where the
  programs are verified, and how
- Conventions and how to contribute: [CONTRIBUTING.md](CONTRIBUTING.md)

## Sources
Each language and implementation README has its own **Sources** section,
following the rules in [docs/sources.md](docs/sources.md).

## License
Copyright (c) 2026 Eduardo Hamerski. See [LICENSE](LICENSE):
- **Code** (source files, scripts, configuration, and the code blocks in
  the documents) is released under the **MIT License**.
- **Prose** (the text of the Markdown documents and of the website made
  from them) is released under the
  **[Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)**.

To cite this repository, use [CITATION.cff](CITATION.cff) (GitHub shows it
as "Cite this repository").
