---
source: languages/pseudocode/clrs/README.md
source_sha: 905ab5e95656e0f8c71b639e200af314783a1819
---
# Pseudocódigo · estilo CLRS: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Pseudocódigo](../README.md)

## O que é
Um Hello World, [`hello-world.txt`](hello-world.txt), escrito no estilo de
pseudocódigo de *Introduction to Algorithms*, de Cormen, Leiserson, Rivest e
Stein, conhecido como **CLRS**, pelas iniciais dos autores. O livro nasceu da
disciplina de algoritmos 6.046 do MIT e, em 2022, o MIT News informou que ele
"has now officially sold over 1 million copies worldwide" [1] (tradução
livre: "agora vendeu oficialmente mais de 1 milhão de exemplares no mundo").
O motivo de ser uma das três variantes está explicado na
[visão geral do pseudocódigo](../README.md#ranking-evidence).

**Esta variante é apenas documentada.** O pseudocódigo CLRS é uma notação para
leitura, composta no livro com o pacote LaTeX dos próprios autores [2]. Não
existe interpretador para ele; a 4ª edição é acompanhada, em vez disso, por
implementações em Python de seus algoritmos [1]. Por isso esta pasta não tem
`install.sh` nem `run.sh`, e `scripts/verify-all.sh` a ignora (ele executa
apenas as pastas que têm um `run.sh`).

## Pré-requisitos
Nenhum: um editor de texto ou um navegador para ler o arquivo.

## Início rápido
```sh
cat hello-world.txt
```

## Scripts explicados
Não há scripts, porque não há nada a instalar, compilar ou executar.

## Estrutura de pastas
```text
clrs/
├── README.md         this file
└── hello-world.txt   the procedure (teaching comments on top)
```
O livro não tem formato de arquivo; `.txt` significa "texto simples".

## Passo a passo
```text
HELLO-WORLD()
1  print "Hello, World!"
```
1. **O nome do procedimento** é escrito em versaletes, com hifens entre as
   palavras. O manual do pacote afirma que seu comando `\proc` "typesets
   procedure names in small caps, and dashes (which occur frequently in our
   procedure names) are typeset as hyphens" [3] (tradução livre: "compõe os
   nomes de procedimentos em versaletes, e os traços (que ocorrem com
   frequência em nossos nomes de procedimentos) são compostos como hifens").
   O texto simples não tem versaletes; por isso, aqui se usam letras
   maiúsculas. Os parênteses contêm os parâmetros (nenhum).
2. **As linhas numeradas** formam o corpo. Cada nível de aninhamento é um
   nível a mais de indentação: "Each tab stop gives one level of indentation"
   (tradução livre: "Cada tabulação dá um nível de indentação"), e os comandos
   `\Do` e `\End` do pacote apenas aumentam e diminuem esse nível [3]. Não há
   palavras-chave `begin`/`end` nem chaves na saída; portanto, somente a
   indentação indica o bloco, como no Python.
3. **`print`** escreve texto. O livro o usa, por exemplo, no procedimento
   KMP-MATCHER: `print "Pattern occurs with shift" i - m` (conforme mostrado no
   manual do pacote para a 3ª edição) [3].
4. **Os comentários** começam com `//` na 3ª e na 4ª edições: "The \Comment
   command simply produces the comment symbol //" [3] (tradução livre: "O
   comando \Comment simplesmente produz o símbolo de comentário //"). O pacote
   da 2ª edição desenhava um triângulo (▷) em seu lugar [4].
5. **A atribuição** (não necessária aqui) é escrita com `=`. A 1ª e a 2ª
   edições usavam uma seta para a esquerda; "Many readers told us that they
   preferred to use an equals sign for assignment" (tradução livre: "Muitos
   leitores nos disseram que preferiam usar um sinal de igual para a
   atribuição"), por isso a 3ª edição a alterou [3]. Um teste de igualdade é
   escrito `==` [3].

Compare-o com as versões em [Portugol](../portugol/) e [PSeInt](../pseint/):
elas fecham os blocos com palavras-chave e podem ser executadas; o CLRS é mais
curto e mais próximo do Python.

## Por que esta toolchain
Não há toolchain. Os pacotes LaTeX dos autores (`clrscode`, para a 2ª edição,
`clrscode3e`, para a 3ª [2], e `clrscode4e`, para a 4ª [5]) são a referência de
como a notação se apresenta; por isso são as fontes do passo a passo acima.

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| qualquer | ✅ (nada a executar) | Texto simples, legível em qualquer lugar. |

## Saída esperada
Nenhuma é produzida por um programa. Se o leitor "executar" o procedimento à
mão, ele escreve:
```text
Hello, World!
```

## Fontes
1. Q&A: What makes a bestselling textbook? (Introduction to Algorithms). MIT News, 2022-02-23. <https://news.mit.edu/2022/qa-what-makes-bestselling-textbook-introduction-algorithms-0223> (acessado em 2026-11-02)
2. Cormen, T. H. `clrscode`: LaTeX packages for CLRS pseudocode. Dartmouth College. <https://web.archive.org/web/20250210061943/https://www.cs.dartmouth.edu/~thc/clrscode/> (acessado em 2026-11-02)
3. Cormen, T. H. Using the clrscode3e Package in LaTeX 2e (manual). Dartmouth College. <https://web.archive.org/web/20250328084750/https://www.cs.dartmouth.edu/~thc/clrscode/clrscode3e.pdf> (acessado em 2026-11-02)
4. clrscode.sty (package for the 2nd edition). Dartmouth College. <https://web.archive.org/web/20240422115246/https://www.cs.dartmouth.edu/~thc/clrscode/clrscode.sty> (acessado em 2026-11-02)
5. clrscode4e.sty (package for the 4th edition). MIT Press. <https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/11599/clrscode4e.sty> (acessado em 2026-11-02)
