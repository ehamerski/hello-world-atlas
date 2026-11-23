---
source: languages/pascal/cli/README.md
source_sha: 2120d13885bd406304fa47681eac4609f79f7a92
---
# Pascal · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Pascal](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. Consiste em um único arquivo, [`hello.pas`](hello.pas), escrito em
**Pascal Padrão ISO 7185**, a forma padronizada da linguagem que Niklaus
Wirth definiu em 1970 [1], e compilado pelo **Free Pascal** (FPC), "a mature,
versatile, open source Pascal compiler" [2] (tradução livre: "um compilador
Pascal maduro, versátil e de código aberto").

Como o [C cli](../../c/cli/), o programa é compilado antecipadamente em um
executável nativo, `bin/hello-cli`. O script `build.sh` chama o compilador
com uma opção que seleciona um dialeto (`-Miso` aqui, `-std=c89` em C).
Compare com a [versão desktop](../desktop/), que usa o Object Pascal, o
dialeto estendido do Lazarus e do Delphi.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Free Pascal (`fpc`) | 3.2.2, versão oficial para macOS, descompactada em `~/.local/fpc-3.2.2` pelo `install.sh` | compila e vincula `hello.pas` |
| Linkeditor da Apple | Command Line Tools (Apple clang 21.0.0) | o FPC chama o linkeditor do sistema no macOS |

O Free Pascal 3.2.2 é a versão estável mais recente; a versão 3.2.4 existe
apenas como release candidate [2][3].

