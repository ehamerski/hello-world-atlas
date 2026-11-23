# Julia · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Julia](../README.md)

## What this is
A command-line program, written in Julia, that prints one line:
`Hello, World!`. There is no build step. The `julia` program reads `hello.jl`,
compiles each function with its "just-in-time" (JIT) compiler when the program
first calls it, and runs it [1]. The program is a script: `julia hello.jl` runs
the file [2].

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Julia (`julia`) | 1.13.4, official tarball `julia-1.13.4-mac64.tar.gz` | reads, compiles and runs `hello.jl` |
| `curl`, `shasum`, `tar` | from macOS | only for `install.sh`, when Julia is missing: download, check, unpack |

The Julia downloads page listed 1.13.4 as the stable release on
2026-11-20 (released 2026-11-13) [3]. The tarball is about 275 MB. `julia-env.sh` pins its SHA-256
digest, `c84de0fcb4268841f296fd56c47c27383d81358033428389b0d1882b110b9bcd`,
which is the digest in the file that the Julia project publishes for this
release [4]. `install.sh` checks it before unpacking.

## Quick start
```sh
./install.sh   # check Julia; if it is missing, ask, then download, check and unpack it
./run.sh       # run hello.jl
```
There is no `build.sh`: Julia has no separate build step.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Looks for `julia` in `~/.local/julia-1.13.4`. If it is missing, asks, downloads the official tarball, checks its SHA-256 digest, and unpacks it there. No `sudo` | `hello.jl` needs the Julia interpreter. The tarball is a complete Julia and needs no installer |
| `julia-env.sh` | Sourced by the other two. Sets the version, the URL, the digest, the install folder, and puts the folder first on `PATH` | Both scripts then find the same Julia, whatever your shell `PATH` is. Set `JULIA_PREFIX` to use another folder |
| `run.sh` | Runs `julia --startup-file=no hello.jl`. `--verify` does the same and exits by itself | `--startup-file=no` skips your own `startup.jl` [5], so your settings cannot change the output |

### Checking the signature by hand
The Julia project also signs each tarball with GPG. Since v1.13.0-rc2 the key
has the fingerprint `64B779A570972FFF7BFC2B54EAD471E1A1F2C10A` [6]. `install.sh`
does not check the signature; to check it yourself:
```sh
curl -fLO https://julialang.org/assets/juliareleases.asc
curl -fLO https://julialang-s3.julialang.org/bin/mac/x64/1.13/julia-1.13.4-mac64.tar.gz
curl -fLO https://julialang-s3.julialang.org/bin/mac/x64/1.13/julia-1.13.4-mac64.tar.gz.asc
gpg --import juliareleases.asc
gpg --fingerprint 64B779A570972FFF7BFC2B54EAD471E1A1F2C10A
gpg --verify julia-1.13.4-mac64.tar.gz.asc julia-1.13.4-mac64.tar.gz
```
On 2026-11-20 this printed `Good signature from "Julia Release Signing Key"`
with that fingerprint. `gpg` also prints "This key is not certified with a
trusted signature": that is normal until you certify the key yourself, so
compare the fingerprint with the one on the Julia page [6].

## Folder structure
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Julia (official tarball, no sudo)
├── julia-env.sh   pinned version, URL, SHA-256, install folder (sourced)
├── run.sh         runs hello.jl
└── hello.jl       the program (one statement)
```
A Julia source file has the extension `.jl`, and `julia script.jl` runs it [2].
Julia needs no project layout for a single script.

## Step-by-step walkthrough
1. **Comments** start with `#` and run to the end of the line.
2. **`println("Hello, World!")`** calls `println`, a function of `Base`. Julia
   loads `Base` before your code, so no `import` is needed [7]. Its documentation
   says it prints its arguments followed by a newline, to `stdout` when no
   other stream is given [8]. That is why the output ends with a newline.
3. **Double quotes** make a string. Single quotes make one character
   (a `Char`), as in `'x'` [9].
