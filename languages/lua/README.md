# Lua

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm. The official site says Lua "supports several
programming styles: procedural, object-oriented, functional, data-driven,
and data description" [1]. The Hello World programs here use only the
procedural (imperative) style: statements run in order, and the only
data structure that appears is the table, which is the single data
structure of Lua [2].

See also: [paradigms](../../docs/paradigms.md#every-language-and-its-paradigm)
(how this paradigm compares with the others) and
[comparisons](../../docs/comparisons.md) (this language side by side with the
other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Lua 5.5 | ✅ |
| desktop | [desktop/](desktop/) | LÖVE 11.5 (LuaJIT, Lua 5.1 dialect) | 🔶 |
| web | [web/](web/) | Pegasus, LuaRocks | ✅ |

## History
Lua was born in 1993 at Tecgraf, the Computer Graphics Technology Group of
PUC-Rio, the Pontifical Catholic University of Rio de Janeiro in Brazil. Its
creators were Roberto Ierusalimschy, Luiz Henrique de Figueiredo, and
Waldemar Celes [2]. The official site names the same team as the designers,
implementers, and maintainers of the language since 1993 [3].

The authors tell the story in the paper that they presented at the Third
ACM SIGPLAN History of Programming Languages Conference (HOPL III) [2]:

- Tecgraf worked with Petrobras, the Brazilian oil company, on graphical
  front ends for data entry. Tecgraf first wrote a declarative data entry
  language (DEL) for these programs, and users then asked for more power.
- Around mid-1993 the three creators decided to design a new language
  instead of using an existing one. The paper says that "In 1993, the only
  real contender was Tcl", which "had unfamiliar syntax, did not offer
  good support for data description, and ran only on Unix platforms" [2].
- The authors state the goals as a language that is "simple, small,
  portable, fast, and easily embedded into applications" [2].

The name is not an acronym: "Lua" means "Moon" in Portuguese [4].

The authors also wrote that "while almost all programming languages come
from North America and Western Europe (with the notable exception of Ruby,
from Japan), Lua is the only language created in a developing country to
have achieved global relevance" [2].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 1993 | Lua is born at Tecgraf, PUC-Rio. | [2] |
| 1994 | July: Lua 1.1, the first public release, is published together with the first paper about Lua. | [2] |
| 1995 | February: Lua 2.1 introduces extensible semantics. | [2] |
| 1996 | December: Dr. Dobb's Journal publishes an article about Lua, which brings it to the attention of the software industry. | [2] |
| 1997 | July: Lua 3.0. | [2] |
| 1998 | October: the adventure game Grim Fandango, which uses Lua, is released. | [2] |
| 2000 | November: Lua 4.0. | [2] |
| 2003 | April: Lua 5.0, which has a register-based virtual machine and coroutines. | [2] |
| 2006 | 2006-02-21: Lua 5.1. | [5] |
| 2007 | Lua is featured at HOPL III. | [3] |
| 2011 | 2011-12-16: Lua 5.2. | [5] |
| 2015 | 2015-01-12: Lua 5.3 adds integers and bitwise operators. | [5] |
| 2020 | 2020-06-29: Lua 5.4 adds a generational garbage collector mode. | [5] |
| 2025 | 2025-12-22: Lua 5.5 adds declarations for global variables. | [5] |

Since Lua 5.0, the language is released under the MIT license; the
authors decided this in May 2002 [2]. Before that, version 1.1 had a
license that allowed academic use freely and required commercial users to
negotiate [2].

## Market usage today
- **Stack Overflow Developer Survey 2026:** Lua is used by 9.4% of all
  respondents (1,327 of 14,099; question: which programming, scripting, and
  markup languages the respondent has done extensive development work in over
  the past year) [6].
- **TIOBE Index, October 2026:** Lua is in position 35, with a rating of
  0.44% [7]. TIOBE states that its index "is not about the best
  programming language or the language in which most lines of code have
  been written" [7].

The two sources measure different things: a survey counts developers who
answer it, and an index computes a rating for each language. Lua is not in the
top 20 of the TIOBE index but is used by a larger share of survey
respondents than Swift (5.9%) or Ruby (5.8%) in the same survey [6].

The official site names World of Warcraft and Angry Birds as games that use
Lua, Adobe Photoshop Lightroom as an industrial application, and the Ginga
middleware for digital television in Brazil as an embedded one [1].

## Importance then and now
**Then.** Lua started as an in-house language for two projects at
Tecgraf [2]. Its design goals, a simple and small language and a simple,
small, fast, portable, and free implementation, made it fit to be
embedded in other programs, and the authors credit the language's success
to them [2]. The Grim Fandango game (1998) was an early, widely noticed
use in games [2].

**Now.** The official site calls Lua "the leading scripting language in
games" and describes it as portable, embeddable, and small: the source of
Lua 5.5.1 is around 32000 lines of C [1]. Its main use remains embedding in
another program, which then offers Lua as its scripting or configuration
language. Lua 5.5, the current version, continues the series that began
in 1993 [5]. LuaJIT, an independent implementation of the language, is "fully
upwards-compatible with Lua 5.1" [8]; the [desktop](desktop/README.md)
implementation runs on it.

## Comparing the categories
| Aspect | cli | desktop | web |
|---|---|---|---|
| Entry point | `hello.lua`, run by the `lua` program | `main.lua`, run by LÖVE | `app.lua`, run by the `lua` program |
| Libraries | none: `print` is built in | LÖVE (`love.graphics`), which embeds the language | Pegasus, LuaSocket, and others, installed by LuaRocks |
| Language version | Lua 5.5 | Lua 5.1 dialect (LuaJIT) | Lua 5.5 |
| Who owns the main loop | nobody: the program runs once | LÖVE: it calls `love.load`, `love.update`, and `love.draw` | Pegasus: `server:start` runs a blocking loop and calls your handler for each request |
| Build step | none | none | none (LuaRocks builds the C modules of the dependencies during `install.sh`) |
| How it is run | `./run.sh` prints and exits | `./run.sh` opens a window | `./run.sh` serves on port 8080 until Ctrl+C |

The language itself is the same in all three. What changes is who is in
control. In the [cli](cli/README.md), the program starts, prints, and ends.
In the [web](web/README.md) version, a library waits for requests and calls
a function that the program supplies. In the
[desktop](desktop/README.md) version, a framework creates the window and
calls three functions that the program supplies. In both of the last two
categories, Lua is the language that the host program embeds and drives, which is
the use that its authors designed it for [2].

**The compromise.** The desktop version runs the Lua 5.1 dialect because
LÖVE embeds LuaJIT, not the reference implementation. The code of Hello World is
the same in both dialects. The details are in the
[desktop README](desktop/README.md#what-this-is).

## Sources
1. Lua: about. Lua.org, PUC-Rio. <https://www.lua.org/about.html> (accessed 2026-11-04)
2. The Evolution of Lua. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. Proceedings of the Third ACM SIGPLAN History of Programming Languages Conference (HOPL III), 2007. <https://www.lua.org/doc/hopl.pdf> (accessed 2026-11-04)
3. Lua: authors. Lua.org, PUC-Rio. <https://www.lua.org/authors.html> (accessed 2026-11-04)
4. Lua: about, section "What's in a name?". Lua.org, PUC-Rio. <https://www.lua.org/about.html> (accessed 2026-11-04)
5. Lua: version history. Lua.org, PUC-Rio. <https://www.lua.org/versions.html> (accessed 2026-11-04)
6. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-20)
7. TIOBE Index for October 2026. TIOBE Software BV. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-04)
8. LuaJIT Extensions. Mike Pall. <https://luajit.org/extensions.html> (accessed 2026-11-04)
