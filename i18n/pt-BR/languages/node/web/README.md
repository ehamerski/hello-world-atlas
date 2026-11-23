---
source: languages/node/web/README.md
source_sha: 1f21ea67e28b639e7146a29796b5584fcae13757
---
# Node.js · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Node.js](../README.md)

## O que é
Um pequeno servidor web escrito com o **Express**, o "fast, unopinionated,
minimalist web framework for Node.js" [1] (tradução livre: "framework web
rápido, sem opiniões impostas e minimalista para Node.js"). Quando um
navegador solicita `http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador exibe como o texto
**Hello, World!**. O próprio servidor envia o HTML; não há front-end
separado.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Node.js 18 ou posterior, com npm | Node.js 26.8.2, npm 12.2.1 (nvm) | executa `app.js`; o npm baixa o Express |
| Express | 5.3.0 (fixada em `package-lock.json`) | o framework web; o `install.sh` o instala em `node_modules/` |
| `curl` | `curl` do sistema | apenas para `./run.sh --verify` e para testes manuais |

O Express 5 exige o Node.js 18 ou posterior: "Before you begin, make sure
you have Node.js 18 or higher installed" [2] (tradução livre: "Antes de
começar, certifique-se de ter o Node.js 18 ou superior instalado"). O npm
acompanha o Node.js.

## Início rápido
```sh
./install.sh   # check Node.js and npm, install Express into node_modules/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`. `npm start` também funciona: ele executa o script
`start` de `package.json`, `node app.js`, na porta 8080.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se há o Node.js 18+ e o npm e mostra como instalá-los se estiverem ausentes. 2. Executa `npm ci`, que instala em `node_modules/` as versões exatas listadas em `package-lock.json`. A etapa 2 pede confirmação antes. | O Express é um pacote do registro do npm, não faz parte do Node.js. O `npm ci` é "meant to be used in automated environments ... or any situation where you want to make sure you're doing a clean install of your dependencies" [8] (tradução livre: "destinado a ambientes automatizados ... ou a qualquer situação em que se queira garantir uma instalação limpa das dependências"). |
| `run.sh` | Executa `node app.js`. `--verify` o inicia em segundo plano, obtém a página uma vez com `curl` e o encerra. | A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem aguardar Ctrl+C. |

