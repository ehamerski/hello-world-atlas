# Common Lisp

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm: functional, imperative, and object-oriented.
This repository groups it with the functional languages. Common-Lisp.net
describes it as "a modern, multi-paradigm, high-performance, compiled,
ANSI-standardized descendant of the long-running family of Lisp
programming languages" [16].

See also: [paradigms](../../docs/paradigms.md#functional) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

Why "functional": Lisp was born as a language of functions. McCarthy's
1960 paper starts with "a formalism for defining functions recursively"
[1], and one of the ideas behind it was "to express programs as
applicative expressions built up from variables and constants using
functions" [3]. Functions are values: the standard defines a function as
"an object representing code" [18], so you can pass one to another
function, as in `(funcall #'+ 1 2 3)` [19] or
`(mapcar #'car '((1 a) (2 b) (3 c)))`, which returns `(1 2 3)` [23].
Lisp code is also written as lists, called S-expressions [1][3]: McCarthy
named "representation of program in the same way" as lists as one of the
ideas that "will probably have a very long life" [41]. A program is data
that another program can read and build, and macros use this to add new
syntax to the language [7][16][22].

Why "multi-paradigm": Common Lisp is not purely functional. McCarthy
wrote that "side-effects are often a great convenience when
computational efficiency is important, and 'functions' with side-effects
are present in LISP" [3]. Common Lisp has assignment
(`(setq var1 form1 ...)` "is the simple variable assignment statement of
Lisp" [20]), statements with `go` jumps (`tagbody` [21]) and an object
system, CLOS, with classes, generic functions, and methods [24]. Compare
Haskell, where "Every
function in Haskell is a function in the mathematical sense (i.e.,
"pure")" [17]. In Common Lisp the programmer chooses the style. The
Hello World here is a single function call with a side effect: it prints.

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | SBCL | ✅ |
| desktop | – | not implemented, see [Why there is no desktop version](#why-there-is-no-desktop-version) | – |
| web | [web/](web/) | Hunchentoot (Quicklisp), SBCL | ✅ |

## History
Two papers tell this story from the inside: McCarthy's own *History of
Lisp* (draft dated 1979-02-12) [6], and *The Evolution of Lisp* by Guy
L. Steele Jr. and Richard P. Gabriel, written for the ACM Conference on
the History of Programming Languages II [7][8].

The idea came first. McCarthy wrote that his "desire for an algebraic
list processing language for artificial intelligence work on the IBM 704
computer arose in the summer of 1956 during the Dartmouth Summer Research
Project on Artificial Intelligence" [2][9]. While writing chess routines
in FORTRAN "at M.I.T. during 1957-58" he invented the conditional
expression, which "evaluates only one of N1 and N2 according to whether M
is true or false" [2].

"In the Fall of 1958", McCarthy and Marvin Minsky "started the M.I.T.
Artificial Intelligence Project", and "The implementation of LISP began
in Fall 1958" [3]. In April 1960 McCarthy published *Recursive Functions
of Symbolic Expressions and Their Computation by Machine, Part I* in the
Communications of the ACM [1]. It opens: "A programming system called
LISP (for LISt Processor) has been developed for the IBM 704 computer by
the Artificial Intelligence group at M.I.T." [1]. The paper described
LISP "both as a programming language and as a formalism for doing
recursive function theory" [3]. For it, McCarthy wrote a universal
function, `eval`, which needed "a notation representing LISP functions as
LISP data" [3]. Then "S.R. Russell noticed that eval could serve as an
interpreter for LISP, promptly hand coded it, and we now had a
programming language with an interpreter" [3].

The *LISP 1.5 Programmer's Manual* by McCarthy, Levin, and others was
published by M.I.T. Press in 1962 [5], and "The primary dialect of Lisp
between 1960 and 1965 was Lisp 1.5" [9]. Many dialects followed. "By the
early 1970's there were two predominant dialects of Lisp": MacLisp and
Interlisp [9]. In the late 1970s Gerald J. Sussman and Guy L. Steele Jr.
designed Scheme, "a simple dialect of Lisp" [9], and Lisp machines from
Xerox, LMI, and Symbolics "were on the market by 1981" [9].

Common Lisp was the answer to this split. "In April 1981, ARPA called a
'Lisp Community Meeting'" [7], after which Symbolics, the SPICE project,
the NIL project, and the S-1 Lisp project "joined together to define
Common Lisp" [9]. Guy Steele's book *Common Lisp: The Language* (CLtL)
was published in 1984 [7], and a second edition (CLtL2) in 1990 [12].
"In 1986 X3J13 was formed as a technical working group to produce a
draft for an ANSI Common Lisp standard" [9]. Its object system, CLOS,
"was adopted in June of 1988" [7]. The result was the standard ANSI
X3.226-1994, today called ANSI INCITS 226-1994 [10][11]. The free online
version is the Common Lisp HyperSpec, published by LispWorks: it "is not
the ANSI Common Lisp standard, but is based on that standard (with
permission from ANSI and X3)" [10].

The compiler used here, SBCL (Steel Bank Common Lisp), "derives most of
its code from CMU CL, created at Carnegie Mellon University", and "In
December 1999, SBCL forked off the main branch of CMUCL" [14]. The name
honors Carnegie Mellon's founders: "the system is named Steel Bank after
the industries where Andrew Carnegie and Andrew Mellon, respectively,
made the big bucks" [14].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1956 (summer) | McCarthy's idea of a list processing language for AI, at the Dartmouth project | [2][9] |
| 1957–1958 | McCarthy invents the conditional expression at M.I.T. | [2] |
| 1958 (fall) | Implementation of LISP begins at the M.I.T. AI Project | [3] |
| 1960-04 | *Recursive Functions of Symbolic Expressions ...*, Communications of the ACM | [1] |
| 1962 | *LISP 1.5 Programmer's Manual* (M.I.T. Press) | [5] |
| mid-1960s | MacLisp introduces the macro facility on which `defmacro` is based | [7] |
| early 1970s | MacLisp and Interlisp are the two main dialects | [9] |
| late 1970s | Scheme, by Sussman and Steele | [9] |
| 1981-04 | ARPA "Lisp Community Meeting"; the Common Lisp effort starts | [7][9] |
| 1984 | *Common Lisp: The Language* (CLtL1) | [7] |
| 1986 | X3J13 is formed to write an ANSI standard | [9] |
| 1988-06 | CLOS, the Common Lisp Object System, is adopted | [7] |
| 1990 | *Common Lisp the Language, 2nd Edition* (CLtL2) | [12] |
| 1994 | ANSI X3.226-1994 (now ANSI INCITS 226-1994), the current standard | [10][11] |
| 1999-12 | SBCL forks from CMUCL | [14] |
| 2026-10-29 | SBCL 2.6.10, the most recent release on 2026-11-01 | [13] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** Lisp is #36 with a rating of 0.42% [25].
- **Stack Overflow Developer Survey 2026:** 2.6% of all respondents to the
  programming languages question used Lisp (368 of 14,099) [26]. In the
  2025 survey the figure was 2.4% of all respondents [27].
- **IEEE Spectrum Top Programming Languages 2025:** Lisp is 48th in the
  default "Spectrum" ranking [28].

The three numbers measure different things. TIOBE counts search-engine
results, the Stack Overflow survey counts the developers who answered,
and IEEE Spectrum combines several metrics into three rankings
(Spectrum, Trending, and Jobs) [28]. None of them separates
Common Lisp from the other Lisp dialects: the label in all three is
"Lisp".

## Importance then and now
- **Then (1958–1990s):** Lisp brought several ideas that are now common:
  - **The conditional expression.** McCarthy invented it and proposed it
    for Algol [2]. The 1960 paper says "the notion of conditional
    expression is believed to be new" [1].
  - **Recursion.** "The use of conditional expressions permits functions
    to be defined recursively in a new and convenient way" [1]. FLPL, the
    list language that IBM built inside FORTRAN, "had neither conditional
    expressions nor recursion" [2].
  - **Garbage collection.** McCarthy rejected explicit erasure and chose
    "garbage collection in which storage is abandoned until the free
    storage list is exhausted" [3]. In the 1960 paper, "No provision need
    be made for the user to program the return of registers to the
    free-storage list" [1].
  - **The interactive interpreter (REPL).** "It is convenient to define
    functions, test them, and re-edit them without ever leaving the LISP
    interpreter" [5].
  - **Self-hosting compilers.** The first successful LISP compiler, by
    Timothy Hart and Michael Levin, "was written in LISP and was claimed
    to be the first compiler written in the language to be compiled" [4].
  - **AI.** In the 1980s, "AI was on the rise, and Lisp was the language
    of AI" [7]. In 1979 McCarthy called LISP "the second oldest
    programming language in present widespread use (after FORTRAN ...)"
    [41].
- **A language for building languages:** "Lisp has been used throughout
  its history as a language laboratory" [7]. With macros, "it is pretty
  easy to add new control structures or other syntactic constructs" [7].
  Scheme brought "lexical scoping, lexical closures, first-class
  continuations" into the Lisp family, and some of these "made a large
  impact on the design of Common Lisp" [9].
- **Now:** Lisp has a small share of developers (2.6% in the 2026 Stack
  Overflow survey [26]), but Common Lisp is still maintained: SBCL had a
  release on 2026-10-29 [13], and Quicklisp offers "over 1,500 libraries"
  [29]. The official standard is still the 1994 one, ANSI INCITS
  226-1994 [11].
- **In teaching:** Common Lisp shows "code as data" in its plainest form:
  the program is a list, `(format t "Hello, World!~%")`. It also shows a
  model the other languages here do not: a run-time environment "that
  allows modification and debugging of running applications" [16], whose
  state can be saved to disk as an executable [15] (see [cli](cli/)).

## Comparing the categories
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Source | one file, `hello.lisp`, with a `main` function | the server code in [web/](web/), with a `main` function |
| Prints with | `(format t "Hello, World!~%")` | Hunchentoot sends `<p>Hello, World!</p>` for `GET /` |
| Libraries | none: only the standard | Hunchentoot, downloaded and loaded by Quicklisp [29][30] |
| Build | SBCL loads the file and saves the image with `sb-ext:save-lisp-and-die` [15] | SBCL loads Quicklisp, Hunchentoot (`ql:quickload`) and the server code, then saves the image with `sb-ext:save-lisp-and-die` [15] |
| Result | a standalone executable "containing both an image of the current Lisp session and an SBCL runtime" [15] | the same kind of executable, with Hunchentoot inside; it listens on `PORT` (default 8080) |
| Who owns the loop | nobody: `main` prints and the program exits | Hunchentoot: it "starts one thread for listening to incoming requests and one thread for each incoming connection" [30], so `main` must block or the process would end |
| First build | build, then run the executable | Quicklisp "will automatically download any supporting software it needs" [29] during `build.sh`, so the first build takes longer than later builds; running needs no network |

What stays the same: both use the same SBCL, both start from a `main`
function, and both do the heavy work once, at build time, and save it as
an executable. The difference is what `main` does: the CLI executable
prints and exits, while the web executable starts Hunchentoot and waits
for requests in other threads.
Compare [Python](../python/README.md), whose web version also loads a
library from a package index (Flask from PyPI).

## Why there is no desktop version
This repository has no desktop version of Common
Lisp: a category stays only if a maintained, mainstream, and
reasonably simple toolchain exists for it on all target platforms.
Common Lisp has GUI libraries, but none meets all three conditions:

- **McCLIM is maintained, but needs an X server.** McCLIM is "a FOSS
  implementation of the Common Lisp Interface Manager specification"
  [31]. It is active: version 1.0.0 "Koliada" was released on 2026-05-05
  [33]. But its README says: "Right now the only backend supported by
  McCLIM is CLX, which ties it to the Xserver on the host system. Any
  platform capable of running Xserver may run McCLIM applications" [32].
  On macOS and Windows the student would first install and start an X
  server, before any Lisp.
- **LTK depends on Tcl/Tk, and its home page is from 2011.** LTK is "a Common Lisp
  binding for the Tk graphics toolkit" [34]. Its documentation says: "To
  use Ltk you need of course tcl/tk installed. This should be default on
  most Linux systems, for Windows/Mac OS you need to download and install
  tcl/tk", and "Ltk has been tested against Tcl/Tk 8.4" [35]. Its home
  page was last modified in July 2011 and lists `ltk-0.981` as the latest
  version [34].
- **The GTK bindings need GTK and are not in the main Quicklisp
  distribution.** cl-cffi-gtk4 is "a Lisp binding to GTK 4", and its
  README says it "is developped using SBCL on UBUNTU. The library runs
  successfully on WINDOWS" [36]; it does not mention macOS. cl-gtk4 asks
  you to "ensure these libraries are available in your system: GTK4,
  GObject Introspection", and "is available on Ultralisp, so it can be
  downloaded via Quicklisp with Ultralisp installed as its distribution"
  [37]. In both cases, the student installs the GTK C library first (as in
  the [C desktop](../c/desktop/) version) and then a binding.
- **CAPI is portable but commercial.** LispWorks' CAPI "is a portable GUI
  toolkit, supporting native look and feel on Microsoft Windows, GTK+,
  Cocoa and Motif" [38], and "The CAPI is included in LispWorks" [38], a
  commercial Common Lisp, not in SBCL. On
  2026-11-01 LispWorks 8.1 (64-bit) for Macintosh, Professional Edition,
  cost $3,000 per user for commercial users in North America [39]. The
  free Personal Edition has "a time limit of 5 hours for each session",
  and "The functions save-image, deliver, and load-all-patches are not
  available" [40], so it cannot save or deliver an application.

A desktop Hello World would therefore need an X server, an old Tk
binding, a GTK installation plus a binding outside the main Quicklisp
distribution, or a commercial Lisp. None of these options meets the three
conditions above.

## Sources
1. Recursive Functions of Symbolic Expressions and Their Computation by Machine, Part I (Communications of the ACM, April 1960). John McCarthy. <https://www-formal.stanford.edu/jmc/recursive.pdf> (accessed 2026-11-01)
2. History of Lisp (draft dated 1979-02-12): "LISP prehistory - Summer 1956 through Summer 1958". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node2.html> (accessed 2026-11-01)
3. History of Lisp: "The implementation of LISP". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node3.html> (accessed 2026-11-01)
4. History of Lisp: "From LISP 1 to LISP 1.5". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node4.html> (accessed 2026-11-01)
5. History of Lisp: "Beyond LISP 1.5". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node5.html> (accessed 2026-11-01)
6. History of Lisp (title page and contents). John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/lisp.html> (accessed 2026-11-01)
7. The Evolution of Lisp (HOPL II version). Guy L. Steele Jr. and Richard P. Gabriel. <https://www.dreamsongs.com/Files/Hopl2.pdf> (accessed 2026-11-01)
8. Essays: The Evolution of Lisp (how the paper was written for the ACM Conference on the History of Programming Languages II). Richard P. Gabriel. <https://www.dreamsongs.com/Essays.html> (accessed 2026-11-01)
9. Common Lisp HyperSpec, 1.1.2 History. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/01_ab.htm> (accessed 2026-11-01)
10. About the Common Lisp HyperSpec. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Front/Help.htm> (accessed 2026-11-01)
11. Common Lisp Documentation (the standard ANSI INCITS 226-1994). LispWorks. <https://www.lispworks.com/documentation/common-lisp.html> (accessed 2026-11-01)
12. Common Lisp the Language, 2nd Edition (Guy L. Steele, Digital Press, 1990). CMU Artificial Intelligence Repository. <https://www.cs.cmu.edu/Groups/AI/html/cltl/cltl2.html> (accessed 2026-11-01)
13. Steel Bank Common Lisp (home page). SBCL. <https://www.sbcl.org/> (accessed 2026-11-01)
14. History and Copyright. SBCL. <https://www.sbcl.org/history.html> (accessed 2026-11-01)
15. SBCL User Manual (Executable Delivery; `save-lisp-and-die`). SBCL. <https://www.sbcl.org/manual/> (accessed 2026-11-01)
16. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (accessed 2026-11-01)
17. Haskell Language (home page: "Purely functional"). haskell.org. <https://www.haskell.org/> (accessed 2026-11-01)
18. Common Lisp HyperSpec, Glossary: F ("function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_f.htm> (accessed 2026-11-01)
19. Common Lisp HyperSpec, Function FUNCALL. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_funcal.htm> (accessed 2026-11-01)
20. Common Lisp HyperSpec, Special Form SETQ. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_setq.htm> (accessed 2026-11-01)
21. Common Lisp HyperSpec, Special Operator TAGBODY. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/s_tagbod.htm> (accessed 2026-11-01)
22. Common Lisp HyperSpec, Macro DEFMACRO. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defmac.htm> (accessed 2026-11-01)
23. Common Lisp HyperSpec, Function MAPC, MAPCAR, .... LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_mapc_.htm> (accessed 2026-11-01)
24. Common Lisp HyperSpec, Macro DEFMETHOD (and Chapter 7, Objects). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defmet.htm> (accessed 2026-11-01)
25. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
26. 2026 Stack Overflow Developer Survey: Technology, languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
27. 2025 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2025/technology> (accessed 2026-11-01)
28. The Top Programming Languages 2025. IEEE Spectrum. <https://spectrum.ieee.org/top-programming-languages-2025> (accessed 2026-11-01)
29. Quicklisp beta. Quicklisp. <https://www.quicklisp.org/beta/> (accessed 2026-11-01)
30. Hunchentoot - The Common Lisp web server formerly known as TBNL. Edi Weitz, edicl. <https://edicl.github.io/hunchentoot/> (accessed 2026-11-01)
31. McCLIM (home page). McCLIM. <https://mcclim.common-lisp.dev/> (accessed 2026-11-01)
32. McCLIM (repository and README). Codeberg. <https://codeberg.org/McCLIM/McCLIM> (accessed 2026-11-01)
33. McCLIM releases. Codeberg. <https://codeberg.org/McCLIM/McCLIM/releases> (accessed 2026-11-01)
34. LTK - The Lisp Toolkit (home page). Peter Herth. <https://www.peter-herth.de/ltk/> (accessed 2026-11-01)
35. LTK - a Lisp binding to the Tk toolkit: Installation. Peter Herth. <https://www.peter-herth.de/ltk/ltkdoc/node3.html> (accessed 2026-11-01)
36. crategus/cl-cffi-gtk4 (README). GitHub. <https://github.com/crategus/cl-cffi-gtk4> (accessed 2026-11-01)
37. bohonghuang/cl-gtk4 (README). GitHub. <https://github.com/bohonghuang/cl-gtk4> (accessed 2026-11-01)
38. LispWorks CAPI. LispWorks. <https://www.lispworks.com/products/capi.html> (accessed 2026-11-01)
39. LispWorks prices. LispWorks. <https://www.lispworks.com/buy/prices-1c.html> (accessed 2026-11-01)
40. LispWorks Personal Edition (download page and limitations). LispWorks. <https://www.lispworks.com/downloads/index.html> (accessed 2026-11-01)
41. History of Lisp: "Conclusions". John McCarthy. <https://www-formal.stanford.edu/jmc/history/lisp/node6.html> (accessed 2026-11-01)
