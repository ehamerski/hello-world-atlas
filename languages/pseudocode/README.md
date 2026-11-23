# Pseudocode

> Part of [Hello World in many languages](../../README.md)

**Paradigm:** imperative (teaching notation). A pseudocode algorithm is a
list of steps run from top to bottom, with variables, decisions, and
loops, the same model as C, Pascal, or Python. It is written for people to
read, not for a computer, although some teaching dialects have
interpreters.

See also: [paradigms](../../docs/paradigms.md#imperative) (how this paradigm
compares with the others) and [comparisons](../../docs/comparisons.md)
(this language side by side with the other languages).

This page presents three pseudocode variants selected for their evidence
of use in university introductory programming courses (the first
programming course is often called CS1). It explains how the three were
chosen, with the evidence, and then collects critical comments from
teachers and specialists about the use of pseudocode today.

## Implementations
Pseudocode has no desktop or web category (see
[Why there is no desktop or web version](#why-there-is-no-desktop-or-web-version)).
Each variant has one folder.

| Variant | Folder | Region / course | Toolchain | Status |
|---|---|---|---|---|
| **Portugol** (VisuAlg dialect) | [portugol/](portugol/) | Brazil (Portuguese), CS1 | Delégua interpreter (VisuAlg dialect), via npm | ✅ |
| **PSeInt** | [pseint/](pseint/) | Spanish-speaking countries, CS1 | PSeInt | ✅ |
| **CLRS-style** textbook pseudocode | [clrs/](clrs/) | English-language algorithms courses | none: documented only | 📄 |

## Selection method
1. **Candidates.** Five: the Portugol family
   (VisuAlg, Portugol Studio), PSeInt, CLRS-style textbook pseudocode,
   Cambridge International exam pseudocode and Flowgorithm.
2. **Criteria**, in this order:
   - **Used in university introductory courses**: papers,
     syllabi, or course material that show it.
   - **Reach**: measurable numbers with year and source (downloads,
     copies sold). There is no survey that compares pseudocode dialects
     across countries, so each candidate is measured with what its
     publisher or host publishes.
   - **Recommended / maintained**: a current official source, a
     maintained tool, a stated teaching purpose.
3. **Rule** ([About the sources](../../docs/sources.md)): only facts read on an HTTPS page;
   anything that could not be confirmed was dropped, and is listed under
   [What could not be verified](#what-could-not-be-verified).

## Ranking evidence
| # | Candidate | University-course evidence | Reach (year, source) | Maintained / tool | Result |
|---|---|---|---|---|---|
| 1 | **Portugol** (VisuAlg, Portugol Studio) | 114 of 150 CS1 courses at 61 Brazilian federal universities cover "Representações de algoritmos" (algorithm representations: "pseudocódigo e fluxogramas", pseudocode and flowcharts), 76.0%, and some teach no language at first, only pseudocode [1]. "Most of the books used as basic reference" in Brazilian university intro courses use "some Portugol notation" (Zanini and Raabe 2012, as cited in 2014 [2]). Portugol Studio was first used at the Universidade do Vale do Itajaí (UNIVALI) in 2011 [3]. | VisuAlg 3.0: 2,976,812 SourceForge downloads, 2,687,773 of them from Brazil (all-time, read 2026-11-02) [4]. Portugol Studio: 959,624 GitHub release downloads (all releases, read 2026-11-02) [5]; "more than 240,000 downloads" and 108,589 users in 2019 [3]. | VisuAlg 3.0.7.0, 2019, Windows only [6]. Portugol Studio 2.7.5, 2020 [5]. The Delégua interpreter (MIT license) runs the VisuAlg dialect on any operating system with Node.js [7][8]. | ✅ selected |
| 2 | **PSeInt** | Made for "a student in their first steps in programming" by a lecturer of Computer Engineering at Universidad Nacional del Litoral, Argentina [9][10]. Each school can pick a "profile" that adapts the language "for their university/faculty/degree" to the teacher's requirements [28]; release 20250314 ships 467 such profiles (counted in its `perfiles/` folder on 2026-11-02). No survey counting universities was found. | 16,705,302 SourceForge downloads (all-time, read 2026-11-02); top countries Mexico 4,795,908, Colombia 3,058,217, Argentina 1,483,968, Peru 1,301,721 [11]. | Release 20250314, native builds for Windows, macOS, and Linux, GPLv2 [9][12]. | ✅ selected |
| 3 | **CLRS-style** | The textbook *Introduction to Algorithms* (Cormen, Leiserson, Rivest, Stein) grew out of MIT's algorithms course 6.046 [13]. | "Over 1 million copies worldwide" (MIT News, 2022) [13]. | 4th edition 2022 [13]; the authors publish a LaTeX package to typeset pseudocode "just as we do in Introduction to Algorithms" [14]. No interpreter. | ✅ selected |
| 4 | Cambridge International 9618 pseudocode | Official guide for AS/A Level exams 2027–2029 (published September 2024) [15]. These are pre-university exams, not university courses. | No numbers published. | Official guide, no interpreter. | ❌ not a university course |
| 5 | Flowgorithm | A 2015 ASEE paper by its author (California State University, Sacramento) on teaching intro programming with flowcharts; then "only available on Microsoft Windows" [16]. | No numbers published. | 4.5.0, 2024-10-08, freeware [17]. The official site failed its HTTPS check on 2026-11-02. | ❌ a flowchart tool, weakest evidence |

**Why these three.** Each of the three dominates a large group of
students: Portugol in Portuguese, PSeInt in Spanish, and CLRS in English
algorithms courses. The first two have keywords in the student's own
language and an interpreter. CLRS is the notation most students meet
later, in the algorithms course, so it shows what "pseudocode" means in
English-language textbooks.

**Limits of the evidence.** The numbers measure different things
(downloads, copies sold, syllabi) and cannot be compared with each other.
Downloads are not students: one student may download a tool more than
once, and a lab may install it once for many students. The ranking is
therefore by evidence of use in university intro courses within each
language community, not a single global count.

## History
- **Pseudocode in textbooks.** CLRS's first edition appeared in 1990; the
  book started from MIT course 6.046 [13]. Its pseudocode is a notation
  for describing algorithms independently of any language, typeset with
  the authors' own LaTeX package [14].
- **Portugol** is a family of pseudocode dialects with Portuguese
  keywords. It "tem
  diversas variações em sintaxe" ("has several syntax variations") [18].
  VisuAlg 3.0, by Antonio Carlos Nicolodi, is a Windows editor and
  interpreter for one of them [6]. Portugol Studio was developed by the
  LITE lab at UNIVALI [19], used there from 2011 [3].
- **PSeInt** ("PSeudo Intérprete") is by Pablo Novara, a graduate and
  lecturer of Computer Engineering at FICH, Universidad Nacional del
  Litoral, Argentina [10]. Its SourceForge project was registered on
  2004-11-28 [12].

## Milestones
| Year | Milestone | Source |
|---|---|---|
| 1990 | First edition of *Introduction to Algorithms* (CLRS) | [13] |
| 2004 | PSeInt project registered on SourceForge (2004-11-28) | [12] |
| 2011 | First version of Portugol Studio used at UNIVALI | [3] |
| 2015 | PSeInt named SourceForge "Community Choice" Project of the Month (September) | [10] |
| 2015 | Flowgorithm paper at the ASEE Pacific Southwest Conference | [16] |
| 2019 | VisuAlg 3.0.7.0 released (2019-03-21) | [6] |
| 2020 | Portugol Studio 2.7.5, its latest release (2020-11-27) | [5] |
| 2022 | CLRS 4th edition; the book passes 1 million copies | [13] |
| 2024 | Cambridge International publishes its 2027–2029 Pseudocode Guide | [15] |
| 2025 | PSeInt release 20250314 | [9] |

## Market usage today
"Market" here means classrooms. See [Ranking evidence](#ranking-evidence)
for the numbers, each with its date and source. In short (all read
2026-11-02 unless stated): PSeInt 16.7 million SourceForge downloads,
mostly Latin America [11]; VisuAlg 3.0 about 3.0 million, 90% from
Brazil [4]; Portugol Studio about 960,000 GitHub release downloads [5];
CLRS over 1 million copies sold (2022) [13].

## Critical views from teachers and specialists
Quotations are copied word for word. The English renderings of the
Portuguese and Spanish quotations are this repository's own translations.

**Against, or with reservations**
- **No feedback, and a hard transition.** Barbosa, Couto and Terra
  (Universidade Federal de Lavras, 2016) [18]:
  > "Apesar de trazer benefícios inquestionáveis no aprendizado de Lógica
  > de Programação e Algoritmos, o Portugol não provê, por definição, uma
  > forma de executar o pseudocódigo escrito para que alunos possam testar
  > seus algoritmos, o que se torna indispensável à medida que os
  > algoritmos se tornam mais complexos e passam a requerer códigos mais
  > elaborados."

  ("Despite bringing unquestionable benefits to learning programming
  logic and algorithms, Portugol does not, by definition, provide a way to
  execute the written pseudocode so students can test their algorithms,
  which becomes indispensable as algorithms grow more complex.")
  > "Assim, devido à origem sintática de Portugol, estudantes não terão
  > uma transição natural ao aprender linguagens de programação do
  > estado-da-prática como C ANSI e Java."

  ("Thus, because of Portugol's syntactic origin, students will not have
  a natural transition when they learn state-of-practice languages such
  as ANSI C and Java.")
- **Too detailed.** Ramon Mayor Martins (Instituto Federal de Santa
  Catarina, 2025) [20]:
  > "No entanto, apesar de já muito experimentadas por décadas,
  > ferramentas tradicionais como Portugol ou Algol podem ser
  > excessivamente detalhadas e perder o foco no ensino da própria lógica
  > de programação."

  ("However, although they have been tried for decades, traditional tools
  such as Portugol or Algol can be excessively detailed and lose focus on
  teaching programming logic itself.")
- **Ambiguity in exams.** Cutts, Connor, Donaldson and Michaelson
  (Universities of Glasgow, Strathclyde and Heriot-Watt, 2014) [21]:
  > "This paper argues that the "institutionalised understanding" of
  > pseudo-code as a blend of formal and natural languages makes it an
  > unsuitable choice for national assessment where the intention is to
  > test program comprehension skills. It permits question-setters to
  > inadvertently introduce a level of ambiguity and consequent
  > confusion."
- **Localized languages rarely spread.** Philip Guo (UC San Diego, 2018)
  [22]:
  > "There have been attempts to create programming languages with
  > non-English keywords [80], but so far none have been widely adopted
  > [77]."

**In favor**
- **Native-language keywords.** Noschang, Pelz, de Jesus and Raabe
  (UNIVALI, 2014) [2]:
  > "Entre as vantagens da utilização do Portugol com alunos iniciantes
  > estão a simplicidade da linguagem e o fato das palavras-chave e
  > comandos estarem em português, evitando os problemas com o idioma
  > inglês."

  ("Among the advantages of using Portugol with beginners are the
  simplicity of the language and the fact that keywords and commands are
  in Portuguese, avoiding problems with the English language.")
  Guo's study of non-native English speakers names the same barrier:
  "A common root cause is that programming language keywords (such as
  "while") are in English" [22]. Felienne Hermans (Vrije Universiteit
  Amsterdam, 2024) says issues of existing tools "disproportionally affect
  underrepresented minorities in programming including girls, kids with
  disabilities and non-English learners" [23]; her answer, Hedy, is a
  real, runnable gradual language rather than pseudocode.
- **Focus on concepts, not syntax.** PSeInt's own site says its "simple e
  intuitivo pseudolenguaje en español" ("simple and intuitive
  pseudo-language in Spanish") lets the student "centrar su atención en
  los conceptos fundamentales de la algoritmia computacional, minimizando
  las dificultades propias de un lenguaje" ("focus on the fundamental
  concepts of computational algorithmics, minimizing the difficulties of
  a language") [9]. This is the tool author's claim, not a study.
- **Exam boards still use it, loosely.** AQA (GCSE Computer Science,
  England) [24]:
  > "Students do not have to use this style of pseudo-code in their own
  > work or written assessments, although they are free to do so. The
  > only direction to students when answering questions or describing
  > algorithms written in pseudo-code is that their code is clear,
  > consistent and unambiguous."

**Recent studies: pseudocode and AI code generators**
- Denny, Prather, Becker et al. (2023, published in *Communications of the
  ACM* 2024) [25]:
  > "Novices may be able to generate code by communicating natural
  > language descriptions to the models, but natural language is ambiguous
  > and the ability to read and comprehend code is arguably more important
  > now than ever."
- Kazemitabaar et al. (University of Toronto and others, 2023) watched
  novices use a code generator based on a large language model (LLM) in
  a CS1 setting [26]:
  > "Compared to other learners who simply prompted the behavior (e.g.,
  > "find the largest number"), such usages of pseudocode indicate a
  > deeper algorithmic thinking."
- Nguyen et al. (CHI 2024) found that beginners "struggle with writing and
  editing prompts, even for problems at their skill level and when
  correctness is automatically determined" [27].

**Summary of the debate.** The critics agree on three weak points:
pseudocode on paper gives no feedback, its syntax is not standard, and
the jump to a real language is not free. Interpreters such as PSeInt,
VisuAlg and Delégua answer the first point, which is why two of the three
variants here run. The supporters stress native-language keywords and a
focus on logic. The recent AI studies add a new argument for the skill
behind pseudocode: stating an algorithm precisely, step by step, is what
beginners need to direct and check an AI code generator [25][26][27].

## Importance then and now
- **Then:** pseudocode let teachers present algorithms before, or without,
  a programming language, and let textbooks such as CLRS describe
  algorithms independently of any language [13][14]. In Brazil some CS1
  courses still teach no language at first, only pseudocode [1].
- **Now:** the native-language dialects are still downloaded in large numbers (2026
  figures above) [4][5][11]. Their tools are aging, though: VisuAlg's last
  release is from 2019 and Portugol Studio's from 2020 [5][6], while
  PSeInt is still released [9], and newer runners such as Delégua
  exist [7].

## Comparing the variants
The same program in the three styles:

| Portugol (VisuAlg) | PSeInt | CLRS-style |
|---|---|---|
| `algoritmo "OlaMundo"` | `Algoritmo HolaMundo` | `HELLO-WORLD()` |
| `var` | | |
| `inicio` | | |
| `   escreval("Hello, World!")` | `    Escribir "Hello, World!";` | `1  print "Hello, World!"` |
| `fimalgoritmo` | `FinAlgoritmo` | |

- **Keywords** are in Portuguese, Spanish, or English.
- **Blocks:** VisuAlg and PSeInt close blocks with keywords
  (`fimalgoritmo`, `FinAlgoritmo`), like Pascal; CLRS has no end
  keywords and shows the body of a block by its indentation level, like
  Python [29].
- **Declarations:** VisuAlg has a `var` section before `inicio`, like
  Pascal. In PSeInt it depends on the school's profile: 30 of the 467
  profiles in release 20250314 set `force_define_vars=1` (counted
  2026-11-02). CLRS does not declare types.
- **Running:** the first two have interpreters; CLRS is only read.

Each folder's README walks through its file line by line.

## Why there is no desktop or web version
Pseudocode is a teaching notation, not a platform for applications. The
two interpreters only read and write text in a console window [8][9];
they have no graphical user interface (GUI) or HTTP library, so a desktop window or a web server cannot
be written *in* pseudocode. (The PSeInt and Portugol Studio editors are
desktop programs, but they are the tool, not the student's program.)

## What could not be verified
Dropped from this page because no readable primary source was found
(checked 2026-11-02): who wrote the first VisuAlg versions; PSeInt's first
release date; the number of universities that adopt CLRS; download or
adoption numbers for Flowgorithm and Cambridge pseudocode; a peer-reviewed
count of Latin American universities that use PSeInt.

## Sources
1. da Silva, E. P.; Caceffo, R. E.; de Azevedo, R. J. "Análise dos Tópicos Mais Abordados em Disciplinas de Introdução à Programação em Universidades Federais Brasileiras" (Analysis of the topics most covered in introductory programming courses at Brazilian federal universities). EDUCOMP 2022. SBC OpenLib. <https://sol.sbc.org.br/index.php/educomp/article/download/19196/19025> (accessed 2026-11-02)
2. Noschang, L. F.; Pelz, F.; de Jesus, E. A.; Raabe, A. L. A. "Portugol Studio: Uma IDE para Iniciantes em Programação" (Portugol Studio: an IDE for programming beginners). WEI/CSBC 2014. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/10954/10824> (accessed 2026-11-02)
3. Esteves, A. M. S.; Noschang, L. F.; Raabe, A. L. A.; Haendchen Filho, A. "Portugol Studio: Em direção a uma comunidade aberta para pesquisa sobre o aprendizado de programação" (Portugol Studio: toward an open community for research on programming learning). WEI 2019. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/6656/6552> (accessed 2026-11-02)
4. VisuAlg 3.0 download statistics. SourceForge. <https://sourceforge.net/projects/visualg30/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (accessed 2026-11-02)
5. Portugol Studio releases. UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio/releases> (accessed 2026-11-02)
6. VisuAlg 3.0. SourceForge. <https://sourceforge.net/projects/visualg30/> (accessed 2026-11-02)
7. Delégua. Design Líquido, GitHub. <https://github.com/DesignLiquido/delegua> (accessed 2026-11-02)
8. @designliquido/visualg (npm package). npm. <https://www.npmjs.com/package/@designliquido/visualg> (accessed 2026-11-02)
9. PSeInt (home page). <https://pseint.sourceforge.net/> (accessed 2026-11-02)
10. "Premian a docente de la FICH por un desarrollo de software libre" (A FICH lecturer is honored for a free-software development). Universidad Nacional del Litoral, 2015-09-03. <https://www.unl.edu.ar/noticias/news/view/premian_a_docente_de_la_fich_por_un_desarrollo_de_software_libre_1> (accessed 2026-11-02)
11. PSeInt download statistics. SourceForge. <https://sourceforge.net/projects/pseint/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (accessed 2026-11-02)
12. PSeInt project page. SourceForge. <https://sourceforge.net/projects/pseint/> (accessed 2026-11-02)
13. Q&A: What makes a bestselling textbook? (Introduction to Algorithms). MIT News, 2022-02-23. <https://news.mit.edu/2022/qa-what-makes-bestselling-textbook-introduction-algorithms-0223> (accessed 2026-11-02)
14. Cormen, T. H. `clrscode`: LaTeX package for CLRS pseudocode. Dartmouth College. <https://web.archive.org/web/20250210061943/https://www.cs.dartmouth.edu/~thc/clrscode/> (accessed 2026-11-02)
15. 2027 - 2029 Pseudocode Guide (AS & A Level Computer Science 9618). Cambridge University Press & Assessment, 2024. <https://www.cambridgeinternational.org/Images/721401-2027-2029-pseudocode-guide.pdf> (accessed 2026-11-02)
16. Cook, D. D. Flowgorithm: Principles for Teaching Introductory Programming Using Flowcharts. ASEE Pacific Southwest Conference 2015. <https://peer.asee.org/54443.pdf> (accessed 2026-11-02)
17. DevinCook.Flowgorithm 4.5.0 manifest. microsoft/winget-pkgs, GitHub. <https://github.com/microsoft/winget-pkgs/tree/master/manifests/d/DevinCook/Flowgorithm/4.5.0> (accessed 2026-11-02)
18. Barbosa, Couto, and Terra. "PortuCol: uma pseudo linguagem inspirada em C ANSI para o Ensino de Lógica de Programação e Algoritmos" (PortuCol: a pseudo-language inspired by ANSI C for teaching programming logic and algorithms). WEI 2016. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/9678/9579> (accessed 2026-11-02)
19. Portugol Studio (repository README). UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio> (accessed 2026-11-02)
20. Martins, R. M. "PseudocodeLab: Uma Ferramenta Educacional Open Source e Gentil para o Ensino de Programação com Pseudocódigos" (PseudocodeLab: a gentle open-source educational tool for teaching programming with pseudocode). EduComp 2025 (extended). SBC OpenLib. <https://sol.sbc.org.br/index.php/educomp_estendido/article/view/34912> (accessed 2026-11-02)
21. Cutts, Q.; Connor, R.; Donaldson, P.; Michaelson, G. Code or (not Code) – Separating Formal and Natural Language in CS Education. WiPSCE '14, ACM. <https://www.macs.hw.ac.uk/~greg/publications/ccdm.WIPSCE14.pdf> (accessed 2026-11-02)
22. Guo, P. J. Non-Native English Speakers Learning Computer Programming: Barriers, Desires, and Design Opportunities. CHI 2018, ACM. <https://pg.ucsd.edu/publications/non-native-english-speakers-learning-programming_CHI-2018.pdf> (accessed 2026-11-02)
23. Hermans, F. Hedy: An Inclusive, Multi-Lingual, and Gradual Programming Language (Invited Talk). ICPEC 2024, OASIcs vol. 122. <https://drops.dagstuhl.de/entities/document/10.4230/OASIcs.ICPEC.2024.1> (accessed 2026-11-02)
24. Notes and guidance: Pseudo-code. GCSE Computer Science 8525. AQA. <https://filestore.aqa.org.uk/resources/computing/AQA-8525-NG-PC.PDF> (accessed 2026-11-02)
25. Denny, P.; Prather, J.; Becker, B. A. et al. Computing Education in the Era of Generative AI. arXiv 2306.02608 (Communications of the ACM 67(2), 2024). <https://arxiv.org/pdf/2306.02608v1> (accessed 2026-11-02)
26. Kazemitabaar, M. et al. How Novices Use LLM-Based Code Generators to Solve CS1 Coding Tasks in a Self-Paced Learning Environment. Koli Calling 2023. arXiv 2309.14049. <https://arxiv.org/pdf/2309.14049> (accessed 2026-11-02)
27. Nguyen, S. et al. How Beginning Programmers and Code LLMs (Mis)read Each Other. CHI 2024. arXiv 2401.15232. <https://arxiv.org/abs/2401.15232v2> (accessed 2026-11-02)
28. "Perfiles" (Profiles). PSeInt. <https://pseint.sourceforge.net/index.php?page=perfiles.php> (accessed 2026-11-02)
29. Cormen, T. H. Using the clrscode3e Package in LaTeX 2e (manual). Dartmouth College. <https://web.archive.org/web/20250328084750/https://www.cs.dartmouth.edu/~thc/clrscode/clrscode3e.pdf> (accessed 2026-11-02)
