---
source: docs/paradigms.md
source_sha: 9201d9c93114cace91f36c4b21ae0b139e59d533
---
# Paradigmas de programação neste repositório

Este repositório representa os quatro paradigmas principais:
**orientado a objetos**, **lógico**, **funcional** e **imperativo**.

Esta página explica o que é cada paradigma, mostra o Hello World que o
representa neste repositório e indica quais linguagens pertencem a qual
paradigma. Quatro seções adicionais acompanham as ideias que atravessam os
quatro: o estilo **concorrente** de Erlang e Elixir e sua ligação com o modelo
de atores, as **origens da orientação a objetos** do Simula ao Swift, o
**Design by Contract** no Eiffel e a programação **quântica** com o QCL.

- [O que é um paradigma](#o-que-é-um-paradigma)
- [Imperativo](#imperativo)
- [Orientado a objetos](#orientado-a-objetos)
- [Funcional](#funcional)
- [Lógico](#lógico)
- [Concorrente: processos, mensagens e o modelo de atores](#concorrente-processos-mensagens-e-o-modelo-de-atores)
- [De onde veio a orientação a objetos](#de-onde-veio-a-orientação-a-objetos)
- [Design by Contract](#design-by-contract)
- [Quântico](#quântico)
- [Todas as linguagens e seus paradigmas](#todas-as-linguagens-e-seus-paradigmas)
- [O que um Hello World pode e não pode mostrar](#o-que-um-hello-world-pode-e-não-pode-mostrar)
- [Fontes](#fontes)

## O que é um paradigma
Peter Van Roy, autor de um livro-texto que compara paradigmas, define um
paradigma da seguinte maneira: "A programming paradigm is an approach to
programming a computer based on a mathematical theory or a coherent set of
principles" [1] (tradução livre: "Um paradigma de programação é uma
abordagem para programar um computador com base em uma teoria matemática
ou em um conjunto coerente de princípios"). Ele acrescenta que "Each
paradigm supports a set of concepts that makes it the best for a certain
kind of problem" [1] (tradução livre: "Cada paradigma oferece suporte a um
conjunto de conceitos que o torna o melhor para um certo tipo de
problema").

Assim, um paradigma não é uma linguagem: é uma forma de pensar
um programa, e uma linguagem torna certas formas mais fáceis do que
outras.

Alan Kay, que deu nome à programação orientada a objetos, escreveu em 1993
que "Programming languages can be categorized in a number of ways:
imperative, applicative, logic-based, problem-oriented, etc." [2]
(tradução livre: "As linguagens de programação podem ser classificadas de
várias maneiras: imperativas, aplicativas, baseadas em lógica, orientadas
a problemas etc."). Muitas linguagens oferecem suporte a mais de um
paradigma. Van Roy chama isso de "multiparadigm programming" e defende que
"it should be the normal way of programming" [1] (tradução livre:
"programação multiparadigma [...] deveria ser a forma normal de
programar"). Por isso, várias linguagens da tabela adiante têm dois
rótulos.

Os quatro paradigmas diferem principalmente quanto a **de que um programa
é feito** e a **como ele altera as coisas**:

| Paradigma | Um programa é… | Como as coisas mudam | Representante neste repositório |
|---|---|---|---|
| Imperativo | uma sequência de instruções | as instruções alteram variáveis, passo a passo | [C](../languages/c/README.md) |
| Orientado a objetos | objetos que mantêm dados e comportamento | os objetos alteram o próprio estado ao receber mensagens (chamadas de método) | [Java](../languages/java/README.md) |
| Funcional | funções aplicadas a argumentos | nada é alterado: as funções devolvem novos valores | [Haskell](../languages/haskell/README.md) |
| Lógico | fatos e regras | nada é "executado" passo a passo: uma consulta é provada a partir das regras | [Prolog](../languages/prolog/README.md) |

## Imperativo
O programa diz ao computador **o que fazer, em ordem**. O padrão da
linguagem C o descreve em uma frase: "A statement specifies an action to
be performed. Except as indicated, statements are executed in sequence" [6]
(tradução livre: "Uma instrução especifica uma ação a ser realizada. Salvo
indicação em contrário, as instruções são executadas em sequência"). Van
Roy chama o conceito subjacente de *estado nomeado*: uma variável que tem
um nome e cujo conteúdo muda ao longo do tempo. "State introduces an
abstract notion of time in programs" [1] (tradução livre: "O estado
introduz nos programas uma noção abstrata de tempo").

A programação
*estruturada* (ou *procedural*) é a programação imperativa organizada em
procedimentos e blocos (`if`, laços) em vez de saltos; a carta de Dijkstra
de 1968, "Go To Statement Considered Harmful", argumentou contra os saltos
(`goto`) [9].

A versão em C, [`c/cli/hello.c`](../languages/c/cli/hello.c) (sem os comentários):
```c
#include <stdio.h>

int main(void)
{
    printf("Hello, World!\n");
    return 0;
}
```
Uma função, `main`, cujas instruções são executadas de cima para baixo:
chamar `printf` e, em seguida, devolver 0. O
[passo a passo](../languages/c/cli/README.md#step-by-step-walkthrough) explica cada
linha.

Linguagens imperativas neste repositório: [C](../languages/c/README.md), [Pascal](../languages/pascal/README.md),
[COBOL](../languages/cobol/README.md), [Fortran](../languages/fortran/README.md),
[BASIC](../languages/basic/README.md), [Clipper](../languages/clipper/README.md),
[dBASE](../languages/dbase/README.md), [ALGOL 68](../languages/algol68/README.md),
[Ada](../languages/ada/README.md), [Go](../languages/go/README.md), [PHP](../languages/php/README.md),
[Bash](../languages/bash/README.md), [Zig](../languages/zig/README.md),
[QCL](../languages/qcl/README.md) (imperativa, com operações quânticas:
consulte [Quântico](#quântico)),
[Assembly](../languages/assembly/README.md) (imperativa sem nada de permeio: cada
linha é uma instrução de CPU) e os três dialetos de
[pseudocódigo](../languages/pseudocode/README.md).

## Orientado a objetos
O programa é feito de **objetos**: cada um mantém juntos os seus próprios
dados e as operações sobre eles. Kay descreveu a ideia por trás do
Smalltalk como "a single kind of behavioral building block that hides its
combination of state and process inside itself and can be dealt with only
through the exchange of messages" e a chamou de "a new design
paradigm—which I called object-oriented" [2] (tradução livre: "um único
tipo de bloco de construção comportamental que oculta em si a combinação
de estado e processo e só pode ser manipulado por meio da troca de
mensagens"; "um novo paradigma de projeto, que chamei de orientado a
objetos").

Ele também recua a origem da ideia até o Simula, uma linguagem
da década de 1960: "Simula-67 added [inheritance] as a generalization to
the ALGOL-60 <block> structure" [2] (tradução livre: "O Simula-67
acrescentou [a herança] como uma generalização da estrutura de <bloco> do
ALGOL-60").

Java é o exemplo mais claro neste repositório. A sua especificação a
define como "a general-purpose, concurrent, class-based, object-oriented
language" [7] (tradução livre: "uma linguagem de propósito geral,
concorrente, baseada em classes e orientada a objetos"), e até o Hello
World precisa estar dentro de uma classe
([`java/cli/.../Hello.java`](../languages/java/cli/src/main/java/com/example/hello/Hello.java),
sem os comentários):
```java
package com.example.hello;

public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

`System.out` é um objeto (o fluxo de saída padrão) e `println` é uma
mensagem enviada a ele. Um Hello World não cria objetos próprios; por
isso, o estilo orientado a objetos aparece melhor nas versões desktop, nas
quais uma classe de janela estende uma classe do toolkit: consulte
[`java/desktop`](../languages/java/desktop/README.md#step-by-step-walkthrough),
[`csharp/desktop`](../languages/csharp/desktop/README.md#step-by-step-walkthrough)
(`override`) e [`cpp/desktop`](../languages/cpp/desktop/README.md#step-by-step-walkthrough)
(classes do Qt).

Linguagens orientadas a objetos neste repositório: [Java](../languages/java/README.md),
[C#](../languages/csharp/README.md), [C++](../languages/cpp/README.md) (multiparadigma),
[Ruby](../languages/ruby/README.md) (com recursos imperativos e funcionais;
seu README cita o site oficial: "In Ruby, everything is an object" (tradução
livre: "Em Ruby, tudo é um objeto")),
[Simula](../languages/simula/README.md), [Smalltalk](../languages/smalltalk/README.md),
[Objective-C](../languages/objectivec/README.md), [Swift](../languages/swift/README.md),
[Eiffel](../languages/eiffel/README.md), [Kotlin](../languages/kotlin/README.md),
[Scala](../languages/scala/README.md), [Dart](../languages/dart/README.md),
[Visual Basic](../languages/visual-basic/README.md) e
[Delphi](../languages/delphi/README.md). As próximas seções acompanham a
[história](#de-onde-veio-a-orientação-a-objetos) da ideia e um
[método de projeto](#design-by-contract) que nasceu dela.

Linguagens que adicionaram objetos posteriormente: [Ada](../languages/ada/README.md) (Ada 95),
[Fortran](../languages/fortran/README.md) (Fortran 2003), [COBOL](../languages/cobol/README.md)
(COBOL 2002), [PHP](../languages/php/README.md) (PHP 3 e 5) e o Object
[Pascal](../languages/pascal/README.md) (usado por [`pascal/desktop`](../languages/pascal/desktop/)).
O README de cada linguagem apresenta a fonte do seu próprio marco.

## Funcional
O programa é feito de **funções** no sentido matemático: dados os mesmos
argumentos, elas sempre devolvem o mesmo resultado e não alteram nada.

John Hughes, em "Why Functional Programming Matters": "Functional
programming is so called because its fundamental operation is the
application of functions to arguments" [3] (tradução livre: "A programação
funcional tem esse nome porque a sua operação fundamental é a aplicação de
funções a argumentos"), e "Functional programs contain no assignment
statements, so variables, once given a value, never change. More
generally, functional programs contain no side-effects at all" [3]
(tradução livre: "Os programas funcionais não contêm instruções de
atribuição; assim, as variáveis, depois de receberem um valor, nunca
mudam. De modo mais geral, os programas funcionais não contêm nenhum
efeito colateral").

Imprimir é um efeito colateral; então, como uma linguagem puramente
funcional pode imprimir? O Haskell 2010 Report descreve o Haskell como "a
general purpose, purely functional programming language" com "a monadic
I/O system" [8] (tradução livre: "uma linguagem de programação funcional
pura, de propósito geral"; "um sistema de E/S monádico"). O programa não
imprime; ele *devolve um valor que descreve* a impressão, uma ação `IO`, e
o runtime a executa
([`haskell/cli/hello.hs`](../languages/haskell/cli/hello.hs), sem os comentários):
```haskell
module Main (main) where

main :: IO ()
main = putStrLn "Hello, World!"
```

`main = ...` é uma equação, não uma instrução: `main` *é* a ação
`putStrLn "Hello, World!"`. O tipo `IO ()` o indica. O
[passo a passo](../languages/haskell/cli/README.md#step-by-step-walkthrough)
a examina linha por linha.

Linguagens funcionais neste repositório: [Haskell](../languages/haskell/README.md) (puramente
funcional), [Common Lisp](../languages/lisp/README.md) (multiparadigma, agrupada
com as funcionais; consulte o seu README),
[Clojure](../languages/clojure/README.md), [OCaml](../languages/ocaml/README.md),
[F#](../languages/fsharp/README.md), [Racket](../languages/racket/README.md),
[R](../languages/r/README.md), [Erlang](../languages/erlang/README.md) e
[Elixir](../languages/elixir/README.md). Erlang e Elixir também são as
linguagens [concorrentes](#concorrente-processos-mensagens-e-o-modelo-de-atores) daqui.
Scala e Kotlin reúnem recursos funcionais e orientados a objetos. Muitas linguagens populares
tomaram emprestados recursos funcionais, por exemplo as expressões lambda
em [Java](../languages/java/README.md) e [C#](../languages/csharp/README.md) e
[Rust](../languages/rust/README.md), cujo livro cita a programação funcional como "one
significant influence" (tradução livre: "uma influência significativa";
consulte o README do Rust).

## Lógico
O programa é um conjunto de **fatos e regras** escritos em lógica, e
executá-lo significa **fazer uma pergunta** que o sistema tenta provar.
Robert Kowalski o formulou assim em 1974: "An
axiomatisation of a problem domain is a program for solving problems in
that domain. Individual problems are posed as theorems to be proved" [4]
(tradução livre: "Uma axiomatização de um domínio de problemas é um
programa para resolver problemas nesse domínio. Os problemas individuais
são propostos como teoremas a provar").

Em 1979, ele o resumiu como
"Algorithm = Logic + Control": "An algorithm can
be regarded as consisting of a logic component, which specifies the
knowledge to be used in solving problems, and a control component, which
determines the problem-solving strategies by means of which that knowledge
is used" [5] (tradução livre: "Um algoritmo pode ser visto como composto
de um componente lógico, que especifica o conhecimento a ser usado na
resolução de problemas, e de um componente de controle, que determina as
estratégias de resolução por meio das quais esse conhecimento é usado").
O programador escreve a lógica; o sistema Prolog fornece o controle (a
busca).

A versão em Prolog, [`prolog/cli/hello.pl`](../languages/prolog/cli/hello.pl)
(sem os comentários):
```prolog
:- initialization(main, main).

main :-
    format("Hello, World!~n").
```

`main :- format(...)` é uma **regra**: "`main` é verdadeira se `format(...)`
tem sucesso". A diretiva da primeira linha pede ao SWI-Prolog que prove o
objetivo `main` quando o programa inicia; prová-lo imprime o texto como
efeito colateral. O [passo a passo](../languages/prolog/cli/README.md#step-by-step-walkthrough)
explica a diretiva, e o [README do Prolog](../languages/prolog/README.md)
explica fatos, regras e consultas.

Linguagem lógica neste repositório: [Prolog](../languages/prolog/README.md). Van Roy observa que
o Prolog é, ele próprio, dois paradigmas em um: "a logic programming engine based on
unification and depth-first search" mais uma parte imperativa, "the assert
and retract operations" [1] (tradução livre: "um mecanismo de programação
em lógica baseado em unificação e busca em profundidade"; "as operações
assert e retract").

## Concorrente: processos, mensagens e o modelo de atores
Concorrência significa que várias atividades estão em andamento ao mesmo
tempo. A forma usual de programá-la é o *estado compartilhado*: threads leem
e escrevem a mesma memória, protegida por locks. Erlang e Elixir seguem o
outro caminho. Um programa é feito de muitos **processos** pequenos, e eles
não alteram nada uns nos outros: apenas enviam **mensagens**.

O guia do Erlang diz: "Threads of execution in Erlang share no data, that is
why they are called processes" [12]. "Each process has its own input queue
for messages it receives" [12], e um processo envia uma mensagem com o
operador `!` (`Pid ! Message`) [12] (tradução livre: "Threads de execução em
Erlang não compartilham dados, e é por isso que são chamadas de processos";
"Cada processo tem sua própria fila de entrada para as mensagens que
recebe").

O manual de referência acrescenta que
"Erlang processes are lightweight (grow and shrink dynamically) with a small
memory footprint, fast to create and terminate, and the scheduling overhead
is low" [13] (tradução livre: "Os processos Erlang são leves (crescem e
encolhem dinamicamente), com pouco uso de memória, rápidos de criar e
encerrar, e a sobrecarga de escalonamento é baixa").

O envio é assíncrono: "Signals are received asynchronously and
automatically" [13] (tradução livre: "Os sinais são recebidos de forma
assíncrona e automática").

O guia do Elixir diz o mesmo para o Elixir: "Processes
are isolated from each other, run concurrent to one another and communicate
via message passing", e o remetente "does not block on `send/2`, it puts the
message in the recipient's mailbox and continues" [14] (tradução livre: "Os
processos são isolados uns dos outros, executam de forma concorrente e se
comunicam por troca de mensagens"; "não bloqueia em `send/2`, coloca a
mensagem na caixa de correio do destinatário e continua").

**Por que o isolamento.** Joe Armstrong, um dos criadores do Erlang, deriva
as regras de um único requisito em sua tese de doutorado. Imagina-se que os
processos executem em máquinas separadas, e "Isolation has several
consequences": os processos têm semântica de "share nothing", "Message
passing is the only way to pass data between processes" e "Isolation implies
that message passing is asynchronous" [11] (tradução livre: "O isolamento
tem várias consequências"; "nada compartilhado"; "A troca de mensagens é a
única forma de passar dados entre processos"; "O isolamento implica que a
troca de mensagens é assíncrona").

Se a comunicação fosse síncrona,
"a software error in the receiver of a message could indefinitely block the
sender" [11] (tradução livre: "um erro de software no receptor de uma
mensagem poderia bloquear o remetente indefinidamente").

Ele chamou o estilo de *Concurrency Oriented Programming*: "the
concurrent structure of the program should follow the concurrent structure
of the application" [11]. Ele observa também que esse estilo oferece "the two
major advantages commonly associated with object-oriented programming": o
polimorfismo e uma interface de troca de mensagens compartilhada por tipos
diferentes de processo [11] (tradução livre: "a estrutura concorrente do
programa deve seguir a estrutura concorrente da aplicação"; "as duas
principais vantagens comumente associadas à programação orientada a
objetos").

**O modelo de atores.** Em 1973, Carl Hewitt, Peter Bishop e Richard Steiger
propuseram um formalismo construído sobre um único tipo de coisa, o *ator*, e
escreveram que "all of the modes of behavior can be defined in terms of one
kind of behavior: sending messages to actors" [10] (tradução livre: "todos os
modos de comportamento podem ser definidos em termos de um único tipo de
comportamento: enviar mensagens a atores"). Os processos de Erlang e Elixir
têm a mesma forma: unidades separadas que mantêm seu próprio estado e se
alcançam apenas por mensagens [11][12][14].

Esta página faz essa comparação
por conta própria. As fontes acima não dizem que o Erlang derivou do artigo
sobre atores, e o relato de Armstrong sobre as origens do Erlang (consulte o
[README do Erlang](../languages/erlang/README.md#history)) parte do Prolog.

**A BEAM.** As duas linguagens executam na mesma máquina virtual. A tese de
Armstrong chama o sistema de runtime do Erlang de "a virtual
machine designed to run the intermediate code produced by the Erlang BEAM
compiler" e registra que o compilador BEAM "replaced the original JAM
compiler in 1998" [11] (tradução livre: "uma máquina virtual projetada para
executar o código intermediário produzido pelo compilador BEAM do Erlang";
"substituiu o compilador JAM original em 1998"). O
[README do Elixir](../languages/elixir/README.md#history) cita o próprio
anúncio do Elixir: "Elixir leverages the Erlang VM" (tradução livre: "O
Elixir tira proveito da VM do Erlang").

Os dois programas Hello World
mostram isso: [`erlang/cli`](../languages/erlang/cli/README.md#step-by-step-walkthrough)
chama `io:format`, [`elixir/cli`](../languages/elixir/cli/README.md#step-by-step-walkthrough)
chama `IO.puts`, e ambos terminam no mesmo runtime. Um Hello World não envia
mensagens entre processos; assim, esses programas mostram o runtime, não o
modelo.

Outras linguagens daqui com concorrência embutida são [Go](../languages/go/README.md)
e [Clojure](../languages/clojure/README.md); seus READMEs citam como cada
uma a realiza. Elas não são o modelo de atores, a menos que uma fonte o diga.

## De onde veio a orientação a objetos
A orientação a objetos não surgiu em um único passo. Quatro linguagens deste
repositório marcam o caminho.

1. **Simula (década de 1960).** Ole-Johan Dahl e Kristen Nygaard projetaram o
   Simula no Norwegian Computing Center para programas de simulação. A
   história de Krogdahl diz que eles "introduced the basic concepts of what
   later became object-orientation" [15]. O Simula 67 permitia declarar uma
   subclasse de uma classe onde a classe é visível, escrevendo o nome da
   classe como "prefixo": "C class D (...); begin ... end" [15]. O
   [README do Simula](../languages/simula/README.md#history) informa as datas
   e o relatório que define a linguagem (tradução livre: "introduziram os
   conceitos básicos do que depois se tornou a orientação a objetos").
2. **Smalltalk (década de 1970).** Alan Kay escreveu que "most of my ideas
   from then on took their roots from Simula—but not as an attempt to improve
   it" [2] e que o Simula "became the precursor of Smalltalk in 1972" [2]
   (tradução livre: "a maior parte das minhas ideias daí em diante teve suas
   raízes no Simula, mas não como uma tentativa de melhorá-lo"; "tornou-se o
   precursor do Smalltalk em 1972").

   O Smalltalk fez da mensagem o centro: seu projeto se apoia em "a single kind
   of behavioral building block that hides its combination of state and
   process inside itself and can be dealt with only through the exchange of
   messages" [2]. Em [`smalltalk/cli`](../languages/smalltalk/cli/hello.st),
   até imprimir é uma mensagem: `'Hello, World!' displayNl` envia `displayNl`
   a uma string (tradução livre: "um único tipo de bloco de construção
   comportamental que oculta em si a combinação de estado e processo e só
   pode ser manipulado por meio da troca de mensagens").
3. **Objective-C (década de 1980).** O guia da Apple o descreve como "a small
   but powerful set of extensions to the standard ANSI C language. Its
   additions to C are mostly based on Smalltalk, one of the first
   object-oriented programming languages" [16]. A sintaxe de mensagens de seu
   código-fonte, `[object message]`, mostra a dívida (veja
   [`objectivec/desktop`](../languages/objectivec/desktop/hello.m), em que
   `[label setStringValue:...]` é uma mensagem). O
   [README do Objective-C](../languages/objectivec/README.md#history-and-milestones)
   traz as datas (tradução livre: "um conjunto pequeno, mas poderoso, de
   extensões à linguagem ANSI C padrão. Suas adições ao C baseiam-se em sua
   maior parte no Smalltalk, uma das primeiras linguagens de programação
   orientadas a objetos").
4. **Swift (2014).** Seu projetista principal, Chris Lattner, escreve que o
   Swift se beneficiou de "the experiences hard-won by many other languages in
   the field, drawing ideas from Objective-C, Rust, Haskell, Ruby, Python, C#,
   CLU, and far too many others to list" [17]. O README do Swift traz o
   histórico de lançamentos (tradução livre: "as experiências duramente
   conquistadas por muitas outras linguagens da área, com ideias extraídas de
   Objective-C, Rust, Haskell, Ruby, Python, C#, CLU e muitas outras, demais
   para listar").

O resultado são dois sentidos de "orientado a objetos" que ainda coexistem.
Simula e Java organizam um programa em torno de **classes**; Smalltalk e
Objective-C o organizam em torno de **mensagens** para objetos.

O próprio Kay
enfatizou o segundo: "Objects communicate by sending and receiving messages
(in terms of objects)" [2] (tradução livre: "Os objetos se comunicam enviando
e recebendo mensagens (em termos de objetos)"). É por isso que a seção
[Orientado a objetos](#orientado-a-objetos) acima cita tanto Kay quanto a
especificação do Java. Este repositório não classifica as duas visões; o
README de cada linguagem informa quais palavras sua própria fonte usa.

## Design by Contract
O **Design by Contract** é um método de Bertrand Meyer, incorporado à
linguagem que ele projetou, o [Eiffel](../languages/eiffel/README.md). A
documentação do Eiffel explica a ideia com uma metáfora de negócios: "Design
by Contract states that their cooperation should be based on precise
specifications -- contracts -- describing each party's expectations and
guarantees" [18] (tradução livre: "O Design by Contract estabelece que a
cooperação deles deve se basear em especificações precisas, os contratos,
que descrevem as expectativas e as garantias de cada parte"). Um contrato tem
três partes [18]:

- uma **pré-condição**: "The client's obligation, which protects the
  supplier" ("what the client must satisfy before requesting a certain
  service") (tradução livre: "A obrigação do cliente, que protege o
  fornecedor"; "o que o cliente deve satisfazer antes de solicitar um
  determinado serviço");
- uma **pós-condição**: "The client's benefit, which describes what the
  supplier must do (assuming the precondition was satisfied)" (tradução livre:
  "O benefício do cliente, que descreve o que o fornecedor deve fazer
  (supondo que a pré-condição tenha sido satisfeita)");
- um **invariante de classe**, que "must be ensured by every creation
  procedure ... and maintained by every exported routine of the class"
  (tradução livre: "deve ser garantido por todo procedimento de criação ... e
  mantido por toda rotina exportada da classe").

O objetivo é a confiabilidade. O artigo de Meyer de 1992 diz que suas
diretrizes visam "to help improve the reliability of software systems", em
que confiabilidade é "the combination of correctness and robustness" [19]
(tradução livre: "ajudar a melhorar a confiabilidade dos sistemas de
software"; "a combinação de correção e robustez"). A documentação do Eiffel
diz de quem é a culpa quando um contrato é quebrado: "A precondition
violation signals a bug in the client" e "A postcondition (or invariant)
violation signals a bug in the supplier" [18] (tradução livre: "Uma violação
de pré-condição sinaliza um bug no cliente"; "Uma violação de pós-condição
(ou de invariante) sinaliza um bug no fornecedor").

Até o Hello World mostra isso no Eiffel
([`eiffel/cli/hello.e`](../languages/eiffel/cli/hello.e), sem os comentários):
```eiffel
class
    HELLO

create
    make

feature

    make
        do
            say (greeting)
        end

    greeting: STRING
        do
            Result := "Hello, World!"
        ensure
            not_empty: not Result.is_empty
        end

    say (a_text: STRING)
        require
            text_attached: a_text /= Void
        do
            io.put_string (a_text)
            io.put_new_line
        end

end
```
`require` declara o que o chamador de `say` deve fornecer, e `ensure` declara
o que `greeting` promete. Como dizem os comentários do código-fonte, ambos
são verificados durante a execução do programa quando a verificação de
asserções está ligada no compilador. A maioria das linguagens deste
repositório não tem essas palavras-chave; elas verificam as mesmas ideias com
testes, tipos ou exceções. O [README do Eiffel](../languages/eiffel/README.md)
e seu [passo a passo](../languages/eiffel/cli/README.md#step-by-step-walkthrough)
explicam cada linha.

## Quântico
A programação quântica é menos um paradigma do que um novo tipo de máquina.
Este repositório tem uma linguagem para ela, o [QCL](../languages/qcl/README.md)
(Quantum Computation Language), de Bernhard Ömer. A página dela chama o QCL de
"a high level, architecture independent programming language for quantum
computers, with a syntax derived from classical procedural languages like C or
Pascal" [21] (tradução livre: "uma linguagem de programação de alto nível,
independente de arquitetura, para computadores quânticos, com uma sintaxe
derivada de linguagens procedurais clássicas como C ou Pascal").

A tese de Ömer define os termos: "A QPL [quantum programming
language] is called imperative if it provides quantum registers (quantum
variables), elementary gates and single qubit measurements" [20] (tradução
livre: "Uma QPL [linguagem de programação quântica] é chamada de imperativa
se oferece registradores quânticos (variáveis quânticas), portas
elementares e medições de qubit único").

A física por trás disso, nas palavras do curso da IBM: "The term *qubit*
refers to a quantum system whose classical state set is {0,1}"; um estado que
é uma combinação linear dos dois é uma *superposição*; e, quando um estado é
medido, "each classical state of the system appears with probability equal to
the absolute value squared of the entry in the quantum state vector" [24]
(tradução livre: "O termo *qubit* refere-se a um sistema quântico cujo
conjunto de estados clássicos é {0,1}"; "cada estado clássico do sistema
aparece com probabilidade igual ao valor absoluto ao quadrado da entrada no
vetor de estado quântico").

**O Hello World não mostra nada disso.** [`qcl/cli/hello.qcl`](../languages/qcl/cli/hello.qcl)
usa apenas a parte clássica do QCL: um `procedure` e uma instrução `print`,
sem nenhum qubit. Imprimir texto é uma tarefa clássica; assim, o programa é
imperativo, como o C e o Pascal a que se assemelha. O README do QCL explica o
formato da saída e o que o interpretador simula.

Para as ferramentas de hoje, as fontes descrevem duas outras, nenhuma delas
construída neste repositório:
- **Qiskit**: "an open-source SDK for working with quantum computers at the
  level of extended (static, dynamic, and scheduled) quantum circuits,
  operators, and primitives" [22] (tradução livre: "um SDK de código aberto
  para trabalhar com computadores quânticos no nível de circuitos quânticos
  estendidos (estáticos, dinâmicos e agendados), operadores e primitivas").
- **Q#**: "a high-level, open-source programming language developed by
  Microsoft for writing quantum programs" [23] (tradução livre: "uma linguagem
  de programação de alto nível e código aberto, desenvolvida pela Microsoft
  para escrever programas quânticos").

Elas são citadas apenas como contexto. Esta página não apresenta
classificação nem número de uso para nenhuma das três.

## Todas as linguagens e seus paradigmas
O rótulo de cada linguagem vem do seu próprio README, que cita a
especificação da linguagem ou a documentação oficial a esse respeito
(primeiro parágrafo, **Paradigma**). "Principal" é o paradigma que este
repositório usa para agrupar a linguagem; "Também oferece suporte a" lista
outros estilos que a fonte citada menciona.

| Linguagem | Paradigma principal | Também oferece suporte a | Estilo de Hello World usado aqui |
|---|---|---|---|
| [Pseudocódigo](../languages/pseudocode/README.md) | imperativo (didático) | – | instruções em ordem |
| [C](../languages/c/README.md) | imperativo (procedural) | – | função `main`, instruções em ordem |
| [C++](../languages/cpp/README.md) | multiparadigma / orientado a objetos | procedural, genérico | `main` procedural, como no C |
| [Java](../languages/java/README.md) | orientado a objetos | recursos funcionais (lambdas, Java 8) | uma classe com um método `main` |
| [C#](../languages/csharp/README.md) | orientado a objetos | recursos funcionais | instrução de nível superior (nenhuma classe escrita) |
| [Go](../languages/go/README.md) | imperativo, concorrente | métodos sem classes | função `main` no pacote `main` |
| [Python](../languages/python/README.md) | multiparadigma | orientado a objetos, procedural, funcional | uma instrução |
| [Node.js (JavaScript)](../languages/node/README.md) | multiparadigma, orientado a eventos | objetos baseados em protótipos | uma instrução |
| [Rust](../languages/rust/README.md) | multiparadigma, de sistemas | influência funcional, traits | função `main` e uma macro |
| [PHP](../languages/php/README.md) | imperativo | orientado a objetos (PHP 3, PHP 5) | uma instrução |
| [Ruby](../languages/ruby/README.md) | orientado a objetos | imperativo, funcional | uma instrução |
| [Perl](../languages/perl/README.md) | multiparadigma | orientado a objetos, procedural, funcional | uma instrução, após `use strict;` e `use warnings;` |
| [Lua](../languages/lua/README.md) | multiparadigma | procedural, orientado a objetos, funcional, orientado a dados, descrição de dados | uma instrução |
| [Haskell](../languages/haskell/README.md) | **funcional** (puro, preguiçoso) | – | `main` é uma ação `IO` |
| [Common Lisp](../languages/lisp/README.md) | **funcional** (multiparadigma) | imperativo, orientado a objetos | uma função chamada pela imagem salva |
| [Prolog](../languages/prolog/README.md) | **lógico** | imperativo (`assert`/`retract`) [1] | uma regra provada na inicialização |
| [Pascal](../languages/pascal/README.md) | imperativo (estruturado) | orientado a objetos (Object Pascal) | corpo do programa entre `begin` e `end.` |
| [COBOL](../languages/cobol/README.md) | imperativo (procedural) | orientado a objetos (COBOL 2002) | uma `PROCEDURE DIVISION` |
| [Clipper (Harbour)](../languages/clipper/README.md) | imperativo (procedural) | – | `PROCEDURE Main()` |
| [BASIC](../languages/basic/README.md) | imperativo (procedural) | – | uma instrução |
| [Fortran](../languages/fortran/README.md) | imperativo (procedural) | orientado a objetos (Fortran 2003) | uma unidade `program` |
| [Ada](../languages/ada/README.md) | imperativo | orientado a objetos (Ada 95) | um procedimento principal |
| [Assembly (x86-64)](../languages/assembly/README.md) | imperativo, de baixo nível | – | instruções de CPU e uma chamada de sistema |
| [Bash](../languages/bash/README.md) | imperativo (shell) | – | um comando, `printf` |
| [ALGOL 68](../languages/algol68/README.md) | imperativo | execução paralela (elaboração colateral) | uma chamada `print`, sem `main` |
| [dBASE](../languages/dbase/README.md) | imperativo, com comandos de banco de dados | – | comandos em um arquivo `.prg` |
| [Zig](../languages/zig/README.md) | imperativo | – | função `main` e uma escrita explícita |
| [Delphi](../languages/delphi/README.md) | imperativo | orientado a objetos (Object Pascal) | corpo do programa, modo Delphi |
| [Visual Basic (VB.NET)](../languages/visual-basic/README.md) | orientado a objetos | imperativo | `Module` com `Sub Main` |
| [Simula](../languages/simula/README.md) | orientado a objetos | – | um bloco com `outtext` e `outimage` |
| [Smalltalk](../languages/smalltalk/README.md) | **orientado a objetos** (mensagens) | – | uma mensagem enviada a uma string |
| [Eiffel](../languages/eiffel/README.md) | **orientado a objetos** | Design by Contract | uma classe com `require` e `ensure` |
| [Objective-C](../languages/objectivec/README.md) | orientado a objetos | imperativo (superconjunto do C) | `main`, mais um envio de mensagem |
| [Swift](../languages/swift/README.md) | multiparadigma | orientado a objetos, funcional | uma instrução |
| [Kotlin](../languages/kotlin/README.md) | multiparadigma | orientado a objetos, funcional | `fun main()` de nível superior |
| [Scala](../languages/scala/README.md) | multiparadigma | funcional, orientado a objetos | um método `@main` |
| [Dart](../languages/dart/README.md) | orientado a objetos | – | função `main` |
| [TypeScript](../languages/typescript/README.md) | multiparadigma | orientado a objetos, tipos estáticos opcionais | uma constante tipada e uma chamada |
| [Julia](../languages/julia/README.md) | multiparadigma | imperativo, funcional, orientado a objetos | uma instrução |
| [Clojure](../languages/clojure/README.md) | **funcional** | suporte a concorrência | uma função em um espaço de nomes (namespace) |
| [OCaml](../languages/ocaml/README.md) | **funcional** | orientado a objetos, imperativo | `let () = ...` |
| [F#](../languages/fsharp/README.md) | **funcional** | orientado a objetos, imperativo (multiparadigma) | uma instrução de nível superior |
| [Racket](../languages/racket/README.md) | **funcional** | orientado a objetos (uma biblioteca de classes), orientado a linguagens | uma expressão em um módulo |
| [R](../languages/r/README.md) | **funcional** | orientado a objetos | uma expressão |
| [Erlang](../languages/erlang/README.md) | **funcional**, concorrente | – | um `escript` com `main/1` |
| [Elixir](../languages/elixir/README.md) | **funcional**, concorrente | – | uma chamada de função |
| [QCL](../languages/qcl/README.md) | imperativo | operações quânticas (não usadas pelo Hello World) | um procedimento e uma chamada |

**Verificação de cobertura:** cada paradigma tem ao menos uma linguagem com
uma implementação executável neste repositório:

| Paradigma | Linguagens | Implementações executáveis |
|---|---|---|
| Imperativo | C, Pascal, COBOL, Fortran, BASIC, Clipper, dBASE, ALGOL 68, Ada, Go, PHP, Bash, Zig, QCL, Assembly, pseudocódigo | por exemplo, [`c/cli`](../languages/c/cli/), [`pascal/cli`](../languages/pascal/cli/), [`cobol/cli`](../languages/cobol/cli/), [`assembly/cli`](../languages/assembly/cli/) |
| Orientado a objetos | Java, C#, C++, Ruby, Simula, Smalltalk, Eiffel, Objective-C, Swift, Kotlin, Scala, Dart, Visual Basic, Delphi | por exemplo, [`java/cli`](../languages/java/cli/), [`smalltalk/cli`](../languages/smalltalk/cli/), [`simula/cli`](../languages/simula/cli/), [`eiffel/cli`](../languages/eiffel/cli/), [`java/desktop`](../languages/java/desktop/), [`swift/desktop`](../languages/swift/desktop/) |
| Funcional | Haskell, Common Lisp, Clojure, OCaml, F#, Racket, R, Erlang, Elixir | [`haskell/cli`](../languages/haskell/cli/), [`haskell/web`](../languages/haskell/web/), [`lisp/cli`](../languages/lisp/cli/), [`ocaml/cli`](../languages/ocaml/cli/), [`erlang/cli`](../languages/erlang/cli/), [`elixir/web`](../languages/elixir/web/) |
| Lógico | Prolog | [`prolog/cli`](../languages/prolog/cli/), [`prolog/web`](../languages/prolog/web/) |
| Concorrente (processos e mensagens) | Erlang, Elixir | [`erlang/cli`](../languages/erlang/cli/), [`erlang/web`](../languages/erlang/web/), [`elixir/cli`](../languages/elixir/cli/), [`elixir/web`](../languages/elixir/web/) |
| Quântico | QCL | [`qcl/cli`](../languages/qcl/cli/) |

## O que um Hello World pode e não pode mostrar
Um Hello World faz uma única coisa: escreve um texto, o que é um efeito
colateral. Essa é a tarefa natural de um programa imperativo; por isso, na
maioria das linguagens o programa parece imperativo mesmo quando a
linguagem não é. Compare:

- **Python, JavaScript, PHP, BASIC, Ruby, Perl, Lua, Julia, Elixir, Swift, F#, R**: uma instrução
  (o Perl coloca `use strict;` e `use warnings;` antes dela). As linguagens
  multiparadigma não impõem paradigma algum a um programa tão pequeno. O Ruby
  é orientado a objetos, mas seu Hello World é uma única chamada a `puts`,
  sem classe.
- **Java**: uma classe é obrigatória; assim, a estrutura orientada a
  objetos é visível mesmo sem a criação de objetos.
- **Haskell**: o programa é um valor do tipo `IO ()`; assim, a regra
  funcional "sem efeitos colaterais" é visível no tipo.
- **Prolog**: o programa é uma regra, e executá-lo é provar um objetivo.
- **Smalltalk**: o programa envia uma mensagem, `displayNl`, a uma string.
- **Eiffel**: o programa é uma classe, e duas de suas rotinas carregam um
  contrato (`require` e `ensure`).
- **Erlang e Elixir**: um único processo imprime; nenhuma mensagem é enviada;
  assim, o estilo semelhante ao de atores não aparece.
- **QCL**: apenas a parte clássica da linguagem é usada; nenhum qubit é
  criado.

Para ver mais de cada paradigma do que a impressão permite, leia a seção
"Comparações entre as categorias" do README de cada linguagem (por exemplo,
[Haskell](../languages/haskell/README.md#comparing-the-categories) e
[Prolog](../languages/prolog/README.md#comparing-the-categories)) e o
arquivo [comparisons.md](comparisons.md), para comparações entre linguagens.

A questão de se a IA produzirá um novo paradigma é discutida à parte em
[ai-new-paradigm.md](ai-new-paradigm.md).

## Fontes
1. Programming Paradigms for Dummies: What Every Programmer Should Know. Peter Van Roy, in *New Computational Paradigms for Computer Music*, G. Assayag and A. Gerzso (eds.), IRCAM/Delatour France, 2009. Author's copy, UCLouvain. <https://webperso.info.ucl.ac.be/~pvr/VanRoyChapter.pdf> (acessado em 2026-11-02). Companion page: <https://webperso.info.ucl.ac.be/~pvr/paradigms.html> (acessado em 2026-11-02)
2. The Early History of Smalltalk. Alan C. Kay, Second History of Programming Languages conference (HOPL-II), ACM, 1993. <https://doi.org/10.1145/155360.155364>. The ACM page blocks automated reading; the quotes were checked in this full-text copy: <https://worrydream.com/EarlyHistoryOfSmalltalk/> (acessado em 2026-11-02)
3. Why Functional Programming Matters. John Hughes, in *Research Topics in Functional Programming*, D. Turner (ed.), Addison-Wesley, 1990, pp. 17–42 (earlier version in The Computer Journal 32(2), 1989). <https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf> (acessado em 2026-11-02)
4. Predicate Logic as Programming Language. Robert Kowalski, Information Processing 74 (IFIP Congress), North-Holland, 1974. <https://www.doc.ic.ac.uk/~rak/papers/IFIP%2074.pdf> (acessado em 2026-11-01)
5. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (acessado em 2026-11-02)
6. ISO/IEC 9899:TC3, committee draft WG14/N1256 (6.8 Statements and blocks). ISO/IEC JTC1/SC22/WG14, 2007-09-07. <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf> (acessado em 2026-10-31)
7. The Java Language Specification, Java SE 21 Edition, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (acessado em 2026-10-31)
8. Haskell 2010 Language Report, Chapter 1: Introduction. Simon Marlow (editor), haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch1.html> (acessado em 2026-11-01)
9. EWD 215: A Case against the GO TO Statement, published as the letter "Go-to statement considered harmful", Communications of the ACM 11(3), 1968, pp. 147–148. Edsger W. Dijkstra; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/ewd02xx/EWD215.PDF> (acessado em 2026-11-02)
10. A Universal Modular ACTOR Formalism for Artificial Intelligence. Carl Hewitt, Peter Bishop and Richard Steiger, Proceedings of the Third International Joint Conference on Artificial Intelligence (IJCAI), 1973. <https://www.ijcai.org/Proceedings/73/Papers/027B.pdf> (acessado em 2026-11-16)
11. Making reliable distributed systems in the presence of software errors. Joe Armstrong, doctoral dissertation, Royal Institute of Technology (KTH), Stockholm, final version, 2003-11-20 (sections 2.4 and the run-time system chapter). <https://erlang.org/download/armstrong_thesis_2003.pdf> (acessado em 2026-11-16)
12. Conc prog (Processes, Message Passing). Erlang/OTP documentation, Getting Started. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/conc_prog.html> (acessado em 2026-11-16)
13. Processes (reference manual). Erlang/OTP documentation. Ericsson AB, erlang.org. <https://www.erlang.org/doc/system/ref_man_processes.html> (acessado em 2026-11-16)
14. Processes. Elixir Getting started guide, Elixir team, hexdocs.pm. <https://elixir.hexdocs.pm/processes.html> (acessado em 2026-11-16)
15. The Birth of Simula. Stein Krogdahl, Department of Informatics, University of Oslo. <https://www.mn.uio.no/english/services/it/simula/bibliography/history/sk-the-birth-of-simula.pdf> (acessado em 2026-11-16)
16. The Objective-C Programming Language (Introduction; retired document, updated 2013-04-23). Apple Inc. <https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjectiveC/Introduction/introObjectiveC.html> (acessado em 2026-11-16)
17. Chris Lattner's homepage (section on Swift). Chris Lattner. <https://nondot.org/sabre/> (acessado em 2026-11-16)
18. Design by Contract, Assertions and Exceptions (Eiffel Tutorial). Eiffel Software, eiffel.org. <https://www.eiffel.org/doc/eiffel/ET-_Design_by_Contract_%28tm%29%2C_Assertions_and_Exceptions> (acessado em 2026-11-16)
19. Applying "Design by Contract". Bertrand Meyer, *Computer* (IEEE), October 1992. Author's copy, ETH Zurich. <https://se.inf.ethz.ch/~meyer/publications/computer/contract.pdf> (acessado em 2026-11-16)
20. Structured Quantum Programming. Bernhard Ömer, doctoral thesis, Vienna University of Technology, first version 2003-05-26 (abstract and chapter 2). <https://tph.itp.tuwien.ac.at/~oemer/doc/structquprog.pdf> (acessado em 2026-11-16)
21. QCL - A Programming Language for Quantum Computers. Bernhard Oemer, TU Wien. <https://tph.itp.tuwien.ac.at/~oemer/qcl.html> (acessado em 2026-11-16)
22. Introduction to Qiskit (The Qiskit SDK). IBM Quantum documentation. <https://quantum.cloud.ibm.com/docs/en/guides/tools-intro> (acessado em 2026-11-16)
23. Q# overview. Microsoft Learn (page updated 2026-08-29). <https://learn.microsoft.com/azure/quantum/qsharp-overview> (acessado em 2026-11-16)
24. Quantum information (Basics of quantum information, Single systems). IBM Quantum Learning. <https://quantum.cloud.ibm.com/learning/en/courses/basics-of-quantum-information/single-systems/quantum-information> (acessado em 2026-11-16)
