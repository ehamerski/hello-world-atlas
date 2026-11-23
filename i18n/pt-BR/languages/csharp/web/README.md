---
source: languages/csharp/web/README.md
source_sha: 0bf4a9c191f3c985e5f7b5e0c2ce5f3837818bb5
---
# C# · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C#](../README.md)

## O que é
Um servidor web escrito em C# com o **ASP.NET Core**. Ele escuta em
`http://localhost:8080` (ou em `$PORT`) e responde a `GET /` com o HTML
`<p>Hello, World!</p>`, que um navegador exibe como **Hello, World!**

O servidor monta o HTML por conta própria; não há front-end separado.
Compare com [../web-angular](../web-angular/), em que a página é desenhada no
navegador pelo Angular e o servidor C# envia apenas JSON.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| .NET SDK 10 | 10.0.404 (runtime do ASP.NET Core 10.0.15), em `~/.dotnet` | o compilador C#, o MSBuild, o runtime do .NET e o ASP.NET Core |
| `curl` | `curl` do sistema | somente para `./run.sh --verify` e para testes manuais |

O ASP.NET Core faz parte do SDK: "`Microsoft.AspNetCore.App` is installed
when the .NET Core 3.0 or later SDK is installed" [1] (tradução livre:
"`Microsoft.AspNetCore.App` é instalado quando o SDK do .NET Core 3.0 ou
posterior é instalado"). Portanto, ao contrário do Spring Boot do Java em
[../../java/web](../../java/web/), nada é baixado.

