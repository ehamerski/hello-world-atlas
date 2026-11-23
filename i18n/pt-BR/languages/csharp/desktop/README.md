---
source: languages/csharp/desktop/README.md
source_sha: cecebf8bd5ac7f6e46d49c4eec8e7a9ecd5c9367
---
# C# · desktop: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [C#](../README.md)

## O que é
Um programa desktop que abre uma janela com o título **Hello, World!** e
mostra o texto **Hello, World!** no meio. A janela é desenhada pelo
**Avalonia**, um toolkit de interface de usuário (UI) de código aberto e
multiplataforma para .NET [1], baixado do NuGet, o registro de pacotes do
.NET.

Os toolkits desktop da própria Microsoft não cobrem as três plataformas
desktop. "WPF only runs on Windows" [2] (tradução livre: "O WPF executa
somente no Windows"). O Windows Forms "is a UI framework for building Windows
desktop apps" [3] (tradução livre: "é um framework de UI para criar
aplicações desktop para Windows"). O .NET MAUI executa "on Android, iOS,
macOS, and Windows" [4] (tradução livre: "no Android, no iOS, no macOS e no
Windows"), e o Linux não está nessa lista. O Avalonia executa no Windows, no
macOS e no Linux [1]; assim, o mesmo código compila nos três.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| .NET SDK 10 | 10.0.404 (runtime 10.0.15), em `~/.dotnet` | o compilador C#, o MSBuild, o runtime do .NET e o `dotnet restore` para os pacotes |
| Avalonia | 12.1.6 (`Avalonia`, `Avalonia.Desktop`, `Avalonia.Themes.Fluent`) | o toolkit de UI; baixado pelo `install.sh` do nuget.org |
| Acesso à internet | apenas na primeira vez | o `dotnet restore` baixa 25 pacotes (cerca de 295 MB de arquivos `.nupkg` na máquina de desenvolvimento) para `~/.nuget/packages` |

## Início rápido
```sh
./install.sh   # check for the .NET 10 SDK; download Avalonia (asks before installing the SDK)
./build.sh     # compile into bin/Release/net10.0/hello-desktop.dll
./run.sh       # open the window; close it to end the program
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica a existência de um .NET SDK 10 ou posterior, como em [../cli](../cli/README.md#scripts-explained). 2. Executa `dotnet restore` após perguntar, a menos que `obj/project.assets.json` mostre que os pacotes já foram restaurados. | O Avalonia não faz parte do .NET: "the .NET CLI uses NuGet to look for these dependencies and download them if necessary" [5] (tradução livre: "a CLI do .NET usa o NuGet para procurar essas dependências e baixá-las, se necessário"). Elas vão para "the `.nuget/packages` directory in the user's home directory" [5] (tradução livre: "o diretório `.nuget/packages` no diretório pessoal do usuário"), compartilhado por todos os projetos. |
| `build.sh` | Executa `dotnet build -c Release --disable-build-servers`. | Compila `Program.cs` para IL e copia os arquivos `.dll` e as bibliotecas nativas do Avalonia para `bin/Release/net10.0/`. |
| `run.sh` | Executa `dotnet bin/Release/net10.0/hello-desktop.dll`. `--verify` define `TF_VERIFY=1`: a aplicação imprime o texto quando a janela está aberta e fecha após cerca de 2 segundos. | O runtime do .NET executa a IL; o Avalonia abre uma janela nativa. |

**Telemetria.** Além de `DOTNET_CLI_TELEMETRY_OPTOUT` (ver
[../cli](../cli/README.md#scripts-explained)), `install.sh` e `build.sh`
definem `AVALONIA_TELEMETRY_OPTOUT=1`. Os pacotes do Avalonia trazem um
pacote chamado `Avalonia.BuildServices` (versão 11.3.2 aqui). O README dele,
em `~/.nuget/packages/avalonia.buildservices/11.3.2/README.md`, diz que
"Avalonia collects anonymous build-time usage data" (tradução livre: "O
Avalonia coleta dados anônimos de uso em tempo de compilação") e lista, por
exemplo, um nome de projeto com hash e um "Anonymous machine identifier
(GUID), and machine name (hashed)" (tradução livre: "Identificador anônimo
da máquina (GUID) e nome da máquina (com hash)"). Ele indica essa variável
como a forma de desativar a coleta [6]. Os dados são coletados apenas em
tempo de compilação, e não quando a aplicação executa [6].

## Estrutura de pastas
```text
desktop/
├── README.md              this file
├── install.sh             checks the .NET SDK; runs dotnet restore
├── build.sh               compiles with dotnet build
├── run.sh                 opens the window
├── screenshot.png         the window, for "Expected output" below
├── hello-desktop.csproj   the project file, with the Avalonia PackageReferences
├── Program.cs             the program: Main, the App class and the window
├── obj/                   created by restore/build; not committed
└── bin/Release/net10.0/   created by build.sh; not committed
    ├── hello-desktop.dll  the program, as IL
    ├── Avalonia*.dll, SkiaSharp.dll, HarfBuzzSharp.dll, ...   the toolkit
    └── runtimes/<platform>/native/   native libraries for each platform
```
- O template de aplicação do Avalonia divide uma aplicação em `Program.cs`,
  `App.axaml`, `App.axaml.cs`, `MainWindow.axaml` e `MainWindow.axaml.cs`
  [7]. "The `.axaml` extension is short for Avalonia XAML" [12] (tradução
  livre: "A extensão `.axaml` é abreviação de Avalonia XAML"), uma linguagem
  XML para descrever a UI. O Avalonia também documenta aplicações sem
  nenhum XAML: "Avalonia does not require XAML. You can build entire
  applications using only C#" [8] (tradução livre: "O Avalonia não exige
  XAML. É possível construir aplicações inteiras usando apenas C#"). Este
  programa faz isso; por isso, é um único arquivo, como
  [../../java/desktop](../../java/desktop/) e
  [../../cpp/desktop](../../cpp/desktop/).
- `bin/Release/net10.0/` tem cerca de 560 MB na máquina de desenvolvimento. O
  build copia as bibliotecas nativas de todas as plataformas que o Avalonia
  suporta (`runtimes/win-x64`, `linux-x64`, `osx`, ...), e somente as três
  pastas do Windows têm cerca de 118 MB cada. Em um Mac, apenas
  `runtimes/osx/native` é usada.
- `bin/` e `obj/` são ignorados pelo `.gitignore` da raiz.

## Passo a passo
Abra [`Program.cs`](Program.cs) e [`hello-desktop.csproj`](hello-desktop.csproj).

1. **`<PackageReference Include="Avalonia" Version="12.1.6" />`** no arquivo
   de projeto lista um pacote NuGet com uma versão exata, do mesmo modo que
   uma `<dependency>` no `pom.xml` do Maven. `Avalonia.Desktop` acrescenta os
   back-ends desktop, e `Avalonia.Themes.Fluent` acrescenta a aparência dos
   controles. `<OutputType>WinExe</OutputType>` marca um programa com GUI. No
   Windows, ele inicia sem uma janela de console.
2. **`class Program { [STAThread] static void Main(string[] args) ... }`**:
   ao contrário de [../cli](../cli/), este arquivo declara classes; por isso,
   o ponto de entrada é escrito de forma explícita: um método `static`
   chamado `Main`, como em Java. `[STAThread]` é um *atributo*, uma
   informação adicional associada ao método. Ele se destina ao código de UI do
   Windows, e o template de aplicação do Avalonia também o coloca em `Main`
   [13].
3. **`AppBuilder.Configure<App>().UsePlatformDetect().StartWithClassicDesktopLifetime(args);`**
   é o padrão de inicialização da documentação do Avalonia [9].
   `Configure<App>()` indica a classe da aplicação (`<App>` é um argumento de
   tipo genérico). `UsePlatformDetect()` escolhe o back-end do sistema
   operacional atual, e `StartWithClassicDesktopLifetime` executa o laço de
   eventos até a janela principal fechar [9]. Cada chamada devolve o
   construtor (*builder*); por isso, as chamadas são encadeadas.
4. **`class App : Application`** herda da `Application` do Avalonia, como o
   `extends` do Java. **`public override void Initialize()`** adiciona o tema
   Fluent. O C# exige a palavra `override`; em Java, `@Override` é opcional.
5. **`if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)`**
   é *correspondência de padrões* (*pattern matching*): testa o tipo e, se
   houver correspondência, declara `desktop` com esse tipo em uma só etapa.
6. **`new Window { Title = ..., Content = new TextBlock { ... } }`** é um
   *inicializador de objeto*: cria o objeto e define suas propriedades em uma
   única expressão. `Content` é o que a janela mostra, aqui um `TextBlock`,
   um controle que exibe texto, centralizado.
7. **A autoverificação.** Com `TF_VERIFY=1`, `window.Opened += (s, e) => { ... };`
   inscreve uma lambda no evento `Opened` da janela (`+=` adiciona um
   tratador de evento; eventos fazem parte da linguagem C#). A lambda
   imprime o texto do TextBlock e chama `DispatcherTimer.RunOnce` para
   fechar a janela 2 segundos depois, na thread da UI. Quem executa
   `./run.sh` nunca vê isso.

## Por que esta toolchain
- O **Avalonia** descreve-se como uma forma de "Build cross-platform desktop,
  mobile, and web apps with shared XAML and C#" (tradução livre: "Criar
  aplicações desktop, móveis e web multiplataforma com XAML e C#
  compartilhados"), e é "MIT licensed" (tradução livre: "licenciado sob a
  MIT") [1]. A versão estável mais recente no NuGet em 2026-11-19 era a
  12.1.6 [10]. Este repositório usa o Avalonia porque os toolkits da própria
  Microsoft não cobrem as três plataformas desktop: o WPF e o Windows Forms
  são exclusivos do Windows [2][3], e o MAUI não tem destino Linux [4].
- **Somente código, sem XAML.** O XAML é a forma habitual de escrever UIs do
  Avalonia [7][12], mas um único arquivo C# mantém o Hello World comparável
  com as outras pastas desktop. O próprio Avalonia documenta esse estilo [8].

## Notas por plataforma
| Plataforma | Situação | Observações |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-20) | .NET SDK 10.0.404, Avalonia 12.1.6. A janela segue a aparência do sistema: "By default, Avalonia inherits the theme variant set by the system-wide user preference" [11] (tradução livre: "Por padrão, o Avalonia herda a variante de tema definida pela preferência do usuário em todo o sistema"); por isso, ela é escura na máquina de desenvolvimento. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. As bibliotecas nativas em `runtimes/osx/native` são binários universais (`file` informa `x86_64` e `arm64`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o `dotnet-install.sh` da Microsoft (canal 10.0) em `~/.dotnet` quando nenhum SDK do .NET 10 é encontrado [2]. Em seguida, executa `dotnet restore`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o SDK: se nenhum SDK do .NET 10 é encontrado, ele imprime `winget install --id Microsoft.DotNet.SDK.10 -e` e para. Em seguida, executa `dotnet restore`. |

## Saída esperada
`./run.sh --verify`:
```text
==> Open the Hello World window
    WHY: the .NET runtime runs the program; Avalonia opens the window and draws the text.
    Self-check: the app prints the text and closes after ~2 seconds.
