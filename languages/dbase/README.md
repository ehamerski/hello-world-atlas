# dBASE

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative, with database commands. dBASE was both a database
program and a programming language with English-like commands such as `use`,
`find`, `append` and `list` [1].

> **Compromise:** dBASE III Plus is **proprietary DOS software** and is **not
> run** in this repository. The example is dBASE III-compatible `.prg` code,
> compiled and run by **Harbour 3.2.0**, an open-source xBase compiler [4].
> Students who own a dBASE III Plus license can run the original in **DOSBox** [6].

See also: [paradigms](../../docs/paradigms.md#imperative)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Harbour 3.2.0 (dBASE III-compatible `.prg`) | 🔶 |

## History

dBASE was invented by Wayne Ratliff, a programmer at the Jet Propulsion
Laboratories in Pasadena, California. He wrote a database program for his
kit-built home computer, called it Vulcan and sold it by mail order. George Tate
convinced him to form a company to sell it, Ashton-Tate, which renamed the
program dBASE II, "even though it was not the second version at all" [1].
Ashton-Tate, founded in August 1980, published dBASE, and its corporate fact sheet
later lists Ratliff as chief scientist [3]. Ashton-Tate dates the introduction of dBASE II to 1981 [2].

dBASE III, written in C for 16-bit computers running MS-DOS, first shipped in June
1984 [2][3]. Its successor, dBASE III Plus, gave the menu interface, the Assistant,
pull-down menus [1][2]. This folder targets the dBASE III Plus dialect. Ashton-Tate
released dBASE IV 1.0 in October 1988; Borland bought Ashton-Tate in 1991 and
continued dBASE on DOS and Windows [1].

The language had many compilers and clones: "dBXL, QuickSilver, Arago, Clipper and
Force allowed developers to compile dBASE-III Plus programs into DOS exe files" [1].
Harbour is a separate, open-source compiler for the xBase language, which aims to be
compatible with Clipper [4]. It lets dBASE-style code run today on systems where the
original does not.

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1981 | dBASE II introduced by Ashton-Tate: Wayne Ratliff's Vulcan under a new name | [1][2] |
| 1984 | dBASE III first shipped (June), the successor to dBASE II | [2] |
| 1988 | dBASE IV 1.0 released by Ashton-Tate (October) | [1] |
| 1991 | Borland buys Ashton-Tate (fall) | [1] |
| 1993 | dBASE IV 2.0 released by Borland (March), with a compiler | [1] |
| 1994 | dBASE for Windows 5.0 released (August), built on Arago for Windows | [1] |

The sources read for this page give no release year for dBASE III Plus, so the
table has no row for it.

## Market usage today

No published usage figure for dBASE or xBase was found, so this page gives no number.

## Importance then and now

dBASE combined a database with a built-in command language, and Martel calls its
popularity the start of "a cottage industry of dBASE compilers or clones" [1].
The xBase compilers keep its commands: in the Clipper reference published with
Harbour, `?` and `??` display values on the console, and programs are written in
`.prg` files [5]. Harbour keeps that family available as free software [4].

## Comparing the categories

Only the `cli` category is implemented: the program prints one line. See
[cli/README.md](cli/README.md).

## Why there is no desktop version

No desktop version is implemented. dBASE III Plus used a text screen on DOS, and this
repository does not add a GUI framework for dBASE-style code.

## Why there is no web version

No web version is implemented. dBASE III Plus predates the web, and this repository
does not add a web framework for it.

## Sources
1. Martel, J.-P. "A personal History of dBASE". The dBASE Developers Bulletin, `dbase.com`. <https://www.dbase.com/Knowledgebase/dbulletin/bu03hist.htm> (accessed 2026-11-20)
2. Ashton-Tate. "dBASE III PLUS Product Background", press background, 1986-07-01. Computer History Museum, catalog number 102762813. <https://archive.computerhistory.org/resources/access/text/2017/01/102762813-05-01-acc.pdf> (accessed 2026-11-20)
3. Ashton-Tate. "Corporate Fact Sheet". Computer History Museum, catalog number 102770527. <https://archive.computerhistory.org/resources/access/text/2017/02/102770527-05-01-acc.pdf> (accessed 2026-11-20)
4. Harbour project home page (xBase compiler; compatibility with Clipper). Harbour project. <https://harbour.github.io/> (accessed 2026-11-20)
5. Harbour Reference Guide: Clipper 5.3 (`?` and `??`; `.prg` program files). Harbour project. <https://harbour.github.io/doc/clc53.html> (accessed 2026-11-20)
6. DOSBox, an x86 emulator with DOS. DOSBox project. <https://www.dosbox.com/> (archived copy of 2026-11-16: <https://web.archive.org/web/20261116214648/https://www.dosbox.com/>) (accessed 2026-11-20)
