// main.go - Go web-vue (backend): a JSON API for the Vue front end.
//
// GET /api/hello answers {"message":"Hello, World!"}. This server sends no
// HTML at all: the page is drawn by Vue in the browser (see ../frontend).
// Compare ../../web, where the Go server fills an HTML template itself.
// Build and run both parts with ../build.sh and ../run.sh.

package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
)

// Greeting is the shape of the JSON answer. A struct groups named fields,
// like a Java record or a Python dataclass. The text in backquotes is a
// struct tag: it tells encoding/json to call the field "message" in the
// JSON. Without it the key would be "Message", the Go field name.
type Greeting struct {
	Message string `json:"message"`
}

// hello handles GET /api/hello.
func hello(w http.ResponseWriter, r *http.Request) {
	// Say what the body is, so the browser (and Vite's proxy) treat it as JSON.
	w.Header().Set("Content-Type", "application/json")
	// Encode writes the struct as JSON to w. Greeting{...} creates a value
	// of type Greeting with Message set.
	if err := json.NewEncoder(w).Encode(Greeting{Message: "Hello, World!"}); err != nil {
		log.Print(err)
	}
}

func main() {
	// The API's port comes from PORT (default 8080). ../run.sh sets it, and
	// ../frontend/vite.config.js reads the same variable for its proxy.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// The /api prefix keeps API paths apart from the front end's pages.
	http.HandleFunc("GET /api/hello", hello)

	log.Printf("API listening on http://localhost:%s/api/hello", port)
	log.Fatal(http.ListenAndServe("127.0.0.1:"+port, nil))
}
