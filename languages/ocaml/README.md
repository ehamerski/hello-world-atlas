# OCaml

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional [1][3], with object-oriented features [4] and
imperative features [3]. The manual calls OCaml "a functional language" and
adds that it is also "equipped with full imperative features" [3].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | OCaml 5.5.2 (`ocamlopt`, Homebrew formula built from source) | ✅ |

## History

Caml began at Inria. The Formel team at Inria became interested in the language ML in
1980–1981. ML was the meta-language of the Edinburgh version of the LCF proof
assistant, and Robin Milner designed both [1]. Between 1984 and 1987,
Pierre-Louis Curien, Ascánder Suárez, and Guy Cousineau designed and
implemented the first complete Caml implementation, Caml V3.1. It compiled
Caml to bytecode for the Categorical Abstract Machine. Inria distributed it
free of charge from 1987 [1]. The name Caml was originally an acronym for
Categorical Abstract Machine Language [1].

In 1990 and 1991, Xavier Leroy designed a new implementation, Caml Light,
which used a bytecode interpreter written in C. Damien Doligez contributed
its memory management system [1]. In 1995, Leroy released Caml Special Light.
It added an optimizing native-code compiler and a module system [1].

Type-theoretic work by Didier Rémy and Jérôme Vouillon allowed the object-oriented
features to join the type system. This led to the release of Objective Caml
in 1996 [1]. Jacques Garrigue added optional arguments and polymorphic
variants in 2000 [1]. The official name of the language became OCaml in
2011 [1]. OCaml development continues in the Cambium team at Inria [1].

OCaml 5.0, released on 2022-12-16, introduced a new runtime system with
support for shared-memory parallelism and effect handlers [1][8]. This
repository uses OCaml 5.5.2, released on 2026-10-23 [9]. Homebrew packages it as the formula
`ocaml` [10].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1980–1981 | The Formel team at Inria becomes interested in ML | [1] |
| 1987 | Caml V3.1 (designed 1984–1987) is distributed free of charge | [1] |
| 1990–1991 | Xavier Leroy designs Caml Light | [1] |
| 1995 | Caml Special Light adds a native-code compiler and a module system | [1] |
| 1996 | Objective Caml is released | [1] |
| 2000 | Optional arguments and polymorphic variants (Jacques Garrigue) | [1] |
| 2011 | The official name becomes OCaml | [1] |
| 2022-12-16 | OCaml 5.0.0: new runtime, shared-memory parallelism, effect handlers | [1][8] |
| 2026-10-23 | OCaml 5.5.2, the version used here | [9] |

## Market usage today

- TIOBE Index, November 2026: OCaml is at rank 34, with a rating of 0.43% [11].
- Stack Overflow Developer Survey 2026: 1.2% of all respondents (165 of
  14,099) named OCaml among the languages they had done extensive development
  work in during the past year [12].

The OCaml.org history page states that OCaml has found adoption in industry for
static analysis tools, compilers, financial systems, and web development [1].

## Importance then and now

When Objective Caml appeared in 1996, the history page describes it as the
first language to combine object-oriented programming with an ML-style
polymorphic type system and type inference [1]. The language grew out of the Formel team's work on ML at Inria [1]. The
history page describes it as gaining popularity in both academic and
industrial settings [1], and its development stays with an Inria team [1].

Today OCaml keeps that type system and, since OCaml 5.0, supports
shared-memory parallelism [8]. Its current ratings are the figures in the
previous section [11][12].

## Comparing the categories

Only the `cli` category is implemented. The program is one phrase in one
source file. `ocamlopt` compiles it into a native executable. The `ocaml`
command is a different tool: the toplevel, a read-eval-print loop that can
also run a script file [6]. `ocamlopt` produces native code that runs faster
than the bytecode of `ocamlc`, at the cost of longer compile time [5].

## Why there is no desktop version

There is no desktop version because the OCaml distribution has no graphical
toolkit. Its standard library chapter lists modules such as `Array`, `List`,
and `String`, and none for windows [7]. The manual's chapter on removed or
moved libraries names Graphics and LablTk, which are no longer part of the
distribution [2]. A desktop program needs an add-on library, which this
repository does not add for OCaml.

## Why there is no web version

There is no web version because the OCaml distribution has no web server or HTTP
library. The standard library chapter lists no such module [7], and the manual's
library chapters cover `Unix`, `Str`, `runtime_events`, threads, and dynamic linking, not HTTP [2].
A web program needs an add-on package, which this repository does not add for
OCaml.

## Sources

1. The history of OCaml. OCaml.org. <https://ocaml.org/history> (accessed 2026-11-11)
2. The OCaml Manual, release 5.5, contents. Xavier Leroy, Damien Doligez, Alain Frisch, Jacques Garrigue, Didier Rémy, Jérôme Vouillon. Inria. <https://ocaml.org/manual/5.5/index.html> (accessed 2026-11-11)
3. The core language, chapter 1 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/coreexamples.html> (accessed 2026-11-11)
4. Objects in OCaml, chapter 3 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/objectexamples.html> (accessed 2026-11-11)
5. Native-code compilation (ocamlopt), chapter 16 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/native.html> (accessed 2026-11-11)
6. The toplevel system or REPL (`ocaml`), chapter 14 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/toplevel.html> (accessed 2026-11-11)
7. The standard library, chapter 30 of The OCaml Manual, release 5.5. Inria. <https://ocaml.org/manual/5.5/stdlib.html> (accessed 2026-11-11)
8. OCaml 5.0.0 release notes. OCaml.org. <https://ocaml.org/releases/5.0.0> (accessed 2026-11-11)
9. OCaml 5.5.2 release notes. OCaml.org. <https://ocaml.org/releases/5.5.2> (accessed 2026-11-11)
10. Homebrew formula `ocaml` (version 5.5.2, license LGPL-2.1-only with the OCaml linking exception). Homebrew. <https://formulae.brew.sh/formula/ocaml> (accessed 2026-11-11)
11. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
12. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
