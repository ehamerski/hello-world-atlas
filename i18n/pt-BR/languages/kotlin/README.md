---
source: languages/kotlin/README.md
source_sha: 84e43a52b3fdc3ca44bfdb4dd7c0f1823870d8cb
---
# Kotlin

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma, orientado a objetos e funcional. O FAQ do
Kotlin diz: "Kotlin has both object-oriented and functional constructs. You
can use it in both OO and FP styles, or mix elements of the two." [1]
(tradução livre: "Kotlin tem construções orientadas a objetos e funcionais.
Você pode usá-la nos estilos OO e FP, ou misturar elementos dos dois.")
Ela também é "statically typed" [1] (tradução livre: "de tipagem estática"):
o compilador verifica os tipos antes de o programa ser executado.

Veja também: [paradigmas](../../docs/paradigms.md#object-oriented) (como este
paradigma se compara aos outros) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com as
demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | JDK 21, `kotlinc` 2.4.21 | ✅ |
| desktop | [desktop/](desktop/) | Compose Multiplatform, Gradle | ✅ |
| web | [web/](web/) | Ktor (Netty), Gradle | ✅ |
| mobile (Android) | [mobile-android/](mobile-android/) | Jetpack Compose, Android Gradle plugin, emulador Android (x86_64) | ✅ |

## Histórico
A JetBrains, empresa que faz o IntelliJ IDEA, desenvolve o Kotlin [1][2]. O
FAQ do Kotlin diz: "The project started in 2010 and was open source from
very early on. The first official 1.0 release was in February 2016." [1]
(tradução livre: "O projeto começou em 2010 e teve código aberto desde muito
cedo. A primeira versão oficial 1.0 saiu em fevereiro de 2016.")

A JetBrains apresentou a linguagem em um post intitulado "Hello World",
escrito por Dmitry Jemerov: "Today at the JVM Language Summit, JetBrains is
unveiling the new project we've been working on for almost a year now. The
project is Kotlin, a new statically typed programming language for the JVM."
[2] (tradução livre: "Hoje, na JVM Language Summit, a JetBrains apresenta o
novo projeto em que trabalhamos há quase um ano. O projeto é o Kotlin, uma
nova linguagem de programação de tipagem estática para a JVM."). O post
informa o objetivo: "a language which is productive enough for today's
environment and at the same time simple enough for every programmer to
learn" (tradução livre: "uma linguagem produtiva o bastante para o ambiente
de hoje e, ao mesmo tempo, simples o bastante para que todo programador a
aprenda"), e promete que o compilador e as ferramentas seriam lançados "as
open-source under the Apache 2 license" (tradução livre: "como código aberto
sob a licença Apache 2") quando a linguagem chegasse à fase beta [2]. Ele
também diz: "since we're a development tools company, we're building
first-class IDE support for Kotlin in parallel with the language itself" [2]
(tradução livre: "como somos uma empresa de ferramentas de desenvolvimento,
estamos construindo suporte de primeira classe em IDE para o Kotlin em
paralelo com a própria linguagem").

O post da versão 1.0, de Andrey Breslav, define a linguagem como "a
pragmatic programming language for the JVM and Android that combines OO and
functional features and is focused on interoperability, safety, clarity,
and tooling support" [3] (tradução livre: "uma linguagem de programação
pragmática para a JVM e o Android, que combina recursos OO e funcionais e é
voltada a interoperabilidade, segurança, clareza e suporte de
ferramentas"). Ele acrescenta: "Being a general-purpose language, Kotlin
works everywhere where Java works: server-side applications, mobile
applications (Android), and desktop applications." [3] (tradução livre:
"Por ser uma linguagem de propósito geral, o Kotlin funciona em todo lugar
onde o Java funciona: aplicações do lado do servidor, aplicações móveis
(Android) e aplicações desktop.")

O Kotlin para a JVM "produces Java-compatible bytecode" [1] (tradução
livre: "produz bytecode compatível com Java"). É por isso que a pasta
[cli](cli/) termina com `java -jar`. O FAQ também diz que "Kotlin is 100%
interoperable with the Java programming language" [1] (tradução livre:
"Kotlin é 100% interoperável com a linguagem de programação Java"). As
pastas de [Java](../java/README.md) e estas pastas usam o mesmo JDK 21.

A mesma linguagem tem como alvo mais do que a JVM. O FAQ lista "the JVM,
Android, JavaScript, Wasm, and Native" [1] (tradução livre: "a JVM,
Android, JavaScript, Wasm e Native").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 2010 | O projeto Kotlin começa na JetBrains | [1] |
| 2011-07 | A JetBrains apresenta o Kotlin na JVM Language Summit (o endereço do post traz o mês) | [2] |
| 2016-02 | Kotlin 1.0, a primeira versão oficial | [1][3] |
| 2017-05-17 | A equipe do Android anuncia "that we are officially adding support for the Kotlin programming language" (tradução livre: "que estamos adicionando oficialmente suporte à linguagem de programação Kotlin") | [4] |
| 2019-05-07 | Google I/O 2019: "Android development will become increasingly Kotlin-first" (tradução livre: "o desenvolvimento Android será cada vez mais Kotlin-first") | [5] |
| 2026-06-03 | Kotlin 2.4.0, a linha de versões deste repositório | [6] |
| 2026-10-08 | **Kotlin 2.4.21, a versão usada neste repositório** | [6] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Stack Overflow Developer Survey 2026:** 10,8% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Kotlin (1.524 de
  14.099) [7].
- **Índice TIOBE, outubro de 2026:** Kotlin ocupa a 32ª posição, com uma
  avaliação de 0,48% [8].
- **Android (documentação do Kotlin, acessada em 2026-11-04):** "Over 50% of
  professional Android developers use Kotlin as their primary language,
  while only 30% use Java as their main language" (tradução livre: "Mais de
  50% dos desenvolvedores Android profissionais usam Kotlin como linguagem
  principal, enquanto apenas 30% usam Java como linguagem principal"), e
  "over 95% of the top thousand Android apps use Kotlin" (tradução livre:
  "mais de 95% dos mil principais aplicativos Android usam Kotlin") [9]. A
  página não informa o ano desses números. O Android Developers Blog
  informou "Over 50% of professional Android developers now use Kotlin" em
  maio de 2019 [5] (tradução livre: "Mais de 50% dos desenvolvedores
  Android profissionais agora usam Kotlin").

Os números vêm de medidas diferentes: uma pesquisa com desenvolvedores, um
índice e uma contagem de desenvolvedores e aplicativos Android. Eles não
são diretamente comparáveis.

## Importância antes e agora
- **Antes (2011):** a JetBrains buscava uma linguagem para a JVM que fosse
  "productive enough for today's environment" e "simple enough for every
  programmer to learn" [2] (tradução livre: "produtiva o bastante para o
  ambiente de hoje" e "simples o bastante para que todo programador a
  aprenda"). Na versão 1.0, em 2016, a interoperabilidade com Java era um
  foco declarado: "any Java library can be used in Kotlin, too; and vice
  versa" [3] (tradução livre: "qualquer biblioteca Java também pode ser
  usada em Kotlin, e vice-versa").
- **Android (2017–2019):** o Google adicionou suporte oficial ao Kotlin no
  Android em 2017 [4] e tornou o desenvolvimento Android Kotlin-first em
  2019 [5]. A documentação do Kotlin diz que o desenvolvimento Android é
  "Kotlin-first since Google I/O in 2019" [9] (tradução livre:
  "Kotlin-first desde a Google I/O de 2019").
- **Hoje (2026):** o Kotlin é usado por 10,8% dos respondentes do Stack
  Overflow em 2026 [7]. O framework de interface da JetBrains, o Compose
  Multiplatform, usa o Kotlin para criar "shared UIs across Android, iOS,
  desktop, and web" [10] (tradução livre: "interfaces compartilhadas entre
  Android, iOS, desktop e web"), e o Ktor é o framework da JetBrains para
  servidores e clientes em Kotlin [11]. As pastas [desktop](desktop/) e
  [web](web/) usam esses dois.
- **No ensino:** um Hello World em Kotlin é `fun main() { println("Hello,
  World!") }` [12]. Ele não precisa de classe, de `static` nem de array de
  argumentos, que o Java 21 exige (veja o [cli de Java](../java/cli/README.md#step-by-step-walkthrough)).

## Comparando as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Linhas de Kotlin (sem comentários, sem imports e sem linhas em branco) | 3 | 13 (8 são a autoverificação) | 10 |
| Biblioteca | nenhuma (`println`) | Compose Multiplatform 1.12.2 | Ktor 3.6.1 com o motor Netty |
| Ponto de entrada | `main` imprime e retorna | `main` → `application { Window { Text } }` | `main` → `embeddedServer(...).start(wait = true)` |
| Ferramenta de build | `kotlinc` | Gradle | Gradle |
| Saída da compilação (`build.sh`) | `build/hello.jar` | `build/classes/` (tarefa `classes` do Gradle) | `build/libs/hello-web-all.jar` |
| Como é executado | `java -jar` | `gradle run` | `java -jar`, atende até Ctrl+C |
| Saída | texto na saída padrão | uma janela nativa | HTML vindo do servidor |
| Instalação extra | o compilador (zip da JetBrains) | Gradle | Gradle |

O que permanece igual: toda versão da tabela é código Kotlin compilado para
bytecode da JVM e executado na JVM, e por isso toda pasta tem um `build.sh`.
Compare com as versões em [Python](../python/README.md), que não têm nenhum. O que
muda é qual código executa o laço principal. O cli executa `main` e
termina. Na versão desktop, o Compose aguarda eventos da janela até que
`exitApplication()` seja chamada. Na versão web, o Netty aguarda requisições
HTTP. O cli usa o compilador diretamente porque um único arquivo não
precisa de um projeto. As outras duas usam o Gradle porque precisam de
bibliotecas da internet, que o Gradle baixa.

## Fontes
1. Kotlin FAQ. JetBrains. <https://kotlinlang.org/docs/faq.html> (acessado em 2026-11-04)
2. Hello World. Dmitry Jemerov, The JetBrains Blog, 2011. <https://blog.jetbrains.com/kotlin/2011/07/hello-world-2/> (acessado em 2026-11-04)
3. Kotlin 1.0 Released: Pragmatic Language for the JVM and Android. Andrey Breslav, The JetBrains Blog, 2016. <https://blog.jetbrains.com/kotlin/2016/02/kotlin-1-0-released-pragmatic-language-for-jvm-and-android/> (acessado em 2026-11-04)
4. Android Announces Support for Kotlin. Android Developers Blog, 2017-05-17. <https://android-developers.googleblog.com/2017/05/android-announces-support-for-kotlin.html> (acessado em 2026-11-04)
5. Google I/O 2019: Empowering developers to build the best experiences on Android + Play. Android Developers Blog, 2019-05-07. <https://android-developers.googleblog.com/2019/05/google-io-2019-empowering-developers-to-build-experiences-on-Android-Play.html> (acessado em 2026-11-04)
6. Kotlin releases. JetBrains. <https://kotlinlang.org/docs/releases.html> (acessado em 2026-11-04)
7. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
8. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
9. Android overview. JetBrains (Kotlin documentation). <https://kotlinlang.org/docs/android-overview.html> (acessado em 2026-11-04)
10. Compose Multiplatform. JetBrains. <https://kotlinlang.org/compose-multiplatform/> (acessado em 2026-11-04)
11. Ktor. JetBrains. <https://ktor.io/> (acessado em 2026-11-04)
12. Kotlin command-line compiler. JetBrains. <https://kotlinlang.org/docs/command-line.html> (acessado em 2026-11-04)
