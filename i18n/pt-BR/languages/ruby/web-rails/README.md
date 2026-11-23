---
source: languages/ruby/web-rails/README.md
source_sha: 705091b268250da0449b87745e7e50f549a7e422
---
# Ruby · web-rails: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Ruby](../README.md)

## O que é
Um pequeno servidor web escrito com o Ruby on Rails. Quando um navegador
pede `http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador mostra como o texto **Hello, World!**.
O próprio servidor envia o HTML; não há um front-end separado.

Esta é a segunda versão web na pasta do Ruby. A [../web](../web/) faz o mesmo
com o Sinatra. O par mostra a diferença entre uma **linguagem** e um
**framework**, e entre dois tamanhos de framework (veja a próxima seção).

### Linguagem e framework
- **O Ruby é uma linguagem.** Ele define a sintaxe, os objetos e a
  biblioteca padrão. O site oficial o descreve como uma linguagem de
  "careful balance" [1] (tradução livre: "equilíbrio cuidadoso"). O Ruby, por
  si só, não tem noção de requisição web.
- **O Rails é um framework escrito em Ruby.** O guia do Rails o chama de "a
  web framework built for the Ruby programming language" (tradução livre:
  "um framework web criado para a linguagem de programação Ruby") e recomenda
  aprender primeiro os fundamentos do Ruby, porque "Rails takes advantage of
  many features of Ruby" [2] (tradução livre: "o Rails aproveita muitos
  recursos do Ruby"). Um framework é uma biblioteca com uma estrutura: ele
  decide onde o código fica, chama o seu código no momento certo e traz
  partes prontas para tarefas comuns. A página inicial do Rails: "Rails is a
  full-stack framework. It ships with all the tools needed to build amazing
  web apps on both the front and back end" [3] (tradução livre: "O Rails é
  um framework full-stack. Ele vem com todas as ferramentas necessárias para
  criar aplicações web incríveis, tanto no front-end quanto no back-end").
- **O Rails tem opinião própria.** Um de seus princípios declarados é
  "Convention over Configuration" (convenção sobre configuração): o Rails
  "has opinions about the best way to do many things in a web application,
  and defaults to this set of conventions, rather than require that you
  define them yourself" [2] (tradução livre: "tem opiniões sobre a melhor
  maneira de fazer muitas coisas em uma aplicação web e adota este conjunto
  de convenções como padrão, em vez de exigir que você mesmo as defina").
  Outro é "The menu is omakase" (o cardápio é omakase): o framework escolhe
  por você as partes da pilha [4].
- **O Sinatra também é um framework, mas pequeno.** Ele se descreve como "a
  DSL for quickly creating web applications in Ruby with minimal effort" [5]
  (tradução livre: "uma DSL para criar rapidamente aplicações web em Ruby com
  o mínimo de esforço"). Oferece rotas e pouco mais; você escolhe o resto.

| | [web](../web/) (Sinatra) | web-rails (esta pasta) |
|---|---|---|
| Linhas de Ruby (sem comentários) | 6 (`app.rb`) | 18 (`config.ru`) |
| Ponto de entrada | `ruby app.rb`: o Sinatra inicia o próprio servidor quando o arquivo termina | `rackup config.ru`: o comando do Rack inicia o Puma, que chama a aplicação |
| Rota | `get "/" do ... end` | `root to: "hello#index"` em uma tabela de rotas |
| Tratador | um bloco | uma action (um método) de uma classe controller |
| Estrutura imposta | nenhuma: um arquivo, um bloco | Rails::Application, um roteador, um controller e convenções de nomes |
| Carregado pelo programa | `sinatra` | `action_controller/railtie` (apenas roteamento e controllers) |
| Gems instaladas (`bundle list`) | 11 (3 diretas) | 44 (4 diretas, mais as bibliotecas do próprio Rails) |
| Projeto típico | um arquivo | muitos arquivos e pastas criados por `rails new` [6] |

A versão Rails aqui não é um projeto Rails completo. Um projeto criado com
`rails new` distribui este código por muitos arquivos e pastas
(`app/controllers`, `config/routes.rb`, `config/application.rb` e outros)
[6]. O `config.ru` mantém apenas o que uma página HTML precisa, de modo que
o programa inteiro pode ser lido de uma só vez. O arquivo diz isso em seus
comentários.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Ruby (`ruby`) | 4.0.7 (`ruby` do Homebrew) | executa o Rails e o `config.ru` |
| Bundler (`bundle`) | 4.0.20 (instalado com o Ruby) | instala as gems fixadas em `vendor/bundle` e executa o Ruby com elas |
| Railties | 8.1.4.1 (fixada no `Gemfile`) | o núcleo do Rails: `Rails::Application` e a sequência de inicialização |
| Action Pack | 8.1.4.1 (fixada no `Gemfile`) | o roteador (Action Dispatch) e os controllers (Action Controller) |
| Puma | 8.1.1 (fixada no `Gemfile`) | o servidor web |
| Rackup | 2.3.1 (fixada no `Gemfile`) | o comando `rackup`, que lê o `config.ru` e inicia o Puma |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O `Gemfile.lock` também fixa as outras gems de que essas precisam (Rack,
Active Support, Action View e outras), com suas versões.

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
| `install.sh` | 1. Verifica o Ruby e o Bundler e mostra como instalar o Ruby. 2. Executa `bundle config set --local path vendor/bundle`. 3. Executa `bundle install`, que instala as versões do `Gemfile.lock`. As etapas que instalam algo perguntam antes. | O Rails é um conjunto de gems de terceiros, não faz parte do Ruby. `path vendor/bundle` mantém as gems nesta pasta e não no Ruby do sistema; `--local` grava a configuração no `.bundle/config` desta pasta [7]. |
| `run.sh` | Inicia `bundle exec rackup --host 127.0.0.1 --port $PORT --server puma config.ru`. `--verify` o inicia em segundo plano, busca a página uma vez com `curl` e então o encerra. | `rackup` é o comando que executa uma aplicação Rack a partir de um arquivo `config.ru`, e uma aplicação Rails é uma delas [8]. `bundle exec` executa o Ruby com as gems do `Gemfile.lock` [9]. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`, porque o Ruby é interpretado, como no
[cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web-rails/
├── README.md       this file
├── install.sh      checks Ruby and Bundler, installs the gems
├── run.sh          starts the server
├── config.ru       the whole Rails application (a Rack "rackup" file)
├── Gemfile         the gems this app needs, with pinned versions
├── Gemfile.lock    the exact versions Bundler chose (committed)
├── screenshot.png  the page in a browser (see Expected output)
├── .gitignore      keeps vendor/ and .bundle/ out of git
├── .bundle/        created by install.sh: Bundler settings for this folder
└── vendor/bundle/  created by install.sh: the installed gems
```
- O `config.ru` é o ponto de entrada de uma aplicação Rack. Os guias do Rails
  descrevem o Rack como a interface entre os servidores web Ruby e os
  frameworks web Ruby, e dizem que o ponto de entrada de uma aplicação Rack
  é "stored in a `config.ru` file" [8] (tradução livre: "armazenado em um
  arquivo `config.ru`"). O Sinatra e o Rails são ambos frameworks Rack, de
  modo que o mesmo comando `rackup` e o mesmo servidor atendem qualquer um
  dos dois.
- O `Gemfile` lista as gems e de onde baixá-las (`source`) [10]. Ele cita
  `railties` e `actionpack` em vez da gem `rails`, que traria o Active
  Record, o Active Job, o Action Mailer e os demais frameworks. Este
  programa não tem banco de dados, e-mail nem jobs.
- O `Gemfile.lock` "writes the exact version of every gem, direct or
  transitive, into the lockfile" [11] (tradução livre: "grava no arquivo de
  bloqueio a versão exata de cada gem, direta ou transitiva"). O Bundler o
  mantém.
- A estrutura de um projeto Rails completo está descrita no guia Getting
  Started [6]. Este programa não a segue de propósito: um único arquivo é
  mais fácil de ler primeiro.

## Passo a passo
Abra o [`config.ru`](config.ru) ao lado desta lista.

1. **`require "action_controller/railtie"`** carrega duas partes do Rails: a
   classe base da aplicação e o Action Controller. Uma railtie é a forma como
   um framework do Rails se conecta à sequência de inicialização. A linha
   que o `rails new` gera carrega todos os frameworks; esta carrega apenas o
   que a página precisa [12].
2. **`class HelloApp < Rails::Application`** define a aplicação. Toda
   aplicação Rails é uma subclasse de `Rails::Application`, e suas
   configurações ficam no corpo da classe. `config.load_defaults 8.1`
   seleciona os valores padrão do Rails 8.1: "config.load_defaults loads
   default configuration values for a target version and all versions prior"
   [13] (tradução livre: "config.load_defaults carrega os valores de
   configuração padrão de uma versão-alvo e de todas as anteriores").
   `config.eager_load = false` carrega o código sob demanda.
   `config.secret_key_base` recebe um valor aleatório a cada execução,
   porque esta aplicação não define cookies.
3. **`HelloApp.initialize!`** executa a sequência de inicialização: lê as
   configurações, monta o roteador e carrega os frameworks.
4. **`Rails.application.routes.draw do ... root to: "hello#index" end`**
   preenche a tabela de rotas. "You can specify what Rails should route '/'
   to with the root method: root to: "pages#main"" [14] (tradução livre:
   "Você pode especificar para onde o Rails deve rotear '/' com o método
   root: root to: "pages#main""). O valor `"hello#index"` significa: a
   action `index` do `HelloController`. O nome `hello` se torna
   `HelloController` por uma regra de nomenclatura, um exemplo de convenção
   sobre configuração [2]. No Sinatra, a rota e o tratador são um só bloco;
   no Rails, são duas peças que um nome conecta.
5. **`class HelloController < ActionController::Base`** é o controller. Seus
   métodos públicos são actions. O guia Getting Started mostra o mesmo
   formato: `class ProductsController < ApplicationController` com um método
   `index` [6]. Uma aplicação completa herda do seu próprio
   `ApplicationController`; este programa usa a classe base diretamente.
6. **`render html: "<p>Hello, World!</p>".html_safe`** envia a string como
   uma página HTML. O Rails escapa o HTML de uma string por padrão, para que
   o texto vindo de um usuário não possa acrescentar um script à página.
   `html_safe` marca esta string como confiável. Uma aplicação Rails real
   renderizaria um template (um arquivo `.erb`, "Embedded Ruby") em vez de
   uma string [6].
7. **`run HelloApp`** informa ao Rack qual objeto é a aplicação: "A Rack app
   is an object which implements a call method" [8] (tradução livre: "Uma
   aplicação Rack é um objeto que implementa um método call").
   `Rails::Application` tem um, de modo que o servidor o chama a cada
   requisição. O Sinatra não precisa dessa linha no `app.rb`, porque inicia o
   próprio servidor.

## Por que esta toolchain
- **O Rails** é o framework web mais conhecido da comunidade Ruby: o Stack
  Overflow Developer Survey 2026 lista o Ruby on Rails com 5,7% dos 583 de
  10.281 respondentes que responderam à pergunta sobre frameworks web [15], e
  o próprio Ruby é a linguagem do Rails (veja a
  [página da linguagem](../README.md#market-usage-today) para os números de
  mercado). O site do Rails o chama de um framework que "scales from PROMPT
  to IPO" (tradução livre: "escala do PROMPT ao IPO") e indica como versão
  atual a 8.1.4.1, lançada em 2026-11-04 [3]. Essa é a versão do `Gemfile`.
- **Por que não `rails new`?** O gerador é a forma usual de começar um
  projeto Rails, e o guia Getting Started o documenta [6]. Ele cria dezenas
  de arquivos, uma configuração de banco de dados e uma configuração do
  Docker, que escondem a única ideia que este repositório quer mostrar. Os
  colaboradores do Rails usam o mesmo tipo de programa de arquivo único em
  relatos de bugs: o guia deles oferece "bug report templates" como "a
  starting point" [16] (tradução livre: "modelos de relato de bug" como "um
  ponto de partida").
- **Railties e Action Pack, não a gem `rails`.** A gem `rails` é o pacote de
  todos os frameworks do Rails. Estas duas gems são o menor conjunto que
  fornece um roteador e um controller. Todo o resto fica de fora de
  propósito, para que a instalação seja menor e o programa mais curto.
- **O Puma e o Rackup** são o mesmo par da [../web](../web/), de modo que as
  duas versões web diferem apenas no framework. O guia do Rails mostra o
  Puma como o servidor de uma aplicação Rack: "gem install puma" e depois
  "puma" [8].
- **A porta 8080** é a convenção deste repositório para toda implementação
  web. O guia Getting Started atende na 3000 [6].
- **Configurações de desenvolvimento.** Sem nenhum ambiente definido, o
  Rails executa em modo de desenvolvimento e registra cada requisição no
  terminal (veja a saída abaixo). Uma implantação em produção exige mais
  configurações, que estão fora do escopo de um programa Hello World.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-19) | Ruby 4.0.7, Rails 8.1.4.1 (railties, actionpack), Puma 8.1.1. O Puma e o nio4r têm uma parte em C, que o `bundle install` compilou neste computador. O Nokogiri veio como uma gem pré-compilada para `x86_64-darwin`. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `ruby-full` e `build-essential` com o apt quando o `ruby` não existe [17] e o `bundler` quando o `bundle` não existe. Em seguida, instala as gems em `vendor/bundle`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O Ruby da imagem do runner não tem o Bundler; por isso o `install.sh` instala os pacotes do MSYS2 para Ruby 4.0 (com o Bundler), GCC e `make` com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`) e coloca `C:\msys64\ucrt64\bin` no início do PATH. Um pequeno wrapper `bundle` em `languages/ruby/msys2-bin` permite que o Git Bash inicie o Bundler, e as gems com uma parte em C são compiladas com o `make` do MSYS2. No Windows, o Gemfile adiciona a gem `tzinfo-data`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C). As linhas `INFO` e
