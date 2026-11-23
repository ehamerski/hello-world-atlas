# Assembly (x86-64) · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Assembly](../README.md)

## What this is
A command-line program that prints exactly `Hello, World!` and ends,
written in **x86-64 assembly language** for **macOS on an Intel Mac**. It
is one file, `hello.asm`, in the syntax of **NASM**, the Netwide Assembler.

Every other folder in this repository hides the machine behind a
print statement or an equivalent library call. Here each line is one CPU instruction: put three
numbers in three registers, `call` a function, put 0 in another register,
`ret`. The function called is `write()` from the C library, which a
compiled C program also uses underneath. The decisions behind that design are
explained in [Why this toolchain](#why-this-toolchain).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| NASM (`nasm`) | 3.02 (Homebrew) | assembles `hello.asm` into an object file |
| A linker driver (`cc`) | Apple clang 21.0.0 (Command Line Tools) | links the object file with the C library, using the system linker `ld` |

## Quick start
```sh
./install.sh   # check for cc and nasm (asks before installing NASM)
./build.sh     # assemble hello.asm and link bin/hello-cli
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `cc --version` and `nasm -v`. If NASM is missing it offers `brew install nasm` (macOS) or `sudo apt-get install -y nasm` (Debian/Ubuntu) and runs it only if you answer `y`. For a missing `cc`, it offers `xcode-select --install`. | An assembler and a linker are the only tools needed. |
| `build.sh` | Runs `nasm -f macho64 -o bin/hello.o hello.asm`, then `cc -o bin/hello-cli bin/hello.o`, and prints both commands (`set -x`). On Linux and Windows it stops and points here, because `hello.asm` is macOS code. | Assembling and linking are two separate steps. A C compiler hides them in one call; this script shows both. |
| `run.sh` | Runs `./bin/hello-cli`. `--verify` does the same (a cli program ends by itself). | The executable is machine code; the CPU runs it directly. |

**The commands, one by one:**
- `nasm -f macho64` picks the output format. NASM writes many object
  formats; `macho64` is "Mach-O", the format of 64-bit macOS, and `elf64`
  would be Linux's [1].
- `-o bin/hello.o` names the object file: machine code in which `_write`
  is still an unresolved name (`nm bin/hello.o` shows `U _write`).
- `cc -o bin/hello-cli bin/hello.o`: given only an object file, clang
  compiles nothing. It runs the system linker, which adds the C library
  (`libSystem`) and the startup code that calls `_main`. Calling `ld`
  directly also works but needs the SDK path and library flags by hand;
  `cc` supplies them.

## Folder structure
```text
cli/
├── README.md     this file
├── install.sh    checks cc, checks / installs NASM
├── build.sh      assembles and links
├── run.sh        runs bin/hello-cli
├── hello.asm     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    ├── hello.o       the object file (assembler output)
    └── hello-cli     the executable (linker output)
```
- NASM has no project file and no required layout. `.asm` is the usual
  extension for NASM source (GNU `as` sources usually use `.s` or `.S`).
- `bin/` is ignored by the root `.gitignore`: build output is never
  committed.

## Step-by-step walkthrough
Open [`hello.asm`](hello.asm) next to this list.

1. **Comments** start with `;`, like Lisp, and run to the end of the line.
2. **Directives** talk to the assembler, not to the CPU:
   - `build_version macos, 11, 0` writes the target platform and the
     minimum macOS version into the object file. NASM's manual: it
     "generates a LC_BUILD_VERSION load command in the Mach-O header ...
     Newer Xcode linker versions warn if this is not present in object
     files" [1]. Remove the line and `./build.sh` prints
     `ld: warning: no platform load command found ... assuming: macOS`.
     The executable itself gets the version that `cc` gives the linker:
     `otool -l bin/hello-cli` shows `minos 26.0` on the dev machine, the
     same as a C program built there.
   - `default rel` makes `[message]` an address relative to the
     instruction pointer (RIP). By default NASM addresses are "absolute
     unless overridden with the REL specifier" [2]. Code that finds its
     data by distance works wherever the system loads it in memory
     (position-independent code). **Try it:** delete the line and run
     `./build.sh`. NASM 3.02 stops with `error: Mach-O 64-bit format does
     not support 32-bit absolute addresses`.
   - `global _main` exports the entry point so the linker can see it;
     `extern _write` declares a name defined elsewhere. On macOS a C
     function `main` is called `_main` in object files: compile any C file
     with `cc -c` and `nm` lists `T _main`. NASM's manual notes that C
     "requires it in some, but not all, system calling conventions", and
     NASM adds the underscore only if asked (`--gprefix _`) [4], so here
     it is written by hand. The Linux variant below has no underscore.
3. **Sections** group bytes of the same kind:
   - `section .data` holds initialized data. `message: db "Hello,
     World!", 10` stores 13 characters and the byte 10 (line feed,
     `\n`). There is no terminating zero, because `write()` takes a
     length, not a C string.
   - `message_len equ $ - message`: `$` is "the current address", so this
     is the length, 14, computed by the assembler. It uses no memory.
   - `section .text` holds the instructions. NASM puts it in Mach-O's
     `__TEXT,__text` section (see `objdump -d bin/hello.o`).
