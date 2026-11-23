---
source: languages/rust/web/README.md
source_sha: 410ff741f7b8e2d094860dcc03080f63b3f06370
---
# Rust · web: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Rust](../README.md)

## O que é
Um servidor web em <http://localhost:8080/> (porta definida por `PORT`, padrão
`8080`) que responde a `GET /` com o HTML `<p>Hello, World!</p>`. O servidor
envia o próprio HTML; não há front-end separado.

A biblioteca padrão do Rust não tem servidor HTTP (a do Go tem `net/http`);
por isso dois crates (bibliotecas) fazem o trabalho:
- **Axum**, "an HTTP routing and request-handling library that focuses on
  ergonomics and modularity" [1] (tradução livre: "uma biblioteca de
  roteamento HTTP e tratamento de requisições que prioriza ergonomia e
  modularidade"): associa `/` a uma função.
- **Tokio**, o runtime assíncrono que executa essa função, "an event-driven,
  non-blocking I/O platform for writing asynchronous applications with the
  Rust programming language" [2] (tradução livre: "uma plataforma de E/S não
  bloqueante, orientada a eventos, para escrever aplicações assíncronas com a
  linguagem de programação Rust").

Compare com [../cli](../cli/): `main` não termina mais após uma linha. Ele
inicia um servidor e aguarda requisições até que Ctrl+C seja pressionado.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Rust 1.85 ou posterior (`rustc` + `cargo`) | Rust 1.98.1 (Homebrew) | compila o programa; baixa os crates |
| Axum | 0.8.9 (publicada em 2026-04-14) [9] | roteamento e respostas HTML; baixado por `cargo build` |
| Tokio | 1.54.1 (publicada em 2026-10-21) [9] | o runtime assíncrono; baixado por `cargo build` |
| curl | 8.x (nativo do macOS) | apenas para `./run.sh --verify` |

