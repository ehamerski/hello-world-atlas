---
source: languages/python/desktop/README.md
source_sha: e800b430ffbde582dc4c1ddad515afab6cac8ff0
---
# Python · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Python](../README.md)

## O que é
Um programa desktop que abre uma janela nativa com o título **Hello, World!**
e o texto **Hello, World!** dentro dela. O programa termina quando a janela é
fechada. Ele usa o tkinter, o módulo de GUI que acompanha o Python.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Python 3 (`python3.14` no macOS, `python3` nos demais) | 3.14.10 (`python@3.14` do Homebrew) | executa `hello.py` |
| tkinter + Tcl/Tk | Tcl/Tk 9.1.0 (`python-tk@3.14` 3.14.10 e `tcl-tk` do Homebrew) | desenha a janela |
| uma sessão gráfica | desktop do macOS, desktop do Windows ou Linux com X11/Wayland | uma janela precisa de uma tela |

A documentação do Python diz: "Tcl/Tk 8.5.12 is the minimum supported
version; the official Python binary release bundles Tcl/Tk 9.0" [1]
(tradução livre: "O Tcl/Tk 8.5.12 é a versão mínima suportada; a versão
binária oficial do Python inclui o Tcl/Tk 9.0").

No macOS, os scripts chamam `python3.14`, e não `python3`. O `python@3.14` do
Homebrew coloca no PATH apenas nomes com versão; "Unversioned names such as
`python` ... are installed into `$(brew --prefix python)/libexec/bin`" [9]
(tradução livre: "Nomes sem versão, como `python` ..., são instalados em
`$(brew --prefix python)/libexec/bin`"), e um `python3` simples no macOS
costuma ser o `/usr/bin/python3` da Apple, mais antigo. O instalador do
python.org também fornece `python3.14`. Defina `PYTHON=python3` (ou qualquer
outro comando) para alterar esse comportamento.

## Início rápido
```sh
./install.sh   # check Python and tkinter (asks before installing)
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o interpretador (`python3.14` no macOS, `python3` nos demais). 2. Verifica se este Python consegue executar `import tkinter` e imprime sua versão do Tcl/Tk. Se o tkinter estiver ausente, mostra o pacote correto (`python-tk@3.14` no Homebrew, `python3-tk` no Debian/Ubuntu) e só o instala se a resposta for `y`. | O tkinter é "an optional module. If it is missing from your copy of CPython, look for documentation from your distributor" [1] (tradução livre: "um módulo opcional. Se estiver ausente na sua cópia do CPython, consulte a documentação do seu distribuidor"). O Homebrew o fornece como uma fórmula separada [2]; o Debian, como um pacote separado [3]. |
| `run.sh` | Executa `python3.14 hello.py` (macOS) ou `python3 hello.py`. `--verify` define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que sua janela é exibida e se fecha após 2 segundos. | Um comando para abrir a janela. A autoverificação permite que `scripts/verify-all.sh` teste uma GUI sem que ninguém clique. |

Não há `build.sh`, porque o Python é interpretado, como na
[versão cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
desktop/
├── README.md      this file
├── install.sh     checks Python and tkinter
├── run.sh         opens the window
└── hello.py       the program
```
Como a [versão cli](../cli/README.md#folder-structure), este é um único script,
e não um pacote para distribuição. O tkinter está na biblioteca padrão do
Python, portanto não há `requirements.txt` (compare com [../web](../web/README.md)).

## Passo a passo
Abra [`hello.py`](hello.py) ao lado desta lista.

1. **Importações.** `import tkinter as tk` carrega o módulo com um nome curto.
   `from tkinter import ttk` carrega os widgets com tema, cuja aparência
   "adapt[s] ... to the platform's native theme" [4] (tradução livre:
   "adapta-se ... ao tema nativo da plataforma").
2. **`root = tk.Tk()`** "initializes Tk and creates its associated Tcl
   interpreter. It also creates a toplevel window, known as the root
   window, which serves as the main window of the application" [1]
   (tradução livre: "inicializa o Tk e cria o interpretador Tcl associado. Também
   cria uma janela de nível superior, conhecida como janela raiz, que serve
   como janela principal da aplicação").
3. **`root.title(...)`** define o texto da barra de título.
4. **`ttk.Label(root, text="Hello, World!", padding=40)`** cria um rótulo
   dentro da janela raiz. `padding` acrescenta espaço para que a janela não
   fique minúscula.
5. **`label.pack()`**: "Creating a widget does not display it. A widget
   appears only after it has been handed to a geometry manager" [1]
   (tradução livre: "Criar um widget não o exibe. Um widget só aparece depois
   de ser entregue a um gerenciador de geometria"). `pack` é o gerenciador de
   geometria mais simples; `grid` e `place` são os outros.
6. **A autoverificação** (`if os.environ.get("TF_VERIFY") == "1":`) só executa
   com `./run.sh --verify`. `update()` faz o Tk processar todos os eventos
   pendentes, o que "bring[s] the application 'up to date'" [10] (tradução
   livre: "deixa a aplicação 'em dia'"), de modo que a janela é desenhada.
   `winfo_viewable()` é verdadeiro se a janela estiver "mapped" (tradução
   livre: "mapeada", isto é, exibida) [1]. Em seguida, o texto do rótulo é
   impresso e `after(2000, root.destroy)` fecha a janela 2000 ms depois. O
   método `wait_visibility()` [1] parece mais adequado, mas, com o Tk 9.1 no
   macOS, nunca retornou na máquina de desenvolvimento, porque nenhum evento
   de visibilidade chegou.
7. **`root.mainloop()`** "puts everything on the display, and responds to
   user input until the program terminates" [1] (tradução livre: "coloca tudo
   na tela e responde à entrada do usuário até que o programa termine"). Este
   *laço de eventos* é a grande diferença em relação à
   [versão cli](../cli/hello.py), que executa uma vez e termina. O servidor
   da [versão web](../web/app.py) também tem um laço, que aguarda requisições.

## Por que esta toolchain
- O **tkinter** é "the standard Python interface to the Tcl/Tk GUI toolkit"
  (tradução livre: "a interface padrão do Python para o toolkit de GUI
  Tcl/Tk"), e "both Tk and tkinter are available on most Unix platforms,
  including macOS, as well as on Windows systems" [1] (tradução livre: "o Tk e
  o tkinter estão disponíveis na maioria das plataformas Unix, incluindo o
  macOS, assim como em sistemas Windows"). Os instaladores do python.org o
  incluem [1][5]; portanto, nenhuma biblioteca extra do PyPI é necessária.
- O instalador do python.org para macOS inclui "a macOS-native version of Tk"
  [5] (tradução livre: "uma versão do Tk nativa do macOS"). No Homebrew, é a
  fórmula `python-tk@3.14`, que deve corresponder à versão do Python
  (`python@3.14`) [2].
- Os widgets **ttk** são usados em vez dos clássicos porque "provide a much
  better appearance on different platforms" [1] (tradução livre: "oferecem uma
  aparência muito melhor em diferentes plataformas").

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Python 3.14.10 com `python-tk@3.14` do Homebrew e Tcl/Tk 9.1.0. O Homebrew afirma que "Intel macOS remains Tier 3", em que "bottles will rarely be built or published" [6] (tradução livre: "o macOS Intel continua sendo Tier 3", em que "bottles raramente serão compilados ou publicados"); por isso, `brew install python-tk@3.14` compilou `tcl-tk` e `python-tk@3.14` a partir do código-fonte (em 2026-10-31, com as Command Line Tools 26.6, o `tcl-tk` levou cerca de 5 minutos e o `python-tk@3.14`, cerca de 20 segundos, depois que o próprio `python@3.14` levou cerca de 10 minutos; um `/Applications/Xcode.app` desatualizado deixado na máquina havia feito uma tentativa anterior falhar). |
| macOS Apple Silicon | ⚠️ não verificado | `brew install python@3.14 python-tk@3.14` ou o instalador do python.org, que inclui o Tk [5]. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `python3` (quando ele não existe) e `python3-tk` (quando o `tkinter` não carrega) com o apt [3]. Uma janela exige uma sessão gráfica. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Python: se o interpretador (`PYTHON`, padrão `python3`) não existe, ele imprime os passos do `winget` e de `py install 3.14` e para. [7] Ele também exige que o `tkinter` carregue; se não carregar, ele para. O WSL não foi verificado; ele se comporta como o Linux, e o WSLg mostra aplicativos gráficos do Linux na área de trabalho do Windows [8]. |

## Saída esperada
`./run.sh` abre uma pequena janela com o título "Hello, World!" e o texto
"Hello, World!" no centro (macOS, modo escuro):

![A janela com o título "Hello, World!" exibindo o texto "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 no macOS Intel com `screencapture -o -l <window-id> screenshot.png`,
que captura apenas essa janela. Exige a permissão Gravação do Áudio do Sistema e da Tela (Screen & System Audio Recording)
em Ajustes do Sistema (System Settings) → Privacidade e Segurança (Privacy & Security).)

`./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: tkinter asks Tk to create a native window; mainloop() keeps it open.
Hello, World!
```

## Fontes
1. tkinter: Python interface to Tcl/Tk. Python Software Foundation. <https://docs.python.org/3/library/tkinter.html> (acessado em 2026-10-30)
2. `python-tk@3.14` formula. Homebrew. <https://formulae.brew.sh/formula/python-tk@3.14> (acessado em 2026-10-30)
3. `python3-tk` package (Debian stable). Debian. <https://packages.debian.org/stable/python3-tk> (acessado em 2026-10-30)
4. tkinter.ttk: Tk themed widgets. Python Software Foundation. <https://docs.python.org/3/library/tkinter.ttk.html> (acessado em 2026-10-30)
5. Using Python on macOS. Python Software Foundation. <https://docs.python.org/3/using/mac.html> (acessado em 2026-10-30)
6. Support Tiers. Homebrew. <https://docs.brew.sh/Support-Tiers> (acessado em 2026-10-30)
7. Using Python on Windows. Python Software Foundation. <https://docs.python.org/3/using/windows.html> (acessado em 2026-10-30)
8. Run Linux GUI apps on the Windows Subsystem for Linux. Microsoft Learn. <https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps> (acessado em 2026-10-30)
9. Language Runtimes and Packages. Homebrew. <https://docs.brew.sh/Language-Runtimes-and-Packages> (acessado em 2026-10-31)
10. update. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TclCmd/update.html> (acessado em 2026-10-31)
