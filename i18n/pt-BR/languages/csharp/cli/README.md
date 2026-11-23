---
source: languages/csharp/cli/README.md
source_sha: 53c291fea8c1f90b96cde082d8a7c8905e92f8c6
---
# C# · cli: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C#](../README.md)

## O que é
Um programa de linha de comando que imprime exatamente `Hello, World!` e
termina. São uma linha de C# em `Program.cs`, mais o arquivo de projeto
`hello-cli.csproj`, compilados com o **.NET 10 SDK**, a versão atual de
suporte de longo prazo (*Long Term Support*, LTS) do .NET [1].

Como o [Java](../../java/cli/), o C# é compilado para uma linguagem
intermediária (IL), e não para código de máquina. O runtime do .NET a
transforma em código de máquina enquanto o programa executa. O programa usa
um recurso mais recente do C#, as *instruções de nível superior*
(*top-level statements*); por isso, não tem classe nem método `Main`. Os
comentários de `Program.cs` mostram a forma clássica, que é quase igual à
versão em Java.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| .NET SDK 10 | 10.0.404 (runtime 10.0.15), instalado com `dotnet-install.sh` em `~/.dotnet` | o compilador C#, o MSBuild, o runtime do .NET e a biblioteca de classes base (`Console`) |
| `curl` e `bash` | versões do sistema | somente se o `install.sh` precisar baixar o SDK |

## Início rápido
```sh
./install.sh   # check for the .NET 10 SDK (asks before installing)
./build.sh     # compile into bin/Release/net10.0/hello-cli.dll
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `dotnet --list-sdks` em busca de um SDK de versão 10 ou posterior. Se nenhum for encontrado, no macOS/Linux oferece o `dotnet-install.sh --channel 10.0` da Microsoft (em `~/.dotnet`, sem `sudo`) e confere o resumo SHA-256 do script antes de executá-lo; no Windows, imprime o comando `winget`. Nada é executado sem o `y` do usuário. | Um único pacote, o SDK, contém tudo de que um programa C# precisa. |
| `build.sh` | Executa `dotnet build -c Release --disable-build-servers` e imprime o comando. | Restaura o projeto e depois compila `Program.cs` para IL em `bin/Release/net10.0/hello-cli.dll`. |
| `run.sh` | Executa `dotnet bin/Release/net10.0/hello-cli.dll`. `--verify` faz o mesmo (um programa CLI termina sozinho). | O `.dll` contém IL; assim, o runtime do .NET precisa carregá-lo, compilá-lo para código de máquina enquanto o programa executa (compilação JIT) e executá-lo. |

**Como o SDK é instalado.** Os scripts `dotnet-install` da Microsoft
"perform a non-admin installation of the .NET SDK" (tradução livre:
"realizam uma instalação do SDK do .NET sem privilégios de administrador") e,
por padrão, instalam em "*$HOME/.dotnet* on Linux/macOS" [2] (tradução livre:
"*$HOME/.dotnet* no Linux/macOS"). `--channel 10.0` escolhe o SDK mais recente
do .NET 10; `--channel LTS` escolheria a versão LTS mais recente, que era a
mesma versão em 2026-11-01 [2]. Os scripts não alteram o `PATH` nem definem
`DOTNET_ROOT` [2]. É por isso que cada script aqui adiciona `~/.dotnet` ao
`PATH` quando o `dotnet` ainda não está nele.

**Como o script é verificado.** O `install.sh` compara o `dotnet-install.sh`
baixado com o resumo em `DOTNET_INSTALL_SHA256`: a saída de `shasum -a 256`
sobre o script baixado de <https://dot.net/v1/dotnet-install.sh> em 2026-11-10
e novamente em 2026-11-19. Se a Microsoft alterar o script, o `install.sh` para
com uma divergência de checksum; verifique o novo script e, em seguida,
atualize o valor.

A Microsoft adverte: "The intended use of the scripts is for
Continuous Integration (CI) scenarios" e "To set up a development
environment or to run apps, use the installers rather than these
scripts" [2] (tradução livre: "O uso previsto dos scripts é para cenários de
integração contínua (CI)" e "Para configurar um ambiente de desenvolvimento
ou executar aplicações, use os instaladores em vez desses scripts"). O
instalador para macOS é um arquivo `.pkg` (também disponível como
`brew install --cask dotnet-sdk` [3]). Ele instala na pasta de todo o
sistema `/usr/local/share/dotnet` [3]. A regra deste repositório é que os
scripts nunca executam `sudo` nem instalam algo para todo o sistema sem
perguntar. A fórmula `dotnet` do Homebrew não tem compilação pronta para
Macs Intel; ela compilaria o .NET a partir do código-fonte [4]. Por essas
razões, o `install.sh` oferece o script. Quem preferir o instalador deve
instalá-lo antes; o `install.sh` então encontra o `dotnet` no `PATH` e o
utiliza.

**O que `dotnet build` produz.** "The binaries include the project's code
in Intermediate Language (IL) files with a *.dll* extension" (tradução livre:
"Os binários incluem o código do projeto em arquivos de linguagem
intermediária (IL) com a extensão *.dll*"), e a pasta de saída padrão é
`./bin/<configuration>/<framework>/` [5]. O `dotnet build` também restaura
antes as dependências do projeto [5]. Este projeto não tem nenhuma.
`-c Release` compila com otimizações. `--disable-build-servers` "forces the
command to ignore any persistent build servers" [5] (tradução livre: "força o
comando a ignorar quaisquer servidores de build persistentes"). Esses são
processos do MSBuild e do compilador que o `dotnet` mantém em execução após um
build, para acelerar o build seguinte (`dotnet build-server shutdown` os
encerra [16]). Com a opção, o script não deixa processos em segundo plano.

**O que `dotnet <arquivo>.dll` faz.** O comando `dotnet` é "the generic
driver for the .NET CLI" (tradução livre: "o driver genérico da CLI do
.NET"). Quando recebe "the path to an application `.dll` file" (tradução
livre: "o caminho de um arquivo `.dll` de aplicação"), ele executa a
aplicação [6]. "At execution time, a just-in-time (JIT) compiler translates
the CIL into native code" [7] (tradução livre: "Em tempo de execução, um
compilador just-in-time (JIT) traduz a CIL em código nativo"). CIL (*Common
Intermediate Language*) é outro nome para IL.

**Telemetria.** "The .NET SDK telemetry feature is enabled by default for
Microsoft distributions of the SDK. To opt out of the telemetry feature,
set the `DOTNET_CLI_TELEMETRY_OPTOUT` environment variable to `1` or
`true`" [8] (tradução livre: "O recurso de telemetria do SDK do .NET é
ativado por padrão nas distribuições do SDK da Microsoft. Para desativá-lo,
defina a variável de ambiente `DOTNET_CLI_TELEMETRY_OPTOUT` como `1` ou
`true`"). Os três scripts a definem e também definem `DOTNET_NOLOGO`, que
oculta a mensagem de boas-vindas da primeira execução [9].

## Estrutura de pastas
```text
cli/
├── README.md          this file
├── install.sh         checks / installs the .NET SDK
├── build.sh           compiles with dotnet build
├── run.sh             runs the .dll with dotnet
├── hello-cli.csproj   the project file (MSBuild)
├── Program.cs         the program
├── obj/               created by build.sh (restore and intermediate files); not committed
└── bin/Release/net10.0/   created by build.sh; not committed
    ├── hello-cli.dll                the program, as IL
    ├── hello-cli                    a native launcher (apphost) for the .dll
    ├── hello-cli.runtimeconfig.json which .NET runtime version to load
    ├── hello-cli.deps.json          the program's dependencies
    └── hello-cli.pdb                debug symbols
