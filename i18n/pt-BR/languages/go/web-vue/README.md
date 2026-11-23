---
source: languages/go/web-vue/README.md
source_sha: 3beed0ddd55df99358015ef18eb5c9f47739ec50
---
# Go · web-vue: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Go](../README.md)

## O que é
Uma aplicação web dividida em **dois programas separados**, como muitas
aplicações web reais são construídas:

- **`backend/`**: uma API em Go construída somente com a biblioteca padrão.
  Não envia HTML. Responde a `GET /api/hello` com o JSON
  `{"message":"Hello, World!"}`.
- **`frontend/`**: uma aplicação Vue em JavaScript, compilada e servida pelo
  Vite. O navegador a carrega, o Vue chama `/api/hello` e a página mostra a
  mensagem como **Hello, World!**

Compare com [../web](../web/), em que o servidor Go preenche um template
HTML por conta própria. Aqui, a página é montada **no navegador**, e o Go
apenas fornece os dados. As duas partes se comunicam por HTTP. A mesma
divisão, com Spring Boot e React, está em
[../../java/web-react](../../java/web-react/).

```text
 browser ──GET /──────────► Vite (frontend, :4173) ── sends index.html + Vue code
 browser ──GET /api/hello─► Vite (frontend, :4173) ──proxy──► Go API (backend, :8080)
                                                    ◄── {"message":"Hello, World!"}
 Vue draws <p>Hello, World!</p>
```

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Go 1.22 ou superior | Go 1.27.3 (Homebrew) | compila o back-end; o `net/http` e o `encoding/json` já vêm com ele |
| Node.js (20.19+ ou 22.12+) com npm | Node.js 26.8.2, npm 12.2.1 | executa o Vite; o npm instala os pacotes do front-end |
| Vue / Vite | Vue 3.5.44, Vite 8.3.5, `@vitejs/plugin-vue` 6.0.10 (`frontend/package-lock.json`) | o framework de interface, a ferramenta de build do front-end e seu plugin para Vue; instalados pelo `install.sh` com `npm ci` |
| `curl` | `curl` do sistema | apenas para o `./run.sh --verify` e para testes manuais |
| Google Chrome ou Chromium | opcional | o `./run.sh --verify` o usa, se estiver presente, para conferir a página que o Vue desenha |

