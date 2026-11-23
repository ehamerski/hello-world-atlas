---
source: languages/java/README.md
source_sha: 3ad318e94afc708e8ee9a1f97eae3723ade10d9a
---
# Java

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** orientado a objetos. A Java Language Specification descreve
Java como "a general-purpose, concurrent, class-based, object-oriented
language" [1] (tradução livre: "uma linguagem de propósito geral,
concorrente, baseada em classes e orientada a objetos"). Na prática, isso
significa que todo trecho de código vive dentro de uma classe, até um
Hello World de uma linha. Versões posteriores acrescentaram recursos
funcionais, como lambdas (Java 8) [7], que a versão [desktop](desktop/)
usa uma vez.

Veja também: [paradigmas](../../docs/paradigms.md#object-oriented) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | JDK 21, Maven | ✅ |
| desktop | [desktop/](desktop/) | JavaFX, Maven | ✅ |
| desktop (variante Swing) | [desktop-swing/](desktop-swing/) | Swing (JDK), Maven | ✅ |
| web | [web/](web/) | Spring Boot, Maven | ✅ |
| web + front-end separado | [web-react/](web-react/) | API Spring Boot + React (Vite) | ✅ |

## Histórico
Java começou em 1991 na Sun Microsystems. O relato da própria Sun diz que
ela "was created as a programming tool in a small, closed-door project
initiated by Patrick Naughton, Mike Sheridan, and James Gosling of Sun in
1991" (tradução livre: "foi criada como uma ferramenta de programação em
um pequeno projeto a portas fechadas, iniciado por Patrick Naughton, Mike
Sheridan e James Gosling, da Sun, em 1991"), e que "creating a new
language wasn't even the point of 'the Green Project'" [2] (tradução
livre: "criar uma nova linguagem nem era o objetivo do 'Green Project'").
A equipe construiu um dispositivo portátil, o *7 ("StarSeven"), e "it ran
on an entirely new, processor-independent language" (tradução livre:
"ele executava uma linguagem totalmente nova, independente de
processador") escrita por Gosling: "Gosling called the new language 'Oak,'
after the tree outside his window" [2] (tradução livre: "Gosling chamou a
nova linguagem de 'Oak', em referência à árvore do lado de fora de sua
janela"). O Computer History Museum data a primeira demonstração do Oak em
1992-09-02 [3].

Java foi anunciada ao público em 1995-05-23, na SunWorld, quando a Sun e a
Netscape disseram que ela "was going to be incorporated into Netscape
Navigator" [2] (tradução livre: "seria incorporada ao Netscape
Navigator"). A Sun lançou o Java 1.0 em 1996-01-23 [4]. O white paper de
1996, de Gosling e Henry McGilton, lista os objetivos do projeto:
"Simple, Object Oriented, and Familiar", "Robust and Secure",
"Architecture Neutral and Portable", "High Performance" e "Interpreted,
Threaded, and Dynamic" [5] (tradução livre: "Simples, Orientada a Objetos
e Familiar", "Robusta e Segura", "Neutra quanto à Arquitetura e
Portável", "de Alto Desempenho" e "Interpretada, com Threads e
Dinâmica").

O código Java é compilado pelo `javac` em arquivos `.class` que contêm
"bytecodes — the machine language of the Java Virtual Machine" (tradução
livre: "bytecodes, a linguagem de máquina da Java Virtual Machine"), e o
launcher `java` os executa em uma JVM [6]. É por isso que toda pasta Java
deste repositório tem um `build.sh`, e por isso o mesmo `.jar` roda em
qualquer sistema operacional que tenha uma JVM.

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1991 | O Green Project começa na Sun (Naughton, Sheridan, Gosling) | [2] |
| 1992-09-02 | Primeira demonstração da linguagem, então chamada Oak | [3] |
| 1995-05-23 | Java é anunciada na SunWorld, para ser incluída no Netscape Navigator | [2] |
| 1996-01-23 | Java 1.0 disponível para download | [4] |
| 2004 | O J2SE 5.0 acrescenta generics, entre outros recursos | [8] |
| 2006-11 | A Sun anuncia que abrirá o código do Java sob a GPL v2 (OpenJDK) | [9] |
| 2010-01-27 | A Oracle conclui a aquisição da Sun Microsystems | [10] |
| 2014-03-18 | Java 8: expressões lambda ("Project Lambda") | [7] |
| 2017-09-21 | Java 9: o sistema de módulos | [11] |
| 2017-09 | Proposta de uma nova versão de recursos a cada seis meses, com versões periódicas de suporte de longo prazo (LTS) | [12] |
| 2018-09-25 | Java 11 | [13] |
| 2021-09-14 | Java 17 (LTS) | [14] |
| 2023-09-19 | **Java 21 (LTS), a versão usada neste repositório**: threads virtuais, record patterns, pattern matching para `switch` | [15] |
| 2025-09-16 | Java 25 (LTS): arquivos-fonte compactos e métodos `main` de instância (JEP 512) | [16][17] |
| 2026-09-15 | Java 27, a versão mais recente no momento da redação | [18] |

