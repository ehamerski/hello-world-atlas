---
source: languages/node/desktop/README.md
source_sha: 9818bdc431c9f4e9cd9354f246553ba6107838f9
---
# Node.js · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Node.js](../README.md)

## O que é
Um programa desktop que abre uma pequena janela intitulada "Hello, World!"
com o título **Hello, World!** dentro dela. Ele é construído com o
**Electron**, "a framework for building desktop applications using
JavaScript, HTML, and CSS" [1] (tradução livre: "um framework para construir
aplicações desktop usando JavaScript, HTML e CSS"). O Node.js não tem um
toolkit de janelas próprio; por isso, a janela vem do Electron, um pacote
npm que o `install.sh` baixa.

O conteúdo da janela é uma página web ([`index.html`](index.html)). O
Electron funciona "by embedding Chromium and Node.js into its binary" [1]
(tradução livre: "incorporando o Chromium e o Node.js ao seu binário"): o
Chromium, o motor de navegador de código aberto por trás do Google Chrome,
desenha a página, e o Node.js executa [`main.js`](main.js), que cria a
janela. Compare com [../../python/desktop](../../python/desktop/) (tkinter)
e [../../go/desktop](../../go/desktop/) (Fyne), que desenham os seus widgets
sem um motor de navegador.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Node.js 22.12 ou posterior, com npm | Node.js 26.8.2, npm 12.2.1 (nvm) | o npm instala o Electron; o campo `"engines"` do pacote `electron` exige `node >= 22.12.0` |
| Electron | 45.2.1 (fixada em `package-lock.json`) | o framework desktop; o `install.sh` o instala em `node_modules/` |
| macOS 13 (Ventura) ou posterior, ou Windows 10 ou posterior | macOS 26.7.2 | Os binários do Electron oferecem suporte a "macOS (Ventura and up)" e "Windows (Windows 10 and up)" [2] |

O Electron traz o **seu próprio** Node.js e o seu próprio Chromium. Na
máquina de desenvolvimento,
`ELECTRON_RUN_AS_NODE=1 node_modules/.bin/electron -p process.versions`
informa o Node.js 24.22.1 e o Chromium 156.0.8078.75, enquanto o comando
`node` é o 26.8.2. Assim, `main.js` executa no Node.js 24 do Electron, não
no Node.js instalado pelo usuário; este é usado apenas pelo npm e para
iniciar o Electron.

## Início rápido
```sh
./install.sh   # check Node.js, install Electron (asks before each download)
./run.sh       # open the window; close it with Cmd+Q (macOS) or Ctrl+C here
```
`npm start` também funciona: ele executa o script `start` de `package.json`,
`electron .`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica se há o Node.js 22.12+ e o npm e mostra como instalá-los se estiverem ausentes. 2. Executa `npm ci`, que instala em `node_modules/` as versões exatas de `package-lock.json`. 3. Executa `npx --no install-electron`, que baixa o programa Electron (cerca de 125 MB compactado e 270 MB descompactado na máquina de desenvolvimento). As etapas 2 e 3 pedem confirmação antes. | Desde o Electron 42, "`electron` no longer downloads itself via `postinstall` script" (tradução livre: "o `electron` não se baixa mais por meio do script `postinstall`"); em vez disso, "Electron will now download itself dynamically the first time that its main `bin` script is run" (tradução livre: "o Electron agora se baixará dinamicamente na primeira vez que o seu script `bin` principal for executado") ou "you can now call the `install-electron` script, which contains the exact same code from the former `postinstall` script" [3] (tradução livre: "agora é possível chamar o script `install-electron`, que contém exatamente o mesmo código do antigo script `postinstall`"). Fazer isso no `install.sh` significa que o `run.sh` nunca inicia um download grande por conta própria. |
| `run.sh` | Executa `node_modules/.bin/electron .`. `--verify` define `TF_VERIFY=1`: depois que a página é carregada, a aplicação imprime o texto do título e encerra após cerca de 2 segundos. | `electron .` lê `package.json`, executa o arquivo indicado em `"main"` e abre a janela. Não há etapa de compilação. |

Não há `build.sh`: o Electron executa `main.js` e `index.html` como estão.
Para entregar a aplicação a outras pessoas, seria preciso empacotá-la com
uma ferramenta como o Electron Forge, "an all-in-one tool for packaging and
distributing Electron applications" [4] (tradução livre: "uma ferramenta
completa para empacotar e distribuir aplicações Electron"); um Hello World
executado a partir da sua pasta não precisa dela.

## Estrutura de pastas
```text
desktop/
├── README.md          this file
├── install.sh         checks Node.js, installs Electron
├── run.sh             opens the window
├── main.js            the main process: creates the window
├── index.html         the page shown inside the window
├── package.json       the project: entry point ("main"), start script, Electron as a dev dependency
├── package-lock.json  the exact version of every installed package (written by npm)
├── screenshot.png     the window, for "Expected output" below
└── node_modules/      created by install.sh; not committed (see ../../../.gitignore)
```
- **`main.js` + `index.html` + `package.json`** é o layout do tutorial do
  primeiro aplicativo do próprio Electron, com `"main": "main.js"` e
  `"start": "electron ."` em `package.json` [5].
