---
source: languages/ruby/web/README.md
source_sha: 45f22f327e1a4c05824e0d1a13e40d1ae374a54f
---
# Ruby · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Ruby](../README.md)

## O que é
Um pequeno servidor web escrito com o Sinatra. Quando um navegador pede
`http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador mostra como o texto **Hello, World!**.
O próprio servidor envia o HTML; não há um front-end separado.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (`ruby` do Homebrew) | executa o Sinatra e o `app.rb` |
| Bundler (`bundle`) | 4.0.20 (instalado com o Ruby) | instala as gems fixadas em `vendor/bundle` e executa o Ruby com elas |
| Sinatra | 4.2.1 (fixada no `Gemfile`) | o framework web |
| Puma | 8.1.1 (fixada no `Gemfile`) | o servidor web que o Sinatra inicia |
| Rackup | 2.3.1 (fixada no `Gemfile`) | a biblioteca que conecta o Sinatra ao servidor |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O `Gemfile.lock` também fixa as outras gems de que essas três precisam (Rack,
Tilt e outras), com seus checksums.

## Início rápido
```sh
./install.sh   # check Ruby and Bundler, install the gems into vendor/bundle (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Use outra porta com
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o Ruby e o Bundler e mostra como instalar o Ruby. 2. Executa `bundle config set --local path vendor/bundle`. 3. Executa `bundle install`, que instala as versões do `Gemfile.lock`. As etapas que instalam algo perguntam antes. | O Sinatra é uma gem de terceiros. O README do Sinatra chama o Bundler de "the recommended way" (a forma recomendada) de executar uma aplicação com uma determinada versão do Sinatra [1]. `path vendor/bundle` mantém as gems nesta pasta e não no Ruby do sistema; `--local` grava a configuração no `.bundle/config` desta pasta [2]. |
| `run.sh` | Inicia `bundle exec ruby app.rb` na `PORT`. `--verify` o inicia em segundo plano, busca a página uma vez com `curl` e então o encerra. | O README do Sinatra: "Sinatra applications can be run directly" (as aplicações Sinatra podem ser executadas diretamente) com `ruby myapp.rb` [1]. `bundle exec` executa o Ruby com as gems do `Gemfile.lock` [3]. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`, porque o Ruby é interpretado, como no
[cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md       this file
├── install.sh      checks Ruby and Bundler, installs the gems
├── run.sh          starts the server
├── app.rb          the web application (Sinatra's classic style)
├── Gemfile         the gems this app needs, with pinned versions
├── Gemfile.lock    the exact versions Bundler chose, with checksums (committed)
├── .gitignore      keeps vendor/ and .bundle/ out of git
├── .bundle/        created by install.sh: Bundler settings for this folder
└── vendor/bundle/  created by install.sh: the installed gems
```
- O `app.rb` usa o estilo clássico: as rotas são escritas no nível superior
  do arquivo. O Sinatra também tem um estilo modular, no qual a aplicação é
  uma classe [1]. Uma única página precisa apenas do estilo clássico.
- O `Gemfile` lista as gems e de onde baixá-las (`source`) [4].
- O `Gemfile.lock` "writes the exact version of every gem, direct or
  transitive, into the lockfile" [5] (tradução livre: "grava no arquivo de
  bloqueio a versão exata de cada gem, direta ou transitiva"). O Bundler o
  mantém; ninguém o edita à mão.
- `.bundle/` e `vendor/` não são versionados: contêm configurações do seu
  computador e código baixado.

## Passo a passo
Abra o [`app.rb`](app.rb) ao lado desta lista.

1. **`require "sinatra"`** carrega a biblioteca. Diferentemente do
   [cli](../cli/hello.rb), que usa apenas o `puts` nativo, este programa
   depende de uma gem do RubyGems.
2. **`set :port, ...` e `set :bind, ...`** alteram duas configurações. O
   README do Sinatra descreve `port` como "Port to listen on" [1] (tradução
   livre: "Porta em que escutar") e `bind` como "IP address to bind to" [1]
   (tradução livre: "Endereço IP ao qual se associar"). O `app.rb` lê a porta
   da variável de ambiente `PORT`, com 8080 como padrão, e se associa a
   `127.0.0.1`, que apenas este computador consegue acessar.
3. **`get "/" do ... end`** define uma rota: "In Sinatra, a route is an HTTP
   method paired with a URL-matching pattern. Each route is associated with
   a block" [1] (tradução livre: "No Sinatra, uma rota é um método HTTP
   combinado com um padrão de correspondência de URL. Cada rota é associada
   a um bloco"). Outros frameworks deste repositório registram rotas à sua
   maneira: o Flask usa `@app.route("/")`, o Express usa `app.get("/", ...)`
   e o Spring Boot usa `@GetMapping("/")`. Um bloco é um trecho de código
   entre `do` e `end` que o Ruby entrega a um método; aqui o Sinatra o guarda
   e o executa a cada requisição correspondente.
