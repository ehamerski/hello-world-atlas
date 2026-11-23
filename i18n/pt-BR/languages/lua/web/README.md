---
source: languages/lua/web/README.md
source_sha: 859d02c1d6d116ca474f67374b37cecafeeeb8e2
---
# Lua · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Lua](../README.md)

## O que é
Um pequeno servidor web escrito com o Pegasus, uma biblioteca de servidor
HTTP para Lua. Quando um navegador pede `http://localhost:8080/`, o servidor
responde com o HTML `<p>Hello, World!</p>`, que o navegador mostra como o
texto **Hello, World!**. O próprio servidor envia o HTML; não há um front-end
separado.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| Lua (`lua`; `lua5.4` no Debian e no Ubuntu) | 5.5.1 (fórmula `lua` do Homebrew) | executa o `app.lua` |
| LuaRocks | 3.13.0 (fórmula `luarocks` do Homebrew) | o gerenciador de pacotes do Lua; o `install.sh` o usa para instalar o Pegasus em `rocks/` |
| Pegasus | 1.1.0 (`pegasus 1.1.0-0` no LuaRocks) | a biblioteca de servidor web |
| LuaSocket, LuaFileSystem, lzlib, mimetypes | 3.1.0-1, 1.9.0-1, 0.4.1.53-4, 1.1.0-2 | os módulos que o Pegasus exige [1] |
| um compilador C | Apple clang das Xcode Command Line Tools | o LuaSocket, o LuaFileSystem e o lzlib contêm código C que o LuaRocks compila no computador do leitor |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O Pegasus declara estes requisitos: Lua 5.1 ou superior, LuaFileSystem 1.6 ou
superior, LuaSocket, lzlib 0.4.1.53-1 ou superior e mimetypes 1.0.0-1 ou
superior [1]. O `install.sh` instala uma versão fixa de cada um, de modo que
toda instalação é igual.

