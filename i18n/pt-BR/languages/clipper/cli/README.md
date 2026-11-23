---
source: languages/clipper/cli/README.md
source_sha: 4df085cdce7814966f040f85222fa79e026262ec
---
# Clipper · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Clipper](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.prg`](hello.prg), escrito com a sintaxe
do **Clipper 5**. O CA-Clipper em si é um produto proprietário e
descontinuado do MS-DOS; por isso, o programa é compilado com o **Harbour
3.2.0**, "the free software implementation of a multi-platform,
multi-threading, object-oriented, scriptable programming language, backward
compatible with Clipper/xBase" [1] (tradução livre: "a implementação em
software livre de uma linguagem de programação multiplataforma,
multithread, orientada a objetos e com suporte a scripts, retrocompatível
com Clipper/xBase").

Como no [cli de COBOL](../../cobol/cli/), o compilador passa pelo C: o
Harbour converte `hello.prg` em C, e um compilador C gera o executável
nativo `bin/hello-cli`. Ao contrário de COBOL e C, o Clipper tem **tipagem
dinâmica**: não há declarações de tipo, e uma variável assume o tipo do
valor armazenado nela.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Harbour (`harbour`, `hbmk2`) | 3.2.0 (r2607071000), compilado pelo `install.sh` em `~/.local/harbour-3.2.0` | compila `.prg` para C e conduz a compilação |
| Um compilador C (`cc`) e `make` | Apple clang 21.0.0 (Command Line Tools) | compilam o próprio Harbour e, depois, o C que o Harbour gera |
| `curl`, `tar`, `shasum` | acompanham o macOS | baixam e verificam a versão em código-fonte do Harbour |

## Início rápido
```sh
./install.sh   # check / build Harbour 3.2.0 (asks first; about 3 minutes)
./build.sh     # hbmk2: Clipper -> C -> bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Procura `hbmk2` (no PATH ou em `~/.local/harbour-3.2.0/bin`). Se ele não existir no macOS ou no Linux, oferece baixar `harbour-3.2.0.src.tar.gz` da versão publicada no GitHub do Harbour, verificar seu SHA-256 e executar `make install HB_INSTALL_PREFIX=~/.local/harbour-3.2.0 HB_BUILD_CONTRIBS=no`. No Windows, imprime o endereço de download do pacote pré-compilado. | Nenhum gerenciador de pacotes tem um Harbour atual (ver [Por que esta toolchain](#por-que-esta-toolchain)); por isso, ele é compilado a partir da versão oficial em código-fonte. Sem `sudo`. |
| `harbour-env.sh` | Carregado (`source`) por `install.sh` e `build.sh`: define a versão, o checksum e a pasta de instalação e coloca o `bin/` dela no PATH. | Mantém a versão em um único lugar. |
| `build.sh` | Executa `hbmk2 -q0 -w3 -es2 -gtcgi hello.prg -obin/hello-cli` e imprime o comando (`set -x`). Opções extras são repassadas ao `hbmk2`, por exemplo `./build.sh -trace`. | Transforma o código-fonte em código de máquina. As opções são explicadas a seguir. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina sozinho). | O executável é código de máquina; portanto, o sistema operacional o executa diretamente. |

**As opções, uma a uma** (a partir de `hbmk2 -help` e de `harbour` sem argumentos, Harbour 3.2.0):
- `-q0`: "quiet and don't display program header" (tradução livre: "silencioso e sem exibir o cabeçalho do programa"), isto é, o banner do Harbour.
- `-w3`: "set warning level number (0..3, default 1)" (tradução livre: "define o número do nível de avisos (0..3, padrão 1)"); 3 é o mais rigoroso.
- `-es2`: "set exit severity" (tradução livre: "define a severidade de saída"); o nível 2 faz os avisos interromperem a compilação, como
  `-Werror` no gcc/clang.
- `-gtcgi`: "link with GT<name> GT driver" (tradução livre: "vincula com o driver GT GT<nome>"). Um **GT** ("general terminal", terminal geral)
  é o driver de tela do Harbour. Os programas em Clipper dominavam toda a
  tela do MS-DOS; por isso, o driver padrão do Harbour no macOS e no Linux,
  o GTTRM, também controla o terminal: na máquina de desenvolvimento, ele
  acrescentou códigos de escape em torno do texto, mesmo quando a saída ia
  para um pipe. O GTCGI escreve texto simples na saída padrão, que é o que
  um programa cli deve fazer.
- `-obin/hello-cli`: "output file name" (tradução livre: "nome do arquivo de saída"). Observe que não há espaço depois de
  `-o`.

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / builds Harbour
├── harbour-env.sh   Harbour version, checksum and install folder
├── build.sh         compiles hello.prg
├── run.sh           runs bin/hello-cli
├── hello.prg        the program
└── bin/             created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- O Clipper não tem um layout de projeto padrão. Um projeto de um só
  programa é um arquivo `.prg`; projetos maiores do Harbour acrescentam um
  arquivo de projeto `.hbp` para o `hbmk2` [1]. Um único arquivo não precisa
  de nenhum.
- `bin/` é ignorado pelo `.gitignore` da raiz: a saída da compilação nunca é
  versionada. O `hbmk2` apaga sozinho seus arquivos temporários de C e de
  objeto.

## Passo a passo
Abra [`hello.prg`](hello.prg) ao lado desta lista.

1. **Comentários.** `/* ... */` e `//` funcionam como em C. O Clipper também
   aceita o `*` do dBASE no início de uma linha e `&&` depois de uma
   instrução.
