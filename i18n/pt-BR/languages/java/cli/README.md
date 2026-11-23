---
source: languages/java/cli/README.md
source_sha: 94c282ca7abac8c200847f7f331609d993fb3ec5
---
# Java · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Java](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. É a versão clássica em Java: uma classe, `Hello`, com um método
`main`. Diferentemente da versão [Python cli](../../python/cli/), precisa
ser **compilado** antes de poder ser executado, de modo que esta pasta tem
um `build.sh`.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o `javac` compila o código para bytecode, e o `java` o executa na JVM |
| Apache Maven | 3.9.16 | a ferramenta de build: lê o `pom.xml`, chama o `javac` e empacota o `.jar` |

Um JRE (somente o runtime) não é suficiente: ele não tem o `javac`. O Maven
precisa de "a Java Development Kit (JDK) installed" [5] (tradução livre: "um
Java Development Kit (JDK) instalado"). O Maven 3.10.0 é a versão mais
recente do Maven (2026) [5]; a 3.9.16 é a versão instalada na máquina de
verificação e compila este projeto da mesma forma.

## Início rápido
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into target/hello-cli.jar
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Executa `javac -version` e verifica se a versão é 21 ou superior. 2. Verifica se o `mvn` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação (Homebrew, apt ou winget) e só o executa se você responder `y`. | O Java é compilado: o JDK contém o compilador e a JVM, e o Maven conduz o build. No macOS, o `/usr/bin/javac` sempre existe, mas só funciona quando um JDK está instalado, de modo que o script o executa em vez de apenas verificar se o arquivo existe. |
| `build.sh` | Executa `mvn --batch-mode --quiet package`. | As fases do Maven "are executed sequentially" (tradução livre: "são executadas em sequência"): `validate`, `compile`, `test` e, por fim, `package`, que pega "the compiled code and package[s] it in its distributable format, such as a JAR" [2] (tradução livre: "o código compilado e o empacota em seu formato distribuível, como um JAR"). A JVM executa bytecode, nunca arquivos `.java` [8]. O primeiro build baixa os plugins do Maven do Maven Central para `~/.m2/repository`; os builds seguintes os reutilizam. |
| `run.sh` | Executa `java -jar target/hello-cli.jar`. `--verify` faz o mesmo (um programa cli termina por conta própria). | O `java` inicia a JVM, que lê o manifesto do arquivo JAR para encontrar a classe principal (`com.example.hello.Hello`) [4]. |

## Estrutura de pastas
```text
cli/
├── README.md        this file
├── install.sh       checks / installs the JDK and Maven
├── build.sh         compiles and packages with Maven
├── run.sh           runs the jar
├── pom.xml          the Maven project file (name, Java version, plugins)
├── src/main/java/com/example/hello/
│   └── Hello.java   the program
└── target/          created by build.sh; not committed (see ../../../.gitignore)
    └── hello-cli.jar
```
- Esta é a **Standard Directory Layout** (estrutura de diretórios padrão)
  do Maven: `src/main/java` contém "Application/Library sources" (tradução
  livre: "fontes da aplicação ou da biblioteca"), e "the target directory is
  used to house all output of the build" [1] (tradução livre: "o diretório
  target é usado para abrigar toda a saída do build").
- As pastas abaixo de `src/main/java` seguem o nome do **pacote**:
  `com.example.hello` → `com/example/hello/`. A Java Language Specification
  sugere formar "a unique package name" (tradução livre: "um nome de pacote
  único") a partir de "an Internet domain name" (tradução livre: "um nome de
  domínio da Internet"), invertido [9]; o `example.com` é reservado para
  exemplos [10], de modo que não pertence a ninguém.
- O `pom.xml` define `maven.compiler.release` como 21: o código é
  "compiled following the rules of the programming language of the
  specified release" (tradução livre: "compilado segundo as regras da
  linguagem de programação da versão especificada") e as classes têm essa
  versão como alvo [3].
- O `maven-jar-plugin` grava `Main-Class` no manifesto do arquivo JAR. A
  documentação do Maven afirma que "if you want to create an executable jar
  file ... You need to tell it which main class to use" (tradução livre: "se
  você quiser criar um arquivo jar executável ... é preciso informar qual
  classe principal usar"), o que é feito com `<mainClass>` [4].
- O `<finalName>hello-cli</finalName>` nomeia o arquivo JAR como
  `hello-cli.jar` em vez de `hello-cli-1.0.0.jar`, de modo que o `run.sh`
  não depende da versão.

## Passo a passo
Abra o [`Hello.java`](src/main/java/com/example/hello/Hello.java) ao lado
desta lista.

1. **`package com.example.hello;`** coloca a classe em um espaço de nomes (namespace).
   Arquivos Python e JavaScript não têm essa linha; em Java, o pacote também
   precisa corresponder à pasta.
2. **`public class Hello { ... }`**: em Java, todo método fica dentro de uma
   classe. Uma classe pública precisa estar em um arquivo com o mesmo nome,
   `Hello.java`. O Java é "class-based, object-oriented" [11] (tradução
   livre: "baseado em classes e orientado a objetos"). Este programa não
   cria objetos, mas ainda assim precisa da classe.
3. **`public static void main(String[] args)`** é o ponto de entrada que o
   lançador `java` procura. `static` significa que ele executa sem criar um
   objeto `Hello`; `args` contém os argumentos de linha de comando. C, C++ e
   C# também começam em um `main`; o Python executa o arquivo de cima para
   baixo.
4. **`System.out.println("Hello, World!");`** escreve o texto e uma quebra
   de linha na saída padrão. A instrução termina com `;`, como em C.
5. **Compilar e depois executar.** O `javac` (por meio do Maven) transforma
   o `Hello.java` em `Hello.class`. Esse arquivo "does not contain code that
   is native to your processor; it instead contains bytecodes — the machine
   language of the Java Virtual Machine" [8] (tradução livre: "não contém
   código nativo do processador; em vez disso, contém bytecodes — a
   linguagem de máquina da Java Virtual Machine"). O `java` então o executa.
   As duas etapas podem ser feitas manualmente, sem o Maven:
   ```sh
   javac -d out src/main/java/com/example/hello/Hello.java
   java -cp out com.example.hello.Hello
   ```

**O Java mais recente é mais curto.** O Java 25 tornou definitivos os
"compact source files" (JEP 512) [12] (tradução livre: "arquivos-fonte
compactos"). Com isso, um programa inteiro pode ser
`void main() { IO.println("Hello, World!"); }`, sem classe e sem `static`.
O objetivo da JEP é permitir que "beginners ... write their first programs
without needing to understand" [12] (tradução livre: "iniciantes ...
escrevam seus primeiros programas sem precisar entender") recursos
destinados a programas grandes. No Java 21, que este repositório usa, o
recurso era apenas uma prévia (JEP 445) [13], de modo que aqui se usa a
forma clássica.

## Por que esta toolchain
- **O Java 21** é uma versão de suporte de longo prazo (LTS). A Oracle lista
  "Java SE 8, 11, 17, 21, and 25" como versões LTS, com Premier Support para
  a 21 até setembro de 2028 [14]. Este repositório usa o Java 21 LTS nas
  quatro implementações em Java. Versões mais novas também compilam este
  código.
- **O Eclipse Temurin** é o JDK que o `install.sh` sugere: "Prebuilt
  OpenJDK Binaries for Free!" (tradução livre: "Binários OpenJDK
  pré-compilados, gratuitos!"), do projeto Eclipse Adoptium [20]. O Adoptium
  recomenda instalá-lo "through a package manager" [6] (tradução livre:
  "por meio de um gerenciador de pacotes").
- **O Maven** dá a todo projeto Java a mesma estrutura e os mesmos comandos
  (`mvn package`) [1][2]. O tutorial do próprio Spring Boot também usa o
  Maven [15], de modo que a versão [web](../web/) é compilada da mesma
  forma. As quatro pastas Java usam o Maven para ficarem semelhantes.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Temurin 21.0.8, Maven 3.9.16. A fórmula `maven` do Homebrew depende do `openjdk` do Homebrew [7]; na máquina de verificação, seu script wrapper `mvn` usa o `JAVA_HOME` quando ele está definido e, caso contrário, esse `openjdk` (verifique com `mvn -v`). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O `brew install --cask temurin@21` instala o JDK arm64 [16]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` e `maven` com o apt quando faltam. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK nem o Maven: se um dos dois não existe, imprime o comando `winget` do Temurin 21 ou os passos do zip do Maven e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: 'java -jar target/hello-cli.jar' starts the JVM, which runs Hello.main().
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm do
`run.sh`.

## Fontes
1. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (acessado em 2026-10-31)
2. Introduction to the Build Lifecycle. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html> (acessado em 2026-10-31)
3. Setting the --release of the Java Compiler. Apache Maven Compiler Plugin. <https://maven.apache.org/plugins/maven-compiler-plugin/examples/set-compiler-release.html> (acessado em 2026-10-31)
4. Set Up The Classpath (executable jar, `mainClass`). Apache Maven Archiver. <https://maven.apache.org/shared/maven-archiver/examples/classpath.html> (acessado em 2026-10-31)
5. Installing Apache Maven. Apache Maven. <https://maven.apache.org/install.html> (acessado em 2026-10-31)
6. Install Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/installation/> (acessado em 2026-10-31)
7. maven (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/maven> (acessado em 2026-10-31)
8. About the Java Technology (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html> (acessado em 2026-10-31)
9. The Java Language Specification, Java SE 21, §6.1 Declarations (package naming). Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-6.html#jls-6.1> (acessado em 2026-10-31)
10. RFC 2606: Reserved Top Level DNS Names. IETF. <https://www.rfc-editor.org/rfc/rfc2606> (acessado em 2026-10-31)
11. The Java Language Specification, Java SE 21, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (acessado em 2026-10-31)
12. JEP 512: Compact Source Files and Instance Main Methods. OpenJDK. <https://openjdk.org/jeps/512> (acessado em 2026-10-31)
13. JEP 445: Unnamed Classes and Instance Main Methods (Preview). OpenJDK. <https://openjdk.org/jeps/445> (acessado em 2026-10-31)
14. Oracle Java SE Support Roadmap. Oracle. <https://www.oracle.com/java/technologies/java-se-support-roadmap.html> (acessado em 2026-10-31)
15. Developing Your First Spring Boot Application. Spring. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (acessado em 2026-10-31)
16. `temurin@21` (cask). Homebrew Formulae. <https://formulae.brew.sh/cask/temurin@21> (acessado em 2026-10-31)
17. `openjdk-21-jdk` in Debian (`madison`). Debian. <https://qa.debian.org/madison.php?package=openjdk-21-jdk> (acessado em 2026-10-31)
18. Package `openjdk-21-jdk` in noble. Ubuntu. <https://packages.ubuntu.com/noble/openjdk-21-jdk> (acessado em 2026-10-31)
19. `EclipseAdoptium.Temurin.21.JDK` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/e/EclipseAdoptium/Temurin/21/JDK> (acessado em 2026-10-31)
20. Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/temurin/> (acessado em 2026-10-31)
