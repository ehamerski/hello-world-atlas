---
source: languages/java/web-react/README.md
source_sha: 1d8539871b612626308301981044e3f140f720d4
---
# Java · web-react: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Java](../README.md)

## O que é
Uma aplicação web dividida em **dois programas separados**, como muitas
aplicações web são construídas na prática:

- **`backend/`**: uma API Spring Boot em Java. Ela não envia HTML. Responde
  a `GET /api/hello` com o JSON `{"message":"Hello, World!"}`.
- **`frontend/`**: uma aplicação React em JavaScript, compilada e servida
  pelo Vite. O navegador a carrega; em seguida, o React chama `/api/hello` e
  mostra a mensagem como **Hello, World!**

Compare com [../web](../web/), em que o servidor Java monta o HTML por conta
própria. Aqui a página é montada **no navegador**, e o Java apenas fornece
os dados. As duas partes se comunicam por HTTP.

```text
 browser ──GET /──────────► Vite (frontend, :4173) ── sends index.html + React code
 browser ──GET /api/hello─► Vite (frontend, :4173) ──proxy──► Spring Boot (backend, :8080)
                                                    ◄── {"message":"Hello, World!"}
 React draws <p>Hello, World!</p>
```

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou posterior | Eclipse Temurin 21.0.8 | compila e executa o back-end |
| Apache Maven | 3.9.16 | compila o back-end e baixa o Spring Boot |
| Spring Boot | 4.1.2 (fixada em `backend/pom.xml`) | o framework do back-end; baixado pelo Maven |
| Node.js (20.19+ ou 22.12+) com npm | Node.js 26.8.2, npm 12.2.1 | executa o Vite; o npm instala os pacotes do front-end |
| React / Vite | React 19.3.1, Vite 8.3.5 (`frontend/package-lock.json`) | a biblioteca de interface e a ferramenta de build do front-end; instalados por `install.sh` com `npm ci` |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |
| Google Chrome ou Chromium | opcional | `./run.sh --verify` o utiliza, se estiver presente, para verificar a página que o React desenha |

