# Pascal

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural, structured). Niklaus Wirth designed
Pascal "both as a convenient basis to teach programming and as an efficient
tool to write large programs" [1]. Object Pascal, the dialect of Delphi and
Lazarus, adds object orientation: Free Pascal's `objfpc` mode "includes
classes, interfaces and exceptions" [2].

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | ISO 7185 Standard Pascal · Free Pascal 3.2.2 (`fpc -Miso`) | ✅ verified on macOS Intel |
| desktop | [desktop/](desktop/) | Object Pascal · Lazarus 4.8 LCL (Cocoa on macOS), built with `lazbuild` · Free Pascal 3.2.2 | ✅ verified on macOS Intel |
| web | – | not implemented, see [Why there is no web version](#why-there-is-no-web-version) | – |

## History
Pascal comes from ETH Zürich. Niklaus Wirth "became Professor of
Informatics at ETH Zurich" in 1968 [3] and "developed the languages Pascal
between 1968 and 1970" [4]. His report *The Programming Language Pascal* is
dated November 1970 [1]. It explains the goal: "emphasis was placed on
keeping the number of fundamental concepts reasonably small", and it
reports a working compiler: "A one-pass compiler has been constructed for
the CDC 6000 computer family; it is expressed entirely in terms of Pascal
itself" [1].

Pascal then moved to personal computers. "Turbo Pascal was introduced by
Borland in November 1983" [5], and Borland's object-oriented successor,
Delphi, followed: "Delphi 1 (Feb 14, 1995)" [6]. ISO also
standardized Pascal as ISO 7185 (Standard Pascal) and ISO/IEC 10206
(Extended Pascal). Free Pascal has a compatibility mode for each [2][7].

The free compilers came next. "Free Pascal was started by Florian Klämpfl,
Germany", with "06/1993: project start" and "07/2000: 1.0 released" [8].
"Lazarus was started in February of 1999" [9] to give Free Pascal a
Delphi-like IDE and component library. Lazarus 1.0 was announced on
2012-08-29 [10].

Wirth received the 1984 ACM Turing Award "for developing a sequence of
innovative computer languages Euler, Algol-W, Pascal, and Modula" [4]. He
"died on 1 January 2024, just weeks before his 90th birthday" [11].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1968–1970 | Wirth develops Pascal at ETH Zürich | [3][4] |
| 1970-11 | *The Programming Language Pascal* (report); first compiler for the CDC 6000 | [1] |
| 1983-11 | Borland's Turbo Pascal | [5] |
| 1984 | ACM Turing Award to Niklaus Wirth | [4][11] |
| 1993-06 | Free Pascal project starts | [8] |
| 1995-02-14 | Delphi 1 (Object Pascal, visual forms) | [6] |
| 1999-02 | Lazarus project starts | [9] |
| 2000-07 | Free Pascal 1.0 | [8] |
| 2012-08 | Lazarus 1.0 | [10] |
| 2021-05 | Free Pascal 3.2.2, still the latest stable release; used in both folders here | [12] |
| 2026-06-11 | Lazarus 4.8, used in [desktop](desktop/) | [13] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** "Delphi/Object Pascal" is #19 with a
  rating of 0.83%. It was #9 in October 2025 [14]. TIOBE has no separate
  "Pascal" entry in its top 20.
- **Stack Overflow Developer Survey 2026:** 1.9% of all respondents used
  Delphi (267 respondents). Pascal is not listed separately [15].

The two numbers measure different things: TIOBE counts search-engine
results, and the Stack Overflow survey counts the developers who answered
it. Both sources report Delphi, the commercial Object Pascal product, and
the figures above do not break out Free Pascal or Lazarus.

## Importance then and now
- **Then (1970s–1990s):** Pascal was built for teaching [1]. ETH says
  Wirth "achieved world fame by developing the Pascal programming
  language" [11]. Turbo Pascal and then Delphi brought it to PC
  programmers [5][6].
- **Now:** Free Pascal is "a mature, versatile, open source Pascal
  compiler" [12], and Lazarus describes its range as "file browsers, image
  viewers, database applications, graphics editing software, games, 3D
  software, medical analysis software or any other type of software" [13].
  The commercial branch, Delphi, is the one the surveys measure [14][15].
- **In teaching:** the two folders show two forms of Pascal. The
  [cli](cli/) uses the small, strict language of the 1970 report (ISO 7185
  mode); the [desktop](desktop/) uses Delphi-style Object Pascal with
  classes, units, and a form designer file.

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) |
|---|---|---|
| Dialect | ISO 7185 Standard Pascal (`-Miso`) | Object Pascal (`{$mode objfpc}{$H+}`) |
| Build | `fpc` on one file | `lazbuild` on a Lazarus project, which calls `fpc` |
| Source files | `hello.pas` | `hello.lpi`, `hello.lpr`, `mainunit.pas`, `mainunit.lfm` |
| Library | Free Pascal runtime library only | the LCL (Lazarus Component Library) |
| How it ends | after the last statement | when the window is closed (event loop) |
| First build on the dev machine | under 1 second | about 50 seconds (the LCL is compiled once) |

