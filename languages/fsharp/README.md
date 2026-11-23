# F#

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** functional, with object-oriented and imperative features
(multi-paradigm). Don Syme, the designer, coined the term "functional-first"
for the way F# is used in practice: "functional prototyping followed by
elements of object programming (for software engineering and interop) and
imperative programming (for performance)" [1]. Microsoft describes F# as a
language with first-class functions, pattern matching, and "full support for
objects" [2].

See also: [paradigms](../../docs/paradigms.md#functional)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | .NET 10 SDK (`dotnet`), F# 10 | ✅ |

## History
Don Syme designed F# at Microsoft Research in Cambridge, United Kingdom [1].
Syme describes the genesis of F# in 2002, and the first release, version
0.1, was made on 2002-06-04 as an addition to the ILX project [1]. The
website of that release described F# as "an implementation of the core of the Caml
programming language for the .NET Framework, along with cross-language
extensions" [1]. F# was one of several responses by advocates of
strongly-typed functional programming to the "object-oriented tidal wave" of
the mid-1990s [1].

A pre-release of F# 1.0 was declared on 2005-01-05 [1]. Microsoft took F#
into a product in the years 2007 to 2010. On 2010-04-12, the first officially
supported version, Visual F# 2.0, was released as part of Visual Studio
2010 [1]. F# 3.0, with type providers, was released on 2012-09-12 [1]. In
2014, Syme, Tomas Petricek, and Phil Trelford decided to start the F#
Software Foundation [1]. Syme describes F# today as an open-source,
cross-platform language [1].

F# runs on .NET and compiles to the intermediate language of the .NET
runtime [3]. The Common Language Infrastructure that .NET implements is
standardized as ECMA-335, which is also ISO/IEC 23271 [4]. The F# language
specification is published by the F# Software Foundation. Its latest
numbered version is 4.1, and newer features are documented through RFCs [5].
F# 10, the version used here, ships with .NET 10 and Visual Studio 2026 [6].
.NET 10 is the current long-term support (LTS) release; .NET 11, released on
2026-11-10 with F# 11, is a standard-term support (STS) release [9][10].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 2002 | First release, version 0.1 (2002-06-04) | [1] |
| 2005 | Pre-release of F# 1.0 declared (2005-01-05) | [1] |
| 2010 | Visual F# 2.0, the first officially supported version, with Visual Studio 2010 (2010-04-12) | [1] |
| 2012 | F# 3.0 with type providers (2012-09-12) | [1] |
| 2014 | The F# Software Foundation is started | [1] |
| 2026 | F# 10 with .NET SDK 10.0.404, used by `cli/` | [6][9] |
| 2026 | F# 11 with .NET 11 (2026-11-10) | [9][10] |

## Market usage today
- Stack Overflow Developer Survey 2026: 1.2% of all respondents (172 of
  14,099) are listed as using F# in the programming, scripting, and markup
  languages question [7].
- TIOBE Index, November 2026: F# is not in the top 50. It appears in the
  list "The Next 50 Programming Languages", positions 51 to 100 [8].

## Importance then and now
F# brought strongly-typed functional programming to the .NET platform, which
Syme describes as a response to the dominance of object-oriented languages
in the mid-1990s [1]. Microsoft documents it today as a language for
"succinct, robust and performant code" [2]. The market figures above show a
language used by a small share of developers [7][8].

## Comparing the categories
Only `cli` exists. It has one source file, `hello.fs`, and one project file,
`hello.fsproj`. The .NET SDK compiles them to `build/hello.dll`, and
`dotnet build/hello.dll` runs it. The other .NET languages in this
repository are [C#](../csharp/README.md) and
[Visual Basic](../visual-basic/README.md).

## Why there is no desktop version
There is no desktop version because this repository covers F# with the `cli`
category only. The scope is a choice of this repository, not a limit of the
language: F# runs on .NET [3], and the [C#](../csharp/README.md) folders show
what the same platform offers.

## Why there is no web version
There is no web version because this repository covers F# with the `cli`
category only. The scope is a choice of this repository, not a limit of the
language: F# runs on .NET [3], and the [Visual Basic web](../visual-basic/web/)
folder shows an ASP.NET Core program on the same platform.

## Sources
1. The Early History of F#. Don Syme, Proceedings of the ACM on Programming Languages 4 (HOPL), 2020, DOI 10.1145/3386325. Author's PDF. <https://fsharp.org/history/hopl-final/hopl-fsharp.pdf> (accessed 2026-11-11)
2. What is F#. Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/what-is-fsharp> (accessed 2026-11-11)
3. `dotnet build` command. .NET CLI. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build> (accessed 2026-11-11)
4. Standard ECMA-335, Common Language Infrastructure (CLI). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-335/> (accessed 2026-11-11)
5. F# language specification. F# Software Foundation. <https://fsharp.org/specs/language-spec/> (accessed 2026-11-11)
6. "What's new in F# 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/whats-new/fsharp-10> (accessed 2026-11-11)
7. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
8. TIOBE Index for November 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-11)
9. Microsoft .NET release index (release metadata: channel, latest SDK, release type). Microsoft. <https://builds.dotnet.microsoft.com/dotnet/release-metadata/releases-index.json> (accessed 2026-11-20)
10. "What's new in F# 11". Microsoft Learn. <https://learn.microsoft.com/dotnet/fsharp/whats-new/fsharp-11> (accessed 2026-11-20)