Não há `build.sh`: o Node.js executa JavaScript diretamente, como em
[../cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md          this file
├── install.sh         checks Node.js and npm, installs Express
├── run.sh             starts the server
├── app.js             the web application (Express's hello world, port 8080)
├── package.json       the project: name, module type, start script, dependencies
├── package-lock.json  the exact version of every installed package (written by npm)
├── screenshot.png     the page, for "Expected output" below
└── node_modules/      created by install.sh; not committed (see ../../../.gitignore)
```
- **`app.js`** é o nome de arquivo usado pelo exemplo hello world do
  Express [3].
- **`package.json`** é o arquivo de projeto do npm. `"dependencies"` lista o
  Express; com `"private": true`, "npm will refuse to publish it" [9]
  (tradução livre: "o npm se recusará a publicá-lo"). `"type": "commonjs"`
  indica que os arquivos `.js` usam `require()` [9][10]. `"scripts"` define
  `npm start`.
- **`package-lock.json`** registra a versão exata do Express e dos 64
  pacotes de que o próprio Express precisa. O npm afirma que esse arquivo
  "is intended to be committed into source repositories" [11] (tradução
  livre: "se destina a ser versionado em repositórios de código-fonte"); com
  isso, todo estudante obtém o mesmo código. O `npm ci` se recusa a executar
  sem ele [8].
- **`node_modules/`** guarda os pacotes baixados, dentro desta pasta (o
  Python os mantém em `.venv/`, e o Go, em um cache compartilhado). Ela
  sempre pode ser recriada a partir do arquivo de bloqueio; por isso, não é
  versionada.

## Passo a passo
Abra [`app.js`](app.js) ao lado desta lista.

1. **`const express = require("express")`** carrega o Express a partir de
   `node_modules/`. Ao contrário da versão [cli](../cli/hello.js), que usa
   apenas o `console` global, este programa depende de uma biblioteca do
   registro do npm. Esta é a sintaxe CommonJS da documentação do Express
   [3]; a sintaxe de módulos ES é `import express from "express"` [10].
2. **`const app = express()`** cria a aplicação.
3. **`process.env.PORT || 8080`** lê a variável de ambiente `PORT` ou usa
   8080 se ela não estiver definida. `||` retorna o lado direito quando o
   lado esquerdo é falso (falsy), por exemplo `undefined`.
4. **`app.get("/", (req, res) => { ... })`** registra uma rota: as
   requisições GET para `/` chamam a função de seta. O exemplo do Express
   faz o mesmo e observa que "for every other path, it will respond with a
   **404 Not Found**" [3] (tradução livre: "para qualquer outro caminho,
   responderá com **404 Not Found**"). Compare com o `@app.route("/")` do
   Flask, o `http.HandleFunc("/", ...)` do Go e o `@GetMapping("/")` do
   Spring Boot.
5. **`res.send("<p>Hello, World!</p>")`**: "When the parameter is a
   `String`, the method sets the `Content-Type` to "text/html"" [4]
   (tradução livre: "Quando o parâmetro é uma `String`, o método define o
   `Content-Type` como "text/html""). Esse cabeçalho pode ser visto na saída
   de `curl -i` abaixo.
6. **`app.listen(port, "127.0.0.1", callback)`** inicia o servidor. Ele
   "binds and listens for connections on the specified host and port" (tradução
   livre: "associa-se ao host e à porta especificados e escuta conexões") e
   "is identical to Node's http.Server.listen()" [5] (tradução livre: "é
   idêntico a http.Server.listen() do Node"). O host `"127.0.0.1"` mantém o
   servidor privado a este computador. Sem ele, "the server will accept
   connections on the unspecified IPv6 address (`::`) when IPv6 is
   available, or the unspecified IPv4 address (`0.0.0.0`) otherwise" [12]
   (tradução livre: "o servidor aceitará conexões no endereço IPv6
   não especificado (`::`) quando o IPv6 estiver disponível ou, caso
   contrário, no endereço IPv4 não especificado (`0.0.0.0`)"), isto é,
   também de outras máquinas. O callback é executado quando o servidor está
   pronto; o Express 5 lhe passa um erro se a escuta falhar, por exemplo
   quando a porta já está em uso.
7. **Sem laço a escrever.** `app.listen()` retorna imediatamente, e o
   arquivo termina, mas o programa continua em execução: o Node.js só "exits
   the event loop when there are no more callbacks to perform" [13]
   (tradução livre: "sai do laço de eventos quando não há mais callbacks a
   executar"), e um servidor aberto continua aguardando requisições. A
   versão [cli](../cli/) não tinha nada a aguardar; por isso, terminava.

O exemplo do Express em expressjs.com usa a porta 3000 e envia
`Hello World!` [3]. Esta versão usa a porta 8080 (a convenção de toda
implementação web deste repositório) e envia o mesmo parágrafo `<p>` das
outras versões web.

## Por que esta toolchain
- **Express:** no Stack Overflow Developer Survey 2026, 15,6% dos
  respondentes da pergunta sobre frameworks e tecnologias web o usaram
  (1.604 de 10.281) [6]. Ele é um "Impact Project" da OpenJS Foundation, a
  mesma fundação que hospeda o Node.js [7].
- **Express 5:** a versão 5.0.0 foi lançada em 2024-09-09, mas "we didn't
  make it the `latest` release on npm" (tradução livre: "não a tornamos a
  versão `latest` no npm") até a 5.1.0, em 2025-03-31 [14]. O Express 5
  "drops support for Node.js versions before v18" [15] (tradução livre:
  "deixa de oferecer suporte às versões do Node.js anteriores à v18"). A
  5.3.0 foi publicada no registro do npm em 2026-10-09 e era a versão
  `latest` ali quando esta página foi verificada [16].
- **Por que não usar apenas o módulo `http` do Node?** O Node.js pode servir
  uma página sem nenhum pacote: a página "About Node.js" mostra um servidor
  construído com `createServer` de `node:http` [13]. O Express acrescenta o
  roteamento (qual URL chama qual função), de modo que um 404 é retornado
  para qualquer outro caminho, e um `Content-Type` escolhido automaticamente
  [3][4]. A pesquisa acima mostra que muitos respondentes usam o Express.
- **CommonJS (`require`)** em vez de módulos ES (`import`): o hello world do
  Express usa `require` [3], assim como o tutorial do Electron usado por
  [../desktop](../desktop/). As duas formas são padrão no Node.js; os
  módulos ES são o sistema de módulos do próprio padrão ECMAScript [10].
- **Porta 8080** é a convenção deste repositório para toda implementação
  web.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Node.js 26.8.2 (nvm), npm 12.2.1, Express 5.3.0. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel. O Express é JavaScript puro: o mesmo `node_modules/` funciona em qualquer CPU. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Node.js: se a versão 18 ou posterior não existe, ele imprime os passos do nodejs.org [17] e para. Ele executa `npm ci` quando o Express não está instalado. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Node.js: se a versão 18 ou posterior não existe, ele imprime `winget install --id OpenJS.NodeJS.LTS -e` [18] e para. Ele executa `npm ci` quando o Express não está instalado. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'node app.js' listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/ (Ctrl+C to stop)
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-UEgmxq84YB3jUrvPtCv95CaXyYs"
Date: Sat, 31 Oct 2026 17:23:58 GMT
Connection: keep-alive
Keep-Alive: timeout=5

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 com o Google Chrome headless:
`chrome --headless=new --window-size=640,320 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Express: Node.js web application framework (home page). OpenJS Foundation and Express.js contributors. <https://expressjs.com/> (acessado em 2026-10-31)
2. Installing. Express.js. <https://expressjs.com/en/starter/installing.html> (acessado em 2026-10-31)
3. Hello world example. Express.js. <https://expressjs.com/en/starter/hello-world.html> (acessado em 2026-10-31)
4. Response (res.send). Express.js 5.x API. <https://expressjs.com/en/5x/api/response> (acessado em 2026-10-31)
5. Application (app.listen). Express.js 5.x API. <https://expressjs.com/en/5x/api/application> (acessado em 2026-10-31)
6. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
7. Projects. OpenJS Foundation. <https://openjsf.org/projects> (acessado em 2026-10-31)
8. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (acessado em 2026-10-31)
9. package.json ("private", "dependencies", "scripts"). npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-json> (acessado em 2026-10-31)
10. Modules: Packages ("type" field) and ECMAScript modules. Node.js v26 Documentation. <https://nodejs.org/api/packages.html> and <https://nodejs.org/api/esm.html> (acessado em 2026-10-31)
11. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (acessado em 2026-10-31)
12. Net: server.listen(). Node.js v26 Documentation. <https://nodejs.org/api/net.html> (acessado em 2026-10-31)
13. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (acessado em 2026-10-31)
14. Express@5.1.0: Now the Default on npm with LTS Timeline. Express Technical Committee, 2025-03-31. <https://expressjs.com/en/blog/2025-03-31-v5-1-latest-release> (acessado em 2026-10-31)
15. Introducing Express v5: A New Era for the Node.js Framework. Wes Todd, 2024-10-15. <https://expressjs.com/en/blog/2024-10-15-v5-release> (acessado em 2026-10-31)
16. express (package metadata: dist-tags and publish times). npm registry. <https://registry.npmjs.org/express> (acessado em 2026-10-31)
17. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (acessado em 2026-10-31)
18. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (acessado em 2026-10-31)
