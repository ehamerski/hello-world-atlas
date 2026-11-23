---
source: languages/perl/web/README.md
source_sha: c6766af57a3a5019403f8ad608f9b4d79b931fbf
---
# Perl · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Perl](../README.md)

## O que é
Um pequeno servidor web escrito com o Mojolicious, em seu modo de arquivo
único, o Mojolicious::Lite. Quando um navegador pede `http://localhost:8080/`,
o servidor responde com o HTML `<p>Hello, World!</p>`, que o navegador exibe
como o texto **Hello, World!**. O servidor envia o próprio HTML; não há
front-end separado.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Perl 5 (`perl`) | 5.34.1 (o `/usr/bin/perl` que acompanha o macOS) | executa o Mojolicious e o `app.pl` |
| Mojolicious | 9.53 (CPAN, fixada em `mojo-env.sh`, instalada em `local/`) | o framework web [1] |
| `curl` e `shasum` | os que acompanham o macOS | baixam e conferem o tarball; o `curl` também atende o `./run.sh --verify` |

O Mojolicious 9.53 declara que precisa do Perl 5.016 ou mais novo, além do
`IO::Socket::IP` 0.37 e do `Sub::Util` 1.41 [2]. No Perl 5.34.1 do sistema
macOS, nada mais precisou ser instalado. O FAQ do Mojolicious diz que o
projeto mantém a distribuição instalável até o Perl 5.16.0 [3].

