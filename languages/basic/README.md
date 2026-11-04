# BASIC

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural). A classic BASIC program is a list of
statements run from top to bottom, with `GOTO`/`GOSUB` and, in later
dialects such as QBasic, `SUB` and `FUNCTION` procedures. The name stands
for "Beginner's All-purpose Symbolic Instruction Code" [1]: it was made
for learning. Later Microsoft dialects grew in other directions: Visual
Basic (1991) for Windows programs [6], and then Visual Basic .NET, a
language of Microsoft's .NET platform [8]. The Hello World here uses the
classic, procedural QBasic dialect.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | QBasic / QuickBASIC 4.5 dialect · QB64 Phoenix Edition 4.7.0 (`qb64pe -x`) | ✅ verified on macOS Intel |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
BASIC was born at Dartmouth College. "At 4 a.m. on May 1, 1964, in the
basement of College Hall, Professor John Kemeny and a student programmer
simultaneously typed RUN on neighboring terminals. When they both got back
correct answers to their simple programs, time-sharing and BASIC were
born" [1]. Kemeny and Thomas Kurtz "wanted to create a language their
students could learn quickly for use on the timesharing system" [2], and
the result "made computing accessible to all Dartmouth students and
faculty, and soon after, to people across the nation and the world" [1].

BASIC spread into many incompatible dialects, so standards bodies tried to
fix a common core. ECMA published **Minimal BASIC** (ECMA-55) in January
1978, "designed to promote the interchangeability of BASIC programs among a
variety of automatic data processing systems" [3], and a full **BASIC**
standard (ECMA-116) in June 1986 [4]. In the United States, NIST adopted
"American National Standard for BASIC, ANSI X3.113-1987" as a federal
standard, superseding its earlier Minimal BASIC standard [5].

On personal computers the most widespread dialects came from Microsoft.
**QBasic** shipped with MS-DOS 5.0: in MS-DOS "versions 5.0 and later",
even the text editor `EDIT.COM` "invokes QBASIC.EXE with the /EDITOR
switch" [7]. On "May 20th, 1991 at Windows World, in Atlanta, Microsoft
founder Bill Gates demoed Visual Basic 1.0" [6], which brought BASIC to
Windows programming. In 2020 Microsoft announced, about Visual Basic .NET:
"Going forward, we do not plan to evolve Visual Basic as a language" [8].

The QBasic dialect lives on in open-source compilers. **QB64 Phoenix
Edition**, used here, "retains QB4.5/QBasic compatibility" and compiles
native programs for Windows, Linux and macOS. The Phoenix Edition was
"created when the old project related pages went offline in April 2022",
and continues the same QB64 language [9]. **FreeBASIC** is another example: it
"provides a high level of support for programs written for QuickBASIC"
[10].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1964-05-01 | First BASIC programs run at Dartmouth (Kemeny, Kurtz and students) | [1] |
| 1978-01 | ECMA-55 Minimal BASIC | [3] |
| 1986-06 | ECMA-116 BASIC (full BASIC) | [4] |
| 1987 | ANSI X3.113-1987 BASIC, adopted by NIST as FIPS PUB 68-2 | [5] |
| MS-DOS 5.0 | QBasic ships with MS-DOS | [7] |
| 1991-05-20 | Visual Basic 1.0 demonstrated by Bill Gates | [6] |
| 2020-03-11 | Microsoft: no plans to evolve the Visual Basic language further | [8] |
| 2022-04 | QB64 Phoenix Edition formed | [9] |
| 2026-09-26 | QB64-PE 4.7.0, the compiler used in [cli](cli/) | [11] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** "Visual Basic" (which TIOBE uses for
  Visual Basic .NET) is #7 with 2.20%, and "Classic Visual Basic" is #24
  with 0.70% [12]. TIOBE explains that until 2010 "(Visual) Basic"
  "referred to all possible dialects of Basic", and that it was then split
  "into all its dialects such as Visual Basic .NET, Classic Visual Basic,
  PureBasic, and Small Basic" [12].
- **Stack Overflow Developer Survey 2026:** 4.0% of all respondents to the
  programming languages question used Visual Basic (.Net) (557 of 14,099),
  and 3.9% used VBA, the Visual Basic for Applications macro language of
  Microsoft Office (552 of 14,099) [13]. QBasic-style BASIC is not listed.

So "BASIC" today mostly means Microsoft's Visual Basic family. The QBasic
dialect of this project is a teaching and hobby language with no survey
numbers of its own.

