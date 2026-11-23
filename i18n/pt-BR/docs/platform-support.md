---
source: docs/platform-support.md
source_sha: 1de62643267b54d64fa7eaa5f45bd1f0edfbf1bf
---
# Suporte a plataformas

Esta página informa onde se sabe que os programas deste repositório
funcionam, como isso é verificado e o que não é verificado.

## Resumo
| Plataforma | Situação |
|---|---|
| macOS em Intel (x86-64) | ✅ verificado na máquina de desenvolvimento (as Notas por plataforma de cada README informam a data) |
| macOS em Apple Silicon | ⚠️ não verificado, exceto a [aplicação iOS em Swift](../languages/swift/mobile-ios/README.md) em um runner de CI |
| Linux (Ubuntu, x86-64) | ✅ verificado no CI em 2026-11-06: as 67 implementações dessa execução. ⚠️ Não verificadas no CI: as implementações adicionadas depois dela |
| Windows (Git Bash) | ✅ verificado no CI em 2026-11-06: as 66 implementações dessa execução (a [aplicação desktop em Lua](../languages/lua/desktop/README.md) foi ignorada). ⚠️ Não verificadas no CI: as implementações adicionadas depois dela |
| Windows (WSL) | ⚠️ não verificado |

**Verificado** significa que a implementação foi instalada, compilada e
executada nessa plataforma e exibiu `Hello, World!`. **Verificado no CI**
significa que a mesma verificação foi executada em uma máquina virtual
hospedada pelo GitHub, na data informada (veja
[Linux e Windows no CI](#linux-e-windows-no-ci)). **Não verificado**
significa que o README fornece os comandos para essa plataforma, extraídos da
documentação oficial da toolchain, mas ninguém os executou nela ainda. O
README de cada implementação tem uma tabela **Notas por plataforma** com a situação
exata, a data e os comandos de cada plataforma.

## Como uma implementação é verificada
O `scripts/verify-all.sh` executa cada pasta de implementação como um
leitor a executaria e só a aprova quando todas as etapas terminam com
status 0 e a saída contém `Hello, World!`:
1. `install.sh`, que verifica a toolchain (e pergunta antes de instalar
   qualquer coisa);
2. `build.sh`, para as linguagens compiladas;
3. `run.sh --verify`, uma autoverificação que termina por conta própria:

| Categoria | O que o `run.sh --verify` faz |
|---|---|
| cli | executa o programa; ele exibe `Hello, World!` |
| desktop | abre a janela; o programa exibe `Hello, World!` e fecha a janela após cerca de 2 s |
| web | inicia o servidor, obtém a página com `curl`, exibe a resposta e encerra o servidor |

É possível executá-lo manualmente, para todas as pastas ou para uma só:
```sh
scripts/verify-all.sh
scripts/verify-all.sh python/cli
```

As implementações web são executadas em portas livres próprias (a partir de
18000, de modo que um servidor iniciado na 8080 não interfere), e o
`verify-all.sh` encerra tudo o que cada pasta deixa em execução, inclusive
quando você pressiona Ctrl+C.

## Última verificação completa
A última verificação completa foi executada em 2026-11-02 no macOS 26.7.2,
Intel x86-64. Ela partiu de um `git clone` novo da tag `v1.0.0-rc.1`, a
versão candidata da `v1.0.0`; a `v1.0.0` final alterou apenas arquivos de
documentação, nenhum código ou script. Em cada pasta, o `install.sh` foi
respondido com "sim" a todas as perguntas; em seguida, o
`scripts/verify-all.sh` executou todas as pastas:

```text
Summary: 46 passed, 0 failed, 1 documented only
```

A única pasta **somente documentada** é o
[pseudocódigo CLRS](../languages/pseudocode/clrs/README.md): é uma notação de
livro didático, sem interpretador, de modo que não há o que executar. A
situação atual de cada implementação está na tabela de
[todas as implementações](../languages/README.md#all-implementations).

## Linux e Windows no CI
O workflow [`.github/workflows/ci-matrix.yml`](../.github/workflows/ci-matrix.yml)
executa a mesma verificação no GitHub Actions, um job por linguagem e por
sistema:

```sh
scripts/verify-all.sh --install languages/<language>
```

O `--install` permite que o `install.sh` instale, sem perguntar, o que
estiver faltando, porque cada runner é uma máquina virtual nova, descartada
após o job. No Linux, os programas desktop desenham em um display X virtual
(Xvfb). Algumas toolchains já estão nas imagens dos runners (por exemplo, Go,
.NET, Node.js, PHP, Python e Rust). Para essas, o `install.sh` apenas
verifica a versão encontrada; em uma máquina sem elas, ele exibe as etapas de
instalação e para, como informam as Notas por plataforma de cada README.
As pastas que não podem ser executadas em um sistema são listadas, com o
motivo e uma fonte, em [`ci/skip.yml`](../ci/skip.yml), e o `verify-all.sh`
as exibe como ignoradas. Há uma: a aplicação desktop em Lua no Windows. O
runner não tem GPU, e o LÖVE exige OpenGL 2.1 ou posterior.

A última execução aprovada foi em 2026-11-06, no branch `develop`; ela
executou todas as implementações que existiam nesse dia. As execuções
posteriores pararam antes de executar qualquer implementação; portanto, não
verificam nada:

| Rótulo do runner | Imagem | Resultado |
|---|---|---|
| `ubuntu-latest` | Ubuntu 26.04, x86-64 | 67 aprovadas, 0 reprovadas, 1 somente documentada |
| `windows-latest` | Windows Server 2025, Git Bash | 66 aprovadas, 0 reprovadas, 1 ignorada, 1 somente documentada |

As implementações adicionadas depois desse dia (por exemplo, as pastas de
Dart, Swift, Objective-C e Smalltalk) **não foram verificadas no CI**: suas
linhas de Linux e Windows informam **não verificado**, e a linha de macOS
Intel informa o resultado na máquina de desenvolvimento. Uma implementação
aprovada em 2026-11-06 pode ter mudado desde então; a linha de macOS Intel
dela informa a data da última verificação. A tabela Notas por plataforma de cada
README informa qual caso se aplica.

Os rótulos dos runners e o software de cada imagem estão listados no
repositório [GitHub Actions runner images](https://github.com/actions/runner-images).
No Windows, o `bash` em um workflow é o Git Bash que acompanha a imagem
([workflow syntax: `defaults.run.shell`](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#defaultsrunshell)).

## Limites conhecidos
- **Três plataformas verificadas.** O macOS em Intel é verificado na máquina
  de desenvolvimento; o Linux (Ubuntu em x86-64) e o Windows (Git Bash) foram
  verificados no CI em 2026-11-06, para as implementações que existiam então.
  O macOS em Apple Silicon, outras distribuições Linux, o Linux em ARM e o WSL
  são documentados, não testados.
- **A máquina já tinha as toolchains.** O clone limpo foi executado em um
  computador que já tinha os compiladores instalados. O `install.sh` instalou
  todas as dependências de cada projeto (npm, Maven, Cargo, NuGet e outras) no
  clone novo e sugere a instalação no sistema para tudo o que estiver
  faltando. Uma máquina sem nenhuma toolchain não foi testada.
- **As janelas desktop são verificadas pelo próprio programa.** O
  `run.sh --verify` abre e fecha a janela automaticamente. As capturas de tela
  dos READMEs desktop foram feitas e conferidas visualmente.
- **Os números de mercado envelhecem.** Os números do TIOBE e do Stack
  Overflow nas páginas das linguagens são datados ("October 2026", "2026") e
  cada fonte tem sua data de acesso, como exige [Sobre as fontes](sources.md).

Se executar uma implementação em uma plataforma marcada como **não
verificada**, informe o resultado; consulte
[CONTRIBUTING.md](../CONTRIBUTING.md).
