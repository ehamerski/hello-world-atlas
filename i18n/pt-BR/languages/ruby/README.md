---
source: languages/ruby/README.md
source_sha: 7cd40d333c9c3c8e11edc0a42930b4d551b1b34c
---
# Ruby

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** orientado a objetos, com recursos imperativos e funcionais. O
site oficial descreve o Ruby como uma linguagem que "balanced functional
programming with imperative programming" [1] (tradução livre: "equilibrou a
programação funcional com a programação imperativa") e afirma que "In Ruby,
everything is an object" [1] (tradução livre: "No Ruby, tudo é um objeto").
Os programas Hello World deste repositório usam apenas o estilo imperativo: as
instruções são executadas de cima para baixo, e as versões web passam um bloco
(um trecho de código) a um método.

Veja também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos outros) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com as
demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Ruby (`ruby`) | ✅ |
| desktop | [desktop/](desktop/) | Ruby/Tk (gem `tk`), Tcl/Tk | ✅ |
| web | [web/](web/) | Sinatra, Puma | ✅ |
| web-rails | [web-rails/](web-rails/) | Ruby on Rails, Puma | ✅ |

## Histórico
Yukihiro "Matz" Matsumoto criou o Ruby. O FAQ oficial resume o relato que ele
escreveu em 1999 [2]:

