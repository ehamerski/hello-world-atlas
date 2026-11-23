# TypeScript · cli: Hello, World!

> Part of [Hello World in many languages](../../../README.md) ·
> Language overview: [TypeScript](../README.md)

## What this is
A TypeScript program that prints `Hello, World!` and ends. TypeScript is
"JavaScript with syntax for types", and "TypeScript code converts to
JavaScript" [1]. The TypeScript compiler, `tsc`, checks the types in
`src/hello.ts` and writes `build/hello.js`. Node.js then runs that
JavaScript file.

## Prerequisites
| Tool | Version used (macOS Intel) | Why it is needed |
|---|---|---|
| Node.js 24 or newer, with npm | Node.js 26.8.2, npm 12.2.1 (nvm) | runs `tsc` and the compiled program; npm downloads the compiler |
| TypeScript (`typescript` package) | 7.0.2 (locked in `package-lock.json`) | the compiler, `tsc` |
| `@types/node` | 26.6.6 (locked in `package-lock.json`) | type declarations for the Node.js global `console` [2] |

The `typescript` 7.0.2 package declares `"engines": {"node": ">=16.20.0"}`
and the license Apache-2.0 [3]. This example asks for Node.js 24 or newer
because that is a current long-term support line [4].

## Quick start
```sh
./install.sh   # check Node.js and npm, install the compiler into node_modules/ (asks first)
./build.sh     # compile src/hello.ts to build/hello.js
./run.sh       # run it
```

## Scripts explained
| Script | What it does | Why it is needed |
|---|---|---|
| `install.sh` | 1. Checks for Node.js 24+ and npm, and shows how to install them if missing. 2. Runs `npm ci`, which installs the exact versions in `package-lock.json` into `node_modules/`. Step 2 asks first. | `tsc` is a package from the npm registry, not part of Node.js. `npm ci` is meant for "any situation where you want to make sure you're doing a clean install of your dependencies" [5]. |
| `build.sh` | Runs `npx tsc -p .`. | The `-p` option compiles "the project given the path to its configuration file, or to a folder with a 'tsconfig.json'" [6]. The result is `build/hello.js`. |
| `run.sh` | Runs `node build/hello.js`. `--verify` does the same: the program always exits by itself. | Node.js runs JavaScript, so it runs the compiled file. |
| `typescript-env.sh` | Sourced by the three scripts. It sets the oldest accepted Node.js version and finds `node` and `npm` when they are not on `PATH`. | The scripts work from a shell with a short `PATH`. |

## Folder structure
```text
cli/
├── README.md            this file
├── install.sh           checks Node.js and npm, installs the compiler
├── build.sh             compiles src/hello.ts to build/hello.js
├── run.sh               runs build/hello.js
├── typescript-env.sh    shared settings (sourced, not run)
├── package.json         the project: pinned compiler and type declarations
├── package-lock.json    the exact version and integrity value of every installed package
├── tsconfig.json        the compiler settings (strict mode, input and output folders)
├── src/
│   └── hello.ts         the program
├── build/               created by build.sh; not committed
└── node_modules/        created by install.sh; not committed
```
- **`package.json`** lists the compiler under `"devDependencies"`, the
  place for packages that the project needs only while it is developed
  [7]. The versions are exact (`7.0.2`, not `^7.0.2`), so every student
  installs the same compiler.
- **`package-lock.json`** records an `integrity` value for every package:
  "A `sha512` or `sha1` Standard Subresource Integrity string for the
  artifact that was unpacked in this location" [8]. `npm ci` fails if the
  lock file does not match `package.json` [5].
- **`tsconfig.json`** is the file `tsc -p .` reads [6]. `"strict": true`
  turns on the whole family of strict type-checking options [9]. `"types": ["node"]`
  is needed because "by default `types` is set to `[]`" since
  TypeScript 6.0 [9]. `"outDir": "build"` sends the `.js` files to
  `build/` [9]. `"noEmitOnError": true` writes no output when a type error
  exists [9]. `"module": "nodenext"` is the setting the TypeScript docs
  recommend "for modern Node.js projects" [9].

## Step-by-step walkthrough
Open [`src/hello.ts`](src/hello.ts) next to this list.

1. **`const message: string = "Hello, World!"`** declares a constant with
   a type annotation. The compiler rejects any value that is not a string.
   The annotation exists only for `tsc`: it is removed from the output.
   Compare [Python](../../python/README.md) and [Node.js](../../node/README.md),
   which check nothing before the program runs.
2. **`console.log(message)`** "prints to `stdout` with newline" [10]. The
   name `console` comes from Node.js. `tsc` knows it because `@types/node`
   declares it [2].
3. **No `main` function and no class.** The file is the program and runs
   from top to bottom, as in [Node.js](../../node/cli/README.md).
4. **The output.** `build/hello.js` is the same program without the type
   annotation. Run `cat build/hello.js` to compare.

