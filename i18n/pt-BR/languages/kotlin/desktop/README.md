---
source: languages/kotlin/desktop/README.md
source_sha: dd4148f1eee821f2964ddd7965e84e13c79e68dd
---
# Kotlin · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Kotlin](../README.md)

## O que é
Um programa desktop que abre uma janela nativa intitulada **Hello, World!**
com o texto **Hello, World!** dentro. Ele usa o **Compose Multiplatform**,
"an open-source, declarative UI framework developed by JetBrains for
building shared UIs across Android, iOS, desktop, and web with Kotlin" [1]
(tradução livre: "um framework de interface declarativo e de código aberto,
desenvolvido pela JetBrains para criar interfaces compartilhadas entre
Android, iOS, desktop e web com Kotlin"). O Gradle o compila e o executa.
Para a mesma tarefa com toolkits de Java, veja o
[JavaFX](../../java/desktop/) e o [Swing](../../java/desktop-swing/).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o Gradle e o programa rodam na JVM |
| Gradle | 9.8.0 | a ferramenta de build: lê o `build.gradle.kts`, baixa as dependências, compila e inicia o programa |
| Plugin do Kotlin para o Gradle | 2.4.21 (fixada em `build.gradle.kts`) | compila o código Kotlin; **não é instalado manualmente**: o Gradle o baixa durante o `./build.sh` |
| Compose Multiplatform | 1.12.2 (fixada em `build.gradle.kts`) | as bibliotecas de interface e a tarefa `run`; baixado pelo Gradle |
| Plugin do compilador Kotlin Compose | 2.4.21 (fixada) | reescreve as funções `@Composable`; baixado pelo Gradle |

O Gradle "requires Java Development Kit (JDK) version 17 or higher to run"
[3] (tradução livre: "exige o Java Development Kit (JDK) versão 17 ou
superior para executar"). O plugin do Kotlin para o Gradle 2.4.21 oferece
suporte completo ao Gradle 7.6.3 até o 9.7.0, e a mesma página diz que
versões mais novas do Gradle funcionam, mas "you might encounter
deprecation warnings" [4] (tradução livre: "você pode encontrar avisos de
descontinuação"). O Gradle 9.8.0 é mais novo que o 9.7.0, e o build imprime
um desses avisos (sobre o Gradle 10). Mesmo assim, ele compila e executa.

## Início rápido
```sh
./install.sh   # check / install the JDK and Gradle (asks before installing)
./build.sh     # download the dependencies and compile (a few minutes the first time)
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se o `java` é a versão 21 ou superior. 2. Verifica se o `gradle` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação (no macOS, `brew install gradle` [3]) e só o executa se você responder `y`. | O mesmo JDK de [../cli](../cli/README.md#scripts-explained). Este repositório não inclui o Gradle wrapper (um jar mais scripts que baixam o Gradle [3]); por isso o Gradle é instalado uma vez. |
| `build.sh` | Executa `gradle --no-daemon --console=plain classes`. | A tarefa `classes` baixa os plugins e as bibliotecas e, em seguida, compila o `Main.kt`. O `--no-daemon` encerra o processo em segundo plano do Gradle ao fim do build. |
| `run.sh` | Executa `gradle --no-daemon --quiet --console=plain run`. `--verify` define antes `TF_VERIFY=1`. | O plugin do Compose para o Gradle fornece a tarefa `run`, que inicia a classe principal [5]. Com `TF_VERIFY=1`, o programa imprime `Hello, World!` assim que sua janela é exibida e se fecha sozinha após cerca de 2 segundos, de modo que o `scripts/verify-all.sh` não espera por você. |

## Estrutura de pastas
```text
desktop/
├── README.md                    this file
├── install.sh                   checks / installs the JDK and Gradle
├── build.sh                     compiles with Gradle
├── run.sh                       runs the program (gradle run)
├── screenshot.png               the window, for "Expected output" below
├── settings.gradle.kts          project name and where Gradle finds plugins and libraries
├── build.gradle.kts             plugins, dependencies and the main class
├── .gitignore                   keeps build/, .gradle/ and .kotlin/ out of the repository
├── src/main/kotlin/
│   └── Main.kt                  the whole program
├── build/                       created by Gradle; not committed
├── .gradle/                     created by Gradle; not committed
└── .kotlin/                     created by the Kotlin plugin; not committed
```
- O `build.gradle.kts` é um script de build escrito em Kotlin (`.kts`). A
  documentação do Kotlin diz: "To target the JVM, apply the Kotlin JVM
  plugin" [4] (tradução livre: "Para ter a JVM como alvo, aplique o plugin
  Kotlin JVM"). O `implementation(compose.desktop.currentOs)` adiciona as
  bibliotecas do Compose para o sistema operacional que executa o build, e o
  `mainClass = "MainKt"` nomeia a classe que o Kotlin gera para o `Main.kt`
  [5].

## Passo a passo
Abra o [`Main.kt`](src/main/kotlin/Main.kt) ao lado desta lista.

1. **Os imports** nomeiam funções do Compose, como `Window` e `Text`. O
   Kotlin importa funções diretamente porque elas podem existir fora de
   classes; o Java importa apenas classes.
2. **`fun main() = application { ... }`** é o ponto de entrada, de novo uma
   função de nível superior sem classe ([passo a passo do cli](../cli/README.md#step-by-step-walkthrough)).
   O `=` significa que o corpo da função é uma única expressão. O
   `application` inicia o Compose e mantém o programa em execução até que
   `exitApplication()` seja chamada. O [JavaFX](../../java/desktop/README.md)
   precisa de uma subclasse de `Application`, e o Swing precisa de uma
   chamada a `invokeLater`.
3. **`val verify = System.getenv("TF_VERIFY") == "1"`** lê a variável de
   ambiente. O `val` declara uma variável que não pode receber outra
   atribuição, o tipo é inferido, e o `==` compara textos pelo conteúdo (o
   Java usa `equals`). Um programa Kotlin chama diretamente métodos de
   bibliotecas Java, como `System.getenv`, porque o Kotlin é "100%
   interoperable with the Java programming language" [2] (tradução livre:
   "100% interoperável com a linguagem de programação Java").
4. **`Window(onCloseRequest = ::exitApplication, title = "Hello, World!") { ... }`**
   abre uma janela nativa. Os argumentos são nomeados, e `::exitApplication`
   é uma referência a uma função. O bloco entre chaves, uma lambda final
   (*trailing lambda*), é o conteúdo da janela.
5. **`Text("Hello, World!")`** é uma *função composable*: ela descreve uma
   parte da tela em vez de criar um objeto de rótulo e alterá-lo depois.
   Este é o estilo declarativo em que o Compose Multiplatform se baseia [1].
6. **`LaunchedEffect(Unit) { ... }`**, usado apenas com `TF_VERIFY=1`,
   executa seu bloco uma vez, depois que a janela é composta. Ele roda em
   uma corrotina, de modo que `delay(2000)` pausa por dois segundos sem
   congelar a janela. Em seguida, o programa chama `exitApplication()`.

## Por que esta toolchain
- **O Compose Multiplatform é o framework de interface da JetBrains para o
  Kotlin.** No desktop, ele roda em "Windows, macOS, and Linux from one
  codebase" [1] (tradução livre: "Windows, macOS e Linux a partir de uma
  única base de código").
- **Ele compartilha sua API com o Android.** "Compose Multiplatform shares
  its API with Jetpack Compose" [1] (tradução livre: "O Compose
  Multiplatform compartilha sua API com o Jetpack Compose"), o framework de
  interface do Google para Android, de modo que quem aprende um aprende o
  outro. A [visão geral da linguagem](../README.md) explica por que o
  Android é importante para o Kotlin.
- **A versão 1.12.2** é a mais nova sem marca de pré-lançamento no Gradle
  Plugin Portal em 2026-11-04. O portal também lista a 1.13.0-beta02, que
  esta pasta não usa [6].
- **O Gradle** é a ferramenta de build para a qual o plugin do Compose
  Multiplatform foi feito: sua tarefa `run` é uma tarefa do Gradle [5].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | macOS 26, Temurin 21.0.8, Gradle 9.8.0, Kotlin 2.4.21, Compose Multiplatform 1.12.2. O primeiro build baixa as dependências (37 s para o `./build.sh` na máquina de verificação). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O `compose.desktop.currentOs` escolhe sozinho as bibliotecas para Apple Silicon. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` com o apt quando nenhum Java 21 é encontrado. Ele não instala o Gradle: se ele não existe, imprime como obter uma versão atual [3] e para. A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK: se o Java 21 não existe, imprime o comando `winget` do Temurin 21 e para. Ele também não instala o Gradle: se ele não existe, imprime `winget install --id Gradle.Gradle -e` [3] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` abre uma janela intitulada "Hello, World!" com o texto no canto
superior esquerdo:

![A janela do Compose intitulada "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente aquela janela. A janela segue a configuração de
aparência do macOS; esta foi capturada no modo escuro.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: Compose Multiplatform draws the window; 'gradle run' starts it.
    Self-check: the app prints Hello, World! and closes after about 2 seconds.
Hello, World!
```
A última linha vem do programa, e o comando termina com código de saída 0.

## Fontes
1. Compose Multiplatform. JetBrains. <https://kotlinlang.org/compose-multiplatform/> (acessado em 2026-11-04)
2. Kotlin FAQ (Java interoperability). JetBrains. <https://kotlinlang.org/docs/faq.html> (acessado em 2026-11-04)
3. Installing Gradle. Gradle. <https://docs.gradle.org/current/userguide/installation.html> (acessado em 2026-11-04)
4. Configure a Gradle project (Kotlin Gradle plugin, compatibility, `kotlin("jvm")`). JetBrains. <https://kotlinlang.org/docs/gradle-configure-project.html> (acessado em 2026-11-04)
5. Compose Multiplatform desktop template (README and `build.gradle.kts`; archived 2025-07-14). JetBrains. <https://github.com/JetBrains/compose-multiplatform-desktop-template> (acessado em 2026-11-04)
6. org.jetbrains.compose Gradle plugin, version list. Gradle Plugin Portal. <https://plugins.gradle.org/m2/org/jetbrains/compose/org.jetbrains.compose.gradle.plugin/maven-metadata.xml> (acessado em 2026-11-04)