4. **The entry point** `_main` is a label: a name for an address. The C
   start-up code calls it like any C function.
5. **The calling convention.** Apple: "Apple platforms typically follow
   the data representation and procedure call rules" of the System V
   psABI for AMD64 [3]. For this program it means [5]:
   - integer and pointer arguments go in **RDI, RSI, RDX**, RCX, R8, R9,
     in that order;
   - the return value comes back in **RAX** (for an `int`, its lower half
     **EAX**);
   - **RSP** (the stack pointer) must be a multiple of 16 at each `call`.
     On entry to `_main` it is 8 off, because `call` pushed an 8-byte
     return address; `push rbp` fixes that. RBP is *callee-saved*, so
     `pop rbp` gives it back before `ret`.
6. **The call** `write(1, message, 14)`:
   - `mov edi, 1`: file descriptor 1 is standard output [6]. Writing a
     32-bit register (`EDI`) clears the upper half of the 64-bit register
     (RDI) [7], and the instruction is shorter.
   - `lea rsi, [message]`: "load effective address" computes the address
     without reading memory.
   - `mov edx, message_len`: 14 bytes.
   - `call _write`: pushes the return address and jumps. `write()`
     returns the number of bytes written, or -1 on error [6], in RAX;
     like most C Hello Worlds, this program ignores it.
7. **Return 0.** `xor eax, eax` sets EAX to 0 (success). Returning from
   `main` is the same as calling `exit()` with that value [8].
8. **See the machine code.** The whole program is 27 bytes of
   instructions. `objdump -d --x86-asm-syntax=intel bin/hello.o` on the
   dev machine prints:
   ```text
   0000000000000000 <_main>:
          0: 55                           push  rbp
          1: bf 01 00 00 00               mov   edi, 0x1
          6: 48 8d 35 00 00 00 00         lea   rsi, [rip]
          d: ba 0e 00 00 00               mov   edx, 0xe
         12: e8 00 00 00 00               call  0x17 <_main+0x17>
         17: 31 c0                        xor   eax, eax
         19: 5d                           pop   rbp
         1a: c3                           ret
   ```
   The `00 00 00 00` bytes are holes: the distances to `message` and to
   `_write` are not known yet. The linker fills them in (relocation).
