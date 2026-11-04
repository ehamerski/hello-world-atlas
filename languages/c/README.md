# C (ANSI C)

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (procedural). A C program is a set of functions
whose statements change data one step at a time. The standard defines a
statement this way: "A statement specifies an action to be performed.
Except as indicated, statements are executed in sequence" [1]. There are no
classes and no objects in the language: compare [Java](../java/README.md),
where even Hello World needs a class. GTK's C API in [desktop/](desktop/)
shows how object-oriented libraries are still written in C, with structs,
function pointers, and naming conventions.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Standard | Status |
|---|---|---|---|---|
| cli | [cli/](cli/) | Apple clang 21 (`cc`) | **C89** (`-std=c89 -pedantic-errors`) | ✅ verified on macOS Intel |
| desktop | [desktop/](desktop/) | `cc` + GTK 4.24 (`pkg-config gtk4`) | C99 (`-std=c99 -pedantic`) | ✅ verified on macOS Intel |
| web | [web/](web/) | `cc` + GNU libmicrohttpd 1.0.10 | C99 (`-std=c99 -pedantic-errors`) | ✅ verified on macOS Intel |

"ANSI C" means the C of the first standard, ANSI X3.159-1989, which ISO
published unchanged as ISO/IEC 9899:1990 [2]. Every folder is compiled in
a strict ISO mode (`-std=...` plus `-pedantic`), so compiler-specific
extensions are rejected or reported. The `cli` version is pure C89. The
`desktop` and `web` versions use C99, because the headers of the libraries they
call need it; each README shows the compiler message that proves it.

## History
C was created by Dennis Ritchie at Bell Labs. His own account, *The
Development of the C Language* (HOPL-II, 1993), is the main source for this
section [3].

- **Purpose:** "The C programming language was devised in the early 1970s
  as a system implementation language for the nascent Unix operating
  system" [3].
- **Ancestors, BCPL and B:** Ken Thompson "decided that Unix ... needed a
  system programming language. After a rapidly scuttled attempt at
  Fortran, he created instead a language of his own, which he called B. B
  can be thought of as C without types; more accurately, it is BCPL
  squeezed into 8K bytes of memory" [3]. Ritchie extended B with types:
  "I called the slightly-extended language NB, for 'new B'"; his paper
  calls NB "embryonic C" [3].
- **When:** "C came into being in the years 1969-1973, in parallel with the
  early development of the Unix operating system; the most creative period
  occurred during 1972" [3]. Among the changes of 1972–73, "the most
  important was the introduction of the preprocessor" (the `#include`
  line in every program here) [3].
- **Unix in C:** "By early 1973, the essentials of modern C were complete.
  The language and compiler were strong enough to permit us to rewrite the
  Unix kernel for the PDP-11 in C during the summer of that year" [3].
  A second wave of changes to C "peaked between 1977 and 1979, when
  portability of the Unix system was being demonstrated" [3].
- **K&R:** "In 1978 Brian Kernighan and I published The C Programming
  Language", a book that "served as the language reference until a formal
  standard was adopted more than ten years later" [3].
- **ANSI:** "ANSI established the X3J11 committee under the direction of
  CBEMA in the summer of 1983, with the goal of producing a C standard.
  X3J11 produced its report [ANSI 89] at the end of 1989, and subsequently
  this standard was accepted by ISO as ISO/IEC 9899-1990" [3].

Today the standard is maintained by ISO/IEC JTC1/SC22/WG14, "the
international standardization working group for the programming language
C" [4].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 1969–1973 | C created at Bell Labs, alongside Unix; "the most creative period occurred during 1972" | [3] |
| 1973 | The Unix kernel for the PDP-11 is rewritten in C | [3] |
| 1978 | *The C Programming Language* (Kernighan and Ritchie, "K&R"): the de facto reference | [3] |
| 1983 | ANSI forms the X3J11 committee to standardize C | [3] |
| 1989 / 1990 | **ANSI C**: X3.159-1989, "ratified in 1989 and published in 1990", then ISO/IEC 9899:1990 ("C89"/"C90"). Used by [cli/](cli/) | [2][3] |
| 1999 | C99, ISO/IEC 9899:1999: `//` comments, `long long`, `<stdint.h>`, implicit `return 0` from `main`. Used by [desktop/](desktop/) and [web/](web/) | [2][1] |
| 2011 | C11, ISO/IEC 9899:2011 | [2] |
| 2018 | C17, ISO/IEC 9899:2018: C11 with corrections, no new features | [2] |
| 2024 | C23, ISO/IEC 9899:2024, the current standard: `bool`, `true`, `false` as keywords; empty `()` in a declaration now means "no parameters" | [2][4][5] |

GCC's documentation also mentions the next revision in progress, "known as
C2Y" [2].

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** C is **#2** with a rating of 11.33%, also
  #2 in October 2025 [6]. TIOBE names C "Programming Language of the Year"
  (the language with "the highest rise in ratings in a year") for 2008,
  2017 and 2019 [6]. TIOBE calls its index "an indicator of the popularity
  of programming languages", calculated from search engines and websites,
  and "not about ... the language in which most lines of code have been
  written" [6].
- **Stack Overflow Developer Survey 2026:** 21.8% of all respondents
  (3,070 of 14,099) said they had "done extensive development work" in C
  over the past year [7]. Of those, 45.9% want to keep using it
  ("admired"); 14.2% of all respondents want to use it ("desired") [7].
