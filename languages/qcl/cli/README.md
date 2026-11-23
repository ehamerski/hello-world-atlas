# QCL · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [QCL](../README.md)

## What this is
A program in QCL that prints the text `Hello, World!`. It uses only the classical part of
QCL (a procedure and `print`), so it needs no qubits. The `qcl` interpreter reads the file
and runs it. The interpreter is a simulator: it runs on a normal computer.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| QCL interpreter (`qcl`) | 0.6.7 archive (the interpreter reports 0.6.4), built from source | runs `hello.qcl` |
| GNU readline (Homebrew formula `readline`) | 8.3.6 | QCL's command line; macOS's own readline lacks a function that QCL calls |
| C++ compiler, `make`, `flex`, `bison` | from the Command Line Tools | build QCL from source |
| `curl`, `shasum` | macOS system tools | download and check the source archive (only if QCL is missing) |

## Quick start
```sh
./install.sh   # check / build QCL 0.6.7 (asks before building it)
./build.sh     # check the syntax of hello.qcl
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `$QCL_PREFIX/bin/qcl`. If it is missing, installs `readline` if needed (Homebrew on macOS; on Linux it prints the `apt-get` command), downloads the QCL 0.6.7 archive, checks its SHA-256 digest, runs `make` (plot feature off), and copies `qcl` and `lib/` into `~/.local/qcl-0.6.7` | QCL is distributed as source, so it is built here |
| `build.sh` | Runs `qcl -q -n -I lib --syntax=y hello.qcl` and fails if the output has a line starting with `!` | QCL exits with status 0 even on a syntax error, so the output is checked |
| `run.sh` | Runs `qcl -q -n -b 2 -I lib hello.qcl </dev/null` | `-q` hides the banner, `-n` skips `default.qcl`, `-b 2` sets 2 qubits, and `</dev/null` stops QCL from waiting for typed commands |
| `qcl-env.sh` | Sets the version, the URL, the digest, the install folder and the readline folder (sourced, not run) | shared by all three scripts |

## Folder structure
```text
cli/
├── README.md       this file
├── install.sh      checks / builds QCL 0.6.7
├── qcl-env.sh      URL, SHA-256 digest, install folder (sourced)
├── build.sh        syntax check of hello.qcl
├── run.sh          runs hello.qcl
└── hello.qcl       the program (classical QCL: a procedure and print)
```
Layout reference: the repository convention in [CONTRIBUTING.md](../../../CONTRIBUTING.md#script-contract).
The QCL manual and examples are in the source archive (`lib/`).

## Step-by-step walkthrough
`hello.qcl` in order:

1. **`/* ... */` and `//`** are comments. The file starts with a block comment that
   explains the program.
2. **`procedure hello() { ... }`** defines a procedure. Its body is in braces. The
   syntax is the one used in the examples in the source archive (`lib/deutsch.qcl`).
3. **`print "Hello, World!";`** writes the text. In QCL, each `print` begins its
   output with `: ` and ends it with a space, so the line printed is `: Hello, World! `.
   The text itself is verbatim.
4. **`hello();`** calls the procedure. Statements end with `;`.

Differences from other languages in this repository: QCL is an interpreter that
also has quantum operators (for example `qureg`, `H` and `measure`, used in the
examples but not here). The output format (`: ` prefix) is the interpreter's own.

## Why this toolchain
- **QCL** is a quantum programming language and simulator, with source code by Bernhard
  Oemer [1]. It is the classical part of a quantum language, which suits a first program.
- **Qiskit** (IBM, Apache-2.0) and **Q#** (Microsoft) are among today's quantum
  programming systems [2][3]. They are not used here, because they need Python or the
  Microsoft Quantum Development Kit.
- **Build from source:** no package manager ships QCL. The archive's own Makefile is
  used, with two settings: no plot feature (it needs GNU libplotter), and Homebrew's GNU
  readline.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-10) | `build.sh` and `run.sh`; QCL built from the archive with Homebrew readline. The plot command is not built |
| macOS Apple Silicon | ⚠️ not verified | `install.sh` takes the readline folder from `brew --prefix readline`; not run |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` builds the same archive against the system readline (`libreadline-dev`, with `flex`, `bison` and a C++ compiler) and prints `apt-get` hints; not run |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` stops and points to WSL |

## Expected output
`./run.sh` (after `./build.sh`) prints one line and exits with status 0:
```text
: Hello, World! 
```
The `: ` prefix and the trailing space are added by QCL's `print`. The text `Hello, World!`
is printed verbatim. `cli` has no screenshot: the output is the text above.

## Sources
1. QCL source archive, `qcl-0.6.7.tgz` (README, `qcl.cc` and `lib/*.qcl`). Bernhard Oemer. <https://tph.itp.tuwien.ac.at/~oemer/tgz/qcl-0.6.7.tgz> (accessed 2026-11-10)
2. Qiskit documentation (IBM) and the Qiskit repository (Apache-2.0). <https://quantum.cloud.ibm.com/docs/en/guides/tools-intro> and <https://github.com/Qiskit/qiskit> (accessed 2026-11-10)
3. Q# overview. Microsoft Learn. <https://learn.microsoft.com/azure/quantum/qsharp-overview> (accessed 2026-11-10)
4. GNU readline, Homebrew formula. <https://formulae.brew.sh/formula/readline> (accessed 2026-11-10)
