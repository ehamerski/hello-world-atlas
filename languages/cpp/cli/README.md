# C++ · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C++](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, `hello.cpp`, compiled as **ISO C++20** (ISO/IEC 14882:2020 [1])
and built with **CMake**, a build system generator widely used for C++.

It is the C++ twin of the [C `cli` version](../../c/cli/): same compiler family
(Apple clang), same kind of native executable. The comments in
`hello.cpp` and the walkthrough below show line by line what C++ changes.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| A C++ compiler (`c++`) | Apple clang 21.0.0 (Command Line Tools) | compiles and links `hello.cpp` |
| CMake | 4.4.5 (Homebrew) | generates the build files (`CMakeLists.txt`) |

`std::cout` comes from the C++ standard library, which comes with every
C++ compiler (`libc++` with Clang on macOS).

## Quick start
```sh
./install.sh   # check for c++ and CMake (asks before installing)
./build.sh     # configure and build into build/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `c++ --version` and `cmake --version`. If one is missing, it offers `xcode-select --install` / `brew install cmake` (macOS) or `sudo apt-get install -y build-essential` / `cmake` (Debian/Ubuntu), or prints the MSYS2 commands (Windows), and runs them only if you answer `y`. | C++ is compiled, so it needs a compiler; CMake describes the build. |
| `build.sh` | Runs `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` (configure), then `cmake --build build` (build), printing both commands. | CMake first writes the build files into `build/`, then runs them. |
| `run.sh` | Runs `./build/hello-cli`. `--verify` does the same (a CLI program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**CMake in two steps.** CMake "is a tool to manage building of source
code" [2]; more exactly, `cmake` is "the command-line interface of the
cross-platform buildsystem generator CMake" [3]. It does not compile
anything itself:
- `cmake -S . -B build` uses `-S` as the "root directory of the CMake
  project" and `-B` as the "root of build directory" ("If the directory
  doesn't already exist CMake will make it") [3]. This step reads
  `CMakeLists.txt`, finds the compiler, and writes Makefiles into `build/`.
- `cmake --build build` runs those generated files, which call `c++` [3].

**What `CMakeLists.txt` asks for.** `CMAKE_CXX_STANDARD 20` requests the
C++ standard "whose features are requested to build this target. For some
compilers, this results in adding a flag such as `-std=gnu++11`" [4].
`CMAKE_CXX_EXTENSIONS OFF` turns off "compiler specific extensions" [5],
which are on by default [5], so the flag becomes `-std=c++20` instead of
`-std=gnu++20`. `CMAKE_CXX_STANDARD_REQUIRED ON` makes CMake stop instead
of "decaying" to an older standard [4]. The result, from
`build/CMakeFiles/hello-cli.dir/flags.make` on the test machine:
```text
CXX_FLAGS = -O3 -DNDEBUG -std=c++20 -Wall -Wextra -pedantic-errors
```
This is the same idea as `-std=c89 -pedantic-errors` in the
[C cli](../../c/cli/README.md#scripts-explained): accept only the ISO
language, no extensions.

## Folder structure
```text
cli/
├── README.md        this file
├── install.sh       checks / installs c++ and CMake
├── build.sh         configures and builds with CMake
├── run.sh           runs build/hello-cli
├── CMakeLists.txt   the CMake project: C++20, one executable
├── hello.cpp        the program
└── build/           created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- C++, like C, has no official project layout. CMake reads
  `CMakeLists.txt` from the source folder given with `-S` [3]; larger
  projects usually add `src/` and `include/` folders.
- `build/` holds everything CMake generates (an "out-of-source" build), so
  deleting it resets the build. It is ignored by the root `.gitignore`.

## Step-by-step walkthrough
Open [`hello.cpp`](hello.cpp) next to this list and
[`../../c/cli/hello.c`](../../c/cli/hello.c) next to it.

1. **Comments** are written `//` (or `/* ... */`). C added `//` only
   in C99, which is why the C `cli` version, compiled as C89, rejects it [6].
2. **`#include <iostream>`** pastes the header that declares `std::cout`,
   exactly like C's `#include <stdio.h>`: C++ kept C's preprocessor.
   C++ standard headers have no `.h`. C's headers are still there with a
   `c` in front: `<cstdio>` has "the same" contents as C's `stdio.h`, but
   its declarations are placed in namespace `std` [7].
3. **`int main()`**: the entry point is `main`, as in C. In C++, an empty
   `()` means no parameters: "If the parameter-declaration-clause is
   empty, the function takes no arguments" [8]. C needs `(void)` for that
   (until C23), so the C version writes `int main(void)`.
4. **`std::cout << "Hello, World!\n";`**: `std::` is a *namespace*, a
   named scope that keeps the standard library's names apart from yours.
   C has no namespaces, so C libraries use prefixes such as `gtk_` or
   `MHD_`. `std::cout` is a global stream object that controls output to a
   stream buffer [9]. `<<` is an *overloaded operator*: the library defines
   a version for each type, and the compiler chooses it from the type of
   the value. There is no format string as in `printf("%s", ...)`, so a
   mismatched `%` code cannot happen. As with `printf`, `\n` is the line
   break.