2. **`PROCEDURE Main()`.** O código fica em procedimentos (sem valor de
   retorno) e em funções. O Harbour inicia o programa em `Main()`, se
   existir, e caso contrário no primeiro procedimento do arquivo (testado na
   máquina de desenvolvimento). Não há declaração de tipo: o Clipper tem
   tipagem dinâmica, como o Python.
3. **`?? "Hello, World!"` e depois `?`.** `?` e `??` são os comandos
   clássicos de saída. Eles não são embutidos no compilador: o
   pré-processador os transforma em chamadas de função. O `std.ch` do
   Harbour tem `#command ?  [<explist,...>] => QOut( <explist> )` e
   `#command ?? [<explist,...>] => QQOut( <explist> )`. `QOut()` inicia uma
   nova linha *antes* de escrever; `QQOut()` escreve onde o cursor está.
   Assim, o conhecido `? "Hello, World!"` imprime primeiro uma linha vazia.
   Experimente (passo 6).
4. **`RETURN`** encerra o procedimento; retornar de `Main()` encerra o
   programa com status de saída 0.
5. **O Clipper vira C.** Execute `harbour -q0 -gc2 hello.prg -o/tmp/` (com
   `~/.local/harbour-3.2.0/bin` no PATH; `-gc2` é a saída C "verbose") e
   abra `/tmp/hello.c`: ele contém um vetor de **pcode**, as instruções da
   máquina virtual do Harbour, como `HB_P_PUSHFUNCSYM, 2, 0, /* QQOUT */`, e
   a chamada `hb_vmExecute( pcode, symbols );` que as executa. O `hbmk2`
   compila esse arquivo C e o vincula à máquina virtual e à biblioteca de
   runtime; assim, `bin/hello-cli` não precisa do Harbour em tempo de
   execução (`otool -L bin/hello-cli` mostra apenas `libSystem`).
6. **Experimente:** substitua as duas linhas de saída por
   `? "Hello, World!"`, execute `./build.sh` e `./bin/hello-cli | od -c`. A
   saída agora começa com `\n`. Depois, recompile sem `-gtcgi`
   (`hbmk2 -q0 hello.prg -obin/hello-cli`) e observe
   `./bin/hello-cli | od -c`: os códigos de escape do GTTRM aparecem.
   Execute `./build.sh` novamente para restaurar a compilação normal.

