---
source: languages/prolog/cli/README.md
source_sha: 2b4743f7a48ed50cdca84cd3ba8b5d08c09f4332
---
# Prolog · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Prolog](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É um único arquivo, [`hello.pl`](hello.pl), com uma diretiva e uma
regra, executado pelo **SWI-Prolog**, um sistema Prolog gratuito [1] cuja
"syntax and set of built-in predicates is based on the ISO standard" [2]
(tradução livre: "sintaxe e conjunto de predicados embutidos baseiam-se no
padrão ISO").

O Prolog é uma linguagem **lógica**. O arquivo não lista comandos a executar
em ordem. Ele enuncia uma regra, e executar o programa significa pedir ao
Prolog que *prove* um objetivo a partir dessa regra. O texto aparece como
efeito colateral dessa prova. Como na [versão `cli` do Python](../../python/cli/),
não há `build.sh`: o `swipl` lê o arquivo de código-fonte a cada inicialização.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| SWI-Prolog (`swipl`) | 10.0.2 (`swi-prolog` 10.0.2 do Homebrew) | carrega `hello.pl` e prova o objetivo `main` |

O programa usa apenas o predicado embutido `format/1` e a diretiva
`initialization/2`; portanto, qualquer versão atual do SWI-Prolog deve
funcionar. Somente a 10.0.2 foi testada.

Em Macs Intel, o Homebrew não tem pacote pré-compilado (*bottle*) do
`swi-prolog`; a página da fórmula lista bottles apenas para o macOS em Apple
Silicon e para o Linux [3]. Assim, `brew install swi-prolog` o compila a
partir do código-fonte, o que também exige `cmake` e `pkgconf` [3]. O site
oficial também oferece uma imagem de disco para macOS com "universal (fat)
binaries that run natively on Intel (x86_64) and Apple Silicon" [4]
(tradução livre: "binários universais (fat) que executam nativamente em
Intel (x86_64) e Apple Silicon").

## Início rápido
```sh
./install.sh   # check / install SWI-Prolog (asks before installing)
./run.sh       # run it
```
Não há `build.sh` (ver [Por que não há etapa de compilação](#por-que-não-há-etapa-de-compilação)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Executa `swipl --version`. Se estiver ausente, oferece `brew install swi-prolog` (macOS), `sudo apt-get install -y swi-prolog-nox` (Debian/Ubuntu) ou imprime o link de download e o comando `winget` para Windows, e só executa uma instalação se a resposta for `y`. | O código Prolog precisa de um sistema Prolog para ser executado. Nada mais é necessário. |
| `run.sh` | Executa `swipl hello.pl`. `--verify` faz o mesmo (um programa CLI termina por conta própria). | Iniciar o `swipl` com nomes de arquivos é "the normal way to start Prolog" (tradução livre: "a forma normal de iniciar o Prolog"): os arquivos "are loaded" (tradução livre: "são carregados") [5]. A diretiva no arquivo então executa `main`. |

Ambos os scripts aceitam `SWIPL=<command>` para usar outro `swipl`, por
exemplo `SWIPL=/Applications/SWI-Prolog.app/Contents/MacOS/swipl ./run.sh`
para a imagem de disco (suas "commandline tools" estão "in the Contents/MacOS
directory" [4]; tradução livre: "ferramentas de linha de comando" estão "no
diretório Contents/MacOS").

## Estrutura de pastas
```text
cli/
├── README.md     this file
├── install.sh    checks / installs SWI-Prolog
├── run.sh        runs swipl hello.pl
└── hello.pl      the program (one directive, one rule, teaching comments)
```
- Um arquivo `.pl` é um programa completo. O SWI-Prolog carrega arquivos que
  têm a extensão `.pl` ou `.prolog` e são informados na linha de comando [5].
  Um "traditional Prolog source file contains Prolog clauses and directives,
  but no module declaration" [6] (tradução livre: "arquivo-fonte Prolog
  tradicional contém cláusulas e diretivas Prolog, mas nenhuma declaração de
  módulo"); `hello.pl` é um arquivo desse tipo.
- Nada é gravado em disco, portanto nada precisa ser ignorado pelo Git.

## Passo a passo
Abra [`hello.pl`](hello.pl) ao lado desta lista.

1. **Comentários** começam com `%` e vão até o fim da linha, como `//` em
   C99, Java ou Go. `/* ... */` também funciona.
2. **Cláusulas.** Um arquivo Prolog é uma lista de *cláusulas*. O glossário
   do SWI-Prolog chama a cláusula de "'Sentence' of a Prolog program"
   (tradução livre: "'Sentença' de um programa Prolog"), composta de uma
   *cabeça* e de um *corpo* "separated by the neck operator (`:-`)" [7]
   (tradução livre: "separados pelo operador neck (`:-`)"). Leia `:-` como
   "se". Cada cláusula termina com um ponto final `.`.
3. **Fatos e regras.** Um *fato* é uma "Clause without a body" (tradução
   livre: "Cláusula sem corpo"); portanto, "interpreted as logic, there is no
   condition to be satisfied" [7] (tradução livre: "interpretado como lógica,
   não há condição a ser satisfeita"). O exemplo do glossário é
   `person(john).` ("john é uma pessoa"). Uma cláusula com corpo é uma
   *regra*: a cabeça é verdadeira se o corpo for verdadeiro. `hello.pl` não
   tem fatos e tem uma regra.
4. **A diretiva `:- initialization(main, main).`** Uma cláusula sem cabeça,
   apenas com `:-` e um objetivo, é uma *diretiva*: "an instruction to the
   compiler" (tradução livre: "uma instrução ao compilador"), executada
   enquanto o arquivo é carregado [6]. Esta diz ao SWI-Prolog o que fazer
   após o carregamento: "the last goal registered using
   `initialization(Goal, main)` is executed as main goal" (tradução livre:
   "o último objetivo registrado com `initialization(Goal, main)` é
   executado como objetivo principal"). Se ele for bem-sucedido, o programa
   termina "with status 0" (tradução livre: "com status 0"); "If Goal fails
   or raises an exception, the process terminates with non-zero exit code" [8]
   (tradução livre: "Se Goal falhar ou lançar uma exceção, o processo termina
   com código de saída diferente de zero"). Sem a diretiva, `swipl hello.pl`
   carregaria o arquivo e depois aguardaria, no prompt interativo `?-`, as
   perguntas do leitor.
5. **A regra `main :- format("Hello, World!~n").`** lê-se "`main` é verdadeiro
   se `format("Hello, World!~n")` for verdadeiro". `main` é um *predicado*:
   uma "Collection of clauses with the same functor (name/arity)" [7]
   (tradução livre: "Coleção de cláusulas com o mesmo functor
   (nome/aridade)"). Seu nome é `main` e sua aridade (número de argumentos)
   é 0, escrita `main/0`. Aqui, a coleção tem uma cláusula.
6. **A consulta.** A diretiva faz a pergunta (o *objetivo*) `main`. Um
   objetivo é uma "Question stated to the Prolog engine" (tradução livre:
   "Pergunta formulada ao motor do Prolog"); ele "either succeeds ... or it
   fails if Prolog fails to prove it" [7] (tradução livre: "ou é bem-sucedido
   ... ou falha, se o Prolog não conseguir prová-lo"). Para provar `main`, o
   Prolog encontra a cláusula cuja cabeça corresponde a `main` e prova seu
   corpo. O corpo é `format/1`, um predicado embutido que vai "Write
   formatted output to Output or `current_output`" [9] (tradução livre:
   "Escrever saída formatada em Output ou em `current_output`"). `~n` significa
   "Output a newline character" [9] (tradução livre: "Enviar um caractere de
   quebra de linha"), como `\n` em C. Provar o objetivo imprime o texto; esse
   efeito colateral é a finalidade do programa.
7. **Unificação e retrocesso (*backtracking*)** são as outras duas partes do
   motor de prova do Prolog. Este programa é pequeno demais para precisar
   delas, mas elas determinam como todo programa maior é executado:
   - *Unificar* é "make two terms equal by assigning variables in one term to
     values at the corresponding location of the other term" (tradução livre:
     "tornar dois termos iguais atribuindo variáveis de um termo a valores na
     posição correspondente do outro termo"). "Unlike assignment (which does
     not exist in Prolog), unification is not directed" [7] (tradução livre:
     "Diferentemente da atribuição (que não existe no Prolog), a unificação não
     tem direção"). Casar o objetivo `main` com a cabeça `main` é uma
     unificação (trivial).
   - *Retrocesso*: "If a predicate offers multiple clauses to solve a goal,
     they are tried one-by-one until one succeeds" (tradução livre: "Se um
     predicado oferece várias cláusulas para resolver um objetivo, elas são
     tentadas uma a uma até que uma seja bem-sucedida"). Se um objetivo
     posterior não for satisfeito, o Prolog pode "reject the previously chosen
     clause and try the next one" [7] (tradução livre: "rejeitar a cláusula
     escolhida anteriormente e tentar a seguinte"). `main/0` tem uma cláusula,
     portanto não há para onde retroceder.

**Experimente** (a partir desta pasta, em qualquer shell):
```sh
swipl -g 'foo(a, B) = foo(A, b), print(A-B), nl' -t halt
swipl -g 'member(X, [red, green, blue]), format("~w~n", [X]), fail ; true' -t halt
```
A primeira linha é o exemplo de unificação do glossário [7]: ela imprime
`a-b`, porque `=` torna os dois termos iguais nos dois sentidos. Na segunda,
`member/2` é "True if Elem is a member of List" [10] (tradução livre:
"Verdadeiro se Elem for membro de List"), portanto tem três respostas. `fail`
vai "Always fail" [11] (tradução livre: "Sempre falhar"), o que força o
Prolog a retroceder em `member/2` para obter a resposta seguinte; assim, ele
imprime `red`, `green` e `blue` em três linhas. A forma que o manual indica
"to prevent the user from entering interactive mode" é "start the
application with `-g goal -t halt`" [5] (tradução livre: "para impedir que o
usuário entre no modo interativo" é "iniciar a aplicação com
`-g goal -t halt`"): `-g` executa o objetivo e `-t halt` encerra o programa
em vez de abrir o prompt `?-`.

### Por que não há etapa de compilação
O SWI-Prolog compila, mas em memória, toda vez que carrega um arquivo. O
glossário afirma: "SWI-Prolog always compiles your program before executing
it" (tradução livre: "O SWI-Prolog sempre compila o programa antes de
executá-lo"), em que compilar é o "Process where a Prolog program is
translated to a sequence of instructions" [7] (tradução livre: "Processo em
que um programa Prolog é traduzido para uma sequência de instruções"). Como o
bytecode do CPython, isso não exige um comando separado e não deixa arquivo
em disco. (O SWI-Prolog também pode gerar um executável independente com
`swipl -o output -c prolog-file` [5]; um Hello World não precisa disso.)

## Por que esta toolchain
- O **SWI-Prolog** "offers a comprehensive free Prolog environment" and "is
  widely used in research and education as well as commercial applications"
  [1] (tradução livre: "oferece um ambiente Prolog gratuito e abrangente" e "é
  amplamente usado em pesquisa e ensino, assim como em aplicações
  comerciais"). Seu manual afirma que ele "is traditionally strong in
  education because it is free and portable, but also because of its
  compatibility with textbooks and its easy-to-use environment" [2] (tradução
  livre: "é tradicionalmente forte no ensino por ser gratuito e portável, mas
  também por sua compatibilidade com livros didáticos e por seu ambiente fácil
  de usar"). Isso é adequado a um repositório voltado a quem está aprendendo.
  Sua licença é BSD-2-Clause [3].
- **Prolog padronizado.** A linguagem é padronizada como ISO/IEC
  13211-1:1995, *Prolog, Part 1: General core*, publicada em 1995-06-01 [12].
  Os predicados embutidos do SWI-Prolog são "based on the ISO standard" [2]
  (tradução livre: "baseados no padrão ISO"). Uma parte de `hello.pl` é
  própria do SWI-Prolog: o manual marca `initialization/1`, com um argumento,
  como ISO [6], mas não `initialization/2` [8]. A opção `main` é usada mesmo
  assim, porque resulta no programa mais simples que executa, imprime e
  termina.
- O **Homebrew** é o gerenciador de pacotes que este repositório usa no macOS.
  Sua fórmula `swi-prolog` estava na 10.0.2 em 2026-11-01 [3], a mesma versão
  do download estável atual [4].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | SWI-Prolog 10.0.2 do Homebrew, compilado a partir do código-fonte (sem bottle para Intel) [3]. |
| macOS Apple Silicon | ⚠️ não verificado | `brew install swi-prolog` instala um bottle pré-compilado [3]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `swi-prolog-nox` com o apt quando o `swipl` não existe [13]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` exige o MSYS2 em `C:\msys64` e instala os pacotes UCRT64 `swi-prolog-core` e `swi-prolog-packages` com o `pacman` quando o `swipl` não existe. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: swipl loads hello.pl and proves the goal 'main', which prints the
         greeting as a side effect; then the program stops.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais vêm de `run.sh`.
Para ver os bytes exatos:
```text
$ swipl hello.pl | od -c
0000000    H   e   l   l   o   ,       W   o   r   l   d   !  \n
0000016
```

## Fontes
1. SWI-Prolog (home page). SWI-Prolog. <https://www.swi-prolog.org/> (acessado em 2026-11-01)
2. SWI-Prolog Reference Manual: 1.1 Positioning SWI-Prolog. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=swiprolog> (acessado em 2026-11-01)
3. `swi-prolog` formula. Homebrew. <https://formulae.brew.sh/formula/swi-prolog> (acessado em 2026-11-01)
4. Download SWI-Prolog stable versions. SWI-Prolog. <https://www.swi-prolog.org/download/stable> (acessado em 2026-11-01)
5. SWI-Prolog Reference Manual: 2.4 Command line options. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=cmdline> (acessado em 2026-11-01)
6. SWI-Prolog Reference Manual: 4.3 Loading Prolog source files. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=consulting> (acessado em 2026-11-01)
7. SWI-Prolog Reference Manual: Glossary of Terms. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?section=glossary> (acessado em 2026-11-01)
8. SWI-Prolog Reference Manual: initialization/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=initialization/2> (acessado em 2026-11-01)
9. SWI-Prolog Reference Manual: format/1, format/2, format/3. SWI-Prolog. <https://www.swi-prolog.org/pldoc/man?predicate=format/1> (acessado em 2026-11-01)
10. SWI-Prolog Reference Manual: member/2. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=member/2> (acessado em 2026-11-01)
11. SWI-Prolog Reference Manual: fail/0. SWI-Prolog. <https://www.swi-prolog.org/pldoc/doc_for?object=fail/0> (acessado em 2026-11-01)
12. ISO/IEC 13211-1:1995, Information technology - Programming languages - Prolog - Part 1: General core (catalog page). IEC Webstore (ISO/IEC JTC 1/SC 22). <https://webstore.iec.ch/publication/9731> (acessado em 2026-11-01)
13. Package `swi-prolog-nox` (trixie). Debian. <https://packages.debian.org/stable/swi-prolog-nox> (acessado em 2026-11-01)
14. Installing from PPA (Ubuntu Personal Package Archive). SWI-Prolog. <https://www.swi-prolog.org/build/PPA.html> (acessado em 2026-11-01)
15. manifests/s/SWI-Prolog/SWI-Prolog. microsoft/winget-pkgs, GitHub. <https://github.com/microsoft/winget-pkgs/tree/master/manifests/s/SWI-Prolog/SWI-Prolog> (acessado em 2026-11-01)
