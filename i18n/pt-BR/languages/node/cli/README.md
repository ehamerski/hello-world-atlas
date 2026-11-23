---
source: languages/node/cli/README.md
source_sha: 74cb4e66ee3e0719179c5f65094d28872412be17
---
# Node.js · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Node.js](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e uma
quebra de linha e, depois, termina. O programa é uma linha de JavaScript,
`console.log("Hello, World!");`, executada pelo **Node.js**, "an open-source
and cross-platform JavaScript runtime environment" [3] (tradução livre: "um
ambiente de execução JavaScript de código aberto e multiplataforma"). O
JavaScript foi criado para navegadores web; o Node.js o executa no
computador do usuário como qualquer outro programa de linha de comando.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Node.js (o comando `node`) | 26.8.2 (instalado com nvm) | o runtime que executa `hello.js` |

Qualquer versão do Node.js serve: este programa usa apenas `console.log`.
Nenhum pacote npm é necessário; por isso, não há `package.json` nem
`node_modules/`.

Na máquina de teste (macOS Intel), o Node.js foi instalado com o nvm, um dos
métodos de instalação listados em nodejs.org [6]. O `install.sh` oferece o
Homebrew no macOS, porque todas as outras implementações deste repositório
usam o Homebrew. A sua fórmula `node` estava na versão 26.13.0 em 2026-10-31
[5].