## Início rápido
```sh
./install.sh   # check Lua and LuaRocks, install Pegasus into rocks/ (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Use outra porta com
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o interpretador e mostra como instalá-lo. 2. Verifica se o `luarocks` está instalado. 3. Executa `luarocks --tree ./rocks install <módulo> <versão>` para LuaSocket, LuaFileSystem, lzlib, mimetypes e Pegasus. Cada etapa de instalação pergunta antes. | O Pegasus é um módulo de terceiros. Na saída de `luarocks help`, a opção `--tree` é descrita como "Which tree to operate on.", de modo que os módulos vão para a pasta `rocks/` deste aplicativo e não para o sistema. |
| `run.sh` | Executa `eval "$(luarocks --tree ./rocks path)"` e depois `lua app.lua`. `--verify` inicia o servidor em segundo plano, busca a página uma vez com `curl` e então o encerra. | `luarocks path` imprime comandos de shell que definem `LUA_PATH` e `LUA_CPATH` [2], que dizem ao Lua onde encontrar módulos. A autoverificação permite que o `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`, porque o Lua é executado a partir do código-fonte, como no
[cli](../cli/README.md#why-there-is-no-build-step). O LuaRocks compila os
módulos em C das dependências durante o `install.sh`, mas a aplicação em si
não tem nada para compilar.

## Estrutura de pastas
```text
web/
├── README.md      this file
├── install.sh     checks Lua and LuaRocks, installs Pegasus into rocks/
├── run.sh         starts the server
├── app.lua        the web application
├── .gitignore     keeps rocks/ out of git
└── rocks/         created by install.sh; not committed
```
- O `app.lua` é o único arquivo-fonte. Um único arquivo basta para uma
  página.
- `rocks/` é uma *tree* (árvore) do LuaRocks: uma pasta onde o LuaRocks
  guarda os módulos instalados. A documentação do LuaRocks descreve a árvore
  "system" e a árvore "user" [2]; uma árvore local ao projeto é uma terceira,
  escolhida com `--tree`.
- Um aplicativo Pegasus maior adicionaria pastas para arquivos estáticos e
  plugins, que o Pegasus lê a partir da sua configuração `location` [4]. Uma
  única página não precisa de nenhum dos dois.

## Passo a passo
Abra o [`app.lua`](app.lua) ao lado desta lista.

1. **`local Pegasus = require("pegasus")`** carrega o módulo e devolve o que
   ele exporta. `require` "loads the given module" [3] (tradução livre:
   "carrega o módulo indicado"). Diferentemente do [cli](../cli/hello.lua),
   que usa apenas o `print` nativo, este programa depende de uma biblioteca
   que o LuaRocks instalou.
2. **`local port = tonumber(os.getenv("PORT")) or 8080`** lê a porta.
   `os.getenv` "returns the value of the process environment variable
   `varname` or fail if the variable is not defined" [3] (tradução livre:
   "devolve o valor da variável de ambiente `varname` do processo ou fail se
   a variável não estiver definida"), e "currently, `fail` is equal to `nil`"
   [3] (tradução livre: "atualmente, `fail` é igual a `nil`"). O operador
   `or` "returns its first argument if this value is different from nil and
   false; otherwise, `or` returns its second argument" [3] (tradução livre:
   "devolve o seu primeiro argumento se esse valor for diferente de nil e de
   false; caso contrário, `or` devolve o seu segundo argumento"), de modo que
   8080 é o valor padrão. `tonumber` converte o texto em número [3].
3. **`Pegasus:new({ host = "127.0.0.1", port = port })`** cria o servidor. As
   chaves constroem uma *tabela*, que "is the sole data-structuring
   mechanism in Lua" [3] (tradução livre: "é o único mecanismo de
   estruturação de dados do Lua"). Os dois-pontos em `Pegasus:new` passam o
   próprio `Pegasus` como primeiro argumento: "a call `v:name(args)` is
   syntactic sugar for `v.name(v, args)`" [3] (tradução livre: "uma chamada
   `v:name(args)` é açúcar sintático para `v.name(v, args)`"). Associar-se a
   `127.0.0.1` torna o servidor acessível apenas a partir deste computador.
4. **`server:start(function(request, response) ... end)`** executa o
   servidor. A função é chamada uma vez para cada requisição, como um
   tratador de rota no Express (`app.get("/", ...)`), no Flask
   (`@app.route("/")`) ou no Go (`http.HandleFunc("/", ...)`). Aqui, toda URL
   recebe a mesma resposta. O Pegasus documenta que "`start` runs a blocking
   accept loop" [4] (tradução livre: "`start` executa um laço de aceitação
   bloqueante"), de modo que essa chamada não retorna. Esse laço é a
   diferença em relação à versão cli, que executa uma vez e termina.
5. **`response:statusCode(200)`, `response:addHeader("Content-Type",
   "text/html")`, `response:write("<p>Hello, World!</p>")`** montam a
   resposta: a linha de status, um cabeçalho e o corpo. O Pegasus documenta
   os três métodos e observa que `write` define `Content-Length` para um
   corpo do tipo string [5]. Sem o cabeçalho `Content-Type`, o navegador não
   saberia que o texto é HTML. O resultado pode ser visto na saída de
   `curl -i` abaixo.

## Por que esta toolchain
- **O Pegasus** se descreve como "an http server to work with web
  applications written in Lua language" [6] (tradução livre: "um servidor
  http para trabalhar com aplicações web escritas na linguagem Lua"). Seu
  código-fonte diz "Minimal, embeddable HTTP server with a simple plugin
  system" [4] (tradução livre: "Servidor HTTP mínimo e embutível, com um
  sistema simples de plugins"). Tem uma API pequena, e a página Hello World
  ocupa 8 linhas de código, o que combina com o objetivo deste repositório de
  manter cada programa o mais simples e direto possível. Ele é licenciado
  sob a licença MIT [1].
- **A versão 1.1.0** é a mais nova do Pegasus no LuaRocks em 2026-11-04 [1].
- **LuaRocks:** a página de download do Lua diz "The main repository of Lua
  modules is LuaRocks" [7] (tradução livre: "O principal repositório de
  módulos Lua é o LuaRocks"). Sua opção `--tree` mantém os módulos deste
  aplicativo separados dos de qualquer outro projeto Lua no computador.
- **O Pegasus é para aprender, não para produção.** Seu método `start` "runs
  a blocking accept loop", e a sua própria documentação recomenda executá-lo
  "in a dedicated OS thread/process if you need concurrency" [4] (tradução
  livre: "em uma thread/processo dedicado do sistema operacional se você
  precisar de concorrência").
- **Cadeia de suprimentos.** O LuaRocks.org publicou um relatório de
  incidente: em 2026-09-25 recebeu o relato de uma vulnerabilidade de
  execução remota de código, corrigida em 2026-09-26. O relatório diz "We
  have not found any evidence that existing packages were modified"
  (tradução livre: "Não encontramos nenhuma evidência de que pacotes
  existentes tenham sido modificados") e recomenda atualizar o LuaRocks "to
  3.12 or newer" [8] (tradução livre: "para a 3.12 ou mais recente"). Esta
  implementação usa o LuaRocks 3.13.0. Fixar versões não verifica os hashes
  dos arquivos, por isso convém ler o relatório antes de instalar.
- **A porta 8080** é a convenção deste repositório para toda implementação
  web. O próprio Pegasus usa 9090 como padrão [4].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-04) | Lua 5.5.1 e LuaRocks 3.13.0 do Homebrew, Pegasus 1.1.0-0. O LuaRocks compilou os três módulos em C em cerca de 25 segundos no total. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel (`brew install lua luarocks`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `lua5.4` com o apt quando ele não existe e, quando o LuaRocks não existe, instala `luarocks`, `build-essential`, `unzip`, `liblua5.4-dev` e `zlib1g-dev`. Ele informa ao LuaRocks a versão do Lua, porque o `luarocks` do Debian está configurado para o Lua 5.1. Em seguida, compila o Pegasus e seus módulos em `rocks/`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. Se o Lua ou o LuaRocks não existe, o `install.sh` instala os pacotes do MSYS2 para Lua 5.5, LuaRocks, GCC e zlib com o `pacman` (o MSYS2 já vem instalado em `C:\msys64`) e adiciona `C:\msys64\ucrt64\bin` ao final do PATH. O Git Bash não consegue executar o arquivo `luarocks` do MSYS2; por isso os scripts o executam com o `lua.exe`. Em seguida, compila o Pegasus e seus módulos em `rocks/`. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'luarocks --tree ./rocks path' prints the settings (LUA_PATH, LUA_CPATH)
         that let Lua find the modules in rocks/; 'eval' applies them to this script.
    Then 'lua app.lua' serves on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Pegasus is up on 127.0.0.1:8080
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Content-Length: 20
Content-Type: text/html
Date: Wed, 04 Nov 2026 16:13:33 GMT

<p>Hello, World!</p>
```
O navegador mostra: **Hello, World!**

