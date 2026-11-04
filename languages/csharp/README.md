# C#

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented, with features from other paradigms.
Microsoft describes C# this way: "Based on object-oriented principles, it
incorporates many features from other paradigms, not least functional
programming" [1]. The language history marks this turn: "C# 3.0 began to
lay the groundwork for turning C# into a hybrid Object-Oriented /
Functional language" [2]. The four programs here show both sides. The
[desktop](desktop/) version is built from classes (inheritance and
`override`). The [web](web/) and [web-angular](web-angular/) versions pass
lambdas to the framework, and the back end returns a `record`, a type that
only carries data.

See also: [paradigms](../../docs/paradigms.md#object-oriented) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | .NET SDK 10.0.403 (C# 14), base class library only (`Console`) | ✅ verified on macOS Intel |
| desktop | [desktop/](desktop/) | .NET SDK 10 + Avalonia 12.1.4 (NuGet) | ✅ verified on macOS Intel |
| web | [web/](web/) | .NET SDK 10 + ASP.NET Core 10 (Minimal API, Kestrel) | ✅ verified on macOS Intel |
| web-angular | [web-angular/](web-angular/) | ASP.NET Core 10 API + Angular 22.2 front end (Node.js, Angular CLI) | ✅ verified on macOS Intel |

All four target **.NET 10** (`net10.0`), the current Long Term Support
release [3], and are built with the `dotnet` command. The SDK is
installed into `~/.dotnet` with Microsoft's `dotnet-install.sh`, without
`sudo`; [cli/README.md](cli/README.md#scripts-explained) explains this
choice and the alternative, Microsoft's installer.

## History
- **Announcement (2000):** "Microsoft Corp. today announced Microsoft® C#
  ("C sharp"), a modern, object-oriented programming language", on
  2000-06-26, as part of Microsoft's .NET platform [4].
- **Designer:** in April 2001, Microsoft called Anders Hejlsberg "the chief
  designer of the C# programming language" [5].
- **C# 1.0 (2002):** "Released January 2002". "C# version 1.0, released
  with Visual Studio .NET 2002, looked a lot like Java" [2]. The classic
  form of the [cli](cli/Program.cs) program, shown in its comments, is
  almost the same as the [Java cli](../java/cli/).
- **Standards:** Ecma International published ECMA-334, the C# language
  specification, in December 2001 (1st edition). The current edition is the
  7th, from December 2023 [6]. ISO/IEC published it as ISO/IEC 23270
  (2003, 2006, 2018), and the 7th edition is included by reference in
  ISO/IEC 20619:2023 [6].
- **Functional features (2007):** C# 3.0, "Released November 2007",
  started the move to "a hybrid Object-Oriented / Functional language".
  Its new features included lambda expressions, implicitly typed local
  variables (`var`), and object initializers [2]. All three are used in
  the programs here.
- **Open source and cross-platform (2016):** .NET Core 1.0, released on
  2016-06-27 [7], was the start of the .NET used here.
  ".NET 5 is the next major release of .NET Core following 3.1", and
  "'Core' was dropped from the name to emphasize that this is the main
  implementation of .NET going forward" [8]. Microsoft calls it "a
  cross-platform and open-source development platform" [8]. Microsoft's
  desktop toolkits WPF and Windows Forms still run only on Windows (see
  [desktop](desktop/README.md#what-this-is)).
- **Shorter programs (2020–2021):** C# 9 (November 2020) added top-level
  statements, used by [cli](cli/), [web](web/) and the
  [web-angular](web-angular/) back end. C# 10 (November 2021) added
  `global using` directives, the basis of the "implicit usings" that every
  project here turns on [2].
- **.NET 10 and C# 14 (2025):** .NET 10 was released on 2025-11-11
  as an LTS release supported until November 2028 [3]. C# 14 was
  "Released November 2025" [2] and is the version .NET 10 uses [9].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 2000 | Microsoft announces C# (2000-06-26) | [4] |
| 2001 | ECMA-334, 1st edition (December) | [6] |
| 2002 | C# 1.0, with Visual Studio .NET 2002 (January) | [2] |
| 2003 | ISO/IEC 23270:2003 | [6] |
| 2007 | C# 3.0: the start of "a hybrid Object-Oriented / Functional language" | [2] |
| 2016 | .NET Core 1.0 (2016-06-27): open source, cross-platform | [7] |
| 2020 | .NET 5 (2020-11-10): "Core" dropped from the name. C# 9: top-level statements | [7][8][2] |
| 2021 | C# 10: `global using` directives | [2] |
| 2023 | ECMA-334, 7th edition (December); ISO/IEC 20619:2023 | [6] |
| 2025 | **.NET 10 LTS** (2025-11-11) and **C# 14**, used by every folder here | [3][2] |

.NET 11 is expected next. It was at release candidate 3 on
2026-10-25 and was not yet released on 2026-11-01 [3]. Odd-numbered
releases are Standard Term Support (STS), with two years of support [3].

## Market usage today
Every number below has its date and source. These figures change every year.

- **TIOBE Index, October 2026:** C# is **#5** with a rating of 3.79%
  (−3.15% from a year earlier), also #5 in October 2025 [10]. TIOBE named
  C# "Programming Language of the Year" for 2023 and 2025, an award given
  "to the programming language that has the highest rise in ratings in a
  year" [10]. TIOBE's index measures popularity based on search engines,
  not lines of code written [10].
- **Stack Overflow Developer Survey 2026:** 27.1% of all respondents
  (3,826 of 14,099) said they had done extensive development work in C#
  over the past year [11]. 16.5% of all respondents want to use it
  ("desired"), and its "admired" score is 50.0% [12]. Among web
  frameworks, 19.9% of 10,281 respondents used ASP.NET Core and 16.0% used
  Angular [13].

## Importance then and now
- **Then:** C# was Microsoft's language for its new .NET platform in 2000
  [4]. Its first version "looked a lot like Java" [2], and it was
  standardized by Ecma within about 18 months of the announcement [4][6].
- **Now:** #5 in TIOBE (October 2026) and TIOBE's language of the year for
  2023 and 2025 [10]. 27.1% of Stack Overflow's 2026 respondents used it
  [11]. Since .NET Core it is open source and runs on Windows, macOS, and
  Linux [8]. Therefore, all four programs here run on the development
  machine, a Mac.
- **In teaching:** C# is statically typed and class-based like
  [Java](../java/README.md), and the build has the same compile-to-bytecode
  step (IL here, bytecode there).
  Top-level statements let a beginner start with one line, as in
  [Python](../python/README.md).

## Comparing the categories
| | [cli](cli/) | [desktop](desktop/) | [web](web/) | [web-angular](web-angular/) |
|---|---|---|---|---|
| Lines of code (no comments, no blank lines) | 1 | 52 C# (9 are the self-check) | 5 | 6 C# + 22 TypeScript |
| Project SDK | `Microsoft.NET.Sdk` | `Microsoft.NET.Sdk` + 3 NuGet packages | `Microsoft.NET.Sdk.Web` | `Microsoft.NET.Sdk.Web` + an npm project |
| Downloads beyond the SDK | none | Avalonia: 25 NuGet packages | none (ASP.NET Core comes with the SDK) | Angular: 238 npm packages |
| Entry point | top-level statement | `static void Main` in `class Program` | top-level statements | top-level statements (back end); `bootstrapApplication` (front end) |
| C# features shown | static method call | classes, inheritance, `override`, attributes, object initializers, pattern matching, events | `var`, lambdas, `??`, interpolated strings | `record`, JSON serialization of objects |
| Who owns the loop | nobody: one statement, then exit | Avalonia (`StartWithClassicDesktopLifetime`) | Kestrel (`app.Run`) | Kestrel + `ng serve` (two processes) |
| Compiled `.dll` (development machine) | 4,608 bytes | 6,656 bytes (plus about 560 MB of toolkit files in `bin/`) | 5,632 bytes | 7,168 bytes (back end) |
| Output | text on standard output | a native window | HTML over HTTP | JSON over HTTP, turned into HTML by Angular in the browser |

The scripts follow one pattern in all four folders: `install.sh` checks
for the SDK, `build.sh` runs `dotnet build -c Release`, and `run.sh` runs
`dotnet <program>.dll`. The desktop folder adds a `dotnet restore` step to
download Avalonia. The web-angular folder adds Node.js and `npm ci`.
The program's own `.dll` stays small in every folder because the runtime
libraries (and ASP.NET Core) live in the .NET installation, not in
`bin/`. Avalonia is the exception: its files are copied next to the
program.

C# has an implementation in each of these four categories.

## Sources
1. Overview - A tour of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/tour-of-csharp/overview> (accessed 2026-11-01)
2. The history of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/whats-new/csharp-version-history> (accessed 2026-11-01)
3. .NET and .NET Core official support policy. Microsoft. <https://dotnet.microsoft.com/platform/support/policy/dotnet-core> (accessed 2026-11-01)
4. Microsoft Introduces Highly Productive .NET Programming Language: C#. Microsoft News, 2000-06-26. <https://news.microsoft.com/source/2000/06/26/microsoft-introduces-highly-productive-net-programming-language-c/> (accessed 2026-11-01)
5. Microsoft's Anders Hejlsberg Receives Prestigious Excellence in Programming Award. Microsoft News, 2001-04-11. <https://news.microsoft.com/source/2001/04/11/microsofts-anders-hejlsberg-receives-prestigious-excellence-in-programming-award/> (accessed 2026-11-01)
6. ECMA-334: C# language specification (editions, ISO/IEC equivalents). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-334/> (accessed 2026-11-01)
7. Microsoft .NET and .NET Core (lifecycle: release dates). Microsoft Learn. <https://learn.microsoft.com/lifecycle/products/microsoft-net-and-net-core> (accessed 2026-11-01)
8. "What's new in .NET 5". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-5> (accessed 2026-11-01)
9. "What's new in .NET 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-10/overview> (accessed 2026-11-01)
10. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
11. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
12. 2026 Stack Overflow Developer Survey: admired and desired languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/da-language> (accessed 2026-11-01)
13. 2026 Stack Overflow Developer Survey: web frameworks and technologies (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/web-framework> (accessed 2026-11-01)
