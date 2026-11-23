---
source: languages/python/README.md
source_sha: 24248dc50345c8e06d8c41ef9ff96fcb5a25c16d
---
# Python

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma. O FAQ oficial chama o Python de "an interpreted,
interactive, object-oriented programming language" (tradução livre: "uma
linguagem de programação interpretada, interativa e orientada a objetos"),
que "supports multiple programming paradigms beyond object-oriented
programming, such as procedural and functional programming" [1] (tradução
livre: "oferece suporte a múltiplos paradigmas de programação além da
orientação a objetos, como a programação procedural e a funcional"). Os
programas Hello World deste repositório usam apenas o estilo procedural
(imperativo): as instruções são executadas de cima para baixo.

Ver também: [paradigmas](../../docs/paradigms.md#every-language-and-its-paradigm)
(como este paradigma se compara aos demais) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | CPython | ✅ |
| desktop | [desktop/](desktop/) | tkinter (biblioteca padrão) | ✅ |
| web | [web/](web/) | Flask | ✅ |

## Histórico
Guido van Rossum iniciou o Python no CWI, nos Países Baixos. O FAQ oficial
apresenta o relato dele [1]:

- Ele "had extensive experience with implementing an interpreted language in
  the ABC group at CWI" (tradução livre: "tinha ampla experiência na
  implementação de uma linguagem interpretada no grupo ABC do CWI"). O ABC é
  "the origin of many Python features, including the use of indentation for
  statement grouping" (tradução livre: "a origem de muitos recursos do
  Python, incluindo o uso de indentação para agrupar instruções").
- Ele trabalhava no grupo do sistema operacional distribuído Amoeba, que
  "needed a better way to do system administration than by writing either C
  programs or Bourne shell scripts" (tradução livre: "precisava de uma
  forma melhor de fazer administração de sistemas do que escrever programas
  em C ou scripts Bourne shell").
- "During the 1989 Christmas holidays, I had a lot of time on my hand, so I
  decided to give it a try." (tradução livre: "Durante as férias de Natal
  de 1989, eu tinha muito tempo livre e decidi tentar.") Em fevereiro de
  1991, ele o publicou na USENET.
- A sintaxe de exceções veio do Modula-3 [1].

O nome vem da série de comédia da BBC "Monty Python's Flying Circus", cujos
roteiros van Rossum lia na época [1]. A história oficial do Python diz que
ele "was created in the early 1990s by Guido van Rossum at Stichting
Mathematisch Centrum (CWI ...) in the Netherlands as a successor of a
language called ABC" [2] (tradução livre: "foi criado no início da década
de 1990 por Guido van Rossum na Stichting Mathematisch Centrum (CWI ...),
nos Países Baixos, como sucessor de uma linguagem chamada ABC"). A Python
Software Foundation (PSF), uma organização sem fins lucrativos criada em
2001 [2], "holds the copyright on Python versions 2.1 and newer" [1]
(tradução livre: "detém os direitos autorais das versões 2.1 e posteriores
do Python").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| dezembro de 1989 | Início da implementação | [3] |
| 1991-02-20 | Python 0.9.0 publicado no grupo USENET `alt.sources` | [3] |
| 1994-01-26 | Python 1.0.0 | [3] |
| 1995 | O desenvolvimento passa para o CNRI, em Reston, Virgínia (EUA) | [2] |
| maio de 2000 | A equipe principal passa para a BeOpen.com (BeOpen PythonLabs) | [2] |
| 2000-10-16 | Python 2.0 | [4] |
| 2001 | Criação da Python Software Foundation | [2] |
| 2008-12-03 | Python 3.0, "incompatible with the 2.x line of releases" (tradução livre: "incompatível com a linha de versões 2.x") | [5] |
| 2010-07-03 | Python 2.7 final | [6] |
| 2020-01-01 | Fim da vida do Python 2: "no longer supported" (tradução livre: "não mais suportado") | [7] |
| 2025-10-07 | Python 3.14 (a versão usada neste repositório) | [8] |
| 2026-10-09 | Python 3.15, a versão mais recente em 2026-10-30 | [8] |

## Uso no mercado hoje
Cada número abaixo tem data e fonte. Eles mudam a cada ano.

- **Índice TIOBE, outubro de 2026:** o Python é o nº 1, com taxa de 19,23% [9].
  O TIOBE observa que os dados históricos de longo prazo estão
  temporariamente indisponíveis após uma mudança para incluir termos de
  busca em chinês [9].
- **Stack Overflow Developer Survey 2026:** 58,0% de todos os respondentes
  da pergunta sobre linguagens de programação usaram Python (8.184 de
  14.099) [10].
- **IEEE Spectrum Top Programming Languages 2025** (publicado em 2025-09-23):
  o Python ocupa "the top spot" [11] (tradução livre: "o primeiro lugar") no
  ranking "Spectrum" padrão.
- **GitHub Octoverse:** em 2024, "Python overtook JavaScript as the most
  popular language on GitHub" [12] (tradução livre: "o Python ultrapassou o
  JavaScript como a linguagem mais popular do GitHub"). O relatório de 2026
  classifica as linguagens por contribuidores: "TypeScript first, Python
  second, and JavaScript third" [13] (tradução livre: "TypeScript em
  primeiro, Python em segundo e JavaScript em terceiro"). Os dois relatórios
  medem coisas diferentes, portanto os rankings não são diretamente
  comparáveis.

## Importância antes e agora
- **Antes (década de 1990):** o FAQ descreve o Python como uma forma de obter
  "a scripting language with a syntax like ABC but with access to the Amoeba
  system calls" (tradução livre: "uma linguagem de script com sintaxe como a
  do ABC, mas com acesso às chamadas de sistema do Amoeba"), situada entre
  os programas em C e os scripts de shell [1]. A linguagem foi projetada para
  ser extensível, porque a "lack of extensibility was one of its biggest
  problems" do ABC [1] (tradução livre: "falta de extensibilidade era um dos
  maiores problemas").
- **Python 3 (2008):** uma nova versão "incompatible with the 2.x line of
  releases" [5] (tradução livre: "incompatível com a linha de versões 2.x").
  O Python 2 foi suportado até 2020-01-01 [7]; portanto, as duas linhas
  foram mantidas em paralelo por 11 anos.
- **Agora:** os números da pesquisa e do índice acima colocam o Python no
  topo ou perto do topo de todos os rankings de 2025–2026 citados nesta
  página [9][10][11][13]. O GitHub associa a ascensão de 2024 a "the surge
  in data science and machine learning" [12] (tradução livre: "o aumento da
  ciência de dados e do aprendizado de máquina").
- **No ensino:** o FAQ oficial argumenta que "students may be better served
  by learning Python as their first language" (tradução livre: "os
  estudantes podem ser mais bem atendidos ao aprender Python como primeira
  linguagem"), por causa de sua "very simple and consistent syntax and a
  large standard library" [1] (tradução livre: "sintaxe muito simples e
  consistente e biblioteca padrão extensa"). Esta é a visão do próprio
  projeto Python, não um estudo independente.

## Comparação entre as categorias
| | [cli](cli/) | [desktop](desktop/) | [web](web/) |
|---|---|---|---|
| Linhas de código (sem comentários) | 1 | 12 | 5 |
| O que utiliza | `print()` embutido | `tkinter` + `ttk` da biblioteca padrão | Flask, do PyPI |
| Instalação adicional | nenhuma | Tcl/Tk (`python-tk@3.14` / `python3-tk`), incluído nos instaladores do python.org | Flask em um `.venv/` local (`requirements.txt`) |
| Como executa | de cima para baixo e depois termina | laço de eventos `mainloop()` até a janela fechar | laço de servidor `flask run` até Ctrl+C |
| Saída | texto na saída padrão | uma janela nativa | uma página HTML via HTTP em `localhost:8080` |
| Autoverificação `--verify` | igual a uma execução normal | imprime o texto do rótulo quando a janela fica visível e fecha após 2 s | inicia o servidor, obtém `/` com curl e o encerra |

A mesma ideia atravessa as três: a versão cli é uma lista direta de
instruções, enquanto as versões desktop e web entregam o controle a um laço
que aguarda eventos (um clique ou uma requisição HTTP) e chama o código
escrito quando um deles chega. Nenhuma delas precisa de etapa de
compilação, porque o Python é interpretado
(ver [cli/README.md](cli/README.md#why-there-is-no-build-step)).

As três categorias previstas para o Python estão implementadas; por isso,
esta página não tem uma seção "por que não há <categoria>".

## Fontes
1. General Python FAQ. Python Software Foundation. <https://docs.python.org/3/faq/general.html> (acessado em 2026-10-30)
2. History and License. Python Software Foundation. <https://docs.python.org/3/license.html> (acessado em 2026-10-30)
3. A Brief Timeline of Python. Guido van Rossum, The History of Python (blog), 2009. <https://python-history.blogspot.com/2009/01/brief-timeline-of-python.html> (acessado em 2026-10-30)
4. Python 2.0. Python Software Foundation. <https://www.python.org/download/releases/2.0/> (acessado em 2026-10-30)
5. Python 3.0 Release. Python Software Foundation. <https://www.python.org/download/releases/3.0/> (acessado em 2026-10-30)
6. PEP 373: Python 2.7 Release Schedule. Python Software Foundation. <https://peps.python.org/pep-0373/> (acessado em 2026-10-30)
7. Sunsetting Python 2. Python Software Foundation. <https://www.python.org/doc/sunset-python-2/> (acessado em 2026-10-30)
8. Status of Python versions. Python Developer's Guide. <https://devguide.python.org/versions/> (acessado em 2026-10-30)
9. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-30)
10. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-30)
11. Top Programming Languages 2025. IEEE Spectrum, 2025-09-23. <https://spectrum.ieee.org/top-programming-languages-2025> (acessado em 2026-10-30)
12. Octoverse 2024. GitHub. <https://github.blog/news-insights/octoverse/octoverse-2024/> (acessado em 2026-10-30)
13. Octoverse 2026. GitHub, 2026-10-28. <https://github.blog/news-insights/octoverse/octoverse-commits-pushes-reach-new-highs-in-2026-as-developers-build-with-agents/> (acessado em 2026-10-30)
