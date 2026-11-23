---
source: languages/java/web/README.md
source_sha: 6d1fdbf420a4e96e91c3b4f9798760b40e706627
---
# Java · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Java](../README.md)

## O que é
Um pequeno servidor web escrito com **Spring Boot**. Quando um navegador
solicita `http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador exibe como o texto **Hello, World!**.
O próprio servidor envia o HTML; não há front-end separado (para isso, ver
[../web-react](../web-react/)).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou posterior | Eclipse Temurin 21.0.8 | compila e executa o servidor |
| Apache Maven | 3.9.16 | compila o projeto e baixa o Spring Boot |
| Spring Boot | 4.1.2 (fixada em `pom.xml`) | o framework web, com o servidor Tomcat 11.0.27 embutido; **não é instalado manualmente**: o Maven o baixa durante `./build.sh` |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

"Spring Boot 4.1.2 requires at least Java 17 and is compatible with
versions up to and including Java 27" (tradução livre: "O Spring Boot 4.1.2
exige no mínimo o Java 17 e é compatível com versões até o Java 27,
inclusive"), e exige "Maven 3.6.3 or later" (tradução livre: "Maven 3.6.3 ou
posterior") [1].

## Início rápido
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into the executable jar target/hello-web.jar
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Executa `javac -version` e verifica se a versão é 21 ou posterior. 2. Verifica se `mvn` está no `PATH`. Se algum estiver ausente, mostra o comando de instalação e só o executa se a resposta for `y`. | Mesma toolchain de [../cli](../cli/README.md#scripts-explained). O Spring Boot não requer instalação separada. |
| `build.sh` | Executa `mvn --batch-mode --quiet package`. | O Maven compila o código e empacota `target/hello-web.jar`. Em seguida, a meta `repackage` do plugin do Spring Boot, que o `spring-boot-starter-parent` associa ao build [2], o transforma em um JAR executável: um arquivo "containing your compiled classes along with all of the jar dependencies that your code needs to run" [2] (tradução livre: "contendo as classes compiladas e todas as dependências em JAR de que o código precisa para ser executado"). O primeiro build baixa os plugins do Maven e as bibliotecas do `pom.xml` do Maven Central para `~/.m2/repository`; os builds seguintes os reutilizam. |
| `run.sh` | Executa `java -jar target/hello-web.jar`. `--verify` o inicia em segundo plano, aguarda a página com `curl`, a imprime e, depois, encerra o servidor. | `SpringApplication` "bootstraps our application, starting Spring, which, in turn, starts the auto-configured Tomcat web server" [2] (tradução livre: "inicializa a aplicação, iniciando o Spring, que, por sua vez, inicia o servidor web Tomcat autoconfigurado"). A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem aguardar Ctrl+C. |

## Estrutura de pastas
```text
web/
├── README.md        this file
├── install.sh       checks / installs the JDK and Maven
├── build.sh         compiles and packages the executable jar
├── run.sh           starts the server
├── screenshot.png   the page in a browser, for "Expected output" below
├── pom.xml          Maven project: Spring Boot parent, web starter, plugin
├── src/main/java/com/example/hello/
│   └── HelloApplication.java      the whole server
├── src/main/resources/
│   └── application.properties     port and address settings
└── target/          created by build.sh; not committed
    └── hello-web.jar
