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
| 2 | ✅ [assembly/cli](assembly/cli/) | Assembly (x86-64) | cli | NASM + `cc` (macOS x86-64) | yes | prints `Hello, World!` | [read](assembly/cli/README.md#step-by-step-walkthrough) |
| 3 | ✅ [basic/cli](basic/cli/) | BASIC | cli | QB64 Phoenix Edition | yes | prints `Hello, World!` | [read](basic/cli/README.md#step-by-step-walkthrough) |
| 4 | ✅ [c/cli](c/cli/) | C (ANSI C) | cli | system C compiler, `-std=c89` | yes | prints `Hello, World!` | [read](c/cli/README.md#step-by-step-walkthrough) |
| 5 | ✅ [c/desktop](c/desktop/) | C (ANSI C) | desktop | GTK 4, `-std=c99` | yes | window | [read](c/desktop/README.md#step-by-step-walkthrough) |
| 6 | ✅ [c/web](c/web/) | C (ANSI C) | web | GNU libmicrohttpd, `-std=c99` | yes | http://localhost:8080/ | [read](c/web/README.md#step-by-step-walkthrough) |
| 7 | ✅ [csharp/cli](csharp/cli/) | C# | cli | .NET 10 SDK | yes | prints `Hello, World!` | [read](csharp/cli/README.md#step-by-step-walkthrough) |
| 8 | ✅ [csharp/desktop](csharp/desktop/) | C# | desktop | Avalonia | yes | window | [read](csharp/desktop/README.md#step-by-step-walkthrough) |
| 9 | ✅ [csharp/web](csharp/web/) | C# | web | ASP.NET Core | yes | http://localhost:8080/ | [read](csharp/web/README.md#step-by-step-walkthrough) |
| 10 | ✅ [csharp/web-angular](csharp/web-angular/) | C# | web + Angular | ASP.NET Core API + Angular | yes | http://localhost:4200/ (API :8080) | [read](csharp/web-angular/README.md#step-by-step-walkthrough) |
| 11 | ✅ [cpp/cli](cpp/cli/) | C++ | cli | CMake, C++20 | yes | prints `Hello, World!` | [read](cpp/cli/README.md#step-by-step-walkthrough) |
| 12 | ✅ [cpp/desktop](cpp/desktop/) | C++ | desktop | Qt 6 Widgets, CMake | yes | window | [read](cpp/desktop/README.md#step-by-step-walkthrough) |
| 13 | ✅ [cpp/web](cpp/web/) | C++ | web | cpp-httplib, CMake | yes | http://localhost:8080/ | [read](cpp/web/README.md#step-by-step-walkthrough) |
| 14 | ✅ [clipper/cli](clipper/cli/) | Clipper | cli | Harbour | yes | prints `Hello, World!` | [read](clipper/cli/README.md#step-by-step-walkthrough) |
| 15 | ✅ [cobol/cli](cobol/cli/) | COBOL | cli | GnuCOBOL | yes | prints `Hello, World!` | [read](cobol/cli/README.md#step-by-step-walkthrough) |
| 16 | ✅ [lisp/cli](lisp/cli/) | Common Lisp | cli | SBCL | yes | prints `Hello, World!` | [read](lisp/cli/README.md#step-by-step-walkthrough) |
| 17 | ✅ [lisp/web](lisp/web/) | Common Lisp | web | Hunchentoot (Quicklisp), SBCL | yes | http://localhost:8080/ | [read](lisp/web/README.md#step-by-step-walkthrough) |
| 18 | ✅ [fortran/cli](fortran/cli/) | Fortran | cli | gfortran | yes | prints `Hello, World!` | [read](fortran/cli/README.md#step-by-step-walkthrough) |
| 19 | ✅ [go/cli](go/cli/) | Go | cli | Go toolchain | yes | prints `Hello, World!` | [read](go/cli/README.md#step-by-step-walkthrough) |
| 20 | ✅ [go/desktop](go/desktop/) | Go | desktop | Fyne | yes | window | [read](go/desktop/README.md#step-by-step-walkthrough) |
| 21 | ✅ [go/web](go/web/) | Go | web | `net/http` + `html/template` (standard library) | yes | http://localhost:8080/ | [read](go/web/README.md#step-by-step-walkthrough) |
| 22 | ✅ [go/web-vue](go/web-vue/) | Go | web + Vue | Go API + Vue (Vite) | yes | http://localhost:4173/ (API :8080) | [read](go/web-vue/README.md#step-by-step-walkthrough) |
| 23 | ✅ [haskell/cli](haskell/cli/) | Haskell | cli | GHC (via GHCup) | yes | prints `Hello, World!` | [read](haskell/cli/README.md#step-by-step-walkthrough) |
| 24 | ✅ [haskell/web](haskell/web/) | Haskell | web | Scotty, Cabal | yes | http://localhost:8080/ | [read](haskell/web/README.md#step-by-step-walkthrough) |
| 25 | ✅ [java/cli](java/cli/) | Java | cli | JDK 21, Maven | yes | prints `Hello, World!` | [read](java/cli/README.md#step-by-step-walkthrough) |
| 26 | ✅ [java/desktop](java/desktop/) | Java | desktop (JavaFX) | JavaFX, Maven | yes | window | [read](java/desktop/README.md#step-by-step-walkthrough) |
| 27 | ✅ [java/desktop-swing](java/desktop-swing/) | Java | desktop (Swing) | Swing (JDK), Maven | yes | window | [read](java/desktop-swing/README.md#step-by-step-walkthrough) |
| 28 | ✅ [java/web](java/web/) | Java | web | Spring Boot, Maven | yes | http://localhost:8080/ | [read](java/web/README.md#step-by-step-walkthrough) |
| 29 | ✅ [java/web-react](java/web-react/) | Java | web + React | Spring Boot API + React (Vite) | yes | http://localhost:4173/ (API :8080) | [read](java/web-react/README.md#step-by-step-walkthrough) |
| 30 | ✅ [node/cli](node/cli/) | Node.js (JavaScript) | cli | Node.js | no | prints `Hello, World!` | [read](node/cli/README.md#step-by-step-walkthrough) |
| 31 | ✅ [node/desktop](node/desktop/) | Node.js (JavaScript) | desktop | Electron | no | window | [read](node/desktop/README.md#step-by-step-walkthrough) |
| 32 | ✅ [node/web](node/web/) | Node.js (JavaScript) | web | Express | no | http://localhost:8080/ | [read](node/web/README.md#step-by-step-walkthrough) |
| 33 | ✅ [pascal/cli](pascal/cli/) | Pascal | cli | Free Pascal (ISO 7185 mode) | yes | prints `Hello, World!` | [read](pascal/cli/README.md#step-by-step-walkthrough) |
| 34 | ✅ [pascal/desktop](pascal/desktop/) | Pascal | desktop | Lazarus LCL (`lazbuild`) | yes | window | [read](pascal/desktop/README.md#step-by-step-walkthrough) |
| 35 | ✅ [php/cli](php/cli/) | PHP | cli | `php` CLI | no | prints `Hello, World!` | [read](php/cli/README.md#step-by-step-walkthrough) |
| 36 | ✅ [php/web](php/web/) | PHP | web | PHP built-in server (`php -S`) | no | http://localhost:8080/ | [read](php/web/README.md#step-by-step-walkthrough) |
| 37 | ✅ [prolog/cli](prolog/cli/) | Prolog | cli | SWI-Prolog | no | prints `Hello, World!` | [read](prolog/cli/README.md#step-by-step-walkthrough) |
| 38 | ✅ [prolog/web](prolog/web/) | Prolog | web | SWI-Prolog HTTP libraries | no | http://localhost:8080/ | [read](prolog/web/README.md#step-by-step-walkthrough) |
| 39 | ✅ [pseudocode/portugol](pseudocode/portugol/) | Pseudocode (Portugol) | cli | Delégua interpreter (VisuAlg dialect), via npm | no | prints `Hello, World!` | [read](pseudocode/portugol/README.md#step-by-step-walkthrough) |
| 40 | ✅ [pseudocode/pseint](pseudocode/pseint/) | Pseudocode (PSeInt) | cli | PSeInt | no | prints `Hello, World!` | [read](pseudocode/pseint/README.md#step-by-step-walkthrough) |
| 41 | 📄 [pseudocode/clrs](pseudocode/clrs/) | Pseudocode (CLRS) | cli | none: documented only | – | – (no interpreter) | [read](pseudocode/clrs/README.md#step-by-step-walkthrough) |
| 42 | ✅ [python/cli](python/cli/) | Python | cli | CPython | no | prints `Hello, World!` | [read](python/cli/README.md#step-by-step-walkthrough) |
| 43 | ✅ [python/desktop](python/desktop/) | Python | desktop | tkinter (standard library) | no | window | [read](python/desktop/README.md#step-by-step-walkthrough) |
| 44 | ✅ [python/web](python/web/) | Python | web | Flask | no | http://localhost:8080/ | [read](python/web/README.md#step-by-step-walkthrough) |
| 45 | ✅ [rust/cli](rust/cli/) | Rust | cli | Cargo | yes | prints `Hello, World!` | [read](rust/cli/README.md#step-by-step-walkthrough) |
| 46 | ✅ [rust/desktop](rust/desktop/) | Rust | desktop | eframe / egui | yes | window | [read](rust/desktop/README.md#step-by-step-walkthrough) |
| 47 | ✅ [rust/web](rust/web/) | Rust | web | Axum | yes | http://localhost:8080/ | [read](rust/web/README.md#step-by-step-walkthrough) |
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
