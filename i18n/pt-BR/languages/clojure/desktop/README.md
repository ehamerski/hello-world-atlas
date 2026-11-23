---
source: languages/clojure/desktop/README.md
source_sha: 5ad09565c51a9e4ac90a4ce9bc28c9e257f83baf
---
# Clojure · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Clojure](../README.md) ·
> O mesmo programa em Java: [java/desktop-swing](../../java/desktop-swing/)

## O que é
Um programa desktop que abre uma janela nativa intitulada "Hello, World!"
com o texto **Hello, World!** no centro. A janela é desenhada pelo **Swing**,
o toolkit de GUI que acompanha o JDK. O Clojure não tem um toolkit de GUI
próprio: o programa chama o Swing por meio de **interoperabilidade com o Java**
(Java interop). Ele continua em execução até que o leitor feche a janela.

É o mesmo programa de [java/desktop-swing](../../java/desktop-swing/),
escrito em Clojure. Colocar os dois lado a lado mostra como é a
interoperabilidade com o Java.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Java runtime 21 ou superior | Eclipse Temurin 21.0.8 | executa o bytecode. **O Swing está dentro do JDK.** |
| Clojure CLI | 1.12.6.1673 (Clojure 1.12.6) | inicia a JVM e carrega o programa; veja [../cli](../cli/README.md#prerequisites) |

Nada mais é necessário. O módulo `java.desktop` do JDK "Defines the AWT and
Swing user interface toolkits, plus APIs for accessibility, audio, imaging,
printing, and JavaBeans" [1] (tradução livre: "Define os toolkits de interface
de usuário AWT e Swing, além de APIs para acessibilidade, áudio, imagens,
impressão e JavaBeans"). O `deps.edn` não tem nenhuma dependência.

## Início rápido
```sh
./install.sh   # check / install Java and the Clojure CLI (asks before installing)
./run.sh       # open the window (close it to end the program)
```
Não há `build.sh`: o Clojure compila o código-fonte quando o carrega. O motivo
está em [../cli](../cli/README.md#why-there-is-no-buildsh).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Os mesmos três passos de [../cli](../cli/README.md#scripts-explained): verifica o Java, verifica ou instala o Clojure CLI e executa `clojure -P`. | O Swing não precisa de instalação separada. |
| `run.sh` | Executa `clojure -M -m hello.core`. Com `--verify`, define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que a janela é exibida e a fecha após cerca de 2 s. | A autoverificação permite que o `scripts/verify-all.sh` teste a janela sem esperar pelo leitor. |
| `clojure-env.sh` | Define a versão do CLI, o checksum do instalador e `CLOJURE_DIR`. | O mesmo arquivo de [../cli](../cli/). |

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs Java and the Clojure CLI
├── run.sh           opens the window
├── clojure-env.sh   toolchain settings, sourced by the scripts
├── deps.edn         project file: source folder, no dependency
├── screenshot.png   the window, for "Expected output" below
├── .gitignore       ignores .cpcache/ (the CLI's classpath cache)
└── src/
    └── hello/
        └── core.clj   the program: namespace hello.core
```
O layout é o mesmo de [../cli](../cli/README.md#folder-structure) [2].

## Passo a passo
Abra o [`core.clj`](src/hello/core.clj) ao lado desta lista.

1. **`(:import ...)` no `ns`** é a versão Clojure do `import` do Java. Ele
   permite escrever `JFrame` no código em vez de `javax.swing.JFrame`. Os
   nomes das classes do Swing começam com `J` (`JFrame`, `JLabel`); o toolkit
   AWT, mais antigo, sobre o qual o Swing se apoia, tem `Frame` e `Label`. O
   pacote `javax.swing` "Provides a set of 'lightweight' (all-Java language)
   components that, to the maximum degree possible, work the same on all
   platforms" [3] (tradução livre: "Fornece um conjunto de componentes
   'leves' (inteiramente em linguagem Java) que, na maior medida possível,
   funcionam do mesmo modo em todas as plataformas").
2. **O `-main` chama `SwingUtilities/invokeLater` e não constrói a janela por
   conta própria.** Esta é a regra mais importante do Swing:
   - O tutorial da Oracle pergunta "Why does not the initial thread simply
     create the GUI itself? Because almost all code that creates or interacts
     with Swing components must run on the event dispatch thread" (EDT) [4]
     (tradução livre: "Por que a thread inicial não cria simplesmente a GUI?
     Porque quase todo código que cria componentes do Swing ou interage com
     eles precisa executar na event dispatch thread").
   - O motivo é que "most Swing object methods are not 'thread safe':
     invoking them from multiple threads risks thread interference or memory
     consistency errors" [5] (tradução livre: "a maioria dos métodos dos
     objetos do Swing não é 'thread safe': invocá-los a partir de várias
     threads gera risco de interferência entre threads ou de erros de
     consistência de memória").
   - O `invokeLater` "Causes doRun.run() to be executed asynchronously on the
     AWT event dispatching thread" [6] (tradução livre: "Faz com que
     doRun.run() seja executado de forma assíncrona na event dispatching
     thread do AWT").
   - O método espera um `java.lang.Runnable`. A interface de função do
     Clojure, `clojure.lang.IFn`, estende `Runnable` [7], de modo que a função
     `create-and-show-window` é passada como está. O Java precisa de um lambda
     ou de uma referência de método (veja
     [java/desktop-swing](../../java/desktop-swing/README.md#step-by-step-walkthrough)).
   - Os Java Tutorials trazem o aviso "The Java Tutorials have been written
     for JDK 8" [4] (tradução livre: "Os Java Tutorials foram escritos para o
     JDK 8"). A documentação da API do Java 21 enuncia a mesma regra [3].
3. **Sintaxe de interop.** O Clojure alcança as classes Java com algumas
   formas [8]:

   | Java | Clojure | Significado |
   |---|---|---|
   | `new JFrame("...")` | `(JFrame. "...")` | um ponto no final chama o construtor |
   | `frame.pack()` | `(.pack frame)` | um ponto no início chama um método de instância; o objeto vem primeiro |
   | `SwingConstants.CENTER` | `SwingConstants/CENTER` | `Classe/NOME` lê um campo estático |
   | `System.getenv("X")` | `(System/getenv "X")` | `Classe/nome` chama um método estático |

   A chamada continua sendo uma lista que começa com o operador, como em todo
   Lisp; assim, o código Java tem outra aparência em Clojure, mas o mesmo
   significado.
4. **`let`** associa `frame` e `label` ao código dentro dele. Os nomes nunca
   mudam depois: os valores do Clojure são imutáveis por padrão. Os próprios
   objetos do Swing são objetos Java mutáveis, e é por isso que o código chama
   `setBorder`, `add` e `setVisible` sobre eles.
5. **`(.setDefaultCloseOperation frame JFrame/EXIT_ON_CLOSE)`.** Por padrão,
   fechar um JFrame apenas o oculta: "The default behavior is to simply hide
   the JFrame when the user closes the window" [9] (tradução livre: "O
   comportamento padrão é simplesmente ocultar o JFrame quando o usuário fecha
   a janela"). O `EXIT_ON_CLOSE` encerra o programa.
6. **O rótulo e a janela.** `(JLabel. "Hello, World!" SwingConstants/CENTER)`
   é o texto, centralizado. Uma borda vazia de 40 pixels evita que a janela
   fique minúscula. O `.pack` "Causes this Window to be sized to fit the
   preferred size and layouts of its subcomponents" [10] (tradução livre:
   "Faz com que esta Window seja dimensionada para se ajustar ao tamanho
   preferido e aos layouts de seus subcomponentes"),
   `(.setLocationRelativeTo frame nil)` centraliza a janela na tela (`nil` é o
   nulo do Clojure) e o `.setVisible` a exibe.
7. **A autoverificação.** Com `TF_VERIFY=1`, a aplicação verifica
   `.isShowing`, imprime o texto do rótulo e inicia um `javax.swing.Timer`.
   Um `Timer` "Fires one or more `ActionEvent`s at specified intervals"
   (tradução livre: "Dispara um ou mais `ActionEvent`s em intervalos
   especificados"), e seus "action event handlers ... execute on ... the
   event-dispatching thread" (tradução livre: "tratadores de eventos de ação
   ... executam na ... event-dispatching thread"), de modo que "can safely
   perform operations on Swing components" [11] (tradução livre: "podem
   executar com segurança operações em componentes do Swing").
   - O `Timer` quer um `ActionListener`, uma interface Java. "reify defines
     both an anonymous type and creates an instance of that type", para "a
     one-off implementation of one or more protocols or interfaces" [12]
     (tradução livre: "reify define um tipo anônimo e cria uma instância
     desse tipo", para "uma implementação avulsa de um ou mais protocolos ou
     interfaces"). Aqui ele faz o papel do lambda do Java.
   - O `doto` chama vários métodos sobre o mesmo objeto e o retorna [8], de
     modo que `(.setRepeats false)` e `(.start)` se aplicam ao timer.
   - A ação envia um evento `WINDOW_CLOSING`, o mesmo evento de um clique no
     botão de fechar, de modo que o `EXIT_ON_CLOSE` encerra o programa.
8. **Sem laço explícito.** O `-main` retorna de imediato, mas o programa
   continua em execução: a EDT espera eventos até que a janela seja fechada.
   O `mainloop()` do tkinter do Python e o laço de requisições de um servidor
   web funcionam do mesmo modo.

## Por que esta toolchain
- **O Swing por meio de interop mostra o sentido de uma linguagem hospedada.**
  O autor escreveu que os programas Clojure "are Java libraries and bytecode
  when on the JVM" e que ser hospedada significa haver "no overhead,
  conversion, friction, wrapping, declarations et al going to and from the
  larger ecosystem" [13] (tradução livre: "são bibliotecas Java e bytecode
  quando na JVM" e "nenhuma sobrecarga, conversão, atrito, encapsulamento,
  declarações etc. na ida e na volta com o ecossistema maior"). Uma janela não
  precisa de nenhuma biblioteca Clojure.
- **Swing, e não JavaFX.** O Swing faz parte de todo JDK [1], de modo que o
  projeto não tem dependência. O JavaFX precisaria de artefatos do Maven e de
  código nativo específico da plataforma, como em
  [java/desktop](../../java/desktop/). Existem wrappers Clojure para o Swing e
  o JavaFX, mas esta pasta não usa nenhum, de modo que o código permanece
  igual ao da versão Java.
- **O Clojure CLI**, como em [../cli](../cli/README.md#why-this-toolchain).

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Temurin 21.0.8, Clojure CLI 1.12.6.1673 (Clojure 1.12.6). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. Use um Java runtime arm64. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` faz o mesmo que em [../cli](../cli/README.md#platform-notes). A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` faz o mesmo que em [../cli](../cli/README.md#platform-notes). O Swing faz parte do JDK, portanto nada mais é instalado. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` abre uma pequena janela intitulada "Hello, World!" com o texto
"Hello, World!" no centro:

![A janela do Swing intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela. O id da janela foi consultado a partir do
processo do programa. A janela não estava em foco, por isso a barra de título
é cinza.)

O `./run.sh --verify` imprimiu, em 2026-11-04:
```text
==> Open the Hello World window
    WHY: Swing (part of the JDK) draws the window; 'clojure -M -m hello.core' starts it.
    Self-check: the app prints the label text and closes after ~2 seconds.
Hello, World!
```

## Fontes
1. Module java.desktop (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/module-summary.html> (acessado em 2026-11-04)
2. Deps and CLI Reference. clojure.org. <https://clojure.org/reference/deps_and_cli> (acessado em 2026-11-04)
3. Package javax.swing (Java SE 21 API), including "Swing's Threading Policy". Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/package-summary.html> (acessado em 2026-11-04)
4. Initial Threads (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html> (acessado em 2026-11-04)
5. The Event Dispatch Thread (The Java Tutorials, Concurrency in Swing). Oracle. <https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html> (acessado em 2026-11-04)
6. SwingUtilities.invokeLater (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/SwingUtilities.html#invokeLater(java.lang.Runnable)> (acessado em 2026-11-04)
7. IFn.java, `public interface IFn extends Callable, Runnable` (tag clojure-1.12.6). Clojure core team, GitHub. <https://github.com/clojure/clojure/blob/clojure-1.12.6/src/jvm/clojure/lang/IFn.java> (acessado em 2026-11-04)
8. Java Interop. clojure.org. <https://clojure.org/reference/java_interop> (acessado em 2026-11-04)
9. JFrame (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/JFrame.html> (acessado em 2026-11-04)
10. Window.pack() (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/java/awt/Window.html#pack()> (acessado em 2026-11-04)
11. Timer (Java SE 21 API). Oracle. <https://docs.oracle.com/en/java/javase/21/docs/api/java.desktop/javax/swing/Timer.html> (acessado em 2026-11-04)
12. Datatypes: deftype, defrecord, and reify. clojure.org. <https://clojure.org/reference/datatypes> (acessado em 2026-11-04)
13. A History of Clojure, section 3.5 "Clojure and the Host". Rich Hickey, Proc. ACM Program. Lang. 4, HOPL, 2020. <https://web.archive.org/web/2023/https://download.clojure.org/papers/clojure-hopl-iv-final.pdf> (acessado em 2026-11-04)
