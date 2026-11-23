---
source: languages/cobol/cli/README.md
source_sha: 7cfce361a8a1d8403c8f7f6eab9f5cd6deebc87a
---
# COBOL · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [COBOL](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.cob`](hello.cob), escrito em
**COBOL-85** (ANSI X3.23-1985, adotado pela ISO como ISO 1989:1985 [1]) no
tradicional **formato fixo**, o layout em colunas dos cartões perfurados. É
compilado com o **GnuCOBOL** 3.2, um compilador COBOL livre que "translates
COBOL into C and internally compiles the translated code using a native C
compiler" [2] (tradução livre: "traduz COBOL para C e compila internamente o
código traduzido usando um compilador C nativo").

Como no [cli de C](../../c/cli/), o resultado é um executável nativo,
`bin/hello-cli`. Ao contrário do C, o programa não tem função `main` nem
`#include`: ele é organizado em **divisões** (*divisions*), e `DISPLAY` faz
parte da própria linguagem, não de uma biblioteca incluída.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| GnuCOBOL (`cobc`) | 3.2.0 (`gnucobol` 3.2 do Homebrew) | traduz COBOL para C e gera o executável |
| Um compilador C (`cc`) | Apple clang 21.0.0 (Command Line Tools) | o `cobc` o chama para compilar o C gerado |
| `libcob` | acompanha o GnuCOBOL | biblioteca de runtime do GnuCOBOL: `DISPLAY`, `STOP RUN`, ... |

## Início rápido
```sh
./install.sh   # check / install GnuCOBOL (asks before installing)
./build.sh     # cobc -x: COBOL -> C -> bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `cobc --version`. Se ele não existir, oferece `brew install gnucobol` (macOS), `sudo apt-get install -y gnucobol` (Debian/Ubuntu) ou imprime os comandos do MSYS2 (Windows), e só os executa se a resposta for `y`. | O COBOL é compilado; o GnuCOBOL é o compilador e também precisa de um compilador C. |
| `build.sh` | Executa `cobc -x -std=cobol85 -Wall -o bin/hello-cli hello.cob` e imprime esse comando (`set -x`). Opções extras são repassadas ao `cobc`, por exemplo `./build.sh -save-temps`. | Transforma o código-fonte em código de máquina. As opções são explicadas a seguir. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina sozinho). | O executável é código de máquina; portanto, o sistema operacional o executa diretamente. |

**As opções, uma a uma** (a partir de `cobc --help`, GnuCOBOL 3.2):
- `-x`: "build an executable program" (tradução livre: "gera um programa executável"). O manual do GnuCOBOL: "Include the
  main function in the output, creating an executable image" [3] (tradução livre: "Inclui a função principal na saída, criando uma imagem executável"). Sem
  `-x`, o `cobc` gera um módulo que outros programas COBOL chamam com `CALL`.
- `-std=cobol85`: "warnings/features for a specific dialect" (tradução livre: "avisos e recursos de um dialeto específico"). O GnuCOBOL
  conhece muitos dialetos (`cobol85`, `cobol2002`, `cobol2014`, `ibm`, `mf`,
  ...); este verifica o programa em relação ao padrão de 1985.
- `-Wall`: "enable most warnings" (tradução livre: "ativa a maioria dos avisos").
- `-o bin/hello-cli`: "place the output into <file>" (tradução livre: "coloca a saída em <arquivo>").
- O formato fixo é o padrão: `--fixed` é descrito como "use fixed source
  format (default)" (tradução livre: "usa o formato fixo de código-fonte (padrão)"). `-free` passa para o formato livre [3].

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs GnuCOBOL
├── build.sh      compiles hello.cob
├── run.sh        runs bin/hello-cli
├── hello.cob     the program
├── .gitignore    ignores the C files made by ./build.sh -save-temps
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- O COBOL não tem layout de projeto nem arquivo de build padrão. Um projeto
  de um só programa é o arquivo de código-fonte; `.cob` (também `.cbl`) é a
  extensão usual.
- `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação nunca é
  versionada.

## Passo a passo
Abra [`hello.cob`](hello.cob) ao lado desta lista.