5. **No `return 0;`**: "If control flows off the end of the
   compound-statement of main, the effect is equivalent to a return with
   operand 0" [10]. C has had the same rule since C99, but the C `cli` version is
   C89 and therefore writes the `return`.
6. **Size and libraries.** `build/hello-cli` is 14,248 bytes on the test
   machine (macOS Intel), against 8,440 for the C version. `otool -L build/hello-cli`
   lists `/usr/lib/libc++.1.dylib` (the C++ standard library) and
   `/usr/lib/libSystem.B.dylib` (the C library); the C version loads only
   the second. Both are linked dynamically, so the code of `std::cout` and
   `printf` stays in the system's shared libraries.

## Why this toolchain
- **C++20.** This folder targets C++20. It is a published ISO
  standard ("published in 2020 as ISO/IEC 14882:2020" [1]), and the
  current one is C++23 (ISO/IEC 14882:2024) [1][11]. Clang accepts
  `-std=c++20` and lists its C++20 support as partial [12]; GCC supports
  "mostly 2020" [1]. This program uses nothing new, but the same flags are
  used in all three folders, and [../desktop](../desktop/) and
  [../web](../web/) use lambdas, which C does not have.
- **CMake instead of calling `c++` directly.** For one file, CMake is
  more than needed (the C `cli` version calls `cc` directly). It is used
  here because Qt 6, needed by [../desktop](../desktop/), documents its
  builds with CMake and provides CMake commands such as
  `qt_add_executable` [13]. Using the same tool in all three folders also
  keeps them comparable.
- **The system compiler.** Apple clang on macOS, `g++` on Linux, and `g++`
  from MSYS2 on Windows; all accept the same flags here [1][12].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-01) | Apple clang 21.0.0 (Command Line Tools, no Xcode app), CMake 4.4.5 from Homebrew. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. The executable is built for arm64. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `sudo apt-get install -y build-essential cmake` [14][15]. `c++` is `g++` there; GCC's default dialect is `-std=gnu++20` [1], which CMake replaces with `-std=c++20`. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Install MSYS2 [16]; in the "MSYS2 UCRT64" shell run `pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake` and add `C:\msys64\ucrt64\bin` to `PATH`. Then `cmake -S . -B build -G "MinGW Makefiles"` and `cmake --build build`; the program is `build\hello-cli.exe`. With Visual Studio's compiler (MSVC), remove the GCC/Clang warning flags from `CMakeLists.txt`. WSL behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: build/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Language Standards Supported by GCC (C++ Language). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (accessed 2026-11-01)
2. CMake Documentation (index; "CMake is a tool to manage building of source code"). Kitware. <https://cmake.org/cmake/help/latest/> (accessed 2026-11-01)
3. cmake(1) manual (-S, -B, --build). Kitware. <https://cmake.org/cmake/help/latest/manual/cmake.1.html> (accessed 2026-11-01)
4. CXX_STANDARD (target property). Kitware. <https://cmake.org/cmake/help/latest/prop_tgt/CXX_STANDARD.html> (accessed 2026-11-01)
5. CXX_EXTENSIONS (target property). Kitware. <https://cmake.org/cmake/help/latest/prop_tgt/CXX_EXTENSIONS.html> (accessed 2026-11-01)
6. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99; Foreword, list of changes: "// comments"). ISO/IEC JTC1/SC22/WG14, 2007. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-10-31)
7. C++ working draft, [headers] (C++ headers for C library facilities). ISO/IEC JTC1/SC22/WG21 draft, HTML edition. <https://eel.is/c++draft/headers> (accessed 2026-11-01)
8. C++ working draft, [dcl.fct] (Functions). WG21 draft, HTML edition. <https://eel.is/c++draft/dcl.fct> (accessed 2026-11-01)
9. `std::cout`, `std::wcout`. cppreference.com. <https://en.cppreference.com/w/cpp/io/cout> (accessed 2026-11-01)
10. C++ working draft, [basic.start.main] (main function). WG21 draft, HTML edition. <https://eel.is/c++draft/basic.start.main> (accessed 2026-11-01)
11. The Standard ("The current ISO C++ standard is C++23 ... ISO/IEC 14882:2024"). Standard C++ Foundation (isocpp.org). <https://isocpp.org/std/the-standard> (accessed 2026-11-01)
12. C++ Support in Clang. The Clang Team. <https://clang.llvm.org/cxx_status.html> (accessed 2026-11-01)
13. Getting started with CMake (Qt 6). The Qt Company. <https://doc.qt.io/qt-6/cmake-get-started.html> (accessed 2026-11-01)
14. Package build-essential (stable). Debian. <https://packages.debian.org/stable/build-essential> (accessed 2026-11-01)
15. Package `cmake` (stable). Debian. <https://packages.debian.org/stable/cmake> (accessed 2026-11-01)
16. MSYS2. MSYS2 project. <https://www.msys2.org/> (accessed 2026-11-01)