Hello, World!
```
`./run.sh` abre esta janela:

![A janela do Avalonia com o título "Hello, World!" mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-01 no macOS Intel com `screencapture -x -o -l <window id>`,
que captura apenas esta janela.)

## Fontes
1. Avalonia UI (home page: platforms, MIT license). AvaloniaUI OÜ. <https://avaloniaui.net/> (acessado em 2026-11-01)
2. What is Windows Presentation Foundation (WPF). Microsoft Learn. <https://learn.microsoft.com/dotnet/desktop/wpf/overview> (acessado em 2026-11-01)
3. What is Windows Forms. Microsoft Learn. <https://learn.microsoft.com/dotnet/desktop/winforms/overview> (acessado em 2026-11-01)
4. What is .NET MAUI? Microsoft Learn. <https://learn.microsoft.com/dotnet/maui/what-is-maui> (acessado em 2026-11-01)
5. `dotnet restore` command. Microsoft Learn. <https://learn.microsoft.com/dotnet/core/tools/dotnet-restore> (acessado em 2026-11-01)
6. Avalonia.BuildServices 11.3.2 package README ("Avalonia Telemetry"), instalado em `~/.nuget/packages/avalonia.buildservices/11.3.2/README.md`; página do pacote: NuGet Gallery. <https://www.nuget.org/packages/Avalonia.BuildServices> (acessado em 2026-11-01)
7. Avalonia.Templates: templates/csharp/app (the `avalonia.app` template files). AvaloniaUI, GitHub. <https://github.com/AvaloniaUI/Avalonia.Templates/tree/main/templates/csharp/app> (acessado em 2026-11-01)
8. Code-only UI. Avalonia Docs. <https://docs.avaloniaui.net/docs/fundamentals/coded-ui> (acessado em 2026-11-01)
9. Application lifetimes. Avalonia Docs. <https://docs.avaloniaui.net/docs/concepts/application-lifetimes> (acessado em 2026-11-01)
10. Avalonia 12.1.6. NuGet Gallery. <https://www.nuget.org/packages/Avalonia> (acessado em 2026-11-19)
11. Theme variants. Avalonia Docs. <https://docs.avaloniaui.net/docs/styling/theme-variants> (acessado em 2026-11-01)
12. Create your first project. Avalonia Docs. <https://docs.avaloniaui.net/docs/get-started/create-your-first-project> (acessado em 2026-11-01)
13. Avalonia.Templates: templates/csharp/app/Program.cs. AvaloniaUI, GitHub. <https://github.com/AvaloniaUI/Avalonia.Templates/blob/main/templates/csharp/app/Program.cs> (acessado em 2026-11-01)
