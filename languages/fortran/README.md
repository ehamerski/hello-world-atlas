# Fortran

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural), with modules and array operations.
Since Fortran 2003 it also supports object orientation ("the major changes
concern object orientation and interfacing with C" [1]). Fortran was made
for numerical work: the Fortran-lang website says it "has been designed from the ground up for
computationally intensive applications in science and engineering" [2].

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GFortran (`gfortran`) | ✅ |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
Fortran is older than the two languages it is compared with below
([COBOL](../cobol/README.md), 1959–1960, and [Ada](../ada/README.md),
1983). IBM's history page says that John Backus, at IBM, wanted programs written in something resembling
mathematical notation: "In 1953, he was given a budget to hire a small team
to test the feasibility of that notion" [3]. The team's "Preliminary Report:
Specifications for the IBM Mathematical FORmula TRANslating System,
FORTRAN" is dated 1954-11-10, and the first *Programmer's Reference
Manual* is dated 1956-10-15 [4]. "In 1957, the IBM Mathematical Formula
Translating System, or Fortran, debuted. Soon after, IBM made the first
Fortran compiler available to users of the IBM 704" [3]; it "was shipped in
April 1957" [4].

Fortran spread quickly: "By the mid-1960s, Fortran had become the first
national computing standard" [3], ANSI X3.9-1966, known as FORTRAN 66 [5].
FORTRAN 77 followed (ISO 1539-1980 [6]), then Fortran 90 (ISO/IEC
1539:1991 [5]) and Fortran 95 [5]. Fortran 2003 added object orientation and
interoperability with C [1], Fortran 2008 added coarrays for parallel
programs [7], and the current standard is Fortran 2023, "published November
2023" [8]. The committee is already working on the next one: WG5 lists a
"Fortran 2028 Committee Draft" (2026) [9].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1953 | John Backus gets a budget and a small team at IBM | [3] |
| 1954-11-10 | *Preliminary Report: Specifications for ... FORTRAN* | [4] |
| 1957-04 | First FORTRAN compiler ships for the IBM 704 | [3][4] |
| 1966 | FORTRAN 66 (ANSI X3.9-1966), "the first national computing standard" | [3][5] |
| 1978 / 1980 | FORTRAN 77 (ANSI, then ISO 1539-1980) | [5][6] |
| 1991 | Fortran 90 (ISO/IEC 1539:1991) | [5] |
| 1997 | Fortran 95 (ISO/IEC 1539:1997) | [5] |
| 2004 | Fortran 2003 (ISO/IEC 1539:2004): object orientation, interoperability with C | [1][10] |
| 2010 | Fortran 2008 (ISO/IEC 1539:2010): coarrays; the standard used in [cli](cli/) | [7][11] |
| 2018 | Fortran 2018 ("Formerly Fortran 2015") | [12] |
| 2023-11 | Fortran 2023 (ISO/IEC 1539:2023), the current standard | [8] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Fortran is #13 with a rating of 1.12%. It
  was #11 in October 2025 [13].
- **Stack Overflow Developer Survey 2026:** 1.7% of all respondents to the
  programming languages question used Fortran (239 of 14,099) [14].

The two numbers measure different things: TIOBE counts search-engine
results, and the Stack Overflow survey counts the developers who answered
it.

## Importance then and now
- **Then (1957 to the 1970s):** IBM writes that "Fortran democratized computer
  programming by providing scientists, mathematicians and engineers the
  ability to input their problems directly into the computer without
  relying on a programmer" and that it "greatly increased programmer
  productivity and significantly lowered costs" [3].
- **Now:** the Fortran-lang website describes Fortran as a
  "High-performance parallel programming language" and says "Fortran is
  mature and under active development" [2]. The standard is still being
  revised (Fortran 2023 [8], a 2028 committee draft [9]).
- **In teaching:** Fortran shows two ages of programming in one language.
  The [`cli`](cli/) version uses modern free form; the `.f` fixed form of
  the punched-card era [15] follows the same idea as the column rules in
  the [COBOL `cli`](../cobol/cli/). The leading blank that `print *` writes
  (see the [`cli` walkthrough](cli/README.md#step-by-step-walkthrough))
  shows that even one line of output follows rules written into the
  standard.

## Comparing the categories
Fortran has one category here, `cli`, so this section compares it with
two other older languages in this repository that compile to a native
executable:

| | [COBOL cli](../cobol/cli/) | [Fortran cli](cli/) | [Ada cli](../ada/cli/) |
|---|---|---|---|
| Statement that prints | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Comment syntax | `*` in column 7 | `!` to end of line | `--` to end of line |
| Case-sensitive? | no | no | no |
| Program header | `PROGRAM-ID. HELLO.` | `program hello` | `procedure Hello is` |
| Compiler | GnuCOBOL (COBOL → C) | GFortran (GCC) | GNAT (GCC) via Alire |

## Why there is no desktop or web version
This repository includes a category only if a maintained, mainstream,
and reasonably simple toolchain exists for it on all target platforms.
For Fortran, no such toolchain exists for the desktop or web categories:

- **Desktop: only bindings to C toolkits.** The package index of the
  Fortran-lang website has a category "Graphics, plotting and user
  interfaces" [16]. Its graphical user interface (GUI) entries are
  bindings: `gtk-fortran` ("A cross-platform library to build Graphical
  User Interfaces (GUI)"), Fortran 2008 bindings to X/Motif, and ISO C
  binding interfaces to Xlib [17]. `gtk-fortran` is maintained ("A GTK / Fortran binding" [18]), but it needs the GTK C
  library installed first and calls it through C interoperability: the
  student would install and learn GTK (as in the
  [C desktop](../c/desktop/) version) plus the binding, before any Fortran.
- **Web: no web framework in the package index.** The index has no web
  or HTTP-server category [16], so there is no mainstream way to serve a
  page from Fortran.
- **Fit with the language's use:** Fortran is for "computationally
  intensive applications in science and engineering" [2], and its
  standard defines input/output for files and records [6], not windows
  or HTTP.

The Fortran Hello World is therefore a command-line program only.

## Sources
1. The New Features of Fortran 2003 (WG5 N1648). John Reid. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/N1601-N1650/N1648.pdf> (accessed 2026-11-01)
2. The Fortran Programming Language (home page and FAQ). Fortran-lang. <https://fortran-lang.org/> (accessed 2026-11-01)
3. Fortran. IBM Heritage. <https://www.ibm.com/history/fortran> (accessed 2026-11-01)
4. History of FORTRAN and FORTRAN II. Computer History Museum, Software Preservation Group. <https://softwarepreservation.computerhistory.org/FORTRAN/> (accessed 2026-11-01)
5. Earlier Fortran standards (FORTRAN 66, FORTRAN 77, Fortran 90, Fortran 95). ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/fearlier.html> (accessed 2026-11-01)
6. Fortran 2018 working draft J3/18-007r1, 4.3.1 (table of earlier standards). INCITS/Fortran (J3). <https://j3-fortran.org/doc/year/18/18-007r1.pdf> (accessed 2026-11-01)
7. Coarrays in the next Fortran Standard (WG5 N1824). John Reid. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/N1801-N1850/N1824.pdf> (accessed 2026-11-01)
8. Fortran 2023. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2023.html> (accessed 2026-11-01)
9. WG5 home page (news: N2258 Fortran 2028 Committee Draft). ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/> (accessed 2026-11-01)
10. Fortran 2003. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2003.html> (accessed 2026-11-01)
11. Fortran 2008. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2008.html> (accessed 2026-11-01)
12. Fortran 2018. ISO/IEC JTC1/SC22/WG5. <https://wg5-fortran.org/f2018.html> (accessed 2026-11-01)
13. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
14. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
15. GNU Fortran and GCC (source form by file extension). GCC. <https://gcc.gnu.org/onlinedocs/gfortran/GNU-Fortran-and-GCC.html> (accessed 2026-11-01)
16. Fortran packages (categories). Fortran-lang. <https://fortran-lang.org/packages/> (accessed 2026-11-01)
17. Graphics, plotting and user interfaces. Fortran-lang. <https://fortran-lang.org/packages/graphics/> (accessed 2026-11-01)
18. `vmagnin/gtk-fortran`. GitHub. <https://github.com/vmagnin/gtk-fortran> (accessed 2026-11-01)
