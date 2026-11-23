# Simula

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented [1][2][3] (it began as a simulation language,
ALGOL-based, and gave the object-oriented paradigm its classes, subclasses
and virtual procedures).

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GNU Cim 5.1 (Simula 67 compiled to C) | ✅ |

## History

Ole-Johan Dahl and Kristen Nygaard designed Simula at the Norwegian Computing
Center (Norsk Regnesentral) in Oslo. Their first goal was simulation
programs, and they coined the name Simula from simulation [2]. Nygaard
started work on the language around 1960/61. Dahl joined him in January
1962, the month of the first written account of the effort [2].

The first published description is the 1966 paper "Simula: an ALGOL-based
simulation language" in *Communications of the ACM* [1]. In May 1967, the
paper "Class and subclass declarations" was presented at the IFIP TC 2
conference on simulation languages at Lysebu, Oslo; it introduced the class,
subclass and virtual-quantity concepts of Simula 67 [2].

On 10 February 1968 the Simula Standards Group accepted the report
*Simula 67 Common Base Language* [2][3]. That report is the definition
that every Simula 67 compiler must implement, and this repository's
implementation follows it [3][5].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| c. 1960/61 | Kristen Nygaard starts work on a simulation language at the Norwegian Computing Center | [2] |
| 1962 | First written account of the effort and Ole-Johan Dahl joins the work (January); first specification of the language (May) | [2] |
| 1966 | "Simula: an ALGOL-based simulation language" published in *Communications of the ACM* 9(9) | [1] |
| 1967 | "Class and subclass declarations" presented at the IFIP TC 2 conference, Lysebu, Oslo (May) | [2] |
| 1968 | Simula Standards Group accepts the *Simula 67 Common Base Language* report (10 February); the report is dated 1968 | [2][3] |
| 2001 | Dahl and Nygaard share the ACM A. M. Turing Award | [4] |

## Market usage today

No current usage survey lists Simula, so this page gives no usage
figure. Two compilers that run Simula 67 today are GNU Cim, used in
this repository [5], and Portable Simula Revisited [6].

## Importance then and now

Simula 67 is the language in which classes, subclasses, inheritance and
virtual procedures first appeared together. The ACM citation for the 2001
award credits Dahl and Nygaard with ideas fundamental to object-oriented
programming through Simula I and Simula 67 [4] (paraphrased here). The
report NR 743 defines "virtual quantities" and class declarations [3].
Modern languages inherited those ideas, so the cli program here is also a
short look at the form they took first.

## Comparing the categories

Only the `cli` category is implemented. The Simula 67 Common Base defines
output procedures such as `outtext` and `outimage` (report NR 743) but no
window or network procedures: a text search of the report finds none.

## Why there is no desktop version

The Common Base report defines no window or graphics procedures (text search
of NR 743), so a desktop program in plain Simula 67 would need a
platform-specific library. This repository does not add one.

## Why there is no web version

The Common Base report defines no network or socket procedures (text search of
NR 743). A web server would also need an external library, which this
repository does not add.

## Sources

1. Dahl, Ole-Johan and Nygaard, K. "Simula: an ALGOL-based simulation language". *Communications of the ACM* 9(9), 1966, pp. 671–678. <https://doi.org/10.1145/365813.365819> (accessed 2026-11-10; the publisher's page refuses automated requests, metadata record: <https://api.crossref.org/works/10.1145/365813.365819>, accessed 2026-11-20)
2. Krogdahl, S. "The Birth of Simula". University of Oslo, Department of Informatics. <https://www.mn.uio.no/english/services/it/simula/bibliography/history/sk-the-birth-of-simula.pdf> (accessed 2026-11-10)
3. Dahl, Ole-Johan, Myhrhaug, B. and Nygaard, K. *Simula 67 Common Base Language*. Norwegian Computing Center, report NR 743, 1968 (revised 1970, 1982, 1984). <https://www.softwarepreservation.org/projects/ALGOL/manual/NR_report_743_Dahl_Myhrhaug_Nygaard_Simula-67-Common-Base-Language.pdf> (accessed 2026-11-10)
4. ACM A. M. Turing Award, 2001: Kristen Nygaard (the award is shared with Ole-Johan Dahl). ACM. <https://awards.acm.org/award_winners/nygaard_5916220> (accessed 2026-11-10; archived copy: <https://web.archive.org/web/20251014165846/https://awards.acm.org/award_winners/nygaard_5916220>, accessed 2026-11-20)
5. GNU Cim. GNU Project. <https://www.gnu.org/software/cim/cim.html> (accessed 2026-11-10; archived copy: <https://web.archive.org/web/20261005162711/http://www.gnu.org/software/cim/cim.html>, accessed 2026-11-22)
6. Portable Simula Revisited. <https://portablesimula.github.io/github.io/> (accessed 2026-11-20)