```
- O Standard Directory Layout do Maven: código Java em `src/main/java` e
  "Application/Library resources" (tradução livre: "recursos da
  aplicação/biblioteca") em `src/main/resources` [3].
- `pom.xml` herda de `spring-boot-starter-parent`, "a special starter that
  provides useful Maven defaults" [2] (tradução livre: "um starter especial
  que fornece padrões úteis do Maven"); assim, a dependência não precisa de
  número de versão.
- A dependência é `spring-boot-starter-webmvc`, o "Starter for using Spring
  MVC and Tomcat" [4] (tradução livre: "Starter para usar o Spring MVC e o
  Tomcat"). No Spring Boot 4, ele substitui `spring-boot-starter-web`, que
  agora está "deprecated in favor of spring-boot-starter-webmvc" [4]
  (tradução livre: "obsoleto em favor de spring-boot-starter-webmvc").
  Tutoriais mais antigos ainda mostram o nome antigo.
- `application.properties` define `server.port=${PORT:8080}`. Os
  placeholders do Spring "can also specify a default value using a : to
  separate the default value from the property name" [5] (tradução livre:
  "também podem especificar um valor padrão, usando : para separar o valor
  padrão do nome da propriedade"). Assim, o servidor usa a variável de
  ambiente `PORT` ou, na falta dela, 8080. `server.address=127.0.0.1` é o
  "Network address to which the server should bind" [6] (tradução livre:
  "endereço de rede ao qual o servidor deve se associar"): apenas este
  computador consegue acessá-lo.

## Passo a passo
Abra [`HelloApplication.java`](src/main/java/com/example/hello/HelloApplication.java)
ao lado desta lista. Ele segue o formato da "primeira aplicação Spring Boot"
oficial [2].

1. **Anotações.** As palavras que começam com `@` são anotações: rótulos que
   o Spring lê enquanto o programa é executado. O Flask, na versão
   [Python web](../../python/web/app.py), usa decoradores (`@app.route`)
   para a mesma função.
2. **`@SpringBootApplication`** "is known as a meta-annotation, it combines
   @SpringBootConfiguration, @EnableAutoConfiguration and @ComponentScan"
   [2] (tradução livre: "é conhecida como metanotação; combina
   @SpringBootConfiguration, @EnableAutoConfiguration e @ComponentScan").
   Em resumo: esta é a classe principal, os componentes devem ser
   procurados neste pacote e o Spring deve ser configurado a partir das
   bibliotecas presentes no class path. O Spring MVC e o Tomcat estão
   presentes; por isso, o Spring configura um servidor web.
3. **`@RestController`** "tells Spring to render the resulting string
   directly back to the caller" [2] (tradução livre: "instrui o Spring a
   devolver a string resultante diretamente ao chamador"). Tudo o que um
   método retorna se torna o corpo da resposta.
4. **`@GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)`**
   associa `GET /` ao método `hello()`. Os mapeamentos de requisição
   fornecem informações de "routing" (tradução livre: "roteamento") [2], e
   `produces` define "the list of content types that a controller method
   produces" [7] (tradução livre: "a lista de tipos de conteúdo que um
   método de controlador produz"). Aqui é `text/html`; por isso, o
   navegador renderiza a tag `<p>`. Sem ele, a resposta poderia ser enviada
   como texto simples.
5. **`return "<p>Hello, World!</p>";`** é a página. Compare com o Flask, em
   que a função sob `@app.route("/")` retorna a mesma string.
6. **`main` chama `SpringApplication.run(...)`.** Ele inicia o Spring e o
   Tomcat [2], e o servidor continua em execução em outras threads depois
   que `main` retorna. A versão [cli](../cli/) executava `main` e terminava.

## Por que esta toolchain
- O **Spring Boot** é o framework web Java mais usado na lista de
  frameworks web do Stack Overflow Developer Survey 2026: 12,8% dos 10.281
  respondentes dessa pergunta o usaram [8]. O único outro framework Java
  dessa lista, o Quarkus, foi usado por 0,3% [8].
- Ele também mantém o exemplo curto: um servidor funcional é uma classe mais
  o `pom.xml`, sem um programa servidor separado para instalar, porque o
  Tomcat está embutido no arquivo JAR [2].
- O **Spring Boot 4.1** é a linha atual: a 4.1.2 foi lançada em 2026-10-22
  [9], e o Spring lista suporte de código aberto para a série 4.1.x até
  2027-07-31 [10].
- A **porta 8080** é o `server.port` padrão do Spring Boot [6] e a
  convenção deste repositório para toda implementação web.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, Spring Boot 4.1.2, Tomcat 11.0.27. Inicia em cerca de 2–3 s. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O Spring Boot é Java puro; portanto, o mesmo arquivo JAR é executado em qualquer JVM para o Java 21 ou posterior. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` e `maven` com o apt quando faltam. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK nem o Maven: se um dos dois não existe, imprime o comando `winget` do Temurin 21 ou os passos do zip do Maven e para. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: Spring Boot starts the embedded Tomcat server on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v4.1.2)

... INFO ... : Starting HelloApplication v1.0.0 using Java 21.0.8 ...
... INFO ... : Tomcat initialized with port 8080 (http)
... INFO ... : Tomcat started on port 8080 (http) with context path '/'
... INFO ... : Started HelloApplication in 2.201 seconds (process running for 2.934)
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 
Content-Type: text/html;charset=UTF-8
Content-Length: 20
Date: Sat, 31 Oct 2026 16:19:38 GMT

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. System Requirements. Spring Boot. <https://docs.spring.io/spring-boot/system-requirements.html> (acessado em 2026-10-31)
2. Developing Your First Spring Boot Application. Spring Boot. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (acessado em 2026-10-31)
3. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (acessado em 2026-10-31)
4. Build Systems (Starters). Spring Boot. <https://docs.spring.io/spring-boot/reference/using/build-systems.html> (acessado em 2026-10-31)
5. Externalized Configuration. Spring Boot. <https://docs.spring.io/spring-boot/reference/features/external-config.html> (acessado em 2026-10-31)
6. Common Application Properties (server.port, server.address). Spring Boot. <https://docs.spring.io/spring-boot/appendix/application-properties/index.html> (acessado em 2026-10-31)
7. Mapping Requests (produces). Spring Framework. <https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-requestmapping.html> (acessado em 2026-10-31)
8. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
9. Releases. spring-projects/spring-boot (GitHub). <https://github.com/spring-projects/spring-boot/releases> (acessado em 2026-10-31)
10. Spring Boot (support). Spring. <https://spring.io/projects/spring-boot#support> (acessado em 2026-10-31)
