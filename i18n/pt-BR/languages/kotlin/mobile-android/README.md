---
source: languages/kotlin/mobile-android/README.md
source_sha: 60c95ebbb1569085ee9e8cf23309239227b81fdf
---
# Kotlin · mobile-android: Hello, World!

> Parte de [Hello World em várias linguagens](../../../README.md) ·
> Visão geral da linguagem: [Kotlin](../README.md)

## O que é
Um aplicativo Android que exibe **Hello, World!** na tela de um dispositivo
Android. A tela é construída com o **Jetpack Compose**, "Android's modern
toolkit for building native UI" [1] (tradução livre: "o toolkit moderno do
Android para criar interfaces nativas"). O plugin do Android para o Gradle
compila o aplicativo, e o **emulador** o executa no computador, de modo que
nenhum celular é necessário. O `./run.sh --verify` confirma que a tela do
aplicativo está em primeiro plano e que o texto está na tela. Para a mesma
tarefa em um desktop, veja a versão [Compose desktop](../desktop/README.md),
que usa a mesma linguagem e a mesma biblioteca de interface em outra
plataforma.

## Pré-requisitos
| Ferramenta | Versão usada (macOS Intel) | Por que é necessária |
|---|---|---|
| JDK (Java Development Kit) 21 ou superior | Eclipse Temurin 21.0.8 | o plugin do Android para o Gradle 9.5.1 exige o JDK 17 ou superior [2]; o 21 é a versão que as outras pastas de Kotlin usam |
| Gradle | 9.8.0 (exige-se o 9.6.0 ou superior) | a ferramenta de build; o plugin do Android para o Gradle 9.5.1 exige o Gradle 9.6.0 ou superior [2] |
| Plugin do Android para o Gradle (AGP) | 9.5.1 (fixada em `build.gradle.kts`) | compila o aplicativo e gera o APK; o Gradle o baixa [2] |
| Kotlin | embutido no AGP 9, não instalado manualmente | o AGP 9 tem suporte nativo ao Kotlin, de modo que o plugin do Kotlin para Android não deve ser aplicado [2] |
| Jetpack Compose | BOM 2026.09.00 (fixada) | a biblioteca de interface; o bill of materials define as versões de suas bibliotecas [3] |
| Ferramentas de linha de comando do Android SDK | build 15859902 | o `sdkmanager` instala os pacotes do SDK e o `avdmanager` cria o dispositivo do emulador [4] |
| Android SDK Platform, Build-Tools | Android 37.0 (`android-37.0`), build-tools 37.0.0 | as APIs do Android com as quais o aplicativo é compilado e as ferramentas que o empacotam; o Compose 1.12 e posteriores exigem `compileSdk 37` [3][4] |
| Android Emulator | 37.2.13 | executa o dispositivo virtual no computador [5] |
| Imagem de sistema | `google_apis` `x86_64`, Android 36 | o software Android que o emulador executa; o tipo de CPU Intel corresponde a um Mac Intel. A imagem do Android 37.0 não iniciou na máquina de desenvolvimento (o dispositivo ficou `offline`, com a janela em branco); por isso o dispositivo executa o Android 36, enquanto o aplicativo continua sendo compilado com o 37 [5] |

### Custo de disco e de tempo
O Android SDK e o emulador são as maiores partes desta pasta. As medições
abaixo vêm de uma instalação nova na máquina de desenvolvimento (macOS
Intel, 2026-11-11). Os seus números dependem da rede e do disco.

| Item | Tamanho em disco | Tempo |
|---|---|---|
| Pacotes do Android SDK (a pasta `ANDROID_HOME`, por padrão `~/.local/android-sdk`) | <<SDK_SIZE>> | <<SDK_TIME>> |
| Dispositivo do emulador (AVD) `hello-mobile` | <<AVD_SIZE>> | <<AVD_TIME>> |
| Cache do Gradle com o AGP e as bibliotecas do Compose (`~/.gradle`) | <<GRADLE_SIZE>> | primeiro `./build.sh`: <<BUILD_TIME>> |
| Primeira inicialização do emulador | | <<BOOT_TIME>> |
| Inicializações e builds posteriores | | alguns minutos, principalmente a inicialização |