`DEBUG` aparecem quando uma requisição chega:
```text
==> Start the web server on http://localhost:8080
    WHY: 'rackup' loads config.ru and serves the Rails app with Puma on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Puma starting in single mode...
* Puma version: 8.1.1 ("Puma Psychosis")
* Ruby version: ruby 4.0.7 (2026-09-15 revision 229531a6cf) +PRISM [x86_64-darwin23]
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 49128
* Listening on http://127.0.0.1:8080
Use Ctrl-C to stop
I, [2026-11-04T20:55:21.786037 #49128]  INFO -- : Started GET "/" for 127.0.0.1 at 2026-11-04 20:55:21 -0300
I, [2026-11-04T20:55:21.841262 #49128]  INFO -- : Processing by HelloController#index as HTML
D, [2026-11-04T20:55:21.856905 #49128] DEBUG -- :   Rendering html template
I, [2026-11-04T20:55:21.857119 #49128]  INFO -- :   Rendered html template (Duration: 0.0ms | GC: 0.0ms)
I, [2026-11-04T20:55:21.857558 #49128]  INFO -- : Completed 200 OK in 16ms (Views: 13.4ms | GC: 0.0ms)
```
Em um segundo terminal (os cabeçalhos que o Rails acrescenta estão abreviados
aqui):
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
x-frame-options: SAMEORIGIN
content-type: text/html; charset=utf-8
content-length: 20

