# ALGOL 68

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative [11][12] (ALGOL is a family of imperative languages; ALGOL 68 lets the implementation choose the order in which some constructs are elaborated, which the Revised Report calls collateral elaboration, and it has a parallel clause for parallel programming (sections 0.2.4 and 3.3) [1]).

See also: [paradigms](../../docs/paradigms.md#imperative)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Algol 68 Genie 3.13.4 interpreter, built from source | ✅ |

## History

In 1960, an international committee published the language ALGOL 60 [5]. Two years later, the committee saw that the language needed corrections and a wider range of applications, and the International Federation for Information Processing (IFIP) set up Working Group 2.1 (WG 2.1) to design a successor [5]. The Revised Report says that WG 2.1 discussed the successor, called "ALGOL X", from 1963 [1].

At the October 1965 meeting near Grenoble, three descriptions of a complete language were on the table, by Niklaus Wirth, Gerhard Seegmueller, and Aad van Wijngaarden [1]. The group did not agree. Wirth describes two factions: one wanted a second milestone after ALGOL 60 with "radically new, untested concepts", and it "later became known as Algol 68"; the other wanted realistic improvements [5]. Wirth's modest proposal lost by a small majority, and he built it as ALGOL W [5]. The Genie documentation adds that the same faction later produced Pascal [11].

A team in Amsterdam wrote the Report: A. van Wijngaarden, B. J. Mailloux, J. E. L. Peck, and C. H. A. Koster [1]. WG 2.1 adopted the final version in Munich on 1968-12-20 [1]. At that meeting, some members who were unhappy with the covering letter that accompanied the Report produced a minority report [4]. The Report was published in *Numerische Mathematik* in 1969 [1][3].

The language was then revised. At Novosibirsk in August 1971, WG 2.1 decided to produce a Revised Report by the end of 1973 [4]. Eight editors worked on it: A. van Wijngaarden, B. J. Mailloux, J. E. L. Peck, C. H. A. Koster, M. Sintzoff, C. H. Lindsey, L. G. L. T. Meertens, and R. G. Fisker [1]. The Los Angeles meeting accepted the Revised Report in September 1973, subject to editorial polishing [4]. It appeared in *Acta Informatica* 5 in 1975 [2]. The Revised Report states that it is "the final definition of the language ALGOL 68" [1], so it replaces the 1968 Report.

Marcel van der Veer wrote Algol 68 Genie. Its development started around 1990, with alpha and beta releases in 2001 and 2002, and version 3 revisions have appeared since 2022 [12]. Genie implements, in the words of its documentation, "practically full Algol 68 as defined by the Revised Report" [11]. This repository pins version 3.13.4, which is the version tested on the development machine. The Genie site lists 3.14.0, released on 2026-11-09, as its current download [12].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1960 | An international committee publishes ALGOL 60 | [5] |
| 1963 | WG 2.1 begins to discuss a successor, "ALGOL X"; ALGOL 60 is revised the same year | [1][11] |
| 1965 | Proposals by Wirth, Seegmueller, and van Wijngaarden at the Grenoble meeting (October) | [1] |
| 1968 | WG 2.1 adopts the Report on the Algorithmic Language ALGOL 68 in Munich (20 December) | [1][4] |
| 1969 | The Report appears in *Numerische Mathematik* 14, pages 79–218 | [1][3] |
| 1971 | WG 2.1 decides at Novosibirsk to produce a Revised Report (August) | [4] |
| 1973 | WG 2.1 accepts the Revised Report at Los Angeles, subject to polishing (September) | [4] |
| 1975 | The Revised Report appears in *Acta Informatica* 5, pages 1–236 | [2] |
| 2001 | First alpha and beta releases of Algol 68 Genie (2001–2002) | [12] |
| 2022 | Version 3 of Algol 68 Genie begins | [12] |
| 2026 | Algol 68 Genie 3.14.0 is released (9 November); GCC 16 includes an experimental ALGOL 68 front end, `ga68` | [12][15] |

## Market usage today

TIOBE Index, November 2026: ALGOL 68 does not appear among the 100 languages the index lists [14]. No other current usage figure for ALGOL 68 was found in an accessible source. The Genie project states that it preserves ALGOL 68 "out of educational as well as scientific-historical interest" [12]. GCC 16 ships `ga68`, an experimental ALGOL 68 compiler [15].

## Importance then and now

The Revised Report says that its authors designed ALGOL 68 to communicate algorithms, to execute them efficiently on many computers, and to aid in teaching them [1]. It states that ALGOL 68 "has not been designed as an expansion of ALGOL 60 but rather as a completely new language" [1]. It introduces modes (a generalization of types), structured values, unions of modes, routines as values, and a heap with garbage collection [1].

The Genie documentation calls ALGOL 68 the first major language for which a full formal definition was written before it was implemented [11]. It was not widely used [11]. Lindsey gives the reason: "because it was not implemented widely enough, or soon enough" [4]. Wirth gives a harsher judgment: the language "sank quickly into obscurity under its own weight, although a few of its concepts did survive into subsequent languages" [5].

Today, ALGOL 68 matters as a historical language and a teaching language. Genie still runs it, and the GCC project has a new compiler for it [12][15]. The section [Descendants and influence](#descendants-and-influence) shows what later languages took from it.

## Descendants and influence

Each link below was checked against the primary source. Of the four languages in the table, only C is supported as influenced by ALGOL 68 (on specific features). For Pascal, Simula, and the Bourne shell the sources show no descent from ALGOL 68.

| Language | What the sources show | Supported as a descent from ALGOL 68? |
|---|---|---|
| C | Ritchie names ALGOL 68 as a source of C's type structure, casts, and the `x=+y` operator notation [7] | Yes, in part: an influence on specific features |
| Pascal | Wirth traces Pascal to ALGOL 60 and ALGOL W, and describes ALGOL 68 as the rival proposal [5][6] | No |
| Simula | The Simula 67 report builds on ALGOL 60 and does not mention ALGOL 68 [8] | No |
| Bourne shell | Bourne compares shell commands to ALGOL 68 procedure calls and wrote an ALGOL 68 compiler [10] | Not stated by a primary source |

### C

See also the [C](../c/README.md) language page.

Dennis Ritchie, "The Development of the C Language" (HOPL-II, 1993), names three features that C took from ALGOL 68 [7].

In the section "Embryonic C", he writes about C's type system:

> The scheme of type composition adopted by C owes considerable debt to Algol 68, although it did not, perhaps, emerge in a form that Algol's adherents would approve of. The central notion I captured from Algol was a type structure based on atomic types (including structures), composed into arrays, pointers (references), and functions (procedures). Algol 68's concept of unions and casts also had an influence that appeared later.

In the section "More History", he writes about assignment operators:

> B introduced generalized assignment operators, using x=+y to add y to x. The notation came from Algol 68 [Wijngaarden 75] via McIlroy, who had incorporated it into his version of TMG.

In the section "Portability", Ritchie adds that C's notation for type conversions, the cast, takes its name from the example of ALGOL 68 [7].

The link has limits, and Ritchie states them. C did not implement ALGOL 68: in "More History", he writes that "Although we entertained occasional thoughts about implementing one of the major languages of the time like Fortran, PL/I, or Algol 68, such a project seemed hopelessly large for our resources" [7]. In "Critique", he contrasts the two languages on arrays: ALGOL 68 arrays "either have fixed bounds, or are `flexible'", which needs "considerable mechanism" in the definition and in compilers, while C uses a simpler approach [7]. Lindsey agrees that C was influenced by ALGOL 68, and adds that "the syntactic sugar is bizarre and C is not so strongly typed" [4] (section 2.3.4.3).

The kind of link: **influence on specific features** (type composition, unions, casts, one operator notation). C is not a descendant of ALGOL 68 in the sense of a successor language.

### Pascal

See also the [Pascal](../pascal/README.md) language page.

Wirth's own account does not name ALGOL 68 as a source of Pascal. In "50 Years of Pascal" (*Communications of the ACM*, March 2021), he writes that Pascal was designed after he left WG 2.1 in 1966, and that the result of his own proposal was ALGOL W [5]. He continues: "The milestone Algol 68 did appear and then sank quickly into obscurity under its own weight, although a few of its concepts did survive into subsequent languages" [5]. The sentence does not name Pascal among those languages. He describes Pascal as having "its precursor Algol 60" [5]. The abstract of his 1971 paper "The Programming Language Pascal" says Pascal "was developed on the basis of Algol 60" [6].

The Genie documentation, written by an ALGOL 68 implementer, agrees: the members around Wirth and Hoare "wanted to shorten the development cycle by improving Algol 60, which eventually produced Algol W and later Pascal" [11]. Lindsey writes that ALGOL 68 "is alive and well and living in Pascal, or C, or C++, or SML, or Ada", and that this is "true in part for all of these languages" [4] (section 2.8.1). He does not say which features Pascal took from ALGOL 68.

This link is **not supported** as a descent. The sources show that Pascal and ALGOL 68 are siblings in the ALGOL family: both follow ALGOL 60, and Pascal comes from the faction that lost the vote on ALGOL 68 [5][11].

### Simula

See also the [Simula](../simula/README.md) language page.

The Simula 67 Common Base Language report (Norwegian Computing Center, report NR 743) states why its authors started from ALGOL 60: "The reason for choosing ALGOL 60 as a starting point was that its basic structure lent itself to extension" [8] (section 1.3.1). The report cites the ALGOL 60 Revised Report and no ALGOL 68 document, and a text search of the report finds no mention of ALGOL 68 [8]. Krogdahl's history of the birth of Simula says the first Simula language "resembled Algol" and describes the work as building on an ALGOL compiler [9]. It does not mention ALGOL 68 either.

The dates agree with that finding. The Simula Standards Group accepted the Common Base report on 1968-02-10 [9], and WG 2.1 adopted the ALGOL 68 Report on 1968-12-20 [1].

The only contact between the two languages in the sources is a preference. Lindsey writes that Hoare, who had misgivings about ALGOL 68, "much preferred the way things had been done in SIMULA 67" [4]. That is an opinion about design, not a link.

This link is **not supported** as a descent or an influence. The sources show that both languages are part of the ALGOL family, as the Genie documentation also states [11].

### Bourne shell

Stephen Bourne's paper "The UNIX Shell" (*Bell System Technical Journal*, 1978) says: "Commands are similar to procedure calls in languages such as Algol 68 or PL/I" [10] (section II). The contributor notes in the same journal issue say that Bourne has been a member of IFIP WG 2.1 since 1972 and "has written a compiler for a dialect of ALGOL 68 called ALGOL68c" [10]. The shell language closes `if` with `fi` and `case` with `esac` [10], and the ALGOL 68 Revised Report uses the same closing words [1]. The Seventh Edition source of the shell defines C macros named `IF`, `THEN`, `FI`, `BEGIN`, and `END` in the file `mac.h` [13].

No primary source in this list states that Bourne took the shell's keywords from ALGOL 68. The facts are an author with ALGOL 68 experience, a comparison to ALGOL 68 procedure calls, and keywords of the same form. This README therefore does not record the Bourne shell as a descendant. The same limit applies to any other page that mentions the shell.

## Comparing the categories

Only the `cli` category is provided. Neither a desktop nor a web version is offered, for the reasons in the next two sections. Algol 68 Genie is an interpreter, so the program runs with `a68g hello.a68` and no build step [12]. The Genie documentation describes the interpreter as "like Python" [12].

## Why there is no desktop version

There is no desktop version because ALGOL 68 defines no window or graphics facilities, and the Genie implementation offers none that a desktop program could use. The Revised Report defines transput, which is input and output to external media [1] (section 0.2.5); a text search of the Report finds no graphics, window system, or network facility. The word "window" appears only as the name of a symbol of the language [1]. Genie can draw 2-D plots through the GNU plotting utilities, and its documentation says it is "not a full Algol 68 binding for libplot" [11] (section 11.17). This binding needs a separate library and writes to an X Window System display, among other targets. It is a plotting interface, not a toolkit for application windows. The Genie binary built for this repository is not linked with that library.

## Why there is no web version

There is no web version because ALGOL 68 defines no network facilities, and Genie provides only client routines. The Revised Report contains no socket or network procedures [1]. The Genie documentation describes `https content`, which fetches a web page, and routines for a PostgreSQL client [11] (section 11.19.5). A text search of the documentation finds no routine that listens for connections. A web server in Genie would need a library that this repository does not add.

## Sources

<!-- vale off -->


1. van Wijngaarden, A. et al. *Revised Report on the Algorithmic Language ALGOL 68*. IFIP Working Group 2.1; edition with errata to 1978, ALGOL Bulletin 47 supplement. Software Preservation Group, Computer History Museum. <https://www.softwarepreservation.org/projects/ALGOL/report/Algol68_revised_report-AB-600dpi.pdf> (accessed 2026-11-11)
2. van Wijngaarden, A. et al. "Revised report on the algorithmic language ALGOL 68". *Acta Informatica* 5, 1975, pp. 1–236. Springer. <https://link.springer.com/article/10.1007/BF00265077> (accessed 2026-11-11)
3. van Wijngaarden, A. (ed.), Mailloux, B. J., Peck, J. E. L., and Koster, C. H. A. "Report on the Algorithmic Language ALGOL 68". *Numerische Mathematik* 14, 1969, pp. 79–218. Springer. <https://link.springer.com/article/10.1007/BF02163002> (accessed 2026-11-11)
4. Lindsey, C. H. "A History of ALGOL 68". In *History of Programming Languages II*, ACM, 1996, pp. 27–84. PDF at the ALGOL 68 Support site. <https://algol68-lang.org/docs/lindsey-history-of-algol68.pdf> (accessed 2026-11-11)
5. Wirth, Niklaus. "50 Years of Pascal". *Communications of the ACM* 64(3), March 2021, pp. 39–41. ACM. <https://homepages.uc.edu/~thomam/OOProg_1/articles/50%20years%20of%20pascal.pdf> (accessed 2026-11-11)
6. Wirth, Niklaus. "The programming language Pascal". *Acta Informatica* 1, 1971, pp. 35–63. Springer. <https://link.springer.com/article/10.1007/BF00264291> (accessed 2026-11-11)
7. Ritchie, Dennis M. "The Development of the C Language". Second History of Programming Languages conference (HOPL-II), ACM, 1993. Author's reprint, archived copy of bell-labs.com (2015-12-31). Internet Archive. <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (accessed 2026-11-11)
8. Dahl, Ole-Johan, Myhrhaug, B., and Nygaard, K. *Simula 67 Common Base Language*. Norwegian Computing Center, report NR 743, 1968. Software Preservation Group. <https://www.softwarepreservation.org/projects/ALGOL/manual/NR_report_743_Dahl_Myhrhaug_Nygaard_Simula-67-Common-Base-Language.pdf> (accessed 2026-11-11)
9. Krogdahl, Stein. "The Birth of Simula". University of Oslo, Department of Informatics. <https://www.mn.uio.no/english/services/it/simula/bibliography/history/sk-the-birth-of-simula.pdf> (accessed 2026-11-11)
10. Bourne, S. R. "UNIX Time-Sharing System: The UNIX Shell". *Bell System Technical Journal* 57(6), part 2, July–August 1978, from p. 1971, with the contributor notes of the same issue. Scan at Bitsavers. <https://bitsavers.mirrorservice.org/magazines/Bell_System_Technical_Journal/BSTJ_V57N06_197807_Part_2.pdf> (accessed 2026-11-11)
11. van der Veer, Marcel (ed.). *Learning Algol 68 Genie* (Algol 68 Genie 3.14, edition of November 2026). <https://algol68genie.nl/learning-algol-68-genie.pdf> (accessed 2026-11-20)
12. van der Veer, Marcel. "The Algol 68 Genie project". algol68genie.nl. <https://algol68genie.nl/en/algol-68-genie/> (accessed 2026-11-11)
13. Bourne, S. R. `mac.h`, UNIX Seventh Edition shell source (`V7/usr/src/cmd/sh/mac.h`). The Unix Heritage Society. <https://www.tuhs.org/cgi-bin/utree.pl?file=V7/usr/src/cmd/sh/mac.h> (accessed 2026-11-11)
14. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
15. GCC 16 Release Series: Changes, New Features, and Fixes. GNU Project. <https://gcc.gnu.org/gcc-16/changes.html> (accessed 2026-11-11)

<!-- vale on -->
