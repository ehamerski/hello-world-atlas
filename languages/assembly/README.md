# Assembly (x86-64)

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative, low-level, machine-specific. An assembly program
is a list of CPU instructions, one per line, each with a written name (a
*mnemonic*) instead of its numeric code. Intel's manual describes the
format as "label: mnemonic argument1, argument2, argument3", for example
`LOADREG: MOV EAX, SUBTOTAL` [1]. The program runs from top to bottom,
changing registers and memory: the imperative paradigm with nothing in
between. "Assembly" is not one language: every instruction set (x86-64,
AArch64, ...) has its own, and even the same CPU has different notations
(see [Intel vs AT&T syntax](cli/README.md#step-by-step-walkthrough)). This
folder uses **x86-64**, the 64-bit form of Intel's x86 family, in **NASM**
syntax.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

## Implementations
| Category | Folder | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | NASM + `cc` (macOS x86-64) | ✅ |
| desktop | – | not implemented, see [Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version) | – |
| web | – | not implemented, same section | – |

## History
- **Coding by hand:** Andrew Booth and Kathleen Britten wrote the report
  *Coding for the A.R.C.* (their Automatic Relay Computer) at the
  Institute for Advanced Study in Princeton "in the summer of 1947" [2].
- **The first assembler in use:** at Cambridge, EDSAC ran its first
  program on 1949-05-06. Its "Initial Orders, (a primitive assembler) were
  hard wired on to rotary telephone switches" [3]. David Wheeler
  defined and refined them [3]. Wilkes,
  Wheeler, and Gill described this way of working in *The Preparation of
  Programs for an Electronic Digital Computer* (1951), "the first book on
  programming to be published" [3].
- **x86:** Intel's 8086 (1978) started the family this folder uses [1][4].
  The Intel386 (1985) "was the first 32-bit processor in the IA-32
  architecture family" [1]. Intel's manual stresses compatibility:
  "object code created for processors released as early as 1978 still
  executes on the latest processors" [1].
- **x86-64:** AMD extended x86 to 64 bits. On 2003-04-22 it
  "introduced the AMD Opteron processor, the world's first 64-bit
  processor" compatible with x86 [5]. Intel's version, "Intel 64
  architecture", appeared in Pentium 4 processors [1]. This is why the same
  instruction set architecture has three names: x86-64, AMD64, and Intel 64.
- **NASM:** "originally developed by Simon Tatham and Julian Hall, and is
  now maintained by a team led by H. Peter Anvin" [6]. Its first release,
  version 0.90, came out in October 1996 [7].

## Milestones
| Date | Milestone | Source |
|---|---|---|
| 1947 | *Coding for the A.R.C.* (Britten and Booth), Princeton | [2] |
| 1949-05-06 | EDSAC runs its first program; its Initial Orders are "a primitive assembler" | [3] |
| 1951 | Wilkes, Wheeler, and Gill, *The Preparation of Programs for an Electronic Digital Computer* | [3] |
| 1978 | Intel 8086, first of the x86 family | [1][4] |
| 1985 | Intel386, first 32-bit x86 (IA-32) | [1] |
| 1996 | NASM 0.90, first release | [7] |
| 2003-04-22 | AMD introduces Opteron, its first 64-bit x86 (AMD64) processor | [5] |
| 2020-06-22 | Apple announces the Mac's transition to its own chips, Apple Silicon | [8] |
| 2026-06-29 | NASM 3.02, used by [cli/](cli/) | [6] |

## Market usage today
Every number below has its date and source. They change every year.

- **TIOBE Index, October 2026:** "Assembly language" is **#23** with a
  rating of 0.76% [9]. TIOBE counts all assembly languages together, as
  one entry. The index is "an indicator of the popularity of programming
  languages", calculated from search engines [9].
- **Stack Overflow Developer Survey 2026:** 7.2% of all respondents (1,020
  of 14,099) said they had done extensive development work in Assembly
  over the past year [10].
- **Seeing it without writing it:** every compiled language in this
  repository ends as machine code, and a compiler can show it as
  assembly. Run `cc -S -masm=intel ../c/cli/hello.c` to see the assembly
  that clang writes for the C Hello World
  (compared [below](#comparing-the-categories)).

## Importance then and now
- **Then (1940s–1970s):** EDSAC's Initial Orders, "a primitive
  assembler", were part of the machine from its first program in 1949 [3].
  Assembly was what systems languages had to replace. Dennis Ritchie
  explains C's success this way: "it evidently satisfied a need for a
  system implementation language efficient enough to displace assembly
  language, yet sufficiently abstract and fluent to describe algorithms
  and interactions in a wide variety of environments" [11].
- **Now:** few programs are written in assembly (#23 in TIOBE, October
  2026 [9]; 7.2% in Stack Overflow 2026 [10]). Its importance is in
  understanding: it is what the compiled programs of this repository become.
  The machine-specific part has mattered again since Apple's move to its
  own chips in 2020 [8]: current Macs use one of two instruction sets
  (x86-64 on Intel Macs, ARM64 on Apple Silicon Macs [13]), and an x86-64
  program runs on Apple Silicon only through Rosetta, which "allows
  users to run Mac apps that contain x86_64 instructions on Apple
  silicon" [12].
- **In teaching:** assembly makes visible what high-level languages hide:
  registers, the stack and its alignment, calling conventions, object
  files, symbols, and the linker. It is the lowest level of every
  comparison in this repository.

## Comparing the categories
Assembly has one category here, `cli`. The useful comparison is with the
[C cli](../c/cli/), because both end as the same kind of executable,
linked with the same C library, on the same machine:

| | [Assembly `cli`](cli/) | [C `cli`](../c/cli/) |
|---|---|---|
| Source lines (no comments, no blank lines) | 18 | 6 |
| Printing | `call _write` with 3 arguments in RDI, RSI, RDX | `printf("Hello, World!\n");` |
| Who chooses registers and stack layout | the programmer | the compiler |
| Translation | `nasm` (assemble) + `cc` (link only) | `cc` (preprocess, compile, assemble, link) |
| Libraries loaded at run time (`otool -L`) | `libSystem` | `libSystem` |
| Executable size (`ls -l`, macOS Intel, 2026-11-02) | 12,584 bytes | 8,440 bytes |
| Runs on | x86-64 macOS only | any platform with a C compiler (rebuilt) |

The C compiler writes almost the same code. `cc -S -O0 -masm=intel` on
`c/cli/hello.c` (Apple clang 21) gives, without directives:
```text
_main:
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	dword ptr [rbp - 4], 0
	lea	rdi, [rip + L_.str]
	mov	al, 0
	call	_printf
	xor	eax, eax
	add	rsp, 16
	pop	rbp
	ret
```
Same entry point `_main`, same `push rbp`, same `lea` with RIP-relative
addressing, same `call` into `libSystem`, same `xor eax, eax` / `ret` for
"return 0". The difference is portability: the C source builds unchanged
for arm64 or Linux, while the assembly source has to be rewritten (see the
cli [Platform notes](cli/README.md#platform-notes)).

## Why there is no desktop or web version
This repository has only the cli version of assembly. A
category is included only if a maintained, mainstream, and reasonably
simple toolchain exists for it, and the result teaches something about the
language:

- **Nothing new about assembly.** The cli already shows the whole
  language mechanism: put arguments in registers, `call` a library
  function. A desktop window or a web server in assembly would be the same
  mechanism repeated many times, calling the same libraries a C program
  calls (a GUI toolkit, or the sockets API), and every call written by hand.
- **No assembly toolkit to choose.** There is no GUI or web framework
  for assembly; both versions would be hand-written calls into C or
  Objective-C libraries. The [C desktop](../c/desktop/) and
  [C web](../c/web/) versions show those libraries with the compiler doing
  the register work.
- **Even less portable.** The cli already needs a rewrite for each
  instruction set and operating system [1][13]. A GUI version would also
  tie it to one platform's GUI system.

## Sources
1. Intel 64 and IA-32 Architectures Software Developer's Manual, Volume 1: Basic Architecture (order no. 253665-093US, September 2026; 1.3.2.1 Instruction Operands, 2.1 Brief History of Intel 64 and IA-32 Architectures, 2.2 More on Intel 64). Intel. <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html> (accessed 2026-11-02)
2. The Booth-Britten reports (1947: "Coding for the A.R.C."). MacTutor History of Mathematics, University of St Andrews. <https://mathshistory.st-andrews.ac.uk/Extras/Booth-Britten_reports/> (accessed 2026-11-02)
3. EDSAC 99: a brief history of EDSAC (1949-05-06; Initial Orders; Wilkes, Wheeler and Gill, 1951). University of Cambridge Computer Laboratory. <https://www.cl.cam.ac.uk/events/EDSAC99/history.html> (accessed 2026-11-02)
4. 1978: The 8086 ushers in the x86 era. Intel Timeline. <https://timeline.intel.com/1978/the-8086-ushers-in-the-x86-era> (accessed 2026-11-02)
5. AMD press release, 2003-07-16 (Exhibit 99.1 to Form 8-K: "On April 22, AMD introduced the AMD Opteron processor"). Advanced Micro Devices, via U.S. SEC EDGAR. <https://www.sec.gov/Archives/edgar/data/2488/000119312503020249/dex991.htm> (accessed 2026-11-02)
6. NASM home page (authors; stable version 3.02, 2026-06-29). The NASM Authors. <https://www.nasm.us/> (accessed 2026-11-02)
7. NASM manual, Appendix C: NASM Version History ("Version 0.90 released October 1996"). The NASM Authors. <https://www.nasm.us/doc/nasmac.html> (accessed 2026-11-02)
8. Apple announces Mac transition to Apple silicon (2020-06-22). Apple Newsroom. <https://www.apple.com/newsroom/2020/06/apple-announces-mac-transition-to-apple-silicon/> (accessed 2026-11-02)
9. TIOBE Index for October 2026 (positions 21–50; definition of the index). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (accessed 2026-11-02)
10. 2026 Stack Overflow Developer Survey: Technology, programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (accessed 2026-11-02)
11. The Development of the C Language. Dennis M. Ritchie, HOPL-II, ACM, 1993 (author's reprint, archived copy of bell-labs.com, 2015-12-31). <https://web.archive.org/web/20151231162516/http://www.bell-labs.com/usr/dmr/www/chist.html> (accessed 2026-11-02)
12. About the Rosetta translation environment. Apple. <https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment> (accessed 2026-11-02)
13. Writing ARM64 code for Apple platforms. Apple. <https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms> (accessed 2026-11-02)