- "Ruby was born on February 24, 1993." (tradução livre: "O Ruby nasceu em 24
  de fevereiro de 1993.") Ele estava "talking with my colleague about the
  possibility of an object-oriented scripting language" (tradução livre:
  "conversando com meu colega sobre a possibilidade de uma linguagem de script
  orientada a objetos").
- Ele conhecia o Perl, mas "didn’t like it really, because it had the smell of
  a toy language" (tradução livre: "não gostava dele de verdade, porque tinha
  cheiro de linguagem de brinquedo"). Conhecia também o Python, mas "didn’t
  think it was a true object-oriented language—OO features appeared to be an
  add-on to the language" (tradução livre: "não achava que fosse uma
  verdadeira linguagem orientada a objetos; os recursos de orientação a
  objetos pareciam um acréscimo à linguagem").
- "I really wanted a genuine object-oriented, easy-to-use scripting language.
  I looked for, but couldn’t find one. So, I decided to make it." (tradução
  livre: "Eu queria muito uma linguagem de script genuinamente orientada a
  objetos e fácil de usar. Procurei, mas não encontrei. Então decidi criá-la.")
- "It took several months to make the interpreter run." (tradução livre:
  "Levou vários meses para fazer o interpretador funcionar.") Ele acrescentou
  "iterators, exception handling, garbage collection" (tradução livre:
  "iteradores, tratamento de exceções, coleta de lixo") e "reorganized the
  features of Perl into a class library" (tradução livre: "reorganizou os
  recursos do Perl em uma biblioteca de classes").
- "I posted Ruby 0.95 to the Japanese domestic newsgroups in Dec. 1995."
  (tradução livre: "Publiquei o Ruby 0.95 nos newsgroups domésticos japoneses
  em dez. de 1995.")

A linguagem recebeu o nome de uma pedra preciosa: "Influenced by Perl, Matz
wanted to use a jewel name for his new language, so he named Ruby after a
colleague’s birthstone" [3] (tradução livre: "Influenciado pelo Perl, Matz
quis usar o nome de uma joia para a sua nova linguagem e, por isso, deu ao Ruby
o nome da pedra de nascimento de um colega").
O site oficial lista as linguagens que Matz combinou: "Perl, Smalltalk,
Eiffel, Ada, and Lisp" [1] (tradução livre: "Perl, Smalltalk, Eiffel, Ada e
Lisp"). Ele atribui ao Smalltalk o mérito de dar "methods and instance
variables to all of its types" (tradução livre: "métodos e variáveis de
instância a todos os seus tipos") e cita Matz sobre os blocos: "in Ruby
closures, I wanted to respect the Lisp culture" [1] (tradução livre: "nas
closures do Ruby, eu quis respeitar a cultura do Lisp").

O Ruby cresceu com a web. A mesma página diz que "Much of the growth is
attributed to the popularity of software written in Ruby, particularly the
Ruby on Rails web framework" [1] (tradução livre: "Grande parte do crescimento
é atribuída à popularidade de software escrito em Ruby, em particular o
framework web Ruby on Rails"). O Rails é um projeto separado, um framework
escrito em Ruby; veja [web-rails](web-rails/README.md#language-and-framework)
para a diferença entre uma linguagem e um framework.

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1993-02-24 | O Ruby é concebido (data do próprio Matz, corrigida em uma mensagem posterior) | [2] |
| 1995-12 | O Ruby 0.95 é publicado nos newsgroups japoneses, a primeira versão pública | [2] |
| 2003-08-04 | Ruby 1.8.0 | [4] |
| 2005-12-13 | Ruby on Rails 1.0, anunciado "15 months after the first public release" (tradução livre: "15 meses após a primeira versão pública") | [5] |
| 2006 | "Ruby achieved mass acceptance" (tradução livre: "o Ruby alcançou aceitação em massa"); o TIOBE nomeia o Ruby a linguagem de programação do ano | [1][6] |
| 2007-12-25 | Ruby 1.9.0 | [4] |
| 2013-02-24 | Ruby 2.0.0, "the first stable release of the Ruby 2.0 series" (tradução livre: "a primeira versão estável da série Ruby 2.0") | [7] |
| 2020-12-25 | Ruby 3.0.0, com os objetivos "performance, concurrency, and Typing" (tradução livre: "desempenho, concorrência e tipagem") | [8] |
| 2025-10 | Rails 8.1, a série usada neste repositório | [9] |
| 2025-12-25 | Ruby 4.0.0, que "introduces “Ruby Box” and “ZJIT”" (tradução livre: "introduz o “Ruby Box” e o “ZJIT”") | [10] |
| 2026-09-15 | Ruby 4.0.7, a versão usada neste repositório | [4] |

A página de manutenção lista a data de lançamento de 25 de dezembro para cada
versão secundária, de 2.1 (2013-12-25) a 4.0 (2025-12-25) [11].

## Uso no mercado hoje
Cada número abaixo tem a sua data e a sua fonte. Eles mudam todo ano.

- **Índice TIOBE, outubro de 2026:** o Ruby ocupa a 28ª posição, com uma
  avaliação de 0,53% [12]. O site oficial do Ruby diz, sem indicar o ano, que
  o Ruby "is ranked among the top 10 on most of the indices" [1] (tradução
  livre: "está classificado entre os 10 primeiros na maioria dos índices"); o
  valor de 2026 acima é menor.
- **Stack Overflow Developer Survey 2026:** 5,8% dos respondentes da pergunta
  sobre linguagens de programação usaram o Ruby (823 de 14.099) [13]. Na
  pergunta sobre frameworks web, 5,7% usaram o Ruby on Rails (583 de 10.281)
  [13].
- **"Programming Language of the Year" do TIOBE:** o Ruby o ganhou em 2006
  [6]. O prêmio vai para "the programming language that has the highest rise
  in ratings in a year" [6] (tradução livre: "a linguagem de programação que
  tem o maior aumento de avaliação em um ano").
- **Site do Rails, 2026-11-04:** "There have been many hundreds of thousands of
  apps created with Rails since its inception" e "Over six thousand people
  have contributed code to Rails" [14] (tradução livre: "Centenas de milhares
  de aplicações foram criadas com o Rails desde o seu início" e "Mais de seis
  mil pessoas contribuíram com código para o Rails"). Esta é a declaração do
  próprio projeto Rails, e não uma contagem independente.

## Importância antes e agora
- **Antes (1993–2006):** Matz queria uma linguagem de script orientada a
  objetos e não encontrou nenhuma de que gostasse [2]. Matz publicou a
  primeira versão em newsgroups japoneses, e "highly active mailing lists have
  been established and web pages formed" desde então [2] (tradução livre:
  "foram criadas listas de discussão muito ativas e páginas web"). O site
  oficial data a "aceitação em massa" da linguagem em 2006 [1].
- **Rails:** o Rails 1.0 foi lançado em 2005 [5]. O site do Rails descreve o
  Rails como um "full-stack framework" [14] (tradução livre: "framework
  full-stack"), e o site oficial do Ruby atribui a ele grande parte do
  crescimento do Ruby [1].
- **Agora:** o Ruby está no meio dos rankings de 2026: 28º no TIOBE, 5,8% dos
  respondentes do Stack Overflow [12][13]. Ele mantém um ritmo anual de
  lançamentos [11] e uma versão principal, a 4.0, de dezembro de 2025 [10]. O
  Rails também está atual: a versão 8.1.4.1 foi lançada em 2026-11-04 [14].

## Comparando as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) | [web-rails](web-rails/) |
|---|---|---|---|---|
| Linhas de Ruby (sem comentários) | 1 | 16 (7 são a autoverificação) | 6 | 18 |
| O que usa | `puts`, nativo | gem `tk` (Ruby/Tk) e Tcl/Tk | Sinatra e Puma | Rails (railties, actionpack), Rackup e Puma |
| Instalação extra | nenhuma | Tcl/Tk (`tcl-tk` do Homebrew), um compilador C e a gem em `vendor/bundle` | gems em `vendor/bundle` (`Gemfile`) | gems em `vendor/bundle` (`Gemfile`) |
| Etapa de build | nenhuma | nenhuma para o programa; a gem é compilada pelo `bundle install` | nenhuma | nenhuma |
| Como é executado | de cima para baixo, e então termina | laço de eventos `Tk.mainloop` até a janela fechar | `ruby app.rb`: o Sinatra inicia o Puma, que atende até Ctrl+C | `rackup config.ru`: o Puma chama a aplicação Rails até Ctrl+C |
| Saída | texto na saída padrão | uma janela nativa | uma página HTML via HTTP em `localhost:8080` | a mesma, a partir de um controller do Rails |

A versão cli é uma lista direta de instruções, sem biblioteca e sem etapa de
build. As versões desktop e web entregam o controle a um laço que aguarda
eventos (um clique ou uma requisição HTTP) e chama o seu código quando um
chega. As três que usam uma biblioteca a listam em um `Gemfile`, e o Bundler
instala na pasta do projeto exatamente as versões do `Gemfile.lock`.

As duas versões web mostram a diferença entre um framework pequeno e um grande
na mesma linguagem. O Sinatra precisa de um arquivo e de um bloco por rota. O
Rails separa a rota (`root to: "hello#index"`) do tratador (um método de uma
classe controller) e os conecta por uma convenção de nomes, o que compensa
quando uma aplicação tem muitas rotas, models e views. O
[README do web-rails](web-rails/README.md#language-and-framework) traz a
comparação completa.

As quatro categorias planejadas para o Ruby estão implementadas, de modo que
esta página não tem uma seção "por que não há <categoria>".

## Fontes
1. About Ruby. Ruby community. <https://www.ruby-lang.org/en/about/> (acessado em 2026-11-04)
2. Ruby FAQ: What is the history of Ruby? (a summary of a posting by Matz, ruby-talk:00382, 1999-06-04). Ruby community. <https://www.ruby-lang.org/en/documentation/faq/1/> (acessado em 2026-11-04)
3. Ruby FAQ: Why the name “Ruby”? Ruby community. <https://www.ruby-lang.org/en/documentation/faq/1/> (acessado em 2026-11-04)
4. Ruby Releases. Ruby community. <https://www.ruby-lang.org/en/downloads/releases/> (acessado em 2026-11-04)
<!-- vale off -->
5. Rails 1.0: Party like it's one oh oh! David Heinemeier Hansson, rubyonrails.org, 2005-12-13. <https://rubyonrails.org/2005/12/13/rails-1-0-party-like-its-one-oh-oh> (acessado em 2026-11-04)
<!-- vale on -->
6. TIOBE Index for October 2026, "Programming Language Hall of Fame". TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
7. Ruby 2.0.0-p0 is released. Ruby community, 2013-02-24. <https://www.ruby-lang.org/en/news/2013/02/24/ruby-2-0-0-p0-is-released/> (acessado em 2026-11-04)
8. Ruby 3.0.0 Released. Ruby community, 2020-12-25. <https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/> (acessado em 2026-11-04)
9. Rails 8.1: Job continuations, structured events, local CI. Rails team, rubyonrails.org, 2025-10-22. <https://rubyonrails.org/2025/10/22/rails-8-1> (acessado em 2026-11-04)
10. Ruby 4.0.0 Released. Ruby community, 2025-12-25. <https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released/> (acessado em 2026-11-04)
11. Ruby Maintenance Branches. Ruby community. <https://www.ruby-lang.org/en/downloads/branches/> (acessado em 2026-11-04)
12. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
13. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
14. Ruby on Rails. Rails team. <https://rubyonrails.org/> (acessado em 2026-11-04)