<p>Hello, World!</p>
```
Um navegador também pede `/favicon.ico`. A aplicação não tem rota para ele,
de modo que o log mostra um `RoutingError` para essa requisição e o servidor
responde 404. A página não é afetada.

O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. About Ruby. Ruby community. <https://www.ruby-lang.org/en/about/> (acessado em 2026-11-04)
2. Getting Started with Rails. Ruby on Rails Guides. <https://guides.rubyonrails.org/getting_started.html> (acessado em 2026-11-04)
3. Ruby on Rails. Rails team. <https://rubyonrails.org/> (acessado em 2026-11-04)
4. The Rails Doctrine. David Heinemeier Hansson, rubyonrails.org. <https://rubyonrails.org/doctrine> (acessado em 2026-11-04)
5. Sinatra. Sinatra project. <https://sinatrarb.com/> (acessado em 2026-11-04)
6. Getting Started with Rails: Creating Your First Rails App, Directory Structure, Model-View-Controller Basics. Ruby on Rails Guides. <https://guides.rubyonrails.org/getting_started.html#creating-your-first-rails-app> (acessado em 2026-11-04)
7. bundle config. Bundler documentation, RubyGems Guides. <https://guides.rubygems.org/command-reference/bundle-config/> (acessado em 2026-11-04)
8. Rails on Rack. Ruby on Rails Guides. <https://guides.rubyonrails.org/rails_on_rack.html> (acessado em 2026-11-04)
9. Using Bundler in applications. RubyGems Guides. <https://guides.rubygems.org/using_bundler_in_applications/> (acessado em 2026-11-04)
10. Gemfile. RubyGems Guides. <https://guides.rubygems.org/gemfile/> (acessado em 2026-11-04)
11. How Gemfile.lock works. RubyGems Guides. <https://guides.rubygems.org/gemfile-lock/> (acessado em 2026-11-04)
12. Configuring Rails Applications. Ruby on Rails Guides. <https://guides.rubyonrails.org/configuring.html> (acessado em 2026-11-04)
13. Configuring Rails Applications: Versioned Default Values. Ruby on Rails Guides. <https://guides.rubyonrails.org/configuring.html#versioned-default-values> (acessado em 2026-11-04)
14. Rails Routing from the Outside In: Using root. Ruby on Rails Guides. <https://guides.rubyonrails.org/routing.html> (acessado em 2026-11-04)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
16. Contributing to Ruby on Rails: Reporting an Issue. Ruby on Rails Guides. <https://guides.rubyonrails.org/contributing_to_ruby_on_rails.html> (acessado em 2026-11-04)
17. Installing Ruby. Ruby community. <https://www.ruby-lang.org/en/documentation/installation/> (acessado em 2026-11-04)
