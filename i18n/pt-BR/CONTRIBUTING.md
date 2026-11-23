---
source: CONTRIBUTING.md
source_sha: 4e61a9bee58c879364ea4a0e212d93142620bfbc
---
# Como contribuir

Obrigado pela ajuda. Este repositório é um recurso didático, portanto toda
alteração deve manter três compromissos: os programas executam, todo fato
tem fonte e as explicações são claras para quem as lê pela primeira vez.

## Formas de ajudar
- **Relatar um fato incorreto ou um link quebrado.** Abra uma issue com a
  página, a frase e uma fonte que mostre o fato correto (consulte
  [Sobre as fontes](docs/sources.md)).
- **Relatar o resultado em uma plataforma.** A maioria das implementações é
  verificada somente em macOS Intel (consulte
  [Suporte a plataformas](docs/platform-support.md)). Quem executou uma
  delas em Linux, Windows ou Apple Silicon pode abrir uma issue com a
  pasta, o sistema operacional e sua versão, os comandos executados e a
  saída deles.
- **Corrigir ou melhorar uma implementação**, ou **adicionar uma nova**,
  seguindo as convenções abaixo, por meio de um pull request.

Os pull requests são revisados pelo mantenedor. Uma alteração aceita é
publicada na próxima versão.

## Estrutura do repositório
```text
README.md                    short intro + language table (generated part)
CONTRIBUTING.md              this file
CHANGELOG.md                 what changed in each release
LICENSE                      MIT License, for code
LICENSE-docs                 CC BY 4.0, for prose and images
NOTICE                       third-party files and their licenses
SECURITY.md                  how to report a security problem
CITATION.cff                 how to cite this repository
.gitignore .gitattributes    files git ignores; line endings per file type
.vale.ini  .vale/            prose style rules, read by scripts/check-prose.sh
.github/workflows/           GitHub Actions workflows (CI, iOS, site, release)
.github/dependabot.yml       automatic dependency update requests
ci/skip.yml                  folders verify-all.sh skips on one OS, with the reason
ci/timeouts.yml              folders that need a longer step timeout, with the reason
docs/start-here.md           where a new reader should begin
docs/about.md                purpose, audience, licenses and maintainer
docs/paradigms.md            the four core paradigms, plus concurrency and quantum
docs/comparisons.md          comparisons between languages
docs/ai-new-paradigm.md      closing essay
docs/off-the-record.md       light remarks and jokes about each language
docs/sources.md              which sources are accepted and how they are cited
docs/platform-support.md     where the programs are verified
docs/templates/              templates for READMEs and scripts
docs/contributing/           style guide, glossary of terms, translation guide
i18n/<locale>/               translations of the published pages
site/                        the website project (no content of its own)
scripts/approved.py          checks the folders, the site, the ZIPs and the export against languages/APPROVED.txt
scripts/build-site.sh        builds the website from languages/ and docs/
scripts/check-category-status.py   checks that each status in meta.yml is verified or explained in ci/skip.yml
scripts/check-downloads.sh   checks that every ZIP holds the files its scripts source
scripts/check-impl-table.py  checks that each language README table matches meta.yml
scripts/check-language.sh    checks that a language folder is complete
scripts/check-links.sh       checks every relative link in the READMEs
scripts/check-missing-categories.py   checks that a language README explains each missing category
scripts/check-product.sh     checks that published files hold no maintenance notes
scripts/check-prose.sh       checks the prose against the style guide (Vale)
scripts/check-sources.sh     requests every external URL (needs the network)
scripts/check-translations.sh  lists which translated pages are current, outdated or missing
scripts/common.sh            shared shell helpers
scripts/export-public.sh     copies the published files of a release into a folder
scripts/gen-readme.py        writes the generated tables from every meta.yml
scripts/package-downloads.sh packs one download ZIP per implementation
scripts/public-paths.txt     the paths that are published
scripts/stop-all.sh          stops processes left running (all or per language)
scripts/test-check-language.sh   checks that check-language.sh fails on broken input
scripts/use-runner-jdk.sh    picks JDK 21 on Windows (sourced by Java, Clojure, Kotlin)
scripts/verify-all.sh        runs every implementation (local CI)
languages/APPROVED.txt       the approved list: every language and its category folders
languages/README.md          every implementation (generated) + meta.yml schema
languages/<language>/README.md     language overview
languages/<language>/meta.yml      facts about the language, read by gen-readme.py
languages/<language>/<category>/   one implementation
languages/<language>/*.sh          Windows helpers that several categories source:
                                   msys2-env.sh and use-msys2-*.sh put MSYS2's
                                   tools first on PATH
languages/ruby/msys2-bin/          a bundle wrapper, so Git Bash can start
                                   MSYS2's Bundler on Windows
```
- `<language>` é qualquer nome de pasta em `languages/`. A lista atual é a
  tabela gerada em
  [`languages/README.md`](languages/README.md#all-implementations).
- `<category>` é `cli`, `desktop`, `web`, `web-<front end>` (uma aplicação web
  com front-end separado, por exemplo `web-react` ou `web-rails`) ou
  `mobile-<platform>` (por exemplo `mobile-android` ou `mobile-ios`). A mesma
  tabela lista todas as pastas de categoria em uso. Em `web`, o próprio
  servidor envia o HTML.
- Uma segunda versão da mesma categoria recebe um sufixo:
  `<category>-<variant>` (por exemplo, `java/desktop-swing`). O pseudocódigo
  não tem categorias, de modo que suas pastas levam o nome do dialeto
  (`pseudocode/portugol`, `pseudocode/pseint`, `pseudocode/clrs`).
- Uma pasta **somente documentada** (por exemplo, `pseudocode/clrs`, que
  não tem interpretador) tem README, mas não tem scripts.
  `scripts/verify-all.sh` a lista como ignorada, e o README da raiz a marca
  com 📄.
- Na documentação, `<language>/<category>` (por exemplo, `python/cli`) é
  abreviação de `languages/<language>/<category>`. O
  `scripts/verify-all.sh` aceita as duas formas.
- Cada implementação é autocontida. Ela nunca importa da pasta de outra
  implementação. O único arquivo compartilhado que usa é
  `scripts/common.sh`.

## Início de uma nova implementação
Adicionar (ou remover) uma linguagem ou uma categoria começa em
[`languages/APPROVED.txt`](languages/APPROVED.txt): adicione a linha da
linguagem ou a pasta da categoria à linha dela. As verificações comparam cada
pasta com essa lista; assim, uma pasta que não consta nela falha, e uma pasta
listada que está ausente também.
```sh
mkdir -p languages/python/cli
cp docs/templates/impl/README.md docs/templates/impl/*.sh languages/python/cli/
rm languages/python/cli/build.sh   # interpreted languages have no build step
# then fill every TODO(template) and every <placeholder>, and delete the
# TEMPLATE paragraph / comment at the top of each file
grep -rn 'TODO(template)\|TEMPLATE' languages/python/cli   # must print nothing
```
Para uma nova linguagem, copie também `docs/templates/language/README.md`
para `languages/<language>/README.md` e escreva
`languages/<language>/meta.yml` (esquema:
[`languages/README.md`](languages/README.md#metayml-schema)). Toda nova
implementação ganha uma entrada em `categories:` no `meta.yml` de sua
linguagem. Em seguida, regenere as tabelas:
```sh
python3 scripts/gen-readme.py           # rewrites the generated parts
python3 scripts/gen-readme.py --check   # exit 1 if they are out of date
```

## Contrato dos scripts
Toda implementação tem `install.sh` e `run.sh`, além de `build.sh` quando a
linguagem é compilada. Cada script:
- é `sh` POSIX, começa com `set -eu`, executa `cd` para a própria pasta e
  carrega (`source`) `../../../scripts/common.sh`;
- tem um bloco de cabeçalho com **WHAT**, **WHY**, **HOW** e **Platforms**;
- anuncia cada etapa com `step` e diz por que ela é necessária com
  `explain`, de modo que o estudante lê os motivos enquanto o script
  executa;
- nunca executa `sudo` nem instala algo sem perguntar (`install_pkg`).

As configurações que vários scripts de uma mesma implementação
compartilham (a versão de uma toolchain, seu checksum, sua pasta de
instalação) ficam em um arquivo `<tool>-env.sh` na mesma pasta, por
exemplo `languages/pascal/cli/fpc-env.sh`. Ele é **carregado (`source`),
não executado**: começa com `# shellcheck shell=sh`, tem um cabeçalho
WHAT/WHY, apenas define variáveis (e o `PATH`) e não é executável
(`chmod 644`).

`run.sh --verify` é a autoverificação usada por `scripts/verify-all.sh`.
Ele deve terminar por conta própria e imprimir `Hello, World!` na saída
padrão:

| Categoria | `./run.sh` | `./run.sh --verify` |
|---|---|---|
| cli | imprime `Hello, World!` | o mesmo |
| web | atende em `http://localhost:$PORT` até Ctrl+C | inicia o servidor, imprime a resposta do `curl` e encerra o servidor |
| desktop | abre uma janela que mostra `Hello, World!` | inicia a aplicação com `TF_VERIFY=1`: a aplicação imprime `Hello, World!` e fecha a janela após cerca de 2 segundos |

Os servidores web usam `PORT` (padrão `8080`, documentado no README).

O `scripts/verify-all.sh` concede a cada etapa (`install.sh`, `build.sh`,
`run.sh --verify`) 300 segundos (`TF_VERIFY_TIMEOUT`). Uma pasta cuja etapa a
frio foi medida e leva mais tempo recebe seu próprio limite em
`ci/timeouts.yml`, com o motivo. Adicione uma entrada apenas para um tempo a
frio medido mais uma margem: o limite ainda reprova uma etapa travada; por
isso, nunca deve ser aumentado para escondê-la.

Verifique tudo com:
```sh
scripts/verify-all.sh                 # all implementations
scripts/verify-all.sh python/cli      # one implementation (languages/ is optional)
scripts/check-links.sh                # every relative link and #anchor
scripts/check-sources.sh              # every external URL answers (network; run before a release)
python3 scripts/gen-readme.py --check # generated tables match every meta.yml
scripts/check-language.sh python      # one language is complete (no argument: all)
scripts/check-downloads.sh            # every download ZIP holds the files its scripts source
```

O `scripts/check-sources.sh` coleta todas as URLs `http(s)` dos arquivos
Markdown, YAML, shell e do site, requisita cada uma com `curl` e imprime um
resumo. Uma URL passa quando responde 2xx após os redirecionamentos. Uma URL
que falha é tentada mais uma vez com um User-Agent de navegador. O status 429
é listado como "retry later" e não reprova a execução; os sites que recusam
robôs (401, 403, 999) são listados para verificação manual. Qualquer outra
falha é impressa com os arquivos que a citam, e o código de saída é 1.

O script exige rede e leva alguns minutos; por isso, o
`scripts/check-links.sh` não o executa. Passe caminhos para verificar apenas
alguns arquivos, por exemplo `scripts/check-sources.sh languages/dart`.

Quando uma fonte mudar de lugar, substitua-a pela nova página da editora ou por
uma cópia do Internet Archive (`web.archive.org/web/<timestamp>/<original URL>`)
que você tenha aberto. Se nenhuma página puder mais sustentar uma afirmação,
altere ou remova a afirmação.

Encerre o que ficou em execução (um servidor web iniciado manualmente, uma
execução de verificação interrompida):
```sh
scripts/stop-all.sh --list            # only show what would be stopped
scripts/stop-all.sh                   # everything (asks first)
scripts/stop-all.sh java csharp/web   # only these folders
```

## Lista de verificação para um pull request

**Cada implementação** (`languages/<language>/<category>/`)
- [ ] Código-fonte mínimo. Um programa cli imprime exatamente
      `Hello, World!`, um programa desktop abre uma janela que o mostra e um
      programa web o serve em uma porta de localhost documentada.
- [ ] Comentários didáticos no código-fonte. Eles também apontam as
      diferenças em relação a outras linguagens.
- [ ] `install.sh`, `build.sh` (se for compilada) e `run.sh` seguem o
      contrato dos scripts acima.
- [ ] Um README com todas as seções de
      [`docs/templates/impl/README.md`](docs/templates/impl/README.md):
      O que é, Pré-requisitos, Início rápido, Scripts explicados, Estrutura
      de pastas, Passo a passo, Por que esta toolchain, Notas de
      plataforma, Saída esperada e Fontes.
      Para web, desktop e mobile, a Saída esperada mostra
      `screenshot.png` (a página, a janela ou a tela da aplicação) e informa
      como a captura foi feita. Uma pasta sem captura explica o motivo em
      Saída esperada, em uma frase que contém "no screenshot" (por exemplo,
      uma página que é texto simples, exibida como texto).
- [ ] A partir de um shell limpo, `install.sh → build.sh → run.sh` conclui
      com sucesso na máquina de quem contribui. Cole os comandos e a saída
      deles (ou uma captura de tela, no caso de web e desktop) no pull
      request, com o sistema operacional utilizado.
- [ ] `scripts/verify-all.sh <language>/<category>` passa.
- [ ] Uma entrada no `meta.yml` da linguagem, as tabelas regeneradas
      (`python3 scripts/gen-readme.py --check` passa) e
      `scripts/check-links.sh` não relata nenhum link quebrado.
- [ ] Uma fonte externa nova ou alterada passa em
      `scripts/check-sources.sh <path>`, e você a abriu e leu a frase que
      sustenta o seu texto.

**Todo o texto**
- [ ] Escrito conforme o [guia de estilo](docs/contributing/style-guide.md),
      com os termos do [glossário](docs/contributing/glossary.yml).
- [ ] `scripts/check-prose.sh` não relata nenhum alerta.

**Cada linguagem** (`languages/<language>/README.md` e `meta.yml`)

Uma linguagem está concluída quando `scripts/check-language.sh <language>`
passa. O script verifica o `meta.yml` (incluindo `humor.line`), cada pasta de
categoria com seu README e seu `run.sh`, as tabelas do site para os
principais arquivos-fonte, as tabelas geradas dos READMEs, os fatos medidos
em `site/data/facts.json` e o texto. O script não verifica os itens abaixo,
que dependem de um leitor.
- [ ] `scripts/check-language.sh <language>` passa.
- [ ] História, marcos datados, uso no mercado hoje (ano e fonte),
      importância antes e agora, paradigma.
- [ ] Tabela de categorias com link para cada implementação, comparação
      entre as categorias e o motivo de qualquer categoria ausente.
- [ ] Toda afirmação factual é citada conforme
      [Sobre as fontes](docs/sources.md). Isso inclui `year` e `designers`
      no `meta.yml`, cujas `sources` devem ser as mesmas fontes que o
      README cita para eles.
- [ ] `humor.line` no `meta.yml` (obrigatório): uma observação leve sobre a
      linguagem para a página [Off the record](docs/off-the-record.md), dentro
      da regra de tom ali enunciada. Uma entrada para o Improbable
      Dictionary of Programming (`humor.dictionary`) é bem-vinda
      (esquema: [`languages/README.md`](languages/README.md#humor-keys)).

## Plataformas
O mantenedor verifica em **macOS Intel**. O Linux (Ubuntu) e o Windows
(Git Bash) podem ser verificados no CI pelo
[`.github/workflows/ci-matrix.yml`](.github/workflows/ci-matrix.yml), que é
iniciado manualmente; sua última execução aprovada foi em 2026-11-06. As
linhas de Linux e Windows de uma implementação informam **verificado no CI
(data)** somente depois que uma execução desse workflow passou para ela, com
a data dessa execução. Caso contrário, informam **não verificado**. O macOS
Apple Silicon e o WSL continuam **não verificados** até que alguém os execute
(consulte
[Suporte a plataformas](docs/platform-support.md)). No Windows, os scripts
executam no Git Bash ou no WSL, e o README também lista os comandos nativos
do Windows. Quem verificar uma plataforma deve atualizar a linha dela em
"Notas por plataforma" com a data e as versões utilizadas.

## Commits e pull requests
- Trabalhe em uma branch do seu fork e abra o pull request contra a branch
  padrão.
- As mensagens de commit seguem o
  [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
  com o escopo `<language>/<category>`, `<language>` ou `scripts`,
  `docs`, `site`, `repo` para arquivos compartilhados:
  `feat(java/web): add Spring Boot hello world`,
  `docs(cobol): add history and milestones`,
  `fix(rust/desktop): pin eframe version`.
- Nunca faça commit de segredos, arquivos `.env`, saída de compilação ou
  arquivos de IDE. O [`.gitignore`](.gitignore) da raiz cobre todas as
  toolchains. Uma implementação pode ter seu próprio `.gitignore`.
- Ao contribuir, concorda-se que o código seja publicado sob a Licença MIT
  ([LICENSE](LICENSE)) e a prosa e as imagens sob a CC BY 4.0
  ([LICENSE-docs](LICENSE-docs)).

## Versões e a interface pública
As versões seguem o [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html),
e cada versão é descrita em [CHANGELOG.md](CHANGELOG.md). O número da versão
protege aquilo em que um leitor, um script ou um link podem confiar:
- **o contrato dos scripts**: os nomes `install.sh`, `build.sh` e `run.sh`, o
  `run.sh --verify` que imprime `Hello, World!` e termina por conta própria e
  a variável `PORT` dos servidores web (consulte
  [Contrato dos scripts](#contrato-dos-scripts));
- **a estrutura de pastas**: `languages/<language>/<category>/` e os
  comandos de `scripts/` citados no README;
- **os endereços do site**: uma página por linguagem em
  `languages/<language>/` e por implementação em
  `languages/<language>/<category>/`, o mesmo em cada tradução.

Remover ou renomear qualquer um desses itens exige uma nova versão maior. Uma
nova linguagem, implementação ou página exige uma nova versão menor; uma
correção que os mantém como estão exige uma nova versão de correção. A
redação, as fontes e as versões de toolchain dentro de uma implementação não
fazem parte da interface.