"Vite requires Node.js version 20.19+, 22.12+" [7] (tradução livre: "O Vite
exige o Node.js na versão 20.19+ ou 22.12+"). O Spring Boot 4.1.2 "requires
at least Java 17" [1] (tradução livre: "exige no mínimo o Java 17").

## Início rápido
```sh
./install.sh   # check JDK, Maven, Node.js; install the front end's packages (asks first)
./build.sh     # build backend/target/hello-api.jar and frontend/dist/
./run.sh       # start both: API on :8080, front end on http://localhost:4173
```
Abra <http://localhost:4173/> em um navegador. Ctrl+C encerra os dois
servidores. Outras portas: `PORT=9000 FE_PORT=5000 ./run.sh` (`PORT` é a
API e `FE_PORT` é o front-end).

**Durante o desenvolvimento do front-end**, é possível usar o servidor de
desenvolvimento do Vite em vez do build. Ele recarrega a página assim que um
arquivo em `frontend/src` é salvo:
```sh
java -jar backend/target/hello-api.jar &       # the API, in the background
cd frontend && npm run dev                      # front end on http://localhost:5173
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se há um JDK 21+ (`javac -version`). 2. Verifica se há o Maven. 3. Verifica se há o Node.js 20.19+ / 22.12+ e o npm. 4. Executa `npm ci` em `frontend/` se `node_modules` não existir. O que estiver ausente é oferecido com o respectivo comando de instalação, que só é executado se a resposta for `y`. | Cada parte tem a sua própria toolchain. O `npm ci` instala exatamente as versões de `package-lock.json`: "If dependencies in the package lock do not match those in package.json, npm ci will exit with an error, instead of updating the package lock" [11] (tradução livre: "Se as dependências do package lock não corresponderem às do package.json, o npm ci termina com um erro, em vez de atualizar o package lock"). |
| `build.sh` | 1. `mvn package` em `backend/` → `backend/target/hello-api.jar`. 2. `npm run build` (isto é, `vite build`) em `frontend/` → `frontend/dist/`. | A máquina virtual Java executa bytecode; por isso, o Java é compilado primeiro, como em [../web](../web/README.md#scripts-explained). Os navegadores não leem JSX (o `<p>` semelhante a HTML em `App.jsx`); assim, o Vite o traduz para JavaScript puro e o empacota em um único arquivo. O primeiro build baixa os plugins do Maven e as bibliotecas do `backend/pom.xml` do Maven Central para `~/.m2/repository`; os builds seguintes os reutilizam. |
| `run.sh` | Inicia a API com `java -jar`, aguarda até que `/api/hello` responda e, em seguida, inicia `vite preview` para o front-end. `--verify`: chama `/api/hello` **pela porta do front-end** com `curl`, carrega a página no Chrome headless, se instalado, e imprime o que o React desenhou; depois encerra os dois. | As duas partes são programas separados; portanto, ambas precisam estar em execução. O `vite preview` serve o build; o Vite informa que ele se destina a "Locally preview the production build. Do not use this as a production server" [9] (tradução livre: "Visualizar localmente o build de produção. Não o use como servidor de produção"). Um `trap` encerra a API quando o script termina ou quando Ctrl+C é pressionado. |

## Estrutura de pastas
```text
web-react/
├── README.md         this file
├── install.sh        checks JDK, Maven, Node.js; runs npm ci
├── build.sh          builds both parts
├── run.sh            starts both parts
├── screenshot.png    the page in a browser, for "Expected output" below
├── backend/                         the Spring Boot API (a Maven project)
│   ├── pom.xml
│   ├── src/main/java/com/example/hello/HelloApiApplication.java
│   ├── src/main/resources/application.properties
│   └── target/hello-api.jar         created by build.sh; not committed
└── frontend/                        the React app (an npm project)
    ├── package.json                 dependencies and the dev/build/preview commands
    ├── package-lock.json            exact versions of every package
    ├── vite.config.js               React plugin and the /api proxy
    ├── index.html                   the page; React fills <div id="root">
    ├── src/main.jsx                 starts React
    ├── src/App.jsx                  the component that calls the API
    ├── node_modules/                created by install.sh; not committed
    └── dist/                        created by build.sh; not committed
```
- **Duas pastas de nível superior, uma por programa.** Cada uma mantém o
  layout padrão da sua própria ferramenta; assim, qualquer uma poderia ir
  para um repositório próprio. `backend/` é um projeto Maven comum,
  organizado como em [../web](../web/README.md#folder-structure) [2].
  `frontend/` é o layout produzido por `npm create vite@latest` com o
  template `react` [7], reduzido aos arquivos de que um Hello World precisa
  (o CSS, as imagens e a configuração do linter do template foram removidos).
- `package-lock.json` está versionado: o npm afirma "This file is intended to
  be committed into source repositories" [12] (tradução livre: "Este arquivo
  se destina a ser versionado em repositórios de código-fonte").
  `node_modules/` e `dist/` são saída de build e são ignorados pelo
  `.gitignore` da raiz.
- Os scripts ficam no topo; assim, o leitor executa um único `install.sh`,
  `build.sh` e `run.sh` para toda a aplicação, como em todas as outras
  pastas.

## Passo a passo
**Back-end:** abra
[`HelloApiApplication.java`](backend/src/main/java/com/example/hello/HelloApiApplication.java).

1. A classe tem as mesmas duas anotações de [../web](../web/README.md#step-by-step-walkthrough):
   `@SpringBootApplication` inicia o Spring, e `@RestController` devolve
   diretamente ao chamador tudo o que um método retorna [3].
2. **`record Greeting(String message) {}`** declara uma pequena classe de
   dados. Os records são classes "that act as transparent carriers for
   immutable data" [13] (tradução livre: "que atuam como portadoras
   transparentes de dados imutáveis"); o compilador escreve o construtor, o
   acessador `message()`, `equals`, `hashCode` e `toString`. Os records se
   tornaram um recurso padrão no Java 16 (JEP 395) [13].
3. **`@GetMapping("/api/hello") Greeting hello()`** retorna um objeto, não
   uma string. O Spring o converte em JSON, `{"message":"Hello, World!"}`,
   com `Content-Type: application/json` (ver a saída de `curl -i` abaixo).
   O prefixo `/api` separa os caminhos da API das páginas do front-end.

**Front-end:** abra [`vite.config.js`](frontend/vite.config.js),
[`main.jsx`](frontend/src/main.jsx) e [`App.jsx`](frontend/src/App.jsx).

4. **O proxy** em `vite.config.js`: `server.proxy` configura "custom proxy
   rules for the dev server" [8] (tradução livre: "regras de proxy
   personalizadas para o servidor de desenvolvimento"), e `preview.proxy`
   usa as mesmas regras por padrão (o valor padrão é `server.proxy`) [10].
   Toda requisição a `/api/...` é encaminhada ao Spring Boot. O navegador
   conversa sempre com uma única origem; portanto, o back-end não precisa de
   configuração de CORS. Sem o proxy, o navegador bloquearia a chamada: "For
   security reasons, browsers prohibit AJAX calls to resources outside the
   current origin" (tradução livre: "Por motivos de segurança, os navegadores
   proíbem chamadas AJAX a recursos fora da origem atual"), e o back-end
   precisaria de `@CrossOrigin` [14].
5. **`index.html`** tem um `<div id="root">` vazio. `main.jsx` chama
   `createRoot`, que "lets you create a root to display React components
   inside a browser DOM node" [4] (tradução livre: "permite criar uma raiz
   para exibir componentes React dentro de um nó DOM do navegador"), e
   renderiza `<App />` nela. O `StrictMode` acrescenta verificações extras
   durante o desenvolvimento; elas "are development-only and do not impact
   the production build" [6] (tradução livre: "existem apenas no
   desenvolvimento e não afetam o build de produção").
6. **`App` é um componente de função.** `useState` "lets you add a state
   variable to your component" [5] (tradução livre: "permite adicionar uma
   variável de estado ao componente"): `message` começa como `Loading...`.
7. **`useEffect(() => { fetch('/api/hello')... }, [])`** é executado uma vez
   depois que o componente é exibido e chama a API. `useEffect` "lets you
   synchronize a component with an external system" [15] (tradução livre:
   "permite sincronizar um componente com um sistema externo"); aqui, o
   sistema externo é a API Spring Boot. Quando o JSON chega,
   `setMessage(data.message)` atualiza o estado e o React redesenha
   `<p>Hello, World!</p>`. A documentação do React mostra uma versão mais
   longa, com um sinalizador `ignore`, para descartar respostas que chegam
   fora de ordem [15]. Com uma única requisição, as respostas não podem
   chegar fora de ordem; por isso, o sinalizador foi omitido aqui.
8. **JSX**: `return <p>{message}</p>` parece HTML, mas é JavaScript. O
   plugin React do Vite o traduz durante `npm run build`. Em
   [../web](../web/), o mesmo `<p>` era uma string Java montada no
   servidor.

## Por que esta toolchain
- **React** é a biblioteca de front-end mais usada no Stack Overflow
  Developer Survey 2026: 41,5% dos 10.281 respondentes da pergunta sobre
  frameworks web a usaram, atrás apenas do Node.js (46,4%), que é um
  runtime, não uma biblioteca de interface [16]. Este repositório combina o
  Java com o React.
- **Vite**: a própria documentação do React lista o Vite como ferramenta de
  build para iniciar "a React app from scratch" (tradução livre: "uma
  aplicação React do zero"), o caminho que ela sugere quando "you just want
  to learn the basics of a React app" (tradução livre: "o objetivo é apenas
  aprender o básico de uma aplicação React") [17]. A primeira sugestão do
  React é um framework como o Next.js, que ele descreve como um meio de
  viabilizar "full-stack React apps" (tradução livre: "aplicações React
  full-stack") [17]. Esse framework traz o seu próprio servidor, mas, nesta
  aplicação, o servidor é o Spring Boot; portanto, uma configuração simples
  do Vite é suficiente.
- **Um proxy em vez de CORS** mantém o back-end idêntico a uma API comum de
  mesma origem e o código do front-end livre de endereços de servidor fixos
  no código. A implantação de `dist/` em produção está fora do escopo
  aqui; o guia do Vite trata do assunto [22].
- **Spring Boot** para a API: ver [../web](../web/README.md#why-this-toolchain).
- **Portas:** 8080 é a porta padrão do Spring Boot [18]. 4173 é a porta
  padrão de `vite preview`, e 5173 a do servidor de desenvolvimento [10][8].

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Temurin 21.0.8, Maven 3.9.16, Spring Boot 4.1.2, Node.js 26.8.2, npm 12.2.1, Vite 8.3.5, React 19.3.1. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. `brew install node` para o Node.js [19]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `openjdk-21-jdk` e `maven` com o apt quando faltam. Ele não instala o Node.js: se uma versão com suporte não existe, imprime os passos do nodejs.org e para. Ele executa `npm ci` em `frontend` quando o Vite não está instalado ali. O `run.sh --verify` procura `google-chrome` ou `chromium` no `PATH` e ignora a verificação no navegador se nenhum dos dois for encontrado. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` coloca no PATH o JDK de `JAVA_HOME_21_X64` quando essa variável está definida. Ele não instala um JDK nem o Maven: se um dos dois não existe, imprime o comando `winget` do Temurin 21 ou os passos do zip do Maven e para. Ele não instala o Node.js: se uma versão com suporte não existe, imprime `winget install --id OpenJS.NodeJS.LTS -e` e para. Ele executa `npm ci` em `frontend` quando o Vite não está instalado ali. |

## Saída esperada
`./run.sh --verify` (as linhas de log do back-end estão abreviadas):
```text
==> 1/2 Start the backend (Spring Boot API) on http://localhost:8080
    WHY: the API must be up before the front end can ask it for the message.
 :: Spring Boot ::                (v4.1.2)
... INFO ... : Started HelloApiApplication in 2.688 seconds (process running for 3.685)
{"message":"Hello, World!"}

==> 2/2 Start the front end (Vite serving the React build) on http://localhost:4173
    WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js).
    Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to Spring Boot:
  ➜  Local:   http://localhost:4173/
  ➜  Network: use --host to expose
{"message":"Hello, World!"}
    Check 2: load the page in headless Chrome and show what React drew:
<div id="root"><p>Hello, World!</p></div>
```
Manualmente, com `./run.sh` em execução:
```text
$ curl -i http://localhost:8080/api/hello        # the backend directly
HTTP/1.1 200 
Content-Type: application/json
Content-Length: 27

{"message":"Hello, World!"}

$ curl -i http://localhost:4173/api/hello        # the same call through the front end
HTTP/1.1 200 OK
content-type: application/json
content-length: 27

{"message":"Hello, World!"}
```
`curl http://localhost:4173/` retorna apenas `index.html` com um
`<div id="root"></div>` vazio: o texto aparece somente depois que o
navegador executa o React. O navegador mostra: **Hello, World!**

![A página em http://localhost:4173/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --virtual-time-budget=10000 --screenshot=screenshot.png http://localhost:4173/`.)

## Fontes
1. System Requirements. Spring Boot. <https://docs.spring.io/spring-boot/system-requirements.html> (acessado em 2026-10-31)
2. Introduction to the Standard Directory Layout. Apache Maven. <https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html> (acessado em 2026-10-31)
3. Developing Your First Spring Boot Application. Spring Boot. <https://docs.spring.io/spring-boot/tutorial/first-application/index.html> (acessado em 2026-10-31)
4. `createRoot`. React. <https://react.dev/reference/react-dom/client/createRoot> (acessado em 2026-10-31)
5. `useState`. React. <https://react.dev/reference/react/useState> (acessado em 2026-10-31)
6. StrictMode. React. <https://react.dev/reference/react/StrictMode> (acessado em 2026-10-31)
7. Getting Started. Vite. <https://vite.dev/guide/> (acessado em 2026-10-31)
8. Server Options. Vite. <https://vite.dev/config/server-options> (acessado em 2026-10-31)
9. Command Line Interface. Vite. <https://vite.dev/guide/cli> (acessado em 2026-10-31)
10. Preview Options. Vite. <https://vite.dev/config/preview-options> (acessado em 2026-10-31)
11. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (acessado em 2026-10-31)
12. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (acessado em 2026-10-31)
13. JEP 395: Records. OpenJDK. <https://openjdk.org/jeps/395> (acessado em 2026-10-31)
14. CORS. Spring Framework. <https://docs.spring.io/spring-framework/reference/web/webmvc-cors.html> (acessado em 2026-10-31)
15. `useEffect`. React. <https://react.dev/reference/react/useEffect> (acessado em 2026-10-31)
16. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
17. Creating a React App / Build a React app from Scratch. React. <https://react.dev/learn/creating-a-react-app>, <https://react.dev/learn/build-a-react-app-from-scratch> (acessado em 2026-10-31)
18. Common Application Properties (server.port). Spring Boot. <https://docs.spring.io/spring-boot/appendix/application-properties/index.html> (acessado em 2026-10-31)
19. node (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/node> (acessado em 2026-10-31)
20. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (acessado em 2026-10-31)
21. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (acessado em 2026-10-31)
22. Deploying a Static Site. Vite. <https://vite.dev/guide/static-deploy> (acessado em 2026-10-31)
