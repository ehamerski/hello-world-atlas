---
source: languages/csharp/README.md
source_sha: 9b56289b5fdb4673490caae83be370a958e68fbc
---
# C#

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** orientado a objetos, com recursos de outros paradigmas.
A Microsoft descreve o C# assim: "Based on object-oriented principles, it
incorporates many features from other paradigms, not least functional
programming" [1] (tradução livre: "Baseada em princípios de orientação a
objetos, ela incorpora muitos recursos de outros paradigmas, não menos a
programação funcional"). O histórico da linguagem assinala essa virada: "C#
3.0 began to lay the groundwork for turning C# into a hybrid Object-Oriented
/ Functional language" [2] (tradução livre: "O C# 3.0 começou a preparar o
terreno para transformar o C# em uma linguagem híbrida orientada a objetos /
funcional"). Os quatro programas deste repositório mostram os dois lados. A
versão [desktop](desktop/) é construída com classes (herança e `override`).
As versões [web](web/) e [web-angular](web-angular/) passam lambdas ao
framework, e o back-end retorna um `record`, um tipo que apenas carrega
dados.

Veja também: [paradigmas](../../docs/paradigms.md#object-oriented) (como
este paradigma se compara aos demais) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com as
outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | .NET 10 SDK | ✅ |
| desktop | [desktop/](desktop/) | Avalonia | ✅ |
| web | [web/](web/) | ASP.NET Core | ✅ |
| web-angular | [web-angular/](web-angular/) | API ASP.NET Core + Angular | ✅ |

