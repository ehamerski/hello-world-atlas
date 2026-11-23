---
source: languages/rust/README.md
source_sha: a1ccb87a0ffdd4821fbe47dfdcc5b91278691195
---
# Rust

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma, para programação de sistemas. O livro de
Rust afirma que "Rust is influenced by many programming paradigms,
including OOP" [1] (tradução livre: "O Rust é influenciado por muitos
paradigmas de programação, incluindo a programação orientada a objetos"),
e que "one significant influence is *functional programming*" [2]
(tradução livre: "uma influência significativa é a *programação
funcional*"). Sobre a questão de o Rust ser orientado a objetos, o livro
responde: "By some of these definitions Rust is object oriented but by
others it is not" [3] (tradução livre: "Segundo algumas dessas definições,
o Rust é orientado a objetos, mas segundo outras não é"): ele tem structs,
métodos e traits, mas não tem classes nem herança. Sua página inicial o
descreve como "A language empowering everyone to build reliable and
efficient software" [4] (tradução livre: "Uma linguagem que capacita todos
a construir software confiável e eficiente"). O que o distingue é a
**segurança de memória sem coletor de lixo**: o compilador verifica quem é
o dono de cada valor, e por isso até as versões [web](web/) e
[desktop](desktop/) usam empréstimo (*borrowing*, `&'static str`) e posse
(*ownership*, `move`).

Ver também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos demais) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com
as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | Cargo | ✅ |
| desktop | [desktop/](desktop/) | eframe / egui | ✅ |
| web | [web/](web/) | Axum | ✅ |

