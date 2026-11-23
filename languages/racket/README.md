# Racket

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional [3][4], with a library of classes and objects [4].
The home page says "While Racket is a functional language, it has offered a
sub-language of classes and objects, mixins and traits, from the beginning" [4],
and the Racket Manifesto describes the project as one that makes Racket "a
programming language for creating new programming languages" [1].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Racket 9.3 CS (Minimal Racket, `racket hello.rkt`) | ✅ |

## History

Racket began as PLT Scheme. The authors of the Racket Manifesto write that in
1995 they "set out to create an outreach project for novice programmers" [1].
They found that nobody could teach Scheme in an hour and then focus on the essence
of programming, so they decided to build their own teaching language and a
pedagogical programming environment, and to use Scheme to build both [1]. The
project was a Scheme project from the start: the Racket Guide
calls Racket "a dialect of Lisp and a descendant of Scheme" [3], and the macro
history paper says that Racket, "then called PLT Scheme", was "firmly in
the Scheme camp" [5].

Over time the team adapted Scheme to its needs. It built a syntax extension
system on top of Scheme's macros, added mechanisms for safe abstractions, and
turned features of the operating system into language constructs [1]. By 2010
the dialect had "evolved so much" that the team renamed it Racket [1]. The
announcement, posted on 2010-06-07, says that Racket, "formerly PLT Scheme, is
a product of over 15 years of development" and that the new name reflects the
view that this is the beginning of its evolution [2]. The home page
notes that the IDE, DrRacket, is the successor of DrScheme [4].

The reference implementation has two variants. The CS variant, built on Chez
Scheme as its core compiler and runtime system, has been the default since
Racket 8.0 [6]. This repository uses Racket 9.3, released in August 2026 [7][11].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1995 | The PLT project begins: a teaching language and environment built with Scheme | [1] |
| 2010-06-07 | PLT Scheme is renamed Racket | [2] |
| 2015 | The Racket Manifesto states the principles of the 20-year development | [1] |
| 2021 | Racket 8.0: the CS variant (Chez Scheme) becomes the default implementation | [6][13] |
| 2026-08 | Racket 9.3, the version used here | [7][11] |

## Market usage today

- TIOBE Index, November 2026: Racket is not listed among the top 50, and the
  list of ranks 51 to 100 does not name it [8].
- Stack Overflow Developer Survey 2026: Racket is not among the 51 answers
  of the programming, scripting, and markup languages question [9].

Racket is therefore a niche language by these measures. Its home page lists
education programs (Program by Design, Bootstrap) and a summer school
among its community activities [4].

## Importance then and now

When the project started in 1995, its purpose was teaching: a language and an
environment made for beginners rather than a professional's power tool [1].
The project then grew into what its authors call a language for building languages. A
programmer writes each module in the language that suits it, and every such
language is built with Racket's macro system [1][4].

Today Racket is a mature, general-purpose language with its own IDE, DrRacket,
a GUI toolbox, a web server, and a package system [4]. Its
home page still lists teaching programs among the project's activities [4].

## Comparing the categories

Only the `cli` category is implemented. The program is one file with one
expression. `racket hello.rkt` loads the module, compiles it in memory, and
runs it, so there is no build step [10]. The `cli` implementation uses Minimal
Racket, the smallest official distribution, which "includes just enough of
Racket that you can use `raco pkg` to install more" [11].

## Why there is no desktop or web version

This repository includes only the `cli` category for Racket; a desktop
or web version is not included. The installation used here is Minimal
Racket, and this distribution has no graphical library: `racket -l
racket/gui/base` fails there with "cannot open module file", because the GUI
toolkit lives in the separate package `gui-lib` [12]. The full distribution
adds DrRacket and more libraries [11], so a desktop or web program would
need that larger installation. The `cli` category runs from start to finish
with the minimal distribution.

## Sources

1. The Racket Manifesto. Matthias Felleisen, Robert Bruce Findler, Matthew Flatt, Shriram Krishnamurthi, Eli Barzilay, Jay McCarthy, Sam Tobin-Hochstadt. SNAPL 2015. <https://www2.ccs.neu.edu/racket/pubs/manifesto.pdf> (accessed 2026-11-12)
2. Racket. Eli Barzilay. Racket blog, 2010-06-07. <https://blog.racket-lang.org/2010/06/racket.html> (accessed 2026-11-12)
3. The Racket Guide, chapter 1 "Welcome to Racket". Racket project. <https://docs.racket-lang.org/guide/intro.html> (accessed 2026-11-12)
4. Racket, the Programming Language (home page). Racket project. <https://racket-lang.org/> (accessed 2026-11-12)
5. From Macros to DSLs: The Evolution of Racket. Ryan Culpepper, Matthias Felleisen, Matthew Flatt, Shriram Krishnamurthi. SNAPL 2019. <https://www2.ccs.neu.edu/racket/pubs/snapl19-cffk.pdf> (accessed 2026-11-12)
6. The Racket Reference, section "Implementations". Racket project. <https://docs.racket-lang.org/reference/implementations.html> (accessed 2026-11-12)
7. Racket v9.3 release announcement. Racket blog, August 2026. <https://blog.racket-lang.org/2026/08/racket-v9-3.html> (accessed 2026-11-12)
8. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-12)
9. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
10. The Racket Guide, section 6.1 "Module Basics". Racket project. <https://docs.racket-lang.org/guide/module-basics.html> (accessed 2026-11-12)
11. Racket v9.3 download page (Minimal Racket and full distribution). Racket project. <https://download.racket-lang.org/releases/9.3/> (accessed 2026-11-12)
12. The Racket Graphical Interface Toolkit (package `gui-lib`). Racket project. <https://docs.racket-lang.org/gui/> (accessed 2026-11-12)
13. Racket v8.0. Racket blog, 2021-02-13. <https://blog.racket-lang.org/2021/02/racket-v8-0.html> (accessed 2026-11-20)