## Início rápido
```sh
./install.sh   # check for the .NET 10 SDK (asks before installing)
./build.sh     # compile into bin/Release/net10.0/hello-web.dll
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Outra porta: `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Igual ao de [../cli](../cli/README.md#scripts-explained): verifica a existência de um .NET SDK 10 ou posterior e oferece `dotnet-install.sh` (macOS/Linux) ou `winget` (Windows). | O SDK também contém o ASP.NET Core. |
| `build.sh` | Executa `dotnet build -c Release --disable-build-servers`. | Compila `Program.cs` para IL em `bin/Release/net10.0/hello-web.dll`. |
| `run.sh` | Executa `dotnet bin/Release/net10.0/hello-web.dll`. `--verify` o inicia em segundo plano, obtém `/` uma vez com `curl` e depois o encerra (um `trap` garante que ele seja encerrado). | O programa inicia o Kestrel, o servidor web embutido no ASP.NET Core; assim, não é necessário um servidor separado. |

Os detalhes de instalação, de telemetria e de build são os mesmos de
[../cli](../cli/README.md#scripts-explained).

## Estrutura de pastas
```text
web/
├── README.md          this file
├── install.sh         checks / installs the .NET SDK
├── build.sh           compiles with dotnet build
├── run.sh             starts the server
├── screenshot.png     the page in a browser, for "Expected output" below
├── hello-web.csproj   the project file, using the Web SDK
├── Program.cs         the server
├── appsettings.json   configuration: log levels
├── obj/               created by build.sh; not committed
└── bin/Release/net10.0/   created by build.sh; not committed
```
- Este é o layout do template `dotnet new web` da Microsoft ("ASP.NET Core
  Empty") [2], sem `Properties/launchSettings.json` e
  `appsettings.Development.json`, que só importam quando a aplicação é
  executada pelo Visual Studio ou com `dotnet run`. O `run.sh` executa o
  `.dll` já compilado.
- `appsettings.json` é lido na inicialização a partir da raiz de conteúdo
  (*content root*). Ela é a pasta atual, e o log do servidor a mostra como
  `Content root path`. O `run.sh` inicia o servidor a partir desta pasta.
  `"Microsoft.AspNetCore": "Warning"` oculta as linhas de log do framework
  para cada requisição, a mesma configuração do arquivo do template [2]. O
  JSON não tem comentários; por isso, a explicação está aqui.

## Passo a passo
Abra [`Program.cs`](Program.cs) e [`hello-web.csproj`](hello-web.csproj).

1. **`<Project Sdk="Microsoft.NET.Sdk.Web">`**: a única diferença real em
   relação a [../cli](../cli/hello-cli.csproj). "Projects that target the
   `Microsoft.NET.Sdk.Web` SDK implicitly reference the
   `Microsoft.AspNetCore.App` framework" [1] (tradução livre: "Projetos que
   têm como alvo o SDK `Microsoft.NET.Sdk.Web` referenciam implicitamente o
   framework `Microsoft.AspNetCore.App`"). O Web SDK também adiciona os
   espaços de nomes do ASP.NET Core às linhas `using` implícitas (ver
   `obj/Release/net10.0/hello-web.GlobalUsings.g.cs` após um build); assim,
   `Program.cs` não precisa de nenhum `using`.
2. **`var builder = WebApplication.CreateBuilder(args);`** cria um
   construtor (*builder*) com a configuração, o log e o servidor web padrão.
   `var` permite que o compilador infira o tipo. O C# continua com tipagem
   estática, como o `auto` do C++ e o `var` do Java 10 e posteriores.
   **`var app = builder.Build();`** cria a aplicação.
3. **`app.MapGet("/", () => Results.Content("<p>Hello, World!</p>", "text/html"));`**
   associa `GET /` a uma lambda. A Microsoft escreve: "For new projects, we
   recommend using Minimal APIs" [3] (tradução livre: "Para novos projetos,
   recomendamos usar Minimal APIs"). É este estilo, sem classes de
   controlador, em oposição à classe `@RestController` em
   [../../java/web](../../java/web/). `Results.Content` "Writes the
   `content` string to the HTTP response" (tradução livre: "Escreve a string
   `content` na resposta HTTP") com o tipo de conteúdo indicado [4]. Retornar
   uma string simples também funcionaria, mas "The framework writes the
   string directly to the response" [5] (tradução livre: "O framework escreve
   a string diretamente na resposta") como `text/plain`. O navegador, então,
   mostraria as tags em vez de um parágrafo.
4. **`Environment.GetEnvironmentVariable("PORT") ?? "8080"`** lê a porta.
   `??` é o operador de coalescência nula: fornece o lado direito quando o
   lado esquerdo é `null`, isto é, quando a variável não está definida.
5. **`app.Run($"http://127.0.0.1:{port}")`** inicia o servidor nesse endereço
   e bloqueia até Ctrl+C. A documentação mostra a mesma forma,
   `app.Run("http://localhost:3000")`, em que "the app responds to port
   `3000`" [6] (tradução livre: "a aplicação responde na porta `3000`").
   `$"..."` é uma string interpolada, como as f-strings do Python.
   `127.0.0.1` significa que somente este computador pode se conectar. (A
   configuração própria do ASP.NET Core para isso é a variável
   `ASPNETCORE_URLS` [6]. Este repositório usa `PORT` em todas as pastas
   web.)
6. **Kestrel.** O `run.sh` não inicia nenhum servidor web separado: "Kestrel
   is a cross-platform web server for ASP.NET Core. Kestrel is the
   recommended server for ASP.NET Core, and it's configured by default in
   ASP.NET Core project templates" [7] (tradução livre: "O Kestrel é um
   servidor web multiplataforma para o ASP.NET Core. O Kestrel é o servidor
   recomendado para o ASP.NET Core e vem configurado por padrão nos templates
   de projeto do ASP.NET Core"). O cabeçalho de resposta `Server: Kestrel`
   abaixo o mostra.

## Por que esta toolchain
- O **ASP.NET Core** é o framework web da Microsoft para .NET: "a
  cross-platform, high-performance, open-source framework for building
  modern web apps using .NET" [8] (tradução livre: "um framework
  multiplataforma, de alto desempenho e de código aberto para criar
  aplicações web modernas usando .NET"). No Stack Overflow Developer Survey
  2026, 19,9% dos 10.281 respondentes da pergunta sobre frameworks web
  usaram o ASP.NET Core e 13,9% usaram o ASP.NET (a versão do .NET
  Framework) [9].
- As **Minimal APIs** são o estilo que a Microsoft recomenda para novos
  projetos [3] e mantêm este Hello World em cinco instruções.
- **Nenhum pacote extra**: o ASP.NET Core vem com o SDK [1], como o
  `net/http` do Go em [../../go/web](../../go/web/).

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-20) | .NET SDK 10.0.404, ASP.NET Core 10.0.15. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o `dotnet-install.sh` da Microsoft (canal 10.0) em `~/.dotnet` quando nenhum SDK do .NET 10 é encontrado [2]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o SDK: se nenhum SDK do .NET 10 é encontrado, ele imprime `winget install --id Microsoft.DotNet.SDK.10 -e` e para. |

## Saída esperada
`./run.sh --verify`:
```text
==> Start the web server on http://localhost:8080
    WHY: Kestrel, ASP.NET Core's web server, listens on 127.0.0.1 (this computer only).
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://127.0.0.1:8080
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: .../csharp/web
<p>Hello, World!</p>
info: Microsoft.Hosting.Lifetime[0]
      Application is shutting down...
```
Manualmente, com `./run.sh` em execução:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html
Date: Sun, 01 Nov 2026 11:30:08 GMT
Server: Kestrel

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-01 com o Google Chrome em modo headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Microsoft.AspNetCore.App for ASP.NET Core (shared framework). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/metapackage-app> (acessado em 2026-11-01)
2. `dotnet new web` template ("ASP.NET Core Empty"), as generated by .NET SDK 10.0.403 on the dev machine; template list: .NET default templates for `dotnet new`. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-new-sdk-templates> (acessado em 2026-11-01)
3. APIs overview (Minimal APIs and controllers). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/overview> (acessado em 2026-11-01)
4. Results.Content method. Microsoft Learn (.NET API browser). <https://learn.microsoft.com/dotnet/api/microsoft.aspnetcore.http.results.content> (acessado em 2026-11-01)
5. Create responses in Minimal API applications. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis/responses> (acessado em 2026-11-01)
6. Minimal APIs quick reference (ports, app.Run). Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/minimal-apis> (acessado em 2026-11-01)
7. Kestrel web server in ASP.NET Core. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/fundamentals/servers/kestrel> (acessado em 2026-11-01)
8. Overview of ASP.NET Core. Microsoft Learn. <https://learn.microsoft.com/aspnet/core/introduction-to-aspnet-core> (acessado em 2026-11-01)
9. 2026 Stack Overflow Developer Survey: web frameworks and technologies (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/web-framework> (acessado em 2026-11-01)
