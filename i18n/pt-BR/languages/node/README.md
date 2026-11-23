---
source: languages/node/README.md
source_sha: 013522391a6d1e5771b79194a9e4a0b1f53b7240
---
# Node.js (JavaScript)

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma, orientado a eventos. O Node.js é um
*runtime*, não uma linguagem: ele executa **JavaScript**, cujo padrão
(ECMA-262) diz "ECMAScript is an object-oriented programming language"
(tradução livre: "ECMAScript é uma linguagem de programação orientada a
objetos") e "ECMAScript is object-based: basic language and host
facilities are provided by objects" [1] (tradução livre: "ECMAScript é
baseado em objetos: os recursos básicos da linguagem e do ambiente
hospedeiro são fornecidos por objetos"). Seus objetos "are not
fundamentally class-based such as those in C++, Smalltalk, or Java" [1]
(tradução livre: "não são fundamentalmente baseados em classes, como os de
C++, Smalltalk ou Java"): eles herdam de outros objetos (protótipos). Um
Hello World não precisa de classe nem de função `main`, como em
[Python](../python/README.md). O Node.js acrescenta a parte orientada a
eventos: ele é "an asynchronous event-driven JavaScript runtime" [2]
(tradução livre: "um runtime JavaScript assíncrono e orientado a
eventos"), e as versões [web](web/) e [desktop](desktop/) apenas registram
funções que são chamadas depois, quando os eventos acontecem.

Ver também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | Node.js | ✅ |
| desktop | [desktop/](desktop/) | Electron | ✅ |
| web | [web/](web/) | Express | ✅ |

## Histórico
O **JavaScript** veio primeiro. O padrão ECMAScript diz: "The language was
invented by Brendan Eich at Netscape and first appeared in that company's
Navigator 2.0 browser" [1] (tradução livre: "A linguagem foi inventada por
Brendan Eich na Netscape e apareceu pela primeira vez no navegador
Navigator 2.0 dessa empresa"). Eich escreveu em 2008 que "Mocha", seu
primeiro nome, "had proven itself via rapid prototyping and embedding in
Netscape Navigator 2.0" [3] (tradução livre: "tinha se provado por meio de
prototipação rápida e da incorporação ao Netscape Navigator 2.0"). Para
torná-lo um padrão comum a todos os navegadores, a Ecma International
adotou a primeira edição do ECMA-262 em junho de 1997 [1][4]. A 17ª
edição, ECMAScript 2026, foi publicada em junho de 2026 [4].

O **Node.js** executa JavaScript fora do navegador, como um programa
comum no computador. Seu repositório começa com dois commits de Ryan Dahl
em 2009-02-16, "add dependencies" e "add readme and initial code" [5]. O
Node.js é construído sobre o V8, o motor JavaScript do Google Chrome [6],
e foi projetado em torno de eventos em vez de threads: "users of Node.js
are free from worries of dead-locking the process, since there are no
locks" (tradução livre: "os usuários do Node.js ficam livres da
preocupação de travar o processo em deadlock, pois não há locks"), e ele
foi "influenced by, systems like Ruby's Event Machine and Python's
Twisted" [2] (tradução livre: "influenciado por sistemas como o Event
Machine do Ruby e o Twisted do Python").

O **npm**, o gerenciador de pacotes instalado com o Node.js, surgiu no
mesmo ano: "npm was created by Isaac Z. Schlueter in 2009" [7] (tradução
livre: "o npm foi criado por Isaac Z. Schlueter em 2009"). As versões
[web](web/) e [desktop](desktop/) o usam para baixar o Express e o
Electron.

Em 2015 o projeto foi dividido em dois e depois reunificado. Um fork
chamado **io.js** "inherits the majority of the changes found in the v0.11
branch of the joyent/node repository" [8] (tradução livre: "herda a maior
parte das mudanças do branch v0.11 do repositório joyent/node"). Em maio
de 2015, "the io.js TC voted to join in the Foundation effort" [9]
(tradução livre: "o TC do io.js votou por aderir ao esforço da
Fundação"), e o Node.js 4.0.0 (2015-09-08) "represents countless hours of
hard work encapsulated in both the Node.js project and the io.js project
that are now combined in a single codebase" [10] (tradução livre:
"representa incontáveis horas de trabalho árduo reunidas no projeto Node.js
e no projeto io.js, agora combinados em uma única base de código"), sob a
nova Node.js Foundation [11]. Em 2019, "The Node.js Foundation and the JS
Foundation ... announced they are merging to form the OpenJS Foundation"
[12] (tradução livre: "A Node.js Foundation e a JS Foundation ...
anunciaram sua fusão para formar a OpenJS Foundation"), que hoje abriga o
Node.js, o Express e o Electron [13].

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1995 | Brendan Eich, que estava "studying Java in April and May 1995" (tradução livre: "estudando Java em abril e maio de 1995"), cria o JavaScript ("Mocha") na Netscape; ele aparece pela primeira vez no Navigator 2.0 | [1][3] |
| junho de 1997 | ECMA-262, 1ª edição: o JavaScript se torna o padrão ECMAScript | [1][4] |
| 2009-02-16 | Primeiros commits do Node.js, de Ryan Dahl | [5] |
| 2009-09-29 | Primeiro commit do npm, de Isaac Z. Schlueter | [7][14] |
| 2015-06-16 | Node.js Foundation: "The Node.js and io.js Technical Committees are merging" (tradução livre: "Os Comitês Técnicos do Node.js e do io.js estão se fundindo") | [11] |
| 2015-09-08 | Node.js 4.0.0: Node.js e io.js combinados em uma única base de código | [10] |
| 2015-10-12 | Node.js 4.2.0 "Argon", "the first release covered under the new Long Term Support plan" (tradução livre: "a primeira versão coberta pelo novo plano de suporte de longo prazo") | [15] |
| 2019-03-12 | A Node.js Foundation e a JS Foundation se fundem na OpenJS Foundation | [12] |
| 2019-11-21 | O Node.js 13.2.0 remove a flag `--experimental-modules`: módulos ES (`import`) sem flag | [16] |
| 2024-12-03 | Node.js 22.12.0: "require(esm) is now enabled by default" (tradução livre: "require(esm) agora é habilitado por padrão") | [17] |
| 2025-11-11 | Node.js 25.2.0: o "type stripping" de TypeScript é marcado como estável (`node file.ts` executa TypeScript) | [18] |
| 2026-10-28 | **O Node.js 26 (usado aqui) se torna LTS**, com o codinome "Lithium", suportado até abril de 2029 | [19][20] |

A partir do Node.js 27, o calendário muda: "the release cycle will be
annual and every major version will move to LTS status after its
six-month Current phase" [20] (tradução livre: "o ciclo de lançamentos
será anual e toda versão principal passará ao status LTS após sua fase
Current de seis meses"). Até o Node.js 26, apenas as versões de número
par se tornavam LTS [20], e "Production applications should only use
Active LTS or Maintenance LTS releases" [20] (tradução livre: "Aplicações
em produção devem usar apenas versões Active LTS ou Maintenance LTS").

## Uso no mercado hoje
Cada número abaixo tem data e fonte. Eles mudam a cada ano.

- **Stack Overflow Developer Survey 2026:** 62,0% de todos os
  respondentes da pergunta sobre linguagens de programação usaram
  JavaScript (8.742 de 14.099), "at the top of the list for 12th year in a
  row" (tradução livre: "no topo da lista pelo 12º ano consecutivo"); o
  TypeScript, 43,8% [21]. Na pergunta sobre frameworks e tecnologias web,
  46,4% usaram o Node.js (4.769 de 10.281); a pesquisa resume: "46% have
  used Node and 42% have used React" [21] (tradução livre: "46% usaram o
  Node e 42% usaram o React"). 46,1% dos usuários do Node.js querem
  continuar a usá-lo ("admired", admirado) [21].
- **Índice TIOBE, outubro de 2026:** o JavaScript é o nº 6, com taxa de
  2,77%, a mesma posição de outubro de 2025 [22].
- **Onde é usado:** o Node.js executa servidores como a versão
  [web](web/); o Electron, construído sobre o Node.js, é usado por
  aplicações desktop como VS Code, Slack, Discord e Figma, segundo a
  própria lista do Electron [23]. Essa lista é um depoimento do projeto,
  não uma pesquisa independente.

## Importância antes e agora
- **Antes (2009):** o JavaScript era a linguagem do navegador. O Node.js
  permitiu que a mesma linguagem executasse servidores e ferramentas de
  linha de comando, construídos em torno de eventos em vez de chamadas
  bloqueantes: "Almost no function in Node.js directly performs I/O, so
  the process never blocks except when the I/O is performed using
  synchronous methods" [2] (tradução livre: "Quase nenhuma função do
  Node.js realiza E/S diretamente, de modo que o processo nunca bloqueia,
  exceto quando a E/S é feita com métodos síncronos").
- **O npm** transformou isso em um ecossistema: um comando instala uma
  biblioteca na própria pasta `node_modules/` do projeto, como mostram as
  versões [web](web/) e [desktop](desktop/).
- **Agora:** o JavaScript é a linguagem mais usada na pesquisa do Stack
  Overflow pelo 12º ano consecutivo, e 46,4% dos respondentes usaram o
  Node.js (2026) [21]. A mesma linguagem hoje é executada no navegador, no
  servidor (Express) e no desktop (Electron).
- **No ensino:** o Hello World `cli` tem uma linha, como o do Python. As
  outras duas versões mostram cedo como é a maior parte do código
  JavaScript: callbacks, eventos e Promises, em vez de um programa que é
  executado de cima para baixo e termina.

## Comparação entre as categorias
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Linhas de JavaScript (sem comentários e sem linhas em branco) | 1 | 32 (14 são da autoverificação) + `index.html` | 12 |
| Biblioteca | nenhuma (`console` é global) | Electron 45.2.1 | Express 5.3.0 |
| `package.json` / `node_modules/` | nenhum | sim / cerca de 284 MB (quase tudo é o programa Electron) | sim / cerca de 3,8 MB (o Express e os 64 pacotes de que ele precisa) |
| Qual Node.js executa o código | o `node` instalado (26.8.2) | o Node.js **do próprio Electron**, 24.22.1, mais o Chromium 156 para a página | o `node` instalado (26.8.2) |
| Etapa de build | nenhuma | nenhuma (o empacotamento com o Electron Forge é opcional) | nenhuma |
| Quem controla o laço | o Node.js: nada está agendado, então ele termina após o `console.log` | o laço de eventos do Electron (eventos da janela) | o laço de eventos do Node.js, mantido ativo pelo servidor que escuta a porta |
| Saída | texto na saída padrão | uma janela com uma página HTML | HTML enviado pelo servidor |

Tamanhos obtidos com `du -sh` e versões obtidas com `process.versions` no
macOS Intel (2026-10-31).

O que permanece igual: nenhuma versão tem etapa de compilação, todas são
JavaScript executado pelo V8, e o código é escrito como funções que o
Node.js (ou o Electron) chama. O que muda é o que é instalado ao lado do
código: nada para `cli`, um framework pequeno para `web` e um motor de
navegador inteiro para `desktop`. Compare com [Go](../go/README.md), em que
cada categoria é compilada em um único executável, e com
[Python](../python/README.md), cujo toolkit desktop (`tkinter`) vem com a
linguagem.

O Node.js tem uma implementação em cada uma de suas três categorias (a
versão desktop usa o Electron; ver
[desktop/README.md](desktop/README.md#why-this-toolchain)); por isso, esta
página não tem uma seção que explique uma categoria ausente.

## Fontes
1. ECMAScript Language Specification (Introduction; Overview). Ecma TC39. <https://tc39.es/ecma262/> (acessado em 2026-10-31)
2. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (acessado em 2026-10-31)
3. Popularity. Brendan Eich, 2008-04-03. <https://brendaneich.com/2008/04/popularity/> (acessado em 2026-10-31)
4. ECMA-262 (editions list). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-262/> (acessado em 2026-10-31)
5. Commit 9d7895c ("add dependencies"), 2009-02-16, and the commit history of nodejs/node. GitHub. <https://github.com/nodejs/node/commit/9d7895c567e8f38abfff35da1b6d6d6a0a06f9aa> (acessado em 2026-10-31)
6. V8 JavaScript engine (home page). The V8 Project Authors. <https://v8.dev/> (acessado em 2026-10-31)
7. "npm, Inc. and Scalenpm". npm Blog, 2014-09-11. <https://blog.npmjs.org/post/97261727560/npm-inc-and-scalenpm.html> (acessado em 2026-10-31)
8. io.js changelog. nodejs/node (GitHub). <https://github.com/nodejs/node/blob/main/doc/changelogs/CHANGELOG_IOJS.md> (acessado em 2026-10-31)
9. Node.js and io.js leaders are building an open, neutral Node.js Foundation to support the future of the platform. Mike Dolan, Node.js Blog, 2015-05-15. <https://nodejs.org/en/blog/community/node-leaders-building-open-neutral-foundation> (acessado em 2026-10-31)
10. Node.js 4.0.0 (Current). Node.js Blog, 2015-09-08. <https://nodejs.org/en/blog/release/v4.0.0> (acessado em 2026-10-31)
11. Node.js Foundation Advances Community Collaboration, Announces New Members and Ratified Technical Governance. The Linux Foundation, 2015-06-16. <https://www.linuxfoundation.org/press-release/node-js-foundation-advances-community-collaboration-announces-new-members-and-ratified-technical-governance> (acessado em 2026-10-31)
12. Node.js Foundation and JS Foundation Merge to Form OpenJS Foundation. The Linux Foundation, 2019-03-12. <https://www.linuxfoundation.org/press/press-release/node-js-foundation-and-js-foundation-merge-to-form-openjs-foundation> (acessado em 2026-10-31)
13. Projects. OpenJS Foundation. <https://openjsf.org/projects> (acessado em 2026-10-31)
14. Commit 4626dfa ("Initial drop."), 2009-09-29. npm/cli (GitHub). <https://github.com/npm/cli/commit/4626dfa73b7847e9c42c1f799935f8242794d020> (acessado em 2026-10-31)
15. Node.js 4.2.0 (LTS). Node.js Blog, 2015-10-12. <https://nodejs.org/en/blog/release/v4.2.0> (acessado em 2026-10-31)
16. Node.js 13.2.0 (Current). Node.js Blog, 2019-11-21. <https://nodejs.org/en/blog/release/v13.2.0> (acessado em 2026-10-31)
17. Node.js 22.12.0 (LTS). Node.js Blog, 2024-12-03. <https://nodejs.org/en/blog/release/v22.12.0> (acessado em 2026-10-31)
18. Node.js 25.2.0 (Current). Node.js Blog, 2025-11-11. <https://nodejs.org/en/blog/release/v25.2.0> ; Modules: TypeScript (history). Node.js Documentation. <https://nodejs.org/api/typescript.html> (acessado em 2026-10-31)
19. Node.js 26.13.0 (LTS). Node.js Blog, 2026-10-28. <https://nodejs.org/en/blog/release/v26.13.0> (acessado em 2026-10-31)
20. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> and Node.js Release Working Group schedule. <https://github.com/nodejs/Release> (acessado em 2026-10-31)
21. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
22. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
23. Electron home page ("Apps users love, built with Electron"). Electron. <https://www.electronjs.org/> (acessado em 2026-10-31)
