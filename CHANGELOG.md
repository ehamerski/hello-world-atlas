# Changelog

Every notable change to this repository is listed here, newest first.
The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/),
and releases follow [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).
What counts as the public interface for a version number is described in
[CONTRIBUTING.md](CONTRIBUTING.md#versions-and-the-public-interface).

## [Unreleased]

## [2.0.0] - 2026-11-22

This is a major version. Implementations moved to new folders, so
links and scripts that use the old paths need updating (see **Changed**).
The new languages arrived in two sets, listed in the order they were added.

### Added
- **Finding languages on the website.** The Languages page has a search
  box that also finds other names a cited source uses (for example
  "golang" or "PLT Scheme"), a sort order (name, first released, most
  implementations), filters where several values can be ticked, with a
  count for each value, a table view, and a link that keeps the search,
  filters, sort order and view. The new optional `other_names` key in
  `meta.yml` holds the other names.
- **Second set of languages (17).** Ruby, Perl, Lua, Kotlin, Clojure,
  Erlang, Elixir, Swift, Objective-C, Dart, Smalltalk, Eiffel, Simula,
  Delphi, Visual Basic, dBASE and QCL, each with a language overview, its
  facts and sources, and a cli, desktop or web implementation where the
  language has one. Ruby also has a Rails web app.
- **Mobile apps.** A native Android app in Kotlin
  (`languages/kotlin/mobile-android`), a native iOS app in Swift
  (`languages/swift/mobile-ios`) and a Flutter app in Dart
  (`languages/dart/mobile-flutter`), each with a `run.sh --verify` that
  starts an emulator or simulator and checks the text on screen.
- **Third set of languages (10).** TypeScript, Scala, F#, OCaml, Julia, R,
  Zig, Bash, Racket and ALGOL 68. The repository now holds 47 languages and
  101 implementations.
- **Website.** Every README and `meta.yml` is turned into a static website
  (`scripts/build-site.sh`), with a page per language and per
  implementation, a language comparison, a timeline, a family tree of
  languages, measured run times and line counts, and the essay "Off the
  record".
- **Brazilian Portuguese translation** (partial) of the pages under
  `i18n/pt-BR/`, with `scripts/check-translations.sh` to show which pages
  are current. The home page, the reader pages and part of the language
  pages are translated; the other language pages are shown in English with
  a notice, and the *Languages* page says how many they are.
- **Downloads.** One ZIP per implementation, holding its scripts and the
  shared helpers they need (`scripts/package-downloads.sh`,
  `scripts/check-downloads.sh`), with a `SHA256SUMS` file.
- **Checks.** `scripts/check-language.sh` (one language is complete),
  `scripts/check-prose.sh` (Vale style rules), `scripts/check-sources.sh`
  (every cited URL answers), `scripts/gen-readme.py` (the language tables
  are generated from `meta.yml`) and `scripts/check-product.sh`.
- **Approved list.** `languages/APPROVED.txt` lists every language and its
  category folders. `scripts/check-language.sh`, `scripts/gen-readme.py`,
  `scripts/build-site.sh`, `scripts/package-downloads.sh` and
  `scripts/export-public.sh` fail when a listed language or folder is
  missing, or a folder is not listed (`scripts/approved.py`).
- **Continuous integration** on Linux and Windows (Git Bash), with a
  per-system skip list in `ci/skip.yml` and per-folder timeouts in
  `ci/timeouts.yml`.
- `scripts/stop-all.sh` stops every web server, window or verify run that
  the repository left running.
- `LICENSE` (MIT, for code), `LICENSE-docs` (CC BY 4.0, for prose and
  images), `CITATION.cff` and this changelog. Each license is in its own
  file, so GitHub can recognize both.
- `NOTICE` lists the files that come from other projects and their
  licenses: the Gradle Wrapper and the Flutter template files of the Dart
  mobile app, and the website fonts. Every download ZIP includes it.

### Changed
- **Folder layout.** Every language moved from the top level to
  `languages/<language>/`, so an implementation is now at
  `languages/<language>/<category>/` (for example `python/cli` is now
  `languages/python/cli`). Scripts in an implementation now source
  `../../../scripts/common.sh`.
- `scripts/verify-all.sh` gives each implementation its own port and
  cleans up after it, so one failed run no longer breaks the next.
- The pages about sources, paradigms and comparisons were rewritten for
  readers, and `docs/start-here.md` now lists the toolchains for each
  system, including the Android SDK and Xcode.
- Library updates: Puma 8.1.1 in the Ruby web apps, Logback 1.6.7 in the
  Kotlin web app, Avalonia 12.1.6 in the C# desktop app, the Maven
  Compiler Plugin 3.16.0 in the Java cli and desktop apps, and Gradle
  9.9.1, the Android Gradle Plugin 9.5.1 and Kotlin 2.4.21 in the Flutter
  app's Android build. JavaFX stays on 21.0.13: newer versions need a
  newer JDK than 21.
- **Platform claims.** "Verified in CI" now carries the date of the last
  passing CI run, 2026-11-06, and covers only the implementations in that
  run (67 on Linux, 66 on Windows). Newer implementations are marked not
  verified in CI; their macOS result is in each README's Platform notes.
- `CONTRIBUTING.md` points to the generated table in `languages/README.md`
  for the current languages and categories, and its layout lists every
  published folder and script. The README and `CITATION.cff` mention the
  mobile apps, and the paradigms page is described as the four core
  paradigms plus concurrency and quantum.
- `scripts/check-language.sh` also fails when a web, desktop or mobile
  folder has no screenshot and does not say why. The Dart, Objective-C,
  Smalltalk and Swift web and desktop folders now have one.
- The site records the Node.js version it is built with in `site/.nvmrc`
  (26), and the workflows read it from there.
- **Website home and navigation.** The website has its own home page
  (`docs/home.md`): what the site is, three ways in (Start here, Languages,
  Compare), how the examples work and the licenses. The repository README
  stays the front page on GitHub, and its links now say where they go
  instead of showing file paths. Every page has Languages, Compare and
  About links in its header, and a short site title on narrow screens.
  Language and implementation pages show a breadcrumb (Languages > Python
  > cli) in place of the "Part of" line, and each language page opens with
  one sentence that gives its year and designers.
- **Smaller page fixes.** On the Languages page a ticked filter value no
  longer shows a count. The Measured facts page opens with what the numbers
  are and their date. Links built by the Languages, Compare, Measured facts
  and Genealogy pages use the site's link color. The menu says "Languages
  (search and filter)" and "Comparisons", and lists "Off the record". The
  Genealogy diagram says that it scrolls sideways, and a keyboard can
  scroll it. Long paragraphs on the About and Paradigms pages and in the
  Zig program's comments are split.
- `scripts/build-site.sh` runs the unit tests of the Languages page
  (`npm test` in `site/`).

### Removed
- The top-level language folders (`ada/`, `c/`, `python/` and the others);
  they live under `languages/` now.
- `docs/source-policy.md`; its rules are in `docs/sources.md`.
- The specification and validation report from `docs/`; they were notes on
  how the repository is maintained, not reading for students.

### Fixed
- Two source links that no longer answered, in the Java and pseudocode
  pages, now point to archived copies.
- Sources on www.gnu.org (Bash, C web, Simula and Smalltalk pages) now
  also give an archived copy, for when that site does not answer.
- **Swift.** The web server now listens on `PORT` (`PORT=9000 ./run.sh`),
  and `run.sh --verify` stops it even when the check fails. The desktop
  window stays open until you quit the app. All Swift scripts follow the
  same shape as the other implementations, and the comments now explain
  `print`, `libswiftCore.dylib` and `-parse-as-library` correctly.
- **Swift language page.** The milestone table follows the release
  headings of the Swift CHANGELOG and runs up to Swift 6.4; every fact has
  a numbered source, claims without a source are gone, and Market usage
  gives dated Stack Overflow and TIOBE figures. The influences on the
  Genealogy page quote Chris Lattner's home page. The web walkthrough
  matches `main.swift`, and Swift links point to their final addresses.
- **Objective-C language page.** Grand Central Dispatch and blocks now date
  from Mac OS X v10.6 Snow Leopard (2009), and Apple's acquisition of NeXT
  from 1997. Every row of the milestone table has a numbered source (the
  HOPL IV paper, Apple press releases and Apple's archived documentation),
  and rows without a source are gone. No source gives one founding year,
  so the tables no longer say 1984; the timeline notes that the language
  began at ITT in the early 1980s.
- **Website.** A local build links source files to the public repository
  (`hello-world-atlas`, branch `main`) when `REPO_URL` is not set. Code
  blocks in BASIC, Fortran, NASM and Eiffel no longer cause build
  warnings, and the not-found page has its own text.
- **Dart.** `run.sh` in the web app starts the server again without
  `--verify` (it stopped with `exec: PORT=8080: not found`). The Flutter
  app's Platform notes say that its iOS side is not built or run.
- **Dart language page.** Null safety is dated 2021 (Dart 2.12), Market
  usage gives TIOBE and PYPL figures for November 2026, the paradigm is
  cited to the Dart documentation, and Flutter dates without a source are
  gone. The cli and web pages name the tested SDK version with its date,
  no longer recommend an archived framework, and Dart and Flutter links
  point to their final addresses.
- **dBASE language page.** The page is now named dBASE, dated 1981 (the
  introduction of dBASE II) and credits Wayne Ratliff, who wrote it as
  Vulcan before Ashton-Tate sold it as dBASE II. Dates come from
  Ashton-Tate's own documents in the Computer History Museum and from
  J.-P. Martel's history of dBASE, the milestones run to dBASE for
  Windows 5.0 (1994), and each source says what it is cited for. The
  DOSBox source has an archived copy.
- **Visual Basic, Delphi, QCL and other pages.** Visual Basic and Delphi
  now give dated usage figures from the TIOBE Index (November 2026) and the
  2026 Stack Overflow Developer Survey. The Delphi pages state in one
  sentence that the examples use the Delphi dialect compiled by Free Pascal.
  QCL lists the 0.6.7 release (22 December 2022) from its author's page.
  Simula, QCL and Eiffel say plainly that no current usage survey lists
  them; Julia and Bash explain their missing categories by what the
  language ships with; spelling on the Delphi and Flutter pages is US
  English.
- **Objective-C.** The desktop window's text is readable in dark mode.
- **Smalltalk.** The desktop window shows the text below its title bar,
  not on top of it.
- **Implementations tables.** The table on each language page now shows
  the toolchain and status from the language's `meta.yml`, the same as the
  generated tables. The Dart mobile app and the Smalltalk desktop and web
  apps show verified, and the Objective-C page has the table it lacked.
  `scripts/check-language.sh` now fails when a table differs from
  `meta.yml`.
- **Visual Basic language page.** The history starts with Visual Basic 1.0
  (1991) and ends with Visual Basic 17.13 and Microsoft's plan not to evolve
  the language, all from Microsoft sources. Support for the Visual Basic 6.0
  IDE ended on 2008-04-08, and the VB6 runtime is still supported on
  Windows. The Wikipedia and O'Reilly sources are gone.
- **Delphi language page.** The 1995 launch and Anders Hejlsberg's role
  come from Embarcadero and Microsoft, and the page names the current
  Delphi 13.2, its platforms and the free Community Edition. On Windows,
  the cli `install.sh` now links to the Free Pascal download, as the
  desktop one does.
- **Simula, QCL, Racket, R, Julia, Eiffel and ALGOL 68 pages.** Simula
  dates Nygaard's start to around 1960/61 and Dahl joining in January 1962,
  and links archived copies of the two ACM sources. The QCL history comes
  from the author's page and theses, with releases up to 0.6.7, and its
  cli `install.sh` finds GNU readline with Homebrew on any Mac and the
  system readline on Linux. Racket credits its quote to the Racket Guide
  and dates Racket 8.0 to 2021. The R page explains that `tcltk` is part of
  R and needs Tcl/Tk. Julia uses 1.13.4. The Eiffel page says why Gobo
  26.03 is used and that this build does not check contracts at run time.
  The ALGOL 68 page explains collateral elaboration and the parallel clause.
- **Current figures and versions.** Market usage on the OCaml, Zig,
  Racket, F#, Scala, Bash, Lua, R and Julia pages comes from the 2026 Stack
  Overflow survey, and the Smalltalk page from the TIOBE Index for November
  2026. The AI page dates its 2025 survey figures. The Zig history covers
  the releases up to 0.16.0. Scala uses 3.10.1, and the .NET folders use
  SDK 10.0.404; the F# page explains that .NET 10 is the long-term support
  release and .NET 11 a standard-term one. TypeScript is listed as
  multi-paradigm and object-oriented, with optional static types.
- The Objective-C and Smalltalk desktop apps open their window in
  `run.sh --verify` too, print `Hello, World!` and close after about
  2 seconds, like the other desktop apps.
- ShellCheck reports no errors or warnings on any script.
- **Kotlin language page.** The page no longer says that there is no
  Android app; the Android app is in `mobile-android/`, listed in the
  implementations table.

### Security
- The Gradle Wrapper in the Flutter app is the official Gradle 9.9.1 JAR
  (its checksum matches the one Gradle publishes), and the Gradle download
  is now checked against its published checksum.
- `SECURITY.md` says how to report a vulnerability privately through
  GitHub. Dependabot watches the website, the workflows and the
  implementations' lockfiles; workflow actions are pinned to commit
  hashes, and only the release workflow starts on a tag. Plug is updated
  to 1.20.4 in the Elixir web app.
- Updated dependencies with known advisories: `golang.org/x/image` 0.43.0
  for the Go desktop app, and fewer Rust desktop crates (no AccessKit or
  Wayland features). The Haskell web app pins `http2` 5.4.14; its README
  explains the one advisory in `base` that has no fix.
- No install script pipes a download into a shell any more. The Smalltalk
  scripts download the Pharo image and VM only after asking, and check
  their SHA-256 digests; the C# scripts check the digest of
  `dotnet-install.sh`. The rustup, GHCup and Dart installers are saved to a
  file you can read before they run, and library downloads in `install.sh`
  (`clojure -P`, `mix deps.get`, `dotnet restore`) ask first.
- `golang.org/x/net` 0.55.0 in the Go desktop app fixes
  GHSA-qxp5-gwg8-xv66, GHSA-vvgc-356p-c3xw and GHSA-5cv4-jp36-h3mw. The
  website packages are updated (Astro 7.4.12, Starlight 0.43.1), and
  `npm audit --omit=dev` reports no known vulnerability in the website or
  in any implementation's `package-lock.json`.
- The `url` crate in the Rust desktop app is updated to 2.5.9, which fixes
  RUSTSEC-2026-0592 (a stack overflow in `Url::origin()` on nested `blob:`
  URLs).

## [1.0.0] - 2026-11-02

First stable release, with the same content as 1.0.0-rc.2.

## [1.0.0-rc.2] - 2026-11-02

### Added
- A validation report of the release candidate, linked from the README.

## [1.0.0-rc.1] - 2026-11-02

First release candidate.

### Added
- Hello World in 20 languages: pseudocode (Portugol, PSeInt and the
  textbook style of CLRS), C, C++, Java, C#, Go, Python, Node.js, Rust,
  PHP, Haskell, Lisp, Prolog, Pascal, COBOL, Clipper, BASIC, Fortran, Ada
  and assembly, in 47 implementations across cli, desktop and web, with
  React, Vue and Angular front ends and a Java Swing window.
- An `install.sh`, `build.sh` (compiled languages) and `run.sh` in every
  implementation, each explaining its steps, and `run.sh --verify` for an
  automatic check.
- A README for every language with its history, milestones, market usage
  and cited sources, and pages about paradigms and comparisons.
- `scripts/verify-all.sh` to check every implementation and
  `scripts/check-links.sh` to check every relative link.
