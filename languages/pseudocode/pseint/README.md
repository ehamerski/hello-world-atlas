# Pseudocode · PSeInt: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Pseudocode](../README.md)

## What this is
A pseudocode algorithm, [`hola.psc`](hola.psc), that prints exactly
`Hello, World!`, run by **PSeInt**. PSeInt "es una herramienta para asistir
a un estudiante en sus primeros pasos en programación" ("is a tool to help
a student take their first steps in programming"), with a "pseudolenguaje
en español" ("pseudo-language in Spanish") [1]. Its author, Pablo Novara,
is a graduate and lecturer of Computer Engineering at Universidad Nacional
del Litoral, Argentina [2]. Why PSeInt is one of the three variants is
explained in the [pseudocode overview](../README.md#ranking-evidence).

Most pseudocode is only read. PSeInt is different: its editor checks and
runs the algorithm, and the same interpreter can be started from a
terminal, which is what `run.sh` does. Like the
[Python CLI](../../python/cli/), there is no `build.sh`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| PSeInt | 20250314 (official archive `pseint-mi64-20250314.tgz`) | its `pseint` interpreter runs `hola.psc` |
| `curl`, `tar`, `shasum` | macOS built-ins | `install.sh` downloads, checks and unpacks the archive |

PSeInt is not in Homebrew or Debian, so `install.sh` downloads the official
archive. The download page says it "No necesita instalación, solo
descomprimir y ejecutar" ("needs no installation, just unpack and run")
[3].

## Quick start
```sh
./install.sh   # check / install PSeInt into ~/.local/pseint-20250314 (asks first)
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Looks for the interpreter in `~/.local/pseint-20250314`. If it is missing, asks, downloads the archive for your OS from SourceForge, checks its SHA-256 checksum against the value published for release 20250314 [4], and unpacks it. No `sudo`. On Windows it prints the manual steps. | PSeInt is distributed as an archive to unpack, not as a package [3]. The checksum proves the file is the published release. |
| `run.sh` | Runs `pseint hola.psc --nouser`. `--verify` does the same. | `--nouser` makes the interpreter "no mostrar mensajes de estado ni esperar un tecla al final" ("not show status messages or wait for a key at the end"), from the help that `pseint` prints when run without arguments. Without it the program waits for a key. |
| `pseint-env.sh` | Sourced by both: sets the version, the folder, the archive name and checksum for your OS, and the interpreter path. | One place to change the version. |

Both scripts accept `PSEINT=/path/to/pseint` and `PSEINT_DIR=/some/dir`.

## Folder structure
```text
pseint/
├── README.md       this file
├── install.sh      checks / installs PSeInt (official archive)
├── run.sh          runs pseint hola.psc --nouser
├── pseint-env.sh   shared settings: version, folder, checksums
└── hola.psc        the algorithm (teaching comments)
```
- `.psc` is the extension PSeInt's editor uses for algorithms; its
  bundled examples use it too (`ejemplos/` in the archive).
- Nothing is written into this folder, so Git has nothing to ignore.

## Step-by-step walkthrough
Open [`hola.psc`](hola.psc) next to this list.

1. **Comments** start with `//`, as in C++ or Java.
2. **`Algoritmo HolaMundo`** opens the algorithm and names it. PSeInt also
   accepts `Proceso` ... `FinProceso` (tested with release 20250314).
3. **`Escribir "Hello, World!";`** ("write") prints the text and a line
   break, like Python's `print`.
4. **`FinAlgoritmo`** closes the block, like `end` in Pascal.
5. **Profiles.** PSeInt lets each school adapt the language: the first time
   it runs, it asks the student to choose a profile "para su
   universidad/facultad/carrera" ("for their university/faculty/degree"),
   which sets the language "de acuerdo a las exigencias de su docente"
   ("according to their teacher's requirements") [5]. Release 20250314
   ships 467 profiles in `perfiles/`; 24 of them set `force_semicolon=1`
   (counted 2026-11-02). With the default settings the `;` is optional.

**Try it** (after `./install.sh`, from this folder):
```sh
. ../../../scripts/common.sh && . ./pseint-env.sh
printf 'Algoritmo A\n Escribir "no semicolon"\nFinAlgoritmo\n' > /tmp/a.psc
"$PSEINT" /tmp/a.psc --nouser                     # prints: no semicolon
"$PSEINT" /tmp/a.psc --nouser --force_semicolon=1 # Lin 2 (inst 1): ERROR 38: Falta punto y coma.
```
The option `--<opt>=0|1` changes one profile option for this run (from the
help text of `pseint`). Note that the interpreter still exits with status 0 after this
syntax error (observed with 20250314), so scripts must check the output,
as `scripts/verify-all.sh` does.

## Why this toolchain
- PSeInt is the interpreter that the author of this pseudocode publishes [1][2]. It
  is free software (GPLv2) [6] and still released: 20250314 is the
  current version, with native builds for Windows, macOS, and Linux [1].
- Of the candidates that publish download numbers, it has the most: 16,705,302
  SourceForge downloads all-time, read 2026-11-02 [7] (details in the
  [overview](../README.md#ranking-evidence)).

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-02) | `pseint-mi64-20250314.tgz`; interpreter at `pseint.app/Contents/Resources/pseint`. |
| macOS Apple Silicon | ⚠️ not verified | `install.sh` uses `pseint-ma64-20250314.tgz` [4]; same layout assumed. |
| Linux | ⚠️ not verified | `install.sh` uses `pseint-l64-20250314.tgz` [4]; interpreter assumed at `pseint/bin/pseint`. |
| Windows (Git Bash / WSL) | ⚠️ not verified | Unzip `pseint-w64-20250314.zip` [4] and run `PSEINT=/c/<folder>/pseint/pseint.exe ./run.sh` (the command `install.sh` prints). The Windows Subsystem for Linux (WSL) behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run hola.psc with the PSeInt interpreter
    WHY: PSeInt reads the pseudocode and executes it; --nouser prints only
         the program's output and does not wait for a key at the end.
Hello, World!
```

## Sources
1. PSeInt (home page). <https://pseint.sourceforge.net/> (accessed 2026-11-02)
2. "Premian a docente de la FICH por un desarrollo de software libre" (A FICH lecturer is honored for a free-software development). Universidad Nacional del Litoral, 2015-09-03. <https://www.unl.edu.ar/noticias/news/view/premian_a_docente_de_la_fich_por_un_desarrollo_de_software_libre_1> (accessed 2026-11-02)
3. "Descargas" (Downloads). PSeInt. <https://pseint.sourceforge.net/index.php?page=descargas.php> (accessed 2026-11-01)
4. PSeInt files, release 20250314. SourceForge. <https://sourceforge.net/projects/pseint/files/20250314/> (accessed 2026-11-01)
5. "Perfiles" (Profiles). PSeInt. <https://pseint.sourceforge.net/index.php?page=perfiles.php> (accessed 2026-11-02)
6. PSeInt project page. SourceForge. <https://sourceforge.net/projects/pseint/> (accessed 2026-11-02)
7. PSeInt download statistics. SourceForge. <https://sourceforge.net/projects/pseint/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (accessed 2026-11-02)