## Início rápido
```sh
./install.sh   # check / install Node.js (asks before installing)
./run.sh       # run it
```
Não há `build.sh` (ver [Por que não há etapa de compilação](#por-que-não-há-etapa-de-compilação)).

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se `node` está no `PATH` e imprime a sua versão. Se estiver ausente, mostra o comando de instalação para o sistema operacional (Homebrew no macOS, nodejs.org no Linux, `winget` no Windows) e só o executa se a resposta for `y`. | O programa não executa sem o runtime. |
| `run.sh` | Executa `node hello.js`. `--verify` faz o mesmo, porque um programa cli termina por conta própria. | Um único comando para os estudantes, com uma explicação do que acontece. |

## Estrutura de pastas
```text
cli/
├── README.md      this file
├── install.sh     checks / installs Node.js
├── run.sh         runs the program
└── hello.js       the program (one line of code plus teaching comments)
```
Um único arquivo `.js` é um programa Node.js completo: a página de
introdução de nodejs.org executa o seu primeiro exemplo com
`node server.js` [3]. Um arquivo `package.json` só é necessário quando um
projeto tem dependências ou scripts do npm, como em [`../web`](../web/) e
[`../desktop`](../desktop/).

## Passo a passo
Abra [`hello.js`](hello.js) ao lado desta lista.

1. **Comentários.** As linhas que começam com `//` são comentários, como em
   C, Java e Go. O JavaScript também tem comentários de bloco `/* ... */`. O
   Python usa `#`.
2. **Sem ponto de entrada.** O Node.js executa o arquivo de cima para
   baixo, como o Python. "Node.js simply enters the event loop after
   executing the input script" (tradução livre: "O Node.js simplesmente
   entra no laço de eventos depois de executar o script de entrada") e
   "exits the event loop when there are no more callbacks to perform" [1]
   (tradução livre: "sai do laço de eventos quando não há mais callbacks a
   executar"). Este script não agenda nada; por isso, o Node.js termina logo
   após a linha de `console.log`. C, Java e Go precisam de uma função
   `main`.
3. **Sem importação.** `console` é um objeto global, sempre disponível, o
   mesmo objeto que os navegadores web fornecem. `console.log` "prints to
   `stdout` with newline" [2] (tradução livre: "imprime em `stdout` com
   quebra de linha"), como o `print` do Python e o `println` do Java.
4. **O ponto e vírgula.** `;` encerra a instrução. O padrão ECMAScript diz
   que a maioria das instruções "must be terminated with a semicolon"
   (tradução livre: "deve ser terminada com ponto e vírgula"), mas "such
   semicolons may be omitted from the source text in certain situations"
   (tradução livre: "esses pontos e vírgulas podem ser omitidos do texto do
   código-fonte em certas situações") (inserção automática de ponto e
   vírgula) [8]. Escrevê-los evita a necessidade de aprender essas regras.
5. **Strings.** `"Hello, World!"` e `'Hello, World!'` são a mesma string em
   JavaScript, como no Python.

Compare com as outras versões do Node.js em [../README.md](../README.md#comparing-the-categories).

### Por que não há etapa de compilação
O JavaScript nunca é compilado manualmente: `node hello.js` lê o
código-fonte e o executa. Dentro do Node.js, o código é executado pelo
**V8**, "Google's open source high-performance JavaScript and WebAssembly
engine" (tradução livre: "o motor JavaScript e WebAssembly de código aberto
e alto desempenho do Google"), que "is used in Chrome and in Node.js" [7]
(tradução livre: "é usado no Chrome e no Node.js"). O V8 compila cada função
para "a concise bytecode" (tradução livre: "um bytecode conciso") para o seu
interpretador Ignition; depois, "the compiled code is analyzed during
runtime and optionally re-compiled dynamically" (tradução livre: "o código
compilado é analisado durante a execução e, opcionalmente, recompilado
dinamicamente") para código de máquina [7]. Tudo isso acontece na memória
enquanto o programa executa. É por isso que as versões `cli` de C, Go e Java
têm um `build.sh` e esta não tem. O Python funciona do mesmo modo do ponto
de vista do estudante (ver [../../python/cli](../../python/cli/README.md#why-there-is-no-build-step)).

## Por que esta toolchain
- O **Node.js** é um runtime JavaScript que executa fora do navegador, no
  macOS, no Linux e no Windows [3]. Ele foi usado por 46,4% dos respondentes
  da pergunta sobre frameworks e tecnologias web do Stack Overflow Developer
  Survey 2026 (base de 10.281) [9].
- **Versão:** o Node.js 26 é a linha "Active LTS" desde 2026-10-28 (nome de
  código Lithium) e tem suporte até 2029-04-30 [4]. "Production
  applications should only use _Active LTS_ or _Maintenance LTS_ releases"
  [4] (tradução livre: "Aplicações em produção devem usar apenas versões
  _Active LTS_ ou _Maintenance LTS_"). A máquina de teste tem a 26.8.2,
  lançada na mesma linha antes de ela se tornar LTS; `hello.js` executa sem
  alterações em qualquer versão.
- **`console.log`** em vez de `process.stdout.write("Hello, World!\n")`: os
  dois escrevem na saída padrão [2], mas `console.log` acrescenta a quebra
  de linha automaticamente e funciona do mesmo modo em um navegador web.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Node.js 26.8.2 (nvm). |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel (`brew install node`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Node.js: se o `node` não existe, ele imprime os passos do nodejs.org [6] e para. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Node.js: se o `node` não existe, ele imprime `winget install --id OpenJS.NodeJS.LTS -e` [10] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ node hello.js
Hello, World!
```
`./run.sh` imprime primeiro a sua explicação (linhas que começam com `==>` e
`WHY:`) e, depois, a mesma linha.

## Fontes
1. About Node.js. OpenJS Foundation. <https://nodejs.org/en/about> (acessado em 2026-10-31)
2. Console. Node.js v26 Documentation. <https://nodejs.org/api/console.html> (acessado em 2026-10-31)
3. Introduction to Node.js. Node.js Learn. <https://nodejs.org/en/learn/getting-started/introduction-to-nodejs> (acessado em 2026-10-31)
4. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> and Node.js Release Working Group schedule. <https://github.com/nodejs/Release> (acessado em 2026-10-31)
5. node formula. Homebrew. <https://formulae.brew.sh/formula/node> (acessado em 2026-10-31)
6. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (acessado em 2026-10-31)
7. V8 JavaScript engine (home page). The V8 Project Authors. <https://v8.dev/> ; Firing up the Ignition interpreter. V8 blog. <https://v8.dev/blog/ignition-interpreter> ; Sparkplug, a non-optimizing JavaScript compiler. V8 blog. <https://v8.dev/blog/sparkplug> (acessado em 2026-10-31)
8. ECMAScript 2026 Language Specification (ECMA-262, 17th edition), §12.10 Automatic Semicolon Insertion. Ecma International. <https://262.ecma-international.org/17.0/#sec-automatic-semicolon-insertion> (acessado em 2026-10-31)
9. 2026 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2026/technology> (acessado em 2026-10-31)
10. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (acessado em 2026-10-31)