4. **No `main` and no class.** The top-level statements of the file run in
   order. Compare [C](../../c/README.md) and [Java](../../java/README.md).
5. **The first call compiles.** Julia compiles a function when the program first
   calls it [1], so even this one-line program starts the compiler.

## Why this toolchain
- `julia` is the reference implementation of the language, published by the
  Julia project. The manual describes the language as JIT-compiled and
  implemented with LLVM [1].
- The tarball needs no installer and no `sudo`, so it installs into a home folder.
  The Julia project publishes a digest and a GPG signature for it [4][6].
- The Julia downloads page listed 1.13.4 as the stable release on 2026-11-20 and 1.10.13
  as the long-term support release [3]. This folder uses the stable release.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-20) | Julia 1.13.4 from the official tarball; `install.sh`, `run.sh` and `run.sh --verify` run, each exit status 0 |
| macOS Apple Silicon | ⚠️ not verified | the pinned tarball is for Intel; `install.sh` stops and says so. Julia publishes other tarballs [10] |
| Linux (Debian/Ubuntu) | ⚠️ not verified | same: pick the Linux tarball and digest from [10] and put them in `julia-env.sh` |
| Windows (Git Bash / WSL) | ⚠️ not verified | not run; see the Julia downloads page [3] |

## Expected output
Run these commands in this folder:
```sh
./install.sh
./run.sh
```
`./install.sh` finds Julia and exits with status 0:
```text
==> 1/2 Check whether Julia is installed
    WHY: julia reads and runs hello.jl; without it the program cannot run.
[ok] Julia found: julia version 1.13.4 (/Users/<you>/.local/julia-1.13.4/bin/julia)
```
`./run.sh` prints one line after its step messages and exits with status 0;
`./run.sh --verify` prints the same:
```text
==> Run the program
    WHY: julia compiles and runs hello.jl; --startup-file=no ignores your startup.jl.
Hello, World!
```
`cli` has no screenshot: the output is the text above.

## Sources
1. Julia Documentation, Introduction, "Julia Compared to Other Languages" (Julia 1.13). The Julia Project. <https://docs.julialang.org/en/v1.13/> (accessed 2026-11-12)
2. Julia Documentation, Command-line Interface, "Using arguments inside scripts" (`julia script.jl`). The Julia Project. <https://docs.julialang.org/en/v1.13/manual/command-line-interface/> (accessed 2026-11-12)
3. Install Julia (stable release 1.13.4, November 13, 2026; long-term support release 1.10.13). The Julia Project. <https://julialang.org/downloads/> (accessed 2026-11-20)
4. SHA-256 checksums for Julia 1.13.4. The Julia Project. <https://julialang-s3.julialang.org/bin/checksums/julia-1.13.4.sha256> (accessed 2026-11-20)
5. Julia Documentation, Command-line Interface, switch `--startup-file={yes*|no}` (Julia 1.13). The Julia Project. <https://docs.julialang.org/en/v1.13/manual/command-line-interface/> (accessed 2026-11-12)
6. Manual Downloads (GPG signing key, fingerprint, and per-platform tarballs). The Julia Project. <https://julialang.org/downloads/manual-downloads/> (accessed 2026-11-12)
7. Julia Documentation, Base, Essentials (`Base` is the module loaded by default). The Julia Project. <https://docs.julialang.org/en/v1.13/base/base/> (accessed 2026-11-12)
8. Julia Documentation, I/O and Network, `println` (Julia 1.13). The Julia Project. <https://docs.julialang.org/en/v1.13/base/io-network/> (accessed 2026-11-12)
9. Julia Documentation, Strings, "Characters" (Julia 1.13). The Julia Project. <https://docs.julialang.org/en/v1.13/manual/strings/> (accessed 2026-11-12)
10. Manual Downloads, platform list. The Julia Project. <https://julialang.org/downloads/manual-downloads/> (accessed 2026-11-12)