![A página em http://localhost:8080/ mostrando "Hello, World!"](screenshot.png)

(Capturada em 2026-11-04 com o Google Chrome headless:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. `pegasus`: LuaRocks module page. LuaRocks. <https://luarocks.org/modules/evandrolg/pegasus> (acessado em 2026-11-04)
2. Using LuaRocks. LuaRocks. <https://github.com/luarocks/luarocks/blob/main/docs/using_luarocks.md> (acessado em 2026-11-04)
3. Lua 5.5 Reference Manual. Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes. <https://www.lua.org/manual/5.5/manual.html> (acessado em 2026-11-04)
4. `src/pegasus/init.lua`, tag v1.1.0. Pegasus.lua. <https://github.com/EvandroLG/pegasus.lua/blob/v1.1.0/src/pegasus/init.lua> (acessado em 2026-11-04)
5. `src/pegasus/response.lua`, tag v1.1.0. Pegasus.lua. <https://github.com/EvandroLG/pegasus.lua/blob/v1.1.0/src/pegasus/response.lua> (acessado em 2026-11-04)
6. Pegasus.lua. EvandroLG (GitHub). <https://github.com/EvandroLG/pegasus.lua> (acessado em 2026-11-04)
7. Download. Lua.org, PUC-Rio. <https://www.lua.org/download.html> (acessado em 2026-11-04)
8. LuaRocks.org Security Incident, September 2026. LuaRocks. <https://luarocks.org/security-incident-september-2026> (acessado em 2026-11-04)
