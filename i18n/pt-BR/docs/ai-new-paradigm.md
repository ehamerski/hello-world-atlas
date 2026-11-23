---
source: docs/ai-new-paradigm.md
source_sha: 07f4ed2d1e9f9097c051cd91881822fac3c2c188
---
# A IA dará origem a um novo paradigma de programação?

A IA dará origem a um novo paradigma de programação? Em caso afirmativo,
qual seria esse paradigma e como ele funcionaria? Este ensaio defende que
sim e justifica a resposta. Ele se apoia em [`docs/paradigms.md`](paradigms.md), que explica
os quatro paradigmas já cobertos por este repositório.

- [A resposta em resumo](#a-resposta-em-resumo)
- [O que caracterizaria um novo paradigma](#o-que-caracterizaria-um-novo-paradigma)
- [O paradigma proposto: programação orientada a intenção](#o-paradigma-proposto-programação-orientada-a-intenção)
- [Como funcionaria](#como-funcionaria)
- [De onde vem](#de-onde-vem)
- [Evidências até o momento](#evidências-até-o-momento)
- [Contra-argumentos](#contra-argumentos)
- [O que este repositório mostra](#o-que-este-repositório-mostra)
- [O que isso significa para estudantes e profissionais](#o-que-isso-significa-para-estudantes-e-profissionais)
- [Fontes](#fontes)

> **Este é um texto de opinião.** As citações, os números e as datas são
> fatos, e cada um deles é referenciado. A posição defendida e o paradigma
> proposto são argumentos do autor. Ninguém pode provar uma previsão; por isso, o
> ensaio apresenta também os argumentos mais fortes contra ela.

## A resposta em resumo
**Sim.** A IA já está dando origem a um novo paradigma, que este ensaio
denomina **programação orientada a intenção**. Nesse paradigma, o programa
que uma pessoa escreve é uma declaração do **que** se deseja, somada às
**verificações** que decidem se um resultado é aceitável. Um modelo gera o
**como** (o código), e as verificações o aceitam ou o rejeitam. O código
passa a ser um artefato intermediário, como a linguagem de montagem
(assembly) que um compilador produz.

Duas ressalvas a esse "sim":

1. Não se trata de um **quinto ramo isolado** ao lado dos paradigmas
   imperativo, orientado a objetos, funcional e lógico. Ele dá continuidade à linha
   *declarativa* iniciada pela programação lógica ([De onde vem](#de-onde-vem)).
2. Ele **ainda não é maduro**. Os resultados medidos em 2025 são mistos
   ([Evidências até o momento](#evidências-até-o-momento)), e a maior parte do uso de IA hoje
   ainda é assistência dentro dos paradigmas existentes.

## O que caracterizaria um novo paradigma
O termo vem do livro *The Structure of Scientific Revolutions*, de Thomas
Kuhn, publicado em 1962. A Stanford Encyclopedia of Philosophy resume o
paradigma de Kuhn como uma "constellation of shared commitments" de uma
comunidade, isto é, seus "shared theoretical beliefs, values, instruments and
techniques" [1] (tradução livre: "constelação de compromissos compartilhados"; "crenças teóricas,
valores, instrumentos e técnicas compartilhados"). Para a programação, Peter Van Roy
oferece uma definição mais restrita: "A programming paradigm is an approach
to programming a computer based on a mathematical theory or a coherent set
of principles" [2] (tradução livre: "Um paradigma de programação é uma abordagem para
programar um computador com base em uma teoria matemática ou em um conjunto coerente de princípios").

Uma ferramenta mais rápida, portanto, não é um paradigma. Escrever Java com um
autocompletar baseado em IA continua sendo programação orientada a objetos: a pessoa ainda escreve
classes e métodos, e a IA apenas digita mais depressa. Para que a IA crie um
paradigma, ela precisa mudar **de que é feito um programa** e **como ele
se torna algo em execução**, as mesmas duas perguntas que distinguem os quatro
paradigmas em [`docs/paradigms.md`](paradigms.md#what-a-paradigm-is).

A história sugere que uma mudança desse tipo pode começar pequena. O Simula
foi projetado para programas de simulação, e seus autores "introduced the
basic concepts of what later became object-orientation" [12] (tradução livre:
"introduziram os conceitos básicos do que depois se tornou a orientação a
objetos"). Alan Kay escreveu então que "most of my ideas from then on took
their roots from Simula" [13] (tradução livre: "a maior parte das minhas
ideias daí em diante teve suas raízes no Simula"). Uma ideia de estruturação
de um domínio, a simulação, tornou-se com o tempo um paradigma geral. A
[página de paradigmas](paradigms.md#where-object-orientation-came-from)
acompanha o caminho do Simula ao Swift. Este ensaio não afirma que a
programação orientada a intenção seguirá o mesmo caminho, apenas que um
paradigma pode ser reconhecido tarde.

## O paradigma proposto: programação orientada a intenção
Esta seção acrescenta uma linha à tabela de [`docs/paradigms.md`](paradigms.md#what-a-paradigm-is):

| Paradigma | Um programa é… | Como as coisas mudam | Representante |
|---|---|---|---|
| Orientado a intenção *(proposto)* | uma declaração de intenção (prosa e exemplos) mais verificações executáveis (testes, tipos, contratos) | um modelo gera código; o código só é mantido se todas as verificações passarem | nenhum até agora: apenas sistemas iniciais (veja abaixo) |

Seus princípios, que é o que a definição de Van Roy exige:

1. **A intenção é a fonte de verdade.** O que uma pessoa mantém é a
   descrição do objetivo e suas verificações de aceitação. O código pode ser
   descartado e gerado novamente.
2. **As verificações fazem parte do programa, não são um complemento.** Uma declaração
   apenas em prosa é ambígua (veja [a objeção de Dijkstra](#1-a-linguagem-natural-é-imprecisa-demais)),
   portanto um programa só está completo quando diz como um resultado é julgado.
3. **Gerar é buscar.** Os modelos de linguagem *amostram* sua saída, de modo que
   a mesma intenção pode produzir código diferente a cada vez. O paradigma
   aceita isso e transfere a correção do gerador para as verificações.
4. **O ser humano trabalha na essência.** A pessoa decide o que se deseja,
   o que é considerado correto e quais compromissos aceitar. A máquina
   cuida da representação em uma linguagem de programação.

Como poderia ser um Hello World. **Esta é uma notação inventada**, apenas
para ilustração. Nenhuma linguagem assim existe, e este repositório não
a executa:

```text
intent:  Greet the world on the terminal.
example: running the program prints exactly "Hello, World!" and a newline
check:   output == "Hello, World!\n"
check:   exit status == 0
```

A partir disso, um gerador poderia produzir [`c/cli/hello.c`](../languages/c/cli/hello.c),
[`python/cli/hello.py`](../languages/python/cli/hello.py) ou qualquer outra das 100
implementações executáveis daqui. Todas passam pelas mesmas duas verificações. Na
programação orientada a intenção, essas quatro linhas são o programa, e o arquivo
C ou Python é saída, do mesmo modo que um arquivo `.o` é saída hoje.

## Como funcionaria
O ciclo de desenvolvimento é um laço:

1. **Declarar a intenção.** Prosa para o objetivo, exemplos para os casos
   pouco claros, verificações executáveis para o que deve ser verdadeiro.
2. **Gerar.** Um modelo escreve um ou mais programas candidatos em uma
   linguagem existente.
3. **Verificar.** Executar os testes, o verificador de tipos e, quando importa, um
   verificador formal. Rejeitar todo candidato que falhar.
4. **Refinar a intenção, não o código.** Se o programa aceito ainda estiver
   errado, a intenção ou as verificações estavam incompletas. Corrigi-las e gerar
   novamente.

Cada parte desse laço já existe separadamente:

- **Geração avaliada por testes.** O artigo do Codex (2021) introduziu o
  benchmark HumanEval "to measure functional correctness for synthesizing
  programs from docstrings" (tradução livre: "para medir a correção funcional na síntese de
  programas a partir de docstrings"): cada problema é uma descrição em prosa, e uma
  resposta só é aceita se passar em testes unitários [3].
- **Verificações que são provas.** O Dafny se descreve como "a
  verification-aware programming language that has native support for
  recording specifications and is equipped with a static program
  verifier" [4] (tradução livre: "uma linguagem de programação ciente de verificação, com suporte nativo
  ao registro de especificações e equipada com um verificador estático de programas"). Um verificador como esse poderia ser o tipo mais rigoroso de verificação
  no passo 3.
- **Programas construídos a partir de chamadas declaradas a modelos.** O DSPy (2023) apresenta-se
  como "a programming model that abstracts LM pipelines as text
  transformation graphs", em que os modelos de linguagem "are invoked through
  declarative modules", com "a compiler that will optimize any DSPy
  pipeline to maximize a given metric" [5] (tradução livre: "um modelo de programação que abstrai
  pipelines de modelos de linguagem como grafos de transformação de texto"; "são invocados por meio de
  módulos declarativos"; "um compilador que otimizará qualquer pipeline DSPy
  para maximizar uma métrica dada"). As palavras *declarativo*,
  *compilador* e *métrica* mostram o paradigma tomando forma: a pessoa
  declara, um compilador busca, uma métrica decide.

O que ainda não existe é uma linguagem ou toolchain amplamente usada que trate
a intenção e as verificações como *o* programa e o código gerado como um
artefato de compilação (build). Por isso a célula do representante na tabela acima
está vazia.

## De onde vem
A programação orientada a intenção dá continuidade a uma ideia antiga. Em 1979, Robert
Kowalski escreveu que "An algorithm can be regarded as consisting of a logic
component, which specifies the knowledge to be used in solving problems,
and a control component, which determines the problem-solving strategies
by means of which that knowledge is used" [6] (tradução livre: "Um algoritmo pode ser visto como composto de um componente
lógico, que especifica o conhecimento a ser usado na resolução de problemas,
e de um componente de controle, que determina as estratégias de resolução
pelas quais esse conhecimento é usado"). Na programação lógica, a
pessoa escreve a lógica e a máquina fornece o controle; isso pode ser visto
em [`prolog/cli/hello.pl`](../languages/prolog/cli/hello.pl) e em
[`docs/paradigms.md`](paradigms.md#logic).

A programação orientada a intenção leva a mesma linha mais longe. A pessoa
fornece a intenção e as verificações. A máquina fornece o controle **e
o algoritmo**, escrito na linguagem que for mais adequada. O Prolog busca uma
prova com uma estratégia fixa. Um gerador busca em meio a programas possíveis
e é guiado pelo que aprendeu de código existente.

A ideia de que as verificações pertencem **ao interior** do programa também é
mais antiga do que a IA. O Design by Contract de Bertrand Meyer, incorporado ao
[Eiffel](../languages/eiffel/README.md), permite que uma rotina declare "The
client's obligation, which protects the supplier" (a pré-condição) e "The
client's benefit, which describes what the supplier must do" (a
pós-condição) [14] (tradução livre: "A obrigação do cliente, que protege o
fornecedor"; "O benefício do cliente, que descreve o que o fornecedor deve
fazer"). O artigo de Meyer de 1992 apresenta como objetivo ajudar a "improve
the reliability of software systems" [15] (tradução livre: "melhorar a
confiabilidade dos sistemas de software"). Um contrato é uma verificação
escrita ao lado do código e executada com ele
([`eiffel/cli/hello.e`](../languages/eiffel/cli/hello.e) tem um até para o
Hello World; veja [Design by Contract](paradigms.md#design-by-contract)). Nos
termos deste ensaio, é o que mais se aproxima do princípio 2 entre as
linguagens daqui. A comparação é própria deste ensaio, não de Meyer. Em um
programa orientado a intenção, os contratos seriam a parte do código-fonte que
uma pessoa escreve e que um modelo não pode alterar.

A amostragem tem um paralelo na programação quântica. Medir um estado quântico
produz cada resultado "with probability equal to the absolute value squared"
de sua amplitude [16] (tradução livre: "com probabilidade igual ao valor
absoluto ao quadrado"); assim, um programa quântico é julgado ao longo de
muitas execuções, não por uma só. O [QCL](../languages/qcl/README.md), a
linguagem quântica deste repositório, é lido da mesma forma, embora seu Hello
World não use nenhum qubit (veja [Quântico](paradigms.md#quantum)). O código
gerado difere de uma medição quântica, mas o princípio 3 tira a mesma lição de
ambos: quando uma única execução prova pouco, a correção precisa vir de
verificações.

O sonho da "programação automática" é ainda mais antigo. Frederick P. Brooks, Jr. escreveu em
1986: "For almost 40 years, people have been anticipating and writing
about 'automatic programming', the generation of a program for solving a
problem from a statement of the problem specifications" [7] (tradução livre: "Há quase 40 anos, as pessoas
antecipam e escrevem sobre a 'programação automática', a geração de um programa para resolver um
problema a partir de uma declaração das especificações do problema"). O que há de novo
desde 2021 é que a geração funciona com frequência suficiente para ser medida (próxima
seção). O próprio Brooks era cético, e seu argumento é um dos
contra-argumentos adiante.

## Evidências até o momento
Os números mostram progresso e também mostram que o paradigma não está
pronto.

- **A geração a partir de uma descrição funciona, às vezes.** No HumanEval (2021),
  o Codex "solves 28.8% of the problems" com uma amostra por problema, e
  "Using this method [repeated sampling], we solve 70.2% of our problems
  with 100 samples per problem" [3] (tradução livre: "resolve 28,8% dos problemas"; "Usando este método [amostragem repetida], resolvemos 70,2% dos nossos problemas
  com 100 amostras por problema"). Isso sustenta os princípios 2 e 3:
  gerar muitos candidatos e manter aquele que passa nos testes
  funciona muito melhor do que confiar em uma única resposta.
- **A adoção é ampla (em 2025).** Na Stack Overflow Developer Survey 2025, "84%
  of respondents are using or planning to use AI tools in their
  development process" e "51% of professional developers use AI tools
  daily" [8] (tradução livre: "84% dos respondentes usam ou planejam usar ferramentas de IA em seu
  processo de desenvolvimento"; "51% dos desenvolvedores profissionais usam ferramentas de IA
  diariamente").
- **A confiança é baixa (em 2025).** A mesma pesquisa: "More developers actively
  distrust the accuracy of AI tools (46%) than trust it (33%)". A
  maior frustração, "cited by 66% of developers", é "AI solutions that
  are almost right, but not quite" [8] (tradução livre: "Mais desenvolvedores desconfiam ativamente da precisão das ferramentas de IA (46%) do que confiam nelas (33%)"; "citada por 66% dos desenvolvedores"; "soluções de IA que
  estão quase certas, mas não totalmente"). Sem verificações, "quase certo" é o
  resultado normal. Este é o argumento mais forte para tornar as verificações parte
  do programa.
- **Os resultados de velocidade divergem.** Em um experimento controlado de 2023, desenvolvedores
  com o GitHub Copilot implementaram um servidor HTTP em JavaScript "55.8%
  faster than the control group" [9] (tradução livre: "55,8% mais rápido que o grupo de controle"). Em um
  ensaio controlado randomizado de 2025 com 16 desenvolvedores experientes de código aberto trabalhando em seus próprios
  projetos maduros, o METR constatou que "allowing AI actually increases
  completion time by 19%" (tradução livre: "permitir o uso de IA na verdade aumenta o tempo de conclusão em 19%"), embora os desenvolvedores tivessem previsto uma redução de 24%
  [10]. Uma tarefa pequena e bem especificada, feita do zero, ficou mais rápida.
  O trabalho em código existente de grande porte, em que a intenção está sobretudo na
  cabeça das pessoas, ficou mais lento. Isso é consistente com a tese deste ensaio: o ganho depende
  de quão explícitas são a intenção e as verificações.

## Contra-argumentos
Estas são as objeções mais fortes encontradas, cada uma com uma resposta.

### 1. A linguagem natural é imprecisa demais
Edsger Dijkstra escreveu uma nota intitulada "On the foolishness of 'natural
language programming'" (EWD 667, sem data, escrita depois de 1977, pois
cita um relatório de 1977). Ele argumentou que "The virtue of formal texts is that
their manipulations, in order to be legitimate, need to satisfy only a few
simple rules" e que a naturalidade de uma língua materna "boils down to
the ease with which we can use them for making statements the nonsense of
which is not obvious" [11] (tradução livre: "A virtude dos textos formais é que
suas manipulações, para serem legítimas, precisam satisfazer apenas algumas
regras simples"; "se resume à facilidade com que podemos usá-las para fazer afirmações cujo
absurdo não é óbvio").

**Resposta:** a objeção está correta, e é por isso que o paradigma não faz da
prosa o programa. A prosa é a parte *legível* da intenção; a parte
*vinculante* são as verificações, que são formais. Se o paradigma se tornasse
"digitar um desejo e confiar na resposta", a objeção de Dijkstra prevaleceria, e
o número de 66% de "quase certo" [8] mostra como isso se parece.

### 2. É apenas uma linguagem de nível mais alto, não um paradigma
Brooks cita David Parnas: "In short, automatic programming always has
been a euphemism for programming with a higher-level language than was
presently available to the programmer" [7] (tradução livre: "Em suma, programação automática sempre
foi um eufemismo para programar com uma linguagem de nível mais alto do que a
então disponível ao programador"). Por esse ponto de vista, os prompts são o
passo seguinte a Fortran e C, não um novo paradigma.

**Resposta:** em parte, é verdade. A programação orientada a intenção *é* um nível
mais alto. Mas ela também muda duas coisas que um novo nível de linguagem
nunca mudou. Primeiro, a tradução deixa de ser determinística: um compilador produz
a mesma saída para a mesma entrada, e um gerador não [3].
Segundo, a pessoa deixa de ler ou de possuir o código gerado, de modo que as
verificações precisam carregar a confiança que a leitura do código antes carregava. Essas
duas mudanças alteram o que é um programa e como se confia nele, que é
o assunto da definição de Van Roy [2].

### 3. A parte difícil do software não é o código
Novamente Brooks: "I believe the hard part of building software to be the
specification, design, and testing of this conceptual construct, not the
labor of representing it and testing the fidelity of the representation"
[7] (tradução livre: "Creio que a parte difícil de construir software é a
especificação, o projeto e o teste dessa construção conceitual, não o
trabalho de representá-la e de testar a fidelidade da representação"). Ele também escreveu, em 1986, que não esperava que a inteligência
artificial fornecesse "the revolutionary breakthrough that will give
order-of-magnitude gains in software productivity and quality" [7] (tradução livre: "o avanço revolucionário que trará
ganhos de uma ordem de grandeza em produtividade e qualidade de software").

**Resposta:** esta é a objeção mais forte, e o paradigma a aceita.
A IA não elimina a parte difícil. Ela elimina grande parte do trabalho de
*representação*, o que deixa a especificação e o teste,
as partes que Brooks chama de difíceis, como a principal tarefa humana. Essa é a mudança
de paradigma: o programa do ser humano passa a ser a especificação. Se isso
traz ganhos de uma ordem de grandeza é uma questão distinta, e o resultado do METR
[10] indica que, em 2025, para desenvolvedores experientes em projetos
maduros, não trouxe.

### 4. O uso atual de IA é assistência, não uma nova forma de pensar
A maioria dos desenvolvedores usa IA dentro de suas linguagens e fluxos de trabalho habituais [8].
Os programas resultantes continuam sendo Java, Python ou C, escritos nos
paradigmas existentes.

**Resposta:** verdadeiro hoje, e por isso o ensaio diz que o paradigma está
nascendo, não que ele chegou. A visão de Kuhn, como a Stanford Encyclopedia
a resume, é que a ciência revolucionária "is not cumulative" e
envolve "a revision to existing scientific belief or practice" [1] (tradução livre: "não é cumulativa"; "uma revisão da crença ou da prática científica existente"). Um
paradigma de programação é menor do que uma revolução científica, mas o
critério é semelhante: ele chegou quando as pessoas mudam *o que mantêm*,
e não apenas a velocidade com que digitam.

### 5. Pode nunca ser confiável o bastante
Se as verificações forem incompletas, um programa gerado pode passar por elas e ainda assim
estar errado, e ninguém talvez o leia com atenção suficiente para perceber.

**Resposta:** este é um risco real, e o paradigma não tem solução
mágica para ele. Ele apenas torna o risco visível: a qualidade do
programa é limitada pela qualidade de suas verificações. Por isso verificadores
como o Dafny [4] importam e, na visão deste ensaio, por isso aprender a escrever boas
verificações se torna uma habilidade central de programação.

## O que este repositório mostra
Agentes de IA construíram este repositório a partir de uma especificação escrita, de um plano com
uma definição de pronto e de scripts que verificam o resultado.
[`scripts/verify-all.sh`](../scripts/verify-all.sh) executa a verificação do `install.sh`,
o `build.sh` e o `run.sh` de cada implementação executável e verifica
se a saída contém `Hello, World!`;
[`scripts/check-links.sh`](../scripts/check-links.sh) verifica cada link
relativo. Um revisor humano aprovou cada etapa.

Esta é uma pequena versão do laço descrito acima: a intenção é a
especificação, as verificações são os scripts e as revisões, e as 101
implementações em 47 linguagens listadas em
[`languages/README.md`](../languages/README.md#all-implementations) são os
artefatos gerados. A segunda rodada acrescentou a categoria `mobile`, em que
uma verificação precisa iniciar um telefone virtual e olhar para a tela dele.
Ela também mostrou o limite do laço: algumas correções foram nas verificações,
não nos programas. A verificação do Android
([`kotlin/mobile-android/run.sh`](../languages/kotlin/mobile-android/run.sh))
precisou aprender a tocar em **Wait** na caixa de diálogo de "não está
respondendo" que o Android pode exibir em um emulador iniciado a frio, e o
[`scripts/verify-all.sh`](../scripts/verify-all.sh) precisou dar a cada
implementação a sua própria porta. Assim, as verificações também precisam de
revisão, e um revisor precisa lê-las com o mesmo cuidado que dedica ao código.
Este é um único projeto com um programa simples, de modo que
não prova nada por si só. Ele mostra, porém, para onde foi o esforço humano: para
a especificação, o plano, as verificações e a revisão, e não para digitar
`printf`.

## O que isso significa para estudantes e profissionais
- **Aprenda os quatro paradigmas de qualquer modo.** O código gerado é escrito em
  linguagens existentes, e alguém precisa julgar se ele está correto. Não é
  possível revisar um programa em Prolog, ou em Haskell, sem saber como
  essa linguagem pensa ([`docs/paradigms.md`](paradigms.md)).
- **Aprenda a escrever verificações.** Um teste, um tipo ou um contrato é a parte do
  programa com a qual um gerador não consegue argumentar. O `require` e o `ensure` do Eiffel são o
  exemplo mais antigo neste repositório.
- **Aprenda a ler verificações.** Uma verificação errada aceita código errado;
  por isso, uma verificação é revisada como código.
- **Aprenda a declarar a intenção com precisão.** O alerta de Dijkstra [11] continua
  válido: a habilidade consiste em dizer exatamente o que se quer, em prosa e em verificações
  formais.

## Fontes
1. Thomas Kuhn. Alexander Bird, *The Stanford Encyclopedia of Philosophy*, publicado pela primeira vez em 2004-08-13, revisão substancial em 2025-09-02. Metaphysics Research Lab, Stanford University. <https://plato.stanford.edu/entries/thomas-kuhn/> (acessado em 2026-11-02)
2. Programming Paradigms for Dummies: What Every Programmer Should Know. Peter Van Roy, in *New Computational Paradigms for Computer Music*, G. Assayag and A. Gerzso (eds.), IRCAM/Delatour France, 2009. Cópia do autor, UCLouvain. <https://webperso.info.ucl.ac.be/~pvr/VanRoyChapter.pdf> (acessado em 2026-11-02)
3. Evaluating Large Language Models Trained on Code. Mark Chen et al., OpenAI, arXiv:2107.03374, 2021. <https://arxiv.org/abs/2107.03374> (acessado em 2026-11-02)
4. Dafny: The Dafny Programming and Verification Language. Dafny project. <https://dafny.org/> (acessado em 2026-11-02)
5. DSPy: Compiling Declarative Language Model Calls into Self-Improving Pipelines. Omar Khattab et al., arXiv:2310.03714, 2023. <https://arxiv.org/abs/2310.03714> (acessado em 2026-11-02)
6. Algorithm = Logic + Control. Robert Kowalski, Communications of the ACM, July 1979. <https://www.doc.ic.ac.uk/~rak/papers/algorithm%20=%20logic%20+%20control.pdf> (acessado em 2026-11-02)
7. No Silver Bullet: Essence and Accident in Software Engineering. Frederick P. Brooks, Jr., Proceedings of the IFIP Tenth World Computing Conference, Elsevier, 1986, pp. 1069–1076; reimpresso em *The Mythical Man-Month*, anniversary edition, Addison-Wesley, 1995. Cópia utilizada: <https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf> (acessado em 2026-11-02)
8. Stack Overflow Developer Survey 2025: AI. Stack Overflow, 2025. <https://survey.stackoverflow.co/2025/ai> (acessado em 2026-11-20)
9. The Impact of AI on Developer Productivity: Evidence from GitHub Copilot. Sida Peng, Eirini Kalliamvakou, Peter Cihon, Mert Demirer, arXiv:2302.06590, 2023. <https://arxiv.org/abs/2302.06590> (acessado em 2026-11-02)
10. Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity. Joel Becker, Nate Rush, Beth Barnes, David Rein, METR, arXiv:2507.09089, 2025. <https://arxiv.org/abs/2507.09089> (acessado em 2026-11-02)
11. EWD 667: On the foolishness of "natural language programming". Edsger W. Dijkstra; E. W. Dijkstra Archive, University of Texas at Austin. <https://www.cs.utexas.edu/~EWD/transcriptions/EWD06xx/EWD667.html> (acessado em 2026-11-02)
12. The Birth of Simula. Stein Krogdahl, Department of Informatics, University of Oslo. <https://www.mn.uio.no/english/services/it/simula/bibliography/history/sk-the-birth-of-simula.pdf> (acessado em 2026-11-16)
13. The Early History of Smalltalk. Alan C. Kay, Second History of Programming Languages conference (HOPL-II), ACM, 1993. Cópia do texto completo: <https://worrydream.com/EarlyHistoryOfSmalltalk/> (acessado em 2026-11-16)
14. Design by Contract, Assertions and Exceptions (Eiffel Tutorial). Eiffel Software, eiffel.org. <https://www.eiffel.org/doc/eiffel/ET-_Design_by_Contract_%28tm%29%2C_Assertions_and_Exceptions> (acessado em 2026-11-16)
15. Applying "Design by Contract". Bertrand Meyer, *Computer* (IEEE), October 1992. Cópia do autor, ETH Zurich. <https://se.inf.ethz.ch/~meyer/publications/computer/contract.pdf> (acessado em 2026-11-16)
16. Quantum information (Basics of quantum information, Single systems). IBM Quantum Learning. <https://quantum.cloud.ibm.com/learning/en/courses/basics-of-quantum-information/single-systems/quantum-information> (acessado em 2026-11-16)
