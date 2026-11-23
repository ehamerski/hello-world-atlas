// hello.ts - TypeScript cli: prints "Hello, World!".
//
// TypeScript is JavaScript plus types. The compiler (tsc) checks the types,
// then removes them and writes plain JavaScript to build/hello.js.
// Node.js runs that JavaScript file, not this one.

// A constant with a type annotation: ": string" says what kind of value
// "message" holds. The compiler rejects a number here. JavaScript, Python,
// and Ruby have no such check before the program runs.
const message: string = "Hello, World!";

// console.log writes its argument and a newline to standard output.
// "console" is a global that Node.js provides. The line "types": ["node"]
// in tsconfig.json loads the type declarations from @types/node, so tsc
// knows it exists. Like Python and JavaScript, there is no main function
// and no class: the file is the program, and it runs top to bottom.
console.log(message);
