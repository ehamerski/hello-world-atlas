---
source: languages/lisp/cli/README.md
source_sha: 146a24e2772a354933b4038ba465cd83ea42dc12
---
# Common Lisp · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Common Lisp](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. Consiste em um único arquivo, [`hello.lisp`](hello.lisp), escrito
em **ANSI Common Lisp** padrão (ANSI INCITS 226-1994 [1]) e compilado com o
**SBCL** (Steel Bank Common Lisp), "a free and open-source ANSI Common Lisp
implementation with a high-performance native Compiler" [2] (tradução livre:
"uma implementação livre e de código aberto do ANSI Common Lisp, com um
compilador nativo de alto desempenho").

O build funciona de modo diferente da [versão `cli` em C](../../c/cli/) ou
da [versão `cli` em Fortran](../../fortran/cli/). Não há um compilador que
transforme um arquivo de código-fonte em um executável. Em vez disso, o
SBCL é iniciado, carrega `hello.lisp` em sua memória (compilando cada função
para código de máquina à medida que avança) e, em seguida, salva toda a sua
memória, a *imagem*, como o executável `bin/hello-cli`.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| SBCL | 2.6.10 (`sbcl` do Homebrew, `/usr/local/bin/sbcl`) | carrega `hello.lisp` e salva o executável |

O SBCL 2.6.10 foi "released October 29, 2026" [3] (tradução livre:
"lançado em 29 de outubro de 2026"). No macOS, ele vem da fórmula `sbcl` do
Homebrew [4]. O Homebrew tem pacotes pré-compilados (bottles) para Macs com
Apple Silicon e para Linux, mas não para Macs com Intel [4]; assim, em um
Mac com Intel, `brew install sbcl` compila o SBCL a partir do código-fonte.
O SBCL é escrito em Lisp e "can be compiled from source code using another
ANSI-compliant Common Lisp implementation" [5] (tradução livre: "pode ser
compilado a partir do código-fonte usando outra implementação de Common Lisp
compatível com o ANSI"); por isso, o Homebrew instala primeiro o `ecl`
(Embeddable Common Lisp) como dependência de build [4].

