---
source: languages/php/web/README.md
source_sha: 0b2484e2351695250c7ffb1784d84f84cd4b39fb
---
# PHP · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [PHP](../README.md)

## O que é
Uma página web escrita em PHP puro e servida pelo servidor web embutido no
programa `php` (`php -S`). Quando um navegador solicita
`http://localhost:8080/`, o servidor executa `public/index.php`, que envia
à saída o HTML `<p>Hello, World!</p>`. O navegador o exibe como o texto
**Hello, World!**. O servidor envia o próprio HTML; não há front-end
separado, nem framework, nem pacote a baixar.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| PHP 8 (`php`) | 8.5.11 (`php` do Homebrew) | executa `public/index.php` e contém o servidor web embutido |
| `curl` | `curl` do sistema | apenas para `./run.sh --verify` e para testes manuais |

Defina `PHP=/path/to/php` para usar outro interpretador.

## Início rápido
```sh
./install.sh   # check / install PHP (asks before installing)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica se `php` está no `PATH` (e avisa se `curl` estiver ausente). Se o PHP estiver ausente, mostra o comando de instalação para o sistema operacional do leitor e só o executa se a resposta for `y`. | O servidor embutido faz parte do programa `php`, portanto o PHP é a única dependência. |
| `run.sh` | Inicia `php -S 127.0.0.1:8080 -t public`. `--verify` o inicia em segundo plano, obtém a página uma vez com `curl` e depois o encerra. | `php -S` inicia o servidor web de desenvolvimento do PHP [1]. A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`: o PHP é interpretado, como em [../cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md          this file
├── install.sh         checks / installs PHP
├── run.sh             starts the built-in web server
├── screenshot.png     the page in a browser
└── public/            the document root: only files in here can be requested
    └── index.php      the page
```
Por que uma pasta `public/`? O servidor embutido envia qualquer arquivo de
sua raiz de documentos. "URI requests are served from the current working
directory where PHP was started, unless the -t option is used to specify an
explicit document root" [1] (tradução livre: "As requisições de URI são
atendidas a partir do diretório de trabalho atual em que o PHP foi iniciado,
a menos que a opção -t seja usada para especificar uma raiz de documentos
explícita"). Sem `-t public`, uma requisição a `/run.sh` retorna o
código-fonte do script (verificado na máquina de teste: `200`,
`application/x-sh`). Com `-t public`, apenas `public/` é acessível, e é ali
que a página fica.

Por que `index.php`? "If a URI request does not specify a file, then either
index.php or index.html in the given directory are returned" [1] (tradução
livre: "Se uma requisição de URI não especifica um arquivo, é retornado
index.php ou index.html do diretório indicado").

## Passo a passo
Abra [`public/index.php`](public/index.php) ao lado desta lista.

1. **Nenhum código de servidor.** As versões em Flask (Python), Express
   (Node.js), Spring Boot (Java) e `net/http` do Go criam o servidor e
   registram uma rota para `/` no código. Aqui, o arquivo *é* a página: o
   servidor PHP associa a URL `/` a `public/index.php` [1] e envia o que o
   arquivo produz na saída.
2. **`<?php ... ?>` ao redor do comentário.** O arquivo começa no modo PHP
   com um comentário de bloco `/* */`. "When PHP processes a file, it
   recognizes the opening and closing tags, `<?php` and `?>` to define the
   boundaries of PHP code execution" [2] (tradução livre: "Quando o PHP
   processa um arquivo, ele reconhece as tags de abertura e de fechamento,
   `<?php` e `?>`, para definir os limites da execução do código PHP").
3. **De volta ao HTML.** Depois de `?>`, tudo o que está "outside of a pair of
   opening and closing tags is ignored by the PHP parser" (tradução livre:
   "fora de um par de tags de abertura e de fechamento é ignorado pelo
   analisador do PHP"), isto é, é enviado como está [3]. A quebra de linha
   logo após `?>` não é enviada: "The closing tag for the block will include
   the immediately trailing newline if one is present" [4] (tradução livre:
   "A tag de fechamento do bloco inclui a quebra de linha imediatamente
   seguinte, se houver"). Assim, a resposta começa com `<p>`.
4. **Código dentro do HTML.** `<p><?php echo "Hello, World!"; ?></p>` é HTML
   com uma instrução PHP dentro. `echo` escreve o texto no lugar em que a
   tag está, entre `<p>` e `</p>` [5]. Esta é a ideia mais antiga do PHP; as
   outras linguagens deste repositório constroem o HTML como uma string.
5. **Tipo de conteúdo.** O código não define nenhum cabeçalho. O PHP envia
   `Content-type: text/html; charset=UTF-8` por conta própria, a partir das
   configurações `default_mimetype` (`"text/html"`) e `default_charset`
   (`"UTF-8"`) [6]. É possível vê-lo na saída de `curl -i` abaixo.
6. **Toda URL responde.** Para um caminho que não é um arquivo, como
   `/nothing`, o servidor procura um `index.php`: "If neither file exists,
   the lookup for index.php and index.html will be continued in the parent
   directory and so on until one is found or the document root has been
   reached" [1] (tradução livre: "Se nenhum dos arquivos existir, a busca por
   index.php e index.html continua no diretório pai, e assim por diante, até
   que um seja encontrado ou a raiz de documentos seja alcançada"). Assim,
   `/nothing` também retorna a página Hello (verificado na máquina de teste),
   enquanto a versão [Python/Flask](../../python/web/), que só tem uma rota
   para `/`, responde `404` (também verificado).

## Por que esta toolchain
- **PHP puro, sem framework.** Um framework (por exemplo, Laravel ou Symfony)
  acrescentaria um projeto Composer, um roteador e configuração. O PHP já
  consegue servir uma página a partir de um único arquivo, o que atende ao
  objetivo deste repositório de ser "o mais simples e direto".
- **O servidor web embutido (`php -S`)** acompanha o programa `php`, portanto
  nada mais é instalado. Ele existe desde o PHP 5.4.0 (2012-03-01): o anúncio
  do lançamento lista um "Built-in webserver" [7][8] (tradução livre:
  "servidor web embutido").
- **Somente para desenvolvimento.** O manual é explícito: "This web server is
  designed to aid application development. ... It is not intended to be a
  full-featured web server. It should not be used on a public network" [1]
  (tradução livre: "Este servidor web foi projetado para auxiliar o
  desenvolvimento de aplicações. ... Não se destina a ser um servidor web
  completo. Não deve ser usado em uma rede pública"). Além disso, "The web
  server runs only one single-threaded process, so PHP applications will
  stall if a request is blocked" [1] (tradução livre: "O servidor web executa
  apenas um processo de thread única, de modo que as aplicações PHP travam se
  uma requisição for bloqueada"). Em produção, o PHP executa por trás de um
  servidor web como Apache ou nginx; isso está fora do escopo de um Hello
  World.
- **127.0.0.1**, e não `0.0.0.0`: o servidor é acessível apenas a partir deste
  computador, o que corresponde a "should not be used on a public network"
  [1] (tradução livre: "não deve ser usado em uma rede pública").
- **A porta 8080** é a convenção deste repositório para toda implementação
  web.
- **PHP 8.5**: ver [../cli](../cli/README.md#why-this-toolchain) para a
  versão e as datas de suporte.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | `php` 8.5.11 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel (`brew install php`). |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala o `php-cli` com o apt quando o `php` não existe. O servidor embutido faz parte do comando `php`, portanto nenhum pacote do Apache é necessário [9]. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o PHP: se o `php` não existe, ele imprime os passos do ZIP "VS17 x64 Non Thread Safe" de windows.php.net [10] e para. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'php -S 127.0.0.1:8080 -t public' serves the public/ folder on this computer only.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
[Sat Oct 31 19:09:23 2026] PHP 8.5.11 Development Server (http://127.0.0.1:8080) started
```
Cada requisição é registrada no terminal (`Accepted`, `[200]: GET /`,
`Closing`). Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Host: localhost:8080
Date: Sat, 31 Oct 2026 22:09:30 GMT
Connection: close
X-Powered-By: PHP/8.5.11
Content-type: text/html; charset=UTF-8

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 com o Google Chrome sem interface gráfica:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Built-in web server. The PHP Group. <https://www.php.net/manual/en/features.commandline.webserver.php> (acessado em 2026-10-31)
2. PHP tags. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phptags.php> (acessado em 2026-10-31)
3. Escaping from HTML. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.phpmode.php> (acessado em 2026-10-31)
4. Instruction separation. The PHP Group. <https://www.php.net/manual/en/language.basic-syntax.instruction-separation.php> (acessado em 2026-10-31)
5. echo. The PHP Group. <https://www.php.net/manual/en/function.echo.php> (acessado em 2026-10-31)
6. Description of core php.ini directives (`default_mimetype`, `default_charset`). The PHP Group. <https://www.php.net/manual/en/ini.core.php> (acessado em 2026-10-31)
7. PHP 5.4.0 Release Announcement. The PHP Group. <https://www.php.net/releases/5_4_0.php> (acessado em 2026-10-31)
8. PHP releases (JSON, version 5.4.0). The PHP Group. <https://www.php.net/releases/index.php?json&version=5.4.0> (acessado em 2026-10-31)
9. php-cli package (Debian stable). Debian. <https://packages.debian.org/stable/php-cli> (acessado em 2026-10-31)
10. Downloads (Windows). The PHP Group. <https://www.php.net/downloads.php?os=windows> (acessado em 2026-10-31)
