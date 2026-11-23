# C · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [C](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends. It is
one file, `hello.c`, written in **ANSI C**: the C of the first standard,
ANSI X3.159-1989, also published by ISO as ISO/IEC 9899:1990 and usually
called C89 or C90 [1]. `build.sh` compiles it with `-std=c89
-pedantic-errors`, so the compiler rejects anything that is not C89.

Like the [Go `cli` version](../../go/cli/), the program is compiled ahead of time
into a native executable, `bin/hello-cli`. Unlike Go, C has no build tool
and no module system of its own: `build.sh` calls the compiler directly.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| A C compiler (`cc`) | Apple clang 21.0.0 (Command Line Tools 26.6) | compiles and links `hello.c` |

No other tool is needed. `printf` comes from the C standard library, which every C
compiler installation already includes. On macOS, `cc` is Apple clang; on
Linux, it is usually GCC. Both accept the flags used here [2][3].

## Quick start
```sh
./install.sh   # check for a C compiler (asks before installing)
./build.sh     # compile hello.c as C89 into bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Runs `cc --version`. If no compiler works, it offers `xcode-select --install` (macOS) or `sudo apt-get install -y build-essential` (Debian/Ubuntu), or prints the MSYS2 commands (Windows), and runs them only if you answer `y`. | C is compiled, so a compiler is the only tool needed. |
| `build.sh` | Runs `cc -std=c89 -pedantic-errors -Wall -Wextra -o bin/hello-cli hello.c` and prints that command (`set -x`). `CC=gcc ./build.sh` picks another compiler. | Turns the source into machine code. The flags are explained below. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a CLI program ends by itself). | The executable is machine code, so the operating system runs it directly. |

**The flags, one by one:**
- `-std=c89` selects the 1989 language. GCC's manual: "The original ANSI C
  standard (X3.159-1989) was ratified in 1989 and published in 1990. This
  standard was ratified as an ISO standard (ISO/IEC 9899:1990) later in
  1990. There were no technical differences between these
  publications" [1]. Clang supports the same mode names (`c89`, `c99`,
  `c11`, `c17`, `c23`, ...) [3].
- `-pedantic-errors`: `-std` alone is not enough. GCC: "to obtain all the
  diagnostics required by the standard, you should also specify -pedantic
  (or -pedantic-errors if you want them to be errors rather than
  warnings)" [1]. Clang's short description: "Error on language
  extensions" [3].
- `-Wall`: "all the warnings about constructions that some users consider
  questionable, and that are easy to avoid"; `-Wextra`: "some extra
  warning flags that are not enabled by -Wall" [2].
- `-o bin/hello-cli` names the output; without it, the file is called `a.out`.

Without `-std`, a compiler uses its own default dialect, which is newer
and has extensions: "If no -std option is specified, clang defaults to
gnu17 mode" [3]; GCC's default is `-std=gnu23` [1].

**Try it:** add a line `// hi` to `hello.c` and run `./build.sh`. It
fails with `error: // comments are not allowed in this language`. One-line
comments came with C99: the list of changes in the C99 standard includes
"// comments" [4]. Remove the line and it builds again.

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks / installs a C compiler
├── build.sh      compiles hello.c as C89
├── run.sh        runs bin/hello-cli
├── hello.c       the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- C has no official project layout and no project file: no `go.mod`, no
  `pom.xml`. A one-file program consists of the `.c` file alone. Larger
  projects usually add a `Makefile` (or CMake/Meson files), `src/` for `.c`
  files, and `include/` for headers; one file does not need that.
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed.

## Step-by-step walkthrough
Open [`hello.c`](hello.c) next to this list.

1. **Comments** are written `/* ... */`. That is the only comment form in
   C89; `//` is C99 (see "Try it" above). Java, Go, and C++ inherited both
   forms.
