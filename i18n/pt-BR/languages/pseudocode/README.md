---
source: languages/pseudocode/README.md
source_sha: abfabd0a59515ecce87fe400b8b0af3cffdbb628
---
# Pseudocódigo

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo (notação de ensino). Um algoritmo em pseudocódigo é
uma lista de passos executados de cima para baixo, com variáveis, decisões e
laços, o mesmo modelo do C, do Pascal ou do Python. Ele é escrito para ser
lido por pessoas, não por um computador, embora alguns dialetos de ensino
tenham interpretadores.

Ver também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

Esta página apresenta três variantes de pseudocódigo selecionadas pela
evidência de uso em disciplinas universitárias introdutórias de programação
(a primeira disciplina de programação costuma ser chamada de CS1). Ela
explica como as três foram escolhidas, com as evidências, e reúne em seguida
comentários críticos de professores e especialistas sobre o uso do
pseudocódigo hoje.

## Implementações
O pseudocódigo não tem categoria desktop nem web (ver
[Por que não há versão desktop nem web](#por-que-não-há-versão-desktop-nem-web)).
Cada variante tem uma pasta.

| Variante | Pasta | Região / disciplina | Toolchain | Situação |
|---|---|---|---|---|
| **Portugol** (dialeto VisuAlg) | [portugol/](portugol/) | Brasil (português), CS1 | interpretador Delégua (dialeto VisuAlg), via npm | ✅ |
| **PSeInt** | [pseint/](pseint/) | países de língua espanhola, CS1 | PSeInt | ✅ |
| Pseudocódigo de livro-texto no estilo **CLRS** | [clrs/](clrs/) | disciplinas de algoritmos em língua inglesa | nenhuma: apenas documentado | 📄 |

## Método de seleção
1. **Candidatos.** Cinco: a família Portugol
   (VisuAlg, Portugol Studio), o PSeInt, o pseudocódigo de livro-texto no
   estilo CLRS, o pseudocódigo das provas do Cambridge International e o
   Flowgorithm.
2. **Critérios**, nesta ordem:
   - **Usado em disciplinas universitárias introdutórias**: artigos,
     ementas ou material didático que o comprovem.
   - **Alcance**: números mensuráveis com ano e fonte (downloads,
     exemplares vendidos). Não existe pesquisa que compare dialetos de
     pseudocódigo entre países; por isso, cada candidato é medido com o que
     seu editor ou hospedagem publica.
   - **Recomendado / mantido**: uma fonte oficial atual, uma ferramenta
     mantida, uma finalidade de ensino declarada.
3. **Regra** ([Sobre as fontes](../../docs/sources.md)): apenas fatos lidos em
   uma página HTTPS; o que não pôde ser confirmado foi descartado e está
   listado em [O que não pôde ser verificado](#o-que-não-pôde-ser-verificado).

## Evidências do ranking
| # | Candidato | Evidência em disciplinas universitárias | Alcance (ano, fonte) | Mantido / ferramenta | Resultado |
|---|---|---|---|---|---|
| 1 | **Portugol** (VisuAlg, Portugol Studio) | 114 de 150 disciplinas de CS1 em 61 universidades federais brasileiras abordam "Representações de algoritmos" ("pseudocódigo e fluxogramas"), 76,0%, e algumas não ensinam linguagem alguma no início, apenas pseudocódigo [1]. "Most of the books used as basic reference" (tradução livre: "A maioria dos livros usados como referência básica") em disciplinas introdutórias de universidades brasileiras usam "some Portugol notation" (tradução livre: "alguma notação Portugol") (Zanini e Raabe 2012, conforme citado em 2014 [2]). O Portugol Studio foi usado pela primeira vez na Universidade do Vale do Itajaí (UNIVALI) em 2011 [3]. | VisuAlg 3.0: 2.976.812 downloads no SourceForge, 2.687.773 deles do Brasil (todo o período, lido em 2026-11-02) [4]. Portugol Studio: 959.624 downloads de versões no GitHub (todas as versões, lido em 2026-11-02) [5]; "more than 240,000 downloads" (tradução livre: "mais de 240.000 downloads") e 108.589 usuários em 2019 [3]. | VisuAlg 3.0.7.0, 2019, somente Windows [6]. Portugol Studio 2.7.5, 2020 [5]. O interpretador Delégua (licença MIT) executa o dialeto VisuAlg em qualquer sistema operacional com Node.js [7][8]. | ✅ selecionado |
| 2 | **PSeInt** | Feito para "a student in their first steps in programming" (tradução livre: "um estudante em seus primeiros passos na programação") por um docente de Engenharia da Computação da Universidad Nacional del Litoral, Argentina [9][10]. Cada escola pode escolher um "profile" (tradução livre: "perfil") que adapta a linguagem "for their university/faculty/degree" (tradução livre: "para sua universidade/faculdade/curso") às exigências do professor [28]; a versão 20250314 inclui 467 desses perfis (contados em sua pasta `perfiles/` em 2026-11-02). Nenhuma pesquisa que contasse universidades foi encontrada. | 16.705.302 downloads no SourceForge (todo o período, lido em 2026-11-02); principais países: México 4.795.908, Colômbia 3.058.217, Argentina 1.483.968, Peru 1.301.721 [11]. | Versão 20250314, compilações nativas para Windows, macOS e Linux, GPLv2 [9][12]. | ✅ selecionado |
| 3 | **Estilo CLRS** | O livro-texto *Introduction to Algorithms* (Cormen, Leiserson, Rivest, Stein) nasceu da disciplina de algoritmos 6.046 do MIT [13]. | "Over 1 million copies worldwide" (MIT News, 2022) [13] (tradução livre: "mais de 1 milhão de exemplares no mundo todo"). | 4ª edição de 2022 [13]; os autores publicam um pacote LaTeX para compor pseudocódigo "just as we do in Introduction to Algorithms" [14] (tradução livre: "exatamente como fazemos em Introduction to Algorithms"). Sem interpretador. | ✅ selecionado |
| 4 | Pseudocódigo do Cambridge International 9618 | Guia oficial para as provas AS/A Level de 2027–2029 (publicado em setembro de 2024) [15]. São provas pré-universitárias, não disciplinas universitárias. | Nenhum número publicado. | Guia oficial, sem interpretador. | ❌ não é uma disciplina universitária |
| 5 | Flowgorithm | Um artigo de 2015 da ASEE, escrito por seu autor (California State University, Sacramento), sobre o ensino de programação introdutória com fluxogramas; na época "only available on Microsoft Windows" [16] (tradução livre: "disponível somente no Microsoft Windows"). | Nenhum número publicado. | 4.5.0, 2024-10-08, freeware [17]. O site oficial falhou na verificação HTTPS em 2026-11-02. | ❌ uma ferramenta de fluxogramas, evidência mais fraca |

**Por que estas três.** Cada uma das três predomina em um grande grupo de
estudantes: o Portugol em português, o PSeInt em espanhol e o CLRS nas
disciplinas de algoritmos em inglês. As duas primeiras têm palavras-chave no
idioma do próprio estudante e um interpretador. O CLRS é a notação que a
maioria dos estudantes encontra mais tarde, na disciplina de algoritmos;
assim, mostra o que "pseudocódigo" significa nos livros-texto em língua
inglesa.

**Limites da evidência.** Os números medem coisas diferentes (downloads,
exemplares vendidos, ementas) e não podem ser comparados entre si. Downloads
não são estudantes: um estudante pode baixar uma ferramenta mais de uma vez,
e um laboratório pode instalá-la uma única vez para muitos estudantes. O
ranking baseia-se, portanto, na evidência de uso em disciplinas
introdutórias universitárias dentro de cada comunidade linguística, e não em
uma contagem global única.

## Histórico
- **Pseudocódigo em livros-texto.** A primeira edição do CLRS apareceu em
  1990; o livro partiu da disciplina 6.046 do MIT [13]. Seu pseudocódigo é
  uma notação para descrever algoritmos independentemente de qualquer
  linguagem, composta com o pacote LaTeX dos próprios autores [14].
- **Portugol** é uma família de dialetos de pseudocódigo com palavras-chave
  em português. Ele "tem diversas variações em sintaxe" [18]. O VisuAlg 3.0, de Antonio Carlos Nicolodi, é um editor e interpretador
  para Windows de um desses dialetos [6]. O Portugol Studio foi desenvolvido
  pelo laboratório LITE da UNIVALI [19], onde é usado desde 2011 [3].
- **PSeInt** ("PSeudo Intérprete") é de Pablo Novara, graduado e docente de
  Engenharia da Computação na FICH, Universidad Nacional del Litoral,
  Argentina [10]. Seu projeto no SourceForge foi registrado em 2004-11-28
  [12].

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 1990 | Primeira edição de *Introduction to Algorithms* (CLRS) | [13] |
| 2004 | Projeto PSeInt registrado no SourceForge (2004-11-28) | [12] |
| 2011 | Primeira versão do Portugol Studio usada na UNIVALI | [3] |
| 2015 | PSeInt é nomeado Projeto do Mês "Community Choice" do SourceForge (setembro) | [10] |
| 2015 | Artigo sobre o Flowgorithm na ASEE Pacific Southwest Conference | [16] |
| 2019 | VisuAlg 3.0.7.0 lançado (2019-03-21) | [6] |
| 2020 | Portugol Studio 2.7.5, sua versão mais recente (2020-11-27) | [5] |
| 2022 | CLRS 4ª edição; o livro ultrapassa 1 milhão de exemplares | [13] |
| 2024 | O Cambridge International publica seu Pseudocode Guide 2027–2029 | [15] |
| 2025 | PSeInt versão 20250314 | [9] |

## Uso no mercado hoje
"Mercado" aqui significa salas de aula. Ver [Evidências do ranking](#evidências-do-ranking)
para os números, cada um com data e fonte. Em resumo (tudo lido em
2026-11-02, salvo indicação em contrário): PSeInt, 16,7 milhões de downloads
no SourceForge, principalmente na América Latina [11]; VisuAlg 3.0, cerca de
3,0 milhões, 90% do Brasil [4]; Portugol Studio, cerca de 960.000 downloads
de versões no GitHub [5]; CLRS, mais de 1 milhão de exemplares vendidos
(2022) [13].

## Visões críticas de professores e especialistas
As citações são copiadas palavra por palavra. As traduções das citações em
inglês e em espanhol são deste repositório.

**Contra, ou com ressalvas**
- **Sem retorno e uma transição difícil.** Barbosa, Couto e Terra
  (Universidade Federal de Lavras, 2016) [18]:
  > "Apesar de trazer benefícios inquestionáveis no aprendizado de Lógica
  > de Programação e Algoritmos, o Portugol não provê, por definição, uma
  > forma de executar o pseudocódigo escrito para que alunos possam testar
  > seus algoritmos, o que se torna indispensável à medida que os
  > algoritmos se tornam mais complexos e passam a requerer códigos mais
  > elaborados."

  > "Assim, devido à origem sintática de Portugol, estudantes não terão
  > uma transição natural ao aprender linguagens de programação do
  > estado-da-prática como C ANSI e Java."
- **Detalhado demais.** Ramon Mayor Martins (Instituto Federal de Santa
  Catarina, 2025) [20]:
  > "No entanto, apesar de já muito experimentadas por décadas,
  > ferramentas tradicionais como Portugol ou Algol podem ser
  > excessivamente detalhadas e perder o foco no ensino da própria lógica
  > de programação."
- **Ambiguidade em provas.** Cutts, Connor, Donaldson e Michaelson
  (Universidades de Glasgow, Strathclyde e Heriot-Watt, 2014) [21]:
  > "This paper argues that the "institutionalised understanding" of
  > pseudo-code as a blend of formal and natural languages makes it an
  > unsuitable choice for national assessment where the intention is to
  > test program comprehension skills. It permits question-setters to
  > inadvertently introduce a level of ambiguity and consequent
  > confusion."

  (tradução livre: "Este artigo argumenta que o "entendimento
  institucionalizado" do pseudocódigo como uma mistura de linguagens formais
  e naturais o torna uma escolha inadequada para a avaliação nacional, em
  que a intenção é testar a capacidade de compreensão de programas. Ele
  permite que os elaboradores de questões introduzam, sem perceber, um nível
  de ambiguidade e a consequente confusão.")
- **Linguagens localizadas raramente se difundem.** Philip Guo (UC San Diego,
  2018) [22]:
  > "There have been attempts to create programming languages with
  > non-English keywords [80], but so far none have been widely adopted
  > [77]."

  (tradução livre: "Houve tentativas de criar linguagens de programação com
  palavras-chave que não são em inglês [80], mas até agora nenhuma foi
  amplamente adotada [77].")

**A favor**
- **Palavras-chave no idioma nativo.** Noschang, Pelz, de Jesus e Raabe
  (UNIVALI, 2014) [2]:
  > "Entre as vantagens da utilização do Portugol com alunos iniciantes
  > estão a simplicidade da linguagem e o fato das palavras-chave e
  > comandos estarem em português, evitando os problemas com o idioma
  > inglês."

  O estudo de Guo sobre falantes não nativos de inglês aponta a mesma
  barreira: "A common root cause is that programming language keywords (such
  as "while") are in English" [22] (tradução livre: "Uma causa-raiz comum é
  que as palavras-chave das linguagens de programação (como "while") estão em
  inglês"). Felienne Hermans (Vrije Universiteit Amsterdam, 2024) afirma que
  os problemas das ferramentas existentes "disproportionally affect
  underrepresented minorities in programming including girls, kids with
  disabilities and non-English learners" [23] (tradução livre: "afetam de
  forma desproporcional as minorias sub-representadas na programação,
  incluindo meninas, crianças com deficiência e aprendizes que não falam
  inglês"); sua resposta, o Hedy, é uma linguagem gradual real e executável,
  e não um pseudocódigo.
- **Foco nos conceitos, não na sintaxe.** O próprio site do PSeInt diz que
  seu "simple e intuitivo pseudolenguaje en español" (tradução livre:
  "pseudolinguagem simples e intuitiva em espanhol") permite ao estudante
  "centrar su atención en los conceptos fundamentales de la algoritmia
  computacional, minimizando las dificultades propias de un lenguaje"
  (tradução livre: "concentrar a atenção nos conceitos fundamentais da
  algoritmia computacional, minimizando as dificuldades próprias de uma
  linguagem") [9]. Esta é uma afirmação do autor da ferramenta, não um
  estudo.
- **As bancas de exame ainda a usam, de modo flexível.** AQA (GCSE Computer
  Science, Inglaterra) [24]:
  > "Students do not have to use this style of pseudo-code in their own
  > work or written assessments, although they are free to do so. The
  > only direction to students when answering questions or describing
  > algorithms written in pseudo-code is that their code is clear,
  > consistent and unambiguous."

  (tradução livre: "Os estudantes não precisam usar este estilo de
  pseudocódigo em seus próprios trabalhos nem em avaliações escritas,
  embora sejam livres para fazê-lo. A única orientação aos estudantes ao
  responder a questões ou descrever algoritmos escritos em pseudocódigo é
  que o código seja claro, consistente e não ambíguo.")

**Estudos recentes: pseudocódigo e geradores de código com IA**
- Denny, Prather, Becker et al. (2023, publicado na *Communications of the
  ACM* em 2024) [25]:
  > "Novices may be able to generate code by communicating natural
  > language descriptions to the models, but natural language is ambiguous
  > and the ability to read and comprehend code is arguably more important
  > now than ever."

  (tradução livre: "Os iniciantes podem conseguir gerar código comunicando
  descrições em linguagem natural aos modelos, mas a linguagem natural é
  ambígua, e a capacidade de ler e compreender código é, possivelmente,
  mais importante agora do que nunca.")
- Kazemitabaar et al. (University of Toronto e outras, 2023) observaram
  iniciantes usando um gerador de código baseado em um modelo de linguagem de
  grande porte (LLM) em um contexto de CS1 [26]:
  > "Compared to other learners who simply prompted the behavior (e.g.,
  > "find the largest number"), such usages of pseudocode indicate a
  > deeper algorithmic thinking."

  (tradução livre: "Em comparação com outros aprendizes que simplesmente
  descreviam o comportamento no prompt (por exemplo, "encontre o maior
  número"), tais usos do pseudocódigo indicam um raciocínio algorítmico mais
  profundo.")
- Nguyen et al. (CHI 2024) constataram que os iniciantes "struggle with
  writing and editing prompts, even for problems at their skill level and
  when correctness is automatically determined" [27] (tradução livre:
  "têm dificuldade para escrever e editar prompts, mesmo para problemas do
  seu nível de habilidade e quando a correção é determinada
  automaticamente").

**Resumo do debate.** Os críticos concordam em três pontos fracos: o
pseudocódigo no papel não dá retorno, sua sintaxe não é padronizada e a
passagem para uma linguagem real não é gratuita. Interpretadores como o
PSeInt, o VisuAlg e o Delégua respondem ao primeiro ponto, razão pela qual
duas das três variantes aqui executam. Os defensores destacam as
palavras-chave no idioma nativo e o foco na lógica. Os estudos recentes
sobre IA acrescentam um novo argumento a favor da habilidade que está por
trás do pseudocódigo: enunciar um algoritmo com precisão, passo a passo, é
o que os iniciantes precisam para dirigir e verificar um gerador de código
com IA [25][26][27].

## Importância antes e agora
- **Antes:** o pseudocódigo permitia que os professores apresentassem
  algoritmos antes de uma linguagem de programação, ou sem ela, e que
  livros-texto como o CLRS descrevessem algoritmos independentemente de
  qualquer linguagem [13][14]. No Brasil, algumas disciplinas de CS1 ainda
  não ensinam linguagem alguma no início, apenas pseudocódigo [1].
- **Agora:** os dialetos no idioma nativo ainda são baixados em grande número
  (números de 2026 acima) [4][5][11]. Suas ferramentas, porém, estão
  envelhecendo: a última versão do VisuAlg é de 2019 e a do Portugol Studio
  é de 2020 [5][6], enquanto o PSeInt ainda recebe versões [9] e executores
  mais novos, como o Delégua, existem [7].

## Comparação entre as variantes
O mesmo programa nos três estilos:

| Portugol (VisuAlg) | PSeInt | Estilo CLRS |
|---|---|---|
| `algoritmo "OlaMundo"` | `Algoritmo HolaMundo` | `HELLO-WORLD()` |
| `var` | | |
| `inicio` | | |
| `   escreval("Hello, World!")` | `    Escribir "Hello, World!";` | `1  print "Hello, World!"` |
| `fimalgoritmo` | `FinAlgoritmo` | |

- **As palavras-chave** estão em português, espanhol ou inglês.
- **Blocos:** o VisuAlg e o PSeInt fecham blocos com palavras-chave
  (`fimalgoritmo`, `FinAlgoritmo`), como o Pascal; o CLRS não tem
  palavras-chave de fechamento e mostra o corpo de um bloco pelo nível de
  indentação, como o Python [29].
- **Declarações:** o VisuAlg tem uma seção `var` antes de `inicio`, como o
  Pascal. No PSeInt, isso depende do perfil da escola: 30 dos 467 perfis da
  versão 20250314 definem `force_define_vars=1` (contados em 2026-11-02). O
  CLRS não declara tipos.
- **Execução:** as duas primeiras têm interpretadores; o CLRS é apenas lido.

O README de cada pasta percorre seu arquivo linha por linha.

## Por que não há versão desktop nem web
O pseudocódigo é uma notação de ensino, não uma plataforma para aplicações.
Os dois interpretadores apenas leem e escrevem texto em uma janela de
console [8][9]; não têm interface gráfica do usuário (GUI) nem biblioteca
HTTP; portanto, uma janela desktop ou um servidor web não pode ser escrito
*em* pseudocódigo. (Os editores do PSeInt e do Portugol Studio são programas
desktop, mas são a ferramenta, não o programa do estudante.)

## O que não pôde ser verificado
Descartado desta página porque nenhuma fonte primária legível foi
encontrada (verificado em 2026-11-02): quem escreveu as primeiras versões do
VisuAlg; a data da primeira versão do PSeInt; o número de universidades que
adotam o CLRS; números de download ou de adoção do Flowgorithm e do
pseudocódigo do Cambridge; uma contagem, revisada por pares, das
universidades latino-americanas que usam o PSeInt.

## Fontes
1. da Silva, E. P.; Caceffo, R. E.; de Azevedo, R. J. "Análise dos Tópicos Mais Abordados em Disciplinas de Introdução à Programação em Universidades Federais Brasileiras". EDUCOMP 2022. SBC OpenLib. <https://sol.sbc.org.br/index.php/educomp/article/download/19196/19025> (acessado em 2026-11-02)
2. Noschang, L. F.; Pelz, F.; de Jesus, E. A.; Raabe, A. L. A. "Portugol Studio: Uma IDE para Iniciantes em Programação". WEI/CSBC 2014. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/10954/10824> (acessado em 2026-11-02)
3. Esteves, A. M. S.; Noschang, L. F.; Raabe, A. L. A.; Haendchen Filho, A. "Portugol Studio: Em direção a uma comunidade aberta para pesquisa sobre o aprendizado de programação". WEI 2019. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/6656/6552> (acessado em 2026-11-02)
4. VisuAlg 3.0 download statistics. SourceForge. <https://sourceforge.net/projects/visualg30/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (acessado em 2026-11-02)
5. Portugol Studio releases. UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio/releases> (acessado em 2026-11-02)
6. VisuAlg 3.0. SourceForge. <https://sourceforge.net/projects/visualg30/> (acessado em 2026-11-02)
7. Delégua. Design Líquido, GitHub. <https://github.com/DesignLiquido/delegua> (acessado em 2026-11-02)
8. @designliquido/visualg (npm package). npm. <https://www.npmjs.com/package/@designliquido/visualg> (acessado em 2026-11-02)
9. PSeInt (home page). <https://pseint.sourceforge.net/> (acessado em 2026-11-02)
10. "Premian a docente de la FICH por un desarrollo de software libre" (Docente da FICH é premiado por um desenvolvimento de software livre). Universidad Nacional del Litoral, 2015-09-03. <https://www.unl.edu.ar/noticias/news/view/premian_a_docente_de_la_fich_por_un_desarrollo_de_software_libre_1> (acessado em 2026-11-02)
11. PSeInt download statistics. SourceForge. <https://sourceforge.net/projects/pseint/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (acessado em 2026-11-02)
12. PSeInt project page. SourceForge. <https://sourceforge.net/projects/pseint/> (acessado em 2026-11-02)
13. Q&A: What makes a bestselling textbook? (Introduction to Algorithms). MIT News, 2022-02-23. <https://news.mit.edu/2022/qa-what-makes-bestselling-textbook-introduction-algorithms-0223> (acessado em 2026-11-02)
14. Cormen, T. H. `clrscode`: LaTeX package for CLRS pseudocode. Dartmouth College. <https://web.archive.org/web/20250210061943/https://www.cs.dartmouth.edu/~thc/clrscode/> (acessado em 2026-11-02)
15. 2027 - 2029 Pseudocode Guide (AS & A Level Computer Science 9618). Cambridge University Press & Assessment, 2024. <https://www.cambridgeinternational.org/Images/721401-2027-2029-pseudocode-guide.pdf> (acessado em 2026-11-02)
16. Cook, D. D. Flowgorithm: Principles for Teaching Introductory Programming Using Flowcharts. ASEE Pacific Southwest Conference 2015. <https://peer.asee.org/54443.pdf> (acessado em 2026-11-02)
17. DevinCook.Flowgorithm 4.5.0 manifest. microsoft/winget-pkgs, GitHub. <https://github.com/microsoft/winget-pkgs/tree/master/manifests/d/DevinCook/Flowgorithm/4.5.0> (acessado em 2026-11-02)
18. Barbosa, Couto e Terra. "PortuCol: uma pseudo linguagem inspirada em C ANSI para o Ensino de Lógica de Programação e Algoritmos". WEI 2016. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/9678/9579> (acessado em 2026-11-02)
19. Portugol Studio (repository README). UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio> (acessado em 2026-11-02)
20. Martins, R. M. "PseudocodeLab: Uma Ferramenta Educacional Open Source e Gentil para o Ensino de Programação com Pseudocódigos". EduComp 2025 (extended). SBC OpenLib. <https://sol.sbc.org.br/index.php/educomp_estendido/article/view/34912> (acessado em 2026-11-02)
21. Cutts, Q.; Connor, R.; Donaldson, P.; Michaelson, G. Code or (not Code) – Separating Formal and Natural Language in CS Education. WiPSCE '14, ACM. <https://www.macs.hw.ac.uk/~greg/publications/ccdm.WIPSCE14.pdf> (acessado em 2026-11-02)
22. Guo, P. J. Non-Native English Speakers Learning Computer Programming: Barriers, Desires, and Design Opportunities. CHI 2018, ACM. <https://pg.ucsd.edu/publications/non-native-english-speakers-learning-programming_CHI-2018.pdf> (acessado em 2026-11-02)
23. Hermans, F. Hedy: An Inclusive, Multi-Lingual, and Gradual Programming Language (Invited Talk). ICPEC 2024, OASIcs vol. 122. <https://drops.dagstuhl.de/entities/document/10.4230/OASIcs.ICPEC.2024.1> (acessado em 2026-11-02)
24. Notes and guidance: Pseudo-code. GCSE Computer Science 8525. AQA. <https://filestore.aqa.org.uk/resources/computing/AQA-8525-NG-PC.PDF> (acessado em 2026-11-02)
25. Denny, P.; Prather, J.; Becker, B. A. et al. Computing Education in the Era of Generative AI. arXiv 2306.02608 (Communications of the ACM 67(2), 2024). <https://arxiv.org/pdf/2306.02608v1> (acessado em 2026-11-02)
26. Kazemitabaar, M. et al. How Novices Use LLM-Based Code Generators to Solve CS1 Coding Tasks in a Self-Paced Learning Environment. Koli Calling 2023. arXiv 2309.14049. <https://arxiv.org/pdf/2309.14049> (acessado em 2026-11-02)
27. Nguyen, S. et al. How Beginning Programmers and Code LLMs (Mis)read Each Other. CHI 2024. arXiv 2401.15232. <https://arxiv.org/abs/2401.15232v2> (acessado em 2026-11-02)
28. "Perfiles" (Perfis). PSeInt. <https://pseint.sourceforge.net/index.php?page=perfiles.php> (acessado em 2026-11-02)
29. Cormen, T. H. Using the clrscode3e Package in LaTeX 2e (manual). Dartmouth College. <https://web.archive.org/web/20250328084750/https://www.cs.dartmouth.edu/~thc/clrscode/clrscode3e.pdf> (acessado em 2026-11-02)