A imagem de sistema é o maior pacote individual. São necessários cerca de
<<TOTAL_GB>> GB de espaço livre em disco para tudo o que está acima.

Se já existe um Android SDK, por exemplo o do Android Studio, defina
`ANDROID_HOME` com a pasta dele antes de executar o `./install.sh`. O script
passa então a usar esse SDK e baixa apenas o que estiver faltando.

## Início rápido
```sh
./install.sh   # check, and install after you answer y: JDK, Gradle, the SDK and the emulator device
./build.sh     # download AGP and the libraries, then build app-debug.apk (minutes the first time)
./run.sh       # start the emulator, install the app and open it; the emulator window stays open
```

## Scripts explicados
| Script | O que faz | Por que é necessário |
|---|---|---|
| `install.sh` | Verifica o JDK, o Gradle, as ferramentas de linha de comando, os pacotes do SDK, a aceleração de hardware e o dispositivo do emulador `hello-mobile`. Baixa as ferramentas de linha de comando somente no macOS, confere a soma de verificação SHA-256 antes de descompactá-las e pergunta antes de cada download ou aceite de licença. | Os passos estão listados no script, com o motivo de cada um. Nada é baixado nem aceito sem a sua resposta, e o `sudo` nunca é executado. |
| `build.sh` | Executa `gradle --no-daemon --console=plain assembleDebug`. | A tarefa `assembleDebug` compila o `MainActivity.kt`, mescla o manifesto e assina o APK com a chave de depuração. O `--no-daemon` encerra o processo em segundo plano do Gradle ao fim do build. O primeiro build baixa os plugins e as bibliotecas do Gradle citados nos arquivos de build para o cache do Gradle (`~/.gradle`); os builds seguintes os reutilizam. |
| `run.sh` | Executa o `build.sh`, inicia o emulador se nenhum estiver em execução, espera até que o Android tenha inicializado, instala o APK com `adb install -r` e inicia a activity com `adb shell am start -W`. | O emulador é o dispositivo no qual o aplicativo é executado. O `adb` se comunica com ele. Com `--verify`, o emulador não tem janela, o script confere a tela e encerra o emulador que iniciou. |
| `android-env.sh` | Define `ANDROID_HOME`, as versões dos pacotes, o nome do emulador e as somas de verificação. É carregado com `source` pelos outros três scripts. | A plataforma, as build-tools e a imagem de sistema devem pertencer à mesma versão do Android. Um único arquivo as mantém sincronizadas. |

O `run.sh --verify` é a autoverificação que o `scripts/verify-all.sh`
executa. Ele imprime o texto que o dump do uiautomator encontrou na tela:
```text
==> 5/5 Check the screen
[ok] The activity com.example.hello/.MainActivity is on top of the screen.
[ok] The text is on the screen:
Hello, World!
```

## Estrutura de pastas
```text
mobile-android/
├── README.md                    this file
├── install.sh                   checks, and installs after you answer y, the Android tools
├── build.sh                     builds the debug APK with Gradle
├── run.sh                       builds, starts the emulator, installs and opens the app
├── android-env.sh               SDK folder, versions, emulator name and checksums (sourced)
├── screenshot.png               the emulator window, for "Expected output" below
├── settings.gradle.kts          project name, the module list, where Gradle finds plugins
├── build.gradle.kts             the root build file: declares the plugin versions
├── gradle.properties            settings for every Gradle build
├── .gitignore                   keeps build/, .gradle/ and local.properties out of the repository
├── app/
│   ├── build.gradle.kts         the app: SDK levels, Compose, the libraries it uses
│   └── src/main/
│       ├── AndroidManifest.xml  the app's description: its name and its start screen
│       └── java/com/example/hello/
│           └── MainActivity.kt  the whole program: one screen with the text
├── build/                       created by Gradle and run.sh; not committed
├── .gradle/                     created by Gradle; not committed
└── .kotlin/                     created by the Kotlin compiler; not committed
```
- Os códigos-fonte em Kotlin ficam em `app/src/main/java/`, a mesma pasta
  que os códigos-fonte em Java usam em um projeto Android. O build compilou
  o `MainActivity.kt` a partir dela sem configurações extras (verificado em
  2026-11-11). O pacote `com.example.hello` corresponde ao caminho de pasta
  `com/example/hello/`.