9. **The same code in AT&T syntax.** Drop `--x86-asm-syntax=intel` and
   `objdump` prints the other x86 syntax, the default of the GNU and Apple
   assemblers:
   ```text
   pushq %rbp
   movl  $0x1, %edi
   leaq  (%rip), %rsi
   movl  $0xe, %edx
   callq 0x17 <_main+0x17>
   xorl  %eax, %eax
   popq  %rbp
   retq
   ```
   Same bytes, different text: source before destination, `%` before
   registers, `$` before constants, and a size letter on the mnemonic
   (`q` = 64 bits, `l` = 32 bits) [9]. GNU's manual sums it up: "AT&T
   and Intel syntax use the opposite order for source and destination
   operands. Intel 'add eax, 4' is 'addl $4, %eax'" [9]. Intel's own
   manual writes `MOV EAX, SUBTOTAL` with EAX as "the destination operand"
   and warns that "some assembly languages put the source and destination
   in reverse order" [7].

## Why this toolchain
**Target: x86-64 macOS (Mach-O).** The dev machine is an Intel Mac, so this
is the only target that can be verified. Assembly is tied to one
instruction set *and* one operating system's conventions (object format,
symbol names, how a program starts and does output).

**Assembler: NASM, Intel syntax.** The alternative is the assembler built
into Apple clang (`cc -c hello.s`), which reads AT&T/GAS syntax.
- NASM is "an 80x86 and x86-64 assembler designed for portability and
  modularity" [11]. One syntax covers macOS (`macho64`), Linux (`elf64`)
  and Windows (`win64`) [1], so only the OS conventions change between
  platforms, not the notation.
- Intel syntax (`mov destination, source`) is the notation of Intel's
  manual [7], so every instruction here can be looked up there as written.
- NASM is maintained (3.02, released 2026-06-29 [12]) and packaged by
  Homebrew and Debian [13][14].
- The cost: NASM is an extra installation, whereas the assembler of clang
  is already present on every Mac with the Command Line Tools.