Hoje o OpenJDK "ships a feature release every six months according to a
strict, time-based model" [18] (tradução livre: "lança uma versão de
recursos a cada seis meses, segundo um modelo estrito, baseado em tempo").
A Oracle lista "Java SE 8, 11, 17, 21, and 25" como versões LTS, planeja
a próxima LTS para setembro de 2027 (Java 29) e dá ao Java 21 o Premier
Support até setembro de 2028 [19].

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** Java ocupa a 4ª posição, com uma
  avaliação de 8,41% (também era a 4ª um ano antes) [20].
- **Stack Overflow Developer Survey 2026:** 27,6% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Java (3.885 de
  14.099) [21]. Na pergunta sobre frameworks web, 12,8% usaram o Spring
  Boot e 41,5% usaram o React (base de 10.281 respondentes) [21].
- **Afirmação do fornecedor (Oracle, não independente):** a página de Java
  da Oracle chama Java de "the #1 programming language and development
  platform" (tradução livre: "a linguagem de programação e plataforma de
  desenvolvimento nº 1") e fala em "more than 73 billion Java Virtual
  Machines worldwide" [23] (tradução livre: "mais de 73 bilhões de Java
  Virtual Machines em todo o mundo"). Ela não informa método nem data para
  esses números, portanto são afirmações de marketing, e não medições.

## Importância antes e agora
- **Antes (década de 1990):** o white paper defendia que uma linguagem para
  computadores em rede "must be architecture neutral, portable, and
  dynamically adaptable" [5] (tradução livre: "deve ser neutra quanto à
  arquitetura, portável e dinamicamente adaptável"). Sua promessa aos
  programadores era: "Write your applications once, and you never need to
  port them--they will run without modification on multiple operating
  systems and hardware architectures" [5] (tradução livre: "Escreva suas
  aplicações uma só vez e você nunca precisará portá-las: elas serão
  executadas sem modificação em vários sistemas operacionais e
  arquiteturas de hardware"). A JVM tornou isso possível, porque os
  programas são distribuídos como bytecode, e não como código de máquina
  [6].
