// main.go - Go web: a web server that answers "/" with <p>Hello, World!</p>.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// Then open http://localhost:8080/ in a browser.
// Everything here comes from Go's standard library: unlike ../../python/web
// (Flask) or ../../java/web (Spring Boot), no web framework is downloaded.

package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
)

// page is the HTML template. {{.}} ("dot") is replaced by the data passed to
// Execute, here the string "Hello, World!". html/template escapes that data
// for HTML: a message containing "<script>" would be shown as text, not run.
// Real apps keep templates in their own .html files (template.ParseFiles);
// one line does not need a file.
// template.Must stops the program at start-up if the template has an error.
var page = template.Must(template.New("page").Parse("<p>{{.}}</p>"))

// hello is a handler: net/http calls it once for every matching request.
// w is where the response is written; r describes the request (method,
// path, headers). The "*" means r is a pointer: the handler gets the
// address of the request, not a copy of it.
func hello(w http.ResponseWriter, r *http.Request) {
	// Execute fills the template and writes the result to w. Before the
	// first write, net/http detects the content type (text/html here) and
	// sends the status 200 OK.
	if err := page.Execute(w, "Hello, World!"); err != nil {
		// Go has no exceptions: functions return an error value, and the
		// caller checks it. Compare try/except in Python.
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func main() {
	// The port comes from the PORT environment variable (default 8080), as
	// in the Python and Java versions.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Register the handler. Since Go 1.22 a pattern can name the HTTP
	// method: "GET /{$}" matches GET (and HEAD) requests for exactly "/".
	// Without {$}, the pattern "/" would match every path.
	http.HandleFunc("GET /{$}", hello)

	// Listen on 127.0.0.1 (this computer only) and serve requests until
	// the program is stopped. ListenAndServe only returns on an error (for
	// example, the port is already in use); log.Fatal prints it and exits.
	addr := "127.0.0.1:" + port
	log.Printf("Listening on http://localhost:%s/", port)
	log.Fatal(http.ListenAndServe(addr, nil))
}
