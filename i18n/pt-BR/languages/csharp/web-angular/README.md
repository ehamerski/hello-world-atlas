---
source: languages/csharp/web-angular/README.md
source_sha: 200612150ab822a0c6ba4d5c31aa5cb1bec74f23
---
# C# · web-angular: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C#](../README.md)

## O que é
Uma aplicação web dividida em **dois programas separados**, o mesmo padrão de
[../../java/web-react](../../java/web-react/) e
[../../go/web-vue](../../go/web-vue/):

- **`backend/`**: uma API ASP.NET Core em C#. Ela não envia HTML. Responde a
  `GET /api/hello` com o JSON `{"message":"Hello, World!"}`.
- **`frontend/`**: uma aplicação Angular em TypeScript, compilada e servida
  pela CLI do Angular. O navegador a carrega, o Angular chama `/api/hello` e
  mostra a mensagem como **Hello, World!**

Compare com [../web](../web/), em que o servidor C# envia o próprio HTML
pronto. Aqui, a página é montada **no navegador**, e o C# fornece apenas os
dados. As duas partes se comunicam por HTTP.

```text
 browser ──GET /──────────► ng serve (frontend, :4200) ── sends index.html + Angular code
 browser ──GET /api/hello─► ng serve (frontend, :4200) ──proxy──► ASP.NET Core API (backend, :8080)
                                                       ◄── {"message":"Hello, World!"}
 Angular draws <p>Hello, World!</p>
```

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| .NET SDK 10 | 10.0.404 (ASP.NET Core 10.0.15), em `~/.dotnet` | compila e executa o back-end; o ASP.NET Core acompanha o SDK |
| Node.js (^22.22.3, ^24.15.0 ou ^26.0.0) com npm | Node.js 26.8.2, npm 12.2.1 | executa a CLI do Angular; o npm instala os pacotes do front-end |
| Angular | `@angular/core` 22.2.4, `@angular/cli` e `@angular/build` 22.2.5, TypeScript 6.0.3 (`frontend/package-lock.json`) | o framework de UI, sua ferramenta de build e o compilador TypeScript; instalados pelo `install.sh` com `npm ci` |
| `curl` | `curl` do sistema | somente para `./run.sh --verify` e para testes manuais |
| Google Chrome ou Chromium | opcional | `./run.sh --verify` o usa, se estiver presente, para verificar a página que o Angular desenha |

As versões do Node.js são as que o Angular 22.x suporta: "^22.22.3 ||
^24.15.0 || ^26.0.0" [1].

