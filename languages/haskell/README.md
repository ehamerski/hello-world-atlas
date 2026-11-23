# Haskell

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** purely functional, lazy (non-strict), statically typed with
type inference. The Haskell 2010 Report says "Haskell is a general
purpose, purely functional programming language" with "higher-order
functions, non-strict semantics, static polymorphic typing" and "a
monadic I/O system" [1].

See also: [paradigms](../../docs/paradigms.md#functional) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

What these words mean here:

- **Functional:** a program is built from expressions and functions, not
  from a list of commands that change variables. haskell.org: "Every
  function in Haskell is a function in the mathematical sense (i.e.,
  "pure")", and "There are no statements or instructions, only
  expressions which cannot mutate variables (local or global) nor access
  state like time or random numbers" [2]. A pure function always gives
  the same result for the same input and does nothing else.
- **Lazy (non-strict):** a value is only computed when it is needed.
  haskell.org: "Functions don't evaluate their arguments" [2].
- **Statically typed, with type inference:** "Every expression in Haskell
  has a type which is determined at compile time", but "You don't have to
  explicitly write out every type in a Haskell program" because the
  compiler infers them [2].
- **Side effects tracked by types (`IO`):** printing is a side effect, so
  it cannot happen inside a pure function. Instead, "The IO type serves as
  a tag for operations (actions) that interact with the outside world"
  [3]. "Even side-effecting IO operations are but a description of what
  to do, produced by pure code" [2].

The whole [cli](cli/) program shows this in two lines:

```haskell
main :: IO ()
main = putStrLn "Hello, World!"
```

`main :: IO ()` reads "`main` has the type `IO ()`": it is an I/O action
whose result is `()`, the unit type, which has only one value [3]. In other
words, the action gives back nothing useful. `putStrLn` has the type
`String -> IO ()` [4]: it takes a string and returns an *action* that
prints it. It does not print anything when it is evaluated. The language
rule is that `main` "must be a computation of type IO τ" and "When the
program is executed, the computation main is performed" [5]. So the
Haskell code only describes the printing, and the runtime performs it.
A function whose type has no `IO`, such as `Int -> Int`, "cannot do any
side-effects whatsoever" [2].

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | GHC (via GHCup) | ✅ |
| desktop | – | not implemented, see [Why there is no desktop version](#why-there-is-no-desktop-version) | – |
| web | [web/](web/) | Scotty, Cabal | ✅ |

## History
Haskell was designed by a committee. The Preface of the Haskell Report
gives the reason: "In September of 1987 a meeting was held at the
conference on Functional Programming Languages and Computer Architecture
(FPCA '87) in Portland, Oregon, to discuss an unfortunate situation in
the functional programming community: there had come into being more than
a dozen non-strict, purely functional programming languages, all similar
in expressive power and semantic underpinnings" [6]. "It was decided that
a committee should be formed to design such a language" [6]. One of its
goals: "It should be suitable for teaching, research, and applications,
including building large systems" [6].

The main source for this history is the paper *A History of Haskell:
Being Lazy with Class*, by Paul Hudak, John Hughes, Simon Peyton Jones and
Philip Wadler, presented at the third ACM History of Programming Languages
conference (HOPL-III) in 2007 [7]. It tells that the name was chosen at a
meeting at Yale in January 1988. The first choice was "Curry", "in
honour of the mathematician and logician Haskell B. Curry"; the next day
the committee "settled on "Haskell" as the name for the new language"
[7]. The Report also says the language is "named after the logician
Haskell B. Curry whose work provides the logical basis for much of ours"
[6].

"1 April 1990. The Haskell version 1.0 Report was published (125 pages),
edited by Hudak and Wadler" [7]. Versions 1.1 to 1.4 followed. Haskell
1.3 (May 1996) was "the most significant release of Haskell after 1.0":
"Monadic I/O made its first appearance, including "do" syntax" [7]. "By
the middle of 1997, there had been five versions of the language design
(from Haskell 1.0 – 1.4)", and a stable version was needed: "this became
"Haskell 98" and was published in February 1999" [6]. A Revised Haskell 98
Report followed in 2002 [6][7]. Then "Haskell 2010 is the first revision
to be created in this way", in small steps; its main additions were a
Foreign Function Interface (FFI), hierarchical module names such as
`Data.Bool`, and pattern guards [6][8].

**GHC's role.** The Glasgow Haskell Compiler "was begun in January 1989
at the University of Glasgow, as soon as the initial language design was
fixed", and "the first full release (version 0.10) was made in December
1992" [7]. In 2007 the paper already called it "Probably the most fully
featured Haskell compiler today" [7]. Today haskell.org calls GHC
Haskell's "flagship compiler" [2], and GHC "supports the entire Haskell
2010 language plus a wide variety of extensions" [9].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1987-09 | Meeting at FPCA '87 in Portland, Oregon, decides to form a committee | [6][7] |
| 1988-01 | Meeting at Yale; the name "Haskell" is chosen | [7] |
| 1988-02-24 | Wadler proposes type classes to the committee | [7] |
| 1989-01 | Work on the Glasgow Haskell Compiler (GHC) begins | [7] |
| 1990-04-01 | Haskell 1.0 Report, edited by Hudak and Wadler | [7] |
| 1992-12 | First full release of GHC (version 0.10) | [7] |
| 1996-05 | Haskell 1.3: monadic I/O and `do` syntax enter the language | [7] |
| 1999-02 | Haskell 98 Report, the first "stable" Haskell | [6][7] |
| 2002 | Revised Haskell 98 Report | [6][7] |
| 2007-01 | Hackage, the central package archive, goes online | [10] |
| 2010 | Haskell 2010 Report (FFI, hierarchical modules, pattern guards) | [6][8] |
| 2025-12-19 | GHC 9.14.1 released | [9] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Haskell is #41 with a rating of 0.33%
  [11].
- **Stack Overflow Developer Survey 2026:** 2.3% of all respondents to the
  programming languages question used Haskell (324 of 14,099) [12]. In the
  same survey, 4.5% of respondents want to work with it ("Desired"), and
  47.8% of those who used it want to keep using it ("Admired") [12].
- **Packages:** haskell.org's home page says "There are 6,954 packages
  freely available" (read on 2026-11-01) [2]. Hackage "has been online
  since January 2007" [10].

The numbers measure different things. TIOBE counts search-engine results,
and the Stack Overflow survey counts the developers who answered it.
Haskell has a small share in both. In the survey, more respondents want to
use it (4.5%) than use it today (2.3%) [12].

## Importance then and now
- **Then (1987–1999):** Haskell gave the lazy functional research
  community one common language. The Report calls it "the culmination and
  solidification of many years of research on non-strict functional
  languages" [1]. Two ideas became its trademarks. The authors write that
  "it is perhaps type classes that are now regarded as Haskell's most
  distinctive characteristic", and that "Aside from type classes [...]
  monads are one of the most distinctive language design features in
  Haskell" [7]. Monads solved a real problem: the committee wanted to keep
  the language "pure—meaning no side effects", yet still talk to the real
  world [7]. That is the `IO` type in the [cli](cli/) program.
- **Influence on other languages:** the paper says "Haskell has
  influenced several other programming languages", while warning that it
  is often "hard to ascertain whether there is a causal relationship"
  [7]. Its examples: "The generic type system introduced in Java 5 is
  based on the Hindley-Milner type system (introduced in ML, and promoted
  by Miranda and Haskell)" and its bounded types are "closely related to
  type classes in Haskell"; "The LINQ (Language INtegrated Query) features
  of C# 3.0 and Visual Basic 9.0 are based on monad comprehensions from
  Haskell"; Scala has features "similar to monad comprehensions" and
  "similar to type classes"; and Clean and Mercury adopted type classes
  [7]. The authors conclude: "We believe the most important legacy of
  Haskell will be how it influences the languages that succeed it" [7].
- **Now:** Haskell is used in industry. haskell.org lists testimonials
  from companies such as HubSpot ("Haskell drives our data
  synchronization engine"), Mercury ("We use Haskell to meet our
  customers' high standards for correctness and security"), finn.no
  ("we use Haskell in production") and NoRedInk ("The highest-traffic
  features of noredink.com are now served via Haskell") [2]. GHC is still
  released often (GHC 9.12.4 on 2026-03-27 [9]).
- **In teaching:** Haskell is the clearest example in this repository of
  a *purely* functional language. Every other command-line interface (CLI)
  program here prints with a statement or a function call that runs at once. In Haskell, the type
  `IO ()` shows that printing is a side effect, kept apart from pure code
  by the type system.

## Comparing the categories
| | [cli](cli/) | [web](web/) |
|---|---|---|
| Project file | none: one `hello.hs` | a Cabal package (a `.cabal` file); "Cabal is a system for building and packaging Haskell libraries and programs" [13] |
| Libraries | only the Prelude that comes with GHC (`putStrLn`) [4] | Scotty, "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp" [14] |
| Built with | one call: `ghc hello.hs` | `cabal build` |
| Downloads | none | Scotty and its dependencies from Hackage, "the Haskell community's central package archive" [10] |
| First build | compiles one file, nothing to download | downloads and compiles Scotty and its dependencies: 507 s (about 8.5 min) with an empty Cabal folder, macOS Intel, 2026-11-01 |
| What `main` does | performs one `putStrLn` action, then the program exits | starts the Warp web server ("A fast, light-weight web server for WAI applications" [15]) and blocks, serving requests until you stop it |
| Output | `Hello, World!` on stdout | `<p>Hello, World!</p>` in the response to `GET /`, on `PORT` (default 8080) |

What stays the same: both programs are compiled by GHC to a native
executable, and in both `main` has type `IO ()`. The web version is still
pure Haskell. Scotty only gives `main` a bigger `IO` action to perform:
"run a server" instead of "print a line". WAI, which Scotty builds on,
"Provides a common protocol for communication between web applications
and web servers" [16]. Compare [Python](../python/README.md), whose web
version also needs a framework (Flask) from a package index.

## Why there is no desktop version
This repository has no desktop version of Haskell: a
category stays only if a maintained, mainstream and reasonably simple
toolchain exists for it on all target OSes. The Haskell GUI libraries on
Hackage each fail one of these tests:

- **`gi-gtk` (`haskell-gi`): maintained, but needs GTK installed on every
  OS.** `haskell-gi` generates "Haskell bindings for GObject Introspection
  capable libraries. This includes most notably GTK" [17]. `gi-gtk` is
  maintained: version 4.0.12 was uploaded on 2025-01-01, and it "re-exports
  (for backward compatibility) the haskell-gi generated bindings in the
  gi-gtk4 package" [18]. But the README says: "To compile the bindings
  generated by haskell-gi, make sure that you have installed the
  necessary development packages for the libraries you are interested
  in" [19]. On macOS that means `brew install gobject-introspection gtk4`
  plus a `PKG_CONFIG_PATH` setting, and Windows has a separate guide [19].
  The student would install the GTK C library and its introspection data
  on each OS before writing any Haskell, as in the
  [C desktop](../c/desktop/) version. The README's own Hello World also
  turns on four language extensions [19].
- **wxHaskell: no release since 2017.** wxHaskell "is built on top of
  wxWidgets - a comprehensive C++ library", and "This version works with
  wxWidgets 2.9 and 3.0" [20]. Its latest release on Hackage, 0.92.3.0,
  was uploaded on 2017-04-28 [20].
- **threepenny-gui: not a desktop window.** It is a "GUI framework that
  uses the web browser as a display": "A program written with Threepenny
  is essentially a small web server that displays the user interface as a
  web page to any browser that connects to it" [21]. Its README says it
  "relies on a web browser being installed", and that a desktop app needs
  the Electron framework, with "no fully automated support for this yet"
  [21]. Hackage marks it: "This is an experimental release!" [21]. That is
  the [web](web/) version again, not a desktop one.
- **Monomer: native, but needs C libraries and is quiet.** Monomer is "A
  GUI library for writing native Haskell applications" [22]. Its setup
  guide asks for the SDL2 and GLEW C libraries on every OS (Homebrew on
  macOS, `pacman` inside Stack's MSYS2 on Windows) [23]. Its README says
  "there has not been a lot of activity in the past year", and the latest
  release on Hackage was uploaded on 2024-01-08 [22].

So a desktop Haskell Hello World would either need a C GUI library
installed on every OS (`gi-gtk`, Monomer), depend on a binding with no
release since 2017 (wxHaskell), or be a web page (threepenny-gui). None shows Haskell in "the
most simple and direct way".

## Sources
1. Haskell 2010 Language Report, Chapter 1: Introduction. Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch1.html> (accessed 2026-11-01)
2. Haskell Language (home page: features and testimonials). haskell.org. <https://www.haskell.org/> (accessed 2026-11-01)
3. Haskell 2010 Language Report, Chapter 6: Predefined Types and Classes (6.1.5 The Unit Datatype, 6.1.7 The IO and IOError Types). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch6.html> (accessed 2026-11-01)
4. Haskell 2010 Language Report, Chapter 7: Basic Input/Output. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch7.html> (accessed 2026-11-01)
5. Haskell 2010 Language Report, Chapter 5: Modules. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch5.html> (accessed 2026-11-01)
6. Haskell 2010 Language Report, Preface. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellli2.html> (accessed 2026-11-01)
7. A History of Haskell: Being Lazy With Class. Paul Hudak, John Hughes, Simon Peyton Jones, Philip Wadler. HOPL-III, 2007. Microsoft Research. <https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf> (accessed 2026-11-01)
8. Haskell 2010 Language Report (title page and contents). Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/> (accessed 2026-11-01)
9. The Glasgow Haskell Compiler (home page and news). GHC developers, haskell.org. <https://www.haskell.org/ghc/> (accessed 2026-11-01)
10. Hackage: The Haskell Package Repository. haskell.org. <https://hackage.haskell.org/> (accessed 2026-11-01)
11. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
12. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-11-01)
13. The Haskell Cabal: Overview. haskell.org. <https://www.haskell.org/cabal/> (accessed 2026-11-01)
14. `scotty`: Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp. Hackage. <https://hackage.haskell.org/package/scotty> (accessed 2026-11-01)
15. warp: A fast, light-weight web server for WAI applications. Hackage. <https://hackage.haskell.org/package/warp> (accessed 2026-11-01)
16. wai: Web Application Interface. Hackage. <https://hackage.haskell.org/package/wai> (accessed 2026-11-01)
17. haskell-gi: Generate Haskell bindings for GObject Introspection capable libraries. Hackage. <https://hackage.haskell.org/package/haskell-gi> (accessed 2026-11-01)
18. `gi-gtk`: Gtk 4.x bindings (compatibility layer). Hackage. <https://hackage.haskell.org/package/gi-gtk> (accessed 2026-11-01)
19. haskell-gi/haskell-gi (README: Installation). GitHub. <https://github.com/haskell-gi/haskell-gi> (accessed 2026-11-01)
20. wx: wxHaskell. Hackage. <https://hackage.haskell.org/package/wx> (accessed 2026-11-01)
21. threepenny-gui: GUI framework that uses the web browser as a display. Hackage. <https://hackage.haskell.org/package/threepenny-gui> (accessed 2026-11-01)
22. monomer: A GUI library for writing native Haskell applications. Hackage. <https://hackage.haskell.org/package/monomer> (accessed 2026-11-01)
23. Monomer tutorial 00: Setup (Libraries: SDL2 and GLEW). fjvallarino/monomer, GitHub. <https://github.com/fjvallarino/monomer/blob/main/docs/tutorials/00-setup.md> (accessed 2026-11-01)