## Why this toolchain
- **The compiler, `tsc`:** TypeScript 7.0 is "a 10x faster native port of
  TypeScript", built in Go, and `npm install -D typescript` gives you "the
  new `tsc` executable" [11]. The `typescript` package on npm has the
  `latest` tag at 7.0.2 on 2026-11-11 [3].
- **Why compile at all?** Node.js can run TypeScript files directly:
  "By default Node.js will execute TypeScript files that contains only
  erasable TypeScript syntax. Node.js will replace TypeScript syntax with
  whitespace, and no type checking is performed" [12]. Type stripping
  became stable in Node.js 25.2.0 and 24.12.0 [12]. This example uses the
  compiler for these reasons:
  - Type stripping does no type checking [12]. The compiler does, and that
    is the main reason to use TypeScript.
  - Node.js "ignores `tsconfig.json` files" [12], so it ignores the strict
    mode in this folder.
  - The compiler writes a `.js` file, so the result no longer depends on
    how a Node.js version treats `.ts` files.
  To try type stripping, run `node src/hello.ts`. It prints the same
  output, with no check.
- **TypeScript 6.0** is "the last release based on the current JavaScript
  codebase" [13]; TypeScript 7.0 "is made to be compatible with TypeScript
  6.0's type-checking and command-line behavior" [11].

## Platform notes
| Platform | Status | Notes |
|---|---|---|
| macOS Intel | ✅ verified (2026-11-11) | Node.js 26.8.2 (nvm), npm 12.2.1, TypeScript 7.0.2, `@types/node` 26.6.6. |
| macOS Apple Silicon | ⚠️ not verified | Same commands as Intel. The `typescript` package lists a separate native package for `darwin-arm64` [3]. |
| Linux (Debian/Ubuntu) | ⚠️ not verified | `install.sh` does not install Node.js: if version 24 or newer is missing it prints the nodejs.org steps [14] and stops. |
| Windows (Git Bash / WSL) | ⚠️ not verified | `install.sh` prints `winget install --id OpenJS.NodeJS.LTS -e` [15] and stops if Node.js is missing. |

On macOS, if Node.js is missing, `install.sh` offers `brew install node`
[16].

## Expected output
Run these commands in this folder:
```sh
./install.sh && ./build.sh && ./run.sh
```
The last command prints:
```text
==> Run the program
    WHY: 'node build/hello.js' runs the compiled JavaScript.
Hello, World!
```
The program itself prints only the last line. Run `node build/hello.js`
to see only that line.

## Sources
1. TypeScript: JavaScript with syntax for types (home page). Microsoft. <https://www.typescriptlang.org/> (accessed 2026-11-11)
2. @types/node ("TypeScript definitions for node"). DefinitelyTyped, npm registry. <https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/node> (accessed 2026-11-11)
3. typescript (package metadata: dist-tags, engines, license, platform packages). npm registry. <https://registry.npmjs.org/typescript> (accessed 2026-11-11)
4. Node.js Releases. OpenJS Foundation. <https://nodejs.org/en/about/previous-releases> (accessed 2026-11-11)
5. `npm ci`. npm Docs. <https://docs.npmjs.com/cli/commands/npm-ci> (accessed 2026-11-11)
6. TypeScript compiler options: CLI commands, `--project`. Microsoft. <https://www.typescriptlang.org/docs/handbook/compiler-options.html> (accessed 2026-11-11)
7. package.json (`devDependencies`). npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-json> (accessed 2026-11-11)
8. package-lock.json. npm Docs. <https://docs.npmjs.com/cli/configuring-npm/package-lock-json> (accessed 2026-11-11)
9. Reference for `tsconfig.json`: `strict`, `outDir`, `types`, `module`, `noEmitOnError`. Microsoft. <https://www.typescriptlang.org/tsconfig/> (accessed 2026-11-11)
10. Console: `console.log()`. Node.js v26 Documentation. <https://nodejs.org/api/console.html> (accessed 2026-11-11)
11. Announcing TypeScript 7.0. Microsoft, TypeScript blog, 2026-07-08. <https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/> (accessed 2026-11-11)
12. Modules: TypeScript. Node.js v26 Documentation. <https://nodejs.org/api/typescript.html> (accessed 2026-11-11)
13. Announcing TypeScript 6.0. Microsoft, TypeScript blog, 2026-03-23. <https://devblogs.microsoft.com/typescript/announcing-typescript-6-0/> (accessed 2026-11-11)
14. Download Node.js. OpenJS Foundation. <https://nodejs.org/en/download> (accessed 2026-11-11)
15. `OpenJS.NodeJS.LTS` manifests. microsoft/winget-pkgs (GitHub). <https://github.com/microsoft/winget-pkgs/tree/master/manifests/o/OpenJS/NodeJS/LTS> (accessed 2026-11-11)
16. node (Homebrew formula). Homebrew. <https://formulae.brew.sh/formula/node> (accessed 2026-11-11)
