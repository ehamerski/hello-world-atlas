---
source: languages/java/desktop-swing/README.md
source_sha: 298d1b2882fac4dd313bba9361dc58db7d9f1b47
---
# Java · desktop-swing: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Java](../README.md) ·
> Versão JavaFX do mesmo programa: [../desktop](../desktop/)

## O que é
Um programa desktop que abre uma janela nativa intitulada "Hello, World!"
com o texto **Hello, World!** no centro. A janela é desenhada pelo
**Swing**, o toolkit de GUI que acompanha o JDK. O programa continua em
execução até que o leitor feche a janela.

É o mesmo programa de [../desktop](../desktop/), que usa o JavaFX. Colocar
os dois lado a lado mostra como os dois toolkits desktop do Java diferem.
Ver [Swing ou JavaFX?](#swing-ou-javafx) abaixo.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o `javac` compila o código, e o `java` o executa. **O Swing está dentro do JDK.** |
| Apache Maven | 3.9.16 | compila o projeto (sem dependências para baixar) |

Nada mais é necessário. O módulo `java.desktop` do JDK "Defines the AWT and
Swing user interface toolkits, plus APIs for accessibility, audio, imaging,
printing, and JavaBeans" [8] (tradução livre: "Define os toolkits de
interface de usuário AWT e Swing, além de APIs para acessibilidade, áudio,
imagens, impressão e JavaBeans"). Compare com [../desktop](../desktop/), em
que o Maven precisa baixar o JavaFX.

## Início rápido
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into target/hello-swing.jar
./run.sh       # open the window (close it to end the program)
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Executa `javac -version` e verifica se a versão é 21 ou superior. 2. Verifica se o `mvn` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação e só o executa se você responder `y`. | A mesma toolchain de [../cli](../cli/README.md#scripts-explained). O Swing não precisa de instalação separada. |
| `build.sh` | Executa `mvn --batch-mode --quiet package`. Isso compila o `HelloSwing.java` em `target/hello-swing.jar`. | A JVM executa bytecode, de modo que o código precisa ser compilado antes. Não há `target/lib/`, porque não há bibliotecas para copiar. O primeiro build baixa os plugins do Maven do Maven Central para `~/.m2/repository`; os builds seguintes os reutilizam. |
| `run.sh` | Executa `java -jar target/hello-swing.jar`. Com `--verify`, define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que a janela é exibida e fecha após cerca de 2 s. | O `java -jar` inicia a classe indicada no manifesto do arquivo JAR (`Main-Class`, definida no `pom.xml`). Não é necessário `--module-path`, porque o Swing está no JDK. A autoverificação permite que o `scripts/verify-all.sh` teste a janela sem esperar pelo leitor. |

## Estrutura de pastas
```text
desktop-swing/
├── README.md          this file
├── install.sh         checks / installs the JDK and Maven
├── build.sh           compiles target/hello-swing.jar
├── run.sh             opens the window
├── screenshot.png     the window, for "Expected output" below
├── pom.xml            Maven project: Java 21, no dependencies, Main-Class
├── src/main/java/com/example/hello/
│   └── HelloSwing.java  the program
└── target/            created by build.sh; not committed
    └── hello-swing.jar
```
- A Standard Directory Layout do Maven, como em [../cli](../cli/README.md#folder-structure) [15].
- A pasta se chama `desktop-swing`, seguindo a nomenclatura
  `<categoria>-<variante>` deste repositório (como [../web-react](../web-react/)).
  A pasta `desktop` simples contém a versão JavaFX.
- O `pom.xml` é o `pom.xml` de [../cli](../cli/) com outro nome e outra
  classe principal. A seção `<dependencies>` não existe porque o programa
  não precisa de nenhuma biblioteca fora do JDK.

## Passo a passo
Abra o [`HelloSwing.java`](src/main/java/com/example/hello/HelloSwing.java)
ao lado desta lista.

1. **`import javax.swing...;`** traz as classes do Swing. Os nomes das
   classes do Swing começam com `J` (`JFrame`, `JLabel`). O toolkit AWT, mais
   antigo e sobre o qual o Swing é construído, tem `Frame` e `Label`. O
   pacote `javax.swing` "Provides a set of 'lightweight' (all-Java language)
   components that, to the maximum degree possible, work the same on all
   platforms" [3] (tradução livre: "Fornece um conjunto de componentes
   'leves' (inteiramente em linguagem Java) que, no maior grau possível,
   funcionam da mesma forma em todas as plataformas").
2. **`public class HelloSwing`** não estende nada. No JavaFX, o programa
   *é* uma subclasse de `Application`
   ([../desktop](../desktop/README.md#step-by-step-walkthrough)). O Swing é
   uma biblioteca simples: o `main` cria os objetos por conta própria.
3. **O `main` chama `SwingUtilities.invokeLater(...)` e não constrói a
   janela por conta própria.** Esta é a regra mais importante do Swing:
   - O tutorial da Oracle lista três tipos de threads em um programa Swing:
     as *initial threads* "that execute initial application code" (tradução
     livre: "que executam o código inicial da aplicação"), a *event
     dispatch thread* (EDT) "where all event-handling code is executed"
     (tradução livre: "em que todo o código de tratamento de eventos é
     executado") e as *worker threads* para "time-consuming background
     tasks" (tradução livre: "tarefas demoradas em segundo plano") [16].
   - Ele pergunta "Why does not the initial thread simply create the GUI
     itself? Because almost all code that creates or interacts with Swing
     components must run on the event dispatch thread" [1] (tradução livre:
     "Por que a initial thread não cria simplesmente a GUI por conta
     própria? Porque quase todo código que cria componentes Swing ou
     interage com eles deve executar na event dispatch thread").
   - O motivo é que "most Swing object methods are not 'thread safe':
     invoking them from multiple threads risks thread interference or
     memory consistency errors" [2] (tradução livre: "a maioria dos métodos
     dos objetos Swing não é 'thread safe': invocá-los a partir de várias
     threads arrisca interferência entre threads ou erros de consistência
     de memória"). "Programs that ignore this rule may function correctly
     most of the time, but are subject to unpredictable errors that are
     difficult to reproduce" [2] (tradução livre: "Programas que ignoram
     esta regra podem funcionar corretamente na maior parte do tempo, mas
     estão sujeitos a erros imprevisíveis e difíceis de reproduzir"). A API
     do Java 21 afirma o mesmo: "In general Swing is not thread safe" e "The
     preferred way to transfer control and begin working with Swing is to
     use `invokeLater`" [3] (tradução livre: "Em geral, o Swing não é thread
     safe" e "A maneira preferida de transferir o controle e começar a
     trabalhar com o Swing é usar `invokeLater`").
   - O `invokeLater` "Causes doRun.run() to be executed asynchronously on
     the AWT event dispatching thread" [4] (tradução livre: "Faz com que
     doRun.run() seja executado de forma assíncrona na AWT event dispatching
     thread"). O tutorial o compara com o `invokeAndWait`: "`invokeLater`
     simply schedules the task and returns; `invokeAndWait` waits for the
     task to finish before returning" [1] (tradução livre: "o `invokeLater`
     apenas agenda a tarefa e retorna; o `invokeAndWait` espera a tarefa
     terminar antes de retornar").
   - `HelloSwing::createAndShowWindow` é uma **referência a método** (Java 8
     e posteriores). Ela passa o método como a tarefa a executar.
   - Observação: os Java Tutorials trazem o aviso "The Java Tutorials have
     been written for JDK 8" [1] (tradução livre: "Os Java Tutorials foram
     escritos para o JDK 8"). A regra de threads não mudou. A documentação
     da API do Java 21 citada acima também a enuncia [3].
4. **`createAndShowWindow()` executa na EDT.** `new JFrame("Hello,
   World!")` cria uma janela com esse título. Fechar um JFrame, por padrão,
   apenas o oculta: "The default behavior is to simply hide the JFrame when
   the user closes the window" [6] (tradução livre: "O comportamento padrão
   é simplesmente ocultar o JFrame quando o usuário fecha a janela"). O
   `setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)` faz o botão de fechar
   encerrar o programa.
5. **`new JLabel("Hello, World!", SwingConstants.CENTER)`** é o texto,
   centralizado. Uma borda vazia de 40 pixels faz o papel do
   `setPadding(new Insets(40))` do JavaFX. O `frame.pack()` "Causes this
   Window to be sized to fit the preferred size and layouts of its
   subcomponents" [7] (tradução livre: "Faz com que esta Window seja
   dimensionada para se ajustar ao tamanho preferido e aos layouts de seus
   subcomponentes"), o `setLocationRelativeTo(null)` centraliza a janela na
   tela e o `setVisible(true)` a exibe.
6. **A autoverificação.** Com `TF_VERIFY=1`, a aplicação verifica
   `frame.isShowing()`, imprime o texto do rótulo e inicia um
   `javax.swing.Timer`. Um `Timer` "Fires one or more `ActionEvent`s at
   specified intervals" (tradução livre: "Dispara um ou mais `ActionEvent`s
   em intervalos especificados"), e seus "action event handlers ... execute
   on ... the event-dispatching thread" (tradução livre: "tratadores de
   eventos de ação ... executam na ... event-dispatching thread"), de modo
   que "can safely perform operations on Swing components" [5] (tradução
   livre: "podem executar com segurança operações em componentes Swing").
   O `setRepeats(false)` faz com que ele dispare uma única vez [5]. O
   tratador envia um evento `WINDOW_CLOSING`, o mesmo evento de um clique no
   botão de fechar, de modo que o `EXIT_ON_CLOSE` encerra o programa.
   `event -> ...` é uma **lambda** (Java 8 e posteriores).
7. **Sem laço explícito.** O `main` retorna imediatamente, mas o programa
   continua em execução: a EDT espera por eventos até que a janela seja
   fechada. O JavaFX ([../desktop](../desktop/)), o `mainloop()` do tkinter
   do Python e o laço de requisições de um servidor web funcionam da mesma
   forma.

## Swing ou JavaFX?
### Histórico
| Ano | Evento | Fonte |
|---|---|---|
| 1995 | O AWT, o primeiro toolkit de GUI do Java, é distribuído com o Java SE em seu lançamento | [9] |
| 1998 | O Swing, inicialmente "a separate library" (uma biblioteca separada), passa a fazer parte do "J2SE 1.2" | [9] |
| 2005 | Começa o desenvolvimento do JavaFX | [9] |
| 2011 | A Oracle abre o código do JavaFX por meio do projeto OpenJFX no OpenJDK | [9] |
| 2018 | O JDK 11 (GA em 2018-09-25) remove o JavaFX: "JavaFX is no longer included in the JDK. It is now available as a separate download from openjfx.io" (o JavaFX não está mais incluído no JDK; agora está disponível como download separado em openjfx.io) | [10][17] |
| 2020 | O Java Client Roadmap da Oracle: "Swing and AWT remain core Java SE technologies to Oracle across all Java SE releases and support timelines" (Swing e AWT continuam sendo tecnologias centrais do Java SE para a Oracle em todas as versões e prazos de suporte do Java SE) | [9] |
| 2026 | Oracle: "JDK 8 includes JavaFX until March 2028, for newer JDK releases, Oracle offers JavaFX as separate library" (o JDK 8 inclui o JavaFX até março de 2028; para versões mais novas do JDK, a Oracle oferece o JavaFX como biblioteca separada) | [11] |

O roadmap da Oracle afirma, sobre o AWT: "AWT has been an integral part of
Java SE since its launch in 1995. Swing was introduced shortly thereafter
as a separate library and finally incorporated into 'J2SE 1.2' in 1998.
Both toolkits are part of the Java SE Specification" [9] (tradução livre:
"O AWT é parte integrante do Java SE desde seu lançamento, em 1995. O Swing
foi introduzido pouco depois como biblioteca separada e finalmente
incorporado ao 'J2SE 1.2' em 1998. Ambos os toolkits fazem parte da
Especificação do Java SE"). Também afirma "Oracle will continue developing
Swing and AWT across all supported releases as a core Java SE technology"
[9] (tradução livre: "A Oracle continuará a desenvolver o Swing e o AWT em
todas as versões suportadas, como tecnologia central do Java SE"). Do lado
do JavaFX, "Oracle completed the re-architecture and transition of JavaFX
to OpenJFX as a stand-alone module as of Java SE 11" [9] (tradução livre:
"A Oracle concluiu a rearquitetura e a transição do JavaFX para o OpenJFX
como módulo independente a partir do Java SE 11"). As notas de versão do
JDK 11 acrescentam que os módulos do JavaFX "were included in earlier
releases of the Oracle JDK, but not in the OpenJDK releases" [10] (tradução
livre: "estavam incluídos em versões anteriores do Oracle JDK, mas não nas
versões do OpenJDK").

(O roadmap foi publicado pela primeira vez em maio de 2020, como mostra sua
URL. A cópia lida em 2026-11-02 é a "Version 1.01" e se identifica como
"out of date and remains for historical tracking purposes only" [9]
(tradução livre: "desatualizada e mantida apenas para fins de registro
histórico"). Os fatos citados aqui são históricos, de modo que continuam
válidos.)

### Empacotamento e execução
| | Swing (esta pasta) | JavaFX ([../desktop](../desktop/)) |
|---|---|---|
| De onde vem o toolkit | do JDK (módulo `java.desktop`) [8] | do Maven Central (OpenJFX), desde o JDK 11 [10] |
| Dependências do `pom.xml` | nenhuma | `org.openjfx:javafx-controls` |
| Saída do build | `target/hello-swing.jar` (cerca de 4 KB) | `target/hello-desktop.jar` + `target/lib/` (arquivos JAR do JavaFX) |
| Código nativo | no JDK | nos arquivos JAR do JavaFX, uma variante por sistema operacional e CPU (ver [../desktop](../desktop/README.md#folder-structure)) |
| Comando de execução | `java -jar target/hello-swing.jar` | `java --module-path target/lib --add-modules javafx.controls -cp ... HelloApp` |
| Forma do programa | o `main` chama `invokeLater`, e o código constrói a janela | subclasse de `Application`; o JavaFX chama `start(Stage)` |
| Thread da GUI | event dispatch thread (EDT) [2] | JavaFX Application Thread |

O tamanho do arquivo JAR foi medido com `ls -l` na máquina de verificação
(2026-11-02). Para distribuir qualquer um dos programas aos usuários sem uma
instalação separada do Java, a ferramenta `jpackage` do JDK (JEP 392,
definitiva no JDK 16) pode empacotar "self-contained Java applications" [13]
(tradução livre: "aplicações Java autocontidas"). O roadmap da Oracle indica
aos desenvolvedores desktop "jlink, jpackage and/or third party packaging
and deployment solutions" [9] (tradução livre: "jlink, jpackage e/ou
soluções de empacotamento e implantação de terceiros").

### Quando escolher cada um
Esta é uma orientação extraída dos fatos acima, e não uma regra da Oracle:

- **Swing** quando se deseja zero dependências ou se mantém uma aplicação
  Swing existente. Ele faz parte da especificação do Java SE, e a Oracle
  afirma que continuará a desenvolvê-lo [9]. Qualquer JDK completo pode
  compilá-lo e executá-lo, em todo sistema operacional que o JDK suporta.
  Seu material de tutorial, porém, é antigo: a trilha do Swing foi "written
  for JDK 8" [1] (tradução livre: "escrita para o JDK 8").
- **JavaFX** para novas aplicações que desejam um toolkit mais moderno. O
  OpenJFX descreve o JavaFX como "an open source, next generation client
  application platform for desktop, mobile and embedded systems built on
  Java" [12] (tradução livre: "uma plataforma de aplicações cliente de
  código aberto e de próxima geração para sistemas desktop, móveis e
  embarcados, construída sobre Java"). O custo é uma dependência extra, e a
  versão do JavaFX precisa corresponder ao JDK do leitor (ver
  [../desktop](../desktop/README.md#why-this-toolchain)).
- **Ambos:** o `JFXPanel` do JavaFX "is a component to embed JavaFX content
  into Swing applications" [14] (tradução livre: "é um componente para
  incorporar conteúdo JavaFX em aplicações Swing"), de modo que uma
  aplicação Swing pode migrar para o JavaFX uma tela de cada vez.

## Por que esta toolchain
- **Um segundo toolkit para comparação.** A principal versão desktop em
  Java usa o JavaFX ([../desktop](../desktop/)). Esta versão em Swing existe
  para que os dois toolkits possam ser comparados.
- **Java 21 e Maven**, como toda pasta Java deste repositório. O próprio
  Swing não exige escolha de versão: é o que está no JDK do leitor.
- **Sem construtor de GUI e sem biblioteca extra de layout.** Um único
  `JLabel` em um `JFrame` é a menor janela Swing completa.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-02) | Temurin 21.0.8, Maven 3.9.16. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. Use um JDK arm64 (o cask `temurin@21` instala um no Apple Silicon). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` e `maven` com o apt quando faltam. Uma janela exige uma sessão gráfica. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK nem o Maven: se um dos dois não existe, imprime o comando `winget` do Temurin 21 ou os passos do zip do Maven e para. |

## Saída esperada
O `./run.sh` abre uma pequena janela intitulada "Hello, World!" com o texto
"Hello, World!" no centro:

![A janela do Swing intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-02 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela. Na máquina de verificação, ela é quase
idêntica à [janela do JavaFX](../desktop/README.md#expected-output).)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: Swing (part of the JDK) draws the window; 'java -jar' starts it.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. Initial Threads (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html> (acessado em 2026-11-02)
2. The Event Dispatch Thread (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html> (acessado em 2026-11-02)
3. Package javax.swing (Java SE 21 API), including "Swing's Threading Policy". Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/package-summary.html> (acessado em 2026-11-02)
4. SwingUtilities.invokeLater (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/SwingUtilities.html#invokeLater(java.lang.Runnable)> (acessado em 2026-11-02)
5. Timer (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/Timer.html> (acessado em 2026-11-02)
6. JFrame (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html> (acessado em 2026-11-02)
7. Window.pack() (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/Window.html#pack()> (acessado em 2026-11-02)
8. Module java.desktop (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/module-summary.html> (acessado em 2026-11-02)
9. Java Client Roadmap Update (first published May 2020; copy read is Version 1.01). Oracle. <https://www.oracle.com/technetwork/java/javase/javaclientroadmapupdatev2020may-6548840.pdf> (acessado em 2026-11-02)
10. JDK 11 Release Notes ("JavaFX is no longer included in the JDK"; "Removal of JavaFX from the Oracle JDK"). Oracle. <https://www.oracle.com/java/technologies/javase/11-relnote-issues.html> (acessado em 2026-11-02)
11. JavaFX. Oracle. <https://www.oracle.com/java/technologies/javase/javafx-overview.html> (acessado em 2026-11-02)
12. JavaFX (OpenJFX home page). Gluon / OpenJFX. <https://openjfx.io/> (acessado em 2026-11-02)
13. JEP 392: Packaging Tool. OpenJDK. <https://openjdk.org/jeps/392> (acessado em 2026-11-02)
14. JFXPanel (JavaFX 21 API). OpenJFX. <https://openjfx.io/javadoc/21/javafx.swing/javafx/embed/swing/JFXPanel.html> (acessado em 2026-11-02)
15. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (acessado em 2026-11-02)
16. Lesson: Concurrency in Swing (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/index.html> (acessado em 2026-11-02)
17. JDK 11. OpenJDK. <https://openjdk.org/projects/jdk/11/> (acessado em 2026-11-02)
