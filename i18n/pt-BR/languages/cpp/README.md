---
source: languages/cpp/README.md
source_sha: 91e72e13852d68e7096ffb05e904340069f6a241
---
# C++

> Parte de [Hello World em várias linguagens](../../README.md)

**Paradigma:** multiparadigma. Nas palavras de seu criador, "C++ is a
multi-paradigm programming language that supports Object-Oriented and other
useful styles of programming" [1] (tradução livre: "O C++ é uma linguagem de
programação multiparadigma que oferece suporte à orientação a objetos e a
outros estilos úteis de programação"), incluindo "traditional procedural
programming, object-oriented programming, and generic programming" [1]
(tradução livre: "programação procedural tradicional, programação orientada
a objetos e programação genérica"). Os três programas daqui mostram alguns
desses estilos. A versão [`cli`](cli/) é procedural, como o C. A versão
[desktop](desktop/) usa a hierarquia de classes do Qt (orientação a
objetos). A versão [web](web/) passa uma lambda, uma função sem nome, a uma
biblioteca como valor.

Ver também: [paradigmas](../../docs/paradigms.md#object-oriented) (como
este paradigma se compara aos demais) e
[comparações](../../docs/comparisons.md) (esta linguagem lado a lado com
as outras linguagens).

## Implementações
| Categoria | Pasta | Toolchain | Situação |
|---|---|---|---|
| cli | [cli/](cli/) | CMake, C++20 | ✅ |
| desktop | [desktop/](desktop/) | Qt 6 Widgets, CMake | ✅ |
| web | [web/](web/) | cpp-httplib, CMake | ✅ |

As três são compiladas como **ISO C++20** (`-std=c++20`, sem extensões do
compilador, `-pedantic-errors`) e construídas com o **CMake**. Cada pasta é
a gêmea da mesma categoria em [C](../c/README.md), de modo que as duas
linguagens podem ser comparadas lado a lado.

## História
O FAQ de Bjarne Stroustrup é a principal fonte desta seção [1].

- **Por quê:** "I wanted to write efficient systems programs in the styles
  encouraged by Simula67. To do that, I added facilities for better type
  checking, data abstraction, and object-oriented programming to C" [1]
  (tradução livre: "Eu queria escrever programas de sistemas eficientes nos
  estilos incentivados pelo Simula67. Para isso, acrescentei ao C recursos
  para melhor verificação de tipos, abstração de dados e programação
  orientada a objetos"). O problema específico "had to do with distributing
  operating system facilities across a network" [1] (tradução livre: "tinha
  a ver com distribuir recursos de sistema operacional por uma rede").
- **C with Classes (1979):** "I started work on what became C++ in 1979.
  The initial version was called "C with Classes"" [1] (tradução livre:
  "Comecei a trabalhar no que viria a ser o C++ em 1979. A versão inicial
  chamava-se "C with Classes""). Um recurso existia desde o início:
  "deterministic destruction, it was in "C with Classes" in the first week
  or two (1979)" [1] (tradução livre: "a destruição determinística, que
  estava em "C with Classes" na primeira ou segunda semana (1979)"). Esse
  recurso é o que permite aos programas desktop e web daqui liberar
  recursos sem uma chamada a `free` ou a `unref`.
- **Por que o C:** "I wanted C++ to be compatible with a complete language
  with sufficient performance and flexibility for even the most demanding
  systems programming. At the time, I considered C the best systems
  programming language available" [1] (tradução livre: "Eu queria que o C++
  fosse compatível com uma linguagem completa, com desempenho e
  flexibilidade suficientes até para a programação de sistemas mais
  exigente. Na época, eu considerava o C a melhor linguagem de programação
  de sistemas disponível"). "C++ is a direct descendant of C that retains
  almost all of C as a subset" [1] (tradução livre: "O C++ é um descendente
  direto do C que mantém quase todo o C como subconjunto").
- **De onde vieram as ideias:** "C++ got the key notions of classes,
  derived classes, virtual functions (in other words, the notions of
  encapsulation, inheritance and polymorphism) from Simula" [1] (tradução
  livre: "O C++ obteve do Simula as noções fundamentais de classes, classes
  derivadas e funções virtuais, isto é, as noções de encapsulamento,
  herança e polimorfismo").
- **O nome (1983):** "The first version of C++ was used internally in AT&T
  in August 1983. The name "C++" was used late that year" [1] (tradução
  livre: "A primeira versão do C++ foi usada internamente na AT&T em agosto
  de 1983. O nome "C++" foi usado no final daquele ano"). "The name C++
  (pronounced "see plus plus") was coined by Rick Mascitti in the summer of
  1983. The name signifies the evolutionary nature of the changes from C;
  "++" is the C increment operator" [1] (tradução livre: "O nome C++
  (pronunciado "see plus plus") foi cunhado por Rick Mascitti no verão de
  1983. O nome indica a natureza evolutiva das mudanças em relação ao C;
  "++" é o operador de incremento do C").
- **Primeira versão (1985):** "The first commercial implementation was
  released October 1985 at the same time as the publication of the 1st
  edition of The C++ Programming Language" [1] (tradução livre: "A primeira
  implementação comercial foi lançada em outubro de 1985, ao mesmo tempo
  que a publicação da 1ª edição de The C++ Programming Language"). Esse
  compilador, o Cfront, "was written in C++" [1] (tradução livre: "foi
  escrito em C++").
- **Padrões:** o C++ é um padrão ISO desde 1998, com revisões publicadas em
  2003, 2011, 2014, 2017, 2020 e 2024 [2]. O comitê é o ISO/IEC
  JTC1/SC22/WG21, "the international standardization working group for the
  programming language C++" [3] (tradução livre: "o grupo de trabalho
  internacional de padronização da linguagem de programação C++").

## Marcos
| Ano | Marco | Fonte |
|---|---|---|
| 1979 | Stroustrup inicia o "C with Classes" | [1] |
| 1983 | Primeiro uso interno na AT&T (agosto); o nome "C++" é usado no final do ano | [1] |
| 1985 | Primeira implementação comercial (Cfront) e *The C++ Programming Language*, 1ª edição (outubro) | [1] |
| 1998 | **C++98**, ISO/IEC 14882:1998, o primeiro padrão ISO | [2] |
| 2003 | C++03, ISO/IEC 14882:2003 (errata técnica) | [2] |
| 2011 | **C++11**, ISO/IEC 14882:2011 | [2] |
| 2014 | C++14, ISO/IEC 14882:2014 | [2] |
| 2017 | C++17, ISO/IEC 14882:2017 (o Qt 6 exige no mínimo este [4]) | [2][4] |
| 2020 | **C++20**, ISO/IEC 14882:2020. Usado por todas as pastas daqui | [2] |
| 2024 | C++23, ISO/IEC 14882:2024, o padrão atual. É "called C++23 because 2023 is the year the technical work was completed" (chamado de C++23 porque 2023 é o ano em que o trabalho técnico foi concluído) | [2][5] |

A próxima revisão é chamada informalmente de C++26; o Clang já oferece
suporte a "some of the features" [6] (tradução livre: "alguns dos
recursos") com `-std=c++2c`.

## Uso no mercado hoje
Cada número abaixo tem sua data e sua fonte. Eles mudam todos os anos.

- **Índice TIOBE, outubro de 2026:** o C++ ocupa a **posição 3**, com
  avaliação de 8,87%, também na posição 3 em outubro de 2025 [7]. O C está
  na posição 2 (11,33%) [7]. O TIOBE nomeou o C++ "Programming Language of
  the Year" (linguagem do ano) em 2003 e 2022 [7]. O TIOBE chama seu índice
  de "an indicator of the popularity of programming languages" (tradução
  livre: "um indicador da popularidade das linguagens de programação"),
  baseado em mecanismos de busca, "not about ... the language in which most
  lines of code have been written" [7] (tradução livre: "não se trata de
  ... a linguagem em que mais linhas de código foram escritas").
- **Stack Overflow Developer Survey 2026:** 24,3% de todos os respondentes
  (3.425 de 14.099) disseram ter feito "extensive development work"
  (trabalho extensivo de desenvolvimento) em C++ no último ano, contra
  21,8% para o C [8]. 15,8% de todos os respondentes querem usar o C++
  ("desired"), e sua pontuação "admired" é de 45,8% (C: 14,2% e 45,9%) [9].

## Importância antes e agora
- **Antes:** o C++ trouxe as classes do Simula para a eficiência do C e
  para o código já existente em C. Foi usado dentro da AT&T desde 1983 e
  vendido a partir de 1985 [1]. Como "retains almost all of C as a subset"
  [1] (tradução livre: "mantém quase todo o C como subconjunto"),
  programadores de C puderam adotá-lo passo a passo.
- **Agora:** posição 3 no TIOBE (outubro de 2026) [7], usado
  extensivamente por 24,3% dos respondentes do Stack Overflow em 2026 [8] e
  ainda revisado pela ISO: o padrão atual foi publicado em 2024, e o C++26
  está em andamento [2][5][6].
- **No ensino:** o mesmo programa pode ser escrito em estilo C e em estilo
  C++, e a [comparação com C](#comparação-com-c) a seguir mostra o que cada
  recurso do C++ substitui.

## Comparação com C
O C++ nasceu do [C](../c/README.md), por isso esta página compara as duas
linguagens. Cada pasta daqui é a gêmea da pasta do C da mesma categoria:

| O quê | [C](../c/README.md) | C++ (esta pasta) |
|---|---|---|
| Padrão usado | C89 (`cli`), C99 (`desktop`, `web`) | C++20 em todas |
| Imprimir uma linha | `printf("Hello, World!\n");` (string de formato) | `std::cout << "Hello, World!\n";` (`<<` sobrecarregado, verificado por tipo) |
| Comentários | somente `/* */` no C89; `//` a partir do C99 | `//` e `/* */` |
| `main` | `int main(void)` + `return 0;` (C89) | `int main()`; chegar ao fim da função retorna 0 [10] |
| Nomes | prefixos: `gtk_`, `MHD_` | espaços de nomes: `std::`, `httplib::`, `Qt::` |
| Objetos | structs + funções, conversões como `GTK_WINDOW(w)` | classes com funções-membro: `label.setWindowTitle(...)` |
| Callbacks | ponteiro para função + dados do usuário em `void *` | lambdas que capturam variáveis: `[&app] { app.quit(); }` |
| Liberação de recursos | manual: `g_object_unref`, `MHD_destroy_response` | automática: os destrutores são executados quando um objeto sai de escopo (RAII) |
| Erros | códigos de retorno (`atoi` retorna 0, `NULL`) | também exceções (`std::stoi` lança) |
| Compilação | `cc` chamado diretamente; `pkg-config` para bibliotecas | CMake: `find_package` / `find_path`, `cmake --build` |
| Tamanho do executável (máquina de teste, macOS Intel) | cli 8.440 · desktop 9.888 · web 9.472 bytes | cli 14.248 · desktop 32.840 · web 695.672 bytes |

O que permanece igual: ambas são compiladas antecipadamente pela mesma
família de compiladores (Apple clang), em um executável nativo. Nenhuma tem
coletor de lixo nem máquina virtual. O executável `cli` do C++ é um pouco
maior e carrega também a `libc++`, a biblioteca padrão do C++. A versão web
é muito maior porque a cpp-httplib é somente cabeçalho e é compilada junto
com o programa, enquanto a libmicrohttpd do C continua sendo uma biblioteca
compartilhada.

## Comparação entre as categorias
| | [`cli`](cli/) | [`desktop`](desktop/) | [`web`](web/) |
|---|---|---|---|
| Linhas de C++ (sem comentários, sem linhas em branco) | 5 | 21 (5 são a autoverificação) | 29 |
| Biblioteca | somente a biblioteca padrão do C++ | Qt 6.12 Widgets (+ Qt GUI, Qt Core) | cpp-httplib 0.64 (um cabeçalho) |
| Como o CMake a encontra | desnecessário | `find_package(Qt6 REQUIRED COMPONENTS Widgets)` | `find_path(... httplib.h)` + `Threads::Threads` |
| Bibliotecas ligadas (`otool -L`) | `libc++`, `libSystem` | QtWidgets, QtGui, QtCore + frameworks da Apple + `libc++`, `libSystem` | `libc++`, `libSystem` |
| Quem controla o laço | ninguém: `main` imprime e retorna | o laço de eventos do Qt (`app.exec()`) | cpp-httplib (`server.listen(...)` bloqueia) |
| Recursos do C++ mostrados | espaços de nomes, `<<` | classes, RAII, lambda | lambda, referências, exceções |
| Saída | texto na saída padrão (stdout) | uma janela nativa | HTML via HTTP |

Os arquivos `CMakeLists.txt` diferem apenas nas linhas das bibliotecas; os
scripts são iguais nas três pastas. Instalar o Qt foi a etapa mais longa na
máquina de teste (macOS Intel): o Homebrew não tem bottle do `qtbase` para
Mac Intel [11], de modo que o Homebrew o compilou a partir do código-fonte,
enquanto a cpp-httplib é um único cabeçalho.

O C++ tem uma implementação em cada uma de suas três categorias, de modo
que esta página não tem seção que explique uma categoria ausente.

## Fontes
1. Bjarne Stroustrup's FAQ (When was C++ invented?, Why did you invent C++?, Where did the name "C++" come from?, Is C++ an Object-Oriented language?, What is the difference between C and C++?). Bjarne Stroustrup. <https://www.stroustrup.com/bs_faq.html> (acessado em 2026-11-01)
2. Language Standards Supported by GCC (C++ Language: C++98 to C++23). GCC, the GNU Compiler Collection. <https://gcc.gnu.org/onlinedocs/gcc/Standards.html> (acessado em 2026-11-01)
3. ISO/IEC JTC1/SC22/WG21 - The C++ Standards Committee. WG21. <https://www.open-std.org/jtc1/sc22/wg21/> (acessado em 2026-11-01)
4. Getting started with CMake ("Qt 6 requires a compiler supporting C++ version 17 or newer"). The Qt Company. <https://doc.qt.io/qt-6/cmake-get-started.html> (acessado em 2026-11-01)
5. The Standard ("The current ISO C++ standard is C++23, formally known as ... ISO/IEC 14882:2024(E)"). Standard C++ Foundation (isocpp.org). <https://isocpp.org/std/the-standard> (acessado em 2026-11-01)
6. C++ Support in Clang. The Clang Team. <https://clang.llvm.org/cxx_status.html> (acessado em 2026-11-01)
7. TIOBE Index for October 2026 (ranking, Programming Language of the Year). TIOBE Software. <https://www.tiobe.com/tiobe-index/> (acessado em 2026-11-01)
8. 2026 Stack Overflow Developer Survey: programming languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/languages> (acessado em 2026-11-01)
9. 2026 Stack Overflow Developer Survey: admired and desired languages (data). Stack Overflow. <https://survey.stackoverflow.co/2026/technology/data/da-language> (acessado em 2026-11-01)
10. C++ working draft, [basic.start.main] (main function). ISO/IEC JTC1/SC22/WG21 draft, HTML edition. <https://eel.is/c++draft/basic.start.main> (acessado em 2026-11-01)
11. `qtbase` (Homebrew formula: version and bottles). Homebrew. <https://formulae.brew.sh/formula/qtbase> (acessado em 2026-11-01)
