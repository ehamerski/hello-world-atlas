---
source: languages/php/README.md
source_sha: 9cd61569e30d818b912a8c95f5d7f1d60d1e77b4
---
# PHP

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** imperativo, com suporte à orientação a objetos. O php.net
descreve o PHP como "A popular general-purpose scripting language that is
especially suited to web development" [1] (tradução livre: "Uma popular
linguagem de script de propósito geral, especialmente adequada ao
desenvolvimento web"). Ela começou como uma linguagem de template
procedural para páginas web. As classes vieram depois: o PHP 3.0
"included object-oriented programming support" (tradução livre:
"incluiu suporte à programação orientada a objetos"), e o PHP 5 trouxe "the
Zend Engine 2.0 with a new object model" (tradução livre: "o Zend Engine
2.0 com um novo modelo de objetos") [2]. Hoje o manual diz "PHP includes a
complete object model" [3] (tradução livre: "O PHP inclui um modelo de
objetos completo"). Um Hello World não precisa de nada disso: nem classe,
nem função `main`.

Veja também: [paradigmas](../../docs/paradigms.md#imperative) (como este
paradigma se compara aos outros) e [comparações](../../docs/comparisons.md)
(esta linguagem lado a lado com as demais).

## Implementações
| Categoria | Pasta | Toolchain | Status |
|---|---|---|---|
| cli | [cli/](cli/) | `php` CLI | ✅ |
| desktop | – | não implementado, veja [Por que não há versão desktop](#por-que-não-há-versão-desktop) | – |
| web | [web/](web/) | servidor embutido do PHP (`php -S`) | ✅ |

## Histórico
"Created in 1994 by Rasmus Lerdorf, the very first incarnation of PHP was
a simple set of Common Gateway Interface (CGI) binaries written in the C
programming language" [2] (tradução livre: "Criada em 1994 por Rasmus
Lerdorf, a primeiríssima encarnação do PHP era um simples conjunto de
binários Common Gateway Interface (CGI) escritos na linguagem de
programação C"). Ele a anunciou publicamente em 1995-06-08 no grupo
Usenet `comp.infosystems.www.authoring.cgi`: "Announcing the Personal
Home Page Tools (PHP Tools) version 1.0" [4] (tradução livre: "Anunciando
a versão 1.0 do Personal Home Page Tools (PHP Tools)").

Por pouco tempo Lerdorf abandonou o nome PHP e chamou a versão seguinte de
"FI (short for "Forms Interpreter")" (tradução livre: "FI (abreviação de
"Forms Interpreter")"); os dois nomes foram combinados mais tarde como
PHP/FI [2]. "It had Perl-like variables,
automatic interpretation of form variables, and HTML embedded syntax" [2]
(tradução livre: "Tinha variáveis semelhantes às do Perl, interpretação
automática de variáveis de formulário e sintaxe embutida em HTML").
Essa sintaxe embutida em HTML continua sendo a ideia central do PHP:
compare com a versão [web](web/public/index.php), em que o código PHP fica
dentro de uma tag `<p>`.

O PHP 3.0 foi "announced by the new PHP Development Team as the official
successor to PHP/FI 2.0" em junho de 1998 [2] (tradução livre: "anunciado
pela nova PHP Development Team como o sucessor oficial do PHP/FI 2.0").
Com ele, o nome mudou: "It was renamed simply 'PHP', with the meaning
becoming a recursive acronym - PHP: Hypertext Preprocessor" [2] (tradução
livre: "Foi renomeada simplesmente para 'PHP', com o significado passando
a ser um acrônimo recursivo - PHP: Hypertext Preprocessor"). Andi Gutmans
e Zeev Suraski reescreveram então o núcleo do PHP como o "Zend Engine"
("comprised of their first names, Zeev and Andi", tradução livre:
"composto por seus primeiros nomes, Zeev e Andi"), e o PHP 4.0, baseado
nele, "was officially released in May 2000" (tradução livre: "foi lançado
oficialmente em maio de 2000").

Duas versões posteriores mudaram mais a linguagem. O PHP 7.0 (2015-12-03
[5]) "featured another major version of the core, Zend Engine 3.0, which
included significant performance improvements (up to twice as fast as PHP
5.6)" [2][6] (tradução livre: "trouxe outra versão principal do núcleo, o
Zend Engine 3.0, que incluiu melhorias significativas de desempenho (até
duas vezes mais rápido que o PHP 5.6)"). O PHP 8.0 (2020-11-26 [5])
acrescentou "named arguments, union types, attributes, constructor
property promotion, match expressions, the nullsafe operator (?->), a new
optimizing JIT compiler" [2][7] (tradução livre: "argumentos nomeados,
tipos união, atributos, promoção de propriedades no construtor,
expressões match, o operador nullsafe (?->), um novo compilador JIT
otimizador").

## Marcos
| Data | Marco | Fonte |
|---|---|---|
| 1994 | Rasmus Lerdorf escreve o primeiro PHP: binários CGI em C | [2] |
| 1995-06-08 | Anúncio público de "Personal Home Page Tools (PHP Tools) version 1.0" | [4] |
| 1998-06 | PHP 3.0: suporte à orientação a objetos; o nome passa a ser "PHP: Hypertext Preprocessor" | [2] |
| 2000-05 | PHP 4.0 sobre o novo Zend Engine | [2] |
| 2004-07-13 | PHP 5.0: Zend Engine 2.0 "with a new object model" | [2][5] |
| 2012-03-01 | O PHP 5.4.0 acrescenta o servidor web embutido usado por [web/](web/) | [5][8] |
| 2015-12-03 | PHP 7.0: Zend Engine 3.0, "up to twice as fast as PHP 5.6" | [2][5][6] |
| 2020-11-26 | PHP 8.0: compilador JIT, argumentos nomeados, tipos união, `match` | [2][5][7] |
| 2025-11-20 | PHP 8.5: "the URI extension, Pipe operator, and support for modifying properties while cloning"; a versão usada neste repositório | [5][9] |

As ramificações do PHP têm um calendário de suporte fixo. O PHP 8.5 tem
suporte ativo até 2027-12-31 e suporte de segurança até 2029-12-31; em
2026-10-31, as ramificações com suporte eram 8.2, 8.3, 8.4 e 8.5 [10].

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam a cada ano.

- **Sites web (W3Techs, 2026-10-31):** "PHP is used by 69.2% of all the
  websites whose server-side programming language we know" [11] (tradução
  livre: "O PHP é usado por 69,2% de todos os sites cuja linguagem de
  programação do lado do servidor conhecemos"). Ele ocupa o primeiro lugar
  no ranking de linguagens do lado do servidor do W3Techs; o JavaScript é
  o segundo, com 8,3% [12]. Dos sites que usam PHP, 65,9% usam a versão 8
  [11]. Parte disso vem do WordPress, uma aplicação PHP, que o W3Techs
  encontra em 39,5% de todos os sites (2026-10-31) [13].
- **Índice TIOBE, outubro de 2026:** o PHP ocupa a 12ª posição, com uma
  avaliação de 1,26%. Em outubro de 2025, ocupava a 14ª [14].
- **Stack Overflow Developer Survey 2026:** 17,7% de todos os respondentes
  da pergunta sobre linguagens de programação usaram PHP (2.490 de
  14.099) [15]. Na pergunta sobre frameworks web, 7,6% usaram o Laravel,
  um framework PHP (785 de 10.281) [15].

Os dois tipos de número medem coisas diferentes. O W3Techs conta sites,
então uma aplicação PHP instalada em milhões de sites (como o WordPress)
conta muitas vezes. O TIOBE conta resultados de mecanismos de busca, e a
pesquisa do Stack Overflow conta os desenvolvedores que responderam.

## Importância antes e agora
- **Antes (1995–2004):** o PHP reduziu o esforço necessário para escrever
  páginas web dinâmicas. Uma página era
  um arquivo HTML com "HTML embedded syntax" (tradução livre: "sintaxe
  embutida em HTML") nas partes dinâmicas [2], e a linguagem "was
  deliberately designed to resemble C in structure, making it an easy
  adoption for developers familiar with C, Perl, and similar languages"
  [2] (tradução livre: "foi projetada deliberadamente para se parecer
  com C em estrutura, facilitando a adoção por desenvolvedores
  familiarizados com C, Perl e linguagens semelhantes").
- **Virada de desempenho (2015):** o PHP 7 foi "up to twice as fast as PHP
  5.6" [6] (tradução livre: "até duas vezes mais rápido que o PHP 5.6"), e
  o PHP 8 acrescentou um compilador JIT [7].
- **Hoje:** o PHP executa a maior parte dos sites cuja linguagem de
  servidor o W3Techs consegue detectar (69,2%, 2026-10-31) [11], mas não
  está entre as 10 linguagens mais usadas na pesquisa Stack Overflow 2026
  (17,7% dos respondentes) [15]. Boa parte do código PHP atual está em
  aplicações e frameworks como o WordPress [13] e o Laravel [15].
- **No ensino:** o PHP mostra o modelo de "template" da web, em que o
  código fica embutido na página, um modelo que as outras linguagens deste
  repositório não têm. Sua CLI também mostra que o PHP é uma linguagem de
  propósito geral, e não apenas web [1].

## Comparando as categorias
| | [`cli`](cli/) | [`web`](web/) |
|---|---|---|
| Linhas de PHP/HTML (sem comentários e sem linhas em branco) | 2 (`<?php` e `echo`) | 3 (`<?php`, `?>` e a linha `<p>`) |
| Começa em | modo PHP (`<?php` na linha 1) | modo PHP, depois passa para HTML após `?>` |
| Iniciado com | `php hello.php` | `php -S 127.0.0.1:8080 -t public` |
| Qual código executa o laço principal | nenhum: o arquivo é executado uma vez e o programa termina | o servidor web embutido, que executa `index.php` uma vez por requisição |
| Código de servidor escrito por você | – | nenhum: o servidor mapeia `/` para `public/index.php` |
| Saída | texto na saída padrão | HTML na resposta HTTP (`text/html; charset=UTF-8`) |
| Dependências extras | nenhuma | nenhuma (`curl` apenas para testes) |

O que permanece igual: ambas usam o mesmo programa `php` e a mesma
instrução `echo`. A versão web não precisa do Composer, de um framework
nem de um servidor web separado. Compare com [Python](../python/README.md),
cuja versão web precisa do Flask, vindo do PyPI, e com [Go](../go/README.md),
cuja versão web escreve o servidor em código com `net/http`.

## Por que não há versão desktop
Este repositório não tem uma versão desktop de PHP: uma categoria só é
incluída se existir uma toolchain mantida, convencional e razoavelmente
simples para ela. O PHP não tem uma toolchain de GUI assim:

- **O PHP-GTK não é mantido.** É "an extension for the PHP programming
  language that implements language bindings for GTK+" (tradução livre:
  "uma extensão da linguagem de programação PHP que implementa bindings
  da linguagem para o GTK+"), e seu site diz: "The PHP-GTK project is no
  longer under active development, and the related mailing lists and other
  online services are no longer active" [16] (tradução livre: "O projeto
  PHP-GTK não está mais em desenvolvimento ativo, e as listas de e-mail e
  outros serviços online relacionados não estão mais ativos"). Seu
  repositório de código-fonte "was archived by the owner on Dec 8, 2021.
  It is now read-only" [17] (tradução livre: "foi arquivado pelo
  proprietário em 8 de dez. de 2021. Agora é somente leitura"), e seu
  README ainda diz "PHP-GTK requires PHP 5.1.2 or greater" [17] (tradução
  livre: "O PHP-GTK requer PHP 5.1.2 ou superior").
- **O NativePHP não é PHP puro.** O NativePHP para desktop "builds on top
  of the incredible affordances and ecosystem that Laravel provides"
  (tradução livre: "se apoia nos incríveis recursos e no ecossistema que o
  Laravel oferece"), e "Before using NativePHP, you'll want to be familiar
  with building web applications using Laravel" [18] (tradução livre:
  "Antes de usar o NativePHP, convém estar familiarizado com a construção
  de aplicações web usando o Laravel"). Seus requisitos são "PHP 8.3+",
  "Laravel 11 or higher" e "Node 22+", e ele executa o aplicativo sobre "the
  Electron runtime" [19]: "NativePHP ships a statically-compiled PHP binary
  inside your app, alongside an Electron shell" [20] (tradução livre: "O
  NativePHP inclui um binário PHP compilado estaticamente dentro do seu
  aplicativo, junto com um shell Electron"). A janela é desenhada pelo
  Electron (Chromium), com uma aplicação web Laravel dentro dela. Isso é
  um projeto Laravel mais um aplicativo Electron, e não um Hello World
  simples em PHP, e a parte do Electron já é mostrada diretamente em
  [Node.js desktop](../node/desktop/).

Assim, um Hello World "desktop" em PHP dependeria de um projeto sem
manutenção ou seria, em grande parte, Laravel e Electron. Nenhum dos dois
mostra o PHP "the most simple and direct way" (tradução livre: "da forma
mais simples e direta"), que é o objetivo deste repositório
([Hello World em várias linguagens](../../README.md)).

## Fontes
1. PHP: Hypertext Preprocessor (home page). The PHP Group. <https://www.php.net/> (acessado em 2026-10-31)
2. History of PHP. The PHP Group. <https://www.php.net/manual/en/history.php.php> (acessado em 2026-10-31)
3. Classes and Objects: Introduction. The PHP Group. <https://www.php.net/manual/en/oop5.intro.php> (acessado em 2026-10-31)
4. Announce: Personal Home Page Tools (PHP Tools). Rasmus Lerdorf, comp.infosystems.www.authoring.cgi, 1995-06-08. <https://groups.google.com/g/comp.infosystems.www.authoring.cgi/c/PyJ25gZ6z7A/m/M9FkTUVDfcwJ> (acessado em 2026-10-31)
5. PHP releases (JSON release data, e.g. `?json&version=8.0.0`). The PHP Group. <https://www.php.net/releases/index.php?json&version=8.0.0> (acessado em 2026-10-31)
6. PHP 7.0.0 Release Announcement. The PHP Group. <https://www.php.net/releases/7_0_0.php> (acessado em 2026-10-31)
7. PHP 8.0 Release Announcement. The PHP Group. <https://www.php.net/releases/8.0/en.php> (acessado em 2026-10-31)
8. PHP 5.4.0 Release Announcement. The PHP Group. <https://www.php.net/releases/5_4_0.php> (acessado em 2026-10-31)
9. PHP 8.5 Release Announcement. The PHP Group. <https://www.php.net/releases/8.5/en.php> (acessado em 2026-10-31)
10. Supported Versions. The PHP Group. <https://www.php.net/supported-versions.php> (acessado em 2026-10-31)
11. Usage statistics of PHP for websites. W3Techs. <https://w3techs.com/technologies/details/pl-php> (acessado em 2026-10-31)
12. Usage statistics of server-side programming languages for websites. W3Techs. <https://w3techs.com/technologies/overview/programming_language> (acessado em 2026-10-31)
13. Usage statistics of WordPress. W3Techs. <https://w3techs.com/technologies/details/cm-wordpress> (acessado em 2026-10-31)
14. TIOBE Index for October 2026. TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-10-31)
15. 2026 Stack Overflow Developer Survey: Technology (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data> (acessado em 2026-10-31)
16. PHP-GTK. The PHP Group. <https://gtk.php.net/> (acessado em 2026-10-31)
17. `php/php-gtk-src` (archived repository). GitHub. <https://github.com/php/php-gtk-src> (acessado em 2026-10-31)
18. NativePHP for Desktop: Introduction. NativePHP. <https://nativephp.com/docs/desktop/getting-started/introduction> (acessado em 2026-10-31)
19. NativePHP for Desktop: Installation. NativePHP. <https://nativephp.com/docs/desktop/2/getting-started/installation> (acessado em 2026-10-31)
20. NativePHP (home page). NativePHP. <https://nativephp.com/> (acessado em 2026-10-31)