```
- **Uma pasta, um arquivo de projeto.** Este é o layout que `dotnet new
  console` cria: um `.csproj` e um `Program.cs` que "uses top-level
  statements by default" [10] (tradução livre: "usa instruções de nível
  superior por padrão"). Por padrão, o compilador compila todos os arquivos
  `.cs` da pasta; assim, o arquivo de projeto não precisa de uma lista de
  arquivos-fonte [11].
- `bin/` e `obj/` são saída da compilação. O `.gitignore` da raiz os ignora.

## Passo a passo
Abra [`Program.cs`](Program.cs) e [`hello-cli.csproj`](hello-cli.csproj).

1. **O arquivo de projeto.** `<Project Sdk="Microsoft.NET.Sdk">` seleciona as
   regras de build do SDK do .NET. `<OutputType>Exe</OutputType>` gera um
   programa em vez de uma biblioteca. `<TargetFramework>net10.0</TargetFramework>`
   tem como alvo o .NET 10. Compare com o `pom.xml` do Java em
   [../../java/cli](../../java/cli/) e com o `CMakeLists.txt` em
   [../../cpp/cli](../../cpp/cli/): aqui, os valores padrão fazem a maior
   parte do trabalho.
2. **Uma instrução, nenhuma classe.** "By using top-level statements, you can
   write executable code directly at the root of a file" [10] (tradução
   livre: "Ao usar instruções de nível superior, é possível escrever código
   executável diretamente na raiz de um arquivo"). O compilador gera a classe
   e o método `Main`. Antes do C# 9 (lançado em novembro de 2020 [12]), todo
   programa C# precisava deles. O comentário no topo de `Program.cs` mostra
   essa forma, que lembra o `public static void main` do Java.
3. **Sem `using System;`.** `Console` está no espaço de nomes (namespace) `System`.
   "Starting in .NET 6, implicit `global using` directives are added to new
   C# projects" (tradução livre: "A partir do .NET 6, diretivas `global using`
   implícitas são adicionadas aos novos projetos C#"), e elas são gravadas "to
   a generated file in the project's *obj* directory" [11] (tradução livre:
   "em um arquivo gerado no diretório *obj* do projeto").
   `<ImplicitUsings>enable</ImplicitUsings>` ativa esse recurso. Após um
   build, `obj/Release/net10.0/hello-cli.GlobalUsings.g.cs` contém
   `global using System;` e mais seis espaços de nomes.
4. **`Console.WriteLine("Hello, World!");`** chama um método *estático* da
   classe `Console`, sem criar antes um objeto, como o `System.out.println`
   do Java. `WriteLine` acrescenta a quebra de linha por conta própria; assim,
   não há `\n` como no `printf` do C ou no `std::cout` do C++.
5. **O tamanho do resultado.** `hello-cli.dll` tem 4.608 bytes na máquina de
   desenvolvimento. Ele contém apenas a IL deste programa; `Console` fica nas
   bibliotecas do próprio runtime do .NET. O iniciador nativo `hello-cli`
   (88.024 bytes) é usado quando o programa é executado sem o comando
   `dotnet`. Ele procura o .NET por meio de `DOTNET_ROOT` e no local padrão,
   `/usr/local/share/dotnet` no macOS [9]; por isso, falha com "You must
   install .NET to run this application" quando o .NET está apenas em
   `~/.dotnet` (testado na máquina de desenvolvimento). É por isso que o
   `run.sh` usa `dotnet hello-cli.dll`.

## Por que esta toolchain
- **O SDK do .NET**, publicado pela Microsoft, inclui o compilador C#, o
  mecanismo de build e o runtime em um único download; assim, nada mais é
  necessário.
- **O .NET 10** é uma versão LTS, publicada em 2025-11-11 e com suporte até
  novembro de 2028. "LTS releases get free support and patches for three
  years" e "Even numbered releases are LTS" [1] (tradução livre: "As versões
  LTS recebem suporte e correções gratuitos por três anos" e "As versões de
  número par são LTS"). Em 2026-11-01, o .NET 11 ainda não havia sido
  lançado (estava na release candidate 3 em 2026-10-25) [1]. O .NET 10 vem
  com o C# 14 [13].
- **A CLI `dotnet` em vez de uma IDE.** Os mesmos comandos funcionam em todos
  os sistemas operacionais e em scripts. O Visual Studio, o Rider e o VS Code
  chamam o mesmo SDK.

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-20) | .NET SDK 10.0.404 (x64) pelo `dotnet-install.sh` em `~/.dotnet`. As versões do macOS com suporte para o .NET 10 são 14, 15 e 26 [14]. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o script escolhe o SDK Arm64. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o `dotnet-install.sh` da Microsoft (canal 10.0) em `~/.dotnet` quando nenhum SDK do .NET 10 é encontrado [2]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o SDK: se nenhum SDK do .NET 10 é encontrado, ele imprime `winget install --id Microsoft.DotNet.SDK.10 -e` e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run the program
    WHY: 'dotnet' starts the .NET runtime, which JIT-compiles the IL in the .dll and runs it.
Hello, World!
```
O programa em si imprime apenas a última linha; as demais linhas vêm de
`run.sh`.

