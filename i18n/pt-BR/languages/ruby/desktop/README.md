---
source: languages/ruby/desktop/README.md
source_sha: 873d78960b868ea50103fb44f2ab23b50abb231d
---
# Ruby · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Ruby](../README.md)

## O que é
Uma pequena aplicação desktop. Ela abre uma janela com o título "Hello,
World!" que mostra o texto **Hello, World!**. A janela é desenhada pelo Tk, um
toolkit de GUI, e o Ruby acessa o Tk por meio da gem `tk` (Ruby/Tk). O
programa termina quando a janela é fechada.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (`ruby` do Homebrew) | executa o `hello.rb` |
| Bundler (`bundle`) | 4.0.20 (instalado com o Ruby) | instala a gem fixada em `vendor/bundle` e executa o Ruby com ela |
| Tcl/Tk | 9.1.0 (`tcl-tk` do Homebrew) | as bibliotecas que desenham a janela; a gem é compilada contra elas |
| gem `tk` | 0.6.0 (fixada no `Gemfile` e no `Gemfile.lock`) | a interface do Ruby para o Tk |
| Um compilador C | Apple Command Line Tools | compila a parte em C da gem `tk` |

A gem `tk` é descrita como "Tk interface module using tcltklib" [1][2]
(tradução livre: "módulo de interface com o Tk que usa o tcltklib"). Uma gem
com uma parte em C é chamada de extensão nativa: ela é compilada no computador
do leitor quando é instalada.

## Início rápido
```sh
./install.sh   # check Ruby, Tcl/Tk and Bundler, build the tk gem (asks first)
./run.sh       # open the window
```
Feche a janela para encerrar o programa. A compilação da gem leva cerca de um
minuto.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o Ruby e o Bundler. 2. Verifica se o `tcl-tk` do Homebrew está instalado e lê a sua versão. 3. Executa `bundle config set --local path vendor/bundle` e `bundle config set --local build.tk <flags>`. 4. Executa `bundle install`, que compila a gem. Todo passo que instala algo pergunta antes. | O Ruby/Tk precisa ser compilado contra o Tcl/Tk. O Bundler repassa opções de compilação a uma gem por meio de `bundle config set build.<gem>` [3]. A configuração `--local` é salva no `.bundle/config` da própria aplicação [3], e o `path vendor/bundle` mantém a gem fora do Ruby do sistema. |
| `run.sh` | Executa `bundle exec ruby hello.rb`. `--verify` define `TF_VERIFY=1`: a aplicação imprime `Hello, World!` assim que a janela é exibida e depois se fecha sozinha após cerca de 2 segundos. | O `bundle exec` executa o Ruby "in the current bundle context, making all gems in Gemfile available to require and use" [4] (tradução livre: "no contexto do bundle atual, tornando todas as gems do Gemfile disponíveis para `require` e uso"). A autoverificação permite que o `scripts/verify-all.sh` teste a janela sem que uma pessoa a feche. |

