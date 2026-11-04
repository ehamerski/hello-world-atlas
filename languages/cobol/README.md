# COBOL

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural). A COBOL program is a sequence of
statements organized in divisions, sections and paragraphs. The 2002
standard added object orientation [5], but the Hello World here uses the
procedural COBOL-85. The name stands for "Common business-oriented
language" [3]: it was designed for "business data processing
applications" [1], with statements
that read like English sentences (`DISPLAY "Hello, World!".`).

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | COBOL-85, fixed format · GnuCOBOL 3.2 (`cobc -x`) | ✅ verified on macOS Intel |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
COBOL was created by a committee, not by a company or a single author. The
history appendix of the ANSI COBOL standard says: "On May 28 and 29, 1959,
a meeting was held in the Pentagon for the purpose of considering both the
desirability and the feasibility of establishing a common language for the
programming of electronic computers for business-type applications" [2].
The participants agreed "that it should be problem-oriented and
machine-independent, and that it should use simple English or
pseudo-English and avoid symbolism as far as possible" [1]. "The
Conference on DAta SYstems Languages (CODASYL) developed out of this
meeting" [1].

The language was described in "a report published in April of 1960 by the
Government Printing Office" which "has since become known as COBOL-60"
[2]. The standard lists the earlier languages it built on, starting with
"FLOW-MATIC (trademark of Sperry Rand Corporation), Programming for the
UNIVAC® I and II" [2]. IBM describes COBOL as "Partly derived from
FLOW-MATIC, a language created by computer science pioneer Dr. Grace
Hopper" [3].

COBOL then became a national standard. The first was approved "on August
23, 1968, as a USA Standard" (X3.23-1968) [2], revised in 1974 [2] and in
1985, when "This standard has been adopted as ISO International Standard
1989-1985" [1]. The ISO standard has been revised since: ISO/IEC 1989:2002
(with objects and classes) [5], ISO/IEC 1989:2014 [6] and the current
ISO/IEC 1989:2023 [7].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1959-05-28/29 | Pentagon meeting on a common business language; CODASYL is formed | [1][2] |
| 1960-04 | COBOL-60 report published by the US Government Printing Office | [2] |
| 1961 / 1963 | COBOL-61 and COBOL-61 Extended | [2] |
| 1968-08-23 | First standard, USA Standard X3.23-1968 | [2] |
| 1974-05-10 | ANSI X3.23-1974 | [2] |
| 1985-09-10 | ANSI X3.23-1985 (COBOL-85), adopted as ISO 1989:1985; the standard used in [cli](cli/) | [1] |
| 2002-12-01 | ISO/IEC 1989:2002: objects and classes | [5] |
| 2014 | ISO/IEC 1989:2014 (identical to ANSI INCITS 1989-2014) | [6] |
| 2023-01 | ISO/IEC 1989:2023, the current edition | [7] |
| 2023-07-28 | GnuCOBOL 3.2, the compiler used here | [8] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** COBOL is #16 with a rating of 0.89%. It
  was #23 in October 2025 [9].
- **Stack Overflow Developer Survey 2026:** 1.1% of all respondents to the
  programming languages question used COBOL (150 of 14,099) [10].
- **IBM's figures** (a vendor's claims, not an independent survey): IBM
  writes that COBOL "serves as the foundation for more than 40% of all
  online banking systems", "supports 80% of in-person credit card
  transactions, handles 95% of all ATM transactions, and powers systems
  that generate more than USD 3 billion of commerce each day" [3].

The two kinds of numbers measure different things. Surveys count
developers or web searches, and few developers write COBOL. IBM's figures
count the business transactions that run on existing COBOL systems.

## Importance then and now
- **Then (1960s-1980s):** COBOL was one language for business programs on
  computers from different makers ("machine-independent" [1]), backed by
  the US government (the 1959 meeting was held in the Pentagon [2]) and
  standardized by ANSI from 1968 [2].
- **Now:** COBOL keeps running core banking and payment systems according
  to IBM [3], and it is still being standardized (ISO/IEC 1989:2023 [7]).
  Developer surveys show few people writing it [10].
- **In teaching:** COBOL shows the punched-card era in the source itself:
  fixed columns, a comment marker in column 7, and English words for
  everything (compare [C](../c/cli/hello.c), where the program is
  symbols and braces). Its compiler also shows a common technique:
  GnuCOBOL translates COBOL into C and lets a C compiler do the rest [4].

