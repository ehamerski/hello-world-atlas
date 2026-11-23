# Pseudocode · Portugol (VisuAlg dialect): Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Pseudocode](../README.md)

## What this is
A Portugol algorithm, [`ola-mundo.alg`](ola-mundo.alg), that prints
exactly `Hello, World!`. Portugol is a family of pseudocode dialects
with Portuguese keywords, used in Brazilian intro programming courses; it "tem
diversas variações em sintaxe" ("has several syntax variations") [1]. This
folder uses the **VisuAlg** variation, the language of the VisuAlg editor,
whose version 3.0 alone has almost 3 million downloads, about 90% of them
from Brazil (read 2026-11-02) [2]. Why Portugol is one of the three
variants is explained in the
[pseudocode overview](../README.md#ranking-evidence).

The program is run by **Delégua**, a free (MIT) interpreter for Node.js
with "suporte a múltiplos dialetos, como variações de Portugol (VisuAlg,
Portugol Studio, Portugol IPT, Mapler)" ("support for several dialects,
such as Portugol variations (VisuAlg, Portugol Studio, Portugol IPT,
Mapler)") [3]. Like the [Python CLI](../../python/cli/), there is no
`build.sh`.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js + npm | 26.8.2 / 12.2.1 (Homebrew) | run Delégua; download it |
| `@designliquido/delegua-node` | 1.25.0 (pinned in `package.json` / `package-lock.json`) | the `delegua` command [4] |
| `@designliquido/visualg` | 0.9.20 (installed with it) | the VisuAlg dialect: "Dialeto de VisuAlg baseado em Delégua e TypeScript" [5] |

## Quick start
```sh
./install.sh   # check Node.js, then npm ci (asks first)
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | Checks `node` and `npm`; offers `brew install node` on macOS or prints the Linux/Windows instructions. Then runs `npm ci` (asks first) to install Delégua into `node_modules/`. | Delégua is an npm package. `npm ci` installs the exact versions in `package-lock.json` [6], so every student runs the same interpreter. |
| `run.sh` | Runs `node_modules/.bin/delegua --dialeto visualg ola-mundo.alg`. `--verify` does the same. | `--dialeto` ("dialect") picks the language; the default is Delégua's own (`delegua --ajuda`). |

`npm run start` runs the same command (the `start` script in
`package.json`).

## Folder structure
```text
portugol/
├── README.md          this file
├── install.sh         checks Node.js, installs Delégua (npm ci)
├── run.sh             runs delegua --dialeto visualg ola-mundo.alg
├── package.json       declares the Delégua dependency
├── package-lock.json  exact versions of every package
└── ola-mundo.alg      the algorithm (teaching comments)
```
- `.alg` is VisuAlg's file extension; Delégua's translator option names it
  `alg-para-delegua` ("alg to Delégua") (`delegua --ajuda`).
- `node_modules/` is created by `install.sh` and ignored by git.

## Step-by-step walkthrough
Open [`ola-mundo.alg`](ola-mundo.alg) next to this list.

1. **`algoritmo "OlaMundo"`** must be the first line: it names the
   algorithm. Delégua rejects even a comment before it (tested with
   1.25.0: "Esperada expressão 'algoritmo' para inicializar programa").
2. **Comments** start with `//`. VisuAlg "não distingue maiúsculas e
   minúsculas no reconhecimento de palavras-chave e nomes de variáveis"
   ("does not distinguish upper and lower case in keywords and variable
   names") [7].
3. **`var`** opens the section where variables are declared with their
   types, before the commands, as in Pascal. This program has none.
4. **`inicio`** ("start") marks where the commands begin, like Pascal's
   `begin`.
5. **`escreval("Hello, World!")`** writes the text and then a line break:
   "Idem ao anterior [escreva], com a única diferença que pula uma linha em
   seguida. É equivalente ao writeln do Pascal" ("Same as escreva, except
   that it then moves to a new line. It is equivalent to Pascal's
   writeln") [7].
6. **`fimalgoritmo`** ends the program, like Pascal's `end.`

The Pascal comparisons are deliberate: the VisuAlg language is close to
Pascal (see the [Pascal CLI](../../pascal/cli/)), with Portuguese keywords.

## Why this toolchain
- **Why the VisuAlg dialect.** The two best-documented Portugol tools are
  VisuAlg and Portugol Studio. VisuAlg 3.0 has 2,976,812 SourceForge
  downloads [2]; Portugol Studio has 959,624 GitHub release downloads
  (both read 2026-11-02) [8].
- **Why not the VisuAlg program itself.** VisuAlg 3.0 is a Windows
  program (version 3.0.7.0, 2019-03-21); its page says it runs on Linux
  only through Wine [9]. It is a graphical user interface (GUI) editor, so `run.sh` cannot run
  it.
- **Why not Portugol Studio.** Its last release is 2.7.5, from 2020-11-27
  [8], and it is a GUI editor too. Delégua also has a Portugol Studio
  dialect, but in a test with 1.25.0 it printed `\n` literally instead of
  a line break, so the program's output was not exact.
- **Why Delégua.** It runs the VisuAlg dialect from a terminal on any OS
  with Node.js, is MIT licensed [3], and is maintained (1.25.0 was
  published to npm in 2026, per the npm registry) [4].
- **npm warnings.** On npm 12, `npm ci` warns that two optional packages
  (`canvas`, `koffi`) "had install scripts blocked". Delégua's command
  line does not need them for this program; the warning can be ignored.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-02) | Node.js 26.8.2 from Homebrew. |
