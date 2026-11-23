;; core.clj - Clojure cli: print "Hello, World!".
;;
;; Run it with ./run.sh, which explains each step. There is no build step:
;; Clojure compiles this file to JVM bytecode in memory when it loads it.

;; ns declares the namespace of this file. Namespaces are Clojure's modules:
;; hello.core must live in src/hello/core.clj, because the namespace name
;; maps to a path, with dots as folders. Java does the same with packages,
;; but there a class needs a file named after it; here the file holds any
;; number of functions. (Common Lisp has packages too, but they are not tied
;; to files.)
;; ":gen-class" is NOT used: it would generate a Java class ahead of time,
;; which "clojure -M -m" does not need.
(ns hello.core)

;; defn defines a function: its name, its parameter list in square brackets,
;; and its body. This is a macro, and a Lisp one: the whole line is a list
;; whose first item is the operator, as in Common Lisp's defun.
;;
;; -main is only a convention: "clojure -M -m hello.core" looks for a
;; function with this name in the namespace and calls it with the command-line
;; arguments. "& args" collects them all in a sequence; the program ignores
;; them, unlike Java's main, which makes you declare String[] args anyway.
(defn -main [& args]
  ;; println prints its argument followed by a newline. A string is written
  ;; in double quotes. The call is an expression, and so is every function
  ;; body: the value of the last expression is the function's result (here
  ;; nil, "nothing"). No semicolon ends the line: the parentheses do.
  (println "Hello, World!"))