## Comparing the categories
COBOL has one category here, cli, so the useful comparison is with the
other two older languages in this repository that compile to a native
executable:

| | [COBOL cli](cli/) | [Fortran cli](../fortran/cli/) | [Ada cli](../ada/cli/) |
|---|---|---|---|
| First version | COBOL-60 (1960) | FORTRAN (1957) | Ada 83 (1983) |
| Designed for | business data processing | scientific computing | large, safety-critical systems |
| Statement that prints | `DISPLAY "Hello, World!".` | `print '(a)', "Hello, World!"` | `Ada.Text_IO.Put_Line ("Hello, World!");` |
| Source layout | fixed columns (COBOL-85) | free form (Fortran 2008) | free form |
| Compiler | GnuCOBOL: COBOL → C → machine code | GFortran (GCC) | GNAT (GCC) via Alire |

## Why there is no desktop or web version
This repository has no desktop or web version of COBOL. A category stays
only if a maintained, mainstream, and reasonably simple toolchain exists
for it on all target platforms. GnuCOBOL has none:

- **No GUI in the product.** The GnuCOBOL FAQ answers "Does GnuCOBOL
  support a GUI?" with: "Yes, but not out of the box. There is not
  currently (March 2018) anything that ships with the product. Third party
  extensions for Tcl/Tk and linkage to GTK+ and other frameworks do allow
  for graphical user interfaces" [4]. A COBOL desktop program would mostly
  be calls into a C toolkit through third-party glue.
- **COBOL's own screens are text screens.** The language's SCREEN SECTION
  is for "text-based screens, as is a typical function on mainframe and
  midframe computers" [11], drawn in the terminal ("ncurses can be used
  to implement SCREEN SECTION" [4]). That is still a terminal program, not
  a desktop window.
- **No web framework.** The FAQ says GnuCOBOL "is more than capable of
  supporting advanced Common Gateway Interface programming" [4]. A CGI
  program does not serve HTTP itself: a separate web server must be
  installed and configured to start it for each request. GnuCOBOL ships
  no web server or web framework of its own.

So the COBOL Hello World stays a cli program. That also matches how IBM
describes COBOL's typical work today: "batch processing jobs, like
processing financial transactions, managing databases and generating
reports" [3].

## Sources
1. FIPS PUB 21-2, COBOL (ANSI X3.23-1985, ISO 1989-1985), Appendix "Development of COBOL". National Institute of Standards and Technology, 1986. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-2.pdf> (accessed 2026-11-01)
2. FIPS PUB 21-1, COBOL (ANSI X3.23-1974), Appendix "History of COBOL". National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-1.pdf> (accessed 2026-11-01)
3. What is COBOL? IBM Think (updated 2026-02-25). <https://www.ibm.com/think/topics/cobol> (accessed 2026-11-01)
4. GnuCOBOL FAQ. GnuCOBOL project. <https://gnucobol.sourceforge.io/faq/index.html> (accessed 2026-11-01)
5. ISO/IEC 1989:2002 Information technology — Programming languages — COBOL, sample pages (first edition 2002-12-01; contents "9.3 Objects", "9.3.1 Objects and classes"). ISO, via iTeh Standards. <https://cdn.standards.iteh.ai/samples/28805/3eea529d195e4bc0a570738daa1e8b5d/ISO-IEC-1989-2002.pdf> (accessed 2026-11-01)
6. Enterprise COBOL for z/OS 6.4: Industry specifications. IBM. <https://www.ibm.com/docs/en/cobol-zos/6.4.0?topic=appendixes-industry-specifications> (accessed 2026-11-01)
7. ISO/IEC 1989:2023 Programming language COBOL (catalog entry). AFNOR. <https://www.boutique.afnor.org/en-gb/standard/iso-iec-19892023/information-technology-programming-languages-their-environments-and-system-/xs140772/341896> (accessed 2026-11-01)
8. GnuCOBOL (home page, releases). GnuCOBOL project. <https://gnucobol.sourceforge.io/> (accessed 2026-11-01)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
10. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
11. GnuCOBOL Programmer's Guide (SCREEN SECTION). Gary L. Cutler. <https://gnucobol.sourceforge.io/HTML/gnucobpg.html> (accessed 2026-11-01)
