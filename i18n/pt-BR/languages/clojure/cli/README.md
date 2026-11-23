---
source: languages/clojure/cli/README.md
source_sha: 3a3d059a4375b12798865011395e9a7fd9f62079
---
# Clojure · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Clojure](../README.md)

## O que é
Um programa de linha de comando que imprime `Hello, World!` e termina. É uma
única função, `-main`, em um único espaço de nomes (namespace), `hello.core`.
O Clojure CLI inicia uma Java Virtual Machine (JVM), carrega o espaço de
nomes, compila-o para bytecode em memória e chama `-main`.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Java runtime 21 ou superior | Eclipse Temurin 21.0.8 | O Clojure "is always compiled (on the JVM, to Java bytecode)" [1] (tradução livre: "é sempre compilado (na JVM, para bytecode Java)"), portanto uma JVM o executa. O próprio Clojure exige Java 8 ou superior; este repositório testa com o Java 21 [2]. |
| Clojure CLI (`clojure`, `clj`) | 1.12.6.1673 | lê o `deps.edn`, baixa as bibliotecas, monta o classpath e inicia a JVM [3] |
| Clojure (a linguagem, um arquivo JAR) | 1.12.6 | o compilador e a biblioteca padrão; o CLI o baixa do Maven Central no primeiro uso [2][4] |

O Clojure CLI tem uma versão de quatro partes, e a linguagem tem uma versão de
três partes. "The leading 3 parts of the CLI version indicate which version of
the Clojure language will be used by default" [4] (tradução livre: "As três
primeiras partes da versão do CLI indicam qual versão da linguagem Clojure
será usada por padrão").

