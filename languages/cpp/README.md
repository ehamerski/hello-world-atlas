# C++

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** multi-paradigm. In its creator's words, "C++ is a
multi-paradigm programming language that supports Object-Oriented and other
useful styles of programming" [1], including "traditional procedural
programming, object-oriented programming, and generic programming" [1].
The three programs here show some of these styles. The [`cli`](cli/) version is
procedural, like C. The [desktop](desktop/) version uses Qt's class
hierarchy (object-oriented). The [web](web/) version passes a lambda, an
unnamed function, to a library as a value.

See also: [paradigms](../../docs/paradigms.md#object-oriented) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | CMake, C++20 | ✅ |
| desktop | [desktop/](desktop/) | Qt 6 Widgets, CMake | ✅ |
| web | [web/](web/) | cpp-httplib, CMake | ✅ |

All three are compiled as **ISO C++20** (`-std=c++20`, no compiler
extensions, `-pedantic-errors`) and built with **CMake**. Each folder is
the twin of the same category in [C](../c/README.md), so the two languages
can be compared side by side.

## History
Bjarne Stroustrup's FAQ is the main source for this section [1].

- **Why:** "I wanted to write efficient systems programs in the styles
  encouraged by Simula67. To do that, I added facilities for better type
  checking, data abstraction, and object-oriented programming to C" [1].
  The specific problem "had to do with distributing operating system
  facilities across a network" [1].
- **C with Classes (1979):** "I started work on what became C++ in 1979.
  The initial version was called "C with Classes"" [1]. One feature was
  there from the start: "deterministic destruction, it was in "C with
  Classes" in the first week or two (1979)" [1]. That feature is what
  lets the desktop and web programs here clean up without a `free` or
  `unref` call.
- **Why C:** "I wanted C++ to be compatible with a complete language with
  sufficient performance and flexibility for even the most demanding
  systems programming. At the time, I considered C the best systems
  programming language available" [1]. "C++ is a direct descendant of C
  that retains almost all of C as a subset" [1].
- **Where the ideas came from:** "C++ got the key notions of classes,
  derived classes, virtual functions (in other words, the notions of
  encapsulation, inheritance and polymorphism) from Simula" [1].
- **The name (1983):** "The first version of C++ was used internally in
  AT&T in August 1983. The name "C++" was used late that year" [1]. "The
  name C++ (pronounced "see plus plus") was coined by Rick Mascitti in the
  summer of 1983. The name signifies the evolutionary nature of the
  changes from C; "++" is the C increment operator" [1].
- **First release (1985):** "The first commercial implementation was
  released October 1985 at the same time as the publication of the 1st
  edition of The C++ Programming Language" [1]. That compiler, Cfront,
  "was written in C++" [1].
- **Standards:** C++ has been an ISO standard since 1998, with revisions
  published in 2003, 2011, 2014, 2017, 2020, and 2024 [2]. The committee is
  ISO/IEC JTC1/SC22/WG21, "the international standardization working group for
  the programming language C++" [3].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 1979 | Stroustrup starts "C with Classes" | [1] |
| 1983 | First internal use at AT&T (August); the name "C++" is used late that year | [1] |
| 1985 | First commercial implementation (Cfront) and *The C++ Programming Language*, 1st edition (October) | [1] |
| 1998 | **C++98**, ISO/IEC 14882:1998, the first ISO standard | [2] |
| 2003 | C++03, ISO/IEC 14882:2003 (technical corrigendum) | [2] |
| 2011 | **C++11**, ISO/IEC 14882:2011 | [2] |
| 2014 | C++14, ISO/IEC 14882:2014 | [2] |
| 2017 | C++17, ISO/IEC 14882:2017 (Qt 6 requires at least this one [4]) | [2][4] |
| 2020 | **C++20**, ISO/IEC 14882:2020. Used by every folder here | [2] |
| 2024 | C++23, ISO/IEC 14882:2024, the current standard. It is "called C++23 because 2023 is the year the technical work was completed" | [2][5] |

The next revision is informally called C++26; Clang already supports "some
of the features" with `-std=c++2c` [6].

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** C++ is **#3** with a rating of 8.87%,
  also #3 in October 2025 [7]. C is #2 (11.33%) [7]. TIOBE named C++
  "Programming Language of the Year" for 2003 and 2022 [7]. TIOBE calls its
  index "an indicator of the popularity of programming languages", based on
  search engines, "not about ... the language in which most lines of code
  have been written" [7].
- **Stack Overflow Developer Survey 2026:** 24.3% of all respondents
  (3,425 of 14,099) said they had done "extensive development work" in
  C++ over the past year, against 21.8% for C [8]. 15.8% of all respondents
  want to use C++ ("desired"), and its "admired" score is 45.8% (C:
  14.2% and 45.9%) [9].

## Importance then and now
- **Then:** C++ brought Simula's classes to C's efficiency and C's
  existing code. It was used inside AT&T from 1983 and sold from 1985 [1].
  Because it "retains almost all of C as a subset" [1], C programmers could
  adopt it step by step.
- **Now:** #3 in TIOBE (October 2026) [7], used extensively by 24.3% of
  Stack Overflow's 2026 respondents [8], and still revised by ISO: the
  current standard was published in 2024, and C++26 is in progress [2][5][6].
- **In teaching:** the same program can be written in C style and in C++
  style, and the
  [comparison with C](#comparison-with-c) below shows what each C++
  feature replaces.

## Comparison with C
C++ grew out of [C](../c/README.md), so this page compares the two. Every
folder here is the twin of the C folder of the same category:

| What | [C](../c/README.md) | C++ (this folder) |
|---|---|---|
| Standard used | C89 (`cli`), C99 (`desktop`, `web`) | C++20 everywhere |
| Print a line | `printf("Hello, World!\n");` (format string) | `std::cout << "Hello, World!\n";` (overloaded `<<`, checked by type) |
| Comments | `/* */` only in C89; `//` from C99 | `//` and `/* */` |
| `main` | `int main(void)` + `return 0;` (C89) | `int main()`; falling off the end returns 0 [10] |
| Names | prefixes: `gtk_`, `MHD_` | namespaces: `std::`, `httplib::`, `Qt::` |
| Objects | structs + functions, casts like `GTK_WINDOW(w)` | classes with member functions: `label.setWindowTitle(...)` |
| Callbacks | function pointer + `void *` user data | lambdas that capture variables: `[&app] { app.quit(); }` |
| Cleanup | by hand: `g_object_unref`, `MHD_destroy_response` | automatic: destructors run when an object goes out of scope (RAII) |
| Errors | return codes (`atoi` returns 0, `NULL`) | also exceptions (`std::stoi` throws) |
| Build | `cc` called directly; `pkg-config` for libraries | CMake: `find_package` / `find_path`, `cmake --build` |
| Executable size (test machine, macOS Intel) | cli 8,440 · desktop 9,888 · web 9,472 bytes | cli 14,248 · desktop 32,840 · web 695,672 bytes |

What stays the same: both are compiled ahead of time by the same compiler
family (Apple clang), into a native executable. Neither has a garbage
collector or a virtual machine. The C++ `cli` executable is somewhat
larger and also loads `libc++`, the C++ standard library. The web version is much
larger because cpp-httplib is header-only and compiled into the program,
while C's libmicrohttpd stays a shared library.

## Comparing the categories
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Lines of C++ (no comments, no blank lines) | 5 | 21 (5 are the self-check) | 29 |
| Library | C++ standard library only | Qt 6.12 Widgets (+ Qt GUI, Qt Core) | cpp-httplib 0.64 (one header) |
| How CMake finds it | not needed | `find_package(Qt6 REQUIRED COMPONENTS Widgets)` | `find_path(... httplib.h)` + `Threads::Threads` |
| Linked libraries (`otool -L`) | `libc++`, `libSystem` | QtWidgets, QtGui, QtCore + Apple frameworks + `libc++`, `libSystem` | `libc++`, `libSystem` |
| Who owns the loop | nobody: `main` prints and returns | Qt's event loop (`app.exec()`) | cpp-httplib (`server.listen(...)` blocks) |
| C++ features shown | namespaces, `<<` | classes, RAII, lambda | lambda, references, exceptions |
| Output | text on stdout | a native window | HTML over HTTP |

The `CMakeLists.txt` files differ only in the library lines; the scripts
are the same in all three folders. Installing Qt was the longest step on
the test machine (macOS Intel): Homebrew has no Intel Mac bottle for
`qtbase` [11], so Homebrew compiled it from source, while cpp-httplib is a single header.

C++ has an implementation in each of its three categories, so this page
has no section that explains a missing category.

## Sources
1. Bjarne Stroustrup's FAQ (When was C++ invented?, Why did you invent C++?, Where did the name "C++" come from?, Is C++ an Object-Oriented language?, What is the difference between C and C++?). Bjarne Stroustrup. <https://www.stroustrup.com/bs_faq.html> (accessed 2026-11-01)
2. Language Standards Supported by GCC (C++ Language: C++98 to C++23). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (accessed 2026-11-01)
3. ISO/IEC JTC1/SC22/WG21 - The C++ Standards Committee. WG21. <https://www.open-std.org/jtc1/sc22/wg21/> (accessed 2026-11-01)
4. Getting started with CMake ("Qt 6 requires a compiler supporting C++ version 17 or newer"). The Qt Company. <https://doc.qt.io/qt-6/cmake-get-started.html> (accessed 2026-11-01)
5. The Standard ("The current ISO C++ standard is C++23, formally known as ... ISO/IEC 14882:2024(E)"). Standard C++ Foundation (isocpp.org). <https://isocpp.org/std/the-standard> (accessed 2026-11-01)
6. C++ Support in Clang. The Clang Team. <https://clang.llvm.org/cxx_status.html> (accessed 2026-11-01)
7. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-01)
8. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-01)
9. 2026 Stack Overflow Developer Survey: admired and desired languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/da-language> (accessed 2026-11-01)
10. C++ working draft, [basic.start.main] (main function). ISO/IEC JTC1/SC22/WG21 draft, HTML edition. <https://eel.is/c++draft/basic.start.main> (accessed 2026-11-01)
11. `qtbase` (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/qtbase> (accessed 2026-11-01)