## Início rápido
```sh
./install.sh   # check / install SBCL (asks before installing)
./build.sh     # load hello.lisp and save the image as bin/hello-cli
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `sbcl --version`. Se o SBCL estiver ausente, oferece `brew install sbcl` (macOS) ou `sudo apt-get install -y sbcl` (Debian/Ubuntu), ou indica o instalador para Windows em sbcl.org, e só executa um comando se a resposta for `y`. `SBCL=/path/to/sbcl ./install.sh` verifica outro comando. | O SBCL é a única ferramenta necessária: o programa não usa nada além do padrão Common Lisp. |
| `build.sh` | Executa `sbcl --non-interactive --no-sysinit --no-userinit --load hello.lisp --eval '(sb-ext:save-lisp-and-die "bin/hello-cli" :executable t :toplevel (function main))'` e imprime esse comando (`set -x`). | Carrega o programa em um Lisp em execução e salva esse Lisp como um único arquivo executável. As opções são explicadas a seguir. |
| `run.sh` | Executa `./bin/hello-cli`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | O executável contém o runtime do SBCL; assim, o sistema operacional o executa diretamente. O próprio SBCL não é necessário neste ponto. |

**As opções, uma a uma:**
- `--non-interactive`: "Sets both --quit and --disable-debugger" (do
  `sbcl --help` [6]) (tradução livre: "Define --quit e --disable-debugger
  ao mesmo tempo"). `--quit` significa "Exit with code 0 after option
  processing" [6] (tradução livre: "Sair com código 0 após o processamento
  das opções"). Sem ele, o SBCL pararia no prompt do REPL e aguardaria a
  digitação. `--disable-debugger` faz um erro "print a backtrace and exit
  with status 1" (tradução livre: "imprimir um backtrace e sair com status
  1") em vez de abrir o depurador interativo [2]; assim, um `hello.lisp`
  com defeito faz o `build.sh` falhar.
- `--no-sysinit` / `--no-userinit`: "Don't load a system-wide
  initialization file" / "Don't load a user initialization file" [2]
  (tradução livre: "Não carregar um arquivo de inicialização do sistema" /
  "Não carregar um arquivo de inicialização do usuário"). O `~/.sbclrc` do
  próprio usuário não pode alterar o build.
- `--load hello.lisp`: "equivalent to --eval '(load "<filename>")'" [2]
  (tradução livre: "equivalente a --eval '(load "<filename>")'").
- `--eval '(...)'`: avalia uma forma Lisp. "More than one --eval option
  can be used, and all will be read and executed, in the order they appear
  on the command line" [2] (tradução livre: "Mais de uma opção --eval pode
  ser usada, e todas serão lidas e executadas na ordem em que aparecem na
  linha de comando").
- `sb-ext:save-lisp-and-die` salva "a 'core image', i.e. enough
  information to restart a Lisp process later in the same state" [2]
  (tradução livre: "uma 'imagem de núcleo', isto é, informação suficiente
  para reiniciar um processo Lisp mais tarde no mesmo estado"). O nome diz o
  que ela faz: salvar e, depois, sair. É uma extensão do SBCL (pacote
  `sb-ext`), não faz parte do padrão.
  - `:executable t`: "combine the SBCL runtime and the core image to
    create a standalone executable" [2] (tradução livre: "combinar o runtime
    do SBCL e a imagem de núcleo para criar um executável autônomo").
  - `:toplevel (function main)`: "The function to run when the created
    core file is resumed" [2] (tradução livre: "A função a executar quando o
    arquivo de núcleo criado é retomado"). Sem ele, o executável iniciaria
    o REPL. "This function returning is equivalent to (sb-ext:exit :code 0)
    being called" [2] (tradução livre: "O retorno desta função equivale a
    chamar (sb-ext:exit :code 0)"); assim, o programa termina com código de
    saída 0 quando `main` retorna.

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs SBCL
├── build.sh      loads hello.lisp and saves bin/hello-cli
├── run.sh        runs bin/hello-cli
├── hello.lisp    the program
└── bin/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli
```
- Um programa Lisp de um único arquivo dispensa arquivo de projeto: o
  `build.sh` mostra o comando do SBCL no lugar dele.
- `bin/` e os arquivos Lisp compilados (`*.fasl`) são ignorados pelo
  `.gitignore` da raiz.

## Passo a passo
Abra [`hello.lisp`](hello.lisp) ao lado desta lista.

1. Os **comentários** começam com `;` e se estendem até o fim da linha. O
   número de pontos e vírgulas é uma convenção de estilo do padrão: `;;;;`
   para um "title for the code which follows" (tradução livre: "título do
   código que se segue"), `;;;` "prior to a definition" (tradução livre:
   "antes de uma definição"), `;;` dentro do código "aligned to the same
   level of indentation as a form" (tradução livre: "alinhado ao mesmo
   nível de indentação de uma forma") e `;` no fim de uma linha [7].
2. **O código são listas.** Tudo o que está entre parênteses é uma lista.
   Quando o Lisp avalia uma lista cujo primeiro elemento é um símbolo, "that
   symbol is the name of an operator" [8] (tradução livre: "esse símbolo é o
   nome de um operador"), e os demais elementos são os argumentos. Assim,
   `(format t "Hello, World!~%")` chama `format` com dois argumentos, e
   `(+ 1 2)` equivale a `1 + 2`. Como um programa é feito de listas, o
   código Lisp pode ler e construir outro código Lisp: uma macro é "a
   function ... that implements macro expansion by producing a form to be
   evaluated in place of the original argument form" [9] (tradução livre:
   "uma função ... que implementa a expansão de macro produzindo uma forma
   a ser avaliada no lugar da forma original do argumento"). A [versão
   web](../web/) usa uma.