O Rust 1.85 é o mínimo porque `Cargo.toml` usa a edição 2024 (ver
[../cli](../cli/README.md#prerequisites)); o Tokio 1.54.1 declara o mesmo
mínimo e o Axum 0.8.9 declara 1.80 [9]. O Axum, o Tokio e os 46 crates de que
precisam (48 compilados no macOS no total, contados com `cargo tree`) são
dependências deste projeto, e não ferramentas do computador; por isso
`install.sh` não os instala: `cargo build` o faz.

## Início rápido
```sh
./install.sh   # check / install Rust (asks before installing)
./build.sh     # download the crates and compile (first time: about 40 s)
./run.sh       # serve on http://localhost:8080/ until Ctrl+C
```
Em seguida, abra <http://localhost:8080/> ou execute
`curl http://localhost:8080/`. Para usar outra porta, execute
`PORT=9000 ./run.sh`.

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Mesma verificação de [../cli](../cli/README.md#scripts-explained): Rust 1.85 ou posterior, ou o comando de instalação do rustup, se estiver ausente. | O Rust é compilado. |
| `build.sh` | Executa `cargo build --release --locked` | A primeira compilação baixa do crates.io todos os crates listados em `Cargo.lock` para o cache do Cargo (`~/.cargo/registry`), compila-os e depois compila `src/main.rs`. `--locked` faz a compilação falhar em vez de escolher silenciosamente outras versões [4]. Na máquina de teste, a primeira compilação levou cerca de 40 segundos; as seguintes recompilam apenas `main.rs`. |
| `run.sh` | Exporta `PORT` (padrão 8080) e executa `./target/release/hello-web`. Com `--verify`, inicia o servidor em segundo plano, obtém `/` uma vez com `curl` (aguardando até 10 s), imprime a resposta e encerra o servidor. | O executável já contém o Axum, o Tokio e o hyper; portanto, não há programa de servidor separado (compare com o Tomcat dentro do Spring Boot em [../../java/web](../../java/web/)). `exec` substitui o script pelo servidor, de modo que Ctrl+C interrompe o servidor diretamente. |

## Estrutura de pastas
```text
web/
├── README.md        this file
├── install.sh       checks / installs Rust
├── build.sh         downloads the crates and compiles
├── run.sh           starts the server
├── screenshot.png   the page in a browser, for "Expected output" below
├── Cargo.toml       the manifest: name, edition, and the dependencies axum and tokio
├── Cargo.lock       the exact version of all 48 crates (written by cargo)
├── src/
│   └── main.rs      the program
└── target/          created by build.sh; not committed
    └── release/
        └── hello-web
```
- O mesmo layout do Cargo de [../cli](../cli/README.md#folder-structure):
  "The default executable file is src/main.rs" [3] (tradução livre: "O
  arquivo executável padrão é src/main.rs").
- **`[dependencies]`** em `Cargo.toml` tem duas linhas. `axum = "0.8"` é um
  requisito caret, "the default version requirement strategy" [5] (tradução
  livre: "a estratégia padrão de requisito de versão"). Para versões abaixo
  de 1.0, o segundo número conta como o principal: "0.2.3 := >=0.2.3,
  <0.3.0" [5]; assim, `"0.8"` aceita a 0.8.9, mas nunca a 0.9.
- **`features = [...]`** no Tokio: "Features of dependencies can be enabled
  within the dependency declaration" [6] (tradução livre: "Os recursos das
  dependências podem ser habilitados na própria declaração da dependência").
  O Tokio desativa a maioria de suas partes por padrão; este programa precisa
  do runtime multithread (`rt-multi-thread`), do atributo `#[tokio::main]`
  (`macros`) e de TCP (`net`).
- **`Cargo.lock`** lista cada crate com sua versão e soma de verificação, de
  modo que todo estudante compila o mesmo código. Ele é versionado [7], como
  o `go.sum` em [../../go/desktop](../../go/desktop/) e o `package-lock.json`
  em projetos npm. Os crates baixados não ficam nesta pasta (diferentemente de
  `node_modules/`): o Cargo mantém um único cache compartilhado em
  `~/.cargo/registry`.

## Passo a passo
Abra [`src/main.rs`](src/main.rs) ao lado desta lista.

1. **`use axum::{Router, response::Html, routing::get};`** traz três nomes do
   crate `axum` para o escopo, como o `import` do Go ou o `from ... import` do
   Python.
2. **`async fn hello() -> Html<&'static str>`** é o tratador.
   - `async fn` não executa seu corpo imediatamente: ela retorna uma *future*
     que um runtime executa depois. "Rust lets you choose [a runtime]
     depending on your requirements, rather than providing one" [8] (tradução
     livre: "O Rust permite escolher [um runtime] conforme os requisitos, em
     vez de fornecer um"); este programa escolhe o Tokio. Enquanto uma
     requisição aguarda a rede, o Tokio executa outras nas mesmas threads.
   - `Html(...)` é "An HTML response" (tradução livre: "Uma resposta HTML") e
     vai "automatically get Content-Type: text/html" [1] (tradução livre:
     "receber automaticamente Content-Type: text/html").
   - `&'static str` é uma string emprestada que vive tanto quanto o programa:
     o texto é uma constante dentro do executável.
   - Não há `return` nem ponto e vírgula na última linha: a última expressão
     de um bloco do Rust é o seu valor.
3. **`#[tokio::main]`** "Marks async function to be executed by the selected
   runtime" [2] (tradução livre: "Marca a função assíncrona para ser
   executada pelo runtime selecionado"). O livro de programação assíncrona o
   explica: ele "initializes the Tokio runtime and starts an async task for
   running the code in main" [8] (tradução livre: "inicializa o runtime do
   Tokio e inicia uma tarefa assíncrona para executar o código em main").
   Sem ele, `main` não poderia ser `async`.
4. **`std::env::var("PORT").unwrap_or_else(|_| "8080".to_string())`** lê a
   porta. `env::var` retorna um `Result`: `Ok(value)` ou `Err`, quando a
   variável não está definida. `unwrap_or_else` transforma um `Err` no valor
   padrão. O Rust não tem `null` nem exceções: um valor ausente é um valor de
   retorno comum que o código precisa tratar (compare com o `if port == ""` do
   Go).
5. **`Router::new().route("/", get(hello))`** associa `GET /` a `hello`. Qualquer
   outro caminho recebe `404 Not Found`. "get routes will also be called for
   HEAD requests but will have the response body removed" [1] (tradução livre:
   "as rotas get também serão chamadas para requisições HEAD, mas terão o corpo
   da resposta removido").
6. **`TcpListener::bind(&addr).await.expect(...)`** escuta em
   `127.0.0.1:8080`, somente neste computador. `.await` aguarda a future sem
   bloquear uma thread; `.expect` interrompe o programa com essa mensagem se a
   ligação falhar, por exemplo quando a porta já está em uso.
7. **`axum::serve(listener, app).await`** "Serve[s] the service with the
   supplied listener" [1] (tradução livre: "Serve o serviço com o listener
   fornecido"), para sempre, até que o programa seja interrompido.

## Por que esta toolchain
- **Uso:** no Stack Overflow Developer Survey 2026, 3,6% dos 10.281
  respondentes da pergunta sobre frameworks web usaram o Axum, e 70,6% deles
  querem continuar a usá-lo ("admired") [10]. Ele vive na organização do
  projeto Tokio no GitHub (`github.com/tokio-rs/axum`) [1].
- **O Axum se apoia na pilha do Tokio em vez de inventar a sua:** "axum is
  designed to work with tokio and hyper" e "doesn't have its own middleware
  system but instead uses tower::Service" [1] (tradução livre: "o axum foi
  projetado para funcionar com tokio e hyper" e "não tem um sistema próprio de
  middleware, mas usa tower::Service"). Aprendê-lo ensina as bibliotecas que a
  maior parte do código Rust assíncrono usa.
- **Código pequeno:** o servidor inteiro tem 15 linhas de Rust sem comentários,
  próximo de [../../go/web](../../go/web/) (23) e de
  [../../python/web](../../python/web/) (Flask).

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-10-31) | Rust 1.98.1, Axum 0.8.9, Tokio 1.54.1. O executável tem 1,6 MB. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos. |
| Linux (Debian/Ubuntu) | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` baixa o script instalador do rustup de `https://sh.rustup.rs` [10] e o executa quando o Rust 1.85 ou posterior não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Rust: se o Rust 1.85 ou posterior não existe, ele imprime `winget install --id Rustlang.Rustup -e` [13] e para. O rustup exige as Build Tools C++ do Visual Studio [14]. |

**O script do rustup não tem verificação de checksum.** O rustup publica arquivos
SHA-256 para os programas `rustup-init`, mas não para o script `rustup-init.sh`
por trás de `https://sh.rustup.rs` [18], e esse script muda a cada versão do
rustup. Por isso, o `install.sh` o salva em
`~/.cache/hello-world-rust/rustup-init.sh` e mostra o caminho, para que você
possa ler o script antes de responder `y` para executá-lo.

## Saída esperada
`./run.sh` imprime as linhas a seguir e continua em execução:
```text
==> Start the web server on http://localhost:8080
    WHY: target/release/hello-web listens on 127.0.0.1 (this computer only) and answers GET /.
    Open http://localhost:8080/ in your browser. Stop with Ctrl+C.
Listening on http://localhost:8080/
```

Em um navegador, a página tem esta aparência:

![Uma página de navegador exibindo "Hello, World!"](screenshot.png)

(Captura feita em 2026-10-31 no macOS Intel com o Chrome sem interface gráfica:
`--headless=new --screenshot --window-size=640,240`.)

`curl -i http://localhost:8080/` mostra os cabeçalhos que o Axum envia:
```text
HTTP/1.1 200 OK
content-type: text/html; charset=utf-8
content-length: 20
date: Sat, 31 Oct 2026 21:26:29 GMT

<p>Hello, World!</p>
```

## Fontes
1. `axum` 0.8.9 documentation (crate overview, `Html`, `routing::get`, `serve`). docs.rs. <https://docs.rs/axum/0.8.9/axum/> (acessado em 2026-10-31)
2. `tokio` 1.54.1 documentation (crate overview, attribute macro `main`). docs.rs. <https://docs.rs/tokio/1.54.1/tokio/> (acessado em 2026-10-31)
3. The Cargo Book: Package Layout. The Rust Project. <https://doc.rust-lang.org/cargo/guide/project-layout.html> (acessado em 2026-10-31)
4. The Cargo Book: `cargo build` (`--release`, `--locked`). The Rust Project. <https://doc.rust-lang.org/cargo/commands/cargo-build.html> (acessado em 2026-10-31)
5. The Cargo Book: Specifying Dependencies (caret requirements). The Rust Project. <https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html> (acessado em 2026-10-31)
6. The Cargo Book: Features (dependency features). The Rust Project. <https://doc.rust-lang.org/cargo/reference/features.html> (acessado em 2026-10-31)
7. The Cargo Book: Cargo.toml vs Cargo.lock. The Rust Project. <https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html> (acessado em 2026-10-31)
8. Asynchronous Programming in Rust: async and await. The Rust Async Working Group. <https://rust-lang.github.io/async-book/part-guide/async-await.html> (acessado em 2026-10-31)
9. crates.io API: `axum` 0.8.9, `tokio` 1.54.1 (publish date, `rust_version`). crates.io. <https://crates.io/api/v1/crates/axum/0.8.9> and <https://crates.io/api/v1/crates/tokio/1.54.1> (acessado em 2026-10-31)
10. Stack Overflow Developer Survey 2026: Technology data (web frameworks and technologies). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
18. The rustup book: Other installation methods. The Rust Project. <https://rust-lang.github.io/rustup/installation/other.html> (acessado em 2026-11-19)