## Início rápido
```sh
./install.sh   # check .NET and Node.js; install the front end's packages (asks first)
./build.sh     # build backend/bin/Release/net10.0/hello-api.dll and frontend/dist/
./run.sh       # start both: API on :8080, front end on http://localhost:4200
```
Abra <http://localhost:4200/> em um navegador. Ctrl+C encerra os dois
servidores. Outras portas: `PORT=9000 FE_PORT=5000 ./run.sh` (`PORT` é a da
API e `FE_PORT` a do front-end, como em [../../go/web-vue](../../go/web-vue/)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica a existência de um .NET SDK 10 ou posterior e oferece `dotnet-install.sh` / `winget`, como em [../cli](../cli/README.md#scripts-explained). 2. Verifica a existência de uma versão do Node.js que o Angular 22 suporta e do npm. 3. Executa `npm ci` em `frontend/` se `node_modules` não existir. Tudo o que estiver faltando é oferecido com o respectivo comando de instalação e só é executado se a resposta for `y`. | Cada parte tem a sua própria toolchain. O `npm ci` instala exatamente as versões de `package-lock.json` [2]. |
| `build.sh` | 1. `dotnet build -c Release` em `backend/` → `backend/bin/Release/net10.0/hello-api.dll`. 2. `ng build` em `frontend/` → `frontend/dist/frontend/browser/`. | O C# é compilado para linguagem intermediária (IL), como em [../cli](../cli/README.md#scripts-explained). Os navegadores não executam TypeScript nem templates do Angular; por isso, a CLI do Angular os compila e empacota em JavaScript simples. |
| `run.sh` | Inicia a API a partir de `backend/`, aguarda até que `/api/hello` responda e então inicia `ng serve` em `frontend/`. `--verify`: chama `/api/hello` **pela porta do front-end** com `curl`, carrega a página no Chrome headless, se instalado, e imprime o que o Angular desenhou; depois, encerra os dois. | As duas partes são programas separados; portanto, ambas precisam executar. Um `trap` encerra os dois servidores quando o script termina ou quando se pressiona Ctrl+C. |

**Por que o `run.sh` usa `ng serve` e não a pasta `dist/`.** Os front-ends
Vite deste repositório servem o build com `vite preview`. Esta pasta usa o
servidor da própria CLI do Angular, o `ng serve`, e a documentação do Angular
descreve o uso de proxy para um back-end com ele: "Use proxying
support to divert certain URLs to a backend server, by passing a file to
the `--proxy-config` build option" [3] (tradução livre: "Use o suporte a
proxy para desviar determinadas URLs para um servidor de back-end,
passando um arquivo para a opção de build `--proxy-config`"). O `ng serve`
compila a aplicação novamente, em memória, toda vez que inicia.
`frontend/dist/frontend/browser/` é o que seria copiado para um servidor web
real [4]. O `build.sh` ainda executa `ng build` para que seja possível ver
que o build de produção compila.

**Por que `PORT` é removida para o `ng serve`.** A documentação do Angular
sobre `--port` diz: "The `PORT` environment variable, when set, takes
precedence over this option" [5] (tradução livre: "A variável de ambiente
`PORT`, quando definida, tem precedência sobre esta opção"). Todas as
pastas web deste repositório usam `PORT` para a porta do servidor, aqui a da
API. Se o `ng serve` a visse, tentaria usar também a porta da API e
falharia ("Port 8080 is already in use", visto na máquina de
desenvolvimento). Por isso, o `run.sh` inicia o `ng serve` sem `PORT` e
passa a porta da API como `API_PORT`, que o `proxy.conf.js` lê.

**Análise de uso e telemetria.** Os scripts definem
`DOTNET_CLI_TELEMETRY_OPTOUT=1` (ver [../cli](../cli/README.md#scripts-explained)).
Quanto ao Angular, "The Angular Team does not collect usage statistics
unless you explicitly opt in" [6] (tradução livre: "A equipe do Angular não
coleta estatísticas de uso, a menos que o usuário aceite explicitamente").
`angular.json` define `"analytics": false` e os scripts definem
`NG_CLI_ANALYTICS=false`; assim, a CLI nunca pergunta. Ambos são lidos pela
CLI do Angular 22: o primeiro está no esquema de workspace dela
(`node_modules/@angular/cli/lib/config/schema.json`) e o segundo em
`node_modules/@angular/cli/src/utilities/environment-options.js`.

O `npm ci` com o npm 12 imprime `npm warn install-scripts ... had install
scripts blocked` para `esbuild`, `lmdb`, `@parcel/watcher`, `fsevents` e
`msgpackr-extract`. O npm não executou os scripts de instalação desses
pacotes. Na máquina de desenvolvimento, `ng build` e `ng serve` funcionam sem
eles. O esbuild, por exemplo, vem como um binário pronto no pacote separado
`@esbuild/darwin-x64`.

## Estrutura de pastas
```text
web-angular/
├── README.md         this file
├── install.sh        checks .NET and Node.js; runs npm ci
├── build.sh          builds both parts
├── run.sh            starts both parts
├── screenshot.png    the page in a browser, for "Expected output" below
├── backend/                         the ASP.NET Core API (a .NET project)
│   ├── hello-api.csproj             the project file (Web SDK)
│   ├── Program.cs                   the API
│   ├── appsettings.json             log levels, as in ../web
│   ├── obj/                         created by build.sh; not committed
│   └── bin/Release/net10.0/         created by build.sh; not committed
└── frontend/                        the Angular app (an npm project)
    ├── package.json                 dependencies and the ng commands
    ├── package-lock.json            exact versions of every package
    ├── angular.json                 the Angular CLI's workspace file: build and serve settings
    ├── tsconfig.json                TypeScript and Angular compiler settings
    ├── proxy.conf.js                the /api proxy for ng serve
    ├── src/index.html               the page; Angular fills <app-root>
    ├── src/main.ts                  starts the Angular application
    ├── src/app/app.ts               the component that calls the API
    ├── node_modules/                created by install.sh; not committed
    ├── .angular/                    the CLI's build cache; not committed
    └── dist/frontend/browser/       created by build.sh; not committed
```
- **Duas pastas de nível superior, uma por programa**, como em
  [../../java/web-react](../../java/web-react/README.md#folder-structure) e
  [../../go/web-vue](../../go/web-vue/README.md#folder-structure). Cada parte
  mantém o layout da sua própria ferramenta; assim, qualquer uma poderia ir
  para o seu próprio repositório. `backend/` tem o layout de
  [../web](../web/).
- `frontend/` partiu de `ng new frontend --minimal` (CLI do Angular 22.2.5) e
  foi depois reduzido aos arquivos de que esta aplicação precisa. O roteador,
  os formulários, o Prettier, as configurações do VS Code, o favicon e a
  folha de estilos global foram removidos, e `tsconfig.app.json` foi
  incorporado a `tsconfig.json`. `angular.json` mantém os alvos `build` e
  `serve` da CLI. A documentação do Angular afirma que as aplicações geradas
  por `ng new` usam `@angular/build:application` por padrão [4].
- `package-lock.json` é versionado, como nos outros front-ends: o npm diz
  "This file is intended to be committed into source repositories" [7]
  (tradução livre: "Este arquivo se destina a ser versionado em repositórios
  de código-fonte").

## Passo a passo
**Back-end:** abra [`backend/Program.cs`](backend/Program.cs).

1. As primeiras linhas são as mesmas de [../web](../web/README.md#step-by-step-walkthrough):
   `WebApplication.CreateBuilder(args)` e `builder.Build()`.
2. **`app.MapGet("/api/hello", () => new Greeting("Hello, World!"));`**
   retorna um objeto em vez de uma string. Para "any other type" (tradução
   livre: "qualquer outro tipo"), o framework "JSON-serializes the response"
   (tradução livre: "serializa a resposta em JSON"), com o tipo de conteúdo
   `application/json` [8]. A biblioteca JSON é a System.Text.Json, parte do
   .NET. Para aplicações web, ela escreve os nomes das propriedades em
   `camelCase` ("PropertyNamingPolicy = CamelCase" [9]); assim, a propriedade
   C# `Message` vira `"message"`. Em [../../go/web-vue](../../go/web-vue/), a
   mesma renomeação exige uma tag de struct (`json:"message"`).
3. **`record Greeting(string Message);`** é um *record posicional*. O
   compilador cria "A public automatically implemented property for each
   positional parameter" e "A primary constructor whose parameters match
   the positional parameters" (tradução livre: "Uma propriedade pública
   implementada automaticamente para cada parâmetro posicional" e "Um
   construtor primário cujos parâmetros correspondem aos parâmetros
   posicionais"), além de `Equals`, `GetHashCode` e um `ToString` [10]. É o
   equivalente em C# do record do Java `record Greeting(String message) {}`.
   Ele fica no fim do arquivo porque, com instruções de nível superior,
   "namespaces and type definitions ... must come after the top-level
   statements" [11] (tradução livre: "espaços de nomes e definições de tipo
   ... devem vir depois das instruções de nível superior").

**Front-end:** abra [`proxy.conf.js`](frontend/proxy.conf.js),
[`main.ts`](frontend/src/main.ts) e [`app.ts`](frontend/src/app/app.ts).

4. **O proxy.** `angular.json` aponta `serve` → `options` →
   `proxyConfig` para `proxy.conf.js`. A regra `'/api/**'` envia toda
   requisição sob `/api` para a API, como no exemplo da documentação do
   Angular `"/api/**": {"target": "http://localhost:3000", "secure": false}`
   [3]. O navegador só conversa com uma origem; por isso, o back-end não
   precisa dos cabeçalhos de compartilhamento de recursos entre origens
   (*Cross-Origin Resource Sharing*, CORS). É um arquivo `.js` em vez do
   `.json` da documentação para poder ler a porta de `API_PORT`.
5. **`index.html`** tem um `<app-root>` vazio. `main.ts` chama
   `bootstrapApplication(App)`, que inicia o Angular com `App` como
   componente raiz e o desenha nesse elemento.
6. **TypeScript.** "TypeScript is JavaScript with syntax for types" [12]
   (tradução livre: "TypeScript é JavaScript com sintaxe para tipos").
   `interface Greeting { message: string; }` descreve o JSON. A interface
   existe apenas em tempo de compilação, para verificar que `data.message` é
   uma string.
7. **`@Component({ selector: 'app-root', template: '<p>{{ message() }}</p>' })`**
   é um *decorador* que transforma a classe em um componente do Angular,
   semelhante a um atributo do C# ou a uma anotação do Java. `selector` é a
   tag que ele substitui; `template` é o HTML dele. O componente é
   *standalone*, sem `NgModule`. O modo standalone é o padrão desde o Angular
   19 ("In Angular versions before 19.0.0, the `standalone` option defaults
   to `false`" [13], tradução livre: "Nas versões do Angular anteriores à
   19.0.0, a opção `standalone` tem `false` como padrão").
8. **`message = signal('Loading...')`**: "A **signal** is a wrapper around
   a value that notifies interested consumers when that value changes"
   [14] (tradução livre: "Um **signal** é um invólucro em torno de um valor
   que notifica os consumidores interessados quando esse valor muda"). O
   template o lê como `message()`, e `message.set(...)` o altera, o que faz o
   Angular redesenhar o `<p>`.
9. **`http = inject(HttpClient)`** pede ao Angular o seu serviço HTTP.
   "`HttpClient` is available for injection by default in Angular v21 and
   later" [15] (tradução livre: "`HttpClient` está disponível para injeção
   por padrão no Angular v21 e posteriores"); assim, `main.ts` não precisa de
   `provideHttpClient()`.
   `http.get<Greeting>('/api/hello').subscribe({ next: ..., error: ... })`
   envia a requisição. A resposta chega depois, e `subscribe` define o que
   fazer com ela.
10. **Angular, React e Vue.** Os três desenham `<p>Hello, World!</p>` a partir
    do mesmo JSON. O React ([../../java/web-react](../../java/web-react/README.md#step-by-step-walkthrough))
    usa uma função que retorna JSX e `useState`. O Vue
    ([../../go/web-vue](../../go/web-vue/README.md#step-by-step-walkthrough))
    usa um arquivo `.vue` com um template e `ref`. O Angular usa uma classe
    TypeScript com um decorador, um signal e um serviço injetado. O Angular
    também inclui o seu próprio cliente HTTP, enquanto os outros dois usam o
    `fetch` do navegador.

## Por que esta toolchain
- O **Angular** é "a web framework that empowers developers to build fast,
  reliable applications that users love" [16] (tradução livre: "um framework
  web que capacita desenvolvedores a criar aplicações rápidas e confiáveis
  que os usuários adoram"). No Stack Overflow Developer Survey 2026, 16,0%
  dos 10.281 respondentes da pergunta sobre frameworks web usaram o Angular e
  19,9% usaram o ASP.NET Core [17]. Este repositório combina o C# com o
  Angular.
- O **Angular 22** era a versão principal atual em 2026-11-01. Foi lançado em
  2026-06-03 e estava em suporte ativo [18]. A política de versões do Angular
  prevê "A major release every 12 months" [18] (tradução livre: "Uma versão
  principal a cada 12 meses").
- A **CLI do Angular** (`ng new`, `ng build`, `ng serve`) é a ferramenta que a
  documentação do Angular usa para criar, compilar e servir aplicações
  [3][4].
- **Um proxy em vez de CORS**: a mesma escolha das outras duas pastas com
  front-end separado. O back-end continua sendo uma API simples de mesma
  origem.
- **ASP.NET Core para a API**: como em [../web](../web/README.md#why-this-toolchain).
  Ele acompanha o .NET SDK; assim, o back-end não baixa nada.
- **Portas:** 8080 para a API, como nas outras pastas web. 4200 é a porta
  padrão do `ng serve` [5].

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-20) | .NET SDK 10.0.404, Node.js 26.8.2, npm 12.2.1, Angular 22.2. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. `brew install node` para o Node.js. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o `dotnet-install.sh` da Microsoft (canal 10.0) em `~/.dotnet` quando nenhum SDK do .NET 10 é encontrado [2]. Ele não instala o Node.js: se uma versão com suporte não existe, imprime os passos do nodejs.org e para. Ele executa `npm ci` em `frontend` quando o Angular não está instalado ali. O `run.sh --verify` procura `google-chrome` ou `chromium` no `PATH` e ignora a verificação no navegador se nenhum dos dois for encontrado. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o SDK: se nenhum SDK do .NET 10 é encontrado, ele imprime `winget install --id Microsoft.DotNet.SDK.10 -e` e para. Ele não instala o Node.js: se uma versão com suporte não existe, imprime `winget install --id OpenJS.NodeJS.LTS -e` e para. Ele executa `npm ci` em `frontend` quando o Angular não está instalado ali. |

## Saída esperada
`./run.sh --verify`:
```text
==> 1/2 Start the backend (ASP.NET Core API) on http://localhost:8080
    WHY: the API must be up before the front end can ask it for the message.
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://127.0.0.1:8080
...
info: Microsoft.Hosting.Lifetime[0]
      Content root path: .../csharp/web-angular/backend
{"message":"Hello, World!"}

==> 2/2 Start the front end (ng serve) on http://localhost:4200
    WHY: ng serve compiles the Angular app, serves it and forwards /api/* to the
         backend (see frontend/proxy.conf.js).
    Check 1: GET /api/hello on the FRONT END's port, which ng serve forwards to the API:
❯ Building...
✔ Building...
Initial chunk files | Names         | Raw size
main.js             | main          |  2.65 kB |

                    | Initial total |  2.65 kB

Application bundle generation complete. [1.648 seconds]

Watch mode enabled. Watching for file changes...
NOTE: Raw file sizes do not reflect development server per-request transformations.
  ➜  Local:   http://localhost:4200/
{"message":"Hello, World!"}
    Check 2: load the page in headless Chrome and show what Angular drew:
<app-root ng-version="22.2.4"><p>Hello, World!</p></app-root>
info: Microsoft.Hosting.Lifetime[0]
      Application is shutting down...
```
(`ng-version` é um atributo que o Angular adiciona ao elemento raiz.)

Manualmente, com `./run.sh` em execução:
```text
$ curl -i http://localhost:8080/api/hello        # the backend directly
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8
Date: Sun, 01 Nov 2026 11:33:26 GMT
Server: Kestrel
Transfer-Encoding: chunked

{"message":"Hello, World!"}
```
`curl http://localhost:4200/` retorna apenas o `index.html` com um
`<app-root></app-root>` vazio: o texto só aparece depois que o navegador
executa o Angular. O navegador mostra: **Hello, World!**

![A página em http://localhost:4200/ mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-01 com o Google Chrome em modo headless:
`chrome --headless=new --window-size=640,240 --virtual-time-budget=10000 --screenshot=screenshot.png http://localhost:4200/`.)

## Fontes
1. Version compatibility (Angular 22.x: Node.js and TypeScript). Angular. <https://angular.dev/reference/versions> (acessado em 2026-11-01)
2. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (acessado em 2026-11-01)
3. "Serving Angular apps for development (proxying to a backend server)". Angular. <https://angular.dev/tools/cli/serve> (acessado em 2026-11-01)
4. Building Angular apps. Angular. <https://angular.dev/tools/cli/build> (acessado em 2026-11-01)
5. `ng serve` (command reference: --port, PORT, default 4200). Angular. <https://angular.dev/cli/serve> (acessado em 2026-11-01)
6. `ng analytics`. Angular. <https://angular.dev/cli/analytics> (acessado em 2026-11-01)
7. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (acessado em 2026-11-01)
8. Create responses in Minimal API applications. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/responses> (acessado em 2026-11-01)
9. How to instantiate JsonSerializerOptions instances with System.Text.Json (web defaults). Microsoft Learn. <https://learn.microsoft.com/dotnet/standard/serialization/system-text-json/configure-options> (acessado em 2026-11-01)
10. Records (C# reference). Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/language-reference/builtin-types/record> (acessado em 2026-11-01)
11. Top-level statements - programs without Main methods. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/fundamentals/program-structure/top-level-statements> (acessado em 2026-11-01)
12. TypeScript (home page). Microsoft. <https://www.typescriptlang.org/> (acessado em 2026-11-01)
13. Anatomy of components. Angular. <https://angular.dev/guide/components> (acessado em 2026-11-01)
14. Signals overview. Angular. <https://angular.dev/guide/signals> (acessado em 2026-11-01)
15. Setting up HttpClient. Angular. <https://angular.dev/guide/http/setup> (acessado em 2026-11-01)
16. What is Angular? Angular. <https://angular.dev/overview> (acessado em 2026-11-01)
17. 2026 Stack Overflow Developer Survey: web frameworks and technologies (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/web-framework> (acessado em 2026-11-01)
18. Versioning and releases. Angular. <https://angular.dev/reference/releases> (acessado em 2026-11-01)
