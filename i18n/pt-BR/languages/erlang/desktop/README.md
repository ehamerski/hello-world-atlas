---
source: languages/erlang/desktop/README.md
source_sha: 021d9463d0ab52477ab8396a0782407d866cbf76
---
# Erlang · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Erlang](../README.md)

## O que é
Um programa desktop que abre uma pequena janela intitulada "Hello, World!"
com o texto **Hello, World!** no meio. A janela é desenhada pelo **wx**, que
a documentação do Erlang descreve assim: "The wx application is an erlang
binding of `wxWidgets`" [1] (tradução livre: "A aplicação wx é um binding
Erlang do `wxWidgets`"). O `wxWidgets` é uma biblioteca C++ que "gives you a
single, easy-to-use API for writing GUI applications on multiple platforms"
[2] (tradução livre: "oferece uma única API fácil de usar para escrever
aplicações GUI em várias plataformas"). No macOS, ele entrega "Cocoa-based
applications" [2] (tradução livre: "aplicações baseadas em Cocoa"), de modo
que a janela é nativa.

O wx faz parte do Erlang/OTP: nada é baixado, ao contrário da biblioteca
Flask da versão [Python web](../../python/web/). O programa é um **módulo**
compilado: o `erlc` transforma o `hello_wx.erl` em `ebin/hello_wx.beam`, e o
`erl` o executa. Compare com a versão [cli](../cli/), que é um escript e não
precisa de build.

O Erlang não tem uma chamada `mainloop()` como a versão [Python
desktop](../../python/desktop/). O programa é o seu próprio laço de eventos:
um processo que recebe mensagens, uma das quais informa que o usuário fechou
a janela.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Erlang/OTP (`erl`, `erlc`) | 29.1.2 (`erlang` 29.1.2 do Homebrew), como em [../cli](../cli/README.md#prerequisites) | compila o módulo e o executa na BEAM |
| Aplicação `wx` | 2.7, parte do Erlang/OTP 29.1.2 | o binding para o `wxWidgets` |
| `wxWidgets` | 3.2.12 (`wxwidgets@3.2` do Homebrew, instalado como dependência do `erlang`) | o toolkit C++ que desenha a janela |
| Uma sessão gráfica | desktop do macOS | uma janela não abre por uma conexão SSH simples nem em um job sem display |

Em Macs Intel, o Homebrew não tem pacote pré-compilado (bottle) para o
`erlang` [3]. Assim, o `brew install erlang` compila o Erlang e sua
dependência `wxwidgets@3.2` a partir do código-fonte. Na máquina de teste
(2026-11-01), o Erlang levou cerca de 15 minutos, mais cerca de 7 minutos
para o `wxWidgets`. A aplicação `wx` está incluída no pacote do Homebrew. No
Debian, ela é um pacote separado, o `erlang-wx` [4].

## Início rápido
```sh
./install.sh   # check / install Erlang/OTP and wx (asks before installing)
./build.sh     # erlc: hello_wx.erl -> ebin/hello_wx.beam
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `erl`, `erlc` e a aplicação `wx` (o `code:lib_dir(wx)` falha quando ela não existe). Se algo estiver faltando, oferece `brew install erlang` (macOS), `apt-get install erlang erlang-wx` (Debian) ou explica como obter o instalador para Windows [4][5], e só executa uma instalação se você responder `y`. | A compilação precisa do compilador, e a execução precisa do `wx`. |
| `build.sh` | Executa `erlc -Wall -o ebin hello_wx.erl`. | A BEAM executa bytecode, não código-fonte. Para um arquivo `.erl`, o `erlc` "generates a `.beam` file" [6] (tradução livre: "gera um arquivo `.beam`"). O `-o` é "The directory where the compiler is to place the output files" [6] (tradução livre: "O diretório em que o compilador deve colocar os arquivos de saída"). O `-Wall` ativa todos os avisos (veja `erlc -h`). |
| `run.sh` | Executa `erl +Bd -noshell -pa ebin -s hello_wx main -s init stop`. Com `--verify`, define `TF_VERIFY=1`: o app imprime `Hello, World!` quando a janela é exibida e se fecha sozinha após cerca de 2 segundos. | O `--verify` permite que o `scripts/verify-all.sh` verifique um programa GUI sem uma pessoa. |

As opções do `erl` no `run.sh` [7]:

- `-noshell`: "Starts an Erlang runtime system with no shell" (tradução
  livre: "Inicia um sistema de runtime do Erlang sem shell"), de modo que o
  terminal fica livre.
- `-pa ebin`: "Adds the specified directories to the beginning of the code
  path" (tradução livre: "Adiciona os diretórios especificados ao início do
  caminho de código"), de modo que o `erl` encontra o `hello_wx.beam`.
- `-s hello_wx main`: "Makes `init` call the specified function" (tradução
  livre: "Faz o `init` chamar a função especificada"): aqui,
  `hello_wx:main()`.
- `-s init stop`: quando `main/0` retorna, `init:stop()` encerra a máquina
  virtual.
- `+Bd`: "disables the break handler" (tradução livre: "desativa o tratador
  de interrupção"), de modo que o Ctrl+C não é capturado pelo menu de
  interrupção do emulador.

## Estrutura de pastas
```text
desktop/
├── README.md        this file
├── install.sh       checks / installs Erlang/OTP and wx
├── build.sh         erlc -> ebin/hello_wx.beam
├── run.sh           runs hello_wx:main()
├── hello_wx.erl     the program (teaching comments)
├── screenshot.png   the window on macOS (used below)
├── .gitignore       keeps ebin/ and *.beam out of Git
└── ebin/            created by build.sh; not committed
    └── hello_wx.beam
```
- `ebin/` é a pasta do código compilado no layout que o Erlang/OTP documenta
  para uma aplicação: "`ebin` - Required. Contains the Erlang object code,
  the `.beam` files" [8] (tradução livre: "`ebin` - Obrigatória. Contém o
  código objeto do Erlang, os arquivos `.beam`").

## Passo a passo
Abra o [`hello_wx.erl`](hello_wx.erl) ao lado desta lista.

1. **`-module(hello_wx).`** dá nome ao módulo. O nome deve ser o nome do
   arquivo sem `.erl`. `-export([main/0]).` torna `main/0` chamável de fora,
   o que o `run.sh` exige.
2. **`-include_lib("wx/include/wx.hrl").`** lê um arquivo de cabeçalho com as
   constantes e os registros do `wx`, como `?wxID_ANY` e o registro `#wx{}`.
   O `?` marca uma macro. O `-include_lib` encontra o arquivo dentro da
   aplicação `wx` instalada, como o `#include <...>` em C.
3. **`Wx = wx:new(),`** inicia o `wx` e devolve uma referência a ele. `Wx`
   começa com letra maiúscula, de modo que é uma variável, e "a variable can
   only be bound once" [9] (tradução livre: "uma variável só pode ser
   vinculada uma vez"). A vírgula encerra uma expressão e inicia a próxima.
4. **`wxFrame:new(Wx, ?wxID_ANY, "Hello, World!")`** cria a janela de nível
   superior com seu título. `?wxID_ANY` significa que o programa não se
   importa com o identificador da janela. O `wxWidgets` original "is an
   object-oriented (C++) API and that is reflected in the erlang mapping" [1]
   (tradução livre: "é uma API orientada a objetos (C++) e isso se reflete
   no mapeamento para Erlang"): `wxFrame` é a classe C++, e o módulo tem uma
   função para cada um de seus métodos. Uma string entre aspas duplas é uma
   lista de caracteres [10].
5. **`wxStaticText:new(Frame, ?wxID_ANY, "Hello, World!")`** cria um rótulo,
   um texto que o usuário não pode editar.
6. **O sizer.** Um sizer organiza os widgets de uma janela. Um sizer de caixa
   vertical os empilha. Um espaçador elástico acima e outro abaixo do rótulo
   o colocam no meio, e o flag `?wxALIGN_CENTER_HORIZONTAL` o centraliza de um
   lado a outro. As opções são uma lista de tuplas `{Key, Value}`. Tuplas
   usam chaves e listas usam colchetes [10]. `wxWindow:setSizer/2` entrega o
   sizer à janela, e `wxWindow:setClientSize/3` define o tamanho da área
   interna como 320 por 120 pixels.
7. **`wxFrame:connect(Frame, close_window)`** pede o evento de fechamento. A
   documentação diz: "The callback fun is optional, if not supplied the event
   will be sent to the process that called connect/2" [1] (tradução livre:
   "A fun de callback é opcional; se não for fornecida, o evento será
   enviado ao processo que chamou connect/2"). Aqui não há callback, de modo
   que o evento chega como uma mensagem na caixa de correio do processo que
   executa `main/0`. O `connect/2` não fecha nada por si só.
8. **`wxFrame:show(Frame)`** torna a janela visível.
9. **A autoverificação.** `os:getenv("TF_VERIFY")` devolve o texto da
   variável, ou `false` quando ela não está definida. Uma expressão `case`
   escolhe por padrão: "The expression `Expr` is evaluated and the patterns
   `Pattern` are sequentially matched against the result" [9] (tradução
   livre: "A expressão `Expr` é avaliada e os padrões `Pattern` são
   comparados sequencialmente com o resultado"). Com `"1"`, o programa
   imprime `Hello, World!` e envia a si mesmo o átomo `verify_done` após
   2000 ms com `erlang:send_after/3`. Caso contrário, não faz nada. Um átomo
   é "a literal, a constant with a name" [10] (tradução livre: "um literal,
   uma constante com um nome").
10. **`loop(Frame)`** é o laço de eventos. O `receive` espera por uma
    mensagem: "The `receive` expression searches for a message in the message
    queue that matches one of the patterns" [9] (tradução livre: "A
    expressão `receive` procura na fila de mensagens uma mensagem que
    corresponda a um dos padrões"). Há três padrões:
    - `#wx{event = #wxClose{}}` corresponde a um registro de evento do wx que
      contém um evento de fechamento. Ele destrói a janela e a função
      retorna.
    - `verify_done` também destrói a janela.
    - `_Other` corresponde a qualquer outra coisa, e a função chama a si
      mesma. O Erlang não tem laço `while`: uma função se repete chamando a
      si mesma. Cada processo tem sua própria fila de mensagens [11], e o
      `receive` retira a primeira mensagem que corresponde.
11. **`wx:destroy()`** encerra o servidor `wx` depois do laço, e `main/0`
    retorna. O `run.sh` então chama `init:stop()`.

**Experimente:** altere o texto nas duas strings e os números em
`setClientSize`, e execute `./build.sh && ./run.sh`.

## Comparando com o cli
| | [cli](../cli/) | desktop |
|---|---|---|
| Código-fonte | um escript, `hello.erl` | um módulo, `hello_wx.erl`, com `-module` e `-export` |
| Build | nenhum: o `escript` compila na memória [12] | o `erlc` grava `ebin/hello_wx.beam` |
| Executar com | `escript hello.erl` | `erl -noshell -pa ebin -s hello_wx main -s init stop` |
| Bibliotecas | `io` da biblioteca padrão | `wx`, o binding do `wxWidgets` |
| Saída | uma linha no terminal | um rótulo em uma janela nativa |
| Termina | após a última expressão | quando a mensagem de fechamento chega |

## Por que esta toolchain
- **O wx acompanha o Erlang/OTP.** É o toolkit de GUI da distribuição do
  Erlang, de modo que a versão não exige download [1].
- **Usa janelas nativas.** O `wxWidgets` usa "the native platform's controls
  and utilities" [2] (tradução livre: "os controles e utilitários da
  plataforma nativa"), de modo que a janela se parece com as outras janelas
  do sistema operacional.
- **Um módulo e o `erlc`** mostram como o código Erlang normalmente é
  compilado, o que o escript da versão [cli](../cli/) esconde.
- **O custo: a primeira instalação.** Em um Mac Intel, o `wxwidgets@3.2` é
  compilado a partir do código-fonte junto com o Erlang (veja
  [Pré-requisitos](#pré-requisitos)).

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Erlang/OTP 29.1.2, `wx` 2.7, `wxWidgets` 3.2.12 do Homebrew. A barra de título da janela está cinza na captura de tela porque a janela não era a ativa. |
| macOS Apple Silicon | ⚠️ não verificado | O `brew install erlang` instala um bottle [3]. Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `erlang` e `erlang-wx` com o apt quando `erl`, `erlc` ou a aplicação `wx` não existe [4]. A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` extrai o zip oficial de 64 bits do Erlang/OTP em `~/.local/otp-29.1.2` quando ele não existe, como em [../cli](../cli/README.md#platform-notes). O zip inclui o `wx` [5]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` abre esta janela:

![A janela do wx intitulada "Hello, World!" exibindo o texto "Hello, World!" no meio](screenshot.png)

(Capturada em 2026-11-04 em macOS Intel, capturando somente a janela.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: wx asks `wxWidgets` for a native window; the program then waits for its close message.
Hello, World!
```
A janela se fecha sozinha após cerca de 2 segundos.

## Fontes
1. wx (chapter). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (acessado em 2026-11-04)
2. About `wxWidgets`. `wxWidgets`. <https://www.wxwidgets.org/about/> (acessado em 2026-11-04)
3. `erlang` formula. Homebrew. <https://formulae.brew.sh/formula/erlang> (acessado em 2026-11-04)
4. `erlang-wx` package in Debian stable. Debian. <https://packages.debian.org/stable/erlang-wx> (acessado em 2026-11-04)
5. Downloads. Ericsson AB, erlang.org. <https://www.erlang.org/downloads> (acessado em 2026-11-04)
6. erlc. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erlc_cmd.html> (acessado em 2026-11-04)
7. `erl` (`-noshell`, `-pa`, `-s`, `+B`). Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/erl_cmd.html> (acessado em 2026-11-04)
8. Applications (directory structure, `ebin`). Erlang/OTP documentation, Design Principles. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/applications.html> (acessado em 2026-11-04)
9. Expressions (variables, `case`, `receive`). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (acessado em 2026-11-04)
10. Data types (atom, tuple, list, string). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/data_types.html> (acessado em 2026-11-04)
11. Conc prog (processes and message passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (acessado em 2026-11-04)
12. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (acessado em 2026-11-04)