- **Where C runs:** "The Linux kernel is written in the C programming
  language", compiled "under -std=gnu11 ... the GNU dialect of ISO C11" [8].
  "SQLite is a C-language library" and, per its authors, "the most used
  database engine in the world" [9]. GTK, used in [desktop/](desktop/),
  "is written in C" [10], and so is libmicrohttpd [11]. Libraries written in
  C are called from other languages too: in this repository the
  [Go desktop](../go/desktop/) version needs a C compiler because its GUI
  toolkit, Fyne, contains C code.

## Importance then and now
- **Then (1970s–1980s):** C was the language Unix was written in, and
  Unix's portability was demonstrated with it in 1977–1979 [3]. Ritchie's own summary:
  "C is quirky, flawed, and an enormous success. ... it evidently satisfied
  a need for a system implementation language efficient enough to displace
  assembly language, yet sufficiently abstract and fluent to describe
  algorithms and interactions in a wide variety of environments" [3].
- **Its family resemblance:** compare the Hello World programs in this
  repository. The [Java](../java/cli/) and [Go](../go/cli/) versions use
  the same braces, the same `/* */` and `//` comment forms, and a
  `main` entry point. Their formatted printing comes from C too: Go's `fmt`
  "implements formatted I/O with functions analogous to C's printf and
  scanf" [12], and in Java "formatted printing ... is heavily inspired by
  C's printf" [13].
- **Now:** still #2 in TIOBE (October 2026) [6] and used extensively by
  21.8% of Stack Overflow's 2026 respondents [7]. It is the language of
  operating system kernels, embedded databases, and system libraries [8][9][10].
- **In teaching:** C shows what other languages hide. A string is an array
  of bytes ending in `'\0'`; memory and objects are released by hand
  (`MHD_destroy_response`, `g_object_unref`); libraries are a header plus a
  binary that the linker connects. The price is safety: nothing checks
  array bounds or the types of a variadic call (see the
  [web walkthrough](web/README.md#step-by-step-walkthrough)).

## Comparing the categories
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Lines of C (no comments, no blank lines) | 6 | 39 (6 are the self-check) | 67 |
| Standard (`-std`) | C89 | C99 | C99 |
| Library | C standard library only (`<stdio.h>`) | GTK 4.24 (+ GLib, Pango, Cairo, ...) | GNU libmicrohttpd 1.0.10 |
| How the library is found | not needed | `pkg-config --cflags --libs gtk4` | `pkg-config --cflags --libs libmicrohttpd` |
| Executable (`ls -l`, macOS Intel) | 8,440 bytes | 9,888 bytes | 9,472 bytes |
| Libraries loaded at run time (`otool -L`) | `libSystem` (the C library) | `libgtk-4` + 11 more GTK/GLib/Pango/Cairo libraries + `libSystem` | `libmicrohttpd` + `libSystem` |
| Who owns the loop | nobody: `main` prints and returns | GTK's main loop (`g_application_run`) | `for (;;) MHD_run_wait(...)` in `main` |
| Output | text on stdout | a native window | HTML over HTTP |

What stays the same: one `hello.c`, compiled by `cc` in strict ISO mode
and linked into one native executable in `bin/`. What changes is only the
library. The executables are tiny because, unlike
[Go](../go/README.md#comparing-the-categories), C links its libraries
**dynamically**: the code of `printf`, GTK and libmicrohttpd stays in shared
libraries on the system, which must therefore be installed where the
program runs.

The other difference is the C standard: the `cli` version is pure C89, while GTK's
and libmicrohttpd's headers require C99 (`long long`, `<stdint.h>`), so
those two folders use `-std=c99`.

C has an implementation in each of its three categories, so this page has
no section that explains a missing category.

## Sources
1. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99 with corrigenda; Foreword list of changes; 6.8 Statements and blocks). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-10-31)
2. Language Standards Supported by GCC (C Language: C89/C90, C99, C11, C17, C23, C2Y). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (accessed 2026-10-31)
3. The Development of the C Language. Dennis M. Ritchie, Second History of Programming Languages conference (HOPL-II), ACM, 1993. Author's reprint, archived copy of bell-labs.com (2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (accessed 2026-10-31)
4. ISO/IEC JTC1/SC22/WG14 - C (home page: "The current C programming language standard (C23) [ISO/IEC 9899] was adopted by ISO and IEC in 2024"). WG14. <https://www.open-std.org/jtc1/sc22/wg14/> (accessed 2026-10-31)
5. ISO/IEC 9899:2024, working draft WG14/N3220 (C23; Annex M, list of changes). WG14. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf> (accessed 2026-10-31)
6. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-10-31)
7. 2026 Stack Overflow Developer Survey: Technology, programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> and <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
8. Programming Language (Linux kernel documentation). The kernel development community. <https://docs.kernel.org/process/programming-language.html> (accessed 2026-10-31)
9. SQLite home page. SQLite. <https://www.sqlite.org/index.html> (accessed 2026-10-31)
10. The GTK Project (home page). GNOME. <https://www.gtk.org/> (accessed 2026-10-31)
11. GNU libmicrohttpd. GNU Project. <https://www.gnu.org/software/libmicrohttpd/> (accessed 2026-10-31)
12. Package `fmt`. The Go Authors. <https://pkg.go.dev/fmt> (accessed 2026-10-31)
13. Class Formatter (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/Formatter.html> (accessed 2026-10-31)
