# Visual Basic (VB.NET)

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented and imperative (VB.NET runs on the .NET runtime) [1].

> This folder covers VB.NET on the .NET 10 SDK (`cli` and `web`). The Visual
> Basic 6.0 IDE is no longer supported and the VB6 runtime is supported only on
> Windows [3], so VB6 appears in the history below and is not built here.

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | .NET 10 SDK (`dotnet`), VB.NET | ✅ |
| web | [web/](web/) | .NET 10 SDK, ASP.NET Core minimal API in VB.NET | ✅ |

## History

Visual Basic is a Microsoft language and development environment. Bill Gates
demonstrated Visual Basic 1.0 at Windows World in Atlanta on 20 May 1991 [4].
Its last classic version, Visual Basic 6.0 (VB6), ran on Windows. Support for
the Visual Basic 6.0 IDE ended on 2008-04-08; the VB6 runtime is still
supported on supported Windows versions [3].

Visual Studio .NET 2002 brought the first release of Visual Basic .NET [2].
VB.NET runs on .NET, and this folder implements VB.NET, not VB6.

Today the current version is Visual Basic 17.13, with Visual Studio 2026 [2].
In 2020 the .NET team wrote: "Going forward, we do not plan to evolve Visual
Basic as a language" [6]. Microsoft's language strategy says that Visual Basic
"will generally adopt a consumption-only approach and avoid new syntax" and
"won't be extended to new workloads" [5].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1991 | Bill Gates demonstrates Visual Basic 1.0 at Windows World (20 May) | [4] |
| 2002 | Visual Studio .NET 2002: the first release of Visual Basic .NET | [2] |
| 2008 | Support for the Visual Basic 6.0 IDE ends (8 April) | [3] |
| 2020 | The .NET team states that it does not plan to evolve Visual Basic as a language | [6] |
| 2026 | Visual Basic 17.13, the current version, with Visual Studio 2026 | [2] |

## Market usage today

Every number below has its date and source. They change every year.

- **TIOBE Index, November 2026:** "Visual Basic" is #9 with a rating of
  1.88% (−1.43% from a year earlier); it was #7 in November 2025 [10].
  TIOBE counts Visual Basic .NET under the name "Visual Basic" and lists
  "Classic Visual Basic" separately, at #22 with 0.69% [10].
- **Stack Overflow Developer Survey 2026:** 4.0% of all respondents (557 of
  14,099) used "Visual Basic (.Net)", and 3.9% (552) used VBA [11].

The two numbers measure different things: TIOBE counts search-engine
results, and the Stack Overflow survey counts the developers who answered
it. The .NET ecosystem that VB.NET belongs to is described in the
[C# overview](../csharp/README.md).

## Importance then and now

VB.NET is object-oriented: a class can inherit from another class with the
`Inherits` statement [7]. The .NET SDK that builds the programs here runs on
macOS, Linux and Windows [8].

## Comparing the categories

`cli` is a console program that uses `Console.WriteLine`. `web` is an ASP.NET Core
minimal API that answers `GET /` with the text. The two share the .NET SDK but differ in
their project files: `vbcli.vbproj` uses `Microsoft.NET.Sdk`, and `vbweb.vbproj` uses
`Microsoft.NET.Sdk.Web`.

## Why there is no desktop version

WinForms, the GUI library for VB.NET desktop programs, is documented as a Windows
library [9], so it is not part of the cross-platform examples here. VB6's forms are not built here either
(the VB6 IDE is no longer supported, and the VB6 runtime is supported only on Windows [3]).

## Sources
1. Visual Basic documentation (VB.NET). Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/> (accessed 2026-11-10)
2. "What's new for Visual Basic" (first release of Visual Basic .NET with Visual Studio .NET 2002; current version Visual Basic 17.13). Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/whats-new/> (accessed 2026-11-20)
3. "Support Statement for Visual Basic 6.0" (IDE no longer supported as of April 8, 2008; runtime supported for the support lifetime of Windows versions). Microsoft Learn. <https://learn.microsoft.com/previous-versions/visualstudio/visual-basic-6/visual-basic-6-support-policy> (accessed 2026-11-20)
4. "Happy 20th Birthday Visual Basic!", Visual Basic Team blog, 20 May 2011. Microsoft. <https://devblogs.microsoft.com/vbteam/happy-20th-birthday-visual-basic/> (accessed 2026-11-20)
5. Visual Basic language strategy. Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/getting-started/strategy> (accessed 2026-11-20)
6. "Visual Basic support planned for .NET 5.0", .NET Blog, 11 March 2020. Microsoft. <https://devblogs.microsoft.com/vbteam/visual-basic-support-planned-for-net-5-0/> (accessed 2026-11-20)
7. Inheritance basics (Visual Basic). Microsoft Learn. <https://learn.microsoft.com/dotnet/visual-basic/programming-guide/language-features/objects-and-classes/inheritance-basics> (accessed 2026-11-20)
8. .NET SDK installation and the dotnet-install script. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script> (accessed 2026-11-10)
9. Windows Forms (WinForms) documentation. Microsoft Learn. <https://learn.microsoft.com/dotnet/desktop/winforms/> (accessed 2026-11-10)
10. TIOBE Index for November 2026 (Visual Basic, Classic Visual Basic). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-20)
11. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