- **`"devDependencies"`**: o Electron está listado ali, como recomenda o
  README do Electron: "The preferred method is to install Electron as a
  development dependency in your app" [2] (tradução livre: "O método
  preferido é instalar o Electron como dependência de desenvolvimento do
  aplicativo").
- **`package-lock.json`** e **`node_modules/`** funcionam como em
  [../web](../web/README.md#folder-structure). Aqui, `node_modules/` tem
  cerca de 284 MB, quase todos do programa Electron em
  `node_modules/electron/dist/`. Compare com 3,8 MB do Express.

## Passo a passo
Abra [`main.js`](main.js) e [`index.html`](index.html) ao lado desta lista.

1. **Dois processos.** "The main process runs in a Node.js environment,
   meaning it has the ability to `require` modules and use all of Node.js
   APIs" [6] (tradução livre: "O processo principal executa em um ambiente
   Node.js, isto é, tem a capacidade de usar `require` em módulos e de
   utilizar todas as APIs do Node.js"); esse é o `main.js`. "Each Electron
   app spawns a separate renderer process for each open `BrowserWindow`" [6]
   (tradução livre: "Cada aplicativo Electron cria um processo de
   renderização separado para cada `BrowserWindow` aberta"); esse processo
   exibe `index.html`, e "the renderer has no direct access to `require` or
   other Node.js APIs" [6] (tradução livre: "o renderizador não tem acesso
   direto a `require` nem a outras APIs do Node.js"). O Electron usa esse
   projeto de dois processos até para um Hello World.
2. **`const { app, BrowserWindow } = require("electron/main")`** carrega dois
   objetos do Electron com *desestruturação*. O tutorial mostra
   `require('electron')` e também a forma `electron/main` [5].
3. **`createWindow`** é uma função de seta guardada em uma constante.
   `new BrowserWindow({ width: 320, height: 160 })` cria a janela, e
   `win.loadFile("index.html")` exibe a página nela.
4. **`index.html`** é HTML comum. O título da janela vem de `<title>` e o
   texto vem de `<h1 id="greeting">`. A sua linha `Content-Security-Policy`
   segue a lista de verificação de segurança do Electron, item 7, "Define a
   Content Security Policy" [7] (tradução livre: "Defina uma Política de
   Segurança de Conteúdo"). Dois outros itens dessa lista já são os padrões:
   a integração com o Node.js está desativada para as páginas ("the default
   behavior in Electron since 5.0.0", em tradução livre: "o comportamento
   padrão no Electron desde a 5.0.0") e o isolamento de contexto está
   ativado ("the default behavior in Electron since 12.0.0", em tradução
   livre: "o comportamento padrão no Electron desde a 12.0.0") [7].
5. **`app.whenReady().then(...)`** aguarda o início do Electron; as janelas
   não podem ser criadas antes disso. `whenReady()` retorna uma *Promise*,
   um valor que chega depois.
6. **`window-all-closed` e `activate`** são as convenções de plataforma que o
   tutorial acrescenta: encerrar quando a última janela é fechada, exceto no
   macOS (`darwin`), e reabrir uma janela quando o ícone do Dock é clicado
   [5].
7. **A autoverificação** (somente com `TF_VERIFY=1`, usada por `./run.sh
   --verify`): no evento `did-finish-load`, `main.js` verifica se a janela
   está visível, pede ao renderizador o texto do título com
   `executeJavaScript` (uma chamada `async`/`await`), o imprime e encerra 2
   segundos depois. 14 das 32 linhas de código de `main.js` correspondem a
   essa verificação.

Não há laço a escrever: como no `mainloop()` do tkinter e no `ShowAndRun()`
do Fyne, o Electron executa o laço de eventos e chama as funções escritas
quando os eventos ocorrem.

## Por que esta toolchain
O Node.js não tem um toolkit desktop próprio; por isso, esta pasta usa o
**Electron**. As razões, com as suas fontes:

- **É um framework desktop para Node.js.** O código do próprio aplicativo
  executa em um ambiente Node.js [6]; assim, continua sendo um programa
  Node.js, com `require`, npm e `package.json`, como [../cli](../cli/) e
  [../web](../web/). O Tauri, uma alternativa, é "built on Rust" [8]
  (tradução livre: "construído sobre Rust"): o seu lado nativo é escrito em
  Rust, o que o tornaria um programa Rust, não Node.js.
- **É usado por muitas aplicações.** A página inicial do Electron lista,
  entre outros, 1Password, Discord, Figma, GitHub Desktop, Notion, Obsidian,
  Postman, Signal, Slack, Trello e VS Code como "Apps users love, built with
  Electron" [9] (tradução livre: "Aplicativos que os usuários adoram,
  construídos com Electron"). Esta é a lista do próprio projeto Electron, não
  uma pesquisa independente. O Stack Overflow Developer Survey 2026 não
  pergunta sobre frameworks desktop (nem o Electron nem o Tauri estão na sua
  lista de frameworks web) [10]; por isso, nenhum número de participação de
  mercado é apresentado aqui.
- **É mantido sob uma fundação.** "Electron is an open-source project under
  the OpenJS Foundation" [9] (tradução livre: "O Electron é um projeto de
  código aberto sob a OpenJS Foundation"), que o lista como um "Impact
  Project" [11], ao lado do próprio Node.js. Uma nova versão principal é
  lançada a cada 8 semanas e "the latest three stable major versions are
  supported by the Electron team" [12] (tradução livre: "as três versões
  principais estáveis mais recentes têm suporte da equipe do Electron").
- **A versão 45** se tornou estável em 2026-10-20 (Chromium M156, Node.js
  v24.22.0) [13]; a 45.2.1 era a versão mais recente no GitHub em 2026-10-31
  [14]. O Electron 46 ainda estava em alfa [13][14].
- **Custos.** Todo aplicativo Electron inclui o seu próprio Chromium e o seu
  próprio Node.js [1]; assim, até este Hello World exige um download de cerca
  de 125 MB e cerca de 270 MB em disco. O Tauri evita isso usando "the web
  view already available on every user's system" [8] (tradução livre: "a
  web view já disponível no sistema de cada usuário"). O NW.js (antes
  node-webkit) é outra opção para Node.js; ele "lets you call all Node.js
  modules directly from DOM" [15] (tradução livre: "permite chamar todos os
  módulos do Node.js diretamente a partir do DOM"). Para um repositório que
  ensina Node.js, o tamanho é aceito em troca de escrever todo o aplicativo
  em JavaScript e HTML com o framework do projeto Electron.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Node.js 26.8.2 (nvm), npm 12.2.1, Electron 45.2.1 (`electron-v45.2.1-darwin-x64.zip`). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. O `install-electron` baixa o build `arm64`; o Electron fornece "64-bit Intel and Apple Silicon / ARM binaries for macOS" [2] (tradução livre: "binários de 64 bits para Intel e Apple Silicon / ARM no macOS"). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Node.js: se a versão 22.12 ou posterior não existe, ele imprime os passos do nodejs.org e para. Ele executa `npm ci` e, em seguida, `npx --no install-electron` para baixar o programa do Electron. O Electron fornece binários Linux `x64` e `arm64` [2]. Uma janela exige uma sessão gráfica. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Node.js: se a versão 22.12 ou posterior não existe, ele imprime `winget install --id OpenJS.NodeJS.LTS -e` e para. Ele executa `npm ci` e, em seguida, `npx --no install-electron` para baixar o programa do Electron. O Electron exige o Windows 10 ou posterior [2]. O WSL não foi verificado; ele se comporta como o Linux, e uma janela exige o WSLg ou um servidor X. |

## Saída esperada
`./run.sh` abre esta janela:

![A janela do Electron intitulada "Hello, World!" exibindo o título "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente essa janela.)

`./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: 'electron .' runs main.js in Electron's main process; main.js opens
         a window whose content (index.html) is drawn by Chromium.
Hello, World!
```

## Fontes
1. Introduction. Electron Docs. <https://www.electronjs.org/docs/latest> (acessado em 2026-10-31)
2. electron/electron (README: Installation, Platform support). GitHub. <https://github.com/electron/electron/blob/main/README.md> (acessado em 2026-10-31)
3. Breaking Changes (42.0: `electron` no longer downloads itself via `postinstall` script). Electron Docs. <https://www.electronjs.org/docs/latest/breaking-changes> (acessado em 2026-10-31)
4. Getting Started. Electron Forge. <https://www.electronforge.io/> (acessado em 2026-10-31)
5. Building your First App. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/tutorial-first-app> (acessado em 2026-10-31)
6. Process Model. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/process-model> (acessado em 2026-10-31)
7. Security. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/security> (acessado em 2026-10-31)
8. What is Tauri?. Tauri. <https://v2.tauri.app/start/> (acessado em 2026-10-31)
9. Electron home page ("Apps users love, built with Electron"). Electron. <https://www.electronjs.org/> (acessado em 2026-10-31)
10. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
11. Projects. OpenJS Foundation. <https://openjsf.org/projects> (acessado em 2026-10-31)
12. Electron Releases. Electron Docs. <https://www.electronjs.org/docs/latest/tutorial/electron-timelines> (acessado em 2026-10-31)
13. Schedule. Electron Releases. <https://releases.electronjs.org/schedule> (acessado em 2026-10-31)
14. Releases. electron/electron (GitHub). <https://github.com/electron/electron/releases> (acessado em 2026-10-31)
15. NW.js home page. NW.js. <https://nwjs.io/> (acessado em 2026-10-31)