## História
O Rust começou como um projeto pessoal de Graydon Hoare. Em um ensaio de
2025, ele recorda que tudo começou "starting from my amusing frustration
with a broken elevator in 2006" (tradução livre: "a partir de minha
divertida frustração com um elevador quebrado em 2006") e que "The baby
Rust I wrote in 2006-09 had essentially no type checker at all" [5]
(tradução livre: "O Rust bebê que escrevi em 2006-09 praticamente não tinha
verificador de tipos"). Permaneceu "an unfunded solo hobby project"
(tradução livre: "um projeto solo de hobby, sem financiamento") até que
"Mozilla's decision to invest in Rust in 2009 immediately quadrupled the
size of the team" (tradução livre: "a decisão da Mozilla de investir no
Rust em 2009 quadruplicou imediatamente o tamanho da equipe"), e "Mozilla
sustained this very unusual, very improbable investment in Rust from
2009-2020" [5] (tradução livre: "a Mozilla manteve esse investimento muito
incomum e muito improvável no Rust de 2009 a 2020").

Após anos de mudanças, o **Rust 1.0** foi lançado em 2015-05-15: "a new
programming language aiming to make it easier to build reliable, efficient
systems" [6] (tradução livre: "uma nova linguagem de programação que visa
facilitar a construção de sistemas confiáveis e eficientes"). Desde então,
"Rust releases every six weeks, like clockwork" [7] (tradução livre: "o
Rust lança versões a cada seis semanas, como um relógio"). Mudanças
maiores, que poderiam quebrar código antigo, chegam em **edições**
(*editions*), nas quais cada crate opta por entrar em seu `Cargo.toml` [8]:
2018 (Rust 1.31) [9], 2021 (Rust 1.56) [10] e 2024 (Rust 1.85) [11]. Todas
as pastas deste repositório usam a edição 2024.

Em 2021, o Rust saiu da Mozilla para uma fundação independente: "Today, on
behalf of the Rust Core team, I'm excited to announce the Rust Foundation"
(tradução livre: "Hoje, em nome da equipe Rust Core, tenho a satisfação de
anunciar a Rust Foundation"), com "Founding member companies, AWS, Huawei,
Google, Microsoft, and Mozilla" [12] (tradução livre: "Empresas membros
fundadoras: AWS, Huawei, Google, Microsoft e Mozilla").

Em seguida, o Rust entrou no kernel do Linux. O Linux 6.1 trouxe "the
introduction of support for the Rust programming language" (tradução livre:
"a introdução de suporte à linguagem de programação Rust") ao kernel,
embora, no início, "No system with a production 6.1 kernel will be running
any Rust code" [13] (tradução livre: "Nenhum sistema com um kernel 6.1 de
produção executará código Rust"). Em dezembro de 2025, os desenvolvedores
do kernel concluíram que "Rust in the kernel is no longer experimental" [14]
(tradução livre: "O Rust no kernel deixou de ser experimental"); o patch
que se seguiu afirma: "the experiment is done, i.e. Rust is here to stay"
[15] (tradução livre: "o experimento terminou, isto é, o Rust veio para
ficar").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 2006 | Graydon Hoare inicia o Rust como projeto pessoal | [5] |
| 2009 | A Mozilla começa a investir no Rust | [5] |
| 2015-05-15 | **Rust 1.0**, a primeira versão estável; versões a cada seis semanas a partir de então | [6][7] |
| 2018-12-06 | Rust 1.31 e a primeira nova edição, Rust 2018 | [9] |
| 2020-05-30 | Publicação do egui 0.1.0, a biblioteca de GUI usada em [desktop/](desktop/) | [16] |
| 2021-02-08 | Fundação da Rust Foundation (AWS, Huawei, Google, Microsoft, Mozilla) | [12] |
| 2021-10-21 | Rust 1.56 e a edição Rust 2021 | [10] |
| 2022 | O Linux 6.1 é o primeiro kernel com suporte a Rust | [13] |
| 2025-02-20 | Rust 1.85 e a **edição Rust 2024** (usada aqui) | [11] |
| 2025-12 | Os desenvolvedores do kernel do Linux declaram encerrado o experimento com Rust: "Rust is here to stay" (o Rust veio para ficar) | [14][15] |
| 2026-08-20 | Rust 1.98.0 (a 1.98.1 é a versão usada na máquina de teste) | [17] |
| 2026-10-15 | Rust 1.99.1, a versão estável mais recente em 2026-10-31 | [18] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todos os anos.

- **Stack Overflow Developer Survey 2026:** 18,0% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Rust (2.542 de
  14.099) [19]. Entre os que o usaram, 67,4% querem continuar usando
  ("admired"); 26,3% de todos os respondentes querem usá-lo ("desired")
  [19]. Nessa tabela, apenas duas linguagens têm pontuação "admired"
  maior, Elm (94,1%) e Odin (82,4%), cada uma usada por menos de 0,5% dos
  respondentes [19].
- **Índice TIOBE, outubro de 2026:** o Rust ocupa a posição 10, com
  avaliação de 1,44%. Era a 16 em outubro de 2025 [20].
- **State of Rust Survey 2024** (a pesquisa do próprio projeto Rust, com
  7.310 respostas completas): "45% of respondents answered that their
  organisation makes non-trivial use of Rust" (tradução livre: "45% dos
  respondentes afirmaram que sua organização faz uso não trivial do
  Rust"), e 38% usam Rust no trabalho para a maior parte de sua
  programação [21]. A pesquisa de 2025 (7.156 respostas, publicada em
  2026-03-02) constatou que as respostas "pretty closely match the results
  of last year" [22] (tradução livre: "correspondem de perto aos
  resultados do ano passado").
- **Onde o Rust é usado** (relatos das próprias empresas, com suas datas):
  - AWS, 2022: "We use Rust to deliver services such as Amazon Simple
    Storage Service (Amazon S3), Amazon Elastic Compute Cloud (Amazon
    EC2), Amazon CloudFront, and more" [23] (tradução livre: "Usamos Rust
    para entregar serviços como o Amazon Simple Storage Service (Amazon
    S3), o Amazon Elastic Compute Cloud (Amazon EC2), o Amazon CloudFront
    e outros").
  - Cloudflare, 2022: Pingora, "a new HTTP proxy we've built in-house using
    Rust that serves over 1 trillion requests a day" [24] (tradução livre:
    "um novo proxy HTTP que construímos internamente usando Rust e que
    atende a mais de 1 trilhão de requisições por dia").
  - Google, 2024: no Android, os problemas de segurança de memória
    "accounted for 76% of Android vulnerabilities in 2019, and are
    currently 24% in 2024" (tradução livre: "respondiam por 76% das
    vulnerabilidades do Android em 2019 e hoje respondem por 24% em
    2024"), à medida que o código novo é escrito em linguagens com
    segurança de memória, como o Rust [25].

## Importância antes e agora
- **O problema que ele aborda:** "~70% of the vulnerabilities Microsoft
  assigns a CVE each year continue to be memory safety issues" (Microsoft,
  2019) [26] (tradução livre: "cerca de 70% das vulnerabilidades às quais a
  Microsoft atribui um CVE a cada ano continuam sendo problemas de
  segurança de memória"). Esses defeitos ocorrem em linguagens como C e
  C++, nas quais o programador gerencia a memória manualmente. As
  linguagens com coletor de lixo (Java, Go, Python) os evitam, mas
  acrescentam um coletor a todo programa. No Rust, a posse "enables Rust to
  make memory safety guarantees without needing a garbage collector" [28]
  (tradução livre: "permite ao Rust oferecer garantias de segurança de
  memória sem precisar de um coletor de lixo"): o compilador verifica quem
  é o dono e quem toma emprestado cada valor.
- **Antes (2015):** o Rust 1.0 prometia controle semelhante ao do C, com
  segurança verificada em tempo de compilação [6], e uma linguagem estável
  após anos de mudanças.
- **Agora:** agências de segurança o citam como linguagem com segurança de
  memória. O guia de 2023 *The Case for Memory Safe Roadmaps* (CISA, NSA,
  FBI e agências parceiras) afirma que "Memory safety vulnerabilities are
  the most prevalent type of disclosed software vulnerability" (tradução
  livre: "As vulnerabilidades de segurança de memória são o tipo mais
  prevalente de vulnerabilidade de software divulgada"), lista o Rust entre
  as linguagens com segurança de memória e observa que "Rust enforces
  correctness at compile time to prevent memory safety and concurrency
  problems at runtime" [27] (tradução livre: "O Rust impõe a correção em
  tempo de compilação para evitar problemas de segurança de memória e de
  concorrência em tempo de execução"). O Rust está no kernel do Linux para
  ficar [15] e ocupa a posição 10 no TIOBE (outubro de 2026) [20].
- **No ensino:** o Hello World é tão curto quanto o do Go (um `main`, um
  `println!`). As ideias novas aparecem assim que um programa cresce: o
  livro chama a posse de "Rust's most unique feature" [28] (tradução livre:
  "o recurso mais singular do Rust"), e as versões [web](web/) e
  [desktop](desktop/) já exigem strings emprestadas (`&'static str`) e
  closures `move`.

## Comparação entre as categorias
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Linhas de Rust (sem comentários, sem linhas em branco) | 3 | 28 (13 são a autoverificação) | 15 |
| Dependências no `Cargo.toml` | nenhuma (biblioteca padrão) | `eframe` | `axum`, `tokio` |
| Crates compilados no macOS (`cargo tree`) | 1 | 179 | 48 |
| Rust mínimo (`rust-version`) | 1.85 (edição 2024) | 1.95 (eframe 0.37) | 1.85 (edição 2024, Tokio) |
| Primeira compilação na máquina de teste (macOS Intel) | cerca de 1 s | 4 min 18 s | cerca de 40 s |
| Executável (`target/release/`) | `hello-cli`, 418 KB | `hello-desktop`, 15,1 MB | `hello-web`, 1,6 MB |
| Quem controla o laço | ninguém: `main` imprime e retorna | o laço de eventos do eframe (`run_ui_native`) | o runtime do Tokio (`#[tokio::main]`, `axum::serve`) |
| Saída | texto na saída padrão (stdout) | uma janela nativa (desenhada com wgpu/Metal) | HTML vindo do servidor |

Os tamanhos vêm de `stat` no macOS Intel com o Rust 1.98.1 (2026-10-31).
Para comparação, os mesmos três programas em [Go](../go/README.md#comparing-the-categories)
têm 2,5 MB, 34,2 MB e 13,6 MB.

O que permanece igual: toda pasta é um pacote Cargo com `Cargo.toml`,
`Cargo.lock` e `src/main.rs`, e todo `build.sh` executa
`cargo build --release --locked`. O resultado é sempre um único executável
nativo, que roda sem o Rust instalado. Compare com o
[Java](../java/README.md), que precisa de uma JVM em tempo de execução, e
com o [Python](../python/README.md), que não tem etapa de compilação.

O Rust tem uma implementação em cada uma de suas três categorias, de modo
que esta página não tem seção que explique uma categoria ausente.

## Fontes
1. The Rust Programming Language, ch. 18.1 "Characteristics of Object-Oriented Languages". The Rust Project. <https://doc.rust-lang.org/book/ch18-01-what-is-oo.html> (acessado em 2026-10-31)
2. The Rust Programming Language, ch. 13 "Functional Language Features: Iterators and Closures". The Rust Project. <https://doc.rust-lang.org/book/ch13-00-functional-features.html> (acessado em 2026-10-31)
3. The Rust Programming Language, ch. 18 "Object-Oriented Programming Features". The Rust Project. <https://doc.rust-lang.org/book/ch18-00-oop.html> (acessado em 2026-10-31)
4. Rust Programming Language (home page). The Rust Project. <https://www.rust-lang.org/> (acessado em 2026-10-31)
5. 10 Years of Stable Rust: An Infrastructure Story. Graydon Hoare, Rust Foundation, 2025-05-15. <https://rustfoundation.org/media/10-years-of-stable-rust-an-infrastructure-story/> (acessado em 2026-10-31)
6. Announcing Rust 1.0. The Rust Core Team, 2015-05-15. <https://blog.rust-lang.org/2015/05/15/Rust-1.0/> (acessado em 2026-10-31)
7. The Rust Programming Language, appendix G "How Rust is Made and Nightly Rust". The Rust Project. <https://doc.rust-lang.org/book/appendix-07-nightly-rust.html> (acessado em 2026-10-31)
8. The Rust Edition Guide: What are editions?. The Rust Project. <https://doc.rust-lang.org/edition-guide/editions/index.html> (acessado em 2026-10-31)
9. Announcing Rust 1.31 and Rust 2018. The Rust Core Team, 2018-12-06. <https://blog.rust-lang.org/2018/12/06/Rust-1.31-and-rust-2018/> (acessado em 2026-10-31)
10. Announcing Rust 1.56.0 and Rust 2021. The Rust Team, 2021-10-21. <https://blog.rust-lang.org/2021/10/21/Rust-1.56.0/> (acessado em 2026-10-31)
11. Announcing Rust 1.85.0 and Rust 2024. The Rust Release Team, 2025-02-20. <https://blog.rust-lang.org/2025/02/20/Rust-1.85.0/> (acessado em 2026-10-31)
12. Hello World! (announcing the Rust Foundation). The Rust Foundation, 2021-02-08. <https://rustfoundation.org/news/2021-02-08-hello-world/> (acessado em 2026-10-31)
13. A first look at Rust in the 6.1 kernel. Jonathan Corbet, LWN.net, 2022-10-13. <https://lwn.net/Articles/910762/> (acessado em 2026-10-31)
14. The (successful) end of the kernel Rust experiment. Jonathan Corbet, LWN.net, 2025-12-10. <https://lwn.net/Articles/1049831/> (acessado em 2026-10-31)
15. [PATCH] rust: conclude the Rust experiment. Miguel Ojeda, Linux kernel mailing list, 2025-12-12. <https://lkml.iu.edu/hypermail/linux/kernel/2512.1/06411.html> (acessado em 2026-10-31)
16. egui CHANGELOG. emilk/egui (GitHub). <https://github.com/emilk/egui/blob/main/CHANGELOG.md> (acessado em 2026-10-31)
17. Announcing Rust 1.98.0. The Rust Release Team, 2026-08-20. <https://blog.rust-lang.org/2026/08/20/Rust-1.98.0/> (acessado em 2026-10-31)
18. Announcing Rust 1.99.1. The Rust Release Team, 2026-10-15. <https://blog.rust-lang.org/2026/10/15/Rust-1.99.1/> (acessado em 2026-10-31)
19. Stack Overflow Developer Survey 2026: Technology data (programming languages; admired and desired). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
20. TIOBE Index, October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
21. 2024 State of Rust Survey Results. The Rust Survey Team, 2025-02-13. <https://blog.rust-lang.org/2025/02/13/2024-State-Of-Rust-Survey-results/> (acessado em 2026-10-31)
22. 2025 State of Rust Survey Results. The Rust Survey Team, 2026-03-02. <https://blog.rust-lang.org/2026/03/02/2025-State-Of-Rust-Survey-results> (acessado em 2026-10-31)
23. Sustainability with Rust. Shane Miller and Carl Lerche, AWS Open Source Blog, 2022-02-11. <https://aws.amazon.com/blogs/opensource/sustainability-with-rust/> (acessado em 2026-10-31)
24. How we built Pingora, the proxy that connects Cloudflare to the Internet. Cloudflare Blog, 2022-09-14. <https://blog.cloudflare.com/how-we-built-pingora-the-proxy-that-connects-cloudflare-to-the-internet/> (acessado em 2026-10-31)
25. Eliminating Memory Safety Vulnerabilities at the Source. Google Security Blog, 2024-09-25. <https://security.googleblog.com/2024/09/eliminating-memory-safety-vulnerabilities-Android.html> (acessado em 2026-10-31)
26. A proactive approach to more secure code. Microsoft Security Response Center, 2019-07-16. <https://www.microsoft.com/en-us/msrc/blog/2019/07/a-proactive-approach-to-more-secure-code> (acessado em 2026-10-31)
27. The Case for Memory Safe Roadmaps. CISA, NSA, FBI and international partners, December 2023. <https://www.cisa.gov/resources-tools/resources/case-memory-safe-roadmaps> (acessado em 2026-10-31)
28. The Rust Programming Language, ch. 4 "Understanding Ownership". The Rust Project. <https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html> (acessado em 2026-10-31)
