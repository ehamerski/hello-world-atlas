// server.ts - TypeScript web: a node:http server that answers "Hello, World!".
//
// tsc compiles this file to build/server.js, and Node.js runs that file.
// The program does not print and exit. It starts a server that waits for
// browsers and answers each request with the function given to createServer.

// "import ... from" loads a module. "node:http" is built into Node.js, so
// npm downloads nothing for it (compare ../../node/web, which needs Express).
// The "node:" prefix tells Node.js that this is a built-in module. The types
// for it come from @types/node, which tsc reads for compile-time checks only.
import { createServer } from "node:http";

// The port comes from the PORT environment variable, with 8080 as the
// default. process.env values are strings or undefined, and the type system
// makes you handle undefined: "??" takes the right side when the left is
// undefined. "Number(...)" converts the text to a number.
const port: number = Number(process.env.PORT ?? 8080);

// createServer takes a function that runs once per request. The parameters
// "request" and "response" have their types inferred from the library, so
// no annotation is needed. The "_" prefix marks "request" as unused.
const server = createServer((_request, response) => {
  // writeHead sets the status code and the headers. text/html makes the
  // browser render the body as a page.
  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  // end sends the body and finishes the response.
  response.end("Hello, World!");
});

// listen starts the server on the port. "127.0.0.1" means this computer
// only: other machines on the network cannot connect. listen returns at
// once. The program stays alive because Node.js keeps waiting for requests,
// until you press Ctrl+C. The callback runs when the server is ready.
server.listen(port, "127.0.0.1", () => {
  console.log(`Listening on http://localhost:${port}/ (Ctrl+C to stop)`);
});
