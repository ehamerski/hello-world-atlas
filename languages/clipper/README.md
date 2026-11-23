# Clipper

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural), dynamically typed. A Clipper program
is a set of procedures and functions that run statements in order. The
language "is a superset of dBASE III+, and also shares some features with
C/C++ and Smalltalk"; it is "a general-purpose, high-level programming
language well suited to corporate and commercial applications
development" [1]. It belongs to the **xBase** family, the languages that
grew out of dBASE. Clipper 5 added local variables and code blocks [3],
but the Hello World here is plain procedural code.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

The Hello World is compiled with **Harbour**, Clipper's free,
open-source successor ("100% compatible with Clipper compilers" [2]).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Harbour | ✅ |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
Clipper started as a **compiler for dBASE**, the database language of
Ashton-Tate on MS-DOS PCs. A history page by Clipper
developer Greg Holmes tells a story that, in the words of "insiders", "is not
far from the truth": an Ashton-Tate employee, Brian Russell, and a
consultant, Barry ReBell, were "expressing their annoyance at the fact that
Ashton-Tate had not created a compiler for the dBase language", and
founded Nantucket to build one [3]. "There were four "seasonally" named
versions of the compiler: Winter 85, Spring 86, Autumn 86, Summer 87",
which "clearly billed themselves as dBase compilers" [3].

**Clipper 5** changed that: "No longer billed as a dBase compiler, Clipper
became an "Application Development System"", with concepts "borrowed from
C and other languages" such as the `++` operator [3].

In May 1992 Nantucket's founder "sold Nantucket to Computer Associates
International Inc" [4], and the product became **CA-Clipper**. By March
1998 the Clipper FAQ reported that it had "definitely stopped evolving;
CA has announced that 5.3 will be the last significant release and only
maintenance patches will be forthcoming", with 5.3b current [1].

Other compilers kept the language going. The 1998 FAQ already counted
"FlagShip, xBase++, x2c, FORCE, and Visual Objects" as "Clipper clones,
improvements, and adaptations" [1]. **Harbour** is the free software one:
it describes itself as "backward compatible with Clipper/xBase" and runs
on macOS, Linux, Windows and more [5]. Its source code carries the
copyright line "Copyright (c) 1999-2025" (printed by `hbmk2 -build`).
Harbour 3.0.0 was released on 2011-07-17 [2], and **Harbour 3.2.0**, "the
first official stable release since 3.0.0 (2011)", on 2026-07-07 [6].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| "Winter 85" | First Nantucket Clipper release, a dBASE compiler | [3] |
| "Summer 87" | Last seasonal release, sold as a "dBase III® compiler" | [3] |
| Clipper 5 | No longer a dBASE compiler: an "Application Development System" | [3] |
| 1992-05 | Computer Associates buys Nantucket; the product becomes CA-Clipper | [4] |
| by 1998-03 | CA announces 5.3 as the last significant release; 5.3b is current | [1] |
| 2011-07-17 | Harbour 3.0.0 | [2] |
| 2026-07-07 | Harbour 3.2.0, the toolchain used in [cli](cli/) | [6] |

The release years of Clipper 5.0 and 5.3 are left out: no primary source
for them could be found.

