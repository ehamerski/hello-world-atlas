---
source: languages/java/desktop/README.md
source_sha: af25ca3fa9c8e60f92b836f85daee10b48a48374
---
# Java · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Java](../README.md)

## O que é
Um programa desktop que abre uma janela nativa intitulada "Hello, World!"
com o texto **Hello, World!** no centro. A janela é desenhada pelo
**JavaFX**, um toolkit de GUI para Java. O programa continua em execução
até que o leitor feche a janela.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o `javac` compila o código, e o `java` o executa |
| Apache Maven | 3.9.16 | compila o projeto e baixa o JavaFX |
| JavaFX (OpenJFX) | 21.0.13 (fixada no `pom.xml`) | o toolkit de GUI; **não é instalado manualmente**: o Maven o baixa do Maven Central durante o `./build.sh` |

O JavaFX não faz parte do JDK. A Oracle o retirou "as a stand-alone module
as of Java SE 11" [10] (tradução livre: "como módulo independente a partir
do Java SE 11"), para o projeto OpenJFX. Por isso ele é uma dependência do
Maven aqui, ao contrário do tkinter do Python, que acompanha os
instaladores do python.org. O guia do openjfx.io faz a mesma observação:
com o Maven, "you don't have to download the JavaFX SDK" [1] (tradução
livre: "não é necessário baixar o SDK do JavaFX").

