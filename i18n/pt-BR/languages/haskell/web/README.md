---
source: languages/haskell/web/README.md
source_sha: 445f277253ae57869a7e7aeaad7739931b9174ff
---
# Haskell · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Haskell](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> que responde a `GET /` com o
HTML `<p>Hello, World!</p>`, como as demais versões web (por exemplo, a
[Python](../../python/web/)). Qualquer outro caminho recebe a página
`404 Not Found` embutida do Scotty.

Ele é escrito com o **Scotty**, um "Haskell web framework inspired by Ruby's
Sinatra, using WAI and Warp" [1] (tradução livre: "framework web Haskell
inspirado no Sinatra do Ruby, usando WAI e Warp"). O Scotty descreve a si
mesmo como "the cheap and cheerful way to write RESTful, declarative web
applications" [1] (tradução livre: "o modo barato e alegre de escrever
aplicações web RESTful e declarativas"). O servidor HTTP embutido é o
**Warp**, "A fast, light-weight web server for WAI applications" [2]
(tradução livre: "Um servidor web rápido e leve para aplicações WAI"). O
projeto é um pacote **Cabal**: "Cabal is a system for building and packaging
Haskell libraries and programs" [3] (tradução livre: "O Cabal é um sistema
para compilar e empacotar bibliotecas e programas Haskell"). O GHC compila
tudo em um único executável nativo.

