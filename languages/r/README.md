# R

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional and object-oriented [6]. The language definition says
that the syntax resembles C but "the semantics are of the FPL (functional
programming language) variety with stronger affinities with Lisp and APL" [6].
The same manual explains how R supports object-oriented programming with
classes and generic functions [6].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | R 4.6.2 (`Rscript`, Homebrew formula built from source) | ✅ |

## History

R is a system for statistical computation and graphics. It consists of a
language and a run-time environment [3]. Ross Ihaka and Robert Gentleman
wrote it at the Department of Statistics of the University of Auckland in New
Zealand [3]. The name comes partly from the first names of the two authors
and partly from a play on the name of the Bell Labs language S [3].

Ihaka describes R as an experiment: its authors set out to use the methods of
Lisp implementers to build a small testbed for ideas about a statistical
environment. They then chose an S-like syntax [2]. The design is influenced by
S and by Scheme: the language looks like S, and its implementation and
semantics come from Scheme [3]. S was developed at Bell Laboratories by John
Chambers and colleagues [5].

The authors placed binary copies of R at Statlib and announced them on the
s-news mailing list in August 1993 [2]. In June 1995, at the urging of Martin
Mächler, they released the source code by ftp under the GNU General Public
License [2]. Ihaka and Gentleman described their design experience in the
paper "R: A Language for Data Analysis and Graphics" (1996) [1]. The first R
mailing list, r-testers, started in March 1996 [2]. In mid-1997, the authors
established a larger core group, the R Core Team, with write access to the
source archive [2][3]. R 1.0.0 was released on 2000-02-29 [4]. The release
statement says that version 1.0.0 marks a stable base language and a stable
application programming interface (API) for extension writers [5].

This repository uses R 4.6.2, released in 2026 and dated 2026-10-29 in its
manuals [6]. Homebrew packages it as the formula `r` [9].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1993 | Binaries of R announced on the s-news mailing list (August) | [2] |
| 1995 | Source code released under the GNU General Public License (June) | [2] |
| 1996 | Ihaka and Gentleman publish "R: A Language for Data Analysis and Graphics" | [1] |
| 1997 | The R Core Team forms (mid-1997) | [2][3] |
| 2000 | R 1.0.0 released (2000-02-29) | [4][5] |
| 2026 | R 4.6.2 (2026-10-29), the version used here | [6] |

## Market usage today

- TIOBE Index, November 2026: R is at rank 7, with a rating of 2.27%. It was
  at rank 12 in November 2025 [10].
- Stack Overflow Developer Survey 2026: 4.5% of all respondents (639 of
  14,099) named R among the languages they had done extensive development work
  in during the past year [11].

## Importance then and now

The 1.0.0 release statement describes R as a language and environment for
statistical computing and graphics. R implements a dialect of S, and users
add functionality through packages from the Comprehensive R Archive Network
(CRAN) [5]. The source has been free software under the GNU General Public
License since 1995 [2]. Today R is in the top 10 of the TIOBE Index [10].

## Comparing the categories

Only the `cli` category is implemented. R is interpreted: the core of R is an
interpreted computer language [3]. `Rscript` runs a file without an interactive
session, so the program has no build step [12]. The `R` command, started
without a file, issues a prompt and waits for commands [12].

## Why there is no desktop version

The `tcltk` package, which uses the Tcl/Tk toolkit, is part of R itself
[7]. The package needs Tcl/Tk on the system: R's installation manual says
that `tcltk` "needs Tcl/Tk ≥ 8.4 installed", and the macOS installer lists the
Tcl/Tk component, which `tcltk` needs, as optional [7]. This repository does
not add a desktop program for R.

## Why there is no web version

There is no web version because a web server for R comes from an add-on
package. The CRAN package `shiny` is described as a web application framework
for R [8]. The R distribution does not include it, and this repository does
not add it.

## Sources

1. Ross Ihaka and Robert Gentleman. R: A Language for Data Analysis and Graphics. Journal of Computational and Graphical Statistics, 5(3), 299–314, 1996. <https://doi.org/10.1080/10618600.1996.10474713> (accessed 2026-11-11; the publisher site refuses automated access, so the citation is checked against section 2.7 of the R FAQ [3])
2. Ross Ihaka. R: Past and Future History, draft paper for Interface '98. Archived copy of the author's page at the University of Auckland. <https://web.archive.org/web/2020/https://www.stat.auckland.ac.nz/~ihaka/downloads/Interface98.pdf> (accessed 2026-11-11)
3. R FAQ. Kurt Hornik and the R Core Team. CRAN. <https://cran.r-project.org/doc/FAQ/R-FAQ.html> (accessed 2026-11-11)
4. R-1.0.0 is released. Peter Dalgaard, R-announce mailing list, 2000-02-29. ETH Zurich. <https://stat.ethz.ch/pipermail/r-announce/2000/000127.html> (accessed 2026-11-11)
5. R 1.0.0 Release Statement. R Core Team. CRAN. <https://cran.r-project.org/R-release-1.0.0.html> (accessed 2026-11-11)
6. The R Language Definition, for R 4.6.2 (2026-10-29). R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-lang.html> (accessed 2026-11-11)
7. R Installation and Administration, for R 4.6.2 (2026-10-29). R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-admin.html> (accessed 2026-11-20)
8. shiny: Web Application Framework for R. CRAN package page. <https://cran.r-project.org/package=shiny> (accessed 2026-11-11)
9. Homebrew formula `r` (version 4.6.2, license GPL-2.0-or-later). Homebrew. <https://formulae.brew.sh/formula/r> (accessed 2026-11-11)
10. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
11. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
12. An Introduction to R, for R 4.6.2 (2026-10-29), section 1.5 and appendix B. R Core Team. CRAN. <https://cran.r-project.org/doc/manuals/r-release/R-intro.html> (accessed 2026-11-11)