Não há `build.sh` para o programa em si, porque o Ruby é interpretado, como no
[cli](../cli/README.md#why-there-is-no-build-step). Apenas a gem tem um build,
e o `bundle install` o executa.

## Estrutura de pastas
```text
desktop/
├── README.md      this file
├── install.sh     checks Ruby, Tcl/Tk, Bundler; builds the tk gem
├── run.sh         opens the window
├── hello.rb       the program (Ruby/Tk)
├── Gemfile        the gem this program needs, with its pinned version
├── Gemfile.lock   the exact versions Bundler chose (committed)
├── .gitignore     keeps vendor/ and .bundle/ out of git
├── .bundle/       created by install.sh: Bundler settings for this folder
└── vendor/bundle/ created by install.sh: the installed gem
```
- O `Gemfile` lista as gems e de onde baixá-las (`source`) [5].
- O `Gemfile.lock` "writes the exact version of every gem, direct or
  transitive, into the lockfile", de modo que "every machine, every teammate, and
  every deploy runs the same code" [6] (tradução livre: "grava no arquivo de
  bloqueio a versão exata de cada gem, direta ou transitiva" e "toda máquina,
  todo colega de equipe e todo deploy executa o mesmo código"). O Bundler o
  mantém; ninguém o edita à mão.
- O `.bundle/` e o `vendor/` não sofrem commit: eles guardam configurações do
  computador do leitor (o caminho do Tcl/Tk) e código compilado.

## Passo a passo
Abra o [`hello.rb`](hello.rb) ao lado desta lista.

1. **`require "tk"`** carrega a gem. É o equivalente em Ruby do `import
   tkinter` do Python. Ao contrário do [cli](../cli/hello.rb), este programa
   depende de uma biblioteca que não faz parte da linguagem.
2. **`TkRoot.new { title "Hello, World!" }`** cria a janela raiz, a janela
   principal da aplicação, e define o seu título. O bloco contém as opções da
   janela.
3. **`TkLabel.new(root) do ... end`** cria um rótulo: o Tk o descreve como um
   "non-interactive text or image widget" [7] (tradução livre: "widget não
   interativo de texto ou imagem"). O `root` indica que ele fica nessa janela;
   `padx` e `pady` adicionam espaço vazio ao redor do texto.
4. **`label.pack`** posiciona o rótulo. O `pack` é um "Geometry manager that
   packs around edges of cavity" [8] (tradução livre: "Gerenciador de
   geometria que empacota ao redor das bordas da cavidade"): enquanto um
   gerenciador de geometria não posiciona um widget, o Tk não o exibe. O
   tkinter do Python usa o mesmo nome para o mesmo comando do Tk.
5. **A autoverificação** (`if ENV["TF_VERIFY"] == "1"`) só é executada quando o
   `./run.sh --verify` define essa variável. O `Tk.update` chama o `update` do
   Tk, que coloca "the application 'up to date' by entering the event loop
   repeatedly until all pending events ... have been processed" [9] (tradução
   livre: "a aplicação “em dia”, entrando repetidamente no laço de eventos até
   que todos os eventos pendentes ... tenham sido processados"). Depois dele, a
   janela está na tela, de modo que o programa imprime o texto do rótulo e
   agenda o `root.destroy` com `Tk.after(2000)`. Chamadas que aguardam um
   evento de visibilidade são evitadas: com o Tk 9 no macOS, elas não
   retornaram quando testadas.
6. **`Tk.mainloop`** entrega o controle ao Tk, que aguarda eventos até a
   janela ser fechada. A versão cli não tem esse laço: imprime uma vez e
   termina.

## Por que esta toolchain
- **O Ruby/Tk** é a interface com o Tk publicada na organização `ruby` no
  GitHub [1] e no RubyGems [2]. Ele usa o mesmo toolkit Tk da versão
  [desktop em Python](../../python/desktop/README.md), de modo que os dois
  programas têm a mesma forma.
- **O Tcl/Tk 9.1 do Homebrew** desenha uma janela nativa no macOS (Aqua) e não
  precisa do X11. O `Tk.windowingsystem` informa `aqua` nesta configuração.
- **O Bundler com `vendor/bundle`** mantém a gem dentro da pasta. A
  documentação do Bundler descreve o `Gemfile.lock` como o arquivo que fixa a
  versão de cada gem [6].
- **Ressalva conhecida.** O projeto Ruby/Tk observa que, com o Tk Aqua, "current
  tcltklib sometimes freezes when using Aqua specific dialogs (e.g.
  Tk.messageBox)" [10] (tradução livre: "o tcltklib atual às vezes trava ao
  usar diálogos específicos do Aqua (por exemplo, Tk.messageBox)"). Este
  programa não usa nenhum diálogo.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Ruby 4.0.7, gem `tk` 0.6.0, `tcl-tk` 9.1.0 do Homebrew (Aqua). O `bundle install` compila a gem em cerca de um minuto. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel; o `install.sh` encontra o Tcl/Tk com `brew --prefix tcl-tk`. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | <!-- vale Vale.Terms = NO -->GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `ruby-full` e `build-essential` com o apt quando o `ruby` não existe e o `bundler` quando o `bundle` não existe. Se os cabeçalhos do Tcl/Tk não existem, ele instala `tk-dev`, `ruby-dev` e `build-essential`; o pacote `tk-dev` do Debian depende do Tk 8.6 [11]. Ele passa as pastas do Tcl/Tk do Debian para a compilação da gem `tk` [1]. A janela abre em um display X virtual (Xvfb). |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Ruby da imagem do runner não tem o Bundler; por isso o `install.sh` instala os pacotes do MSYS2 para Ruby 4.0 (com o Bundler), GCC, `make`, Tcl 8.6 e Tk 8.6 com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`). Ele compila a gem `tk` contra `C:/msys64/ucrt64` [1]. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` abre uma janela pequena com o título "Hello, World!" e o texto
"Hello, World!" no meio (macOS, modo escuro):

![A janela com o título "Hello, World!" mostrando o texto "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 no macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente essa janela. Ela exige a permissão Gravação do Áudio do Sistema e da Tela (Screen & System Audio Recording)
em Ajustes do Sistema (System Settings) → Privacidade e Segurança (Privacy & Security). A janela aparece cinza
porque não é a janela ativa no momento da captura.)

O `./run.sh --verify` imprime:
```text
==> Open the Hello World window
    WHY: Ruby/Tk asks Tk to create a native window; Tk.mainloop keeps it open.
Hello, World!
```
e fecha a janela após cerca de 2 segundos.

## Fontes
1. `ruby/tk`: Tk interface module using `tcltklib` (README). Ruby project. <https://github.com/ruby/tk> (acessado em 2026-11-04)
2. `tk` 0.6.0. RubyGems.org. <https://rubygems.org/gems/tk> (acessado em 2026-11-04)
3. bundle config. Bundler documentation, RubyGems Guides. <https://guides.rubygems.org/command-reference/bundle-config/> (acessado em 2026-11-04)
4. Using Bundler in applications. RubyGems Guides. <https://guides.rubygems.org/using_bundler_in_applications/> (acessado em 2026-11-04)
5. Gemfile. RubyGems Guides. <https://guides.rubygems.org/gemfile/> (acessado em 2026-11-04)
6. How Gemfile.lock works. RubyGems Guides. <https://guides.rubygems.org/gemfile-lock/> (acessado em 2026-11-04)
7. label. Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/label.html> (acessado em 2026-11-04)
8. pack. Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TkCmd/pack.html> (acessado em 2026-11-04)
9. update. Tcl/Tk 9.0 manual. <https://www.tcl-lang.org/man/tcl9.0/TclCmd/update.html> (acessado em 2026-11-04)
10. README.macosx-aqua. Ruby/Tk project. <https://github.com/ruby/tk/blob/master/README.macosx-aqua> (acessado em 2026-11-04)
11. `tk-dev` package (Debian stable). Debian. <https://packages.debian.org/stable/tk-dev> (acessado em 2026-11-04)
