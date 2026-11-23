# Java · web: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [Java](../README.md)

## What this is
A small web server written with **Spring Boot**. When a browser asks for
`http://localhost:8080/`, the server answers with the HTML
`<p>Hello, World!</p>`, which the browser shows as the text **Hello, World!**.
The server sends the HTML itself; there is no separate front end (for
that, see [../web-react](../web-react/)).

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| JDK (Java Development Kit) 21 or newer | Eclipse Temurin 21.0.8 | compiles and runs the server |
| Apache Maven | 3.9.16 | builds the project and downloads Spring Boot |
| Spring Boot | 4.1.2 (pinned in `pom.xml`) | the web framework, with the embedded Tomcat 11.0.27 server; **not installed by hand**: Maven downloads it during `./build.sh` |
| curl | system curl | only for `./run.sh --verify` and for testing by hand |

"Spring Boot 4.1.2 requires at least Java 17 and is compatible with
versions up to and including Java 27", and needs "Maven 3.6.3 or later" [1].

## Quick start
```sh
./install.sh   # check / install the JDK and Maven (asks before installing)
./build.sh     # compile into the executable jar target/hello-web.jar
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Open <http://localhost:8080/> in a browser, or in a second terminal run
`curl http://localhost:8080/`. Use another port with `PORT=9000 ./run.sh`.

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Runs `javac -version` and checks that the version is 21 or newer. 2. Checks that `mvn` is on `PATH`. If one is missing, it shows the install command and runs it only if you answer `y`. | Same toolchain as [../cli](../cli/README.md#scripts-explained). Spring Boot needs no separate install. |
| `build.sh` | Runs `mvn --batch-mode --quiet package`. | Maven compiles the code and packs `target/hello-web.jar`. Then the Spring Boot plugin's `repackage` goal, which `spring-boot-starter-parent` binds to the build [2], turns it into an executable JAR: an archive "containing your compiled classes along with all of the jar dependencies that your code needs to run" [2]. The first build downloads Maven's plugins and the libraries in `pom.xml` from Maven Central into `~/.m2/repository`; later builds reuse them. |
| `run.sh` | Runs `java -jar target/hello-web.jar`. `--verify` starts it in the background, waits for the page with `curl`, prints it, then stops the server. | `SpringApplication` "bootstraps our application, starting Spring, which, in turn, starts the auto-configured Tomcat web server" [2]. The self-check lets `scripts/verify-all.sh` test the server without waiting for Ctrl+C. |

## Folder structure
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
- Maven's Standard Directory Layout: Java code in `src/main/java`,
  "Application/Library resources" in `src/main/resources` [3].
- `pom.xml` inherits from `spring-boot-starter-parent`, "a special starter
  that provides useful Maven defaults" [2], so the dependency needs no
  version number.
- The dependency is `spring-boot-starter-webmvc`, the "Starter for using
  Spring MVC and Tomcat" [4]. In Spring Boot 4 it replaces
  `spring-boot-starter-web`, which is now "deprecated in favor of
  spring-boot-starter-webmvc" [4]. Older tutorials still show the old name.
- `application.properties` sets `server.port=${PORT:8080}`. Spring
  placeholders "can also specify a default value using a : to separate the
  default value from the property name" [5]. So the server uses the `PORT`
  environment variable, or 8080. `server.address=127.0.0.1` is the "Network
  address to which the server should bind" [6]: only this computer can
  reach it.

## Step-by-step walkthrough
Open [`HelloApplication.java`](src/main/java/com/example/hello/HelloApplication.java)
next to this list. It follows the shape of the official "first Spring Boot
application" [2].

1. **Annotations.** Words starting with `@` are annotations: labels that
   Spring reads while the program runs. Flask in the
   [Python web](../../python/web/app.py) version uses decorators
   (`@app.route`) for the same job.
2. **`@SpringBootApplication`** "is known as a meta-annotation, it combines
   @SpringBootConfiguration, @EnableAutoConfiguration and @ComponentScan"
   [2]. In short: this is the main class, find the components in this
   package, and configure Spring from the libraries on the class path. Spring
   MVC and Tomcat are there, so Spring sets up a web server.
3. **`@RestController`** "tells Spring to render the resulting string
   directly back to the caller" [2]. Whatever a method returns becomes the
   response body.
4. **`@GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)`** maps
   `GET /` to the `hello()` method. Request mappings provide "routing"
   information [2], and `produces` sets "the list of content types that a
   controller method produces" [7]. Here it is `text/html`, so the browser
   renders the `<p>` tag. Without it, the answer could be sent as plain
   text.
5. **`return "<p>Hello, World!</p>";`** is the page. Compare Flask, where the
   function under `@app.route("/")` returns the same string.
6. **`main` calls `SpringApplication.run(...)`.** It starts Spring and
   Tomcat [2], and the server keeps running in other threads after `main`
   returns. The [cli](../cli/) version ran `main` and ended.

## Why this toolchain
- **Spring Boot** is the most used Java web framework in the Stack Overflow
  Developer Survey 2026 web frameworks list: 12.8% of the 10,281
  respondents to that question used it [8]. The only other Java framework
  in that list, Quarkus, was used by 0.3% [8].
- It also keeps the example short: a
  working server is one class plus the `pom.xml`, with no separate server
  program to install, because Tomcat is embedded in the JAR file [2].
- **Spring Boot 4.1** is the current line: 4.1.2 was released on
  2026-10-22 [9], and Spring lists open-source support for 4.1.x until
  2027-07-31 [10].
- **Port 8080** is Spring Boot's default `server.port` [6] and the
  convention of this repository for every web implementation.

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, Spring Boot 4.1.2, Tomcat 11.0.27. Starts in about 2–3 s. |
| macOS Apple Silicon | ⚠️ not verified | Same commands. Spring Boot is pure Java, so the same JAR file runs on any JVM for Java 21 or newer. |
| Linux (Debian/Ubuntu) | ✅ verified in CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). `install.sh` installs `openjdk-21-jdk` and `maven` with apt when missing. |
| Windows (Git Bash / WSL) | ✅ verified in CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. `install.sh` puts the JDK from `JAVA_HOME_21_X64` on PATH when that variable is set. It does not install a JDK or Maven: if one is missing it prints the `winget` Temurin 21 command or the Maven zip steps and stops. |

