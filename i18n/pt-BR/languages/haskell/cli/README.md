---
source: languages/haskell/cli/README.md
source_sha: 190eccece109f9c7d282568cf3811fc7976b1d57
---
# Haskell · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Haskell](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É composto por um único arquivo, [`hello.hs`](hello.hs), compilado
pelo **GHC**, o Glasgow Haskell Compiler, em um executável nativo,
`bin/hello-cli`. O GHC e suas ferramentas são instalados com o **GHCup**,
"the main installer for the general purpose language Haskell" [1] (tradução
livre: "o instalador principal da linguagem de propósito geral Haskell").

O programa tem duas linhas de código propriamente ditas:

```haskell
main :: IO ()
main = putStrLn "Hello, World!"
```

Essas duas linhas mostram a ideia central do Haskell, uma linguagem
**puramente funcional**: imprimir não é algo que o código *faz*; é um valor
(uma ação `IO`) que o código *descreve*. O
[passo a passo](#passo-a-passo) explica isso etapa por etapa.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| GHC | 9.10.3 (GHCup) | compila e liga o `hello.hs` |
| GHCup | 0.2.6.2 | instala o GHC (e o Cabal, usado por [../web](../web/)) em `~/.ghcup` |
| Linker da Apple | Command Line Tools | o GHC usa a toolchain C do sistema para ligar no macOS |

O GHC 9.10.3 foi "released 10th September 2025" [2] (tradução livre:
"lançado em 10 de setembro de 2025"). Na máquina de teste, o `ghcup list` o
exibia com a etiqueta `recommended` em 2026-11-01; o GHCup instala essa
versão quando nenhuma versão é informada [3].

O GHCup coloca seus programas em `~/.ghcup/bin` [4], na pasta pessoal do
usuário, de modo que não é necessário `sudo`. Os scripts adicionam essa
pasta ao `PATH` por conta própria (ver `ghcup-env.sh`); no terminal do
próprio leitor, execute `. ~/.ghcup/env` antes.

## Início rápido
```sh
./install.sh   # check / install GHC with GHCup (asks before installing)
./build.sh     # compile hello.hs into bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `ghc --version`. Se o GHC não estiver instalado, baixa o script de bootstrap do GHCup de `https://get-ghcup.haskell.org` [1] para um arquivo e mostra o caminho dele; em seguida, só o executa se você responder `y` (ele pergunta também antes do download), com `BOOTSTRAP_HASKELL_NONINTERACTIVE=1` (sem perguntas, como no guia do GHCup [3]) e `BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1` (dispensa o Stack, uma ferramenta de build que estes exemplos não usam). No Windows, imprime o comando do PowerShell [1]. | O Haskell é compilado, de modo que o GHC é a única ferramenta de que o cli precisa. O GHCup deve ser executado "as **non-root/non-admin user**" [4] (tradução livre: "como **usuário não root/não administrador**"). |
| `build.sh` | Executa `ghc -O -outputdir build -o bin/hello-cli hello.hs` e imprime esse comando (`set -x`). `GHC=ghc-9.10 ./build.sh` escolhe outro comando de compilador. | Transforma o código-fonte em código de máquina. As opções são explicadas abaixo. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O executável é código de máquina, de modo que o sistema operacional o executa diretamente. |
| `ghcup-env.sh` | Não é executado isoladamente: os outros três scripts o leem. Adiciona `~/.ghcup/bin` ao `PATH` se ele ainda não estiver lá. | O `install.sh` não edita o perfil do shell do leitor, de modo que cada script encontra o `ghc` dessa forma. |

**As opções, uma a uma:**
- `-O`: otimizar. O guia do usuário do GHC descreve o padrão, sem a opção
  `-O`, como "Please compile quickly; I'm not over-bothered about
  compiled-code quality" [5] (tradução livre: "Compile rapidamente; não me
  preocupo muito com a qualidade do código compilado"). O `-O1` (o mesmo
  que `-O`) significa "Generate good-quality code without taking too long
  about it" [5] (tradução livre: "Gere código de boa qualidade sem demorar
  demais para isso").
- `-outputdir build`: coloca os arquivos intermediários em `build/` em vez
  de ao lado do `hello.hs`. Ele "is shorthand for the combination of"
  (tradução livre: "é uma abreviação da combinação de") `-odir`, `-hidir`
  e das demais opções de pasta de saída [6]. Nessa pasta, os arquivos
  recebem o nome do *módulo*, e não do arquivo, de modo que resultam
  `build/Main.o` e `build/Main.hi` [6]. O arquivo de *interface* `.hi`
  "contains the information that GHC needs in order to compile further
  modules that depend on this module" [6] (tradução livre: "contém as
  informações de que o GHC precisa para compilar outros módulos que
  dependem deste módulo").
- `-o bin/hello-cli` dá nome ao executável. Sem ele, o nome é "based on the
  name of the file containing the module `Main`" [6] (tradução livre:
  "baseado no nome do arquivo que contém o módulo `Main`"), de modo que
  aqui seria `hello`.