## Por que esta toolchain
- **Não é possível usar o próprio Clipper.** O Clipper era um compilador
  comercial para MS-DOS (Nantucket, depois Computer Associates); ver o
  [README da linguagem](../README.md#history). Ele deixou de evoluir na
  década de 1990: a CA anunciou a versão 5.3 como "the last significant
  release" (Clipper FAQ, 1998 [5]) (tradução livre: "a última versão
  significativa"). Ele gerava programas para MS-DOS, que o macOS e o Linux
  não executam nativamente. Para linguagens antigas, este repositório usa a
  melhor opção daquele período ou o seu sucessor mantido.
- **O Harbour é o sucessor mantido e compatível com o Clipper.** A própria
  descrição dele é "backward compatible with Clipper/xBase" [1] (tradução
  livre: "retrocompatível com Clipper/xBase"). É software livre (GPL com
  exceção de vinculação, ver `LICENSE.txt` [1]) e funciona no macOS, no
  Linux e no Windows. O **Harbour 3.2.0** foi lançado em 2026-07-07, "the
  first official stable release since 3.0.0 (2011)" [2] (tradução livre:
  "a primeira versão estável oficial desde a 3.0.0 (2011)").
- **Por que compilar a partir do código-fonte (e não usar Docker).** A
  fórmula `harbour` do Homebrew ainda está na versão 3.0.0, obsoleta (motivo
  nos dados JSON dela: "uses deprecated libxdiff"), com desativação prevista
  para 2027-01-05; para Macs Intel, ela tem um pacote pronto (*bottle*)
  apenas para o macOS Sonoma [3]; portanto, na máquina de desenvolvimento
  (macOS 26), o Homebrew a compilaria a partir do código-fonte de qualquer
  forma. O arquivo de código-fonte do Debian lista apenas um pacote
  `0.44-1` do Harbour, na antiga versão "sarge" [4]. A versão publicada do
  Harbour traz código-fonte e um pacote para Windows [2], e o README dela
  documenta `make install` em hosts macOS ("Darwin") e Linux, com o Xcode ou
  as Command Line Tools como único pré-requisito no macOS [1]. Na máquina de
  desenvolvimento, a compilação levou cerca de 3 minutos (179 s,
  2026-11-01). Uma compilação nativa foi possível; por isso, não foi
  necessária uma alternativa com Docker.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | Harbour 3.2.0 compilado a partir do código-fonte pelo `install.sh` com o Apple clang 21. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmo script. O CI do Harbour inclui o macOS [1], mas este projeto não testou arm64. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` baixa `harbour-3.2.0.src.tar.gz` das versões do Harbour, confere o SHA-256 e o compila com `make install` em `~/.local/harbour-3.2.0`. Ele exige `make` e `cc`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` baixa `harbour-3.2.0-win-mingw64.7z` [2], confere o SHA-256 e o extrai com o 7-Zip em `~/.local/harbour-3.2.0`. Ele exige o 7-Zip e um `gcc` do MinGW-w64 no PATH. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code; the operating system runs it directly.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm de
`run.sh`.

## Fontes
1. Harbour README (description, build instructions for Darwin and Linux, hbmk2). Projeto Harbour, arquivo `README.md` na versão 3.2.0 e em <https://github.com/harbour/core> (acessado em 2026-11-01)
2. Release v3.2.0 (2026-07-07; assets and SHA-256 digests). Projeto Harbour, GitHub. <https://github.com/harbour/core/releases/tag/v3.2.0> (acessado em 2026-11-01)
3. harbour formula (web page and JSON data <https://formulae.brew.sh/api/formula/harbour.json>). Homebrew. <https://formulae.brew.sh/formula/harbour> (acessado em 2026-11-01)
4. Debian sources: harbour. Debian. <https://sources.debian.org/src/harbour/> (acessado em 2026-11-01)
5. Clipper FAQ, part 3: "About Clipper and Visual Objects" (as of March 1998). The Oasis archive, hospedado pelo projeto Harbour. <https://harbour.github.io/the-oasis/docs/clipper-3.html> (acessado em 2026-11-01)
