# Delphi

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative and object-oriented (Object Pascal) [1][2].

> The examples use the Delphi dialect of Object Pascal, compiled by Free Pascal
> 3.2.2 (`{$mode delphi}`); the desktop example also uses Lazarus 4.8 (LCL).
> Embarcadero Delphi itself is not used. See [cli/](cli/) and [desktop/](desktop/).

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Free Pascal 3.2.2 in Delphi mode (`{$mode delphi}`) | 🔶 |
| desktop | [desktop/](desktop/) | Lazarus 4.8 (LCL, Cocoa) with Free Pascal 3.2.2 | 🔶 |

## History

Delphi is a development product for Object Pascal. Borland launched Delphi 1.0
at the Software Development West conference in San Francisco on 14 February
1995 [3]. The Borland team that released it included Anders Hejlsberg [4], who
was the chief architect of the Delphi product line [5]. Delphi 1.0 was 16-bit
only; the 32-bit Delphi 2.0 followed in 1996 [6]. Delphi combined Object
Pascal with a visual form builder [6]. Hejlsberg joined Microsoft in 1996 [5],
where he became the chief designer of C# [5]. Object Pascal is a dialect of
Pascal; the history of Pascal and Turbo Pascal is on the
[Pascal page](../pascal/README.md).

Today Delphi is an Embarcadero product. In November 2026, the Embarcadero
product page lists Delphi 13.2 as the current version, part of RAD Studio
13.2 Florence [7]. Its FireMonkey framework builds programs for Windows,
Linux, macOS, iOS and Android, and a free Community Edition of Delphi 13 is
available [7].

Free Pascal is a separate, free compiler for Pascal and Object Pascal. Its Delphi
mode (`{$mode delphi}`) accepts Delphi-style code [2]. Lazarus is a free,
Delphi-like IDE and component library (LCL) built on Free Pascal [8].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1995 | Borland launches Delphi 1.0 (16-bit) on 14 February | [3][6] |
| 1996 | Delphi 2.0, 32-bit | [6] |
| 1996 | Anders Hejlsberg, chief architect of Delphi, joins Microsoft | [5] |
| 2026 | Delphi 13.2 (RAD Studio 13.2 Florence) is the current Embarcadero version | [7] |
| 2026 | Lazarus 4.8 (with Free Pascal 3.2.2), the versions used by the desktop example | [8][9] |

The Turbo Pascal milestones are on the [Pascal page](../pascal/README.md).

## Market usage today

Every number below has its date and source. They change every year.

- **TIOBE Index, November 2026:** "Delphi/Object Pascal" is #19 with a
  rating of 0.78% (−1.28% from a year earlier); it was #8 in November
  2025 [10].
- **Stack Overflow Developer Survey 2026:** 1.9% of all respondents (267
  of 14,099) used Delphi [11].

The two numbers measure different things: TIOBE counts search-engine
results, and the Stack Overflow survey counts the developers who answered
it. Neither breaks out Free Pascal or Lazarus. The Pascal page has its own
figures: [pascal/README.md](../pascal/README.md).

## Importance then and now

Delphi made visual, event-driven Windows programming with a compiled language
much quicker for many developers [6]. Free Pascal and Lazarus keep the Delphi
dialect and its component model available as free software [2][8]. The
examples here use them, so they build with a free toolchain.

## Comparing the categories

The two categories share the Pascal source rules. `cli` is a console program
(`WriteLn`). `desktop` is a Lazarus project (`hello.lpi`, `hello.lpr`) that
opens a window through the LCL. See [cli/README.md](cli/README.md) and
[desktop/README.md](desktop/README.md).

## Why there is no web version

No web version is implemented. Delphi is known for its visual form builder for
Windows desktop programs [6], so this folder shows a console program and a
desktop form, the two kinds that Free Pascal and Lazarus build here [2][8].

## Sources

1. Free Pascal Reference Guide, chapter 6 "Classes" (the Delphi approach to object-oriented programming). Free Pascal. <https://www.freepascal.org/docs-html/ref/refch6.html> (accessed 2026-11-20)
2. Free Pascal User's Guide, compiler modes (Delphi mode). Free Pascal. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (accessed 2026-11-10)
3. David Intersimone, "Celebrating the 30th Anniversary of Delphi Version 1.0's Launch", Embarcadero blog, 14 February 2025. <https://blogs.embarcadero.com/celebrating-the-30th-anniversary-of-delphi-version-1-0s-launch/> (accessed 2026-11-20)
4. Celebrating Delphi's anniversary (the Borland team that released Delphi). Embarcadero. <https://delphi.embarcadero.com/> (accessed 2026-11-20)
5. "Microsoft's Anders Hejlsberg Receives Prestigious Excellence in Programming Award", Microsoft News, 11 April 2001. <https://news.microsoft.com/source/2001/04/11/microsofts-anders-hejlsberg-receives-prestigious-excellence-in-programming-award/> (accessed 2026-11-20)
6. Tim Anderson, "25 years of Delphi", The Register, 14 February 2020 (secondary source). <https://www.theregister.com/software/2020/02/14/25-years-of-delphi-and-no-oracle-in-sight-not-a-visual-basic-killer-but-hard-to-kill/360875> (accessed 2026-11-20)
7. Delphi product page (Delphi 13.2, FireMonkey platforms, Community Edition). Embarcadero. <https://www.embarcadero.com/products/delphi> (accessed 2026-11-20)
8. Lazarus home page (Lazarus 4.8, Free Pascal 3.2.2). Lazarus. <https://www.lazarus-ide.org/> (accessed 2026-11-10)
9. Free Pascal home page (version 3.2.2 as the latest stable release). Free Pascal. <https://www.freepascal.org/> (accessed 2026-11-10)
10. TIOBE Index for November 2026 (Delphi/Object Pascal). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-20)
11. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