## Início rápido
```sh
./install.sh   # check Perl, download and install Mojolicious into local/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Use outra porta com
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o `perl` e mostra como instalá-lo. 2. Baixa o tarball do Mojolicious do CPAN, confere seu checksum SHA-256 com o fixado em `mojo-env.sh` e então executa `perl Makefile.PL INSTALL_BASE=...`, `make` e `make install` para colocá-lo em `local/`. A instalação pergunta antes. | O Mojolicious não faz parte do Perl. Uma pasta `local/` privada o mantém fora do Perl do seu sistema, e o `INSTALL_BASE` é a configuração do MakeMaker para isso [4]. O checksum prova que o arquivo é a versão fixada. O Mojolicious não tem código C, de modo que o `make` apenas copia arquivos. |
| `mojo-env.sh` | Incluído (`source`) pelos outros scripts: a versão, a URL e o checksum fixados, e o `PERL5LIB`. Não é executado sozinho. | Um único lugar para os valores fixados, compartilhado pelo `install.sh` e pelo `run.sh`. |
| `run.sh` | Inicia `perl app.pl daemon -l http://127.0.0.1:8080` com `local/lib/perl5` no `PERL5LIB` [5]. `--verify` o inicia em segundo plano, busca a página uma vez com o `curl` e depois o encerra. | O comando `daemon` inicia o servidor web embutido do Mojolicious [6]. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`, porque o Perl é interpretado, como no
[cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md      this file
├── install.sh     checks Perl, installs Mojolicious into local/
├── mojo-env.sh    pinned version, URL, checksum and PERL5LIB (sourced)
├── run.sh         starts the server
├── app.pl         the web application (a Mojolicious::Lite app)
├── .gitignore     keeps local/ out of git
└── local/         created by install.sh: tarball in src/, modules in lib/perl5/
```
- O `app.pl` é uma aplicação Mojolicious::Lite: a aplicação inteira é um
  único script [2]. A documentação do Mojolicious mostra como fazê-la crescer
  até uma aplicação completa, com controllers e templates, quando ela ficar
  maior [7]. Uma única página não precisa de nenhum dos dois.
- O `local/` é a biblioteca privada que o `INSTALL_BASE` cria (`lib/perl5`
  para os módulos) [4]. Ele é apagado e reconstruído com segurança pelo
  `install.sh`.

## Passo a passo
Abra o [`app.pl`](app.pl) ao lado desta lista.

1. **`use Mojolicious::Lite;`** carrega o framework. Ao contrário do
   [cli](../cli/hello.pl), que usa apenas o `print` nativo, este programa
   depende de um módulo do CPAN. O Mojolicious::Lite "automatically enables
   'strict', 'warnings', 'utf8' and Perl 5.16 features" [2] (tradução livre:
   "ativa automaticamente 'strict', 'warnings', 'utf8' e os recursos do Perl
   5.16"), de modo que o programa não precisa das linhas `use strict; use
   warnings;` da versão cli. Ele também acrescenta ao arquivo as funções
   `get` e `app`.
2. **`get '/' => sub { ... };`** registra um tratador para requisições GET à
   URL `/`. O `sub { ... }` é uma função anônima, um valor que guarda código,
   e o `=>` é a "vírgula gorda" (fat comma) do Perl, que associa a URL a ela.
   Outros frameworks deste repositório registram rotas à sua própria maneira:
   o Flask usa `@app.route("/")`, o Express usa `app.get("/", ...)` e o Go
   usa `http.HandleFunc("/", ...)`.
3. **`my $c = shift;`** pega o primeiro argumento da função. O Perl passa os
   argumentos no array `@_`, e o `shift` remove o primeiro. O Mojolicious
   passa um objeto controller, que guarda a requisição e monta a resposta.
   (Com um Perl mais novo, `sub ($c) { ... }` é possível, mas exige o Perl
   5.20 ou posterior [2][3].)
4. **`$c->render(text => '<p>Hello, World!</p>', format => 'html');`** envia
   o texto como corpo da resposta. O valor de `text` é codificado em bytes
   pelo Mojolicious [8], e `format => 'html'` faz o tipo de conteúdo ser
   `text/html`, de modo que o navegador exibe o texto dentro da tag de
   parágrafo `<p>`. É possível ver isso na saída do `curl -i` abaixo.
5. **`app->start;`** passa o controle ao sistema de comandos do Mojolicious.
   Com o comando `daemon` e a opção `-l` (listen), ele inicia o servidor web
   no endereço indicado [6][9]. O programa permanece nessa chamada, aguardando
   requisições. Essa é a maior diferença em relação à versão cli, que é
   executada uma vez e termina.

## Por que esta toolchain
- **O Mojolicious** se descreve como "an amazing real-time web framework"
  (tradução livre: "um incrível framework web de tempo real"), com rotas,
  plugins, comandos e templates embutidos [1]. O Mojolicious::Lite "is a tiny
  domain specific language built around Mojolicious, made up of
  only about a dozen Perl functions" [2] (tradução livre: "é uma pequena
  linguagem específica de domínio construída em torno do Mojolicious,
  composta de apenas cerca de uma dúzia de funções Perl"). Isso o torna a
  configuração mais enxuta para um Hello World em HTML em Perl: um arquivo,
  nenhuma configuração e um servidor incluído.
- **Perl puro.** A distribuição é instalada com o `make`, mas nada é
  compilado. Isso é o oposto da versão [desktop](../desktop/README.md), que
  precisa compilar o Tcl.pm.
- **Por que não os outros.** O CPAN tem outros frameworks web (e o PSGI, a
  interface que muitos deles compartilham), mas esta página não os compara:
  a versão daqui é a que precisa de menos etapas. Escolhê-la é uma decisão
  sobre este repositório, não um ranking de frameworks Perl.
- **Porta 8080** em vez do padrão do Mojolicious, `http://*:3000` [6], para
  coincidir com todas as implementações web deste repositório.
- **127.0.0.1**, de modo que o servidor só é acessível a partir deste
  computador.
- **Servidor de desenvolvimento.** O servidor embutido "is usually used during
  development" (tradução livre: "costuma ser usado durante o
  desenvolvimento") e é "solid and fast enough for small to mid sized
  applications" [10] (tradução livre: "sólido e rápido o bastante para
  aplicações de pequeno a médio porte"). O `daemon` o inicia por padrão no
  modo "development" [6], em que o nível de log é "trace" e as mensagens vão
  para o `STDERR` [9]: por isso o terminal mostra uma linha para cada
  requisição. Para produção, a documentação do Mojolicious descreve o
  Hypnotoad, um servidor "optimized for high
  availability non-containerized production environments" [11] (tradução
  livre: "otimizado para ambientes de produção de alta disponibilidade, sem
  contêineres"). Isso está fora do escopo de um programa Hello World.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Perl 5.34.1 do sistema, Mojolicious 9.53. Nada foi compilado. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `perl` com o apt quando ele não existe [12]. Em seguida, baixa o Mojolicious do CPAN, confere seu checksum SHA-256 e o instala em `local/`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Perl do Git Bash não consegue compilar módulos (ele não tem o `ExtUtils::MakeMaker`); por isso o `install.sh` instala os pacotes do MSYS2 para Perl, GCC e `mingw32-make` com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`) e coloca `C:\msys64\ucrt64\bin` no início do PATH. Em seguida, compila o Mojolicious em `local/`. O Mojolicious afirma que "Windows is not officially supported" [3] (tradução livre: "o Windows não tem suporte oficial"); ele funciona nesta verificação. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
O `./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'perl app.pl daemon' serves app.pl; 127.0.0.1 means this computer only.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
[2026-11-04 13:16:12.02311] [12921] [info] Listening at "http://127.0.0.1:8080"
Web application available at http://127.0.0.1:8080
```
(Cada linha de log começa com a data e o id do processo. O servidor também
registra uma linha `[trace]` para cada requisição.) Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html;charset=UTF-8
Date: Wed, 04 Nov 2026 16:15:25 GMT
Server: Mojolicious (Perl)

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Mojolicious: Real-time web framework (release 9.53). Sebastian Riedel and others, MetaCPAN. <https://metacpan.org/pod/Mojolicious> (acessado em 2026-11-04)
2. Mojolicious::Lite: Micro real-time web framework. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Lite> (acessado em 2026-11-04)
3. Mojolicious::Guides::FAQ. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::FAQ> (acessado em 2026-11-04)
4. ExtUtils::MakeMaker: INSTALL_BASE. Perl 5 porters, MetaCPAN. <https://metacpan.org/pod/ExtUtils::MakeMaker#INSTALL_BASE> (acessado em 2026-11-04)
5. perlrun: PERL5LIB. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlrun> (acessado em 2026-11-04)
6. Mojolicious::Command::daemon: Daemon command. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Command::daemon> (acessado em 2026-11-04)
7. Mojolicious::Guides::Growing. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Growing> (acessado em 2026-11-04)
8. Mojolicious::Guides::Rendering. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Rendering> (acessado em 2026-11-04)
9. Mojolicious::Guides::Tutorial. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Tutorial> (acessado em 2026-11-04)
10. Mojolicious::Guides::Cookbook. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Cookbook> (acessado em 2026-11-04)
11. Mojolicious::Guides::Cookbook: Hypnotoad. Mojolicious, MetaCPAN. <https://metacpan.org/pod/Mojolicious::Guides::Cookbook#Hypnotoad> (acessado em 2026-11-04)
12. Package perl (trixie). Debian. <https://packages.debian.org/stable/perl> (acessado em 2026-11-04)