2. **`#include <stdio.h>`** is a *preprocessor directive*. Before the
   compiler proper runs, the preprocessor replaces the line with the
   contents of the header `stdio.h`, which declares `printf`. Ritchie
   writes that "many other changes occurred around 1972-3, but the most
   important was the introduction of the preprocessor" [5].
   It copies text; it is not an import of a module (compare Go's `import
   "fmt"`). The code of `printf` is in the C library, which the linker
   adds: `otool -L bin/hello-cli` shows that the only library it loads is
   `/usr/lib/libSystem.B.dylib`, macOS's C library.
3. **`int main(void)`**: execution starts in `main`. It returns an `int`,
   the exit status for the operating system. `(void)` means "no
   parameters". In older C, empty parentheses `()` meant "parameters not
   specified"; C23 "mandated function declarations whose parameter
   list is empty be treated the same as a parameter list which only contain
   a single void" [6]. Compare Go's `func main()` (no return value) and
   Java's `main(String[] args)` inside a class.
4. **`printf("Hello, World!\n");`** writes the string to standard output.
   `\n` is the line break: `printf` adds none on its own, unlike Python's
   `print` or Go's `Println`. Every statement ends with `;`.
5. **`return 0;`** ends `main` with status 0 (success). C99 says "reaching
   the } that terminates the main function returns a value of 0" [4], but
   C89 has no such rule, so a C89 program writes the `return`.
6. **Compile, link, run.** `build.sh` performs all these steps in one call.
   To see them separately:
   ```sh
   cc -std=c89 -E hello.c | tail -n 5     # only preprocess: stdio.h is pasted in
   cc -std=c89 -c hello.c -o hello.o      # compile to an object file
   cc hello.o -o bin/hello-cli            # link with the C library
   ```
   (Delete `hello.o` afterwards; `*.o` files are ignored by Git.)
   `file bin/hello-cli` reports `Mach-O 64-bit executable x86_64` on the
   test machine (macOS Intel). It is 8,440 bytes, against 2.5 MB for the
   [Go `cli` version](../../go/README.md#comparing-the-categories): C's library is
   shared by the whole system instead of copied into each program.

## Why this toolchain
- **The system C compiler, invoked directly.** Every platform has one:
  Apple clang ships with Apple's Command Line Tools, GCC is packaged by
  Linux distributions such as Debian [8], and MSYS2 provides GCC on
  Windows [7]. Both Clang and GCC have a `-std` mode for every C standard from C89 to C23 [1][3].
- **C89 on purpose.** This repository targets ANSI C (strict C89 or
  C99). C89 is the original ANSI standard [1], and current compilers
  still accept it through `-std=c89` [1][3]. This folder can use C89 because it needs only
  `<stdio.h>`. [../desktop](../desktop/) and [../web](../web/) need C99 because their
  libraries' headers do.
- **No Makefile.** `make` is the classic build tool for C, but for one file
  it would only repeat the `cc` line. `build.sh` shows that line instead.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Apple clang 21.0.0 from the Command Line Tools (no Xcode app). |
| macOS Apple Silicon | ⚠️ not verified | Same commands. The executable is built for arm64. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `build-essential` with apt when `cc` is missing [8]. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install a compiler: if `cc` is missing it prints the MSYS2 steps (`pacman -S mingw-w64-ucrt-x86_64-gcc`) [7] and stops. WSL not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. Language Standards Supported by GCC (C Language). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (accessed 2026-10-31)
2. Options to Request or Suppress Warnings (-Wall, -Wextra, -Wpedantic, -pedantic-errors). GCC. <https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html> (accessed 2026-10-31)
3. Clang Compiler User's Manual (C language modes, default mode, -pedantic-errors). The Clang Team. <https://clang.llvm.org/docs/UsersManual.html> (accessed 2026-10-31)
4. ISO/IEC 9899:TC3, committee draft WG14/N1256 (C99 with corrigenda; Foreword list of changes, 5.1.2.2.3 Program termination). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-10-31)
5. The Development of the C Language. Dennis M. Ritchie, HOPL-II, ACM, 1993 (author's reprint, archived copy of bell-labs.com, 2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (accessed 2026-10-31)
6. ISO/IEC 9899:2024, working draft WG14/N3220 (C23; Annex M, list of changes). ISO/IEC JTC1/SC22/WG14. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf> (accessed 2026-10-31)
7. MSYS2 (and package mingw-w64-gcc). MSYS2 project. <https://www.msys2.org/>, <https://packages.msys2.org/base/mingw-w64-gcc> (accessed 2026-10-31)
8. Package build-essential (stable). Debian. <https://packages.debian.org/stable/build-essential> (accessed 2026-10-31)