3. **`(defun main () ...)`** "Defines a new function named function-name
   in the global environment" [10] (tradução livre: "Define uma nova função
   chamada function-name no ambiente global"). `()` é a lista de parâmetros
   vazia. O nome `main` é uma escolha deste programa: o Common Lisp não tem
   ponto de entrada obrigatório. O `build.sh` faz de `main` a função de
   inicialização com `:toplevel`.
4. **`(format t "Hello, World!~%")`** escreve o texto na saída padrão.
   - `t` é o destino: a saída padrão. Com `nil` no lugar, `format` retorna o
     texto como uma string e não imprime nada [11].
   - `~%` é uma diretiva: ela "outputs a #\Newline character" [12]
     (tradução livre: "produz um caractere #\Newline"). Em `format`, o til
     inicia uma diretiva, como o `%` no `printf` do C [11].
   - `format` com `t` retorna `nil` [11]; portanto, `main` retorna `nil`.
     Toda forma Lisp tem um valor; aqui, ninguém o utiliza.
5. **Funcional, mas não puro.** O Common Lisp é "a multi-paradigm
   programming language" [13] (tradução livre: "uma linguagem de programação
   multiparadigma"), e este repositório o agrupa com as linguagens
   funcionais. Uma função é "an object representing code" [14] (tradução
   livre: "um objeto que representa código"): `(function main)` no
   `build.sh` entrega a própria função `main`, como valor, a
   `save-lisp-and-die`. Mas `main` não é uma função matemática: sua única
   tarefa é um efeito colateral, a impressão. A linguagem não impede isso;
   ver a [visão geral da linguagem](../README.md) para uma comparação com o
   Haskell.
6. **Carregar não é executar.** `sbcl --script hello.lisp` não imprime nada:
   `--script` carrega o arquivo "instead of entering the read-eval-print-loop,
   and exit[s] afterwards" [2] (tradução livre: "em vez de entrar no laço
   read-eval-print e sair depois"), e o carregamento apenas *define*
   `main`. **Experimente** com a linha do topo do arquivo, que carrega o
   arquivo e, em seguida, chama `main`:
   `sbcl --noinform --eval '(load "hello.lisp")' --eval '(main)' --quit`.
7. **O modelo de imagem.** A forma usual de trabalhar em Lisp é o REPL
   (laço read-eval-print), "where you can interact with SBCL by typing
   expressions" [2] (tradução livre: "em que é possível interagir com o SBCL
   digitando expressões"). **Experimente:** execute `sbcl`, digite
   `(load "hello.lisp")` e, depois, `(main)`; altere o texto no arquivo,
   carregue-o novamente, chame `(main)` de novo e saia com `(quit)`. Um
   programa em execução foi alterado sem ser reiniciado. O `build.sh` faz os
   mesmos passos sem que ninguém digite e, depois, salva em disco esse Lisp
   em execução.
8. **O que há dentro do executável.** `bin/hello-cli` tem 36.147.144 bytes
   na máquina de teste: é um sistema Lisp completo (incluindo o compilador e
   o depurador), não apenas `main`. `otool -L bin/hello-cli` mostra duas
   bibliotecas: `libSystem.B.dylib` (macOS) e `libzstd.1.dylib` do Homebrew.
   O SBCL do Homebrew depende do `zstd` [4], que o SBCL usa para arquivos de
   núcleo comprimidos [2]; assim, o executável roda sem o SBCL, mas ainda
   precisa do pacote `zstd`.

## Por que esta toolchain
- **O SBCL é livre, mantido e rápido.** Ele tem "a high-performance native
  Compiler" [2] (tradução livre: "um compilador nativo de alto desempenho")
  e teve uma versão lançada em 2026-10-29 [3]. Há binários para Linux e
  Windows, e ele está no Homebrew e no Debian [3][4][15].