- O `AndroidManifest.xml` é o arquivo que o Android lê antes de executar
  qualquer código. Ele nomeia a activity que abre primeiro [6].
- Os arquivos `build.gradle.kts` são escritos em Kotlin (`.kts`), como na
  versão [desktop](../desktop/README.md). Os projetos Android também têm
  arquivos XML, como o manifesto, porque o Android os lê no momento da
  instalação.

## Passo a passo
Abra o [`MainActivity.kt`](app/src/main/java/com/example/hello/MainActivity.kt)
ao lado desta lista.

1. **`class MainActivity : ComponentActivity()`** declara a tela. Uma
   activity é "one screen" de um aplicativo Android [6] (tradução livre:
   "uma tela"). Os dois-pontos são a sintaxe do Kotlin para "estende"; o
   Java escreve `extends`.
2. **`override fun onCreate(savedInstanceState: Bundle?)`** é executada
   quando a tela é criada. O `override` indica que a função substitui a da
   classe base. O `Bundle?` termina com um ponto de interrogação porque o
   estado salvo é `null` na primeira vez que a tela abre.
3. **`setContent { ... }`** recebe a tela como uma função. As chaves
   descrevem o que a tela mostra. Nas views XML de um aplicativo Java, a
   mesma tela é um layout XML que o `setContentView` carrega.
4. **`MaterialTheme { Surface { Box { Text("Hello, World!") } } }`**
   aninha as funções composable. O `MaterialTheme` define as cores e as
   fontes e segue a configuração de tema claro ou escuro do dispositivo. O
   `Surface` preenche a tela com a cor de fundo, e o `Box` centraliza o seu
   conteúdo.
5. **`Text("Hello, World!")`** é o texto na tela. É uma chamada de função
   com um argumento. O `run.sh --verify` procura exatamente esse texto na
   árvore de views da tela.
6. **`AndroidManifest.xml`** indica que a `.MainActivity` é iniciada quando
   o usuário toca no ícone (a categoria `LAUNCHER`). O `label` é o nome sob
   o ícone.
7. **`build.gradle.kts`** nomeia os níveis do SDK. O `compileSdk = 37` é a
   API do Android com a qual o código é compilado, e o `minSdk = 24` é o
   Android mais antigo que pode instalar o aplicativo [3][4]. O
   `compose = true` ativa o compilador do Compose para este módulo.

## Por que esta toolchain
- **O Jetpack Compose é o toolkit de interface recomendado.** O site Android
  Developers diz: "Jetpack Compose is Android's recommended modern toolkit
  for building native UI" [1] (tradução livre: "O Jetpack Compose é o
  toolkit moderno recomendado do Android para criar interfaces nativas").
  O Compose 1.0 foi anunciado em 28 de julho de 2021, e o anúncio diz: "It's
  stable, and ready for you to adopt in production" [7] (tradução livre:
  "Ele é estável e está pronto para você adotá-lo em produção").
- **O Kotlin é a linguagem que o Google recomenda para o Android.** Na
  Google I/O de 2019, o Google escreveu: "Android development will become
  increasingly Kotlin-first" [8] (tradução livre: "O desenvolvimento para
  Android será cada vez mais Kotlin-first"). A
  [visão geral da linguagem](../README.md) traz as datas e as outras fontes.
- **O emulador dispensa um celular.** O emulador executa imagens de sistema
  do Android no computador [5].

## Notas por plataforma
| Plataforma | Situação | Notas |
|---|---|---|
| macOS Intel | ✅ verificado (2026-11-11) | macOS 26.7.2, Temurin 21.0.8, Gradle 9.8.0, AGP 9.5.1, imagem de emulador do Android 36 (aplicativo compilado com o 37.0). O emulador usa o Hypervisor.Framework [5]. |
| macOS Apple Silicon | ⚠️ não verificado | Os scripts baixam o zip arm64 das ferramentas de linha de comando, e a imagem de sistema deve ser a arm64. O nome da imagem em `android-env.sh` é o do Intel e precisa ser alterado. |
| Linux (Debian/Ubuntu) | ⚠️ não verificado | Nenhum runner foi usado nesta verificação, de modo que os scripts não foram executados lá. O `install.sh` para antes do download e imprime os passos. A aceleração de hardware no Linux usa o KVM, que precisa estar habilitado [5]. |
| Windows (Git Bash / WSL) | ⚠️ não verificado | O `install.sh` para antes do download e imprime os passos. O emulador no Windows precisa de um hipervisor [5]. O WSL não foi verificado. |

