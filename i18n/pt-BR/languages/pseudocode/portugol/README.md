---
source: languages/pseudocode/portugol/README.md
source_sha: bd2e83937946f9c470b8c01e06f129492f6a19a1
---
# Pseudocódigo · Portugol (dialeto VisuAlg): Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Pseudocódigo](../README.md)

## O que é
Um algoritmo em Portugol, [`ola-mundo.alg`](ola-mundo.alg), que imprime
exatamente `Hello, World!`. O Portugol é uma família de dialetos de
pseudocódigo com palavras-chave em português, usada em cursos brasileiros de
introdução à programação; ele "tem diversas variações em sintaxe" [1]. Esta
pasta usa a variação **VisuAlg**, a linguagem do editor VisuAlg, cuja versão
3.0, sozinha, tem quase 3 milhões de downloads, cerca de 90% deles do Brasil
(lido em 2026-11-02) [2]. O motivo de o Portugol ser uma das três variantes
está explicado na [visão geral do pseudocódigo](../README.md#ranking-evidence).

O programa é executado pelo **Delégua**, um interpretador gratuito (MIT) para
Node.js com "suporte a múltiplos dialetos, como variações de Portugol
(VisuAlg, Portugol Studio, Portugol IPT, Mapler)" [3]. Como no
[CLI do Python](../../python/cli/), não há `build.sh`.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| Node.js + npm | 26.8.2 / 12.2.1 (Homebrew) | executar o Delégua; baixá-lo |
| `@designliquido/delegua-node` | 1.25.0 (fixada em `package.json` / `package-lock.json`) | o comando `delegua` [4] |
| `@designliquido/visualg` | 0.9.20 (instalada junto) | o dialeto VisuAlg: "Dialeto de VisuAlg baseado em Delégua e TypeScript" [5] |

## Início rápido
```sh
./install.sh   # check Node.js, then npm ci (asks first)
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica `node` e `npm`; oferece `brew install node` no macOS ou imprime as instruções para Linux e Windows. Em seguida, executa `npm ci` (após perguntar) para instalar o Delégua em `node_modules/`. | O Delégua é um pacote npm. O `npm ci` instala as versões exatas de `package-lock.json` [6], de modo que todo estudante executa o mesmo interpretador. |
| `run.sh` | Executa `node_modules/.bin/delegua --dialeto visualg ola-mundo.alg`. `--verify` faz o mesmo. | `--dialeto` escolhe a linguagem; o padrão é a do próprio Delégua (`delegua --ajuda`). |

`npm run start` executa o mesmo comando (o script `start` de
`package.json`).

## Estrutura de pastas
```text
portugol/
├── README.md          this file
├── install.sh         checks Node.js, installs Delégua (npm ci)
├── run.sh             runs delegua --dialeto visualg ola-mundo.alg
├── package.json       declares the Delégua dependency
├── package-lock.json  exact versions of every package
└── ola-mundo.alg      the algorithm (teaching comments)
```
- `.alg` é a extensão de arquivo do VisuAlg; a opção de tradutor do Delégua a
  chama de `alg-para-delegua` (`delegua --ajuda`).
- `node_modules/` é criada por `install.sh` e ignorada pelo Git.

## Passo a passo
Abra [`ola-mundo.alg`](ola-mundo.alg) ao lado desta lista.

1. **`algoritmo "OlaMundo"`** deve ser a primeira linha: ela dá nome ao
   algoritmo. O Delégua rejeita até um comentário antes dela (testado com a
   1.25.0: "Esperada expressão 'algoritmo' para inicializar programa").
2. **Os comentários** começam com `//`. O VisuAlg "não distingue maiúsculas e
   minúsculas no reconhecimento de palavras-chave e nomes de variáveis" [7].
3. **`var`** abre a seção em que as variáveis são declaradas com seus tipos,
   antes dos comandos, como no Pascal. Este programa não tem nenhuma.
4. **`inicio`** marca onde os comandos começam, como o `begin` do Pascal.
5. **`escreval("Hello, World!")`** escreve o texto e depois uma quebra de
   linha: "Idem ao anterior [escreva], com a única diferença que pula uma
   linha em seguida. É equivalente ao writeln do Pascal" [7].
6. **`fimalgoritmo`** encerra o programa, como o `end.` do Pascal.

As comparações com o Pascal são deliberadas: a linguagem do VisuAlg é próxima
do Pascal (ver o [CLI do Pascal](../../pascal/cli/)), com palavras-chave em
português.

## Por que esta toolchain
- **Por que o dialeto VisuAlg.** As duas ferramentas de Portugol mais bem
  documentadas são o VisuAlg e o Portugol Studio. O VisuAlg 3.0 tem 2.976.812
  downloads no SourceForge [2]; o Portugol Studio tem 959.624 downloads de
  versões no GitHub (ambos lidos em 2026-11-02) [8].
- **Por que não o programa VisuAlg em si.** O VisuAlg 3.0 é um programa para
  Windows (versão 3.0.7.0, 2019-03-21); sua página diz que ele executa no Linux
  apenas por meio do Wine [9]. É um editor com interface gráfica (GUI), de
  modo que `run.sh` não consegue executá-lo.
- **Por que não o Portugol Studio.** Sua última versão é a 2.7.5, de
  2020-11-27 [8], e ele também é um editor GUI. O Delégua também tem um
  dialeto Portugol Studio, mas, em um teste com a 1.25.0, ele imprimiu `\n`
  literalmente em vez de uma quebra de linha, de modo que a saída do programa
  não era exata.
- **Por que o Delégua.** Ele executa o dialeto VisuAlg a partir de um terminal
  em qualquer sistema operacional com Node.js, tem licença MIT [3] e é mantido
  (a 1.25.0 foi publicada no npm em 2026, segundo o registro do npm) [4].
- **Avisos do npm.** No npm 12, `npm ci` avisa que dois pacotes opcionais
  (`canvas`, `koffi`) "had install scripts blocked" (tradução livre: "tiveram
  scripts de instalação bloqueados"). A linha de comando do Delégua não os
  exige para este programa; o aviso pode ser ignorado.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-02) | Node.js 26.8.2 do Homebrew. |
| macOS Apple Silicon | ⚠️ não verificado | Mesmos comandos; `brew install node`. |
| Linux | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` não instala o Node.js: se o `node` ou o `npm` não existe, ele imprime os passos do nodejs.org [10] e para. Ele executa `npm ci` para instalar o Delégua quando ele não existe. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` não instala o Node.js: se o `node` ou o `npm` não existe, ele imprime `winget install --id OpenJS.NodeJS.LTS -e` e para. Ele executa `npm ci` para instalar o Delégua quando ele não existe. O editor VisuAlg 3.0 original [9] é uma alternativa. O WSL (Windows Subsystem for Linux) não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run ola-mundo.alg with the Delégua interpreter (VisuAlg dialect)
    WHY: Delégua reads the pseudocode and executes it, line by line.
Hello, World!
```

## Fontes
1. Barbosa, Couto, and Terra. "PortuCol: uma pseudo linguagem inspirada em C ANSI para o Ensino de Lógica de Programação e Algoritmos". WEI 2016. SBC OpenLib. <https://sol.sbc.org.br/index.php/wei/article/download/9678/9579> (acessado em 2026-11-02)
2. VisuAlg 3.0 download statistics. SourceForge. <https://sourceforge.net/projects/visualg30/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (acessado em 2026-11-02)
3. Delégua. Design Líquido, GitHub. <https://github.com/DesignLiquido/delegua> (acessado em 2026-11-02)
4. @designliquido/delegua-node. npm registry. <https://registry.npmjs.org/@designliquido/delegua-node> (acessado em 2026-11-02)
5. @designliquido/visualg. npm registry. <https://registry.npmjs.org/@designliquido/visualg> (acessado em 2026-11-02)
6. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (acessado em 2026-11-02)
7. VisuAlg language reference (copy of the VisuAlg help hosted by a lecturer at the "Escola de Engenharia de Lorena", University of São Paulo). <https://sistemas.eel.usp.br/docentes/arquivos/5840003/241/VisuAlg.pdf> (acessado em 2026-11-02)
8. Portugol Studio releases. UNIVALI-LITE, GitHub. <https://github.com/UNIVALI-LITE/Portugol-Studio/releases> (acessado em 2026-11-02)
9. VisuAlg 3.0. SourceForge. <https://sourceforge.net/projects/visualg30/> (acessado em 2026-11-02)
10. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (acessado em 2026-11-02)