1. **As colunas importam (formato fixo).** O manual do GnuCOBOL o descreve:
   "columns 1-6, the sequence number area; column 7, the indicator area;
   columns 8-72, the program-text area" [3] (tradução livre: "colunas 1 a 6,
   a área do número de sequência; coluna 7, a área do indicador; colunas 8 a
   72, a área do texto do programa"). Os cabeçalhos de divisão, de seção e
   de parágrafo "must begin in Area A" (tradução livre: "devem começar na
   Área A") (colunas 8-11), e todo o resto vai na Área B (colunas 12-72) [4].
   Assim, toda linha de código começa com 7 espaços, e as instruções, com 11.
2. **Os comentários** são linhas com `*` na coluna 7, a área do indicador
   [4]: a linha inteira é um comentário.
3. **`IDENTIFICATION DIVISION.` / `PROGRAM-ID. HELLO.`** dão nome ao
   programa. Todo cabeçalho e toda sentença terminam com um ponto.
4. **Sem ENVIRONMENT nem DATA DIVISION.** Elas descrevem o computador, os
   arquivos e as variáveis. Este programa não tem nenhum desses itens; por
   isso, elas são omitidas.
5. **`PROCEDURE DIVISION.`** contém o código. A execução começa na primeira
   instrução dela; não há função `main` a declarar.
6. **`DISPLAY "Hello, World!".`** escreve o texto e uma quebra de linha na
   saída padrão, como o `print` do Python (o `printf` do C precisa de `\n`).
7. **`STOP RUN.`** encerra o programa e devolve o controle ao sistema
   operacional.
8. **O COBOL vira C.** Execute `./build.sh -save-temps` e abra o `hello.c`
   gerado: a linha `DISPLAY` vira a chamada `cob_display (0, 1, 1, &c_1);`
   e `STOP RUN` vira `cob_stop_run (0);`, funções da `libcob`.
   `otool -L bin/hello-cli` mostra que o programa carrega
   `libcob.4.dylib` em tempo de execução. Apague os arquivos gerados depois
   (`rm hello.c hello.c.h hello.c.l.h hello.i`; o Git os ignora de qualquer
   forma).
9. **Experimente:** mova `PROCEDURE DIVISION.` para a coluna 1 e execute
   `./build.sh`. O GnuCOBOL para com `invalid indicator 'U' at column 7`: ele
   leu o `U` de `PROCEDURE` como o indicador. Recoloque os 7 espaços.

## Por que esta toolchain
- **Contexto da época.** O COBOL foi criado para os computadores comerciais
  de 1959-1960 (ver o [README da linguagem](../README.md#history)). Os
  compiladores comerciais de mainframe atuais, como o IBM Enterprise COBOL
  for z/OS [5], executam no sistema operacional de mainframe z/OS da IBM, e
  não nos computadores macOS, Linux e Windows aos quais este projeto se
  destina.
- **O GnuCOBOL é o sucessor livre e mantido para essas plataformas.**
  "GnuCOBOL (formerly OpenCOBOL) is a free, modern COBOL compiler" [2]
  (tradução livre: "O GnuCOBOL (antes OpenCOBOL) é um compilador COBOL livre
  e moderno"); o Homebrew o descreve como um "COBOL85-202x compiler
  supporting lots of dialect specific extensions" [6] (tradução livre:
  "compilador COBOL85-202x com suporte a muitas extensões específicas de
  dialeto"). A versão 3.2 foi lançada em 2023-07-28 [7]. Ele é empacotado
  pelo Homebrew [6], pelo Debian [8] e pelo MSYS2 [9]; assim, todas as
  plataformas deste projeto podem instalá-lo.
- **COBOL-85 e formato fixo, de propósito.** Para uma linguagem antiga, este
  repositório usa a melhor opção daquele período que ainda está em uso e
  com suporte. O COBOL-85 (ANSI X3.23-1985 / ISO 1989:1985 [1]) é o padrão
  anterior ao ISO/IEC 1989:2002, que acrescentou objetos (ver os
  [marcos](../README.md#milestones)), e o formato fixo é o seu layout de
  código-fonte [4]. `-std=cobol85` faz o GnuCOBOL verificar o programa em
  relação a esse padrão, como `-std=c89` faz para o [ANSI C](../../c/cli/).

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | GnuCOBOL 3.2.0 (Homebrew), Apple clang das Command Line Tools. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos: `brew install gnucobol` [6]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `gnucobol` com o apt quando o `cobc` não existe [8]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `gnucobol` e `gcc` com o `pacman` quando o `cobc` não existe [9]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly
         and loads libcob, the GnuCOBOL runtime library.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm de
`run.sh`.

## Fontes
1. FIPS PUB 21-2, COBOL (adopts ANSI X3.23-1985). National Institute of Standards and Technology. <https://nvlpubs.nist.gov/nistpubs/Legacy/FIPS/fipspub21-2.pdf> (acessado em 2026-11-01)
2. GnuCOBOL (project page). SourceForge. <https://sourceforge.net/projects/gnucobol/> (acessado em 2026-11-01)
3. GnuCOBOL manual (`cobc` options, source format). Projeto GnuCOBOL. <https://gnucobol.sourceforge.io/doc/gnucobol.html> (acessado em 2026-11-01); textos das opções também de `cobc --help`, GnuCOBOL 3.2.0
4. GnuCOBOL Programmer's Guide (fixed format, Area A/B, indicator column). Gary L. Cutler. <https://gnucobol.sourceforge.io/HTML/gnucobpg.html> (acessado em 2026-11-01)
5. Enterprise COBOL for z/OS 6.4: Industry specifications. IBM. <https://www.ibm.com/docs/en/cobol-zos/6.4.0?topic=appendixes-industry-specifications> (acessado em 2026-11-01)
6. `gnucobol` formula. Homebrew. <https://formulae.brew.sh/formula/gnucobol> (acessado em 2026-11-01)
7. GnuCOBOL (home page, releases). Projeto GnuCOBOL. <https://gnucobol.sourceforge.io/> (acessado em 2026-11-01)
8. Package `gnucobol` (trixie). Debian. <https://packages.debian.org/stable/gnucobol> (acessado em 2026-11-01)
9. Base package mingw-w64-gnucobol. MSYS2. <https://packages.msys2.org/base/mingw-w64-gnucobol> (acessado em 2026-11-01)
