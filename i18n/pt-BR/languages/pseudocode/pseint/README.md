---
source: languages/pseudocode/pseint/README.md
source_sha: a1473bec1ce8905ed63981ee02a88e2621bb2c7c
---
# Pseudocódigo · PSeInt: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Pseudocódigo](../README.md)

## O que é
Um algoritmo em pseudocódigo, [`hola.psc`](hola.psc), que imprime exatamente
`Hello, World!`, executado pelo **PSeInt**. O PSeInt "es una herramienta para
asistir a un estudiante en sus primeros pasos en programación" (tradução
livre: "é uma ferramenta para auxiliar um estudante em seus primeiros passos
na programação"), com um "pseudolenguaje en español" (tradução livre:
"pseudolinguagem em espanhol") [1]. Seu autor, Pablo Novara, é formado em
Engenharia da Computação e docente da Universidad Nacional del Litoral, na
Argentina [2]. O motivo de o PSeInt ser uma das três variantes está explicado
na [visão geral do pseudocódigo](../README.md#ranking-evidence).

A maior parte do pseudocódigo é apenas lida. O PSeInt é diferente: seu editor
verifica e executa o algoritmo, e o mesmo interpretador pode ser iniciado a
partir de um terminal, que é o que `run.sh` faz. Como no
[CLI do Python](../../python/cli/), não há `build.sh`.

## Pré-requisitos
| Ferramenta | Versão utilizada (macOS Intel) | Por que é necessária |
|---|---|---|
| PSeInt | 20250314 (arquivo oficial `pseint-mi64-20250314.tgz`) | seu interpretador `pseint` executa `hola.psc` |
| `curl`, `tar`, `shasum` | recursos nativos do macOS | `install.sh` baixa, verifica e descompacta o arquivo |

O PSeInt não está no Homebrew nem no Debian; por isso `install.sh` baixa o
arquivo oficial. A página de download diz que ele "No necesita instalación,
solo descomprimir y ejecutar" (tradução livre: "Não precisa de instalação,
basta descompactar e executar") [3].

## Início rápido
```sh
./install.sh   # check / install PSeInt into ~/.local/pseint-20250314 (asks first)
./run.sh       # run it
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Procura o interpretador em `~/.local/pseint-20250314`. Se estiver ausente, pergunta, baixa do SourceForge o arquivo para o sistema operacional do leitor, confere sua soma de verificação SHA-256 com o valor publicado para a versão 20250314 [4] e o descompacta. Sem `sudo`. No Windows, imprime os passos manuais. | O PSeInt é distribuído como um arquivo a descompactar, não como um pacote [3]. A soma de verificação comprova que o arquivo é a versão publicada. |
| `run.sh` | Executa `pseint hola.psc --nouser`. `--verify` faz o mesmo. | `--nouser` faz o interpretador "no mostrar mensajes de estado ni esperar un tecla al final" (tradução livre: "não mostrar mensagens de estado nem esperar uma tecla no final"), conforme a ajuda que o `pseint` imprime quando executado sem argumentos. Sem ele, o programa espera uma tecla. |
| `pseint-env.sh` | Carregado (*source*) por ambos: define a versão, a pasta, o nome do arquivo e a soma de verificação para o sistema operacional do leitor, e o caminho do interpretador. | Um único lugar para alterar a versão. |

Ambos os scripts aceitam `PSEINT=/path/to/pseint` e `PSEINT_DIR=/some/dir`.

## Estrutura de pastas
```text
pseint/
├── README.md       this file
├── install.sh      checks / installs PSeInt (official archive)
├── run.sh          runs pseint hola.psc --nouser
├── pseint-env.sh   shared settings: version, folder, checksums
└── hola.psc        the algorithm (teaching comments)
```
- `.psc` é a extensão que o editor do PSeInt usa para algoritmos; seus
  exemplos incluídos também a usam (`ejemplos/` no arquivo).
- Nada é gravado nesta pasta, portanto o Git não tem nada a ignorar.

## Passo a passo
Abra [`hola.psc`](hola.psc) ao lado desta lista.

1. **Os comentários** começam com `//`, como em C++ ou Java.
2. **`Algoritmo HolaMundo`** abre o algoritmo e lhe dá nome. O PSeInt também
   aceita `Proceso` ... `FinProceso` (testado com a versão 20250314).
3. **`Escribir "Hello, World!";`** ("escrever") imprime o texto e uma quebra
   de linha, como o `print` do Python.
4. **`FinAlgoritmo`** fecha o bloco, como o `end` do Pascal.
5. **Perfis.** O PSeInt permite que cada escola adapte a linguagem: na
   primeira execução, ele pede ao estudante que escolha um perfil "para su
   universidad/facultad/carrera" (tradução livre: "para sua
   universidade/faculdade/curso"), que define a linguagem "de acuerdo a las
   exigencias de su docente" (tradução livre: "de acordo com as exigências de
   seu docente") [5]. A versão 20250314 traz 467 perfis em `perfiles/`; 24 deles
   definem `force_semicolon=1` (contados em 2026-11-02). Com as configurações
   padrão, o `;` é opcional.

**Experimente** (após `./install.sh`, a partir desta pasta):
```sh
. ../../../scripts/common.sh && . ./pseint-env.sh
printf 'Algoritmo A\n Escribir "no semicolon"\nFinAlgoritmo\n' > /tmp/a.psc
"$PSEINT" /tmp/a.psc --nouser                     # prints: no semicolon
"$PSEINT" /tmp/a.psc --nouser --force_semicolon=1 # Lin 2 (inst 1): ERROR 38: Falta punto y coma.
```
A opção `--<opt>=0|1` altera uma opção de perfil nesta execução (conforme o
texto de ajuda do `pseint`). Observe que o interpretador ainda termina com
status 0 após esse erro de sintaxe (observado com a 20250314); portanto, os
scripts devem verificar a saída, como faz `scripts/verify-all.sh`.

## Por que esta toolchain
- O PSeInt é o interpretador que o autor deste pseudocódigo publica [1][2]. É
  software livre (GPLv2) [6] e continua recebendo versões: a 20250314 é a
  versão atual, com compilações nativas para Windows, macOS e Linux [1].
- Entre os candidatos que publicam números de download, é o que tem mais:
  16.705.302 downloads no SourceForge em todo o período, lidos em 2026-11-02
  [7] (detalhes na [visão geral](../README.md#ranking-evidence)).

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-02) | `pseint-mi64-20250314.tgz`; interpretador em `pseint.app/Contents/Resources/pseint`. |
| macOS Apple Silicon | ⚠️ não verificado | `install.sh` usa `pseint-ma64-20250314.tgz` [4]; presume-se a mesma estrutura. |
| Linux | ✅ verificado no CI (2026-11-06) | GitHub Actions `ubuntu-latest` (Ubuntu 26.04, x86_64). O `install.sh` baixa `pseint-l64-20250314.tgz` [4] do SourceForge, confere o SHA-256 e o extrai em `~/.local/pseint-20250314`. O interpretador é `pseint/bin/pseint`. Ele exige o `curl`. |
| Windows (Git Bash / WSL) | ✅ verificado no CI (2026-11-06) | GitHub Actions `windows-latest` (Windows Server 2025), Git Bash. O `install.sh` baixa `pseint-w64-20250314.zip` [4] do SourceForge, confere o SHA-256 e o extrai com o `tar.exe` do Windows em `~/.local/pseint-20250314`. O interpretador é `pseint/pseint.exe`. Ele exige o `curl`. O WSL (Windows Subsystem for Linux) não foi verificado; ele se comporta como o Linux. |

## Saída esperada
```text
$ ./run.sh

==> Run hola.psc with the PSeInt interpreter
    WHY: PSeInt reads the pseudocode and executes it; --nouser prints only
         the program's output and does not wait for a key at the end.
Hello, World!
```

## Fontes
1. PSeInt (home page). <https://pseint.sourceforge.net/> (acessado em 2026-11-02)
2. "Premian a docente de la FICH por un desarrollo de software libre" (Um docente da FICH é premiado por um desenvolvimento de software livre). Universidad Nacional del Litoral, 2015-09-03. <https://www.unl.edu.ar/noticias/news/view/premian_a_docente_de_la_fich_por_un_desarrollo_de_software_libre_1> (acessado em 2026-11-02)
3. "Descargas" (Downloads). PSeInt. <https://pseint.sourceforge.net/index.php?page=descargas.php> (acessado em 2026-11-01)
4. PSeInt files, release 20250314. SourceForge. <https://sourceforge.net/projects/pseint/files/20250314/> (acessado em 2026-11-01)
5. "Perfiles" (Perfis). PSeInt. <https://pseint.sourceforge.net/index.php?page=perfiles.php> (acessado em 2026-11-02)
6. PSeInt project page. SourceForge. <https://sourceforge.net/projects/pseint/> (acessado em 2026-11-02)
7. PSeInt download statistics. SourceForge. <https://sourceforge.net/projects/pseint/files/stats/json?start_date=2000-01-01&end_date=2026-11-01> (acessado em 2026-11-02)
