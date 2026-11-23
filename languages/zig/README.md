# Zig

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative [3]. A Zig program is a sequence of statements in
functions. The language overview says that control flow is managed
"exclusively with language keywords and function calls" and that the
programmer manages memory explicitly [3].

See also: [paradigms](../../docs/paradigms.md#imperative)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Zig 0.17.0 (`zig build-exe`, official tarball) | ✅ |

## History

Andrew Kelley introduced Zig in a blog post dated 2016-02-08. The post
names four goals: a language that is pragmatic, optimal, safe, and
readable, with the aim of being "more pragmatic than C" [1]. The
earliest release in the download index of ziglang.org is 0.1.1, dated
2017-10-17 [2]. Versions 0.2.0 to 0.16.0 followed between 2018 and
2026 [2].

On 2020-07-11, Kelley announced the Zig Software Foundation (ZSF), a
501(c)(3) not-for-profit corporation [4]. Its stated mission is "to promote,
protect, and advance the Zig programming language" [5]. Its board lists
Andrew Kelley as President [5].

Zig 0.17.0 is dated 2026-10-01 and is the version this repository uses. Version
0.17.1 is dated 2026-11-02 [2]. The language has not reached version
1.0: every version in the index is numbered 0.x [2].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 2016-02-08 | Andrew Kelley publishes "Introduction to the Zig Programming Language" | [1] |
| 2017-10-17 | Release 0.1.1, the earliest release in the download index | [2] |
| 2018-03-15 | Release 0.2.0 | [2] |
| 2020-07-11 | The Zig Software Foundation is announced | [4] |
| 2023-01-19 | Release 0.10.1 | [2] |
| 2026-10-01 | Release 0.17.0, the version used here | [2] |
| 2026-11-02 | Release 0.17.1 | [2] |

## Market usage today

- Stack Overflow Developer Survey 2026: 2.8% of all respondents (398 of
  14,099) named Zig among the programming, scripting, and markup languages
  they had done extensive development work in during the past year [6].
- TIOBE Index, November 2026: Zig is not in the top 50. It appears in the
  list "Next 50 Programming Languages" (positions 51 to 100), which gives
  no individual rank or rating [7].

## Importance then and now

When Kelley introduced Zig in 2016, he presented it as an alternative to C,
with the goal of being "more pragmatic than C" [1]. The language overview still
describes Zig as a competitor of C, not a language that depends on it [3].
It adds that Zig can compile C code (`zig build-exe hello.c -lc`) and
that its standard library "integrates with libc, but does not depend on it" [3].

Today Zig has a non-profit foundation behind it [4][5] and a steady
release history [2]. Its figures in the market section are small compared
with the long-established languages [6][7].

## Comparing the categories

Only the `cli` category is implemented. The program is one source file.
`zig build-exe` compiles it into a native executable. In Zig 0.17.0, `main`
receives an argument, `init`, that carries the `Io` value the program uses to
write [8][9]. This differs from C, where `printf` needs no such argument. See
[C](../c/README.md).

## Why there is no desktop version

The only category checked for Zig was `cli`. The language and its standard
library were not examined for graphical or web libraries, so no claim is made
about them. A desktop or web version needs a decision about a third-party
library, which this repository has not made for Zig.

## Why there is no web version

See the previous section: the same reason applies. Only `cli` was checked.

## Sources

1. Introduction to the Zig Programming Language. Andrew Kelley. <https://andrewkelley.me/post/intro-to-zig.html> (accessed 2026-11-12)
2. Zig download index (JSON): releases, dates, tarballs and SHA-256 digests. Zig Software Foundation. <https://ziglang.org/download/index.json> (accessed 2026-11-20)
3. Zig language overview. Zig Software Foundation. <https://ziglang.org/learn/overview/> (accessed 2026-11-12)
4. Announcing the Zig Software Foundation. Andrew Kelley, 2020-07-11. Zig Software Foundation. <https://ziglang.org/news/announcing-zig-software-foundation/> (accessed 2026-11-12)
5. Zig Software Foundation. Zig Software Foundation. <https://ziglang.org/zsf/> (accessed 2026-11-12)
6. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
7. TIOBE Index for November 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-12)
8. Zig Language Reference 0.17.0, Hello World. Zig Software Foundation. <https://ziglang.org/documentation/0.17.0/> (accessed 2026-11-12)
9. Zig standard library 0.17.0, `std.process.Init`. Zig Software Foundation. <https://ziglang.org/documentation/0.17.0/std/> (accessed 2026-11-12)
