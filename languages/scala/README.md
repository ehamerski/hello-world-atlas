# Scala

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm: functional and object-oriented. The authors
describe Scala as a language that "fuses object-oriented and functional
programming in a statically typed programming language" [1]. The Scala 3
Book says that Scala is "an object-oriented programming (OOP) language" and
"a functional programming (FP) language" [2].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | JDK 21, Scala 3.10.1 (`scalac`, `scala`) | ✅ |

## History
Martin Odersky and his group at the École Polytechnique Fédérale de Lausanne
(EPFL) designed Scala. The Scala project's history page says: "Scala was
designed from 2001 by Martin Odersky and his group at EPFL in Lausanne,
Switzerland." [3] A first public release followed in 2003, and a redesigned
version, Scala 2.0, was released in 2006 [3].

The language targets the Java Virtual Machine (JVM): Scala code runs on the
JVM [2]. The authors give the aim of the language in their overview paper:
Scala is "aimed at the construction of components and component systems",
and the paper postulates that a language can support components at scale by
unifying and generalizing object-oriented and functional programming [1].

The Scala 3 announcement dates the first commit of the Scala 3 project to
2012-12-06 [4]. The project announced "Scala 3 is
finally out" on 2021-05-14 [4]. Scala 3.10.1, the version used here, was
published on 2026-11-11 [5].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 2001 | Design of Scala starts at EPFL | [3] |
| 2003 | First public release | [3] |
| 2006 | Scala 2.0, a redesigned version | [3] |
| 2012 | First commit of the Scala 3 project (2012-12-06) | [4] |
| 2021 | Scala 3 announced as released (2021-05-14) | [4] |
| 2026 | Scala 3.10.1 published (2026-11-11), used by `cli/` | [5] |

## Market usage today
- Stack Overflow Developer Survey 2026: 2.2% of all respondents (309 of
  14,099) are listed as using Scala in the programming, scripting, and markup
  languages question [6].
- TIOBE Index, November 2026: Scala is in position 38, with a rating of
  0.34% [7].

## Importance then and now
When Scala appeared, its authors set out to join object-oriented and
functional programming in one statically typed language that runs on the
JVM [1][2][3]. Today the Scala project continues the language with Scala 3
releases such as 3.10.1 [5]. The market figures above show a language used
by a small share of developers [6][7].

## Comparing the categories
Only `cli` exists. It has one source file, `hello.scala`, that the Scala 3
compiler turns into JVM class files, and the `scala` command runs them.
Another JVM language is in [Kotlin](../kotlin/README.md) and
[Java](../java/README.md).

## Why there is no desktop version
There is no desktop version because this repository covers Scala with the
`cli` category only. The scope is a choice of this repository, not a limit of
the language: Scala code runs on the JVM [2], and the
[java/desktop-swing](../java/desktop-swing/) folder shows a desktop
program on the same platform.

## Why there is no web version
There is no web version because this repository covers Scala with the `cli`
category only. The scope is a choice of this repository, not a limit of the
language: Scala code runs on the JVM [2], and the [java/web](../java/web/)
folder shows a web program on the same platform.

## Sources
1. An Overview of the Scala Programming Language, Second Edition. Martin Odersky et al. École Polytechnique Fédérale de Lausanne (EPFL), Technical Report LAMP-REPORT-2006-001. <https://www.scala-lang.org/docu/files/ScalaOverview.pdf> (accessed 2026-11-11)
2. Scala 3 Book, "Scala features". Scala project. <https://docs.scala-lang.org/scala3/book/scala-features.html> (accessed 2026-11-11)
3. Scala's Prehistory. Scala project (archived site). <https://www.scala-lang.org/old/node/239> (accessed 2026-11-11)
4. Scala 3 is here! Anatolii Kmetiuk, Scala blog, 2021-05-14. <https://www.scala-lang.org/blog/2021/05/14/scala3-is-here.html> (accessed 2026-11-11)
5. Release 3.10.1. scala/scala3. GitHub. <https://github.com/scala/scala3/releases/tag/3.10.1> (accessed 2026-11-20)
6. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
7. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
