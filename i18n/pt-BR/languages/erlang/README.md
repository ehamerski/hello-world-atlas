---
source: languages/erlang/README.md
source_sha: e4483f5258480a7200b48794255aa1f01758f68a
---
# Erlang

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** funcional e concorrente, de tipagem dinâmica. O site do
Erlang descreve a linguagem como "a programming language used to build
massively scalable soft real-time systems" "with requirements on high
availability", e diz que seu "runtime system has built-in support for
concurrency, distribution and fault tolerance" [1] (tradução livre: "uma
linguagem de programação usada para construir sistemas de tempo real
brando massivamente escaláveis" "com requisitos de alta disponibilidade", e
"o sistema de runtime tem suporte embutido para concorrência, distribuição e
tolerância a falhas"). Suas unidades de programa são os processos: leves e
parte da linguagem, não do sistema operacional [2].

Veja também: [paradigmas](../../docs/paradigms.md#functional) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

O que estas palavras significam aqui:

- **Funcional:** um programa é construído a partir de funções, e uma
  variável "can only be bound once" [3] (tradução livre: "só pode ser
  vinculada uma vez"). Armstrong escreve que o projeto do Erlang terminou
  com "removing virtually all traces of Prolog from the language and adding
  many well-known features from functional languages" (tradução livre:
  "remover praticamente todos os vestígios do Prolog da linguagem e
  acrescentar muitos recursos conhecidos das linguagens funcionais"), como
  funções de ordem superior e compreensões de lista [2]. Uma função se
  repete chamando a si mesma: a versão [desktop](desktop/) não tem laço
  `while`, apenas uma função, `loop/1`, que chama a si mesma.
- **De tipagem dinâmica:** o tipo de um valor é verificado quando o programa
  é executado. Armstrong escreve que o Erlang "has always had a dynamic type
  system" [2] (tradução livre: "sempre teve um sistema de tipos dinâmico").
- **Concorrente:** "In Erlang, each thread of execution is called a
  process", e os processos "share no data" [4] (tradução livre: "No Erlang,
  cada linha de execução é chamada de processo", e os processos "não
  compartilham dados"). O resumo do artigo de Armstrong diz que eles "have no
  shared memory and communicate by asynchronous message passing" [2]
  (tradução livre: "não têm memória compartilhada e se comunicam por troca
  assíncrona de mensagens"). Uma mensagem vai para a fila de entrada de um
  processo, e a expressão `receive` retira a primeira que corresponde a um
  padrão [3][4]. A versão [desktop](desktop/) é um laço desse tipo. Um
  servidor web é um grupo de tais processos.

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | Erlang/OTP (`escript hello.erl`) | ✅ |
| desktop | [desktop/](desktop/) | Erlang/OTP, `wx` (`wxWidgets`) | ✅ |
| web | [web/](web/) | Erlang/OTP, `httpd` do `inets` | ✅ |

## Histórico
Joe Armstrong, Robert Virding e Mike Williams criaram o Erlang no Ericsson
Computer Science Laboratory. O artigo de Armstrong "A History of Erlang"
(HOPL III, 2007) diz: "The initial development of Erlang took place in 1986
at the Ericsson Computer Science Laboratory (the Lab)." O objetivo era "to
provide a better way of programming telephony applications" [2] (tradução
livre: "O desenvolvimento inicial do Erlang ocorreu em 1986 no Ericsson
Computer Science Laboratory (o Lab)." O objetivo era "oferecer uma forma
melhor de programar aplicações de telefonia"). As aplicações de telefonia
"are by their nature highly concurrent", com software que é "expected to be
highly fault-tolerant" e que precisa ser alterado "on the fly", "without
loss of service" [2] (tradução livre: "são, por natureza, altamente
concorrentes", com software do qual "se espera alta tolerância a falhas" e
que precisa ser alterado "em tempo de execução", "sem perda de serviço").

**Do Prolog a uma linguagem própria.** Armstrong começou com um
metainterpretador em Prolog, ao qual acrescentou processos paralelos. Ele
escreve: "What started as an experiment in 'adding concurrency to Prolog'
became more of a language in its own right and this language acquired a name
'Erlang,' which was probably coined by Bjarne Däcker." (tradução livre: "O
que começou como um experimento de 'acrescentar concorrência ao Prolog'
tornou-se mais uma linguagem por si só, e essa linguagem recebeu o nome
'Erlang', que provavelmente foi cunhado por Bjarne Däcker.") Alguns diziam
que o nome significava "Ericsson Language", enquanto outros diziam que
homenageava Agner Krarup Erlang (1878–1929), e a equipe "deliberately
encouraged this ambiguity" [2] (tradução livre: "incentivou deliberadamente
essa ambiguidade"). Robert Virding escreveu então uma segunda implementação,
também em Prolog, e os dois se revezaram reescrevendo o código um do outro
[2]. Em 1987, "Erlang was regarded as a new programming language that we had
prototyped in Prolog" [2] (tradução livre: "o Erlang era considerado uma
nova linguagem de programação que havíamos prototipado em Prolog").

**Uma máquina virtual.** Os interpretadores em Prolog eram lentos. No início
de 1990, Armstrong entendeu as máquinas abstratas das linguagens lógicas
paralelas o bastante para projetar a máquina virtual JAM. Mike Williams
escreveu seu emulador em C, que "ran 70 times faster than the original
Prolog emulator" [2] (tradução livre: "rodava 70 vezes mais rápido que o
emulador Prolog original"). Em 1990, "the language acquired its own syntax"
porque a equipe precisou escrever seu próprio parser, e "the Erlang
implementor group had expanded to three, Mike, Robert and myself" [2]
(tradução livre: "a linguagem adquiriu sua própria sintaxe" e "o grupo de
implementadores do Erlang havia crescido para três: Mike, Robert e eu
mesmo"). Em 1993, "the Turbo Erlang system started working", criado por
Bogumil (Bogdan) Hausman (tradução livre: "o sistema Turbo Erlang começou a
funcionar"). Seu nome foi mudado para BEAM, e "BEAM programs compiled to C
ran about ten times faster than JAM interpreted programs" [2] (tradução
livre: "programas BEAM compilados para C rodavam cerca de dez vezes mais
rápido que programas JAM interpretados").

**Código aberto.** No início do projeto AXD, foram feitos planos para
construir uma unidade de produto, chamada OTP, para dar suporte ao sistema
Erlang. "OTP stands for the 'Open Telecom Platform' and is both the name of
the Erlang software distribution and the name of an Ericsson product unit"
(tradução livre: "OTP significa 'Open Telecom Platform' e é, ao mesmo tempo,
o nome da distribuição de software do Erlang e o nome de uma unidade de
produto da Ericsson"). Desde 1997, a unidade OTP é responsável pela
distribuição do Erlang [2]. Em 1998, o Erlang foi proibido dentro da
Ericsson Radio AB para o desenvolvimento de novos produtos. O artigo chama
isso de "the second most significant event in the history of Erlang: It led
indirectly to Open Source Erlang and was the main reason why Erlang started
spreading outside Ericsson." (tradução livre: "o segundo evento mais
significativo da história do Erlang: levou indiretamente ao Erlang de código
aberto e foi o principal motivo pelo qual o Erlang começou a se espalhar
fora da Ericsson."). Ele acrescenta: "On 2 December 1998, Open Source Erlang
was announced" [2] (tradução livre: "Em 2 de dezembro de 1998, o Erlang de
código aberto foi anunciado"). A maior parte da equipe original deixou então
a Ericsson e fundou uma empresa, a Bluetail AB [2]. Hoje, a documentação do
Erlang/OTP traz o aviso de direitos autorais "Copyright © 1996-2026 Ericsson
AB" [5], e o OTP 29.1.2 foi publicado em 2026-10-14 [6].

**De onde vêm as ideias.** Armstrong escreve que "The early syntax of
Erlang came straight from Prolog" e que "The only remaining signs of the
Prolog heritage lie in the syntax for atoms and variables, the scoping rules
for variables and the dynamic type system" [2] (tradução livre: "A sintaxe
inicial do Erlang veio diretamente do Prolog" e "Os únicos sinais restantes
da herança do Prolog estão na sintaxe de átomos e variáveis, nas regras de
escopo das variáveis e no sistema de tipos dinâmico"). Armstrong lista as
linguagens com processos que a equipe conhecia quando o Erlang foi
implementado pela primeira vez: "Ada (with tasks), EriPascal (an Ericsson
dialect of Pascal with concurrent processes), Chill (with processes), PLEX
(with its own special form of processes implemented in hardware) and Euclid"
[2] (tradução livre: "Ada (com tarefas), EriPascal (um dialeto de Pascal da
Ericsson com processos concorrentes), Chill (com processos), PLEX (com sua
própria forma especial de processos implementada em hardware) e Euclid").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1986 | Desenvolvimento inicial do Erlang no Ericsson Computer Science Laboratory | [2] |
| 1987 | O Erlang é considerado uma nova linguagem, prototipada em Prolog, e está pronto para usuários externos | [2] |
| 1990 | A linguagem ganha sua própria sintaxe; a máquina virtual JAM roda 70 vezes mais rápido que o emulador Prolog | [2] |
| 1990 (meados) | A Ericsson entrega uma cópia do Erlang à Bellcore, seu primeiro usuário externo | [2] |
| 1993 | O sistema Turbo Erlang começa a funcionar; seu nome é mudado para BEAM | [2] |
| 1997 | A unidade OTP é formada como nova unidade de produto e se torna responsável pela distribuição do Erlang | [2] |
| 1998-02 | O Erlang é proibido dentro da Ericsson Radio Systems | [2] |
| 1998-03 | O AXD301 é anunciado, "possibly the largest ever program in a functional language" (tradução livre: "possivelmente o maior programa já feito em uma linguagem funcional") | [2] |
| 1998-12-02 | O Erlang de código aberto é anunciado | [2] |
| 2026-10-14 | OTP 29.1.2, a versão usada neste repositório | [6] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Stack Overflow Developer Survey 2026:** 1,5% de todos os respondentes da
  pergunta sobre linguagens de programação usaram Erlang (218 de 14.099)
  [7]. Na mesma pesquisa, 2,8% dos respondentes querem trabalhar com ela
  ("Desired"), e 49,1% dos que a usaram querem continuar usando
  ("Admired") [7].
- **Índice TIOBE, outubro de 2026:** o Erlang não está entre os 50
  primeiros. O índice o lista apenas pelo nome entre as linguagens "#51 to
  #100", sem posição nem avaliação [8].

Os números medem coisas diferentes. A pesquisa do Stack Overflow conta os
desenvolvedores que a responderam, e o TIOBE conta resultados de mecanismos
de busca. O Erlang tem uma participação pequena em ambos. Na pesquisa, 49,1%
dos que o usaram querem continuar usando, enquanto 2,8% de todos os
respondentes querem trabalhar com ele [7].

## Importância antes e agora
- **Antes (1986–1998):** o Erlang resolvia um problema específico: centrais
  telefônicas que precisam tratar "tens or hundreds of thousands of
  simultaneous transactions" e que não podem parar para atualizações de
  código [2] (tradução livre: "dezenas ou centenas de milhares de transações
  simultâneas"). O AXD301, anunciado em 1998, "has 2.6 millions lines of
  Erlang code" na época do artigo (2007), e Armstrong diz que ele "is also
  highly reliable and runs in realtime" [2] (tradução livre: "tem 2,6
  milhões de linhas de código Erlang" e "também é altamente confiável e
  roda em tempo real").
- **Agora:** o site do Erlang descreve a linguagem como usada "to build
  massively scalable soft real-time systems" [1] (tradução livre: "para
  construir sistemas de tempo real brando massivamente escaláveis"). As
  versões continuam: o OTP 29.1.2 foi publicado em 2026-10-14 [6]. O Erlang
  também é a base de outras linguagens: o [Elixir](../elixir/) roda na
  máquina virtual do Erlang, e sua equipe diz que "the whole Erlang
  ecosystem is also available to Elixir developers" [9] (tradução livre:
  "todo o ecossistema Erlang também está disponível para os desenvolvedores
  Elixir").
- **No ensino:** o Erlang é o exemplo deste repositório de uma linguagem em
  que processos e mensagens são os blocos básicos de construção. A versão
  [desktop](desktop/) é um processo que espera por uma mensagem, e a versão
  [web](web/) inicia um servidor web que acompanha a distribuição. A versão
  em [Prolog](../prolog/) deste programa mostra a linguagem da qual o Erlang
  partiu.

## Comparando as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Código-fonte | um escript: `hello.erl` | um módulo: `hello_wx.erl` | um módulo: `hello_httpd.erl` |
| Executar com | `escript hello.erl` | `erl -noshell -pa ebin -s hello_wx main -s init stop` | `erl -noshell -pa ebin -s hello_httpd main` |
| Build | nenhum: "By default, the script will be compiled by the Erlang compiler" na memória [10] (tradução livre: "Por padrão, o script será compilado pelo compilador do Erlang") | `erlc` grava `ebin/hello_wx.beam` | `erlc` grava `ebin/hello_httpd.beam` |
| Bibliotecas | `io` da biblioteca padrão | `wx`, "an erlang binding of `wxWidgets`" [11] (tradução livre: "um binding Erlang do `wxWidgets`") | `httpd` da aplicação `inets` [12] |
| Downloads | nenhum | nenhum: o `wx` acompanha o Erlang/OTP | nenhum: o `inets` acompanha o Erlang/OTP |
| Ponto de entrada | `main/1`, chamada pelo `escript` | `hello_wx:main/0`, chamada com `-s` | `hello_httpd:main/0`, chamada com `-s`; `do/1` é chamada pelo `httpd` a cada requisição |
| Saída | `Hello, World!` na saída padrão | um rótulo em uma janela nativa | `<p>Hello, World!</p>` na resposta a `GET /`, em `PORT` (padrão 8080) |
| Termina | após a última expressão | quando o usuário fecha a janela | quando você pressiona Ctrl+C |

O que permanece igual: as três rodam na BEAM, e as três usam apenas o que o
Erlang/OTP inclui. A versão desktop acrescenta um laço de mensagens, e a
versão web acrescenta um callback que um servidor chama.

## Fontes
1. Erlang/OTP home page. Ericsson AB, erlang.org. <https://www.erlang.org/> (acessado em 2026-11-04)
2. A History of Erlang. Joe Armstrong, HOPL III, ACM SIGPLAN, 2007 (DOI 10.1145/1238844.1238850). Author's copy. <https://lfe.io/papers/%5B2007%5D%20Armstrong%20-%20HOPL%20III%20A%20History%20of%20Erlang.pdf> (acessado em 2026-11-04)
3. Expressions (variables, `receive`). Erlang/OTP documentation, Reference Manual. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/expressions.html> (acessado em 2026-11-04)
4. Conc prog (processes and message passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (acessado em 2026-11-04)
5. Getting started (page footer). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/getting_started.html> (acessado em 2026-11-04)
6. Releases. erlang/otp, GitHub (release `OTP-29.1.2`). <https://github.com/erlang/otp/releases> (acessado em 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data; languages, admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
9. Elixir v1.0 released. José Valim, elixir-lang.org, 2014-09-18. <https://elixir-lang.org/blog/2014/09/18/elixir-v1-0-0-released/> (acessado em 2026-11-04)
10. escript. Erlang/OTP documentation, erts. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/erts/escript_cmd.html> (acessado em 2026-11-04)
11. wx (chapter). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/wx/chapter.html> (acessado em 2026-11-04)
12. httpd. Erlang/OTP documentation, inets. Ericsson AB, erlang.org. <https://www.erlang.org/doc/apps/inets/httpd.html> (acessado em 2026-11-04)
