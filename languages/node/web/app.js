// app.js - Node.js web: an Express server that answers "Hello, World!".
//
// Run it with:  ./run.sh   then open http://localhost:8080/
//
// Unlike the cli version, this program does not print the greeting and
// exit. It starts a web server that waits for browsers to ask for a page,
// and answers each request by calling the function given to app.get().

// require() loads a module. Express is not part of Node.js: install.sh
// downloads it from the npm registry into node_modules/, and require
// finds it there. This is the CommonJS module syntax that the Express
// docs use (package.json says "type": "commonjs"). The newer ES module
// syntax would be: import express from "express" (compare Python's
// "from flask import Flask" and Go's import "net/http").
const express = require("express");

// express() creates the application: an object that holds the routes
// (which URL runs which function). "const" declares a variable that is
// never reassigned.
const app = express();

// The port comes from the PORT environment variable (run.sh sets it),
// with 8080 as the default. process.env is Node's view of the
// environment variables, like os.environ in Python.
const port = process.env.PORT || 8080;

// app.get("/", handler) registers a route: GET requests for "/" call the
// arrow function (req, res) => { ... }. req describes the request, res is
// used to answer it. Compare Flask's @app.route("/"), Go's
// http.HandleFunc("/", handler) and Spring Boot's @GetMapping("/").
app.get("/", (req, res) => {
  // res.send() with a string sends it as the response body. Express sets
  // the Content-Type header to text/html, so the browser shows the text
  // inside the <p> paragraph tag.
  res.send("<p>Hello, World!</p>");
});

// app.listen() starts Node's HTTP server on the port. "127.0.0.1" means
// this computer only: other machines on the network cannot connect.
// listen() does not block: it returns at once, and the callback runs when
// the server is ready (or with an error, e.g. if the port is taken). The
// program then stays alive because Node's event loop keeps waiting for
// requests, until you press Ctrl+C.
app.listen(port, "127.0.0.1", (error) => {
  if (error) {
    throw error;
  }
  // `...${port}` is a template literal: ${} inserts a value into the
  // string, like Python's f"...{port}".
  console.log(`Listening on http://localhost:${port}/ (Ctrl+C to stop)`);
});