**Por que não usar `brew install fpc` no macOS?** A fórmula `fpc` do
Homebrew tem pacotes prontos (bottles) apenas para Apple Silicon e Linux
[4]; assim, em Macs com Intel, o Homebrew compila o FPC a partir do
código-fonte. Na máquina de desenvolvimento, essa compilação falhou
(2026-11-01): o montador (assembler) atual da Apple rejeita código que o FPC 3.2.2
gera para uma de suas próprias unidades de biblioteca:
```text
rtl-objpas/units/x86_64-darwin/rtti.s:12:1: error: non-private labels cannot
appear between .cfi_startproc / .cfi_endproc pairs
```
A versão oficial do FPC para macOS já vem compilada; por isso, não
apresenta esse problema. A equipe do Lazarus também observa que a sua
própria versão 4.8 "was built with FPC 3.2.2, and FPC 3.2.4RC1 for macOS"
[5] (tradução livre: "foi compilada com o FPC 3.2.2 e com o FPC 3.2.4RC1
para macOS"). Por isso, o `install.sh` baixa a versão oficial
(`fpc-3.2.2.intelarm64-macosx.dmg`, um único arquivo para Intel e Apple
Silicon) [6], verifica a sua soma de verificação SHA-256 e descompacta, em
`~/.local/fpc-3.2.2`, os arquivos que o seu instalador copiaria para
`/usr/local`. Não é necessário `sudo`; basta excluir essa pasta para
desinstalar. Na máquina de desenvolvimento, isso levou cerca de 40 segundos
com o arquivo já baixado (2026-11-01).

## Início rápido
```sh
./install.sh   # check / install Free Pascal (asks before installing)
./build.sh     # compile hello.pas as ISO 7185 Pascal into bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `fpc-env.sh` | Carregado (sourced) por `install.sh` e `build.sh`: define `FPC_VERSION`, `FPC_DMG_SHA256`, `FPC_DIR` (padrão `~/.local/fpc-3.2.2`) e coloca `$FPC_DIR/bin` no início do `PATH` se o FPC estiver instalado ali. | Um único lugar para a versão, a soma de verificação e a pasta. |
| `install.sh` | Executa `fpc -iV`. Se `fpc` estiver ausente: no macOS, instala a versão oficial conforme descrito acima (usa apenas `curl`, `shasum`, `hdiutil` e `pkgutil`, que acompanham o macOS); no Debian/Ubuntu, oferece `sudo apt-get install -y fpc`; no Windows, mostra onde obter o instalador. Tudo é executado somente se a resposta for `y`. | O Pascal é compilado; assim, um compilador Pascal é a única ferramenta necessária. |
| `build.sh` | Executa `fpc -Miso -FEbin -FUbin -ohello-cli hello.pas` e imprime esse comando (`set -x`). `FPC=/path/to/fpc ./build.sh` seleciona outro compilador. | Transforma o código-fonte em código de máquina. As opções são explicadas a seguir. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O executável é código de máquina; assim, o sistema operacional o executa diretamente. |

**As opções, uma a uma** (descrições de `fpc -h`, a ajuda do próprio
compilador [7]):
- `-Miso`: "ISO 7185 mode" (tradução livre: "modo ISO 7185"). O Guia do
  Usuário acrescenta: "In this mode, the compiler complies with the
  requirements of level 0 of ISO/IEC 7185" [8] (tradução livre: "Neste modo,
  o compilador cumpre os requisitos do nível 0 da ISO/IEC 7185"). Sem `-M`,
  o FPC usa o seu próprio dialeto: `-Mfpc` "Free Pascal dialect (default)"
  [7] (tradução livre: "dialeto Free Pascal (padrão)").
- `-FEbin`: "Set exe/unit output path to bin" [7] (tradução livre: "Define o
  caminho de saída de executáveis e unidades como bin"); assim, o executável
  vai para `bin/`.
- `-FUbin`: "Set unit output path to bin" [7] (tradução livre: "Define o
  caminho de saída de unidades como bin"): o arquivo objeto `hello.o` também
  vai para `bin/`, e a pasta do código-fonte permanece limpa.
- `-ohello-cli`: "Change the name of the executable produced" [7] (tradução
  livre: "Altera o nome do executável produzido"); sem ela, o arquivo se
  chamaria `hello`, com o nome do arquivo de código-fonte.
- O FPC compila **e vincula** em uma única chamada. Ele mostra avisos por
  padrão: o seu arquivo de configuração `fpc.cfg` contém `-viwn` ("Display
  Info, Warnings and Notes", em tradução livre: "Exibir informações, avisos
  e notas").

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── fpc-env.sh    Free Pascal version, checksum and folder (sourced)
├── install.sh    checks / installs Free Pascal
├── build.sh      compiles hello.pas as ISO 7185 Pascal
├── run.sh        runs bin/hello-cli
├── hello.pas     the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    ├── hello-cli
    └── hello.o
```
- Um programa Pascal de um único arquivo dispensa arquivo de projeto:
  `fpc hello.pas` basta. Projetos maiores em Free Pascal costumam ser
  projetos Lazarus (arquivo `.lpi`, ver [../desktop](../desktop/)) ou usar o
  `fpmake` do FPC.
- `bin/` e as unidades compiladas (`*.ppu`) são ignorados pelo `.gitignore`
  da raiz.

## Passo a passo
Abra [`hello.pas`](hello.pas) ao lado desta lista.

1. Os **comentários** são escritos como `{ ... }` ou `(* ... *)`. O Guia de
   Referência do FPC chama `(* *)` de "an older form of comment notation"
   (tradução livre: "uma forma mais antiga de notação de comentário") e `{ }`
   de "the standard notation" (tradução livre: "a notação padrão"). A forma
   `//`, encontrada em muito código Pascal, "was introduced by Borland in
   the Delphi Pascal compiler" [9] (tradução livre: "foi introduzida pela
   Borland no compilador Delphi Pascal"); portanto, não é Pascal Padrão.
2. **`program hello(output);`** é o cabeçalho do programa. No Pascal Padrão,
   ele lista os arquivos que o programa usa; `output` é o terminal. Os
   dialetos próprios do Free Pascal não precisam dele: "The program header
   is not required. If present, it will be used by the compiler to name the
   program" [9] (tradução livre: "O cabeçalho do programa não é obrigatório.
   Se presente, será usado pelo compilador para dar nome ao programa").
3. **`begin ... end.`** é o corpo do programa, o seu ponto de entrada. Não há
   função `main` como em C, Java ou Go. Observe o ponto final depois do
   último `end`.
4. **`writeln('Hello, World!')`** escreve o texto e uma quebra de linha na
   saída padrão. A documentação do FPC diz: "If the parameter F is omitted,
   standard output is assumed" [10] (tradução livre: "Se o parâmetro F for
   omitido, presume-se a saída padrão"). As strings usam aspas simples.
5. **Sem ponto e vírgula depois de `writeln(...)`.** No Pascal, o ponto e
   vírgula *separa* instruções; não as encerra como em C. Com uma única
   instrução, não há nada a separar. **Experimente:** acrescente um `;`
   depois do `)` e execute `./build.sh`: o programa ainda compila (o Pascal
   admite uma *instrução vazia* antes de `end`). Agora remova o `;` e as
   aspas finais da string e execute `./build.sh` novamente: o FPC para com
   `hello.pas(33,11) Fatal: String exceeds line`. Depois, desfaça as
   alterações.
6. **Maiúsculas e minúsculas não importam.** `WriteLn`, `WRITELN` e
   `writeln` são a mesma palavra, como em Fortran e COBOL, e ao contrário de
   C ou Java.
7. **O que o executável precisa.** `otool -L bin/hello-cli` lista apenas
   `/usr/lib/libSystem.B.dylib`, a biblioteca do sistema macOS: o Free Pascal
   copia a sua própria biblioteca de runtime para dentro do executável.
   Compare com o [Fortran cli](../../fortran/cli/), que carrega a
   `libgfortran` em tempo de execução.

## Por que esta toolchain
- **Contexto da época.** O primeiro compilador de Pascal executava em
  computadores CDC 6000 [1]. Em computadores pessoais, os compiladores
  Pascal mais conhecidos eram o Turbo Pascal da Borland (1983) e o seu
  sucessor, o Delphi (1995) [11][12]; ambos são produtos comerciais.
- **O Free Pascal é o compilador livre e mantido em todas as plataformas
  deste projeto.** O projeto Lazarus o descreve como "a GPL'ed compiler that
  runs on Linux, Windows, macOS, FreeBSD and others" [16] (tradução livre:
  "um compilador GPL que executa em Linux, Windows, macOS, FreeBSD e
  outros"). Ele oferece suporte a vários dialetos por meio de `-M`: ISO 7185,
  ISO 10206 Extended Pascal, Turbo Pascal, Delphi e o seu próprio [7][8].
  Assim, um único compilador consegue compilar tanto o programa ao estilo da
  década de 1970 deste diretório quanto o Object Pascal de
  [../desktop](../desktop/).
- **Modo ISO de propósito.** Ele mostra a linguagem como padronizada, sem as
  extensões do Turbo Pascal e do Delphi que a versão desktop usa.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | FPC 3.2.2, versão oficial, em `~/.local/fpc-3.2.2` (a compilação a partir do código-fonte pelo Homebrew falha; ver Pré-requisitos). A vinculação imprime dois avisos inofensivos do linkeditor mais novo da Apple: `-macosx_version_min has been renamed to -macos_version_min` e `ld: warning: -multiply_defined is obsolete`. |
| macOS Apple Silicon | ⚠️ não verificado | O mesmo caminho do `install.sh`: o arquivo da versão cobre Intel e Apple Silicon [6]. `brew install fpc` também tem um bottle ali [4]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `fpc` com o apt quando ele não existe [13]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o Chocolatey e instala o Lazarus 4.0.0, que inclui o Free Pascal 3.2.2 [15], com `choco install lazarus --version=4.0.0` quando o `fpc` não existe. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
         Free Pascal's runtime library is inside the executable.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. Niklaus Wirth, *The Programming Language Pascal*, ETH Zürich, November 1970 (second edition July 1971). ETH Research Collection, DOI 10.3929/ethz-a-004150844. <https://www.research-collection.ethz.ch/server/api/core/bitstreams/8bd8f312-3c90-4bc5-9081-63943ff3902a/content> (acessado em 2026-11-01)
2. Free Pascal (home page: description, latest stable version 3.2.2). <https://www.freepascal.org/> (acessado em 2026-11-01)
3. FPC source repository tags (`release_3_2_2`, `release_3_2_4_rc2`). Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/source/-/tags> (acessado em 2026-11-01)
4. `fpc` formula (versions and bottles). Homebrew Formulae. <https://formulae.brew.sh/formula/fpc> (acessado em 2026-11-01)
5. Lazarus home page (news: "Lazarus Bugfix Release 4.8 - June 11, 2026"). Lazarus. <https://www.lazarus-ide.org/> (acessado em 2026-11-01)
6. Free Pascal 3.2.2 for macOS (release files and checksums). SourceForge. <https://sourceforge.net/projects/freepascal/files/Mac%20OS%20X/3.2.2/> (acessado em 2026-11-01)
7. `fpc -h`, the command-line help of Free Pascal 3.2.2 (run on the dev machine, 2026-11-01).
8. Free Pascal User's Guide, compiler modes (`-M`) section, LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/user.tex> (acessado em 2026-11-01)
9. Free Pascal Reference Guide, sections "Comments" and "Programs", LaTeX source. Free Pascal, GitLab. <https://gitlab.com/freepascal.org/fpc/documentation/-/blob/main/tex/ref.tex> (acessado em 2026-11-01)
10. WriteLn. Free Pascal Run-Time Library reference. <https://www.freepascal.org/docs-html/rtl/system/writeln.html> (acessado em 2026-11-01)
11. Turbo Pascal turns 40. Embarcadero blog. <https://blogs.embarcadero.com/turbo-pascal-turns-40/> (acessado em 2026-11-01)
12. The long and winding road to today's Delphi: happy 29th birthday. Embarcadero blog. <https://blogs.embarcadero.com/the-long-and-winding-road-to-todays-delphi-happy-29th-birthday/> (acessado em 2026-11-01)
13. `fpc` in Debian stable (3.2.2+dfsg-46). Debian archive (`madison`). <https://api.ftp-master.debian.org/madison?package=fpc&s=stable> (acessado em 2026-11-01)
14. Free Pascal 3.2.2 for Windows (release files). SourceForge. <https://sourceforge.net/projects/freepascal/files/Win32/3.2.2/> (acessado em 2026-11-01)
15. Lazarus downloads ("Lazarus 4.8 which is accompanied by FPC 3.2.2"). Lazarus. <https://www.lazarus-ide.org/index.php?page=downloads> (acessado em 2026-11-01)
16. About Lazarus. Lazarus. <https://www.lazarus-ide.org/index.php?page=about> (acessado em 2026-11-01)