**Output: call the C library, not the kernel.** A program can ask the
kernel directly with the `syscall` instruction; the Linux variant in
[Platform notes](#platform-notes) works that way. On macOS Apple advises
against it. Its Technical Q&A on statically linked binaries (which bypass
the system libraries) explains: "A statically linked binary assumes binary
compatibility at the kernel system call interface, and we do not make any
guarantees on that front. Rather, we strive to ensure binary compatibility
in each dynamically linked system library and framework" [15]. The system
library this program uses is `libSystem`, the only one `otool -L
bin/hello-cli` lists. A raw-syscall binary may break with a macOS
update. Calling `write()` uses the same supported path as every C program
and costs one `extern` and one `call`.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel (x86-64) | ✅ verified (2026-11-02) | NASM 3.02 (Homebrew), Apple clang 21.0.0, macOS 26.7.2. |
| macOS Apple Silicon (arm64) | ⚠️ not verified | The CPU has a different instruction set (AArch64), so `hello.asm` cannot run natively. `build.sh` links it with `cc -arch x86_64`, which produces an x86-64 executable that Rosetta translates [16]. A native version must be rewritten in AArch64 assembly (Apple's ABI for it is described in [17]), and NASM cannot assemble AArch64. |
| Linux x86-64 (ELF) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `build-essential` (when `cc` is missing) and `nasm` with apt. `build.sh` assembles `hello_linux.asm` with `nasm -f elf64` and links it with `cc`. |
| Windows x64 | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` needs MSYS2 in `C:\msys64` and installs `gcc` and `nasm` (UCRT64) with `pacman` when missing. `build.sh` assembles `hello_windows.asm` with `nasm -f win64` and links it with `gcc`. |

**Linux x86-64 variant (not verified).** It was checked only to assemble
(`nasm -f elf64` on the dev machine), not linked or run:
```nasm
        default rel
        global  _start              ; ld's default entry point, no C runtime
        section .data
message: db "Hello, World!", 10
message_len equ $ - message
        section .text
_start:
        mov     eax, 1              ; system call number 1 = write
        mov     edi, 1              ; fd 1 = standard output
        lea     rsi, [message]      ; buffer address
        mov     edx, message_len    ; byte count
        syscall                     ; enter the kernel
        mov     eax, 60             ; system call number 60 = exit
        xor     edi, edi            ; exit status 0
        syscall
```
Build with `nasm -f elf64 -o hello.o hello.asm && ld -o hello hello.o`.
The numbers 1 (`write`) and 60 (`exit`) come from the kernel's x86-64
system-call table [10]; the kernel takes the number in RAX and the
arguments in RDI, RSI, RDX [5].

## Expected output
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system loads it and the CPU runs it.
Hello, World!
```
The program itself prints only the last line; the other lines come from
`run.sh`.

## Sources
1. NASM manual, 9.9 macho32 and macho64 (9.9.6 `build_version`); chapter 9 Output Formats. The NASM Authors. <https://www.nasm.us/doc/nasm09.html#section-9.9.6> (accessed 2026-11-02)
2. NASM manual, 8.2 DEFAULT: Change the assembler defaults. The NASM Authors. <https://www.nasm.us/doc/nasm08.html#section-8.2> (accessed 2026-11-02)
3. Writing 64-bit Intel code for Apple Platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-64-bit-intel-code-for-apple-platforms> (accessed 2026-11-02)
4. NASM manual, 2.1.28 --prefix, --gprefix. The NASM Authors. <https://www.nasm.us/doc/nasm02.html#section-2.1.28> (accessed 2026-11-02)
5. System V Application Binary Interface, AMD64 Architecture Processor Supplement (psABI), 3.2 Function Calling Sequence and A.2 AMD64 Linux Kernel Conventions. x86-64 psABI maintainers. <https://gitlab.com/x86-psABIs/x86-64-ABI> (accessed 2026-11-02)
6. write (The Open Group Base Specifications Issue 8, POSIX.1-2024). The Open Group / IEEE. <https://pubs.opengroup.org/onlinepubs/9799919799/functions/write.html> (accessed 2026-11-02)
7. Intel 64 and IA-32 Architectures Software Developer's Manual, Volume 1: Basic Architecture (order no. 253665-093US, September 2026; 1.3.2.1 Instruction Operands, 2.1 Brief History, 3.4.1.1 General-Purpose Registers in 64-Bit Mode). Intel. <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html> (accessed 2026-11-02)
8. ISO/IEC 9899:TC3, committee draft WG14/N1256 (5.1.2.2.3 Program termination). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (accessed 2026-11-02)
9. Using as: 9.16.3 i386 Syntactical Considerations, AT&T Syntax versus Intel Syntax. GNU Binutils. <https://sourceware.org/binutils/docs/as/i386_002dVariations.html> (accessed 2026-11-02)
10. Linux kernel, arch/x86/entry/syscalls/syscall_64.tbl ("1 common write", "60 common exit"). The Linux kernel developers. <https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl> (accessed 2026-11-02)
11. NASM manual, 1.1 What Is NASM?. The NASM Authors. <https://www.nasm.us/doc/nasm01.html#section-1.1> (accessed 2026-11-02)
12. NASM home page (stable version 3.02, 2026-06-29). The NASM Authors. <https://www.nasm.us/> (accessed 2026-11-02)
13. `nasm` (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/nasm> (accessed 2026-11-02)
14. Package `nasm` (stable). Debian. <https://packages.debian.org/stable/nasm> (accessed 2026-11-02)
15. Technical Q&A QA1118: Statically linked binaries on Mac OS X (archived, last updated 2011-09-20). Apple. <https://developer.apple.com/library/archive/qa/qa1118/_index.html> (accessed 2026-11-02)
16. About the Rosetta translation environment. Apple. <https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment> (accessed 2026-11-02)
17. Writing ARM64 code for Apple platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms> (accessed 2026-11-02)
18. x64 calling convention. Microsoft Learn. <https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention> (accessed 2026-11-02)