## Fontes
1. .NET and .NET Core official support policy (release dates, LTS/STS, .NET 11 RC3). Microsoft. <https://dotnet.microsoft.com/platform/support/policy/dotnet-core> (acessado em 2026-11-01)
2. `dotnet-install` scripts reference. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-install-script> (acessado em 2026-11-01)
3. `dotnet-sdk` (Homebrew cask: .pkg installer, `/usr/local/share/dotnet`). Homebrew. <https://formulae.brew.sh/cask/dotnet-sdk> (acessado em 2026-11-01)
4. `dotnet` (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/dotnet> (acessado em 2026-11-01)
5. `dotnet build` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build> (acessado em 2026-11-01)
6. `dotnet` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet> (acessado em 2026-11-01)
7. Managed execution process. Microsoft Learn. <https://learn.microsoft.com/dotnet/standard/managed-execution-process> (acessado em 2026-11-01)
8. .NET SDK and .NET CLI telemetry. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/telemetry> (acessado em 2026-11-01)
9. .NET environment variables (DOTNET_NOLOGO, DOTNET_ROOT). Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-environment-variables> (acessado em 2026-11-01)
10. Top-level statements - programs without Main methods. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/fundamentals/program-structure/top-level-statements> (acessado em 2026-11-01)
11. .NET project SDK overview (implicit using directives, default includes). Microsoft Learn. <https://learn.microsoft.com/dotnet/core/project-sdk/overview> (acessado em 2026-11-01)
12. The history of C#. Microsoft Learn. <https://learn.microsoft.com/dotnet/csharp/whats-new/csharp-version-history> (acessado em 2026-11-01)
13. "What's new in .NET 10". Microsoft Learn. <https://learn.microsoft.com/dotnet/core/whats-new/dotnet-10/overview> (acessado em 2026-11-01)
14. Install .NET on macOS. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/install/macos> (acessado em 2026-11-01)
15. Install .NET on Linux. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/install/linux> (acessado em 2026-11-01)
16. `dotnet build-server` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-build-server> (acessado em 2026-11-01)
