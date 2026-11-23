---
source: languages/kotlin/cli/README.md
source_sha: 4563752a5db4a661dad32a3955a8a440252ab93d
---
# Kotlin · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Kotlin](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É uma única função de nível superior, `main`, no arquivo
`hello.kt`. Como a versão [Java cli](../../java/cli/), precisa ser
**compilado** antes de poder ser executado, de modo que esta pasta tem um
`build.sh`. O compilador do Kotlin gera bytecode para a Java Virtual Machine
(JVM) [1][2], de modo que o resultado é executado com o mesmo lançador
`java` de um programa Java.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o compilador `kotlinc` roda na JVM, e o `java -jar` executa o programa |
| `kotlinc`, o compilador do Kotlin | 2.4.21 (lançado em 2026-10-08 [3]) | compila o `hello.kt` em um arquivo jar |
| curl, `unzip` | versões do sistema | apenas para o `./install.sh`, que baixa e descompacta o compilador |

O guia oficial da linha de comando manda baixar "the latest version
(`kotlin-compiler-2.4.21.zip`) from GitHub Releases" e descompactar "the
standalone compiler into a directory" [2] (tradução livre: "a versão mais
recente (`kotlin-compiler-2.4.21.zip`) do GitHub Releases" e "o compilador
independente em um diretório"). O `./install.sh` faz exatamente isso, em
`~/.local/kotlinc-2.4.21`.

## Início rápido
```sh
./install.sh   # check / install the JDK and the Kotlin compiler (asks before installing)
./build.sh     # compile into build/hello.jar
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se o `java` é a versão 21 ou superior. 2. Verifica se o `kotlinc` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação e só o executa se você responder `y`. Para o `kotlinc`, baixa o zip oficial, confere seu checksum SHA-256 e o descompacta em `~/.local/kotlinc-2.4.21`. | O compilador é um programa separado do JDK. Um checksum prova que o arquivo baixado é o arquivo que foi publicado. Não é preciso senha de administrador. |
| `kotlinc-env.sh` | Não é executado, apenas incluído (`source`) pelos outros scripts: define a versão, o checksum e a pasta de instalação, e coloca a pasta `bin` do compilador no `PATH`. | O `install.sh` e o `build.sh` precisam concordar sobre onde está o compilador. |
| `build.sh` | Executa `kotlinc hello.kt -include-runtime -d build/hello.jar`. | O `-d` "indicates the output path for generated class files, which may be either a directory or a .jar file" (tradução livre: "indica o caminho de saída dos arquivos de classe gerados, que pode ser um diretório ou um arquivo .jar"), e o `-include-runtime` "makes the resulting .jar file self-contained and runnable by including the Kotlin runtime library in it" [2] (tradução livre: "torna o arquivo .jar resultante autocontido e executável, incluindo nele a biblioteca de runtime do Kotlin"). |
| `run.sh` | Executa `java -jar build/hello.jar`. `--verify` faz o mesmo, porque um programa cli já termina por conta própria. | A JVM carrega o bytecode do jar e chama `main` [2]. |

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / installs the JDK and the Kotlin compiler
├── kotlinc-env.sh   compiler version, checksum and folder (sourced, not run)
├── build.sh         compiles hello.kt into build/hello.jar
├── run.sh           runs the jar
├── hello.kt         the whole program
├── .gitignore       keeps build/ out of the repository
└── build/           created by build.sh; not committed
    └── hello.jar
```
Um único arquivo não precisa de uma estrutura de projeto. As outras pastas
de Kotlin usam a ferramenta de build Gradle: veja [../desktop](../desktop/)
e [../web](../web/).

## Passo a passo
Abra o [`hello.kt`](hello.kt) ao lado desta lista. O guia oficial da linha
de comando mostra o mesmo programa: `fun main() { println("Hello, World!") }`
[2].

1. **`fun main()`** declara uma função (`fun`) chamada `main`. O Kotlin
   inicia o programa em uma função de nível superior com esse nome. Não há
   classe em volta, nem `public`, nem `static`. O compilador coloca a função
   em uma classe chamada `HelloKt`, a partir do nome do arquivo, e grava
   essa classe no jar. O [Java](../../java/cli/README.md#step-by-step-walkthrough)
   precisa de uma classe, de `public static void main(String[] args)` e de
   um arquivo com o nome da classe.
2. **Sem tipo de retorno e sem parâmetro.** Uma função que não devolve nada
   não precisa de tipo de retorno em Kotlin, e o parâmetro que guarda os
   argumentos de linha de comando pode ser omitido quando o programa não os
   lê.
3. **`println("Hello, World!")`** imprime o texto e uma quebra de linha. É
   uma função da biblioteca padrão do Kotlin, de modo que não precisa de
   import nem de `System.out`. Compare com o `print` do Python no
   [Python cli](../../python/cli/).
4. **Sem ponto e vírgula.** Uma quebra de linha encerra a instrução. Isso
   difere de Java, C, C++ e C#.
5. **`build.sh`** é uma etapa de compilação, como em Java, Pascal e C. Com
   `-include-runtime`, o `kotlinc` também copia a biblioteca de runtime do
   Kotlin para dentro do jar, de modo que o jar é executado sozinho [2].

## Por que esta toolchain
- **O `kotlinc` é o compilador de referência** da JetBrains, a empresa que
  desenvolve o Kotlin [1]. O guia oficial da linha de comando o usa para
  este mesmo programa [2].
- **A versão 2.4.21** é a mais nova listada na página de versões do Kotlin
  (2026-10-08) [3].
- **O mesmo JDK 21** das [pastas de Java](../../java/README.md), de modo que
  o leitor precisa de uma única instalação do Java para as duas linguagens.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Temurin 21.0.8, `kotlinc` 2.4.21 (JRE 21.0.8). O zip do compilador é baixado uma vez e fica em cache em `~/.cache/hello-world-kotlin`. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o compilador e o jar são bytecode Java puro. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` com o apt quando nenhum Java 21 é encontrado. Se o `kotlinc` não existe, ele baixa o zip oficial do compilador Kotlin, confere seu checksum SHA-256 e o extrai em `~/.local/kotlinc-2.4.21` [2]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK: se o Java 21 não existe, imprime o comando `winget` do Temurin 21 e para. Se o `kotlinc` não existe, ele baixa o mesmo zip, confere seu checksum SHA-256 e o extrai com o 7-Zip quando o Git Bash não tem o `unzip` [2]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` e `./run.sh --verify` imprimem:
```text
==> Run the program
    WHY: 'java -jar' starts the JVM and runs the main function in the jar.
Hello, World!
```
A última linha é a saída do programa.

## Fontes
1. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (acessado em 2026-11-04)
2. Kotlin command-line compiler. JetBrains. <https://kotlinlang.org/docs/command-line.html> (acessado em 2026-11-04)
3. Kotlin releases. JetBrains. <https://kotlinlang.org/docs/releases.html> (acessado em 2026-11-04)