Esta pasta não é verificada em integração contínua (CI): o workflow de CI
para Linux e Windows não tem um emulador Android. As verificações são as da
máquina de desenvolvimento.

## Saída esperada
O `./run.sh` abre a janela do emulador, e o aplicativo mostra **Hello,
World!** no meio da tela:

![A janela do Android Emulator com Hello, World! no meio da tela](screenshot.png)

(Capturada em 2026-11-13 em macOS Intel com `screencapture -x -o -l <window-id> screenshot.png`,
que captura somente a janela do emulador. O ID da janela vem da lista
`CGWindowListCopyWindowInfo`, para a janela intitulada "Android Emulator".)

**Janela lenta ou em branco?** O emulador desenha a tela com a CPU quando
tem uma janela, e um Mac ocupado torna isso lento. A primeira inicialização
de um dispositivo novo é a mais lenta, porque é nesse momento que o Android
compila os seus aplicativos. Se a janela continuar preta, dê a ela alguns minutos. Se
mostrar "System UI isn't responding", toque em **Wait** e depois execute
`adb shell am start -W -n com.example.hello/.MainActivity` para abrir o
aplicativo de novo. Antes, feche outros programas pesados. Isso foi
observado na máquina de desenvolvimento enquanto outros builds estavam em
execução.

O `./run.sh --verify` termina com esta saída:
```text
==> 5/5 Check the screen
    WHY: --verify checks two things. ...
[ok] The activity com.example.hello/.MainActivity is on top of the screen.
[ok] The text is on the screen:
Hello, World!
```
A última linha vem do script, e o comando termina com código de saída 0.

## Fontes
1. Jetpack Compose. Android Developers. <https://developer.android.com/jetpack/compose> (acessado em 2026-11-11)
2. Android Gradle plugin release notes and built-in Kotlin. Android Developers. <https://developer.android.com/build/releases/gradle-plugin> e <https://developer.android.com/build/releases/past-releases/agp-9-0-0-release-notes> (acessado em 2026-11-11). Metadados do Maven para a versão: <https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle/maven-metadata.xml> (acessado em 2026-11-11)
3. Set up Compose: dependencies, the Compose compiler plugin and the BOM. Android Developers. <https://developer.android.com/develop/ui/compose/setup-compose-dependencies-and-compiler> (acessado em 2026-11-11). A versão do BOM: <https://dl.google.com/dl/android/maven2/androidx/compose/compose-bom/maven-metadata.xml> (acessado em 2026-11-11)
4. Android Studio downloads, command-line tools only. Android Developers. <https://developer.android.com/studio#command-line-tools-only> (acessado em 2026-11-11). sdkmanager. <https://developer.android.com/tools/sdkmanager> (acessado em 2026-11-11). avdmanager. <https://developer.android.com/tools/avdmanager> (acessado em 2026-11-11)
5. Run Android Emulator on the command line. Android Developers. <https://developer.android.com/studio/run/emulator-commandline> (acessado em 2026-11-11)
6. App manifest overview and the activity element. Android Developers. <https://developer.android.com/guide/topics/manifest/manifest-intro> (acessado em 2026-11-11)
7. Jetpack Compose is now 1.0: announcing Android's modern toolkit for building native UI. Android Developers Blog, 2021-07-28. <https://android-developers.googleblog.com/2021/07/jetpack-compose-announcement.html> (acessado em 2026-11-11)
8. Google I/O 2019: Empowering developers to build the best experiences on Android + Play. Android Developers Blog, 2019-05-07. <https://android-developers.googleblog.com/2019/05/google-io-2019-empowering-developers-to-build-experiences-on-Android-Play.html> (acessado em 2026-11-22)