| macOS Apple Silicon | ⚠️ not verified | Same commands; `brew install node`. |
| Linux | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` does not install Node.js: if `node` or `npm` is missing it prints the nodejs.org steps [10] and stops. It runs `npm ci` to install Delégua when it is missing. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` does not install Node.js: if `node` or `npm` is missing it prints `winget install --id OpenJS.NodeJS.LTS -e` and stops. It runs `npm ci` to install Delégua when it is missing. The original VisuAlg 3.0 editor [9] is an alternative. WSL (Windows Subsystem for Linux) not verified; it behaves like Linux. |

## Expected output
```text
$ ./run.sh

==> Run ola-mundo.alg with the Delégua interpreter (VisuAlg dialect)
    WHY: Delégua reads the pseudocode and executes it, line by line.
Hello, World!
```

## Sources
1. Barbosa, Couto, and Terra. "PortuCol: uma pseudo linguagem inspirada em C ANSI para o Ensino de Lógica de Programação e Algoritmos" (PortuCol: a pseudo-language inspired by ANSI C for teaching programming logic and algorithms). WEI 2016. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/9678/9579> (accessed 2026-11-02)
2. VisuAlg 3.0 download statistics. SourceForge. <https://sourceforge.net/projects/visualg30/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (accessed 2026-11-02)
3. Delégua. Design Líquido, GitHub. <https://github.com/DesignLiquido/delegua> (accessed 2026-11-02)
4. @designliquido/delegua-node. npm registry. <https://registry.npmjs.org/@designliquido/delegua-node> (accessed 2026-11-02)
5. @designliquido/visualg. npm registry. <https://registry.npmjs.org/@designliquido/visualg> (accessed 2026-11-02)
6. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-11-02)
7. VisuAlg language reference (copy of the VisuAlg help hosted by a lecturer at the "Escola de Engenharia de Lorena", University of São Paulo). <https://sistemas.eel.usp.br/docentes/arquivos/5840003/241/VisuAlg.pdf> (accessed 2026-11-02)
8. Portugol Studio releases. UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio/releases> (accessed 2026-11-02)
9. VisuAlg 3.0. SourceForge. <https://sourceforge.net/projects/visualg30/> (accessed 2026-11-02)
10. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-11-02)
