---
source: docs/sources.md
source_sha: cf630d7f926df779928bf3a167be472485393fd6
---
# Sobre as fontes

Todas as páginas deste repositório apresentam fatos: datas, nomes, versões,
classificações, percentuais e o comportamento de compiladores e bibliotecas.
Cada fato deve ser **real, confiável e acessível**: o leitor precisa poder
abrir a fonte e conferi-lo. Esta página explica quais fontes são usadas, como
são citadas e como são verificadas.

## 1. Quais fontes são aceitas
Em ordem de preferência:

1. A **documentação oficial** da linguagem, do compilador, do framework ou do
   fornecedor (por exemplo, python.org, go.dev, learn.microsoft.com e os
   manuais do GNU).
2. Os **órgãos de normalização** que publicam o padrão da linguagem:
   ISO/IEC, ANSI, ECMA International e IEEE.
3. **Artigos e livros originais** dos autores da linguagem.
4. **Pesquisas e índices do setor reconhecidos**, para o uso no mercado:
   - Stack Overflow Developer Survey: https://survey.stackoverflow.co/
   - TIOBE Index: https://www.tiobe.com/tiobe-index/
   - IEEE Spectrum Top Programming Languages: https://spectrum.ieee.org/
   - GitHub Octoverse: https://octoverse.github.com/
5. **A Wikipédia somente junto com uma fonte primária** dos itens 1 a 3 que
   sustente a mesma afirmação. A Wikipédia isolada não basta.

Não são aceitos: blogs, fóruns, textos gerados por IA ou fazendas de conteúdo
como única fonte de um fato. Eles podem ser indicados apenas como "leitura
complementar".

Alguns fatos exigem tipos de fonte que a lista acima não menciona. Eles são
aceitos nestas formas:
- **Documentação de fornecedor para plataformas e toolchains**, para a
  categoria `mobile` e para toolchains sem padrão: por exemplo, a documentação
  do Android SDK e do Android Gradle plugin (developer.android.com), a
  documentação do Xcode e do SwiftUI da Apple (developer.apple.com) e o guia
  de instalação do Flutter (docs.flutter.dev). Um número de versão ou um
  requisito ("needs Gradle 9.6 or newer") cita a página do fornecedor que o
  declara, e o README informa a versão que de fato foi executada.
- **Artigos históricos e palestras dos autores de uma linguagem**, como os
  artigos da HOPL (History of Programming Languages conference, ACM SIGPLAN)
  e as teses de doutorado. São a melhor fonte para "por que esta linguagem
  foi criada". Cita-se a cópia do próprio autor quando a página da editora
  bloqueia a leitura automatizada (consulte a seção 5).
- **Arquivos-fonte da própria ferramenta**, quando uma linguagem não tem site
  próprio: por exemplo, o arquivo-fonte do QCL (o README dentro dele é a fonte
  do que o QCL diz sobre si mesmo) e o manual do GNU Cim para o Simula. O
  arquivo e sua versão são informados.
- **Acervos que preservam padrões e relatórios antigos**, para linguagens de
  antes da web, como o relatório Simula 67 Common Base Language mantido pelo
  Software Preservation Group.
- **Registros de pacotes e páginas de lançamento** para "a versão atual é":
  o registro ou a página de lançamentos do projeto, com a data de acesso.

## 2. Regras para toda afirmação
- **Toda afirmação factual tem uma citação**: datas, nomes, versões,
  "primeiro", "mais usado", classificações e percentuais.
- **Todo número informa seu ano e sua fonte**, por exemplo "TIOBE Index,
  October 2026: …". Os números de mercado mudam a cada ano; por isso, nunca
  são apresentados como atemporais.
- **Não verificável significa removido.** Se uma afirmação não puder ser
  confirmada em uma fonte acessível, ela é descartada, não atenuada.
- **Nenhuma API nem comportamento de ferramenta inventado.** Comandos,
  opções e chamadas de biblioteca são conferidos na documentação oficial ou
  executando-os de fato.
