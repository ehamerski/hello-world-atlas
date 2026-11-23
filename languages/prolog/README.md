# Prolog

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** logic programming. A Prolog program is a set of facts and
rules (Horn clauses). Running it means asking a question, a *query*, that
the system tries to prove from those clauses. Kowalski described the idea
in 1974: "An axiomatisation of a problem domain is a program for solving
problems in that domain. Individual problems are posed as theorems to be
proved" [1].

See also: [paradigms](../../docs/paradigms.md#logic) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

In an **imperative** language (C, Python, Fortran), the program is a list
of commands: do this, then do that. A **declarative** logic program says
*what is true* instead, and the system works out *how* to find an answer.
Kowalski put it as "Algorithm = Logic + Control": the logic component
"specifies the knowledge to be used in solving problems", and the control
component "determines the problem-solving strategies by means of which
that knowledge is used" [2].

Three words explain how Prolog proves a query. The SWI-Prolog manual
defines them [3]:

- A **clause** is a head and a body joined by `:-`, read as "if". A
  **fact** is a "Clause without a body", so there is "no condition to be
  satisfied".
- To **unify** is to "make two terms equal by assigning variables in one
  term to values at the corresponding location of the other term".
  "Unlike assignment (which does not exist in Prolog), unification is not
  directed."
- **Backtracking**: "If a predicate offers multiple clauses to solve a
  goal, they are tried one-by-one until one succeeds."

This proof method is SLD resolution: Prolog works on Horn clauses with
"SLD-resolution (Kowalski, 1974) based on Robinson's principle (1965)
and Kowalski's procedural semantics (Kowalski, 1974) as the basic
execution mechanism" [5]. The language itself is standardized as ISO/IEC
13211-1:1995 [4].

The Hello World is one rule: `main :- format("Hello, World!~n").` Read as
logic, it says "`main` is true if `format(...)` is true". When Prolog
proves `main`, it must prove the body, and proving `format/1` has a side
effect: it will "Write formatted output to Output or current_output"
[22]. The program is "proved" only to get that side effect. Nothing about
it is a fact to look up, but the mechanism is the same one used for real
logic programs.

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | SWI-Prolog | ✅ |
| desktop | – | not implemented, see [Why there is no desktop version](#why-there-is-no-desktop-version) | – |
| web | [web/](web/) | SWI-Prolog HTTP libraries | ✅ |

## History
Prolog was born in Marseille, from work on natural language. Alain
Colmerauer "was seeking to automate human-machine conversation", and his
aim of writing "a complete question-answering system" in logic "inspired
him, amongst others, to create Prolog" [5]. He invited Robert Kowalski,
then at the University of Edinburgh [1], to visit Marseille "in the
summer of 1971" [5].
"Colmerauer and Kowalski's collaboration led in 1972 to a discovery
analogous, for programs, to that made previously for grammars": a certain
style of clauses lets a theorem prover "behave as a computational
procedure for executing computer programs" [5].

"The first system ("Prolog 0") was written in Algol-W by Roussel in
1972" [5]. A second implementation, "Prolog I", followed "at the end of
1973 by Battani, Meloni, and Bazzoli, in Fortran", and it "already had
the same operational semantics and most of the built-ins that later
became part of the ISO standard" [5]. In 1974 Kowalski, at the
University of Edinburgh, published "Predicate Logic as Programming
Language", which argued that "predicate logic is a useful and practical,
high-level, non-deterministic programming language with sound
theoretical foundations" [1].

Edinburgh made Prolog fast. David H.D. Warren visited Marseille in 1974,
took Prolog to a DEC-10 in Edinburgh, and wrote "the first compiler from
Prolog to machine code", with speed "rivaling that of Lisp systems" [5].
DEC-10 Prolog spread to AI departments "from about 1976 onward". Its
syntax, known as the "Edinburgh syntax", and many of its features
"constitute a fundamental component of the current Prolog ISO standard"
[5]. In 1983 Warren
described an abstract machine that "became widely known as the Warren
Abstract Machine, the WAM", and "the WAM became the standard blueprint
for Prolog compilers and continues to be today" [5].

In 1982 Japan's Ministry of International Trade and Industry started the
Fifth Generation Computer Systems (FGCS) initiative, to "build large
parallel computers and apply them in artificial intelligence tasks, with
logic programming as the basis, and in particular Prolog" [5]. Its core
language later moved away from Prolog's backtracking (KL1) [5].

Work on a standard "started in 1984 and was organized formally in 1987"
[5]. ISO/IEC 13211-1, *Prolog, Part 1: General core*, was published on
1995-06-01 [4]. It "solidified the Edinburgh/Quintus de-facto standard"
[5].

SWI-Prolog, the system used in this repository, was written by Jan Wielemaker.
The manual says it "started back in 1986 with the requirement for a
Prolog that could handle recursive interaction with the C-language" [6];
the home page says "Since its start in 1987" [7]. It "took form in the
SWI department at the University of Amsterdam" [8].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1971 (summer) | Kowalski visits Colmerauer in Marseille | [5] |
| 1972 | Prolog 0, written in Algol-W by Philippe Roussel in Marseille | [5] |
| 1973 (end) | Prolog I, in Fortran (Battani, Meloni, Bazzoli) | [5] |
| 1974 | Kowalski, "Predicate Logic as Programming Language" (IFIP 74) | [1] |
| 1975 | DEC-10 Prolog compiler in Edinburgh (Warren): "the first compiler from Prolog to machine code" | [5] |
| 1979-07 | Kowalski, "Algorithm = Logic + Control" (*Communications of the ACM*) | [2] |
| 1982 | Japan starts the Fifth Generation Computer Systems (FGCS) initiative | [5] |
| 1983 | Warren Abstract Machine (WAM) | [5] |
| 1986 / 1987 | SWI-Prolog starts (manual: 1986; home page: 1987) | [6][7] |
| 1987 | Constraint Logic Programming (CLP) scheme, Jaffar and Lassez | [5] |
| 1995-06-01 | ISO/IEC 13211-1:1995, Prolog Part 1: General core | [4] |
| 2011-02 | IBM Watson wins *Jeopardy!*; its question analysis rules are written in Prolog | [12] |
| 2025-06-04 | ISO/IEC TS 13211-3:2025: Definite clause grammar rules | [13] |
| 2025-12-03 | SWI-Prolog 10.0.0: GUI tools based on SDL3 on Linux, macOS, and Windows | [14][15] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Prolog is #31 with a rating of 0.49%
  [9].
- **Stack Overflow Developer Survey 2026:** 0.9% of all respondents to the
  programming languages question used Prolog (129 of 14,099) [10].
- **Stack Overflow Developer Survey 2025:** 1.1% of all respondents used
  Prolog. Among people "Learning to Code" the share was 3%, against 0.8%
  among "Professional Developers" [11].

The numbers measure different things: TIOBE counts search-engine results,
and the Stack Overflow survey counts the developers who answered it. Both
show a small language. The 2025 survey also shows that Prolog is used more
by learners than by professionals [11], which fits its place in teaching.

## Importance then and now
- **Then (1972–1990s):** Prolog was "first conceived" for natural
  language processing [5], and it changed what a program could be:
  logic programming moved computing from a "mostly imperative paradigm
  into the new, unique paradigm of inferential engines" [5]. It was the
  chosen basis of Japan's FGCS project [5], and the WAM is still "the
  standard blueprint for Prolog compilers" [5].
- **Ideas that spread:** Datalog, "a subset of Prolog", "plays an
  important role in the research field of deductive databases" and has
  found uses in "program analysis", "security", and "natural language
  processing" [5]. Constraint Logic Programming replaced "the unification
  procedure in the resolution steps by a more general process for solving
  constraints over specific domains" [5].
- **Now:** IBM's Watson, which won *Jeopardy!* in February 2011, used
  Prolog for "detection rules that match patterns in the parse" of a
  question. Its authors wrote: "We found that Prolog was the ideal choice
  for the language due to its simplicity and expressiveness" [12]. ISO is
  still extending the standard (DCG rules, 2025 [13]), and SWI-Prolog's
  focus includes "multi-threaded programming, implementations of
  communication network protocols such as HTTP" [5].
- **In teaching:** "SWI-Prolog is traditionally strong in education
  because it is free and portable" [23]. Prolog is the only logic
  language in this repository, and it shows a way of programming where you
  describe facts and rules and let the system search for the answer.

## Comparing the categories
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Entry point | `:- initialization(main, main).` then `main :- format("Hello, World!~n").` | `:- initialization(main, main).`; `main` starts the HTTP server |
| Started with | `swipl hello.pl` | `swipl` on the server file (port from `PORT`, default 8080) |
| Libraries loaded | none | `library(http/thread_httpd)`, `library(http/http_dispatch)` |
| How `/` is answered | – | an `http_handler` maps `/` to a predicate that sends `<p>Hello, World!</p>` |
| Who owns the loop | nobody: `main` succeeds, then Prolog halts | the server's threads; `main` waits forever instead of returning |
| Output | text on stdout | HTML in the HTTP response |
| Extra downloads | none | none: the HTTP libraries ship with SWI-Prolog [17] |

What stays the same: both are run by the same `swipl` program, with no
compile step, and both use `initialization(main, main)`. With that
directive, "the last goal registered using `initialization(Goal, main)`
is executed as main goal", and when it is done the toplevel "is set to
`halt/0`, causing the process to exit with status 0" [16]. This is the
behavior that the CLI version needs. The web version must not exit, so its `main`
starts the server and then blocks.

The server side comes from SWI-Prolog's own libraries: `thread_httpd` "is
responsible for accepting and managing connections", and `http_dispatch`
"associates the path of the HTTP request with a handler" [17]. The server
is multi-threaded; SWI-Prolog's authors write that "Multi-threading was
initially introduced to support scalable web servers in Prolog" [8].
Compare [PHP](../php/README.md), whose built-in server needs no server
code at all, and [Go](../go/README.md), which also writes the server in
code with its standard library.

## Why there is no desktop version
This repository has no desktop version of Prolog: a
category stays only if a maintained, mainstream, and reasonably
simple toolchain exists for it on all target operating systems. SWI-Prolog does have a GUI
toolkit, XPCE, so the reason is the toolchain this repository installs, not the
absence of a toolkit:

- **XPCE exists and is maintained.** "XPCE is a toolkit for developing
  graphical applications in Prolog" [18]. Its repository describes it as
  "The graphics toolkit for SWI-Prolog", and its README says "Current
  versions use SDL3 and Cairo for the graphics and run on Linux, macOS
  and Windows" [19].
- **Native on macOS only since December 2025.** On macOS, "For versions up to
  9.3.25, XQuartz" (an X11 server) was required [20]. SWI-Prolog 10.0,
  tagged on 2025-12-03 [15], is the first stable release with
  "Native GUI tools for Linux (Wayland or X11), MacOS (Cocoa) and Windows
  (Win32) based on SDL3" [14].
- **The Homebrew package has no GUI.** This repository installs SWI-Prolog with
  Homebrew, an established package manager
  ([About the sources](../../docs/sources.md#4-security-of-installers)). The
  Homebrew formula builds it with `-DSWIPL_PACKAGES_GUI=OFF` [21], so
  `brew install swi-prolog` gives no XPCE. Getting XPCE on macOS means
  either the official disk image [14] or a source build with the extra
  libraries "sdl3 sdl3_image cairo pango" [20].

So a desktop Prolog Hello World would need a second installation of
SWI-Prolog next to the Homebrew one used by [`cli`](cli/) and [`web`](web/),
for a GUI toolkit that has run natively on all three operating systems only since
December 2025.

## Sources
1. Predicate Logic as Programming Language. Robert Kowalski, Information Processing 74 (IFIP Congress), North-Holland, 1974. <https://www.doc.ic.ac.uk/~rak/papers/IFIP%2074.pdf> (accessed 2026-11-01)
2. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (accessed 2026-11-01)
3. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (accessed 2026-11-01)
4. ISO/IEC 13211-1:1995, Information technology - Programming languages - Prolog - Part 1: General core (catalog page). IEC Webstore (ISO/IEC JTC 1/SC 22). <https://webstore.iec.ch/publication/9731> (accessed 2026-11-01)
5. Fifty Years of Prolog and Beyond. Philipp Körner, Michael Leuschel, João Barbosa, Vítor Santos Costa, Verónica Dahl, Manuel V. Hermenegildo, Jose F. Morales, Jan Wielemaker, Daniel Diaz, Salvador Abreu, Giovanni Ciatto. Theory and Practice of Logic Programming, 2022 (arXiv:2201.10816). <https://arxiv.org/abs/2201.10816> (accessed 2026-11-01)
6. SWI-Prolog Reference Manual: 1.5 Implementation history. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=implhistory> (accessed 2026-11-01)
7. SWI-Prolog (home page). SWI-Prolog. <https://www.swi-prolog.org/> (accessed 2026-11-01)
8. SWI-Prolog. Jan Wielemaker, Tom Schrijvers, Markus Triska, Torbjörn Lager. Theory and Practice of Logic Programming, 2012 (arXiv:1011.5332). <https://arxiv.org/abs/1011.5332> (accessed 2026-11-01)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
10. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
11. 2025 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2025/technology> (accessed 2026-11-01)
12. Natural Language Processing With Prolog in the IBM Watson System. Adam Lally (IBM Thomas J. Watson Research Center) and Paul Fodor (Stony Brook University). Association for Logic Programming, 2011-03-31. <https://logicprogramming.org/2011/03/natural-language-processing-with-prolog-in-the-ibm-watson-system> (accessed 2026-11-01)
13. ISO/IEC TS 13211-3:2025, Programming languages - Prolog - Part 3: Definite clause grammar rules (catalog page). IEC Webstore. <https://webstore.iec.ch/en/publication/107758> (accessed 2026-11-01)
14. Download SWI-Prolog stable versions (SWI-Prolog 10.0 highlights). SWI-Prolog. <https://www.swi-prolog.org/download/stable> (accessed 2026-11-01)
15. Release V10.0.0. SWI-Prolog/swipl, GitHub. <https://github.com/SWI-Prolog/swipl/releases/tag/V10.0.0> (accessed 2026-11-01)
16. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (accessed 2026-11-01)
17. SWI-Prolog HTTP support: 3 The HTTP server libraries. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=httpserver> (accessed 2026-11-01)
18. XPCE: the SWI-Prolog native GUI library. SWI-Prolog. <https://www.swi-prolog.org/packages/xpce/> (accessed 2026-11-01)
19. SWI-Prolog/packages-xpce. GitHub. <https://github.com/SWI-Prolog/packages-xpce> (accessed 2026-11-01)
20. "Building SWI-Prolog on MacOS". SWI-Prolog. <https://www.swi-prolog.org/build/macos.html> (accessed 2026-11-01)
21. `swi-prolog.rb` (Homebrew formula). Homebrew/homebrew-core, GitHub. <https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/s/swi-prolog.rb> (accessed 2026-11-01)
22. SWI-Prolog Reference Manual: format/1, format/2, format/3. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=format/1> (accessed 2026-11-01)
23. SWI-Prolog Reference Manual: 1.1 Positioning SWI-Prolog. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=swiprolog> (accessed 2026-11-01)
