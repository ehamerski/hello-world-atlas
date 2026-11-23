---
source: languages/basic/cli/README.md
source_sha: 985891317008815dd00f70e2396cc1f3191d1d3f
---
# BASIC · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [BASIC](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.bas`](hello.bas), escrito em BASIC
**QBasic / QuickBASIC 4.5**, o dialeto dos BASIC do MS-DOS da Microsoft, e
compilado com o **QB64 Phoenix Edition** (QB64-PE) 4.7.0, "a modern extended
BASIC+OpenGL language that retains QB4.5/QBasic compatibility and compiles
native binaries for Windows (7 and up), Linux and macOS (Catalina and up)"
[1] (tradução livre: "uma linguagem BASIC+OpenGL moderna e estendida, que
mantém a compatibilidade com o QB4.5/QBasic e compila binários nativos para
Windows (7 e posteriores), Linux e macOS (Catalina e posteriores)").

O programa inteiro tem duas instruções, `PRINT` e `SYSTEM`, mais uma
instrução para o compilador. Compare-o com o [C](../../c/cli/hello.c) ou o
[COBOL](../../cobol/cli/hello.cob): o BASIC não tem cabeçalho de programa,
nem `main`, nem blocos, nem declarações. Essa simplicidade era o objetivo:
a linguagem foi criada em Dartmouth para que estudantes aprendessem a
programar rapidamente (consulte o
[README da linguagem](../README.md#history)).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| QB64-PE (`qb64pe`) | 4.7.0-GLFW, compilado pelo `install.sh` em `~/.local/qb64pe-4.7.0` | traduz BASIC para C++ e conduz a compilação |
| Um compilador C++ (`clang++`) e o `make` | Apple clang 21.0.0 (Command Line Tools) | compilam o próprio QB64-PE e, depois, o C++ que ele gera |
| `curl`, `tar`, `shasum` | acompanham o macOS | baixam e verificam a versão do QB64-PE |

## Início rápido
```sh
./install.sh   # check / build QB64-PE 4.7.0 (asks first; about 1 minute)
./build.sh     # qb64pe -x: BASIC -> C++ -> bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Procura o `qb64pe` (em `~/.local/qb64pe-4.7.0` ou no PATH). Se ele estiver ausente no macOS, oferece baixar o `qb64pe_osx-4.7.0-GLFW.tar.gz` da versão publicada no GitHub do QB64-PE, verificar seu SHA-256, descompactá-lo e executar ali `make OS=osx BUILD_QB64=y -j3`. No Linux e no Windows, imprime o download e as etapas. | O QB64-PE não está em nenhum gerenciador de pacotes; sua versão para macOS é compilada no próprio Mac [1]. Sem `sudo`. |
| `qb64pe-env.sh` | Carregado (`source`) pelo `install.sh` e pelo `build.sh`: define a versão, o checksum e a pasta de instalação e escolhe o comando `qb64pe`. | Mantém a versão em um único lugar. |
| `build.sh` | Executa `qb64pe -x -q -w hello.bas -o bin/hello-cli` e o imprime (`set -x`). | Transforma o código-fonte em código de máquina. As opções são explicadas abaixo. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente. |

**As opções, uma a uma** (de `man ./qb64pe.1`, na pasta do QB64-PE):
- `-x`: "Compile instead of edit and output the result to the console"
  (tradução livre: "Compila em vez de editar e envia o resultado ao
  console"). Sem `-x` nem `-c`, o `qb64pe` abre seu editor (IDE).
- `-q`: "Quiet mode (suppresses most output other than warnings and errors)"
  (tradução livre: "Modo silencioso (suprime a maior parte da saída, exceto
  avisos e erros)").
- `-w`: "Show warnings when compiling" (tradução livre: "Exibe avisos durante
  a compilação").
- `-o bin/hello-cli`: "Write output executable to <output file>"
  (tradução livre: "Grava o executável de saída em <arquivo de saída>"). O
  QB64-PE também grava `bin/hello-cli_start.command`, um inicializador em que
  é possível dar um clique duplo no Finder; este projeto não o usa.

**Por que o `install.sh` chama o `make` em vez do `setup_osx.command`:** o
README do QB64-PE diz "Run `./setup_osx.command` to compile QB64-PE for your
OS version" [1] (tradução livre: "Execute `./setup_osx.command` para
compilar o QB64-PE para a sua versão do sistema operacional"). Esse script
executa `make OS=osx clean` e `make OS=osx BUILD_QB64=y -j3` e, em seguida,
abre o editor e espera uma tecla. O `install.sh` executa o mesmo comando de
compilação sem as partes interativas, de modo que também funciona sem
supervisão (`TF_ASSUME_YES=1`).

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / builds QB64-PE
├── qb64pe-env.sh    QB64-PE version, checksum and install folder
├── build.sh         compiles hello.bas
├── run.sh           runs bin/hello-cli
├── hello.bas        the program
└── bin/             created by build.sh; not committed (see ../../../.gitignore)
    ├── hello-cli
    └── hello-cli_start.command
```
- O BASIC não tem estrutura de projeto nem arquivo de compilação. Um
  programa QBasic é um único arquivo `.bas`.
- `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação nunca
  recebe commit.

## Passo a passo
Abra [`hello.bas`](hello.bas) ao lado desta lista.

1. **Os comentários** começam com um apóstrofo `'` ou com a palavra-chave
   `REM`.
2. **`$CONSOLE:ONLY`** é um *metacomando* do QB64, uma instrução para o
   compilador. Um programa QB64 normalmente abre sua própria janela
   gráfica, assim como um programa QBasic preenchia a tela do MS-DOS. "The
   :ONLY option bypasses the graphical program window, allowing the program
   to run in a text-only console window" [2] (tradução livre: "A opção :ONLY
   dispensa a janela gráfica do programa, permitindo que ele execute em uma
   janela de console somente de texto"); o `PRINT` passa então a escrever no
   terminal. O wiki do QB64 acrescenta: "QB64 Metacommands are not commented
   out with ' or REM, unlike QuickBASIC metacommands" [2] (tradução livre:
   "Os metacomandos do QB64 não são comentados com ' nem com REM, ao
   contrário dos metacomandos do QuickBASIC"). Esta linha é a única parte
   do arquivo que o QBasic não entenderia.
3. **`PRINT "Hello, World!"`.** "The PRINT statement prints numeric or
   string expressions to the program screen" [3] (tradução livre: "A
   instrução PRINT imprime expressões numéricas ou de string na tela do
   programa"), seguidas de uma quebra de linha, a menos que a linha termine
   com `;` ou `,`. Não há `main`: o programa executa da primeira à última
   instrução.
4. **`SYSTEM`** "immediately closes a program and returns control to the
   operating system" [4] (tradução livre: "encerra imediatamente um programa
   e devolve o controle ao sistema operacional"). Sem ele, ou com `END`, o
   QB64 faz uma pausa com a mensagem "Press any key to continue" [5]. Na
   máquina de desenvolvimento, em modo console, a mensagem foi `Press enter
   to continue` e o programa aguardou uma entrada.
5. **O BASIC vira C++.** O QB64-PE grava o C++ traduzido em sua própria
   pasta, `~/.local/qb64pe-4.7.0/internal/temp/`, como arquivos `.txt` que o
   `main.txt` inclui, e o compila com o `clang++`. Depois de uma compilação,
   `grep -n Hello ~/.local/qb64pe-4.7.0/internal/temp/main0.txt` mostra a
   linha `PRINT` convertida em C++:
   `qbs_set(tqbs,qbs_new_txt_len("Hello, World!",13));`.
   O `otool -L bin/hello-cli` mostra que até este programa de console liga
   os frameworks gráficos do macOS (Cocoa, OpenGL): a biblioteca de runtime
   do QB64-PE sempre inclui seu código de janela.
6. **Experimente:** apague a linha `SYSTEM` e execute `./build.sh` e
   `./run.sh`: o programa passa a esperar a tecla Enter. Em seguida, apague
   também `$CONSOLE:ONLY` e compile novamente: o `./bin/hello-cli` abre uma
   janela do QB64 em vez de imprimir no terminal. Depois, restaure as duas
   linhas.

## Por que esta toolchain
- **Qual BASIC?** O BASIC tem muitos dialetos (consulte o
  [README da linguagem](../README.md)). Para uma linguagem antiga, este
  repositório usa a melhor opção da época ou seu sucessor mantido. O BASIC
  que a maioria dos usuários de PC conheceu na era do MS-DOS foi o da
  Microsoft: o QBasic acompanhava o MS-DOS 5.0 (artigo de suporte da própria
  Microsoft: "When EDIT.COM is executed in MS-DOS versions 5.0 and later, it
  invokes QBASIC.EXE with the /EDITOR switch" [6] (tradução livre: "Quando o
  EDIT.COM é executado nas versões 5.0 e posteriores do MS-DOS, ele chama o
  QBASIC.EXE com a opção /EDITOR")). O próprio QBasic é um programa MS-DOS,
  que o macOS e o Linux não executam nativamente.
- **O QB64 Phoenix Edition** mantém esse dialeto vivo: ele "retains
  QB4.5/QBasic compatibility" (tradução livre: "mantém a compatibilidade com
  o QB4.5/QBasic") e gera programas nativos para Windows, Linux e macOS [1].
  É mantido: a versão 4.7.0 foi lançada em 2026-09-26 [7]. Instala-se
  nativamente no macOS, de modo que não é necessário o Docker.
- **Por que não o FreeBASIC**, o outro candidato? O FreeBASIC "is a
  free/open source (GPL), BASIC compiler for Microsoft Windows, DOS and
  Linux" [8] (tradução livre: "é um compilador BASIC livre e de código
  aberto (GPL) para Microsoft Windows, DOS e Linux"); o macOS não consta de
  sua lista, de modo que, na máquina de desenvolvimento deste projeto, ele só
  executaria dentro de um contêiner Docker com Linux. Ele também oferece
  suporte a código QuickBASIC, por meio de seu dialeto `-lang qb` [9]. Sua
  versão mais recente, 1.10.1, é de 2023-12-25 [10]. O QB64-PE foi escolhido
  porque executa nativamente em todas as plataformas de destino e tem
  lançamento mais recente.
- **Por que não o Visual Basic?** O Visual Basic .NET é o BASIC com mais
  usuários hoje (consulte o
  [README da linguagem](../README.md#market-usage-today)), mas é uma
  linguagem .NET orientada a objetos, mais próxima do C#, que este projeto
  já cobre em [csharp/](../../csharp/). A Microsoft também escreveu em
  2020: "Going forward, we do not plan to evolve Visual Basic as a
  language" [11] (tradução livre: "Daqui em diante, não planejamos evoluir
  o Visual Basic como linguagem"). O BASIC clássico, linha a linha, mostra
  o paradigma imperativo com mais clareza.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | QB64-PE 4.7.0 compilado pelo `install.sh` com o Apple clang 21 (57 s). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmo pacote para macOS e mesmo script; o pacote é compilado localmente, de modo que tem como alvo a CPU do próprio Mac. |
| Linux | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `build-essential x11-utils mesa-common-dev libglu1-mesa-dev libasound2-dev libpng-dev libcurl4-openssl-dev libx11-dev libxcursor-dev libxrandr-dev libxinerama-dev libxi-dev` com o apt, baixa `qb64pe_lnx-x64-4.7.0-GLFW.tar.gz` [7], confere o SHA-256 e o compila com `make OS=lnx BUILD_QB64=y` em `~/.local/qb64pe-4.7.0`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` baixa `qb64pe_win-x64-4.7.0-GLFW.7z` [7], confere o SHA-256 e o extrai com o 7-Zip (`7z` no PATH ou em `C:\Program Files\7-Zip`) em `~/.local/qb64pe-4.7.0`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. QB64 Phoenix Edition README (description, installation, usage). QB64-PE project. <https://github.com/QB64-Phoenix-Edition/QB64pe> (acessado em 2026-11-01)
2. $CONSOLE. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/$CONSOLE> (acessado em 2026-11-01)
3. PRINT. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/PRINT> (acessado em 2026-11-01)
4. SYSTEM. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/SYSTEM> (acessado em 2026-11-01)
5. END. QB64 Phoenix Edition Wiki. <https://qb64phoenix.com/qb64wiki/index.php/END> (acessado em 2026-11-01)
6. `EDIT.COM` Cannot Find `QBASIC.EXE` (KB 63777). Microsoft Knowledge Base, archived copy. <https://ftp.zx.net.nz/pub/archive/ftp.microsoft.com/MISC/KB/en-us/63/777.HTM> (acessado em 2026-11-01)
7. Release v4.7.0-GLFW (2026-09-26; assets and SHA-256 digests). QB64-PE project, GitHub. <https://github.com/QB64-Phoenix-Edition/QB64pe/releases/tag/v4.7.0-GLFW> (acessado em 2026-11-01)
8. FreeBASIC home page. FreeBASIC project. <https://www.freebasic.net/> (acessado em 2026-11-01)
9. Compiler option -lang. FreeBASIC Wiki. <https://www.freebasic.net/wiki/CompilerOptlang> (acessado em 2026-11-01)
10. Release 1.10.1 (2023-12-25). FreeBASIC project, GitHub. <https://github.com/freebasic/fbc/releases/tag/1.10.1> (acessado em 2026-11-01)
11. Visual Basic support planned for .NET 5.0 (2020-03-11). Microsoft .NET Blog. <https://devblogs.microsoft.com/vbteam/visual-basic-support-planned-for-net-5-0/> (acessado em 2026-11-01)
