# Ada

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative, with modules (packages) and, since Ada 95,
object-oriented programming. The Ada Resource Association says that Ada 95
made Ada "the world's first internationally standardized object oriented
language" [1]. Ada is used where software must be safe ("These
applications require a high degree of safety" [10]), and its compiler
performs many checks: in the [cli](cli/) version, even a misspelled
procedure name is reported with a suggested fix.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GNAT via Alire | ✅ |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
Ada was ordered by the United States Department of Defense (DoD). The Ada
Reference Manual's introduction says: "The common high order language
program began in 1974. The requirements of the United States Department of
Defense were formalized in a series of documents", and "The Ada language
was designed in accordance with the final (1978) form of these
requirements, embodied in the Steelman specification" [2].

The design was chosen by competition: "After several rounds of competition
the winner was a team from France lead by Jean Ichbiah" [1]. The Reference
Manual adds: "The Ada design team was led by Jean D. Ichbiah" [2], and "The
Ada 83 language definition was developed by Cii Honeywell Bull and later
Alsys" [2]. The name honors the 19th-century mathematician Ada Lovelace:
"The decision was to name the language in honor of Augusta Ada Byron,
Countess of Lovelace" [1], a choice the DoD made "in 1979" [3].

The first standard, Ada 83, was published as a US military standard
("1983 Mil Std 1815 published (Ada 83)") and adopted by ISO in 1987 [4].
Ada 95 added object orientation [1]. Ada 2012 brought "pre- and
postconditions for subprograms, type invariants, and subtype predicates"
[5], which let a
programmer write a contract next to the code. The current edition, Ada
2022, "was published as ISO/IEC 8652:2023 in May 2023" [6].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1974 | The DoD's "common high order language program" begins | [2] |
| 1978 | Final requirements: the Steelman specification | [2] |
| 1979 | The language is named "Ada", after Ada Lovelace (born 1815-12-10) | [1][3] |
| 1983 | Ada 83: Mil Std 1815 published | [4] |
| 1987 | ISO adopts Ada 83 unchanged as ISO 8652:1987 | [4] |
| 1995 | Ada 95 (ISO/IEC 8652:1995): "first internationally standardized object oriented language" | [1][4] |
| 2007 | Ada 2005 (Amendment 1 to Ada 95) | [4] |
| 2012 | Ada 2012 (ISO/IEC 8652:2012): contracts (pre/postconditions) | [4][5] |
| 2023-05 | Ada 2022 published as ISO/IEC 8652:2023; the edition used in [cli](cli/) | [6] |
| 2026-05-29 | Alire 2.1.1, the package manager used here | [7] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Ada is #21 with a rating of 0.82%, outside
  the top 20 [8].
- **Stack Overflow Developer Survey 2026:** 1.2% of all respondents to the
  programming languages question used Ada (172 of 14,099) [9].
- **Where it is used:** "Specific domains seeing Ada usage include
  Aerospace & Defense, civil aviation, rail, and many others. These
  applications require a high degree of safety" [10]. ada-lang.io sums it
  up as "40 years of reliability in planes, trains, and satellites" [11].

These are small shares of general developer surveys. Ada's use is
concentrated in the specialized domains above, which a general survey
reaches only in part.

## Importance then and now
- **Then (1980s):** Ada was the DoD's "common high order language" [2].
  It was designed from written requirements (Steelman [2]) by a competition
  [1], not grown from an existing language, and it became a military
  standard in 1983 and an ISO standard in 1987 [4].
- **Now:** the focus on safety continues in SPARK, which
  "is a subset of Ada, designed so that the code written in SPARK is
  amenable to automatic proof" [10]. Ada 2012's contracts [5] put the
  rules of a subprogram in its declaration, where the compiler and these
  tools can check them.
