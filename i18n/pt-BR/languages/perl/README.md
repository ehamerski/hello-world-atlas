---
source: languages/perl/README.md
source_sha: fa721119981a0507343ae0212dbe14cc0cd25b40
---
# Perl

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma. A página do perl.org sobre o Perl diz que ele
"Supports object-oriented, procedural and functional programming" [1]
(tradução livre: "Oferece suporte à programação orientada a objetos,
procedural e funcional"). Os programas Hello World desta pasta usam apenas o
estilo procedural (imperativo): as instruções são executadas de cima para
baixo.

Veja também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | perl 5 | ✅ |
| desktop | [desktop/](desktop/) | Tkx (Tcl/Tk) | 🔶 |
| web | [web/](web/) | Mojolicious::Lite | ✅ |

A pasta desktop é uma **solução de compromisso**: ela usa o Tkx, que controla
o Tcl/Tk do sistema, e não o Perl/Tk, o binding mais conhecido. O motivo é
que o Perl/Tk precisa de um servidor X11 no macOS, e a máquina de
desenvolvimento não tem nenhum. Veja a explicação completa em
[desktop/README.md](desktop/README.md#why-this-toolchain).

## Histórico
O FAQ do Perl descreve o Perl como "a high-level programming language with an
eclectic heritage written by Larry Wall and a cast of thousands" [2]
(tradução livre: "uma linguagem de programação de alto nível, de herança
eclética, escrita por Larry Wall e um elenco de milhares"). Ele acrescenta
que o Perl "derives from the ubiquitous C programming language" (tradução
livre: "deriva da onipresente linguagem de programação C") e, em menor
medida, de outras ferramentas e linguagens [2]. Os registros perlhist, que
listam cada versão com a pessoa que a produziu, mostram Larry Wall como o
autor do Perl 1 ao Perl 5.000 [3].

O FAQ indica como escrever o nome: "Perl" é a linguagem, `perl` é o
interpretador. O nome não é escrito em maiúsculas, porque "perl is not an
acronym" [2] (tradução livre: "perl não é uma sigla").
Um lema do desenvolvimento do Perl é "there's more than one way
to do it" [2] (tradução livre: "há mais de uma maneira de fazer isso").

O Perl 5 é a linha usada neste repositório. A linguagem Raku "(formerly
known as Perl 6) was originally described as the community's rewrite of
Perl" [2] (tradução livre: "(antes conhecida como Perl 6) foi descrita
originalmente como a reescrita do Perl pela comunidade") é hoje uma
linguagem separada. Uma versão em Raku não faz parte desta página.

## Marcos
As datas vêm da tabela de versões do perlhist [3]. A primeira coluna dessa
tabela indica a versão; a data é a data de lançamento.

| Data | Marco | Fonte |
|---|---|---|
| 1987-12-18 | Perl 1.000, por Larry Wall | [3] |
| 1988-06-05 | Perl 2.000 | [3] |
| 1989-10-18 | Perl 3.000 | [3] |
| 1991-03-21 | Perl 4.000 | [3] |
| 1994-10-17 | Perl 5.000 | [3] |
| 2002-07-18 | Perl 5.8.0 | [3] |
| 2007-12-18 | Perl 5.10.0 | [3] |
| 2022-05-27 | Perl 5.36.0 | [3] |
| 2026-07-15 | Perl 5.44.0, a versão estável mais recente listada em 2026-11-04 | [3] |

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** o Perl ocupa a 17ª posição, com uma
  avaliação de 0,88% [4].
- **Stack Overflow Developer Survey 2026:** 3,8% dos respondentes da
  pergunta sobre linguagens de programação, de script e de marcação usaram
  Perl (538 de 14.099) [5].
- **perl.org, 2026:** a página sobre o Perl fala em "over 38 years of
  development" (tradução livre: "mais de 38 anos de desenvolvimento") e diz
  que ele é "Used for mission critical projects in the
  public and private sectors" [1] (tradução livre: "Usado em projetos
  críticos nos setores público e privado"). Essa é a descrição do próprio
  projeto, não uma medida independente.

## Importância antes e agora
- **Antes:** a primeira versão é de 1987 [3]. Desde a versão 5.000, de
  1994 [3], o FAQ diz que o projeto "averaged about one production
  release per year" [2] (tradução livre: "teve em média cerca de uma versão
  de produção por ano"). O FAQ lista prototipagem, utilitários de sistema,
  processamento de texto e trabalho para a web como usos típicos [2].
- **Agora:** o Perl ainda é mantido: o Perl 5.44.0 tem a data 2026-07-15 [3].
  Os números do índice e da pesquisa de 2026 acima o colocam entre os 20
  primeiros do Índice TIOBE [4] e em 3,8% dos respondentes da pesquisa do
  Stack Overflow de 2026 [5].

## Comparando as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Linhas de código (sem comentários) | 3 | 15 | 6 |
| O que usa | `print` nativo | Tkx, uma interface Perl para o Tk | Mojolicious::Lite do CPAN |
| Instalação extra | nenhuma | Tcl/Tk (`tcl-tk` do Homebrew), um compilador C, e Tcl.pm mais Tkx do CPAN em `local/` | Mojolicious do CPAN em `local/` |
| Como é executado | de cima para baixo, depois termina | laço de eventos `Tkx::MainLoop()` até a janela ser fechada | laço de servidor `perl app.pl daemon` até Ctrl+C |
| Saída | texto na saída padrão | uma janela nativa | uma página HTML via HTTP em `localhost:8080` |
| Autoverificação `--verify` | igual a uma execução normal | imprime o texto do rótulo assim que a janela é exibida e a fecha após 2 s | inicia o servidor, busca `/` com curl e o encerra |

O programa cli é uma lista direta de instruções. As versões desktop e web
passam o controle a um laço que aguarda eventos (um evento de janela ou uma
requisição HTTP) e chama o código do leitor quando um deles chega. Nenhuma
delas precisa de uma etapa de compilação, porque o Perl é interpretado (veja
[cli/README.md](cli/README.md#why-there-is-no-build-step)). A única
diferença de esforço está na pasta desktop, que compila o Tcl.pm durante o
`install.sh`; isso faz parte da solução de compromisso.

As três categorias previstas para o Perl estão implementadas, de modo que
esta página não tem uma seção "por que não há <categoria>".

## Fontes
1. About Perl. perl.org. <https://www.perl.org/about.html> (acessado em 2026-11-04)
2. perlfaq1: General Questions About Perl. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlfaq1> (acessado em 2026-11-04)
3. perlhist: the Perl history records. Perl 5 porters, perldoc.perl.org. <https://perldoc.perl.org/perlhist> (acessado em 2026-11-04)
4. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-04)
5. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-11-04)