## Importance then and now
- **Then:** BASIC made programming accessible to people who were not
  computer specialists, first on Dartmouth's time-sharing system [1][2],
  then on personal computers, where QBasic came with MS-DOS 5.0 and
  later [7].
- **Now:** Visual Basic .NET and VBA still rank among the commonly used
  languages [12][13], although Microsoft no longer evolves Visual Basic as
  a language [8]. The classic dialect survives through compilers such as
  QB64-PE (released 2026-09-26 [11]) and FreeBASIC [10].
- **In teaching:** the [cli](cli/hello.bas) program is a single `PRINT`
  statement, with no `main`, header or declarations. Compare it with
  [C](../c/cli/hello.c), which needs an `#include`, a `main` function and
  braces before it can print anything.

## Comparing the categories
BASIC has one category here, cli. The useful comparison is with the other
MS-DOS-era language in this repository, Clipper, and with the C cli
program:

| | [BASIC cli](cli/) | [Clipper cli](../clipper/cli/) | [C cli](../c/cli/) |
|---|---|---|---|
| Lines of code (without comments) | 3 | 4 | 5 |
| Statement that prints | `PRINT "Hello, World!"` | `?? "Hello, World!"` then `?` | `printf("Hello, World!\n");` |
| Entry point | first statement of the file | `PROCEDURE Main()` | `int main(void)` |
| Ending the program | `SYSTEM` (else QB64 waits for a key) | `RETURN` from `Main()` | `return 0;` |
| Compiler | QB64-PE: BASIC → C++ → machine code | Harbour: Clipper → C (pcode) → machine code | clang: C → machine code |

## Why there is no desktop or web version
This repository has only the cli version of BASIC. A category stays only
if a maintained, mainstream, and reasonably simple toolchain exists for it
on all target platforms.

- **Desktop:** the classic dialect has no GUI toolkit. A QB64-PE program
  without `$CONSOLE:ONLY` opens its "graphical program window" [14], a
  screen the program prints and draws on. It has no buttons, menus or
  labels, so it is not a desktop GUI in the sense of the other languages'
  desktop folders. A desktop BASIC today would be Visual Basic .NET with Windows
  Forms or WPF, which run only on Windows. That is the same .NET stack as
  the [C# desktop](../csharp/desktop/) version.
- **Web:** QBasic and QB64-PE have no web framework. Serving HTTP from
  BASIC would mean writing the protocol by hand on raw sockets, which is
  no longer a simple Hello World.

## Sources
1. BASIC Begins at Dartmouth. Dartmouth College, BASIC at 50. <https://www.dartmouth.edu/basicfifty/basic.html> (accessed 2026-11-01)
2. May 1, 1964: First BASIC program runs. Computer History Museum, This Day in History. <https://www.computerhistory.org/tdih/may/1/> (accessed 2026-11-01)
3. ECMA-55 Minimal BASIC, 1st edition (January 1978). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-55/> (accessed 2026-11-01)
4. ECMA-116 BASIC, 1st edition (June 1986). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-116/> (accessed 2026-11-01)
5. FIPS PUB 68-2, BASIC (adopts ANSI X3.113-1987), August 1987. National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub68-2-Aug1987.pdf> (accessed 2026-11-01)
6. Happy 20th Birthday, Visual Basic! (2011-05-20). Microsoft Visual Basic Team Blog. <https://devblogs.microsoft.com/vbteam/happy-20th-birthday-visual-basic/> (accessed 2026-11-01)
7. `EDIT.COM` Cannot Find `QBASIC.EXE` (KB 63777). Microsoft Knowledge Base, archived copy. <https://ftp.zx.net.nz/pub/archive/ftp.microsoft.com/MISC/KB/en-us/63/777.HTM> (accessed 2026-11-01)
8. Visual Basic support planned for .NET 5.0 (2020-03-11). Microsoft .NET Blog. <https://devblogs.microsoft.com/vbteam/visual-basic-support-planned-for-net-5-0/> (accessed 2026-11-01)
9. QB64 Phoenix Edition README. QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe> (accessed 2026-11-01)
10. FreeBASIC home page. FreeBASIC project. <https://www.freebasic.net/> (accessed 2026-11-01)
11. Release v4.7.0-GLFW (2026-09-26). QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW> (accessed 2026-11-01)
12. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
13. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
14. $CONSOLE. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/$CONSOLE> (accessed 2026-11-01)