Compare primeiro com a versão [cli](../cli/): nela, `main` é uma ação `IO`
que imprime uma linha. Aqui, `main` é uma ação `IO` que executa um servidor
web. O programa continua sendo construído a partir de valores e funções
puras; ver o [passo a passo](#passo-a-passo).

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| GHC | 9.10.3 (GHCup) | compila as bibliotecas e o `app/Main.hs` |
| cabal-install (`cabal`) | 3.16.1.0 (GHCup) | baixa as bibliotecas do Hackage e compila o pacote |
| Scotty | 0.30 (fixada em `cabal.project.freeze`) | o framework web |
| Warp | 3.4.19 (fixada em `cabal.project.freeze`) | o servidor HTTP sobre o qual o Scotty executa |
| curl | curl do sistema | apenas para o `./run.sh --verify` e para testes manuais |

O GHC e o Cabal vêm do GHCup, "the main installer for the general purpose
language Haskell" [4] (tradução livre: "o instalador principal da linguagem
de propósito geral Haskell"); ver [../cli](../cli/README.md#prerequisites).
O Scotty 0.30 foi enviado ao Hackage em 2026-01-07 [1], e o Warp 3.4.19, em
2026-10-29 [2].

## Início rápido
```sh
./install.sh   # check / install GHC and Cabal with GHCup (asks before installing)
./build.sh     # download the libraries and build (first build on the test machine: about 8.5 min)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute
`curl http://localhost:8080/`. Para usar outra porta, `PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `ghc --version` e `cabal --version`. Se um dos dois estiver faltando, baixa o script de bootstrap do GHCup [4] para um arquivo, mostra o caminho dele e só o executa se você responder `y` (detalhes em [../cli](../cli/README.md#scripts-explained)). | Esta versão usa bibliotecas, de modo que precisa do Cabal além do GHC. O GHCup instala ambos. |
| `build.sh` | 1. `cabal update`: "updates the state of the package index" [5] (tradução livre: "atualiza o estado do índice de pacotes"), a lista de todos os pacotes e versões do Hackage. 2. `cabal build`: "Compile targets within the project" [5] (tradução livre: "Compila os alvos dentro do projeto"). Lê o `hello-web.cabal` e o `cabal.project.freeze`, baixa e compila todas as bibliotecas (somente no primeiro build), depois compila o `app/Main.hs` e liga o `hello-web`. 3. Imprime onde está o executável com `cabal list-bin hello-web` ("List the path to a single executable" [5]; tradução livre: "Lista o caminho de um único executável"). | Como o Cargo para o Rust ou o Maven para o Java, o Cabal encontra, baixa e compila as dependências. |
| `run.sh` | Encontra o executável com `cabal list-bin hello-web` e o executa com `PORT` (padrão 8080). `--verify` o inicia em segundo plano, busca a página uma vez com o `curl` e depois o encerra. | O executável é o servidor: não há programa servidor separado para instalar (compare com [Go](../../go/web/) e [Rust](../../rust/web/)). |
| `ghcup-env.sh` | Não é executado isoladamente: os scripts o leem. Adiciona `~/.ghcup/bin` ao `PATH`. | O mesmo que em [../cli](../cli/README.md#scripts-explained). |

**Onde ficam as coisas.** A saída da compilação do projeto vai para
`dist-newstyle/` (a pasta que o `cabal clean` remove [5]). As bibliotecas
compiladas vão para o *store* do Cabal, na pasta pessoal do usuário, de
modo que outros projetos possam reutilizá-las. Por padrão, o store fica em
`~/.local/state/cabal` no Unix, mas, se já existir uma pasta `~/.cabal`, o
Cabal continua a usá-la [6]. Na máquina de teste, era `~/.cabal/store`.

**Versões fixadas.** O `cabal.project.freeze` foi escrito pelo `cabal
freeze`, que "writes out a freeze file which records all of the versions and
flags that are picked by the solver" [5] (tradução livre: "grava um arquivo
de congelamento que registra todas as versões e opções escolhidas pelo
solucionador"). O Cabal o lê como parte da configuração do projeto [7], de
modo que todo estudante compila as mesmas versões das bibliotecas, como
`Cargo.lock` ou `package-lock.json`. Para programas (não bibliotecas), a
documentação do Cabal afirma "it is recommended that you distribute the
`cabal.project.freeze` file in your source repository" [5] (tradução livre:
"recomenda-se distribuir o arquivo `cabal.project.freeze` no repositório de
código-fonte"). Sua última linha, `index-state`, fixa o estado do índice do
Hackage "the solver uses to compute install-plans" [7] (tradução livre:
"que o solucionador usa para calcular planos de instalação"). O arquivo
lista 133 pacotes, contando os que acompanham o GHC, como o `base`. O arquivo de versões fixa o `http2` 5.4.14 e o `network` 3.2.14.0:
o `http2` 5.4.14 corrige o
[HSEC-2026-0015](https://osv.dev/vulnerability/HSEC-2026-0015), uma validação
ausente de requisições CONNECT, e exige o `network` 3.2.12 ou posterior. Um
aviso de segurança não pode ser corrigido por nenhuma versão:
o [HSEC-2023-0007](https://osv.dev/vulnerability/HSEC-2023-0007) cobre o
`Numeric.readFloat` em todas as versões do `base`. Este programa nunca chama
`readFloat`, e o `osv-scanner.toml` registra isso como uma exceção datada.

## Estrutura de pastas
```text
web/
├── README.md              this file
├── install.sh             checks / installs GHC and Cabal with GHCup
├── build.sh               cabal update + cabal build
├── run.sh                 starts the server (or checks it with --verify)
├── ghcup-env.sh           adds ~/.ghcup/bin to PATH (read by the scripts)
├── screenshot.png         the page in a browser (see Expected output)
├── hello-web.cabal        the package description
├── cabal.project.freeze   the exact version of every package
├── osv-scanner.toml       the one documented security-scanner exception
├── app/
│   └── Main.hs            the program: routes + main
└── dist-newstyle/         created by cabal build; not committed (see ../../../.gitignore)
```
- Não há arquivo `cabal.project`. Nesse caso, "cabal-install fabricates an
  ephemeral project" [7] (tradução livre: "o cabal-install fabrica um
  projeto efêmero") que usa o arquivo `.cabal` desta pasta.
- **`hello-web.cabal`, linha por linha:**
  - `cabal-version: 3.0` deve ser a primeira linha: desde a 2.2, "this field
    is only valid if fully contained in the very first line of a package
    description" [8] (tradução livre: "este campo só é válido se estiver
    totalmente contido na primeiríssima linha da descrição de um pacote").
  - `executable hello-web` compila um programa (não uma biblioteca)
    chamado `hello-web`. `main-is: Main.hs` e `hs-source-dirs: app`
    indicam onde está o `main`. Nas palavras da documentação do Cabal: "By
    convention, a Haskell program must have a module called `Main` which
    exports an IO action named `main`" [8] (tradução livre: "Por convenção,
    um programa Haskell deve ter um módulo chamado `Main` que exporta uma
    ação IO chamada `main`").
  - `build-depends` lista as bibliotecas. `scotty ^>= 0.30` usa o operador
    circunflexo para "PVP-style major upper bounds" [8] (tradução livre:
    "limites superiores de versão principal no estilo PVP"): significa
    `>= 0.30 && < 0.31`.
  - `default-language: Haskell2010` escolhe o padrão da linguagem [8].
  - `ghc-options: -Wall -threaded`. O `-Wall` "Turns on all warning options
    that indicate potentially suspicious code" [9] (tradução livre: "Ativa
    todas as opções de aviso que indicam código potencialmente suspeito").
    O `-threaded` significa "Link the program with the "threaded" version of
    the runtime system" [10] (tradução livre: "Liga o programa com a versão
    "threaded" do sistema de runtime").

## Passo a passo
Abra o [`app/Main.hs`](app/Main.hs) ao lado desta lista.

1. **`{-# LANGUAGE OverloadedStrings #-}`.** Um pragma `LANGUAGE` ativa um
   recurso da linguagem para um único arquivo; ele "must precede the module
   keyword" [11] (tradução livre: "deve preceder a palavra-chave module").
   "Normally a string literal has type `String`" [12] (tradução livre:
   "Normalmente, um literal de string tem o tipo `String`"); com o
   `OverloadedStrings`, "a string literal has type `(IsString a) => a`" [12]
   (tradução livre: "um literal de string tem o tipo `(IsString a) => a`"),
   de modo que `"/"` pode ser um padrão de rota e o HTML pode ser o tipo de
   texto do Scotty. A documentação do Scotty afirma "most of the code
   snippets below depend on the OverloadedStrings language pragma" [13]
   (tradução livre: "a maioria dos trechos de código abaixo depende do
   pragma de linguagem OverloadedStrings").
2. **As importações** nomeiam exatamente o que é usado, a partir de três
   pacotes: o Warp (`setHost`, `setPort`, `defaultSettings`), o `base`
   (`lookupEnv`) e o Scotty (o restante).
3. **`app :: ScottyM ()` é um valor, não um servidor em execução.** Esta é a
   ideia funcional do programa. Os tipos, da documentação do Scotty [13]:

   ```haskell
   get  :: RoutePattern -> ActionM () -> ScottyM ()
   html :: Text -> ActionM ()
   ```

   `html "<p>Hello, World!</p>"` é um valor: uma *ação* que define o corpo
   da resposta e "Also sets "Content-Type" header to "text/html;
   charset=utf-8"" [13] (tradução livre: "Também define o cabeçalho
   "Content-Type" como "text/html; charset=utf-8""). `get "/"` é uma função
   que recebe essa ação e devolve uma *rota*. Assim, `app` é apenas dado:
   uma descrição da aplicação web. Defini-la não abre uma porta nem imprime
   nada. Uma aplicação maior listaria várias rotas em um bloco `do`, que as
   combina em um único valor `ScottyM ()`.
4. **O `$` economiza parênteses.** No Prelude, ele é definido como
   `f $ x = f x`, com a menor precedência (`infixr 0`) [14]. Assim,
   `get "/" $ html "..."` equivale a `get "/" (html "...")`.
5. **`main :: IO ()` com `do`.** "A do expression provides a more
   conventional syntax for monadic programming" [15] (tradução livre: "Uma
   expressão do fornece uma sintaxe mais convencional para a programação
   monádica"): as linhas são ações `IO`, executadas uma após a outra. Esta é
   a única parte do programa que se comunica com o mundo exterior, e seu
   tipo o indica. O sistema de runtime executa o `main` quando o programa
   inicia, exatamente como na versão
   [cli](../cli/README.md#step-by-step-walkthrough).
6. **`portVar <- lookupEnv "PORT"`.** `lookupEnv :: String -> IO (Maybe
   String)` devolve "the value of the environment variable `var`, or
   `Nothing` if there is no such value" [16] (tradução livre: "o valor da
   variável de ambiente `var`, ou `Nothing` se não houver tal valor"). O
   `<-` executa a ação e dá nome ao seu resultado. O Haskell não tem
   `null`: o tipo `Maybe` obriga o código a tratar o caso "não definida".
7. **`let port = maybe 8080 read portVar :: Int`** é puro: o `let` apenas
   dá nome a um valor. `maybe n f Nothing = n` e `maybe n f (Just x) = f x`
   [14], de modo que o resultado é `8080` ou o texto convertido em número
   por `read`. Se o `read` não consegue interpretar o texto, interrompe o
   programa com `error "Prelude.read: no parse"` [14]. **Experimente:** com
   `PORT=abc ./run.sh`, o servidor para imediatamente com
   `hello-web: Prelude.read: no parse`.
8. **`setHost "127.0.0.1" . setPort port $ defaultSettings`.** Os setters do
   Warp têm tipos como `setPort :: Port -> Settings -> Settings` [17]: eles
   não alteram um objeto de configurações; devolvem um novo. O `.` é a
   composição de funções, `f . g = \ x -> f (g x)` [14], de modo que o
   `setPort` executa primeiro e, depois, o `setHost`. Sem eles, o Warp usaria
   a porta 3000 e "HostIPv4" [17]. Com `"127.0.0.1"`, ele se vincula "to the
   IPv4 local host only" [17] (tradução livre: "somente ao host local
   IPv4"), de modo que outros computadores não conseguem se conectar.
9. **`defaultOptions { settings = warp }`** é uma atualização de registro
   (*record update*). Ela "creates a new value in which the specified field
   values replace those in the existing value" [15] (tradução livre: "cria
   um novo valor em que os valores de campo especificados substituem os do
   valor existente"): o próprio `defaultOptions` não muda. Valores em
   Haskell nunca são modificados no lugar.
10. **`scottyOpts defaultOptions { settings = warp } app`.** `scottyOpts
    :: Options -> ScottyM () -> IO ()` "Run a scotty application using the
    warp server, passing extra options" [13] (tradução livre: "Executa uma
    aplicação scotty usando o servidor warp, passando opções extras"). Ele
    recebe a descrição pura `app` e a transforma em uma única ação `IO` que
    atende requisições para sempre. Como `verbose` é `1` por padrão, o
    Scotty imprime um "startup banner" [13] (tradução livre: "banner de
    inicialização") (`Setting phasers to stun...`, ver abaixo).

## Por que esta toolchain
- **O Scotty é pequeno.** Uma rota é uma linha, `get "/" $ html ...`, e o
  servidor inteiro cabe em um único arquivo, como mostra o Hello World em
  sua página no Hackage [1]. O Scotty é "set up by default for development
  mode" [13] (tradução livre: "configurado por padrão para o modo de
  desenvolvimento"); um servidor de produção alteraria suas configurações.
- **O Cabal é o sistema de empacotamento do Haskell** [3], instalado pelo
  GHCup junto com o GHC. Ele baixa pacotes do Hackage, que a página do Cabal
  chama de "the Haskell Package Database" [3] (tradução livre: "o Banco de
  Dados de Pacotes Haskell").
- **O custo: o primeiro build.** O Scotty e o Warp precisam de muitos outros
  pacotes. O primeiro `./build.sh` baixa e compila todos eles (507 s,
  cerca de 8,5 min, na máquina de teste em 2026-11-01, com a pasta do Cabal
  vazia, incluindo o download do índice do Hackage). Os builds seguintes
  reutilizam o store e recompilam apenas o `app/Main.hs`.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-01) | GHC 9.10.3, cabal-install 3.16.1.0, GHCup 0.2.6.2. A etapa de ligação imprime `ld: warning: -U option is redundant when using -undefined dynamic_lookup`; o build ainda é concluído com sucesso e o servidor funciona. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; o GHC tem um build para macOS AArch64 [18]. Ver a observação do GHCup sobre o LLVM em [../cli](../cli/README.md#platform-notes). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` executa o script de bootstrap do GHCup de `get-ghcup.haskell.org` (não interativo, sem o Stack) quando o `ghc` ou o `cabal` não existe. Ele instala o GHC e o Cabal em `~/.ghcup`. Se outra versão do GHC é encontrada, ele executa `ghcup install ghc 9.10.3 --set`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o GHC nem o Cabal: se um dos dois não existe, ele imprime o comando do PowerShell do GHCup [4] e para. Se outra versão do GHC é encontrada, ele executa `ghcup install ghc 9.10.3 --set`. O WSL não foi verificado; ele se comporta como o Linux. |

**O script de bootstrap do GHCup não tem verificação de checksum.** A página de
instalação do GHCup não fornece um checksum para ele: ela aponta para o código-fonte
do script e oferece verificações com GPG apenas para uma instalação manual dos
binários [31]. Por isso, o `install.sh` salva o script em
`~/.cache/hello-world-haskell/bootstrap-haskell.sh` e mostra o caminho, para que
você possa lê-lo antes de responder `y` para executá-lo.

## Saída esperada
```text
$ ./run.sh --verify

==> Start the web server on http://localhost:8080
    WHY: hello-web runs Scotty on Warp, listening on 127.0.0.1 (this
         computer only), and answers GET /.
<p>Hello, World!</p>
```
A última linha é a página, buscada pelo `curl` no `run.sh`.

Com o `./run.sh` em um terminal, o servidor imprime mais duas linhas (a
primeira vem do `putStrLn` em `main`; a segunda é o banner de inicialização
do Scotty) e continua em execução até Ctrl+C:
```text
$ ./run.sh

==> Start the web server on http://localhost:8080
    WHY: hello-web runs Scotty on Warp, listening on 127.0.0.1 (this
         computer only), and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
Setting phasers to stun... (port 8080) (ctrl-c to quit)
```
No modo `--verify`, essas duas linhas não aparecem. A saída do servidor vai
ali para um pipe, e não para um terminal, e "The default buffering mode
when a handle is opened is implementation-dependent" [20] (tradução livre:
"O modo de buffer padrão quando um handle é aberto depende da
implementação"). Com o GHC, as linhas permaneceram no buffer de saída, e o
servidor foi encerrado antes que o buffer fosse descarregado.

Em um segundo terminal:
```text
$ curl -i http://127.0.0.1:8080/
HTTP/1.1 200 OK
Transfer-Encoding: chunked
Date: Sun, 01 Nov 2026 22:43:27 GMT
Server: Warp/3.4.19
Content-Type: text/html; charset=utf-8

<p>Hello, World!</p>
```
Qualquer outro caminho, por exemplo `curl -i http://127.0.0.1:8080/nope`,
recebe `HTTP/1.1 404 Not Found` e o corpo `<h1>404: File Not Found!</h1>`
do Scotty.

![Uma página de navegador exibindo "Hello, World!"](screenshot.png)

(Capturada em 2026-11-02 em macOS Intel com o Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. `scotty`: Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp (version 0.30). Hackage. <https://hackage.haskell.org/package/scotty> (acessado em 2026-11-01)
2. warp: A fast, light-weight web server for WAI applications (version 3.4.19). Hackage. <https://hackage.haskell.org/package/warp> (acessado em 2026-11-01)
3. The Haskell Cabal: Overview. haskell.org. <https://www.haskell.org/cabal/> (acessado em 2026-11-01)
4. GHCup (home page: install commands). haskell.org. <https://www.haskell.org/ghcup/> (acessado em 2026-11-01)
5. Cabal User Guide: Commands (update, build, list-bin, freeze, clean). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-commands.html> (acessado em 2026-11-01)
6. Cabal User Guide: Configuration (directories, XDG and `~/.cabal`). Cabal developers. <https://cabal.readthedocs.io/en/stable/config.html> (acessado em 2026-11-01)
7. Cabal User Guide: cabal.project Reference (configuration sources, implicit project, index-state). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-project-description-file.html> (acessado em 2026-11-01)
8. Cabal User Guide: Package Description (cabal-version, main-is, build-depends, `^>=`, default-language). Cabal developers. <https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html> (acessado em 2026-11-01)
9. GHC 9.10.3 User's Guide: Warnings and sanity-checking (-Wall). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/using-warnings.html> (acessado em 2026-11-01)
10. GHC 9.10.3 User's Guide: Options related to a particular phase (-threaded). GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/phases.html> (acessado em 2026-11-01)
11. Haskell 2010 Language Report, Chapter 12: Compiler Pragmas (12.3 Language extensions). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch12.html> (acessado em 2026-11-01)
12. GHC 9.10.3 User's Guide: Overloaded string literals. GHC developers. <https://downloads.haskell.org/ghc/9.10.3/docs/users_guide/exts/overloaded_strings.html> (acessado em 2026-11-01)
13. `Web.Scotty` (`scotty-0.30` API documentation: `get`, `html`, `scottyOpts`, `Options`). Hackage. <https://hackage.haskell.org/package/scotty-0.30/docs/Web-Scotty.html> (acessado em 2026-11-01)
14. Haskell 2010 Language Report, Chapter 9: Standard Prelude (`$`, `.`, `maybe`, `read`). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch9.html> (acessado em 2026-11-01)
15. Haskell 2010 Language Report, Chapter 3: Expressions (3.14 Do Expressions, 3.15.3 Updates Using Field Labels). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch3.html> (acessado em 2026-11-01)
16. `System.Environment` (`base-4.20.2.0` API documentation: `lookupEnv`). Hackage. <https://hackage.haskell.org/package/base-4.20.2.0/docs/System-Environment.html> (acessado em 2026-11-01)
17. `Network.Wai.Handler.Warp` (`warp-3.4.19` API documentation: `setPort`, `setHost`, `HostPreference`). Hackage. <https://hackage.haskell.org/package/warp-3.4.19/docs/Network-Wai-Handler-Warp.html> (acessado em 2026-11-01)
18. GHC 9.10.3 download page (binary distributions). GHC developers, haskell.org. <https://www.haskell.org/ghc/download_ghc_9_10_3.html> (acessado em 2026-11-01)
19. GHCup: System requirements. haskell.org. <https://www.haskell.org/ghcup/install/reqs/> (acessado em 2026-11-01)
20. Haskell 2010 Language Report, Chapter 41: System.IO (41.4.3 Buffering Operations). haskell.org. <https://www.haskell.org/onlinereport/haskell2010/haskellch41.html> (acessado em 2026-11-01)
31. GHCup: Installation. haskell.org. <https://www.haskell.org/ghcup/install/> (acessado em 2026-11-19)
