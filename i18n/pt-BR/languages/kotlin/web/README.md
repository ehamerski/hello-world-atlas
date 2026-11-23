---
source: languages/kotlin/web/README.md
source_sha: 3cd655fbef961c5143196f9f56e1cee54e24f088
---
# Kotlin · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Kotlin](../README.md)

## O que é
Um pequeno servidor web escrito com o **Ktor**. Quando um navegador
solicita `http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador exibe como o texto **Hello, World!**.
O próprio servidor envia o HTML; não há front-end separado. O Ktor é
"built from the ground up using Kotlin and Coroutines" (tradução livre:
"construído do zero com Kotlin e corrotinas") e é oferecido "by JetBrains,
creators of IntelliJ IDEA, Kotlin, and more" [1] (tradução livre: "pela
JetBrains, criadora do IntelliJ IDEA, do Kotlin e de mais"). Para a mesma
tarefa em Java, veja o [Spring Boot](../../java/web/).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o Gradle e o servidor rodam na JVM |
| Gradle | 9.8.0 | a ferramenta de build: baixa as dependências, compila e empacota o jar |
| Plugin do Kotlin para o Gradle | 2.4.21 (fixada em `build.gradle.kts`) | compila o código Kotlin; baixado pelo Gradle |
| Ktor | 3.6.1 (fixada em `build.gradle.kts`) | o framework web; **não é instalado manualmente**: o Gradle o baixa durante o `./build.sh` |
| Netty | 4.2.17.Final (escolhido pelo Ktor) | o motor dentro do Ktor que trata as conexões de rede |
| Logback | 1.6.7 | imprime as mensagens de log do Ktor |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O Ktor 3.6.1 é a "Latest release" na página inicial do Ktor e a versão que
a documentação do Ktor mostra [1][6], e o Maven Central o lista como o
`ktor-server-core` mais recente [2]. O mesmo Kotlin 2.4.21 das outras
pastas de Kotlin o compila. O Gradle 9.8.0 é mais novo que o 9.7.0, que o
plugin do Kotlin para o Gradle 2.4.21 suporta por completo; versões mais
novas podem imprimir avisos de descontinuação [3].

## Início rápido
```sh
./install.sh   # check / install the JDK and Gradle (asks before installing)
./build.sh     # compile into the executable jar build/libs/hello-web-all.jar
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se o `java` é a versão 21 ou superior. 2. Verifica se o `gradle` está no `PATH`. Se um dos dois estiver faltando, mostra o comando de instalação (no macOS, `brew install gradle` [4]) e só o executa se você responder `y`. | Mesma toolchain de [../desktop](../desktop/README.md#scripts-explained). O Ktor não requer instalação separada. |
| `build.sh` | Executa `gradle --no-daemon --console=plain buildFatJar`. | A tarefa `buildFatJar` do plugin do Ktor para o Gradle "builds a combined JAR of a project and runtime dependencies" [5] (tradução livre: "gera um JAR combinado do projeto e das dependências de runtime"): um único jar executável com Ktor, Netty e Logback dentro. O primeiro build baixa os plugins do Gradle e as bibliotecas citadas nos arquivos de build para o cache do Gradle (`~/.gradle`); os builds seguintes os reutilizam. |
| `run.sh` | Executa `java -jar build/libs/hello-web-all.jar`. `--verify` o inicia em segundo plano, aguarda a página com `curl`, a imprime e, depois, encerra o servidor. | O fat jar inicia a JVM e chama `main`, que inicia o Ktor com o motor Netty. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem aguardar Ctrl+C. |

## Estrutura de pastas
```text
web/
├── README.md                    this file
├── install.sh                   checks / installs the JDK and Gradle
├── build.sh                     compiles and packages the executable jar
├── run.sh                       starts the server
├── screenshot.png               the page in a browser, for "Expected output" below
├── settings.gradle.kts          project name and where Gradle finds plugins and libraries
├── build.gradle.kts             plugins, dependencies, main class and jar name
├── .gitignore                   keeps build/, .gradle/ and .kotlin/ out of the repository
├── src/main/kotlin/
│   └── Main.kt                  the whole server
├── src/main/resources/
│   └── logback.xml              log level (INFO) and where messages go
├── build/                       created by Gradle; not committed
│   └── libs/hello-web-all.jar
├── .gradle/                     created by Gradle; not committed
└── .kotlin/                     created by the Kotlin plugin; not committed
```
- O `build.gradle.kts` aplica o plugin do Ktor para o Gradle e define
  `application { mainClass = "MainKt" }`, como a documentação do Ktor
  mostra para fat jars [5]. O
  `ktor { fatJar { archiveFileName.set("hello-web-all.jar") } }` fixa o nome
  do jar [5].
- As duas dependências do Ktor são `ktor-server-core` e
  `ktor-server-netty`. A documentação do Ktor lista Netty, Jetty, Tomcat e
  CIO (Coroutine-based I/O) como motores de servidor para a JVM e nomeia a
  dependência de cada um [6]. O Netty é usado aqui porque é o motor do
  primeiro exemplo na página inicial do Ktor [1].
- O `logback.xml` define o nível de log como INFO. Sem ele, o Logback
  imprime as mensagens internas de depuração do Netty.

## Passo a passo
Abra o [`Main.kt`](src/main/kotlin/Main.kt) ao lado desta lista. Ele segue o
exemplo de `embeddedServer` da documentação do Ktor [6].

1. **Imports.** Os três últimos, `respondText`, `get` e `routing`, são
   *funções de extensão*: funções que o Ktor acrescenta a classes
   existentes por fora, de modo que `call.respondText(...)` se lê como um
   método. O Java não tem esse recurso. O
   [Spring Boot](../../java/web/README.md#step-by-step-walkthrough) usa
   anotações (`@GetMapping`) para a mesma tarefa, e o Flask, na versão
   [Python web](../../python/web/app.py), usa decoradores.
2. **`val port = System.getenv("PORT")?.toInt() ?: 8080`.** O servidor usa a
   variável de ambiente `PORT` ou 8080. O `?.` chama `toInt()` apenas
   quando o lado esquerdo não é nulo, e o `?:` (o "operador Elvis") usa o
   lado direito quando o esquerdo é nulo.
3. **`embeddedServer(Netty, port = port, host = "127.0.0.1") { ... }`** cria
   um servidor dentro do programa: "`embeddedServer()` ... accepts an engine
   factory used to create an engine of a specific type" [6] (tradução
   livre: "aceita uma fábrica de motor usada para criar um motor de um tipo
   específico"). O `127.0.0.1` significa que somente este computador pode
   acessá-lo. O bloco entre chaves, uma lambda final (*trailing lambda*),
   configura a aplicação.
4. **`routing { get("/") { ... } }`** diz que as requisições `GET` para `/`
   executam o bloco interno, como no exemplo do Ktor [1].
5. **`call.respondText("<p>Hello, World!</p>", ContentType.Text.Html)`**
   envia o texto como resposta. O tipo de conteúdo `text/html` faz o
   navegador interpretar a tag `<p>`. O Ktor acrescenta `charset=UTF-8`
   sozinho (veja a saída do `curl` abaixo). O `respondText` é uma função
   suspend: ela pode pausar sua corrotina enquanto os dados são enviados, e
   a thread atende outras requisições nesse intervalo.
6. **`.start(wait = true)`** abre a porta e mantém o `main` aguardando, de
   modo que o servidor continua em execução até que você o encerre. Sem
   `wait`, o `main` retornaria. A versão [cli](../cli/) executava `main` e
   terminava.

## Por que esta toolchain
- **O Ktor é o framework da JetBrains**, a empresa que desenvolve o Kotlin
  [1][7]. Ele é "built from the ground up using Kotlin and Coroutines" [1],
  de modo que o código desta pasta não usa anotações Java.
- **Números de uso não decidem esta escolha.** A tabela de frameworks web do
  Stack Overflow Developer Survey 2026 (10.281 respondentes) não lista o
  Ktor [8], de modo que esta pasta não afirma nada sobre quantas pessoas o
  usam. Ele é usado porque é do próprio Kotlin, pequeno o bastante para um
  único arquivo e documentado pela JetBrains.
- **O Netty** é um dos quatro motores da JVM na documentação do Ktor [6] e o
  motor de seu primeiro exemplo [1].
- **O Ktor 3.6.1** é a versão atual (veja Pré-requisitos) [1][2].
- **A porta 8080** é a convenção deste repositório para toda implementação
  web e a porta dos exemplos da documentação do Ktor [6].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | macOS 26, Temurin 21.0.8, Gradle 9.8.0, Kotlin 2.4.21, Ktor 3.6.1, Netty 4.2.17.Final. O `./build.sh` levou cerca de 1 minuto com o cache de dependências vazio. O servidor inicia em menos de 1 s. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O fat jar é bytecode Java puro, de modo que roda em qualquer JVM para Java 21 ou superior. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` com o apt quando nenhum Java 21 é encontrado. Ele não instala o Gradle: se ele não existe, imprime como obter uma versão atual [4] e para. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK: se o Java 21 não existe, imprime o comando `winget` do Temurin 21 e para. Ele também não instala o Gradle: se ele não existe, imprime `winget install --id Gradle.Gradle -e` [4] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: Ktor starts the Netty engine on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
13:11:27.093 INFO  i.k.s.Application - Application started in 0.493 seconds.
13:11:27.415 INFO  i.k.s.Application - Responding at http://127.0.0.1:8080
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html; charset=UTF-8

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Ktor: Build Asynchronous Servers and Clients in Kotlin. JetBrains. <https://ktor.io/> (acessado em 2026-11-04)
2. `ktor-server-core`, `maven-metadata.xml`. Maven Central. <https://repo1.maven.org/maven2/io/ktor/ktor-server-core/maven-metadata.xml> (acessado em 2026-11-04)
3. Configure a Gradle project (Kotlin Gradle plugin compatibility). JetBrains. <https://kotlinlang.org/docs/gradle-configure-project.html> (acessado em 2026-11-04)
4. Installing Gradle. Gradle. <https://docs.gradle.org/current/userguide/installation.html> (acessado em 2026-11-04)
5. Creating fat JARs using the Ktor Gradle plugin. JetBrains. <https://ktor.io/docs/server-fatjar.html> (acessado em 2026-11-04)
6. Server engines (`embeddedServer`, engine list). JetBrains. <https://ktor.io/docs/server-engines.html> (acessado em 2026-11-04)
7. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (acessado em 2026-11-04)
8. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
