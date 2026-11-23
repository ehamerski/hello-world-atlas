# Eiffel

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** object-oriented [1], built around Design by Contract [1]: each
routine states its preconditions, postconditions and the class invariant.

See also: [paradigms](../../docs/paradigms.md#object-oriented)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations

| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Gobo Eiffel 26.03 (gec, Homebrew bottle) | ✅ |

## History

Eiffel was designed in 1985 by Bertrand Meyer, the principal designer of its
first versions, with Jean-Marc Nerson. The first implementation came from
Interactive Software Engineering Inc. (now Eiffel Software) and was released
commercially in 1986 [1]. Meyer's method of software construction, and the
notation that supports it, is the core of the language [1].

The language was first described in technical documents from Eiffel Software,
which became Meyer's book *Eiffel: The Language* (1990–1991). The two editions
of *Object-Oriented Software Construction* (1988 and 1997) also describe its
concepts [1]. Other implementations followed, among them Eiffel/S, Visual
Eiffel, EiffelStudio, Eiffel Envision and SmartEiffel [1]. ECMA International
standardized the language as ECMA-367: first edition June 2005, second
edition June 2006 [1].

## Milestones

| Year | Milestone | Source |
|---|---|---|
| 1985 | Eiffel designed (Meyer, with Nerson) | [1] |
| 1986 | First implementation released commercially by Interactive Software Engineering | [1] |
| 1988 | First edition of *Object-Oriented Software Construction* | [1] |
| 1990–1991 | Meyer's *Eiffel: The Language* | [1] |
| 1997 | Second edition of *Object-Oriented Software Construction* | [1] |
| 2005 | ECMA-367 first edition (June) | [1] |
| 2006 | ECMA-367 second edition (June) | [1] |
| 2026 | Gobo Eiffel 26.10 is released (2026-10-19) | [4] |

## Market usage today

ECMA-367 (2006) states that Eiffel is used across industry, including banking
and finance, defense and aerospace, health care, networking and
telecommunications, computer-aided design and game programming [1]. That is a
2006 statement. No current usage survey lists Eiffel, so this page gives no
newer usage figure.

## Importance then and now

Design by Contract is the language's best-known idea. The standard calls it
"the centerpiece of the Eiffel method": clients and suppliers (callers and
routines) agree on obligations made explicit by assertions [1]. The cli program
here uses a precondition (`require`), a postcondition (`ensure`) and a labeled
assertion so that a reader can see the three roles [1].

## Comparing the categories

Only the `cli` category is implemented. The program is a single class with
one creation routine. The language standard defines the language; it does not
define a window or web framework, so this repository adds neither.

## Why there is no desktop version

No desktop version is implemented. The standard describes the language, not a
GUI library, and this repository does not add one for Eiffel.

## Why there is no web version

No web version is implemented, for the same reason: the standard does not
define a web framework, and this repository does not add one for Eiffel.

## Sources

1. ECMA-367, *Eiffel: Analysis, Design and Programming Language*, 2nd edition, June 2006. ECMA International. <https://www.ecma-international.org/wp-content/uploads/ECMA-367_2nd_edition_june_2006.pdf> (accessed 2026-11-10)
2. Gobo Eiffel. <https://www.gobosoft.com/> (accessed 2026-11-10)
3. Homebrew formula `gobo` (version 26.03, license MIT). <https://formulae.brew.sh/formula/gobo> (accessed 2026-11-10)
4. Gobo Eiffel 26.10, GitHub release, published 2026-10-19. Gobo Eiffel project. <https://github.com/gobo-eiffel/gobo/releases/tag/gobo-26.10> (accessed 2026-11-20)