- **Código aberto (2006–2007):** a Sun anunciou que abriria o código de
  "its entire Java stack ... under the GNU General Public License,
  version 2" [9] (tradução livre: "toda a sua pilha Java ... sob a GNU
  General Public License, versão 2"). As versões atuais do JDK são
  desenvolvidas no projeto OpenJDK [18], e o Eclipse Temurin, o JDK usado
  aqui, é "Built on OpenJDK" [22] (tradução livre: "Construído sobre o
  OpenJDK").
- **Hoje:** Java ocupa a 4ª posição no TIOBE (outubro de 2026) e foi usada
  por 27,6% dos respondentes do Stack Overflow em 2026 [20][21]. O Spring
  Boot, o framework das versões [web](web/), é o único framework Java com
  participação de dois dígitos na pergunta sobre frameworks web dessa
  pesquisa [21].
- **No ensino:** um Hello World em Java há muito tempo exige uma classe,
  `public static void main` e `System.out`, tudo antes da primeira linha de
  saída. O próprio projeto OpenJDK tratou disso: a JEP 512 (final no
  Java 25) pretende permitir que "beginners ... write their first
  programs without needing to understand" esses recursos [17] (tradução
  livre: "iniciantes ... escrevam seus primeiros programas sem precisar
  entender"). Veja o [README do cli](cli/README.md#step-by-step-walkthrough)
  para a forma mais curta.

## Comparando as categorias
| | [cli](cli/) | [desktop](desktop/) | [desktop-swing](desktop-swing/) | [web](web/) | [web-react](web-react/) |
|---|---|---|---|---|---|
| Linhas de Java (sem comentários e sem imports) | 6 | 24 (9 são a autoverificação) | 25 (10 são a autoverificação) | 12 | 13 (+ 15 linhas de JavaScript) |
| Biblioteca | nenhuma (`System.out`) | JavaFX 21 (OpenJFX) | Swing (no JDK) | Spring Boot 4.1 (Spring MVC, Tomcat) | Spring Boot 4.1 + React 19, Vite 8 |
| Ponto de entrada | `main` imprime e retorna | `main` → `launch()` → `start(Stage)` | `main` → `invokeLater()` → constrói a janela na thread de despacho de eventos | `main` → `SpringApplication.run()` | o mesmo, mais `main.jsx` no navegador |
| Saída da compilação (`build.sh`) | `target/hello-cli.jar` | `target/hello-desktop.jar` + `target/lib/` (JavaFX) | `target/hello-swing.jar` | JAR executável com Spring e Tomcat dentro | JAR da API + `frontend/dist/` |
| Como é executado | `java -jar` | `java --module-path target/lib --add-modules javafx.controls ...` | `java -jar` | `java -jar`, atende até Ctrl+C | `java -jar` + `vite preview`, ambos até Ctrl+C |
| Saída | texto na saída padrão | uma janela nativa | uma janela nativa | HTML vindo do servidor | JSON vindo do servidor; HTML desenhado pelo React no navegador |
| Instalação extra | nenhuma | nenhuma (o Maven baixa o JavaFX) | nenhuma | nenhuma (o Maven baixa o Spring Boot) | Node.js; `npm ci` |

O que permanece igual: toda versão é um projeto Maven com o mesmo layout
`src/main/java`, compilado pelo `javac` para bytecode e executado pela
JVM, e por isso as cinco têm um `build.sh`. Compare com as versões em
[Python](../python/README.md), que não têm nenhum. O que muda é qual
código executa o laço principal. O cli executa `main` e termina. Nas
versões desktop, o JavaFX ou o Swing aguarda eventos da janela. O Swing e o
JavaFX são comparados no
[README do desktop-swing](desktop-swing/README.md#swing-or-javafx). Nas
versões web, o Tomcat aguarda requisições HTTP. No web-react, dois
programas trabalham juntos: o navegador executa o React, e o React pede
dados ao servidor Java.

As quatro categorias estão implementadas para Java, além de uma segunda
versão desktop com Swing. Por isso a página não tem uma seção "por que não
há versão <categoria>".

## Fontes
1. The Java Language Specification, Java SE 21 Edition, Chapter 1. Introduction. Oracle. <https://docs.oracle.com/javase/specs/jls/se21/html/jls-1.html> (acessado em 2026-10-31)
2. Java Technology: The Early Years. Jon Byous, Sun Microsystems, 1998 (Internet Archive copy). <https://web.archive.org/web/20051230031802/http://java.sun.com/features/1998/05/birthday.html> (acessado em 2026-10-31)
3. James Gosling. Computer History Museum. <https://computerhistory.org/profile/james-gosling/> (acessado em 2026-10-31)
4. JavaSoft Ships Java 1.0 (Sun Microsystems press release, 1996-01-23; Internet Archive copy of the tech-insider.org transcript). <https://web.archive.org/web/20221231225635/https://www.tech-insider.org/java/research/1996/0123.html> (acessado em 2026-10-31)
5. The Java Language Environment (white paper, May 1996). James Gosling and Henry McGilton, Sun Microsystems; hosted by Oracle. <https://www.oracle.com/java/technologies/language-environment.html> (acessado em 2026-10-31)
6. About the Java Technology (The Java Tutorials). Oracle. <https://docs.oracle.com/javase/tutorial/getStarted/intro/definition.html> (acessado em 2026-10-31)
7. JDK 8. OpenJDK. <https://openjdk.org/projects/jdk8/> (acessado em 2026-10-31)
8. J2SE 5.0 New Features. Oracle. <https://docs.oracle.com/javase/1.5.0/docs/relnotes/features.html> (acessado em 2026-10-31)
9. One giant leap, two small steps. Mark Reinhold (Sun Microsystems), 2006-11-12. <https://mreinhold.org/blog/one-giant-leap> (acessado em 2026-10-31)
10. Oracle Completes Acquisition of Sun (press release, 2010-01-27, SEC filing). Oracle Corporation / U.S. SEC. <https://www.sec.gov/Archives/edgar/data/1341439/000119312510015241/dex991.htm> (acessado em 2026-10-31)
11. JDK 9. OpenJDK. <https://openjdk.org/projects/jdk9/> (acessado em 2026-10-31)
12. Moving Java Forward Faster. Mark Reinhold, 2017-09-06. <https://mreinhold.org/blog/forward-faster> (acessado em 2026-10-31)
13. JDK 11. OpenJDK. <https://openjdk.org/projects/jdk/11/> (acessado em 2026-10-31)
14. JDK 17. OpenJDK. <https://openjdk.org/projects/jdk/17/> (acessado em 2026-10-31)
15. JDK 21. OpenJDK. <https://openjdk.org/projects/jdk/21/> (acessado em 2026-10-31)
16. JDK 25. OpenJDK. <https://openjdk.org/projects/jdk/25/> (acessado em 2026-10-31)
17. JEP 512: Compact Source Files and Instance Main Methods. OpenJDK. <https://openjdk.org/jeps/512> (acessado em 2026-10-31)
18. JDK Project (release list and cadence). OpenJDK. <https://openjdk.org/projects/jdk/> (acessado em 2026-10-31)
19. Oracle Java SE Support Roadmap (updated 2026-10-20). Oracle. <https://www.oracle.com/java/technologies/java-se-support-roadmap.html> (acessado em 2026-10-31)
20. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
21. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
22. Eclipse Temurin. Eclipse Adoptium. <https://adoptium.net/temurin/> (acessado em 2026-10-31)
23. Java Software. Oracle. <https://www.oracle.com/java/> (acessado em 2026-10-31)