## Início rápido
```sh
./install.sh   # check / install Java and the Clojure CLI (asks before installing)
./run.sh       # run it (there is no build.sh)
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se o `java` é a versão 21 ou superior. 2. Verifica se o `clojure` está no `PATH`; se não estiver, oferece instalar o Clojure CLI 1.12.6.1673 em `~/.local/clojure-1.12.6` com o instalador POSIX oficial (sem `sudo`). 3. Executa `clojure -P` após perguntar, a menos que `.cpcache/` já contenha o classpath. | O Java executa o bytecode e o CLI o inicia. Com `-P`, o CLI faz "a full deps expansion, download deps, and cache the classpath, but not actually execute the function, tool, main, etc." [5] (tradução livre: "uma expansão completa das dependências, baixa as dependências e guarda o classpath em cache, mas não executa de fato a função, a ferramenta, o main etc."). Assim, o `./run.sh` inicia sem baixar nada. |
| `run.sh` | Executa `clojure -M -m hello.core`. `--verify` faz o mesmo: um programa cli não tem mais nada a verificar. | `-M` executa o `clojure.main` e `-m` nomeia um espaço de nomes "with a -main function" [5] (tradução livre: "com uma função -main"). |
| `clojure-env.sh` | Define a versão do CLI, o checksum do instalador e `CLOJURE_DIR`, e coloca `$CLOJURE_DIR/bin` no `PATH`. O `install.sh` e o `run.sh` o carregam com `source`. | Um único lugar para as configurações da toolchain. É idêntico em [../desktop](../desktop/) e [../web](../web/), de modo que cada pasta continua independente. |

### Por que não há build.sh
A regra deste repositório é que uma linguagem compilada tem um `build.sh`. O
Clojure é compilado, mas o compilador roda quando o programa é carregado, e
não como uma etapa separada:

- "Clojure compiles all code you load on-the-fly into JVM bytecode, but
  sometimes it is advantageous to compile ahead-of-time (AOT)" [6] (tradução
  livre: "O Clojure compila todo o código que você carrega, na hora, para
  bytecode da JVM, mas às vezes é vantajoso compilar antecipadamente (AOT)").
  A referência do Clojure lista os motivos para o AOT: entregar uma aplicação
  sem o código-fonte, acelerar a inicialização, gerar classes nomeadas para o
  Java e criar uma aplicação que não precise de geração de bytecode em tempo
  de execução nem de class loaders personalizados [6]. Um Hello World não
  precisa de nenhum deles.
- O autor afirma que "there is no interpreter" e que o Clojure é "always
  compiled" para bytecode Java na JVM [1] (tradução livre: "não há
  interpretador" e "sempre compilado"). Por isso o programa roda direto do
  código-fonte com `clojure -M -m hello.core`: esse comando é todo o "compilar
  e executar", e os arquivos `.clj` são a única entrada.
- O CLI cobre a outra tarefa de uma ferramenta de build, o download de
  dependências, com `clojure -P`, que o `install.sh` executa. Empacotar em um
  único arquivo JAR ("uberjar") com o `tools.build` é o caminho do AOT [6].
  Este repositório não o segue, porque acrescentaria uma biblioteca, um alias
  de build e um `build.sh` que produz uma saída de que o programa não precisa
  para executar.

A mesma escolha vale para [../desktop](../desktop/) e [../web](../web/).
Compare com o [Java](../../java/cli/README.md), em que o `javac` precisa rodar
antes do `java`, e com o [Python](../../python/cli/README.md), que também não
tem `build.sh`.

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI
├── run.sh           runs the program
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folders and dependencies
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
- O `deps.edn` é o arquivo de projeto do Clojure CLI. Ele contém `:paths`, as
  pastas com o código-fonte, e `:deps`, as bibliotecas [3][7]. O arquivo lista
  `:paths` explicitamente, embora `["src"]` também seja o valor no `deps.edn`
  do próprio CLI.
- O espaço de nomes `hello.core` é o arquivo `src/hello/core.clj`: os pontos
  no nome viram pastas. O CLI coloca `src` no classpath, de modo que o
  carregador encontra o arquivo ali.
- O `.cpcache/` é criado pelo CLI na pasta do projeto e guarda o classpath
  calculado. Ele não é versionado.

Referência do layout: <https://clojure.org/reference/deps_and_cli>

## Passo a passo
Abra o [`core.clj`](src/hello/core.clj) ao lado desta lista.

1. **`(ns hello.core)`** declara o espaço de nomes. Os espaços de nomes são os
   módulos do Clojure. No Java, o nome de um pacote precisa corresponder a uma
   pasta, e uma classe precisa corresponder a um arquivo; aqui o arquivo
   contém quantas funções se quiser. O Common Lisp tem pacotes, mas eles não
   estão ligados a arquivos.
2. **Tudo é uma lista.** `(defn -main ...)` é uma lista cujo primeiro item é o
   operador. Essa é a herança do Lisp: o Clojure "is a dialect of Lisp" [8]
   (tradução livre: "é um dialeto do Lisp"), e nos Lisps "code is data" [8]
   (tradução livre: "código é dado"), de modo que o programa é escrito nas
   mesmas listas que ele manipula. O Common Lisp escreve a mesma coisa como
   `(defun main () (format t "Hello, World!~%"))`.
3. **`defn`** define uma função: um nome, um vetor de parâmetros entre
   colchetes e um corpo. `-main` é apenas uma convenção: a opção `-m` procura
   uma função com esse nome [5].
4. **`& args`** reúne os argumentos da linha de comando em uma sequência. O
   programa os ignora. O `main` do Java obriga a escrever `String[] args` e
   uma classe mesmo quando nenhum argumento é usado.
5. **`(println "Hello, World!")`** imprime a string e uma quebra de linha. Uma
   chamada de função tem a forma `(função argumento ...)`: o parêntese abre
   antes do nome da função. Não há ponto e vírgula; no Clojure, um `;` inicia
   um comentário, como no Common Lisp.
6. **O resultado.** Toda expressão tem um valor. O valor da última expressão
   de um corpo é o valor da função; `println` retorna `nil`.
7. **O que executa.** `clojure -M -m hello.core` inicia uma JVM com o
   `clojure.main`, que carrega o `hello.core`. O compilador transforma cada
   forma em bytecode, "there is no interpreter" [1] (tradução livre: "não há
   interpretador"), e o `-main` é chamado. Quando o `-main` retorna, a JVM
   termina, porque nenhuma outra thread está em execução.

Veja a [visão geral da linguagem](../README.md#comparing-the-categories) e
[docs/comparisons.md](../../../docs/comparisons.md) para este programa ao lado
das outras linguagens.

## Por que esta toolchain
- **O Clojure CLI é a forma oficial de executar o Clojure.** O guia Getting
  Started do clojure.org o instala: o CLI "can download Clojure itself and
  other Clojure or JVM-based libraries" [4] (tradução livre: "pode baixar o
  próprio Clojure e outras bibliotecas Clojure ou baseadas na JVM"). O
  Leiningen, uma ferramenta de build mais antiga, não é usado aqui.
- **O instalador POSIX oficial, com checksum.** O guia documenta o
  `posix-install.sh` para Linux, BSD e macOS, e sua opção `--prefix` [4]. O
  `install.sh` executa o instalador versionado da release 1.12.6.1673 do
  `clojure/brew-install` [9], confere antes o seu SHA-256 e instala na pasta
  pessoal do usuário, de modo que não é necessário `sudo`. Em seguida, o
  instalador confere o checksum do arquivo de ferramentas que baixa. O guia
  avisa que, no macOS, esse instalador "will conflict with brew" [4]
  (tradução livre: "entrará em conflito com o brew"). Se o `clojure/tools/clojure`
  do Homebrew já for usado, o `install.sh` encontra esse `clojure` no `PATH` e
  não instala nada.
- **Java 21.** O clojure.org lista o Java 8 como mínimo e recomenda a versão
  de suporte de longo prazo mais recente; o seu guia de instalação diz que o
  Clojure "officially supports Java LTS releases (currently Java 8, 11, 17, 21,
  and 25)" [2][4] (tradução livre: "oferece suporte oficial às versões LTS do
  Java (atualmente Java 8, 11, 17, 21 e 25)"). O Java 21 é a versão usada nas
  outras pastas JVM deste repositório.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6), instalado pelo instalador POSIX oficial em `~/.local/clojure-1.12.6`. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O instalador é um script de shell e as bibliotecas são bytecode da JVM, de modo que apenas o Java runtime é específico da CPU. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` com o apt quando nenhum Java 21 é encontrado. Se o `clojure` não existe, ele baixa o instalador POSIX oficial, confere seu checksum SHA-256 e instala o CLI em `~/.local/clojure-1.12.6` sem sudo [4]. Em seguida, executa `clojure -P`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK: se o Java 21 não existe, imprime o comando `winget` do Temurin 21 e para. Se o `clojure` não existe, ele baixa o instalador `clj-msi`, confere seu checksum SHA-256 e o instala silenciosamente em `~/.local/clojure-1.12.6` [4]. Em seguida, executa `clojure -P`. O WSL não foi verificado; ele se comporta como o Linux. |

