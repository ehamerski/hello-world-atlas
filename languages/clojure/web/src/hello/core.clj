;; core.clj - Clojure web: serve "<p>Hello, World!</p>" on port 8080.
;;
;; Run it with ./run.sh, which explains each step. Ring is Clojure's
;; standard web application interface. Its README says it is "inspired by
;; Python's WSGI and Ruby's Rack": a request is a map, a response is a map,
;; and a handler is a function from the first to the second. Spring Boot
;; (../../java/web) uses annotations and classes for the same job.

;; :require loads another namespace. [ring.adapter.jetty :as jetty] means
;; "use the functions of ring.adapter.jetty, and write jetty/ before their
;; names". Java's import and Python's "import x as y" are the closest forms.
(ns hello.core
  (:require [ring.adapter.jetty :as jetty]))

;; A handler. Ring calls it once per HTTP request and passes the request as a
;; map (:uri, :request-method, :headers and so on). This program ignores it,
;; and the parameter name _request, with a leading underscore, says so.
;; The function returns the response as a plain map: the :status code,
;; the :headers (a map of strings) and the :body.
(defn handler [_request]
  {:status  200
   ;; Without a charset, a browser has to guess how to decode the bytes. The
   ;; response says UTF-8. Jetty sends the header in its own form,
   ;; text/html;charset=utf-8, which means the same.
   :headers {"Content-Type" "text/html; charset=UTF-8"}
   :body    "<p>Hello, World!</p>"})

(defn -main [& args]
  ;; System/getenv returns nil when PORT is not set. `or` returns its first
  ;; value that is not nil or false, so "8080" is the default. parse-long
  ;; (Clojure 1.11 and later) turns the text into a number.
  (let [port (parse-long (or (System/getenv "PORT") "8080"))]
    ;; run-jetty starts Jetty and passes it the handler. The options are a
    ;; map: :host "127.0.0.1" listens on this computer only (not on the
    ;; network), :port is the port, and :join? true makes the call block until
    ;; the server stops, so the program does not end right after starting
    ;; Jetty. Ctrl+C stops it.
    (jetty/run-jetty handler {:host "127.0.0.1" :port port :join? true})))