- As **citações** (por exemplo, as visões críticas de professores em
  `pseudocode/`) são copiadas palavra por palavra, com autor, publicação e
  ano.

### Fatos sobre ideias, não só sobre ferramentas
[Paradigmas](paradigms.md) e [o ensaio sobre IA](ai-new-paradigm.md)
apresentam afirmações sobre ideias: o que é o modelo de atores, de onde veio
a orientação a objetos, o que um contrato em Eiffel promete. Para essas
páginas:
- A afirmação é uma **citação** ou uma paráfrase próxima de uma fonte
  primária: o artigo que propôs a ideia (por exemplo, Hewitt, Bishop e
  Steiger para os atores, 1973), a documentação da própria linguagem ou o
  relato de seu autor.
- Um **vínculo entre duas ideias ou linguagens** ("Objective-C's additions to
  C are mostly based on Smalltalk") precisa de uma fonte que o declare. Se
  nenhuma fonte declara o vínculo, a página ainda pode comparar as duas e,
  nesse caso, informa que a comparação é própria deste repositório, não uma
  afirmação histórica.
- Uma **observação lateral** sobre uma ferramenta, como "Qiskit is an
  open-source SDK", cita a documentação da própria ferramenta e não diz mais
  do que essa página diz. Classificações e números de uso exigem uma pesquisa
  datada da seção 1.

## 3. Regras para links
- **Somente HTTPS.** Os links devem ser publicamente acessíveis, sem login
  nem acesso pago. Se um padrão for pago (por exemplo, o da ISO), cite a
  página de seu catálogo e uma descrição acessível feita pelo editor.
- Cada entrada de uma seção **Sources** usa este formato:
  `<Title>. <Publisher/Author>. <https://...> (acessado em YYYY-MM-DD)`
- No texto, cite com uma referência numerada `[n]` que aponta para a lista.

## 4. Segurança dos instaladores
Fontes confiáveis também importam para o software que o leitor instala:
- As toolchains são instaladas somente a partir do **instalador oficial** ou
  de um **gerenciador de pacotes** consolidado (Homebrew, apt, winget).
- O `install.sh` nunca executa `sudo` nem baixa código silenciosamente: ele
  mostra o comando e pergunta antes (consulte `scripts/common.sh`,
  `install_pkg`).
- Nenhum encadeamento `curl … | sh`, a menos que seja o instalador oficial
  documentado pelo fornecedor (por exemplo, GHCup e rustup); nesse caso, o
  README informa isso e indica a página do fornecedor.

## 5. Como as fontes são verificadas
- Toda página nova ou alterada é revisada em relação às suas fontes antes de
  ser publicada.
- Antes de cada versão, todos os links são abertos e verificados. Alguns
  sites (por exemplo, iso.org) recusam requisições automatizadas; esses são
  verificados manualmente. Links quebrados são corrigidos, e as afirmações sem
  fonte acessível são removidas.
- O `scripts/check-links.sh` verifica todos os links relativos e `#anchor`
  entre os arquivos Markdown do próprio repositório.
- As fontes que uma linguagem cita para seu ano, seus projetistas e seu
  paradigma ficam no `meta.yml` dela (`sources`). O `scripts/gen-readme.py` e
  o gerador do site leem esse arquivo; assim, a página **Fontes por linguagem** do site
  lista as mesmas fontes que o README da linguagem, agrupadas por linguagem, e
  o `scripts/check-language.sh` falha quando o arquivo está incompleto.
- Um artigo pode ser um PDF que uma ferramenta não consegue ler no navegador.
  Suas citações são conferidas com o texto do PDF, extraído na máquina do
  mantenedor (por exemplo, com o `pdftotext`), nunca a partir de um resumo
  dele.

Encontrou um fato errado ou um link inativo? Informe-o; consulte
[CONTRIBUTING.md](../CONTRIBUTING.md).