Os quatro programas têm como alvo o **.NET 10** (`net10.0`), a versão atual
com suporte de longo prazo (Long Term Support) [3], e são compilados com o
comando `dotnet`. O SDK é instalado em `~/.dotnet` com o `dotnet-install.sh`
da Microsoft, sem `sudo`; o [cli/README.md](cli/README.md#scripts-explained)
explica essa escolha e a alternativa, o instalador da Microsoft.

## História
- **Anúncio (2000):** "Microsoft Corp. today announced Microsoft® C#
  ("C sharp"), a modern, object-oriented programming language" (tradução
  livre: "A Microsoft Corp. anunciou hoje o Microsoft® C# ("C sharp"), uma
  linguagem de programação moderna e orientada a objetos"), em 2000-06-26,
  como parte da plataforma .NET da Microsoft [4].
- **Projetista:** em abril de 2001, a Microsoft chamou Anders Hejlsberg de
  "the chief designer of the C# programming language" [5] (tradução livre:
  "o projetista-chefe da linguagem de programação C#").
- **C# 1.0 (2002):** "Released January 2002" (tradução livre: "Lançado em
  janeiro de 2002"). "C# version 1.0, released with Visual Studio .NET 2002,
  looked a lot like Java" [2] (tradução livre: "O C# versão 1.0, lançado com
  o Visual Studio .NET 2002, parecia muito com o Java"). A forma clássica do
  programa [cli](cli/Program.cs), mostrada em seus comentários, é quase
  igual à do [Java cli](../java/cli/).
- **Padrões:** a Ecma International publicou a ECMA-334, a especificação da
  linguagem C#, em dezembro de 2001 (1ª edição). A edição atual é a 7ª, de
  dezembro de 2023 [6]. A ISO/IEC a publicou como ISO/IEC 23270 (2003, 2006,
  2018), e a 7ª edição está incluída por referência na ISO/IEC 20619:2023
  [6].
- **Recursos funcionais (2007):** o C# 3.0, "Released November 2007"
  (tradução livre: "Lançado em novembro de 2007"), iniciou a transição para
  "a hybrid Object-Oriented / Functional language" (tradução livre: "uma
  linguagem híbrida orientada a objetos / funcional"). Seus novos recursos
  incluíam expressões lambda, variáveis locais com tipo implícito (`var`) e
  inicializadores de objeto [2]. Os três são usados nos programas deste
  repositório.
- **Código aberto e multiplataforma (2016):** o .NET Core 1.0, lançado em
  2016-06-27 [7], foi o início do .NET usado aqui.
  ".NET 5 is the next major release of .NET Core following 3.1" (tradução
  livre: "O .NET 5 é a próxima versão principal do .NET Core após a 3.1"), e
  "'Core' was dropped from the name to emphasize that this is the main
  implementation of .NET going forward" [8] (tradução livre: "'Core' foi
  removido do nome para enfatizar que esta é a implementação principal do
  .NET daqui em diante"). A Microsoft o chama de "a
  cross-platform and open-source development platform" [8] (tradução livre:
  "uma plataforma de desenvolvimento multiplataforma e de código aberto"). Os
  toolkits desktop da Microsoft, WPF e Windows Forms, ainda funcionam apenas
  no Windows (veja [desktop](desktop/README.md#what-this-is)).
- **Programas mais curtos (2020–2021):** o C# 9 (novembro de 2020)
  acrescentou instruções de nível superior (top-level statements), usadas
  por [cli](cli/), [web](web/) e pelo back-end de
  [web-angular](web-angular/). O C# 10 (novembro de 2021) acrescentou
  diretivas `global using`, a base dos "implicit usings" que todo projeto
  deste repositório ativa [2].
- **.NET 10 e C# 14 (2025):** o .NET 10 foi lançado em 2025-11-11 como uma
  versão LTS, com suporte até novembro de 2028 [3]. O C# 14 foi "Released
  November 2025" [2] (tradução livre: "Lançado em novembro de 2025") e é a
  versão que o .NET 10 usa [9].

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 2000 | A Microsoft anuncia o C# (2000-06-26) | [4] |
| 2001 | ECMA-334, 1ª edição (dezembro) | [6] |
| 2002 | C# 1.0, com o Visual Studio .NET 2002 (janeiro) | [2] |
| 2003 | ISO/IEC 23270:2003 | [6] |
| 2007 | C# 3.0: o início de "a hybrid Object-Oriented / Functional language" (tradução livre: "uma linguagem híbrida orientada a objetos / funcional") | [2] |
| 2016 | .NET Core 1.0 (2016-06-27): código aberto, multiplataforma | [7] |
| 2020 | .NET 5 (2020-11-10): "Core" removido do nome. C# 9: instruções de nível superior | [7][8][2] |
| 2021 | C# 10: diretivas `global using` | [2] |
| 2023 | ECMA-334, 7ª edição (dezembro); ISO/IEC 20619:2023 | [6] |
| 2025 | **.NET 10 LTS** (2025-11-11) e **C# 14**, usados por todas as pastas aqui | [3][2] |

O .NET 11 é esperado em seguida. Ele estava na release candidate 3 em
2026-10-25 e ainda não havia sido lançado em 2026-11-01 [3]. As versões de
numeração ímpar têm suporte padrão (Standard Term Support, STS), com dois
anos de suporte [3].

## Uso de mercado hoje
Cada número abaixo traz sua data e sua fonte. Esses números mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o C# ocupa a **5ª posição**, com uma
  avaliação de 3,79% (−3,15% em relação a um ano antes), também 5º em
  outubro de 2025 [10]. O TIOBE nomeou o C# "Programming Language of the
  Year" (Linguagem de Programação do Ano) em 2023 e 2025, prêmio concedido
  "to the programming language that has the highest rise in ratings in a
  year" [10] (tradução livre: "à linguagem de programação que tem o maior
  aumento de avaliação em um ano"). O índice do TIOBE mede a popularidade com
  base em mecanismos de busca, e não em linhas de código escritas [10].
- **Stack Overflow Developer Survey 2026:** 27,1% de todos os respondentes
  (3.826 de 14.099) disseram ter realizado trabalho extensivo de
  desenvolvimento em C# no último ano [11]. 16,5% de todos os respondentes
  querem usá-lo ("desired"), e sua pontuação "admired" é de 50,0% [12]. Entre
  os frameworks web, 19,9% de 10.281 respondentes usaram o ASP.NET Core e
  16,0% usaram o Angular [13].

## Importância antes e agora
- **Antes:** o C# era a linguagem da Microsoft para sua nova plataforma .NET
  em 2000 [4]. Sua primeira versão "looked a lot like Java" [2] (tradução
  livre: "parecia muito com o Java"), e ela foi padronizada pela Ecma cerca
  de 18 meses após o anúncio [4][6].
- **Agora:** 5º lugar no TIOBE (outubro de 2026) e linguagem do ano do TIOBE
  em 2023 e 2025 [10]. 27,1% dos respondentes do Stack Overflow de 2026 a
  usaram [11]. Desde o .NET Core, é de código aberto e funciona em Windows,
  macOS e Linux [8]. Por isso, os quatro programas deste repositório
  funcionam na máquina de desenvolvimento, um Mac.
- **No ensino:** o C# é de tipagem estática e baseado em classes, como o
  [Java](../java/README.md), e a compilação tem a mesma etapa de compilar
  para bytecode (IL aqui, bytecode lá).
  As instruções de nível superior permitem que um iniciante comece com uma
  única linha, como em [Python](../python/README.md).

## Comparação entre as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) | [web-angular](web-angular/) |
|---|---|---|---|---|
| Linhas de código (sem comentários, sem linhas em branco) | 1 | 52 de C# (9 são a autoverificação) | 5 | 6 de C# + 22 de TypeScript |
| SDK do projeto | `Microsoft.NET.Sdk` | `Microsoft.NET.Sdk` + 3 pacotes NuGet | `Microsoft.NET.Sdk.Web` | `Microsoft.NET.Sdk.Web` + um projeto npm |
| Downloads além do SDK | nenhum | Avalonia: 25 pacotes NuGet | nenhum (o ASP.NET Core acompanha o SDK) | Angular: 238 pacotes npm |
| Ponto de entrada | instrução de nível superior | `static void Main` em `class Program` | instruções de nível superior | instruções de nível superior (back-end); `bootstrapApplication` (front-end) |
| Recursos de C# mostrados | chamada de método estático | classes, herança, `override`, atributos, inicializadores de objeto, correspondência de padrões, eventos | `var`, lambdas, `??`, strings interpoladas | `record`, serialização JSON de objetos |
| Quem controla o laço | ninguém: uma instrução e depois a saída | Avalonia (`StartWithClassicDesktopLifetime`) | Kestrel (`app.Run`) | Kestrel + `ng serve` (dois processos) |
| `.dll` compilada (máquina de desenvolvimento) | 4.608 bytes | 6.656 bytes (mais cerca de 560 MB de arquivos do toolkit em `bin/`) | 5.632 bytes | 7.168 bytes (back-end) |
| Saída | texto na saída padrão | uma janela nativa | HTML sobre HTTP | JSON sobre HTTP, transformado em HTML pelo Angular no navegador |

Os scripts seguem um mesmo padrão nas quatro pastas: o `install.sh` verifica
o SDK, o `build.sh` executa `dotnet build -c Release` e o `run.sh` executa
`dotnet <program>.dll`. A pasta desktop acrescenta uma etapa `dotnet restore`
para baixar o Avalonia. A pasta web-angular acrescenta o Node.js e o
`npm ci`. A `.dll` do próprio programa permanece pequena em todas as pastas
porque as bibliotecas de runtime (e o ASP.NET Core) ficam na instalação do
.NET, e não em `bin/`. O Avalonia é a exceção: seus arquivos são copiados
para junto do programa.

O C# tem uma implementação em cada uma dessas quatro categorias.

## Fontes
1. Overview - A tour of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/tour-of-csharp/overview> (acessado em 2026-11-01)
2. The history of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/whats-new/csharp-version-history> (acessado em 2026-11-01)
3. .NET and .NET Core official support policy. Microsoft. <https://dotnet.microsoft.com/platform/support/policy/dotnet-core> (acessado em 2026-11-01)
4. Microsoft Introduces Highly Productive .NET Programming Language: C#. Microsoft News, 2000-06-26. <https://news.microsoft.com/source/2000/06/26/microsoft-introduces-highly-productive-net-programming-language-c/> (acessado em 2026-11-01)
5. Microsoft's Anders Hejlsberg Receives Prestigious Excellence in Programming Award. Microsoft News, 2001-04-11. <https://news.microsoft.com/source/2001/04/11/microsofts-anders-hejlsberg-receives-prestigious-excellence-in-programming-award/> (acessado em 2026-11-01)
6. ECMA-334: C# language specification (editions, ISO/IEC equivalents). Ecma International. <https://ecma-international.org/publications-and-standards/standards/ecma-334/> (acessado em 2026-11-01)
7. Microsoft .NET and .NET Core (lifecycle: release dates). Microsoft Learn. <https://learn.microsoft.com/lifecycle/products/microsoft-net-and-net-core> (acessado em 2026-11-01)
8. "What's new in .NET 5". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-5> (acessado em 2026-11-01)
9. "What's new in .NET 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-10/overview> (acessado em 2026-11-01)
10. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
11. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
12. 2026 Stack Overflow Developer Survey: admired and desired languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/da-language> (acessado em 2026-11-01)
13. 2026 Stack Overflow Developer Survey: web frameworks and technologies (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/web-framework> (acessado em 2026-11-01)