## Expected output
`./run.sh` (the server keeps running until Ctrl+C):
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
In a second terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 
Content-Type: text/html;charset=UTF-8
Content-Length: 20
Date: Sat, 31 Oct 2026 16:19:38 GMT

<p>Hello, World!</p>
```
The browser shows: **Hello, World!**

![The page at http://localhost:8080/ showing "Hello, World!"](screenshot.png)

(Taken on 2026-10-31 with headless Google Chrome:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Sources
1. System Requirements. Spring Boot. <https://docs.spring.io/spring-boot/system-requirements.html> (accessed 2026-10-31)
2. Developing Your First Spring Boot Application. Spring Boot. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (accessed 2026-10-31)
3. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (accessed 2026-10-31)
4. Build Systems (Starters). Spring Boot. <https://docs.spring.io/spring-boot/reference/using/build-systems.html> (accessed 2026-10-31)
5. Externalized Configuration. Spring Boot. <https://docs.spring.io/spring-boot/reference/features/external-config.html> (accessed 2026-10-31)
6. Common Application Properties (server.port, server.address). Spring Boot. <https://docs.spring.io/spring-boot/appendix/application-properties/index.html> (accessed 2026-10-31)
7. Mapping Requests (produces). Spring Framework. <https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-requestmapping.html> (accessed 2026-10-31)
8. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (accessed 2026-10-31)
9. Releases. spring-projects/spring-boot (GitHub). <https://github.com/spring-projects/spring-boot/releases> (accessed 2026-10-31)
10. Spring Boot (support). Spring. <https://spring.io/projects/spring-boot#support> (accessed 2026-10-31)