- **In teaching:** Ada shows how much a compiler can check. Compare the
  Hello World with [C](../c/cli/hello.c): Ada spells out where every block
  ends (`end Hello;`), names the package of every call
  (`Ada.Text_IO.Put_Line`) and has a separate bind step that checks the
  whole program is consistent before linking (see the
  [cli walkthrough](cli/README.md#step-by-step-walkthrough)).

## Comparing the categories
Ada has one category here, cli, so the useful comparison is with the other
two older languages in this repository that compile to a native executable:

| | [COBOL cli](../cobol/cli/) | [Fortran cli](../fortran/cli/) | [Ada cli](cli/) |
|---|---|---|---|
| Statement that prints | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Program structure | 2 divisions (IDENTIFICATION, PROCEDURE) | `program hello` ... `end program hello` | `procedure Hello is begin ... end Hello;` |
| Build command | `cobc -x` (COBOL → C → machine code) | `gfortran` | `alr build` (GPRbuild: compile, **bind**, link) |
| Standard used | COBOL-85 (fixed format) | Fortran 2008 (free form) | Ada 2022 |
| Runtime library | `libcob`, loaded at run time | `libgfortran`, loaded at run time | linked into the executable |

## Why there is no desktop or web version
This repository has no desktop or web version of Ada. A category stays only
if a maintained, mainstream, and reasonably simple toolchain exists for it
on all target platforms. Ada libraries for both exist and are maintained,
but neither fits "the most simple and direct way":

- **Desktop: GtkAda** is AdaCore's "Ada bindings for the GTK+ graphical
  library" [12]. Its Alire crate says "This crate requires Gtk3+ >=
  3.24.24" [13], so the student must first install the GTK 3 C library
  and its build tools on each OS before the Ada code (the
  [C desktop](../c/desktop/) version shows what installing GTK involves).
  It is a binding to a C toolkit, not a GUI library of Ada's own.
- **Web: AWS (Ada Web Server)** "is a small yet powerful HTTP component to
  embed in any applications" [14]. Its Alire crate depends on `gnatcoll`,
  `xmlada`, and OpenSSL (`openssl >=1.1.0`) [15]: a much larger build than the
  Hello World itself.
- **Fit with the language's use:** Ada's usage is in embedded and
  safety-critical systems such as "Aerospace & Defense, civil aviation,
  rail" [10], where a command-line or embedded program is the typical form.

So the Ada Hello World stays a cli program. The desktop and web categories
are shown with mainstream toolchains in the other languages of this
repository (see the [root README](../../README.md)).

## Sources
1. Introduction to Ada, part 1 (history). Ada Information Clearinghouse (Ada Resource Association). <https://www.adaic.org/learn/materials/intro/part1/> (accessed 2026-11-01)
2. Ada Reference Manual, 2022 Edition: Introduction (Language Summary, Acknowledgements). Ada Resource Association. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-2.html> (accessed 2026-11-01)
3. Celebrating Ada Lovelace: The Pioneer of Programming. AdaCore press release. <https://www.adacore.com/press/celebrating-ada-lovelace-the-pioneer-of-programming> (accessed 2026-11-01)
4. Ada Standards Timeline. Ada Information Clearinghouse. <https://www.adaic.org/ada-resources/standards/ada-standards-timeline/> (accessed 2026-11-01)
5. Ada 2012. Ada Information Clearinghouse. <https://www.adaic.org/advantages/ada-2012/> (accessed 2026-11-01)
6. Ada Reference Manual, 2022 Edition: Foreword. <https://www.adaic.org/resources/add_content/standards/22rm/html/RM-0-1.html> (accessed 2026-11-01)
7. Alire releases, v2.1.1. GitHub, `alire-project/alire`. <https://github.com/alire-project/alire/releases/tag/v2.1.1> (accessed 2026-11-01)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
9. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
10. Introduction to Ada: Introduction. AdaCore (learn.adacore.com). <https://learn.adacore.com/courses/intro-to-ada/chapters/introduction.html> (accessed 2026-11-01)
11. Ada Programming Language (home page). ada-lang.io. <https://ada-lang.io/> (accessed 2026-11-01)
12. `AdaCore/gtkada`. GitHub. <https://github.com/AdaCore/gtkada> (accessed 2026-11-01)
13. `gtkada` crate. Alire. <https://alire.ada.dev/crates/gtkada> (accessed 2026-11-01)
14. `AdaCore/aws`. GitHub. <https://github.com/AdaCore/aws> (accessed 2026-11-01)
15. `aws` crate. Alire. <https://alire.ada.dev/crates/aws> (accessed 2026-11-01)
