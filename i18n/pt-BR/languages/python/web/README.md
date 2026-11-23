---
source: languages/python/web/README.md
source_sha: 3cd3f336d7f3592a32b3dc31a9eb40eca06aec81
---
# Python · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Python](../README.md)

## O que é
Um pequeno servidor web escrito com o Flask. Quando um navegador solicita
`http://localhost:8080/`, o servidor responde com o HTML
`<p>Hello, World!</p>`, que o navegador exibe como o texto **Hello, World!**.
O servidor envia o próprio HTML; não há front-end separado.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Python 3 (`python3.14` no macOS, `python3` nos demais) | 3.14.10 (`python@3.14` do Homebrew) | executa o Flask e `app.py` |
| Flask | 3.1.3 (fixada em `requirements.txt`) | o framework web; `install.sh` o instala em `.venv/` |
| curl | curl do sistema | apenas para `./run.sh --verify` e para testes manuais |

O Flask 3.1 "supports Python 3.9 and newer" [2] (tradução livre: "oferece
suporte ao Python 3.9 e posteriores").

No macOS, os scripts chamam `python3.14`, e não `python3`. O `python@3.14` do
Homebrew coloca no PATH apenas nomes com versão; "Unversioned names such as
`python` ... are installed into `$(brew --prefix python)/libexec/bin`" [15]
(tradução livre: "Nomes sem versão, como `python` ..., são instalados em
`$(brew --prefix python)/libexec/bin`"), e um `python3` simples no macOS
costuma ser o `/usr/bin/python3` da Apple, mais antigo. O instalador do
python.org também fornece `python3.14`. Defina `PYTHON=python3` (ou qualquer
outro comando) para alterar esse comportamento.

## Início rápido
```sh
./install.sh   # check Python, create .venv/, install Flask (asks first)
./run.sh       # serve on http://localhost:8080 until Ctrl+C
```
Abra <http://localhost:8080/> em um navegador ou, em um segundo terminal,
execute `curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | 1. Verifica o interpretador (`python3.14` no macOS, `python3` nos demais) e mostra como instalá-lo. 2. Cria o ambiente virtual `.venv/` com `python3.14 -m venv .venv`. 3. Instala o Flask com `.venv/bin/python -m pip install -r requirements.txt`. Os passos 2 e 3 perguntam antes. | O Flask é um pacote de terceiros. A documentação do Flask recomenda "use a virtual environment to manage the dependencies for your project" [2] (tradução livre: "usar um ambiente virtual para gerenciar as dependências do seu projeto"). Um venv tem "its own independent set of Python packages" [3] (tradução livre: "seu próprio conjunto independente de pacotes Python"); assim, nada é instalado no Python do sistema. |
| `run.sh` | Inicia `.venv/bin/flask --app app run --port 8080`. `--verify` o inicia em segundo plano, obtém a página uma vez com `curl` e depois o encerra. | `flask run` inicia o servidor de desenvolvimento do Flask [4]. A autoverificação permite que `scripts/verify-all.sh` teste o servidor sem esperar por Ctrl+C. |

Não há `build.sh`, porque o Python é interpretado, como na
[versão cli](../cli/README.md#why-there-is-no-build-step).

## Estrutura de pastas
```text
web/
├── README.md         this file
├── install.sh        checks Python, creates .venv/, installs Flask
├── run.sh            starts the server
├── app.py            the web application (Flask's minimal app)
├── requirements.txt  the packages to install, with pinned versions
└── .venv/            created by install.sh; not committed (see ../../../.gitignore)
```
- `app.py` é o nome de módulo que o `flask` procura primeiro: "If `--app` is
  not set, the command will try to import 'app' or 'wsgi'" [5] (tradução
  livre: "Se `--app` não for definido, o comando tentará importar 'app' ou
  'wsgi'"). `run.sh` ainda passa `--app app` para que o comando diga o que
  executa.
- `requirements.txt` é o formato de arquivo que `pip install -r` lê [6].
- `.venv` é o nome de pasta que o guia de instalação do Flask usa [2].
- Uma aplicação Flask maior se tornaria uma pasta de pacote com `templates/` e
  `static/`, como no tutorial do Flask [7]. Uma única página não precisa de
  nenhuma das duas.

## Passo a passo
Abra [`app.py`](app.py) ao lado desta lista.

1. **`from flask import Flask`** carrega a classe `Flask` do pacote
   instalado. Diferentemente da [versão cli](../cli/hello.py), que usa apenas
   o `print` embutido, este programa depende de uma biblioteca do PyPI.
2. **`app = Flask(__name__)`** cria a aplicação. O primeiro argumento é "the
   name of the application's module or package" (tradução livre: "o nome do
   módulo ou pacote da aplicação"), e o Flask precisa dele "so that Flask
   knows where to look for resources such as templates and static files" [1]
   (tradução livre: "para que o Flask saiba onde procurar recursos como
   templates e arquivos estáticos").
3. **`@app.route("/")`** é um decorador. Ele informa ao Flask "what URL should
   trigger our function" [1] (tradução livre: "qual URL deve acionar nossa
   função"). Os outros frameworks deste repositório registram rotas à sua
   maneira: o Express usa `app.get("/", ...)`, o Spring Boot usa
   `@GetMapping("/")` e o Go usa `http.HandleFunc("/", ...)`.
4. **`return "<p>Hello, World!</p>"`**: quando uma view retorna uma string, o
   Flask a converte em uma resposta "with the string as response body, a 200
   OK status code and a text/html mimetype" [1] (tradução livre: "com a
   string como corpo da resposta, o código de status 200 OK e o mimetype
   text/html"). É possível ver isso na saída de `curl -i` abaixo.
5. **Sem `main`, sem laço.** O arquivo apenas define a aplicação. O comando
   `flask run` a importa e executa o laço do servidor que aguarda
   requisições. Esta é a maior diferença em relação à versão cli, que executa
   uma vez e termina.

## Por que esta toolchain
- O **Flask** descreve a si mesmo como "a lightweight WSGI web application
  framework", "designed to make getting started quick and easy" [8]
  (tradução livre: "um framework leve de aplicações web WSGI", "projetado para
  tornar o início rápido e fácil"). Uma página Hello World leva 5 linhas de
  código, o que atende ao objetivo deste repositório de manter cada programa
  o mais simples e direto possível.
- O Flask está entre os frameworks web Python mais usados. Na Python
  Developers Survey 2024 (PSF e JetBrains, respostas de outubro e novembro de
  2024), o FastAPI foi usado por 38%, o Django por 35% e o Flask por 34% dos
  respondentes [9]. No Stack Overflow Developer Survey 2026, 12,5% de todos os
  respondentes da pergunta sobre frameworks web usaram o Flask [10].
- Esta página não usa os outros dois. Um projeto Django começa com
  `django-admin startproject`, que gera um `manage.py` e um pacote de
  configurações (`settings.py`, `urls.py`, `asgi.py`, `wsgi.py`) [12]. O
  FastAPI é "a web framework for building APIs" [13] (tradução livre: "um
  framework web para construir APIs"). O Flask serve uma string HTML a partir
  de um único arquivo, que é a configuração mais simples para um Hello World
  em HTML.
- **A porta 8080**, em vez da usual 5000 do Flask: "macOS Monterey and later
  automatically starts a service that uses port 5000" (AirPlay Receiver) [4]
  (tradução livre: "o macOS Monterey e posteriores iniciam automaticamente um
  serviço que usa a porta 5000"). A porta 8080 também é a convenção deste
  repositório para toda implementação web.
- **Somente servidor de desenvolvimento.** O Flask alerta: "Do not use the
  development server when deploying to production" [4] (tradução livre: "Não
  use o servidor de desenvolvimento ao implantar em produção"). Uma
  implantação em produção precisa de um servidor WSGI, o que está fora do
  escopo de um programa Hello World.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Python 3.14.10 (Homebrew), Flask 3.1.3. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos do Intel. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` instala `python3` e `python3-venv` com o apt quando faltam [14]. Ele cria o `.venv` e instala o Flask a partir de `requirements.txt` com o pip. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Python: se o interpretador (`PYTHON`, padrão `python3`) não existe, ele imprime os passos do `winget` e de `py install 3.14` e para. [11] Ele cria o `.venv` (encontra o `.venv/Scripts/` automaticamente) e instala o Flask a partir de `requirements.txt` com o pip. O WSL não foi verificado; ele se comporta como o Linux. |

## Saída esperada
`./run.sh` (o servidor continua em execução até Ctrl+C):
```text
==> Start the web server on http://localhost:8080
    WHY: 'flask --app app run' imports app.py and serves it on 127.0.0.1 (this computer only).
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
 * Serving Flask app 'app'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:8080
Press CTRL+C to quit
```
Em um segundo terminal:
```text
$ curl -i http://localhost:8080/
HTTP/1.1 200 OK
Server: Werkzeug/3.1.9 Python/3.14.10
Date: Fri, 30 Oct 2026 18:29:54 GMT
Content-Type: text/html; charset=utf-8
Content-Length: 20
Connection: close

<p>Hello, World!</p>
```
O navegador exibe: **Hello, World!**

![A página em http://localhost:8080/ exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 com o Google Chrome sem interface gráfica:
`chrome --headless=new --window-size=640,240 --screenshot=screenshot.png http://localhost:8080/`.)

## Fontes
1. Quickstart. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/quickstart/> (acessado em 2026-10-30)
2. Installation. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/installation/> (acessado em 2026-10-30)
3. venv: Creation of virtual environments. Python Software Foundation. <https://docs.python.org/3/library/venv.html> (acessado em 2026-10-30)
4. Development Server. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/server/> (acessado em 2026-10-30)
5. Command Line Interface. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/cli/> (acessado em 2026-10-30)
6. Requirements File Format. pip documentation. <https://pip.pypa.io/en/stable/reference/requirements-file-format/> (acessado em 2026-10-30)
7. Project Layout (Tutorial). Flask (Pallets). <https://flask.palletsprojects.com/en/stable/tutorial/layout/> (acessado em 2026-10-30)
8. Welcome to Flask. Flask (Pallets). <https://flask.palletsprojects.com/en/stable/> (acessado em 2026-10-30)
9. Python Developers Survey 2024 Results. Python Software Foundation and JetBrains. <https://lp.jetbrains.com/python-developers-survey-2024/> (acessado em 2026-10-30)
10. 2026 Stack Overflow Developer Survey: Technology. Stack Overflow. <https://survey.stackoverflow.co/2026/technology> (acessado em 2026-10-30)
11. Using Python on Windows. Python Software Foundation. <https://docs.python.org/3/using/windows.html> (acessado em 2026-10-30)
12. Writing your first Django app, part 1. Django Software Foundation. <https://docs.djangoproject.com/en/stable/intro/tutorial01/> (acessado em 2026-10-30)
13. FastAPI. FastAPI documentation. <https://fastapi.tiangolo.com/> (acessado em 2026-10-30)
14. python3-venv package (Debian stable). Debian. <https://packages.debian.org/stable/python3-venv> (acessado em 2026-10-30)
15. Language Runtimes and Packages. Homebrew. <https://docs.brew.sh/Language-Runtimes-and-Packages> (acessado em 2026-10-31)