Compared with the other languages: Pascal marks blocks with
`begin ... end`, like the [Ada cli](../ada/cli/), whereas C, Java, and Go use
braces. Its keywords are case-insensitive, like those of Fortran and
COBOL. Its desktop version describes the window in a separate text file
(`mainunit.lfm`), as the [Node.js desktop](../node/desktop/) does with
`index.html`; the [C](../c/desktop/) and [C#](../csharp/desktop/)
desktop versions build their window in code.

## Why there is no web version
This repository has no web version of Pascal. A category stays only if a
maintained, mainstream, and reasonably simple toolchain exists for it on
all target platforms.

Web programming in Pascal is possible, but none of the options below is a
mainstream web stack, so this repository leaves the web category out. The
options are:
- **fcl-web**, part of Free Pascal: "Web(app) related parts of Free
  Component Libraries (FCL), FPC's OOP library" [16]. It ships with FPC.
- **pas2js**, also from the Free Pascal project: "an open source Pascal to
  JavaScript transpiler" [17], for the browser side, not for a server.
- **Third-party frameworks** such as Brook ("Microframework which helps to
  develop web Pascal applications") [18] and mORMot 2 (an "RTL/ToolBox in
  modern Object Pascal, up to a Client-Server ORM/SOA/MVC Framework") [19]
  are separate projects, installed on top of Free Pascal.
- **Usage:** Pascal as a whole is #19 on TIOBE and used by 1.9% of the
  Stack Overflow 2026 respondents (as Delphi) [14][15], so Pascal web
  frameworks serve a small share of developers.

Pascal therefore keeps the cli and the desktop versions, where Free Pascal
and Lazarus are the standard free tools.

## Sources
1. Niklaus Wirth, *The Programming Language Pascal*, ETH Zürich, November 1970 (second edition July 1971). ETH Research Collection, DOI 10.3929/ethz-a-004150844. <https://www.research-collection.ethz.ch/server/api/core/bitstreams/8bd8f312-3c90-4bc5-9081-63943ff3902a/content> (accessed 2026-11-01)
2. Free Pascal User's Guide, compiler modes, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (accessed 2026-11-01)
3. Niklaus Wirth (profile). IEEE Computer Society. <https://www.computer.org/profiles/niklaus-wirth> (accessed 2026-11-01)
4. Niklaus Wirth (Computer Pioneers). IEEE Computer Society History. <https://history.computer.org/pioneers/wirth.html> (accessed 2026-11-01)
5. Turbo Pascal turns 40. Embarcadero blog. <https://blogs.embarcadero.com/turbo-pascal-turns-40/> (accessed 2026-11-01)
6. The long and winding road to today's Delphi: happy 29th birthday. Embarcadero blog. <https://blogs.embarcadero.com/the-long-and-winding-road-to-todays-delphi-happy-29th-birthday/> (accessed 2026-11-01)
7. `fpc -h`, the command-line help of Free Pascal 3.2.2 (`-Miso` "ISO 7185 mode", `-Mextendedpascal` "ISO 10206 mode"; run on the dev machine, 2026-11-01).
8. Free Pascal FAQ (history). Free Pascal. <https://www.freepascal.org/faq.html> (accessed 2026-11-01)
9. About Lazarus. Lazarus. <https://www.lazarus-ide.org/index.php?page=about> (accessed 2026-11-01)
10. [Lazarus] Lazarus 1.0 Release (mailing list, 2012-08-29). Lazarus. <https://lists.lazarus-ide.org/pipermail/lazarus/2012-August/206047.html> (accessed 2026-11-01)
11. Computer pioneer Niklaus Wirth has died. ETH Zürich News, January 2024. <https://ethz.ch/en/news-and-events/eth-news/news/2024/01/computer-pioneer-niklaus-wirth-has-died.html> (accessed 2026-11-01)
12. Free Pascal (home page: "Version 3.2.2 is the latest stable version of Free Pascal", release news May 2021). <https://www.freepascal.org/> (accessed 2026-11-01)
13. Lazarus home page (description, news "Lazarus Bugfix Release 4.8 - June 11, 2026"). Lazarus. <https://www.lazarus-ide.org/> (accessed 2026-11-01)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
15. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
16. fcl-web `fpmake.pp` (package description). Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/source/-/blob/main/packages/fcl-web/fpmake.pp> (accessed 2026-11-01)
17. pas2js README. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/pas2js/-/blob/main/README.md> (accessed 2026-11-01)
18. risoflora/brookframework. GitHub. <https://github.com/risoflora/brookframework> (accessed 2026-11-01)
19. synopse/mORMot2. GitHub. <https://github.com/synopse/mORMot2> (accessed 2026-11-01)