## Market usage today
- **TIOBE Index, October 2026:** neither Clipper nor Harbour appears in
  the top 50 or in "The Next 50 Programming Languages" (#51 to #100). The
  only xBase language listed is `XBase++`, in the unranked #51-#100 list [7].
- **Stack Overflow Developer Survey 2026:** Clipper, Harbour and xBase are
  not among the languages of the survey [8].

No reliable, dated usage figure for Clipper or Harbour was found, so none
is given. Harbour itself is maintained: its GitHub repository has CI on
Linux, Windows and macOS [5] and a release in 2026 [6].

## Importance then and now
- **Then (late 1980s-1990s):** Clipper turned dBASE programs into
  stand-alone, compiled MS-DOS applications, and became a language of its
  own for "corporate and commercial applications development" [1].
- **Now:** Harbour keeps those programs alive on modern operating systems.
  It "can be used to make open source applications, free or nonfree
  products" [2], and lists "Native RDDs, SQL, ODBC" and support for "JSON,
  SSL, TCP/IP, XML" among its features [2]. An RDD is a "replaceable
  database driver" [9], the layer through which Clipper programs read and
  write their data files.
- **In teaching:** Clipper shows a language built around *commands* that
  are preprocessor rules: `?` and `??` look like statements, but
  `std.ch` turns them into the functions `QOut()` and `QQOut()` (see the
  [walkthrough](cli/README.md#step-by-step-walkthrough)). It also shows,
  like [COBOL](../cobol/cli/), a compiler that produces C, here as pcode
  for a virtual machine.

## Comparing the categories
Clipper has one category here, cli. The useful comparison is with the other
MS-DOS-era language in this repository, BASIC, and with COBOL, which also
compiles through C:

| | [Clipper cli](cli/) | [BASIC cli](../basic/cli/) | [COBOL cli](../cobol/cli/) |
|---|---|---|---|
| Dialect | Clipper 5 | QBasic / QuickBASIC 4.5 | COBOL-85 |
| Era of the dialect | MS-DOS business applications | MS-DOS PCs, hobby and teaching | mainframes |
| Statement that prints | `?? "Hello, World!"` then `?` | `PRINT "Hello, World!"` | `DISPLAY "Hello, World!".` |
| Entry point | `PROCEDURE Main()` | first statement of the file | first statement of `PROCEDURE DIVISION` |
| Types | dynamic | static, by name suffix or `DIM ... AS` | static, `PICTURE` clauses |
| Modern compiler | Harbour 3.2.0: Clipper → C (pcode) → machine code | QB64-PE 4.7.0: BASIC → C++ → machine code | GnuCOBOL 3.2: COBOL → C → machine code |
| Installed by | source build of the official release | build of the official macOS package | Homebrew |

## Why there is no desktop or web version
This repository has only the cli version of Clipper. A category stays only
if a maintained, mainstream, and reasonably simple toolchain exists for it
on all target platforms.

- **Clipper's own interface was the text screen.** CA-Clipper ran on
  "IBM-PC-type personal computers running DOS-like operating systems" [1];
  its screens were text screens drawn with commands such as `@...SAY`
  and `@...GET` [9]. Harbour reproduces that through its terminal drivers (GT), as the cli
  build shows.
- **Harbour's GUI and web options are optional contrib libraries.** The
  3.2.0 source tree has GUI terminals such as `gtqtc` (Qt) and `gtwvg`
  (Windows only), and an HTTP server library, `hbhttpd`, under
  `contrib/` [6]. They need extra system libraries (Qt for `gtqtc`) and are
  not part of the core that `install.sh` builds (`HB_BUILD_CONTRIBS=no`).
  A desktop or web Hello World would be mostly glue around them, not
  Clipper, so it was left out.

## Sources
1. Clipper FAQ, part 3: "About Clipper and Visual Objects" (as of March 1998). The Oasis archive, hosted by the Harbour project. <https://harbour.github.io/the-oasis/docs/clipper-3.html> (accessed 2026-11-01)
2. Harbour home page (features, project status, license summary). Harbour project. <https://harbour.github.io/> (accessed 2026-11-01)
3. The CA-Clipper Story. Greg Holmes, The Holmes Page (a third-party history, not a vendor document). <https://ghservices.com/gregh/clipper/story.htm> (accessed 2026-11-01)
4. "Nantucket After Computer Associates". CBR (Computer Business Review), 1992-06-01, archived by Tech Monitor. <https://www.techmonitor.ai/?p=171092> (accessed 2026-11-01)
5. Harbour README. Harbour project, GitHub. <https://github.com/harbour/core> (accessed 2026-11-01)
6. Release v3.2.0 (2026-07-07). Harbour project, GitHub. <https://github.com/harbour/core/releases/tag/v3.2.0> (accessed 2026-11-01)
7. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
8. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
9. CA-Clipper 5.3 reference (commands and functions, RDDs). Computer Associates documentation, hosted by the Harbour project. <https://harbour.github.io/doc/clc53.html> (accessed 2026-11-01)
