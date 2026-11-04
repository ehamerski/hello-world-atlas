<!--
TEMPLATE for languages/<language>/<category>/README.md (checklist "Each
implementation" in CONTRIBUTING.md). Keep every section, in this order. Replace each
<placeholder>, then delete this comment. Every fact needs a source that
follows docs/sources.md.
-->
# <Language> · <category>: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [<Language>](../README.md)

## What this is
<!-- one short paragraph. What the program does in this category:
cli prints "Hello, World!", desktop opens a window, web serves a page. -->

## Prerequisites
<!-- Tools and versions this implementation needs. ./install.sh checks them. -->
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| <tool> | <x.y.z> | <reason> |

## Quick start
```sh
./install.sh   # check / install the toolchain (asks before installing)
./build.sh     # compile (only for compiled languages; delete this line otherwise)
./run.sh       # run it
```

## Scripts explained
<!-- for each script, what it does and WHY each step is needed.
The script headers and their runtime messages say the same thing. -->
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | <...> | <...> |
| `build.sh` | <...> | <...> |
| `run.sh` | <...> (`--verify` runs a self-check and exits) | <...> |

## Folder structure
<!-- the idiomatic layout for this toolchain, with the official doc that
defines it (e.g. Maven "Standard Directory Layout"). Explain every file. -->
```text
<category>/
├── README.md      this file
├── install.sh     checks / installs the toolchain
├── build.sh       compiles (compiled languages only)
├── run.sh         runs the program
└── <source files>
```
Layout reference: <official URL>

## Step-by-step walkthrough
<!-- guided reading of the source, line by line or block by block, for
a beginner. Point out what differs from other languages and link to the
comparison in ../README.md or ../../../docs/comparisons.md. -->
1. <...>

## Why this toolchain
<!-- why this compiler / framework / GUI toolkit is the current market
standard (or the standard of its era, or its maintained successor).
Every claim cited. -->

## Platform notes
<!-- only macOS Intel is verified on the development machine. Keep the
"not verified" marks unless the steps were really run on that platform. -->
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (<date>) | <...> |
| macOS Apple Silicon | ⚠️ not verified | <...> |
| Linux (Debian/Ubuntu) | ⚠️ not verified | <...> |
| Windows (Git Bash / WSL) | ⚠️ not verified | <native Windows commands> |

## Expected output
<!-- Exact output of ./run.sh. Web: the curl output and the port, plus a
browser screenshot. Desktop: a screenshot of the window. Store the image
next to this README as screenshot.png and say how it was taken. -->
```text
Hello, World!
```

## Sources
<!-- Follows docs/sources.md: HTTPS only, official docs first,
"accessed YYYY-MM-DD" on each entry. -->
1. <Title>. <Publisher>. <https://...> (accessed <YYYY-MM-DD>)