## Início rápido
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile; downloads JavaFX the first time
./run.sh       # open the window (close it to end the program)
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Executa `javac -version` e verifica se a versão é 21 ou superior. 2. Verifica se o `mvn` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação e só o executa se você responder `y`. | A mesma toolchain de [../cli](../cli/README.md#scripts-explained). O JavaFX não precisa de instalação separada. |
| `build.sh` | Executa `mvn --batch-mode --quiet package`. Isso compila o `HelloApp.java` em `target/hello-desktop.jar` e copia os arquivos JAR do JavaFX para `target/lib/`. | A JVM executa bytecode, de modo que o código precisa ser compilado antes. O `copy-dependencies` "copies the files for a project's dependencies from the repository to a directory" [6] (tradução livre: "copia os arquivos das dependências de um projeto do repositório para um diretório"); o `run.sh` precisa deles em uma pasta conhecida. O primeiro build baixa os plugins do Maven e as bibliotecas do `pom.xml` do Maven Central para `~/.m2/repository`; os builds seguintes os reutilizam. |
| `run.sh` | Executa `java --module-path target/lib --add-modules javafx.controls -cp target/hello-desktop.jar com.example.hello.HelloApp`. Com `--verify`, define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que a janela é exibida e encerra após cerca de 2 s. | O JavaFX é um conjunto de **módulos** Java. Este é o comando que o openjfx.io fornece para executar um aplicativo JavaFX pela linha de comando: `java --module-path $PATH_TO_FX --add-modules javafx.controls HelloFX` [1]. A autoverificação permite que o `scripts/verify-all.sh` teste a janela sem esperar pelo leitor. |

## Estrutura de pastas
```text
desktop/
├── README.md          this file
├── install.sh         checks / installs the JDK and Maven
├── build.sh           compiles and collects JavaFX into target/lib
├── run.sh             opens the window
├── screenshot.png     the window, for "Expected output" below
├── pom.xml            Maven project: Java 21, JavaFX dependency, plugins
├── src/main/java/com/example/hello/
│   └── HelloApp.java  the program
└── target/            created by build.sh; not committed
    ├── hello-desktop.jar
    └── lib/           javafx-base, javafx-graphics, javafx-controls jars
```
- A Standard Directory Layout do Maven, como em [../cli](../cli/README.md#folder-structure) [2].
- O `pom.xml` pede apenas o `javafx-controls`. O Maven acrescenta o
  `javafx-graphics` e o `javafx-base` porque o `javafx-controls` depende
  deles. O openjfx.io observa que o javafx.graphics "is transitively
  required by the javafx.controls module" [1] (tradução livre: "é exigido
  transitivamente pelo módulo javafx.controls").
- O JavaFX contém código nativo, de modo que cada arquivo JAR tem uma
  variante por sistema operacional. O POM pai do JavaFX para o Maven escolhe
  o "classifier" a partir do sistema operacional e da CPU do leitor: `mac`,
  `mac-aarch64`, `linux`, `linux-aarch64`, `win` e outros [7]. Na máquina de
  verificação (um Mac Intel), o `target/lib` contém
  `javafx-base-21.0.13-mac.jar` e assim por diante.
- O `target/lib` também contém arquivos JAR sem classifier (por exemplo,
  `javafx-base-21.0.13.jar`). São marcadores vazios: seu manifesto apenas
  diz `Automatic-Module-Name: javafx.baseEmpty` (verificado com `unzip -p`
  na máquina de verificação). Não causam problemas no module path.
- A execução do `maven-dependency-plugin` está vinculada à fase `package`.
  Por padrão, o `copy-dependencies` executa em `process-sources` e copia
  para `target/dependency` [6]. O `pom.xml` altera ambos, de modo que os
  arquivos JAR ficam em `target/lib`, ao lado do `hello-desktop.jar`.

## Passo a passo
Abra o [`HelloApp.java`](src/main/java/com/example/hello/HelloApp.java) ao
lado desta lista.

1. **`import javafx...;`** traz as classes do JavaFX usadas abaixo, como
   `from tkinter import ttk` faz em [Python](../../python/desktop/hello.py).
2. **`public class HelloApp extends Application`**: um programa JavaFX é uma
   subclasse de `Application`. Isso é **herança** da orientação a objetos: a
   classe recebe todo o ciclo de vida do JavaFX e apenas preenche o
   `start()`. A versão [cli](../cli/) não precisava de herança.
3. **O `main` chama `launch(args)`.** A cada inicialização, o runtime do
   JavaFX "Constructs an instance of the specified Application class; Calls
   the init() method; Calls the start(javafx.stage.Stage) method; Waits for
   the application to finish" e, em seguida, chama `stop()` [3] (tradução
   livre: "Constrói uma instância da classe Application especificada; chama
   o método init(); chama o método start(javafx.stage.Stage); aguarda o fim
   da aplicação"). O `launch` "does not return until the application has
   exited" [3] (tradução livre: "não retorna até que a aplicação tenha
   terminado").
4. **`start(Stage stage)`** "is called on the JavaFX Application Thread" [3]
   (tradução livre: "é chamado na JavaFX Application Thread"). Um `Stage` é
   uma janela, e o JavaFX cria a primeira e a passa para o `start()`.
5. **`new Label("Hello, World!")`** é o texto. Um `StackPane` o centraliza, o
   `setPadding(new Insets(40))` acrescenta 40 pixels de espaço ao redor dele
   e uma `Scene` contém tudo o que é desenhado na janela. Em seguida, o
   `setTitle` define a barra de título e o `show()` coloca a janela na tela.
6. **A autoverificação.** Com `TF_VERIFY=1`, a aplicação verifica
   `stage.isShowing()`, imprime o texto do rótulo e inicia uma
   `PauseTransition` de 2 s. Uma `PauseTransition` "executes an
   Animation.onFinished at the end of its duration" [4] (tradução livre:
   "executa um Animation.onFinished ao fim de sua duração"), e esse tratador
   chama `Platform.exit()`, que "Causes the JavaFX application to
   terminate" [5] (tradução livre: "Faz a aplicação JavaFX terminar") e é "the
   preferred way to explicitly terminate a JavaFX Application" [3]
   (tradução livre: "a maneira preferida de encerrar explicitamente uma
   aplicação JavaFX"). `event -> Platform.exit()` é uma **lambda**, uma forma
   curta de passar uma função como valor (Java 8 e posteriores).
7. **Sem laço explícito.** Depois que o `start()` retorna, o JavaFX continua
   tratando eventos até que a última janela seja fechada. O tkinter do
   Python faz o mesmo com `root.mainloop()`, e um servidor web faz o mesmo
   enquanto aguarda requisições.

## Por que esta toolchain
- **JavaFX ou Swing?** O JDK ainda inclui um toolkit de GUI mais antigo, o
  Swing. A Oracle afirma que "Swing and AWT remain core Java SE
  technologies" [10] (tradução livre: "Swing e AWT continuam sendo
  tecnologias centrais do Java SE"), de modo que o Swing não está
  obsoleto. Este repositório usa o JavaFX na versão desktop em Java (e o
  Swing em [desktop-swing](../desktop-swing/)). O JavaFX é desenvolvido de
  forma aberta como OpenJFX [10]. Ele ainda recebe versões com novos
  recursos (o JavaFX 21 foi lançado em setembro de 2023; a 27 é a mais
  recente em outubro de 2026) e tem versões de suporte de longo prazo (LTS)
  [9].
- **Por que o JavaFX 21 e não o 27?** Cada versão do JavaFX exige um JDK
  mínimo. "JavaFX 21 requires JDK 17 or later" [8] (tradução livre: "O
  JavaFX 21 exige o JDK 17 ou posterior"), mas "JavaFX 24 requires JDK 22 or
  later" [11] (tradução livre: "O JavaFX 24 exige o JDK 22 ou posterior"), e
  o JavaFX mais recente, o 27, precisa do JDK 25 [9]. Este repositório usa
  o Java 21, de modo que o JavaFX mais novo que ele pode usar é a linha 23,
  que "is compiled with `--release 21` and thus requires JDK 21 or later"
  [12] (tradução livre: "é compilada com `--release 21` e, portanto, exige o
  JDK 21 ou posterior"). Mas a 23 não é uma linha LTS; sua última versão no
  Maven Central é a 23.0.2 [13]. O JavaFX 21 é uma linha LTS, e a Gluon a
  lista como uma versão LTS ativa, com a 21.0.13 publicada em outubro de
  2026 [9]. Ela corresponde ao Java 21 LTS.
- **Por que não `mvn javafx:run`?** O openjfx.io também documenta o
  `javafx-maven-plugin`, que executa a aplicação com `mvn javafx:run` [1].
  Aqui, o `build.sh` e o `run.sh` são mantidos separados, como em toda
  implementação compilada deste repositório: compila-se uma vez e depois se
  executa com o `java` simples.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, JavaFX 21.0.13 (arquivos JAR `mac`). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O Maven escolhe os arquivos JAR `mac-aarch64` do JavaFX [7]. Use um JDK arm64 (o cask `temurin@21` instala um no Apple Silicon). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` e `maven` com o apt quando faltam. O Maven escolhe os arquivos JAR do `linux` [7]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK nem o Maven: se um dos dois não existe, imprime o comando `winget` do Temurin 21 ou os passos do zip do Maven e para. O Maven escolhe os arquivos JAR do `win` [7]. |

## Saída esperada
O `./run.sh` abre uma pequena janela intitulada "Hello, World!" com o texto
"Hello, World!" no centro:

![A janela do JavaFX intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-10-31 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela. O título aparece cortado porque a janela
é estreita.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: JavaFX draws the window. Its jars in target/lib are loaded as Java modules.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. Getting Started with JavaFX. OpenJFX (Gluon). <https://openjfx.io/openjfx-docs/> (acessado em 2026-10-31)
2. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (acessado em 2026-10-31)
3. Application (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/application/Application.html> (acessado em 2026-10-31)
4. PauseTransition (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/animation/PauseTransition.html> (acessado em 2026-10-31)
5. Platform (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.graphics/javafx/application/Platform.html> (acessado em 2026-10-31)
6. dependency:copy-dependencies. Apache Maven Dependency Plugin. <https://maven.apache.org/plugins/maven-dependency-plugin/copy-dependencies-mojo.html> (acessado em 2026-10-31)
7. javafx-21.0.13.pom (OS profiles and `javafx.platform` classifiers). Maven Central. <https://repo.maven.apache.org/maven2/org/openjfx/javafx/21.0.13/javafx-21.0.13.pom> (acessado em 2026-10-31)
8. Release Notes for JavaFX 21. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx21/doc-files/release-notes-21.md> (acessado em 2026-10-31)
9. JavaFX (downloads and release table). Gluon. <https://gluonhq.com/products/javafx/> (acessado em 2026-10-31)
10. Java Client Roadmap Update (May 2020). Oracle. <https://www.oracle.com/technetwork/java/javase/javaclientroadmapupdatev2020may-6548840.pdf> (acessado em 2026-10-31)
11. Release Notes for JavaFX 24. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx24/doc-files/release-notes-24.md> (acessado em 2026-10-31)
12. Release Notes for JavaFX 23. OpenJDK (openjdk/jfx). <https://github.com/openjdk/jfx/blob/jfx23/doc-files/release-notes-23.md> (acessado em 2026-10-31)
13. org.openjfx:javafx-controls versions (maven-metadata.xml). Maven Central. <https://repo.maven.apache.org/maven2/org/openjfx/javafx-controls/maven-metadata.xml> (acessado em 2026-10-31)