4. **`"<p>Hello, World!</p>"`**: "The return value of a route block
   determines at least the response body ... Most commonly, this is a
   string" [1] (tradução livre: "O valor de retorno de um bloco de rota
   determina pelo menos o corpo da resposta ... Mais comumente, é uma
   string"). No Ruby, um bloco retorna a sua última expressão, de modo que
   não é preciso usar `return`. O tipo de conteúdo HTML pode ser visto na
   saída de `curl -i` abaixo.
5. **Nenhum código de servidor.** O arquivo nunca inicia um servidor por
   conta própria. Quando ele termina, o Sinatra inicia um, porque a
   aplicação "can be run directly" [1] (tradução livre: "pode ser executada
   diretamente"). Esse servidor (o Puma) aguarda requisições. Esta é a maior
   diferença em relação à versão cli, que executa uma vez e termina.

## Por que esta toolchain
- **O Sinatra** se descreve como "a DSL for quickly creating web
  applications in Ruby with minimal effort" [6] (tradução livre: "uma DSL
  para criar rapidamente aplicações web em Ruby com o mínimo de esforço").
  Uma página Hello World ocupa seis linhas de código, o que combina com o
  objetivo deste repositório de manter cada programa o mais simples e direto
  possível. Uma comparação com a versão [Rails](../web-rails/README.md),
  full-stack, está na [página da linguagem](../README.md#comparing-the-categories).
- **O Puma** é o servidor que o README do Sinatra instala em seu próprio
  comando de início rápido, `gem install sinatra rackup puma`, e que lista
  como padrão da opção `-s` (servidor): "specify rack server/handler
  (default is puma)" [1] (tradução livre: "especifica o servidor/tratador
  rack (o padrão é puma)"). O site do Sinatra acrescenta: "It is recommended
  to also run gem install puma, which Sinatra will pick up if available" [6]
  (tradução livre: "Recomenda-se executar também gem install puma, que o
  Sinatra usará se estiver disponível"). O WEBrick, a outra escolha comum,
  não foi necessário.
- **O Rackup** é instalado no mesmo comando do README [1]; ele fornece os
  tratadores pelos quais o Sinatra inicia um servidor Rack, como o Puma.
- **A porta 8080** é a convenção deste repositório para toda implementação
  web. O padrão do próprio Sinatra é 4567 [1].
- **Configurações de desenvolvimento.** Sem nenhum ambiente definido, o
  Sinatra executa em modo de desenvolvimento [1] e imprime uma linha de log
  por requisição. Uma implantação em produção exige mais configurações, que
  estão fora do escopo de um programa Hello World.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-19) | Ruby 4.0.7, Sinatra 4.2.1, Puma 8.1.1. O Puma e sua dependência nio4r têm uma parte em C: o `bundle install` compilou ambos neste computador em poucos segundos. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `ruby-full` e `build-essential` com o apt quando o `ruby` não existe [7] e o `bundler` quando o `bundle` não existe. Em seguida, instala as gems em `vendor/bundle`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Ruby da imagem do runner não tem o Bundler; por isso o `install.sh` instala os pacotes do MSYS2 para Ruby 4.0 (com o Bundler), GCC e `make` com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`) e coloca `C:\msys64\ucrt64\bin` no início do PATH. Um pequeno wrapper `bundle` em `languages/ruby/msys2-bin` permite que o Git Bash inicie o Bundler, e as gems com uma parte em C (Puma) são compiladas com o `make` do MSYS2. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'ruby app.rb' loads Sinatra, which serves the app with Puma on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
== Sinatra (v4.2.1) has taken the stage on 8080 for development with backup from Puma
Puma starting in single mode...
* Puma version: 8.1.1 ("Puma Psychosis")
* Ruby version: ruby 4.0.7 (2026-09-15 revision 229531a6cf) +PRISM [x86_64-darwin23]
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 8413
* Listening on http://127.0.0.1:8080
Use Ctrl-C to stop
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
content-type: text/html;charset=utf-8
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
content-length: 20

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Sinatra README. Sinatra project. <https://github.com/sinatra/sinatra#readme> (acessado em 2026-11-04)
2. bundle config. Bundler documentation, RubyGems Guides. <https://guides.rubygems.org/command-reference/bundle-config/> (acessado em 2026-11-04)
3. Using Bundler in applications. RubyGems Guides. <https://guides.rubygems.org/using_bundler_in_applications/> (acessado em 2026-11-04)
4. Gemfile. RubyGems Guides. <https://guides.rubygems.org/gemfile/> (acessado em 2026-11-04)
5. How Gemfile.lock works. RubyGems Guides. <https://guides.rubygems.org/gemfile-lock/> (acessado em 2026-11-04)
6. Sinatra. Sinatra project. <https://sinatrarb.com/> and <https://sinatrarb.com/intro.html> (acessado em 2026-11-04)
7. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (acessado em 2026-11-04)