"Vite requires Node.js version 20.19+, 22.12+" [7] (tradução livre: "O Vite
exige o Node.js na versão 20.19+ ou 22.12+"). O gerador de projetos do
próprio Vue, `npm create vue@latest`, pede um Node.js mais recente
(`^22.18.0 || >=24.12.0`) [2], mas esta aplicação não usa o gerador.

## Início rápido
```sh
./install.sh   # check Go and Node.js; install the front end's packages (asks first)
./build.sh     # build backend/bin/hello-api and frontend/dist/
./run.sh       # start both: API on :8080, front end on http://localhost:4173
```
Abra <http://localhost:4173/> em um navegador. Ctrl+C encerra os dois
servidores. Outras portas: `PORT=9000 FE_PORT=5000 ./run.sh` (`PORT` é a
API, `FE_PORT` é o front-end).

**Durante o desenvolvimento do front-end**, é possível usar o servidor de
desenvolvimento do Vite no lugar do build. Ele recarrega a página assim que
um arquivo em `frontend/src` é salvo:
```sh
./backend/bin/hello-api &                      # the API, in the background
cd frontend && npm run dev                      # front end on http://localhost:5173
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o Go 1.22+ (`go env GOVERSION`). 2. Verifica o Node.js 20.19+ / 22.12+ e o npm. 3. Executa `npm ci` em `frontend/` se `node_modules` não existir. Para o que estiver faltando, o script mostra o comando de instalação e só o executa se você responder `y`. | Cada parte tem sua própria toolchain. O back-end não baixa nada. O `npm ci` instala exatamente as versões do `package-lock.json`: "If dependencies in the package lock do not match those in package.json, npm ci will exit with an error, instead of updating the package lock" [11] (tradução livre: "Se as dependências do lock de pacotes não corresponderem às do package.json, o npm ci terminará com um erro, em vez de atualizar o lock de pacotes"). |
| `build.sh` | 1. `go build -o bin/hello-api .` em `backend/` → `backend/bin/hello-api`. 2. `npm run build` (isto é, `vite build`) em `frontend/` → `frontend/dist/`. | O Go compila para um executável nativo, como em [../cli](../cli/README.md#scripts-explained). Os navegadores não leem arquivos `.vue`, de modo que o plugin do Vite para Vue os compila para JavaScript puro e o Vite o empacota em um único arquivo. |
| `run.sh` | Inicia a API, espera até que `/api/hello` responda e, em seguida, inicia o `vite preview` para o front-end. `--verify`: chama `/api/hello` **pela porta do front-end** com o `curl`, carrega a página no Chrome headless se ele estiver instalado, imprime o que o Vue desenhou e, depois, encerra os dois. | As duas partes são programas separados, de modo que ambas precisam estar em execução. O `vite preview` serve o build; o Vite afirma que ele serve para "Locally preview the production build. Do not use this as a production server" [9] (tradução livre: "Visualizar localmente o build de produção. Não use como servidor de produção"). Um `trap` encerra a API quando o script termina ou quando o leitor pressiona Ctrl+C. |

O `npm ci` pode imprimir `npm warn install-scripts ... fsevents@2.3.3`.
O `fsevents` é um pacote opcional do Vite, exclusivo do macOS (`"optional":
true, "os": ["darwin"]` no `package-lock.json`), usado para observar
arquivos. O npm não executou seu script de instalação; o build e o `vite
preview` funcionam sem ele.

## Estrutura de pastas
```text
web-vue/
├── README.md         this file
├── install.sh        checks Go and Node.js; runs npm ci
├── build.sh          builds both parts
├── run.sh            starts both parts
├── screenshot.png    the page in a browser, for "Expected output" below
├── backend/                         the Go API (a Go module)
│   ├── go.mod                       module example.com/hello-api, go 1.22
│   ├── main.go                      the API
│   └── bin/hello-api                created by build.sh; not committed
└── frontend/                        the Vue app (an npm project)
    ├── package.json                 dependencies and the dev/build/preview commands
    ├── package-lock.json            exact versions of every package
    ├── vite.config.js               Vue plugin and the /api proxy
    ├── index.html                   the page; Vue fills <div id="app">
    ├── src/main.js                  creates the Vue app and mounts it
    ├── src/App.vue                  the component that calls the API
    ├── node_modules/                created by install.sh; not committed
    └── dist/                        created by build.sh; not committed
```
- **Duas pastas de nível superior, uma por programa**, como em
  [../../java/web-react](../../java/web-react/README.md#folder-structure).
  Cada uma mantém a estrutura padrão da sua própria ferramenta, de modo que
  qualquer uma poderia ir para um repositório próprio. O `backend/` é um
  módulo Go de "comando básico", como o de
  [../web](../web/README.md#folder-structure) [12]. O `frontend/` tem os
  arquivos de que um projeto Vite + Vue precisa, escritos à mão e reduzidos
  ao mínimo (sem CSS, imagens ou configuração de linter). O `npm create
  vue@latest`, "the official Vue project scaffolding tool" (tradução livre:
  "a ferramenta oficial de estruturação de projetos Vue"), cria uma
  estrutura semelhante, baseada no Vite [2].
- O `package-lock.json` é incluído no repositório: o npm afirma "This file
  is intended to be committed into source repositories" [13] (tradução
  livre: "Este arquivo se destina a ser incluído em repositórios de código-fonte").
  `node_modules/`, `dist/` e `bin/` são saídas de compilação e são ignorados
  pelo `.gitignore` da raiz.
- Os scripts ficam no topo, de modo que o leitor executa um único
  `install.sh`, `build.sh` e `run.sh` para a aplicação inteira, como em todas
  as outras pastas.

## Passo a passo
**Back-end:** abra o [`backend/main.go`](backend/main.go).

1. **``type Greeting struct { Message string `json:"message"` }``** declara
   o formato da resposta. Uma struct agrupa campos nomeados, como um record
   do Java ou uma dataclass do Python. O texto entre crases é uma **struct
   tag**: "The encoding of each struct field can be customized by the format
   string stored under the "json" key in the struct field's tag" [14]
   (tradução livre: "A codificação de cada campo da struct pode ser
   personalizada pela string de formato armazenada sob a chave "json" na
   tag do campo"). Sem ela, a chave JSON seria `Message`, o nome do campo em
   Go. O campo precisa começar com letra maiúscula, ou o `encoding/json`
   não poderia enxergá-lo (nomes exportados, ver
   [../cli](../cli/README.md#step-by-step-walkthrough)).
2. **`w.Header().Set("Content-Type", "application/json")`** informa o que é o
   corpo. Em [../web](../web/README.md#step-by-step-walkthrough), o Go
   deduziu `text/html` a partir do conteúdo; para JSON, o tratador o informa.
3. **`json.NewEncoder(w).Encode(Greeting{Message: "Hello, World!"})`**
   escreve a struct como JSON diretamente na resposta. O `Encode` escreve o
   JSON "followed by a newline character" [14] (tradução livre: "seguido de
   um caractere de nova linha"), e é por isso que a resposta tem 28 bytes, e
   não 27.
4. **`http.HandleFunc("GET /api/hello", hello)`**: o mesmo padrão de método
   do Go 1.22 de [../web](../web/README.md#step-by-step-walkthrough) [15].
   O prefixo `/api` separa os caminhos da API das páginas do front-end.

**Front-end:** abra o [`vite.config.js`](frontend/vite.config.js), o
[`main.js`](frontend/src/main.js) e o [`App.vue`](frontend/src/App.vue).

5. **O proxy** em `vite.config.js`: `server.proxy` configura "custom proxy
   rules for the dev server", e "any requests whose request path starts
   with that key will be proxied to the specified target" [8] (tradução
   livre: "regras de proxy personalizadas para o servidor de
   desenvolvimento"; "quaisquer requisições cujo caminho comece com essa
   chave serão repassadas ao destino especificado"). O `preview.proxy` usa
   as mesmas regras por padrão [10]. Toda requisição a `/api/...` é
   encaminhada à API em Go. O navegador conversa sempre com uma única
   origem, de modo que o back-end não precisa de cabeçalhos de
   compartilhamento de recursos entre origens (CORS).
6. **O `index.html`** tem um `<div id="app">` vazio. O `main.js` chama
   `createApp(App).mount('#app')`: cria a aplicação Vue a partir do
   componente `App` e a desenha dentro desse elemento [20].
7. **O `App.vue` é um Single-File Component.** "Vue Single-File Components
   (a.k.a. *.vue files, abbreviated as SFC) is a special file format" [3]
   (tradução livre: "Os Single-File Components do Vue (também chamados de
   arquivos *.vue, abreviados como SFC) são um formato de arquivo
   especial") que mantém juntos a lógica de um componente (`<script
   setup>`) e seu template HTML (`<template>`). O `<script setup>` "is a
   compile-time syntactic sugar for using Composition API inside
   Single-File Components" [4] (tradução livre: "é um açúcar sintático em
   tempo de compilação para usar a Composition API dentro de Single-File
   Components").
8. **`const message = ref('Loading...')`**: o `ref` "takes an inner value and
   returns a reactive and mutable ref object, which has a single property
   .value that points to the inner value" [5] (tradução livre: "recebe um
   valor interno e devolve um objeto ref reativo e mutável, que tem uma
   única propriedade .value apontando para o valor interno"). Atribuir
   `message.value` faz o Vue redesenhar todos os pontos que o usam. No
   template, escreve-se `{{ message }}` sem `.value`.
9. **`onMounted(async () => { ... })`** "registers a callback to be called
   after the component has been mounted" [6] (tradução livre: "registra um
   callback a ser chamado depois que o componente foi montado"): depois que
   o `<p>` está na página, o callback chama `fetch('/api/hello')`, aguarda
   (`await`) o JSON e define `message.value = data.message`. O Vue
   redesenha `<p>Hello, World!</p>`.
10. **O Vue comparado ao React** ([../../java/web-react](../../java/web-react/README.md#step-by-step-walkthrough)):
    a mesma aplicação, dois estilos. O componente do React é uma função
    JavaScript que devolve JSX, e as mudanças de estado passam por
    `setMessage(...)`. O Vue separa um `<template>` semelhante a HTML do
    script, e o estado é um `ref` ao qual se atribui um valor. O
    `{{ message }}` no template do Vue faz o papel do `{message}` no JSX do
    React.

## Por que esta toolchain
- **Vue** é "a JavaScript framework for building user interfaces" [1]
  (tradução livre: "um framework JavaScript para construir interfaces de
  usuário"). Na Stack Overflow Developer Survey 2026, 17,2% dos 10.281
  respondentes da pergunta sobre frameworks web usaram o Vue.js [16]. Este
  repositório combina o Go com o Vue.
- **Vite**: o quick start do Vue cria projetos que usam "a build setup based
  on Vite" [2] (tradução livre: "uma configuração de build baseada no
  Vite"), de modo que ele é a ferramenta de build padrão para uma nova
  aplicação Vue.
- **Um proxy em vez de CORS** mantém o back-end como uma API simples de
  mesma origem e o código do front-end livre de endereços de servidor fixos
  no código, a mesma escolha de
  [../../java/web-react](../../java/web-react/README.md#why-this-toolchain).
- **A biblioteca padrão do Go para a API**: o `net/http` a serve e o
  `encoding/json` escreve o JSON [14][15], de modo que o back-end não baixa
  nada, como em [../web](../web/README.md#why-this-toolchain).
- **Portas:** a 8080 coincide com as demais pastas web deste repositório. A
  4173 é a porta padrão do `vite preview`, e a 5173 é a do servidor de
  desenvolvimento [10][8].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Go 1.27.3, Node.js 26.8.2, npm 12.2.1, Vue 3.5.44, Vite 8.3.5. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. `brew install go node` [17][18]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime os passos do arquivo de go.dev [6] e para. Ele não instala o Node.js: se uma versão com suporte não existe, imprime os passos do nodejs.org e para. Ele executa `npm ci` em `frontend` quando o Vite não está instalado ali. O `run.sh --verify` procura `google-chrome` ou `chromium` no `PATH` e ignora a verificação no navegador se nenhum dos dois for encontrado. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Go: se o Go 1.22 ou posterior não existe, ele imprime `winget install --id GoLang.Go -e` [12] e para. Ele não instala o Node.js: se uma versão com suporte não existe, imprime `winget install --id OpenJS.NodeJS.LTS -e` e para. Ele executa `npm ci` em `frontend` quando o Vite não está instalado ali. |

## Saída esperada
`./run.sh --verify`:
```text
==> 1/2 Start the backend (Go API) on http://localhost:8080
    WHY: the API must be up before the front end can ask it for the message.
2026/10/31 13:48:36 API listening on http://localhost:8080/api/hello
{"message":"Hello, World!"}


==> 2/2 Start the front end (Vite serving the Vue build) on http://localhost:4173
    WHY: Vite serves frontend/dist and forwards /api/* to the backend (see vite.config.js).
    Check 1: GET /api/hello on the FRONT END's port, which Vite forwards to the Go API:
  ➜  Local:   http://localhost:4173/
  ➜  Network: use --host to expose
{"message":"Hello, World!"}

    Check 2: load the page in headless Chrome and show what Vue drew:
<div id="app" data-v-app=""><p>Hello, World!</p></div>
```
(As linhas vazias vêm da quebra de linha que o `Encode` acrescenta após o
JSON. O `data-v-app` é um atributo que o Vue adiciona ao elemento em que
foi montado.)

Manualmente, com o `./run.sh` em execução:
```text
$ curl -i http://localhost:8080/api/hello        # the backend directly
HTTP/1.1 200 OK
Content-Type: application/json
Date: Sat, 31 Oct 2026 16:47:20 GMT
Content-Length: 28

{"message":"Hello, World!"}
```
O `curl http://localhost:4173/` devolve apenas o `index.html` com um
`<div id="app"></div>` vazio: o texto só aparece depois que o navegador
executa o Vue. O navegador mostra: **Hello, World!**

![A página em http://localhost:4173/ exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-10-31 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --virtual-time-budget=10000 --screenshot=screenshot.png http://localhost:4173/`.)

## Fontes
1. Introduction. Vue.js. <https://vuejs.org/guide/introduction.html> (acessado em 2026-10-31)
2. Quick Start. Vue.js. <https://vuejs.org/guide/quick-start.html> (acessado em 2026-10-31)
3. Single-File Components. Vue.js. <https://vuejs.org/guide/scaling-up/sfc.html> (acessado em 2026-10-31)
4. `<script setup>`. Vue.js. <https://vuejs.org/api/sfc-script-setup.html> (acessado em 2026-10-31)
5. Reactivity API: Core (ref). Vue.js. <https://vuejs.org/api/reactivity-core.html#ref> (acessado em 2026-10-31)
6. Composition API: Lifecycle Hooks (`onMounted`). Vue.js. <https://vuejs.org/api/composition-api-lifecycle.html#onmounted> (acessado em 2026-10-31)
7. Getting Started. Vite. <https://vite.dev/guide/> (acessado em 2026-10-31)
8. Server Options. Vite. <https://vite.dev/config/server-options> (acessado em 2026-10-31)
9. Command Line Interface. Vite. <https://vite.dev/guide/cli> (acessado em 2026-10-31)
10. Preview Options. Vite. <https://vite.dev/config/preview-options> (acessado em 2026-10-31)
11. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (acessado em 2026-10-31)
12. Organizing a Go module. The Go Authors. <https://go.dev/doc/modules/layout> (acessado em 2026-10-31)
13. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (acessado em 2026-10-31)
14. Package encoding/json. The Go Authors. <https://pkg.go.dev/encoding/json> (acessado em 2026-10-31)
15. Package net/http (ServeMux patterns). The Go Authors. <https://pkg.go.dev/net/http> (acessado em 2026-10-31)
16. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
17. go (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/go> (acessado em 2026-10-31)
18. node (formula). Homebrew Formulae. <https://formulae.brew.sh/formula/node> (acessado em 2026-10-31)
19. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (acessado em 2026-10-31)
20. Application API (`createApp`, `app.mount`).
 Vue.js. <https://vuejs.org/api/application.html> (acessado em 2026-10-31)