O Homebrew (`brew install clojure/tools/clojure`) é a alternativa documentada
para o macOS [4]. Ele não foi executado para esta pasta.

## Saída esperada
O `./run.sh` imprime:
```text
Hello, World!
```
O `./run.sh --verify` (o mesmo programa) imprimiu, em 2026-11-04:
```text
==> Run the program
    WHY: 'clojure -M -m hello.core' loads hello.core and calls its -main function.
Hello, World!
```

## Fontes
1. A History of Clojure, section 3.5.10 "Implementation Benefits". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, Article 71, 2020 (author's PDF, Internet Archive copy of download.clojure.org). <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (acessado em 2026-11-04)
2. Clojure Downloads (stable release 1.12.6; "Recommended: Java 25 (LTS releases are supported)", "Minimum: Java 8"). clojure.org. <https://clojure.org/releases/downloads> (acessado em 2026-11-04)
3. Clojure CLI Reference. clojure.org. <https://clojure.org/reference/clojure_cli> (acessado em 2026-11-04)
4. Install Clojure. clojure.org. <https://clojure.org/guides/install_clojure> (acessado em 2026-11-04)
5. Clojure CLI Reference, "Run a main namespace or script (-M)" and option -P. clojure.org. <https://clojure.org/reference/clojure_cli> (acessado em 2026-11-04)
6. Ahead-of-time Compilation and Class Generation. clojure.org. <https://clojure.org/reference/compilation> (acessado em 2026-11-04)
7. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (acessado em 2026-11-04)
8. A History of Clojure, abstract and section 3.1 "Clojure, the Lisp". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, 2020. <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (acessado em 2026-11-04)
9. clojure/brew-install release 1.12.6.1673 (contains `posix-install.sh`). Clojure core team, GitHub. <https://github.com/clojure/brew-install/releases/tag/1.12.6.1673> (acessado em 2026-11-04)
