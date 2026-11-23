---
source: docs/off-the-record.md
source_sha: 71ef59647d24b65059332b065a672a48bede748c
---
# Nos bastidores

O restante deste site é formal. Esta página não é. Ela reúne uma observação
leve sobre cada linguagem deste repositório, piadas sobre programação
encontradas em outras fontes, um dicionário improvável e algumas citações conhecidas
de pessoas que projetaram ou estudaram linguagens de programação.

As piadas podem tratar de linguagens, paradigmas, ferramentas, inteligência
artificial e do cotidiano de quem programa, e uma piada à custa do próprio
programador é bem-vinda. Nenhuma é depreciativa para qualquer grupo de
pessoas ou para qualquer pessoa real.

## Uma linha por linguagem
<!-- BEGIN SITE: humor-lines -->
Cada linguagem mantém sua linha em seu próprio `meta.yml` (`humor.line`, veja o
[esquema](../languages/README.md#humor-keys)). O site as lista aqui,
ordenadas por nome.
<!-- END SITE: humor-lines -->

## Piadas sobre programação
Cada piada abaixo é citada literalmente da página indicada logo após ela,
com seu autor quando a página o informa e "Origin unknown" (origem
desconhecida) em caso contrário. As tirinhas do xkcd apenas recebem um link: elas são licenciadas sob CC BY-NC
2.5, e este site não as copia. O texto do Stack Overflow é licenciado sob
CC BY-SA, e as entradas dele indicam o autor e apontam para a página
que as reúne. Cada citação é seguida de uma tradução livre.

### Linguagens falando umas das outras

<!-- vale off -->

> C makes it easy to shoot yourself in the foot; C++ makes it harder, but
> when you do it blows your whole leg off
>
> (Tradução livre: "C facilita dar um tiro no próprio pé; C++ dificulta, mas
> quando você consegue, leva a perna inteira.")

Bjarne Stroustrup, que escreve "Yes, I said something like that (in 1986
or so)" na página [Quotes](https://www.stroustrup.com/quotes.html) dele
(acessado em 2026-11-03).

> Any sufficiently complicated C or Fortran program contains an ad-hoc,
> informally-specified bug-ridden slow implementation of half of Common
> Lisp.
>
> (Tradução livre: "Todo programa C ou Fortran suficientemente complicado contém uma
> implementação ad hoc, informalmente especificada, repleta de bugs e lenta de
> metade do Common Lisp.")

Philip Greenspun, "Greenspun's Tenth Rule of Programming", na página
[Research](https://philip.greenspun.com/research/) dele (acessado em
2026-11-03).

> 1970 - Niklaus Wirth creates Pascal, a procedural language. Critics
> immediately denounce Pascal because it uses "x := x + y" syntax instead
> of the more familiar C-like "x = x + y". This criticism happens in spite
> of the fact that C has not yet been invented.
>
> (Tradução livre: "1970 - Niklaus Wirth cria o Pascal, uma linguagem procedural.
> Os críticos denunciam imediatamente o Pascal porque ele usa a sintaxe "x := x + y"
> em vez da mais familiar "x = x + y", ao estilo de C. Essa crítica ocorre apesar
> de C ainda não ter sido inventada.")

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009) (acessado em 2026-11-03).

> 1996 - James Gosling invents Java. Java is a relatively verbose, garbage
> collected, class based, statically typed, single dispatch, object
> oriented language with single implementation inheritance and multiple
> interface inheritance. Sun loudly heralds Java's novelty.
>
> (Tradução livre: "1996 - James Gosling inventa o Java. Java é uma linguagem
> relativamente verbosa, com coleta de lixo, baseada em classes, estaticamente tipada, de despacho único, orientada
> a objetos, com herança simples de implementação e herança múltipla de
> interface. A Sun anuncia alto e bom som a novidade do Java.")

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009) (acessado em 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 224, "Lisp"](https://xkcd.com/224/): uma tirinha sobre
um sonho de iluminação que acomete o leitor de um livro de Lisp
(acessado em 2026-11-03).

### Paradigmas

<!-- vale off -->

> 1980 - Alan Kay creates Smalltalk and invents the term "object
> oriented." When asked what that means he replies, "Smalltalk programs
> are just objects." When asked what objects are made of he replies,
> "objects." When asked again he says "look, it's all objects all the way
> down. Until you reach turtles."
>
> (Tradução livre: "1980 - Alan Kay cria o Smalltalk e inventa o termo "orientado
> a objetos". Quando lhe perguntam o que isso significa, ele responde: "Programas
> Smalltalk são apenas objetos." Quando lhe perguntam de que são feitos os objetos, responde:
> "de objetos." Quando lhe perguntam de novo, diz: "olhe, são objetos até
> o fim. Até chegar às tartarugas."")

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), sobre a programação orientada a objetos (acessado em 2026-11-03).

> Any sufficiently complicated concurrent program in another language
> contains an ad hoc informally-specified bug-ridden slow implementation
> of half of Erlang.
>
> (Tradução livre: "Todo programa concorrente suficientemente complicado em outra linguagem
> contém uma implementação ad hoc, informalmente especificada, repleta de bugs e lenta
> de metade do Erlang.")

Robert Virding, [Virding's First Rule of
Programming](https://rvirding.blogspot.com/2008/01/virdings-first-rule-of-programming.html)
(2008), escrita após textos de blog sobre a concorrência por troca de mensagens
do Erlang, o modelo de atores em funcionamento. Ele acrescenta "With all respect to
Greenspun." (acessado em 2026-11-03).

> Haskell gets some resistance due to the complexity of using monads to
> control side effects. Wadler tries to appease critics by explaining that
> "a monad is a monoid in the category of endofunctors, what's the
> problem?"
>
> (Tradução livre: "O Haskell encontra alguma resistência devido à complexidade de usar mônadas para
> controlar efeitos colaterais. Wadler tenta apaziguar os críticos explicando que
> "uma mônada é um monoide na categoria dos endofuntores, qual é o
> problema?"")

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), parte da entrada de 1990, sobre a programação funcional (acessado em
2026-11-03).

> 1972 - Alain Colmerauer designs the logic language Prolog. His goal is
> to create a language with the intelligence of a two year old. He proves
> he has reached his goal by showing a Prolog session that says "No." to
> every query.
>
> (Tradução livre: "1972 - Alain Colmerauer projeta a linguagem lógica Prolog. Seu objetivo é
> criar uma linguagem com a inteligência de uma criança de dois anos. Ele prova
> ter atingido o objetivo ao mostrar uma sessão de Prolog que responde "No." a
> toda consulta.")

James Iry, [A Brief, Incomplete, and Mostly Wrong History of Programming
Languages](https://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)
(2009), sobre a programação lógica (acessado em 2026-11-03).

> One day a student came to Moon and said: “I understand how to make a
> better garbage collector. We must keep a reference count of the
> pointers to each cons.”
>
> Moon patiently told the student the following story:
>
> “One day a student came to Moon and said: ‘I understand how to make a
> better garbage collector...
>
> (Tradução livre: "Um dia, um estudante procurou Moon e disse: "Entendo como fazer um
> coletor de lixo melhor. Devemos manter uma contagem de referências dos
> ponteiros para cada cons."
>
> Moon contou com paciência ao estudante a seguinte história:
>
> "Um dia, um estudante procurou Moon e disse: "Entendo como fazer um
> coletor de lixo melhor...")

"Moon instructs a student", um dos koans de IA, um gênero de piadas contado
no Laboratório de IA do MIT, encontrado em [The Jargon File, "Some AI
Koans"](http://www.catb.org/jargon/html/koans.html) (acessado em
2026-11-03). A história nunca termina, pois uma estrutura que aponta para si mesma
nunca chega a uma contagem de referências igual a zero.

<!-- vale on -->

Randall Munroe, [xkcd 1312, "Haskell"](https://xkcd.com/1312/): uma tirinha
sobre a garantia de que o código escrito em Haskell não tem efeitos colaterais
(acessado em 2026-11-03).

### IA e programação

<!-- vale off -->

> In the days when Sussman was a novice, Minsky once came to him as he sat
> hacking at the PDP-6.
>
> “What are you doing?”, asked Minsky.
>
> “I am training a randomly wired neural net to play Tic-Tac-Toe” Sussman
> replied.
>
> “Why is the net wired randomly?”, asked Minsky.
>
> “I do not want it to have any preconceptions of how to play”, Sussman
> said.
>
> Minsky then shut his eyes.
>
> “Why do you close your eyes?”, Sussman asked his teacher.
>
> “So that the room will be empty.”
>
> At that moment, Sussman was enlightened.
>
> (Tradução livre: "Nos tempos em que Sussman era novato, Minsky o procurou certa vez enquanto ele
> mexia no PDP-6.
>
> "O que você está fazendo?", perguntou Minsky.
>
> "Estou treinando uma rede neural com ligações aleatórias para jogar jogo da velha", respondeu
> Sussman.
>
> "Por que a rede tem ligações aleatórias?", perguntou Minsky.
>
> "Não quero que ela tenha preconceitos sobre como jogar", disse
> Sussman.
>
> Minsky então fechou os olhos.
>
> "Por que você fecha os olhos?", perguntou Sussman ao seu professor.
>
> "Para que a sala fique vazia."
>
> Naquele momento, Sussman alcançou a iluminação.)

"Sussman attains enlightenment", um dos koans de IA, encontrado em [The Jargon File, "Some AI
Koans"](http://www.catb.org/jargon/html/koans.html) (acessado em
2026-11-03).

> A novice was trying to fix a broken Lisp machine by turning the power
> off and on.
>
> Knight, seeing what the student was doing, spoke sternly: “You cannot
> fix a machine by just power-cycling it with no understanding of what is
> going wrong.”
>
> Knight turned the machine off and on.
>
> The machine worked.
>
> (Tradução livre: "Um novato tentava consertar uma máquina Lisp quebrada desligando e
> ligando a energia.
>
> Knight, vendo o que o estudante fazia, falou com severidade: "Você não pode
> consertar uma máquina apenas reiniciando-a sem entender o que está
> dando errado."
>
> Knight desligou e ligou a máquina.
>
> A máquina funcionou.)

"Tom Knight and the Lisp Machine", dos mesmos [koans de
IA](http://www.catb.org/jargon/html/koans.html) (acessado em 2026-11-03).

> Intelligence is whatever machines haven't done yet
>
> (Tradução livre: "Inteligência é tudo aquilo que as máquinas ainda não fizeram.")

Larry Tesler, que apresenta esta frase como "What I actually said" (o que eu
realmente disse) para a linha
normalmente citada como "Artificial Intelligence is whatever hasn't been done
yet", em [Adages and
Coinages](https://www.nomodes.com/larry-tesler-consulting/adages-and-coinages)
(acessado em 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 1838, "Machine Learning"](https://xkcd.com/1838/):
uma tirinha sobre um sistema de aprendizado que é uma pilha de álgebra linear, mexida
até que as respostas pareçam certas (acessado em 2026-11-03).

Randall Munroe, [xkcd 1425, "Tasks"](https://xkcd.com/1425/): uma tirinha
sobre como distinguir uma tarefa que exige algumas horas de programação de outra que
exige uma equipe de pesquisa por cinco anos (acessado em 2026-11-03).

### Programação no dia a dia

<!-- vale off -->

> There are only two hard things in Computer Science: cache invalidation
> and naming things.
>
> (Tradução livre: "Há apenas duas coisas difíceis na Ciência da Computação: invalidação de cache
> e dar nomes às coisas.")

Phil Karlton, conforme citado por Martin Fowler em
[TwoHardThings](https://martinfowler.com/bliki/TwoHardThings.html)
(acessado em 2026-11-03).

> There are 2 hard problems in computer science: cache invalidation,
> naming things, and off-by-1 errors.
>
> (Tradução livre: "Há 2 problemas difíceis na ciência da computação: invalidação de cache,
> dar nomes às coisas e erros de off-by-1.")

Leon Bambrick, conforme citado na mesma
[página](https://martinfowler.com/bliki/TwoHardThings.html) (acessado em
2026-11-03).

> There are only two hard problems in distributed systems: 2. Exactly-once
> delivery 1. Guaranteed order of messages 2. Exactly-once delivery
>
> (Tradução livre: "Há apenas dois problemas difíceis em sistemas distribuídos: 2. Entrega
> exatamente uma vez 1. Ordem garantida das mensagens 2. Entrega exatamente uma vez")

Mathias Verraes, conforme citado na mesma
[página](https://martinfowler.com/bliki/TwoHardThings.html) (acessado em
2026-11-03).

> Some people, when confronted with a problem, think “I know, I'll use
> regular expressions.” Now they have two problems.
>
> (Tradução livre: "Algumas pessoas, diante de um problema, pensam: "Já sei, vou usar
> expressões regulares." Agora elas têm dois problemas.")

Jamie Zawinski, em uma mensagem na Usenet de 12 de agosto de 1997, conforme rastreada por Jeffrey
Friedl em [Source of the famous "Now you have two problems"
quote](https://regex.info/blog/2006-09-15/247) (acessado em 2026-11-03).

> The first 90 percent of the code accounts for the first 90 percent of
> the development time. The remaining 10 percent of the code accounts for
> the other 90 percent of the development time.
>
> (Tradução livre: "Os primeiros 90 por cento do código respondem pelos primeiros 90 por cento do
> tempo de desenvolvimento. Os 10 por cento restantes do código respondem pelos
> outros 90 por cento do tempo de desenvolvimento.")

Tom Cargill, da Bell Labs, popularizada pela coluna "Programming
Pearls" de Jon Bentley (1985), conforme citado em [Wikipedia, "Ninety–ninety
rule"](https://en.wikipedia.org/wiki/Ninety%E2%80%93ninety_rule)
(acessado em 2026-11-03).

> Everyone knows that debugging is twice as hard as writing a program in
> the first place. So if you're as clever as you can be when you write
> it, how will you ever debug it?
>
> (Tradução livre: "Todos sabem que depurar é duas vezes mais difícil do que escrever um programa
> logo de início. Então, se você é tão engenhoso quanto pode ser ao escrevê-lo,
> como conseguirá depurá-lo?")

Brian W. Kernighan e P. J. Plauger, *The Elements of Programming
Style*, 2.ª edição, capítulo 2, conforme citado em [Wikiquote, "Brian
Kernighan"](https://en.wikiquote.org/wiki/Brian_Kernighan) (acessado em
2026-11-03).

> heisenbug: /hi:´zen·buhg/, n.
>
> [from Heisenberg's Uncertainty Principle in quantum physics] A bug that
> disappears or alters its behavior when one attempts to probe or isolate
> it.
>
> (Tradução livre: "heisenbug: /hi:´zen·buhg/, s.
>
> [do Princípio da Incerteza de Heisenberg, da física quântica] Um bug que
> desaparece ou altera seu comportamento quando se tenta investigá-lo ou isolá-lo.")

Origin unknown (origem desconhecida), encontrado em [The Jargon File,
"heisenbug"](http://www.catb.org/jargon/html/H/heisenbug.html) (acessado em
2026-11-03).

> Using if(constant == variable) instead of if(variable == constant), like
> if(4 == foo). Because it’s like saying “if blue is the sky” or “if tall
> is the man.”
>
> (Tradução livre: "Usar if(constante == variável) em vez de if(variável == constante), como
> if(4 == foo). Porque é como dizer "se azul é o céu" ou "se alto
> é o homem."")

"Yoda Conditions", do usuário do Stack Overflow zneak, reunida por Jeff
Atwood em [New Programming
Jargon](https://blog.codinghorror.com/new-programming-jargon/) (2012);
texto do Stack Overflow, CC BY-SA (acessado em 2026-11-03).

> For when you just Gotta Catch ’Em All.
>
> (Tradução livre: "Para quando você simplesmente Tem Que Pegar Todos.")

"Pokémon Exception Handling", do usuário do Stack Overflow woot4moo, da
mesma [coletânea](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (acessado em 2026-11-03).

> The process of taking a well-designed piece of code and, through a
> series of small, reversible changes, making it completely unmaintainable
> by anyone except yourself.
>
> (Tradução livre: "O processo de pegar um trecho de código bem projetado e, por meio de uma
> série de pequenas alterações reversíveis, torná-lo completamente impossível de manter
> por qualquer pessoa que não seja você mesmo.")

"Refuctoring", de Jason Gorman, da mesma
[coletânea](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (acessado em 2026-11-03).

> A riff on strongly typed. Used to describe an implementation that
> needlessly relies on strings when programmer & refactor friendly options
> are available.
>
> (Tradução livre: "Uma variação de fortemente tipado. Usada para descrever uma implementação que
> depende desnecessariamente de strings quando há opções amigáveis ao programador e à refatoração.")

"Stringly Typed", de Mark Simpson, da mesma
[coletânea](https://blog.codinghorror.com/new-programming-jargon/);
CC BY-SA (acessado em 2026-11-03).

<!-- vale on -->

Randall Munroe, [xkcd 1597, "Git"](https://xkcd.com/1597/): uma tirinha sobre
a maneira habitual de consertar um repositório Git quebrado, que é salvar o trabalho
em outro lugar, apagar o projeto e baixar uma cópia nova (acessado em
2026-11-03).

Randall Munroe, [xkcd 2347, "Dependency"](https://xkcd.com/2347/): uma
tirinha sobre a infraestrutura digital moderna, apoiada em um pequeno projeto
mantido por uma única pessoa durante anos (acessado em 2026-11-03).

<!-- BEGIN SITE: humor-jokes -->
<!-- END SITE: humor-jokes -->

## O Dicionário Improvável da Programação
Um dicionário de brincadeira é uma piada antiga. Ambrose Bierce reuniu suas
definições satíricas em *The Cynic's Word Book* em 1906 e, em uma
versão mais completa, em *The Devil's Dictionary* em 1911 [10]. Stan Kelly-Bootle
levou o formato à computação com *The Devil's DP Dictionary* (McGraw-Hill,
1981) [11], [12]. O Jargon File, iniciado por Raphael Finkel em Stanford em
1975, registra o jargão real dos programadores, muitas vezes com uma piada embutida
[13]. Essas obras são a inspiração para as entradas abaixo, que são
escritas para este site e não copiam nada delas. Uma entrada para o nome de
uma linguagem vem da própria pasta dessa linguagem.

<!-- BEGIN SITE: humor-dictionary -->
<!-- The entries for language names are in each languages/<language>/meta.yml
(humor.dictionary); the website merges them with these, from A to Z. -->
- **Ator** (s.): no modelo de atores, um pequeno processo que lê suas
  mensagens e envia outras, o que também é uma boa descrição de um dia
  de trabalho.
- **Programador par de IA** (s.): um colega que nunca se cansa, nunca dorme
  e nunca se lembra da conversa de ontem.
- **API** (s.): uma promessa entre dois programas, cumprida até a próxima
  versão principal.
- **Bug** (s.): uma funcionalidade que ninguém pediu, entregue no prazo.
- **Cache** (s.): um lugar para guardar a resposta a uma pergunta, de modo que
  ela possa estar errada mais depressa da próxima vez.
- **Comentário** (s.): um recado de um programador do passado para um do
  futuro, descrevendo um código que mudou desde então.
- **Mensagem de commit** (s.): um breve bilhete para o futuro, geralmente "ajustes".
- **Compilador** (s.): um programa que lê seu código com mais atenção do que
  qualquer outra pessoa jamais lerá.
- **Contêiner** (s.): uma forma de enviar a máquina do programador junto com
  o programa, para que funcione em toda máquina que seja a máquina do
  programador.
- **Prazo** (s.): a data em que uma estimativa se torna história.
- **Depurador** (s.): uma ferramenta para observar, passo a passo, um programa fazer
  exatamente o que lhe foi mandado.
- **Dependência** (s.): o código de outra pessoa de que o seu código precisa, e
  que precisa do código de outra pessoa, e assim por diante até o fim.
- **Documentação** (s.): a segunda descrição mais atualizada de um
  programa, depois do próprio programa.
- **Estimativa** (s.): um número de dias, multiplicado por uma constante que
  ninguém conhece ainda.
- **Framework** (s.): código que chama o seu código, no horário que lhe convém.
- **Programação funcional** (s.): programar sem efeitos colaterais, exceto
  imprimir "Hello, World!", o que exige uma mônada.
- **Git** (s.): um sistema de controle de versão em que todo erro do passado é
  guardado, assinado e copiado para todos os colegas.
- **Alucinação** (s.): uma resposta de um modelo de IA que é fluente,
  confiante e referenciada, citando um artigo que não existe.
- **Hello World** (s.): o primeiro programa em uma nova linguagem e o último
  que funciona de primeira.
- **Modelo de linguagem de grande escala** (s.): um programa que leu a maior parte da
  internet e, como a internet, responde a toda pergunta com
  convicção.
- **Código legado** (s.): código que funciona.
- **Programação lógica** (s.): um paradigma em que o programa declara os
  fatos e o computador assume a responsabilidade pelas consequências.
- **Aprendizado de máquina** (s.): um programa que aprende com exemplos,
  inclusive com os que ninguém queria lhe dar.
- **Programação orientada a objetos** (s.): uma forma de organizar o código em que
  todo problema é um substantivo, e todo substantivo tem uma classe gerente.
- **Erro de off-by-one** (s.): um erro que nunca está longe da resposta
  certa.
- **Prompt** (s.): um programa escrito em português, para um computador que pode
  executá-lo ou executar algo parecido.
- **Pull request** (s.): uma forma educada de pedir aos colegas que encontrem seus
  erros em público.
- **Condição de corrida** (s.): um bug que só aparece quando ninguém está olhando.
- **Expressão regular** (s.): uma sequência curta que casa com o que se
  queria e também com o que não se queria.
- **Ponto e vírgula** (s.): um sinal de pontuação que algumas linguagens exigem, outras
  proíbem e o JavaScript insere por conta própria quando acha que falta um.
- **Stack Overflow** (s.): 1. o que acontece quando uma recursão nunca termina.
  2. onde os programadores vão para descobrir por quê.
- **Dívida técnica** (s.): tempo emprestado do futuro, a uma taxa de
  juros que ninguém registrou.
- **Comportamento indefinido** (s.): o que um programa em C faz quando o padrão
  deixa de vigiá-lo.
- **Vibe coding** (s.): programar descrevendo o programa a um modelo de
  IA e depois torcendo.
- **Espaço em branco** (s.): caracteres invisíveis que causam discussões
  visíveis.
- **Funciona na minha máquina** (expr.): a primeira metade de um relatório de bug.
- **YAML** (s.): um formato de dados em que a indentação tem significado e, na
  versão 1.1, a palavra `no` também.
- **Base zero** (adj.): como a maioria das linguagens deste repositório conta.
  Fortran e COBOL começam em um, e nenhuma das duas aceita discutir o assunto.
<!-- END SITE: humor-dictionary -->

## Citações
Cada citação é copiada literalmente da fonte listada abaixo dela e vem
seguida de uma tradução livre.

<!-- vale off -->

> A language that doesn't affect the way you think about programming, is
> not worth knowing.
>
> (Tradução livre: "Uma linguagem que não afeta a maneira como você pensa sobre programação
> não vale a pena ser conhecida.")

Alan J. Perlis, *Epigrams on Programming*, epigrama 19 (1982) [1].

> Syntactic sugar causes cancer of the semicolon.
>
> (Tradução livre: "O açúcar sintático causa câncer do ponto e vírgula.")

Alan J. Perlis, *Epigrams on Programming*, epigrama 3 (1982) [1].

> In the good old days physicists repeated each other's experiments, just to
> be sure. Today they stick to FORTRAN, so that they can share each other's
> programs, bugs included.
>
> (Tradução livre: "Nos bons velhos tempos, os físicos repetiam os experimentos uns dos outros, só para
> ter certeza. Hoje eles se limitam ao FORTRAN, para poderem compartilhar os programas
> uns dos outros, bugs incluídos.")

Edsger W. Dijkstra, *How do we tell truths that might hurt?*, EWD498
(1975) [2].

> Here is a language so far ahead of its time, that it was not only an
> improvement on its predecessors, but also on nearly all its successors.
>
> (Tradução livre: "Eis uma linguagem tão à frente de seu tempo que foi não apenas um
> aprimoramento de suas antecessoras, mas também de quase todas as suas sucessoras.")

C. A. R. Hoare sobre o ALGOL 60, *Hints on Programming Language Design* (1973),
apêndice, p. 27 [3].

> We should forget about small efficiencies, say about 97% of the time:
> premature optimization is the root of all evil.
>
> (Tradução livre: "Devemos esquecer as pequenas eficiências, digamos, em cerca de 97% do tempo:
> a otimização prematura é a raiz de todo o mal.")

Donald E. Knuth, *Structured Programming with go to Statements* (1974),
p. 268 [4].

> In this case it prints hello, world
>
> (Tradução livre: "Neste caso, ele imprime hello, world")

Brian W. Kernighan, *Programming in C: A Tutorial* (Bell Laboratories,
c. 1974), seção 2, sobre um dos primeiros programas Hello World impressos
[5].

> There are only two kinds of languages: the ones people complain about and
> the ones nobody uses
>
> (Tradução livre: "Há apenas dois tipos de linguagens: aquelas de que as pessoas reclamam e
> aquelas que ninguém usa.")

Uma frase que Bjarne Stroustrup confirma ser sua na própria página de
citações, onde acrescenta que duvida de que a ideia seja original [6].

> Readability counts.
>
> (Tradução livre: "A legibilidade conta.")

Tim Peters, *The Zen of Python*, PEP 20 (2004) [7].

> Do I have to like “Monty Python’s Flying Circus”? No, but it helps. :)
>
> (Tradução livre: "Preciso gostar de "Monty Python's Flying Circus"? Não, mas ajuda. :)")

A FAQ geral oficial do Python, pergunta e resposta [8].

> In retrospect, therefore, perhaps the biggest single benefit of laziness
> is not laziness per se, but rather that laziness kept us pure
>
> (Tradução livre: "Em retrospecto, portanto, talvez o maior benefício isolado da preguiça
> não seja a preguiça em si, mas o fato de que ela nos manteve puros.")

Paul Hudak, John Hughes, Simon Peyton Jones e Philip Wadler, *A History
of Haskell: Being Lazy With Class* (2007), seção 3.2 [9].

<!-- vale on -->

## Fontes
1. Epigrams in Programming. Alan J. Perlis, ACM SIGPLAN Notices 17(9), September 1982; texto publicado pelo Departamento de Ciência da Computação da Yale University. <https://www.cs.yale.edu/homes/perlis-alan/quotes.html> (acessado em 2026-11-03)
2. How do we tell truths that might hurt? (EWD498). Edsger W. Dijkstra, 1975; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/transcriptions/EWD04xx/EWD498.html> (acessado em 2026-11-03)
3. Hints on Programming Language Design. C. A. R. Hoare, Stanford Artificial Intelligence Memo AIM-224 / STAN-CS-73-403, December 1973; digitalização hospedada pela University of Michigan. <https://web.eecs.umich.edu/~bchandra/courses/papers/Hoare_Hints.pdf> (acessado em 2026-11-03)
4. Structured Programming with go to Statements. Donald E. Knuth, Computing Surveys 6(4), December 1974; cópia arquivada. <https://web.archive.org/web/2013/http://cs.sjsu.edu/~mak/CS185C/KnuthStructuredProgrammingGoTo.pdf> (acessado em 2026-11-03)
5. Programming in C: A Tutorial. Brian W. Kernighan, Bell Laboratories; cópia arquivada de bell-labs.com. <https://web.archive.org/web/20151226023321/https://www.bell-labs.com/usr/dmr/www/ctut.pdf> (acessado em 2026-11-03)
6. Quotes. Bjarne Stroustrup. <https://www.stroustrup.com/quotes.html> (acessado em 2026-11-03)
7. PEP 20: The Zen of Python. Tim Peters, Python Software Foundation, 2004. <https://peps.python.org/pep-0020/> (acessado em 2026-11-03)
8. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (acessado em 2026-11-03)
9. A History of Haskell: Being Lazy With Class. Paul Hudak, John Hughes, Simon Peyton Jones, Philip Wadler, Third ACM SIGPLAN History of Programming Languages Conference (HOPL III), 2007; cópia do autor hospedada pela Microsoft Research. <https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/history.pdf> (acessado em 2026-11-03)
10. The Devil's Dictionary. Wikipedia. <https://en.wikipedia.org/wiki/The_Devil%27s_Dictionary> (acessado em 2026-11-03)
11. The Devil's DP Dictionary. Stan Kelly-Bootle, McGraw-Hill, 1981; registro da Open Library. <https://openlibrary.org/works/OL3522422W> (acessado em 2026-11-03)
12. Stan Kelly-Bootle. Wikipedia. <https://en.wikipedia.org/wiki/Stan_Kelly-Bootle> (acessado em 2026-11-03)
13. Revision History. The Jargon File, version 4.4.7, Eric S. Raymond. <http://www.catb.org/jargon/html/revision-history.html> (acessado em 2026-11-03)
