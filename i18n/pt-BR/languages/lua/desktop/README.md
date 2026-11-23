---
source: languages/lua/desktop/README.md
source_sha: bdb574729415f86153bd51ea71b22a491fa9ac90
---
# Lua · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Lua](../README.md)

## O que é
Um programa desktop que abre uma janela pequena com o título "Hello, World!"
e o texto **Hello, World!** no meio. A janela é desenhada pelo LÖVE (também
escrito Love2D), que se descreve como "a framework you can use to make
2D games in Lua" [1] (tradução livre: "um framework que você pode usar para
criar jogos 2D em Lua"). O Lua não tem um toolkit de janelas próprio, de modo
que um programa precisa de um hospedeiro que ofereça um.

**Esta implementação é um compromisso.** O [`../cli`](../cli/README.md) e o
[`../web`](../web/README.md) executam no Lua 5.5, a versão atual [2]. O LÖVE
11.5 embute o LuaJIT, uma implementação separada da linguagem que é "fully
upwards-compatible with Lua 5.1" [3] (tradução livre: "totalmente compatível
com o Lua 5.1, para versões posteriores"). Assim, o `main.lua` executa no
dialeto Lua 5.1, e não no Lua 5.5. O programa imprime a sua versão do Lua ao
iniciar (veja [Saída esperada](#saída-esperada)): `Lua 5.1` e uma versão do
LuaJIT. O código do Hello World é o mesmo nos dois dialetos: só a versão
difere.

O LÖVE funciona em um estilo diferente do [`../cli`](../cli/README.md). O
programa não inicia a janela e não executa um laço. O LÖVE é o programa: ele
inicia, lê o `conf.lua`, cria a janela e então executa o seu próprio laço
principal, que chama funções que o programa define com nomes fixos
(`love.load`, `love.update`, `love.draw`) [4]. Este é o modelo de *callback*:
o programa fornece as funções, e o framework decide quando chamá-las.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| LÖVE (`love`) | 11.5, o zip oficial do macOS [5] | executa o `main.lua`; contém o LuaJIT e o código de janelas e gráficos |
| curl | curl do sistema | apenas para o `install.sh`, que baixa o zip |
| `shasum`, `unzip` | ferramentas do sistema | o `install.sh` confere o checksum e descompacta o zip |

O programa `lua` do [`../cli`](../cli/README.md) não é necessário: o LÖVE tem
a sua própria cópia da linguagem.

## Início rápido
```sh
./install.sh   # check LÖVE; on macOS download it into vendor/ (asks first)
./run.sh       # open the window; close it to end the program
```
`./run.sh --verify` é uma autoverificação: abre a janela, imprime
`Hello, World!` e fecha a janela após cerca de 2 segundos.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `love-env.sh` | Define a versão do LÖVE (11.5), o endereço de download, o checksum SHA-256 do zip e o caminho do programa `love`. É incluído (`source`) pelos outros dois scripts, e não executado. | O `install.sh` e o `run.sh` precisam concordar com esses valores, por isso eles ficam em um único arquivo. |
| `install.sh` | 1. Verifica se o `love` pode ser executado. 2. No macOS: pergunta, baixa o `love-11.5-macos.zip` dos releases do LÖVE no GitHub para `vendor/`, confere o checksum e descompacta o `love.app` ali. No Debian e no Ubuntu: executa `sudo apt-get install -y love` após perguntar. No Windows: mostra onde baixar o LÖVE. | O LÖVE não faz parte do Lua, e cada sistema o empacota de um modo diferente. O download no macOS fica dentro desta pasta: nada vai para `/Applications`, e não é preciso `sudo`. |
| `run.sh` | Executa `love .`, que inicia o LÖVE nesta pasta. Com `--verify`, define antes `TF_VERIFY=1`. | O LÖVE recebe como argumento uma pasta com um `main.lua`. O `main.lua` lê `TF_VERIFY` e, quando vale `1`, imprime a saudação e encerra após cerca de 2 segundos, de modo que o `scripts/verify-all.sh` não espera uma pessoa fechar a janela. |

Não há `build.sh`: o LÖVE executa o código-fonte Lua diretamente, como no
[cli](../cli/README.md#why-there-is-no-build-step).

A página de releases do LÖVE não publica um checksum para o zip. O checksum
em `love-env.sh` foi calculado a partir do download e comparado com o que o
cask `love` do Homebrew lista para o mesmo arquivo [6].

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks / downloads LÖVE
├── run.sh           opens the window
├── love-env.sh      version, address, and checksum of LÖVE (sourced)
├── main.lua         the program: love.load, love.update, love.draw
├── conf.lua         window settings: love.conf
├── screenshot.png   the window, for "Expected output" below
├── .gitignore       keeps vendor/ out of git
└── vendor/          created by install.sh (the zip and love.app); not committed
```
- Um programa LÖVE é uma pasta com um `main.lua` no nível superior. O LÖVE
  informa "No code to run" e o conselho de "Make sure main.lua is at the
  top level" quando ele falta [7] (tradução livre: "Nenhum código para
  executar" e "Certifique-se de que o main.lua esteja no nível superior").
- O `conf.lua` é opcional. Quando existe, o LÖVE o carrega antes de criar a
  janela, de modo que ele pode alterar as configurações da janela [7].
- Jogos maiores adicionam pastas para imagens, sons e módulos Lua; uma única
  janela precisa apenas destes dois arquivos.

## Passo a passo
Abra o [`main.lua`](main.lua) e o [`conf.lua`](conf.lua) ao lado desta lista.

1. **`conf.lua`: `function love.conf(t) ... end`.** O LÖVE executa este
   arquivo primeiro. Ele chama `love.conf` com uma tabela `t` que guarda as
   configurações padrão, e a função altera apenas o que precisa [7]. Aqui ela
   define o título e o tamanho da janela (480 por 200 pixels). Uma *tabela* é
   a única estrutura de dados do Lua, e `t.window.title` lê um campo de um
   campo dela.
2. **`local verify = os.getenv("TF_VERIFY") == "1"`** lê uma variável de
   ambiente. Ela é `true` apenas na autoverificação do `run.sh --verify`.
3. **`function love.load()`** é chamada uma vez, depois que a janela existe
   [4]. Ela imprime `_VERSION` e `jit.version`, que mostram o dialeto do
   compromisso (o segundo valor existe apenas no LuaJIT). Em seguida, cria
   uma fonte de 32 pixels e a torna a fonte atual com
   `love.graphics.setFont`.
4. **`function love.update(dt)`** é chamada a cada quadro com `dt`, os
   segundos desde o quadro anterior [4]. Um jogo mantém a sua lógica aqui. A
   saudação não tem nenhuma; a função apenas conta os segundos no modo de
   verificação e chama `love.event.quit()` depois de dois deles.
5. **`function love.draw()`** é chamada a cada quadro depois de
   `love.update` [4]. O LÖVE limpa a janela antes de cada chamada, de modo
   que a função desenha tudo de novo. `love.graphics.printf("Hello, World!",
   0, y, width, "center")` desenha o texto em uma caixa da largura da janela,
   centralizado, e `y` coloca uma linha de texto no meio vertical.
6. **Por que uma função executada 60 vezes por segundo desenha uma única
   frase.** Um toolkit desktop como o tkinter ([Python](../../python/desktop/README.md))
   ou o Swing ([Java](../../java/desktop-swing/README.md)) constrói uma
   árvore de widgets uma única vez e a mantém. Um laço de jogo não mantém
   widgets: ele redesenha a cena a cada quadro. É também por isso que o
   programa não tem uma chamada `mainloop()` ou `launch()`: o LÖVE é o dono
   do laço (veja a função `love.run` em [4]).

## Por que esta toolchain
- **O Lua não tem um toolkit de janelas padrão.** As bibliotecas padrão do
  manual de referência cobrem strings, tabelas, matemática, entrada e saída e
  o sistema operacional, e nenhuma desenha uma janela [2]. Um programa Lua
  que quer uma janela precisa de um hospedeiro que ofereça uma.
- **O LÖVE é um framework centrado no Lua.** Sua página inicial o apresenta
  como um framework para criar jogos 2D em Lua, livre e de código aberto,
  para Windows, macOS, Linux, Android e iOS, sob a licença zlib/libpng [1].
  Os autores do Lua escrevem que o Lua "is one of the leading scripting
  languages in game development" [8] (tradução livre: "é uma das principais
  linguagens de script no desenvolvimento de jogos"), de modo que um
  framework de jogos se encaixa em um dos principais usos da linguagem.
- **A versão 11.5** é a versão que o site do LÖVE oferece para download em
  2026-11-04 [1].
- **O compromisso.** O LÖVE 11.5 executa o LuaJIT, que implementa o Lua 5.1
  [3]. Este repositório não encontrou uma biblioteca de janelas para o Lua
  5.5 que pudesse documentar como mantida e verificar, e por isso o LÖVE foi
  mantido. A [visão geral](../README.md#comparing-the-categories) da
  linguagem registra a diferença.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | LÖVE 11.5 do zip oficial, descompactado em `vendor/`. O `run.sh` inicia o programa diretamente dentro do bundle do aplicativo. |
| macOS Apple Silicon | ⚠️ não verificado | O zip oficial é um aplicativo universal, de modo que os mesmos comandos devem valer. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `love` com o apt quando ele não existe [9]. A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ⚠️ não verificado | O `install.sh` baixa o zip oficial de 64 bits do LÖVE 11.5 [5] para `vendor/` e confere seu checksum SHA-256. O CI não o executa: o runner `windows-latest` do GitHub não tem GPU, e o LÖVE exige o OpenGL 2.1 ou posterior [10]. O WSL exige uma sessão gráfica (WSLg). |

## Saída esperada
`./run.sh` abre esta janela:

![A janela do LÖVE com o título "Hello, World!" mostrando o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura apenas essa janela. A janela tem 480 por 200 pontos, e a
imagem tem 960 por 456 pixels por causa da tela Retina.)

`./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: 'love .' starts LÖVE, which runs conf.lua and main.lua from this folder.
Lua 5.1	LuaJIT 2.1.1700008891
Hello, World!
```
A linha com as versões é impressa por `love.load`.

## Fontes
1. LÖVE: free 2D game engine. LÖVE Development Team. <https://love2d.org/> (acessado em 2026-11-04)
2. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (acessado em 2026-11-04)
3. LuaJIT Extensions. Mike Pall. <https://luajit.org/extensions.html> (acessado em 2026-11-04)
4. `src/modules/love/callbacks.lua`, tag 11.5 (function `love.run`). LÖVE. <https://github.com/love2d/love/blob/11.5/src/modules/love/callbacks.lua> (acessado em 2026-11-04)
5. LÖVE 11.5 release. LÖVE (GitHub). <https://github.com/love2d/love/releases/tag/11.5> (acessado em 2026-11-04)
6. love: Homebrew cask. Homebrew. <https://formulae.brew.sh/cask/love> (acessado em 2026-11-04)
7. `src/modules/love/boot.lua`, tag 11.5. LÖVE. <https://github.com/love2d/love/blob/11.5/src/modules/love/boot.lua> (acessado em 2026-11-04)
8. The Evolution of Lua. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. HOPL III, ACM, 2007. <https://www.lua.org/doc/hopl.pdf> (acessado em 2026-11-04)
9. love: Debian package. Debian. <https://packages.debian.org/stable/love> (acessado em 2026-11-04)
10. `readme.md`, tag 11.5 (Dependencies). LÖVE. <https://github.com/love2d/love/blob/11.5/readme.md> (acessado em 2026-11-05)