- **O padrão não muda desde 1994.** O padrão da linguagem continua sendo o
  ANSI INCITS 226-1994 [1]. O Common Lisp HyperSpec, a referência online
  gratuita usada aqui como fonte, "is not the ANSI Common Lisp standard, but
  is based on that standard" [16] (tradução livre: "não é o padrão ANSI
  Common Lisp, mas se baseia nesse padrão"). `hello.lisp` usa apenas
  operadores padrão (`defun`, `format`); somente o `build.sh` usa uma
  extensão do SBCL (`sb-ext:save-lisp-and-die`).
- **Um único executável, como nas outras versões CLI.** Salvar a imagem com
  `:executable t` produz um arquivo que roda como os programas em C ou Go. O
  preço é o tamanho (cerca de 36 MB aqui), porque todo o sistema Lisp
  acompanha o programa.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | SBCL 2.6.10 do Homebrew, compilado a partir do código-fonte (sem bottle para Intel; compila com `ecl`) [4]. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install sbcl` instala um bottle pré-compilado [4]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `sbcl` com o apt quando ele não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala o pacote UCRT64 `sbcl` com o `pacman` quando o `sbcl` não existe. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: bin/hello-cli is a saved Lisp image plus the SBCL runtime; the
         operating system runs it, and the image calls MAIN.
Hello, World!
```
O próprio programa imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. Common Lisp Documentation (the standard ANSI INCITS 226-1994). LispWorks. <https://www.lispworks.com/documentation/common-lisp.html> (acessado em 2026-11-01)
2. SBCL 2.6.10 User Manual (1 Introduction; 3.3 Command-line Options; 3.6.1 Saving a Core Image; 5.3 Enabling and Disabling the Debugger). SBCL. <https://www.sbcl.org/manual/> (acessado em 2026-11-01)
3. Download (platform table: "The most recent version of SBCL is 2.6.10, released October 29, 2026"). SBCL. <https://www.sbcl.org/platform-table.html> (acessado em 2026-11-01)
4. `sbcl` formula. Homebrew. <https://formulae.brew.sh/formula/sbcl> (acessado em 2026-11-01)
5. Getting Started. SBCL. <https://www.sbcl.org/getting.html> (acessado em 2026-11-01)
6. `sbcl --help` (output of SBCL 2.6.10 on the test machine; the same help text is printed by every SBCL 2.6.10 installation). SBCL. <https://www.sbcl.org/> (acessado em 2026-11-01)
7. Common Lisp HyperSpec, 2.4.4.2 Notes about Style for Semicolon (and 2.4.4.2.1 to 2.4.4.2.4). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/02_ddb.htm> (acessado em 2026-11-01)
8. Common Lisp HyperSpec, 3.1.2.1.2 Conses as Forms. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/03_abab.htm> (acessado em 2026-11-01)
9. Common Lisp HyperSpec, Glossary: M ("macro function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_m.htm> (acessado em 2026-11-01)
10. Common Lisp HyperSpec, Macro DEFUN. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/m_defun.htm> (acessado em 2026-11-01)
11. Common Lisp HyperSpec, Function FORMAT. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/f_format.htm> (acessado em 2026-11-01)
12. Common Lisp HyperSpec, 22.3.1.2 Tilde Percent: Newline. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/22_cab.htm> (acessado em 2026-11-01)
13. Common-Lisp.net (home page: "What is Common Lisp?"). Common-Lisp.net. <https://common-lisp.net/> (acessado em 2026-11-01)
14. Common Lisp HyperSpec, Glossary: F ("function"). LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Body/26_glo_f.htm> (acessado em 2026-11-01)
15. Package `sbcl` (trixie). Debian. <https://packages.debian.org/stable/sbcl> (acessado em 2026-11-01)
16. About the Common Lisp HyperSpec. LispWorks. <https://www.lispworks.com/documentation/HyperSpec/Front/Help.htm> (acessado em 2026-11-01)