## Estrutura de pastas
```text
cli/
├── README.md       this file
├── install.sh      checks / installs GHC with GHCup
├── build.sh        compiles hello.hs
├── run.sh          runs bin/hello-cli
├── ghcup-env.sh    adds ~/.ghcup/bin to PATH (read by the scripts)
├── hello.hs        the program
├── build/          created by build.sh: Main.o, Main.hi; not committed
└── bin/            created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- Um programa de um único arquivo, sem bibliotecas, não precisa de arquivo
  de projeto nem de ferramenta de build: o `ghc` sozinho basta. A versão
  [web](../web/) usa bibliotecas, de modo que tem um arquivo `.cabal` e é
  compilada com o Cabal.
- `bin/`, `build/` e os arquivos `*.hi` são ignorados pelo `.gitignore` da
  raiz.

## Passo a passo
Abra o [`hello.hs`](hello.hs) ao lado desta lista.

1. **Comentários.** "An ordinary comment begins with a sequence of two or
   more consecutive dashes (e.g. --) and extends to the following
   newline" [7] (tradução livre: "Um comentário comum começa com uma
   sequência de dois ou mais hifens consecutivos (por exemplo, --) e se
   estende até a quebra de linha seguinte"), como o `//` no C99, no Java
   ou no Go. "A nested comment begins with "{-" and ends with "-}"" [7]
   (tradução livre: "Um comentário aninhado começa com "{-" e termina com
   "-}"").
2. **`module Main (main) where`.** Todo arquivo Haskell é um módulo. Um
   programa precisa de um módulo que, "by convention, must be called Main
   and must export the value main" [8] (tradução livre: "por convenção,
   deve se chamar Main e deve exportar o valor main"). A linha é opcional:
   se um arquivo não tem cabeçalho, "the header is assumed to be 'module
   Main(main) where'" [8] (tradução livre: "presume-se que o cabeçalho seja
   'module Main(main) where'").
3. **`main :: IO ()` é uma assinatura de tipo.** Leia `::` como "tem o
   tipo". `IO ()` é o tipo de uma *ação de E/S*: "The IO type serves as a
   tag for operations (actions) that interact with the outside world" [9]
   (tradução livre: "O tipo IO serve como uma etiqueta para operações
   (ações) que interagem com o mundo exterior"). O `()` é o tipo *unit*, que
   "has one non-⊥ member, the nullary constructor ()" [9] (tradução livre:
   "tem um membro não ⊥, o construtor nulário ()"): a ação não devolve nada
   útil, como o `void` em C. O GHC poderia inferir esse tipo sozinho, mas
   escrevê-lo é o estilo habitual.
4. **`main = putStrLn "Hello, World!"` é uma definição, não um comando.**
   O `putStrLn` tem o tipo `String -> IO ()` [10]: é uma função que recebe
   uma string e devolve uma ação. A aplicação de função não precisa de
   parênteses: "Function application is written e1 e2" [11] (tradução
   livre: "A aplicação de função é escrita e1 e2"), de modo que
   `putStrLn "Hello, World!"` equivale a `putStrLn("Hello, World!")` no
   estilo do C. O resultado dessa aplicação é a ação "escrever esta linha".
   O `=` significa *é igual a*, como na matemática: `main` e essa ação são
   o mesmo valor.
5. **Quem imprime, então? O sistema de runtime.** O Report afirma: "When the
   program is executed, the computation main is performed" [8] (tradução
   livre: "Quando o programa é executado, a computação main é realizada").
   Portanto, o código Haskell apenas *descreve* a impressão, e o runtime a
   *realiza* uma única vez, quando o programa inicia. O haskell.org
   expressa-o assim: "Even side-effecting IO operations are but a
   description of what to do, produced by pure code" [12] (tradução livre:
   "Mesmo as operações de IO com efeitos colaterais são apenas uma descrição
   do que fazer, produzida por código puro").
6. **Por que isso importa: funções puras.** "Every function in Haskell is a
   function in the mathematical sense (i.e., "pure")" [12] (tradução livre:
   "Toda função em Haskell é uma função no sentido matemático (isto é,
   "pura")"): mesma entrada, mesmo resultado, e nada mais acontece. O tipo
   mostra quais valores podem tocar o mundo exterior. Uma função do tipo
   `String -> String` não pode imprimir; sobre esse tipo, o haskell.org
   afirma "By the type it cannot do any side-effects whatsoever" [12]
   (tradução livre: "Pelo tipo, ela não pode ter nenhum efeito colateral").
   Somente valores do tipo `IO ...`, executados a partir de `main`, podem.
   **Experimente:** acrescente uma função pura e use-a em `main`:

   ```haskell
   greet :: String -> String
   greet name = "Hello, " ++ name ++ "!"

   main :: IO ()
   main = putStrLn (greet "World")
   ```

   Execute `./build.sh && ./run.sh`: a saída é a mesma. O `greet` monta o
   texto, e apenas a ação `IO` o imprime. Depois, desfaça a alteração.
7. **Compilar e ligar.** O `build.sh` faz as duas etapas em uma só chamada.
   O `otool -L bin/hello-cli` lista apenas bibliotecas do sistema macOS
   (`libSystem`, `libiconv`, `libffi`, `libcharset`): o GHC liga as
   bibliotecas Haskell e o sistema de runtime ao próprio executável, de modo
   que nenhuma ferramenta Haskell é necessária para executá-lo. Na máquina
   de teste, o arquivo tem 1.438.656 bytes.

## Por que esta toolchain
- **O GHC é o compilador padrão.** O haskell.org chama o GHC de "flagship
  compiler" do Haskell [12] (tradução livre: "compilador principal"). Ele
  compila antecipadamente para um executável nativo, como as versões em
  [C](../../c/cli/) e [Fortran](../../fortran/cli/) deste repositório.
- **O GHCup é o instalador oficial.** Ele "makes it easy to install
  specific versions of GHC on GNU/Linux, macOS (aka Darwin), FreeBSD and
  Windows" [4] (tradução livre: "facilita a instalação de versões
  específicas do GHC em GNU/Linux, macOS (também chamado de Darwin),
  FreeBSD e Windows"), instala na pasta pessoal do usuário e também instala
  o Cabal, de que a versão [web](../web/) precisa.
- **`ghc` puro, sem Cabal nem Stack aqui.** Um único arquivo que não usa
  bibliotecas não precisa de descrição de pacote. A linha de comando do
  `ghc` mostra cada etapa; a versão [web](../web/) mostra o caminho com o
  Cabal.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | GHC 9.10.3, GHCup 0.2.6.2. O GHC tem um build para macOS x86-64 [2]. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o GHC tem um build para macOS AArch64 [2]. O GHCup observa: "On Darwin M1 you might also need a working llvm installed (e.g. via brew) and have the toolchain exposed in PATH" [13] (tradução livre: "No Darwin M1, também pode ser necessário ter um llvm funcional instalado (por exemplo, via brew) e a toolchain exposta no PATH"). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o script de bootstrap do GHCup de `get-ghcup.haskell.org` (não interativo, sem o Stack) quando o `ghc` não existe. Ele instala o GHC e o Cabal em `~/.ghcup`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o GHC: se o `ghc` não existe, ele imprime o comando do PowerShell do GHCup [4] e para. O WSL não foi verificado; ele se comporta como o Linux. |

**O script de bootstrap do GHCup não tem verificação de checksum.** A página de
instalação do GHCup não fornece um checksum para ele: ela aponta para o código-fonte
do script e oferece verificações com GPG apenas para uma instalação manual dos
binários [4]. Por isso, o `install.sh` salva o script em
`~/.cache/hello-world-haskell/bootstrap-haskell.sh` e mostra o caminho, para que
você possa lê-lo antes de responder `y` para executá-lo.

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is machine code with the Haskell runtime inside;
         the operating system runs it directly.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. GHCup (home page: install commands). haskell.org. <https://www.haskell.org/ghcup/> (acessado em 2026-11-01)
2. GHC 9.10.3 download page (release date, binary distributions). GHC developers, haskell.org. <https://www.haskell.org/ghc/download_ghc_9_10_3.html> (acessado em 2026-11-01)
3. GHCup User Guide (tags such as `recommended`, non-interactive install). haskell.org. <https://www.haskell.org/ghcup/guide/> (acessado em 2026-11-01)
4. GHCup: Installation. haskell.org. <https://www.haskell.org/ghcup/install/> (acessado em 2026-11-19)
5. GHC 9.10.3 User's Guide: <!-- vale HelloWorld.British = NO -->Optimisation<!-- vale HelloWorld.British = YES --> (code improvement). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/using-optimisation.html> (acessado em 2026-11-01)
6. GHC 9.10.3 User's Guide: Filenames and separate compilation (-o, -outputdir, interface files). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/separate_compilation.html> (acessado em 2026-11-01)
7. Haskell 2010 Language Report, Chapter 2: Lexical Structure (2.3 Comments). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch2.html> (acessado em 2026-11-01)
8. Haskell 2010 Language Report, Chapter 5: Modules. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch5.html> (acessado em 2026-11-01)
9. Haskell 2010 Language Report, Chapter 6: Predefined Types and Classes (6.1.5 The Unit Datatype, 6.1.7 The IO and IOError Types). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch6.html> (acessado em 2026-11-01)
10. Haskell 2010 Language Report, Chapter 7: Basic Input/Output. haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch7.html> (acessado em 2026-11-01)
11. Haskell 2010 Language Report, Chapter 3: Expressions (3.3 Curried Applications and Lambda Abstractions). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch3.html> (acessado em 2026-11-01)
12. Haskell Language (home page: features). haskell.org. <https://www.haskell.org/> (acessado em 2026-11-01)
13. GHCup: System requirements. haskell.org. <https://www.haskell.org/ghcup/install/reqs/> (acessado em 2026-11-01)
