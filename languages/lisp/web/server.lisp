;;;; server.lisp - Common Lisp web: serve "Hello, World!" on http://localhost:8080/
;;;;
;;;; Build and run it with ./build.sh and ./run.sh, which explain each step.
;;;;
;;;; Compare ../cli/hello.lisp first. The program is still a set of
;;;; definitions in a Lisp image, and MAIN is still the start-up function.
;;;; The new part is Hunchentoot, a web server written in Common Lisp.
;;;; build.sh loads it with Quicklisp BEFORE this file is loaded, so this
;;;; file can use it.
;;;;
;;;; Paradigm (see ../cli/hello.lisp for more): Common Lisp is grouped with
;;;; the FUNCTIONAL languages, but it is not pure. Below, the handler is a
;;;; function whose return value is the page, in the functional style, while
;;;; MAIN starts the server and waits, which are side effects.

;;; A PACKAGE is a namespace for symbols (names), like a Java package or a
;;; Python module. DEFPACKAGE creates HELLO-WEB; (:use :cl) lets it use the
;;; standard Common Lisp names (DEFUN, FORMAT...) without a prefix.
;;; Hunchentoot's names are written with their package prefix instead, as
;;; in HUNCHENTOOT:START, so you can see where each one comes from.
(defpackage :hello-web
  (:use :cl)
  (:export #:main))

;;; Everything below is read inside the HELLO-WEB package.
(in-package :hello-web)

;;; DEFINE-EASY-HANDLER is a MACRO from Hunchentoot. A macro is a function
;;; that receives code (as lists) and returns new code, which the compiler
;;; then compiles. Here it expands into a function named SAY-HELLO plus the
;;; code that registers it for the path "/". C's #define does text
;;; substitution; a Lisp macro works on the program's structure.
;;;   (say-hello :uri "/")  the handler's name and its URL path
;;;   ()                    the request parameters it wants: none
;;; The value of the last form is the response body, like the return value
;;; of a Flask view in ../../python/web.
(hunchentoot:define-easy-handler (say-hello :uri "/") ()
  ;; SETF sets a "place": here the Content-Type header of the reply.
  ;; Hunchentoot's default is already text/html; writing it shows where
  ;; headers are set.
  (setf (hunchentoot:content-type*) "text/html; charset=utf-8")
  "<p>Hello, World!</p>")

;;; MAIN: read the port, start the server, then wait.
(defun main ()
  ;; LET* binds local variables one after another, each one to the value
  ;; of an expression.
  ;;   (sb-ext:posix-getenv "PORT")  the PORT environment variable, or NIL
  ;;   (or a b)                      a if it is not NIL, else b
  ;;   (parse-integer ...)           text to a number
  ;; SB-EXT is SBCL's own package of extensions: the Common Lisp standard
  ;; (1994) has no function for environment variables.
  (let* ((port (parse-integer (or (sb-ext:posix-getenv "PORT") "8080")))
         ;; MAKE-INSTANCE creates an object of a CLOS class (the Common
         ;; Lisp Object System). An EASY-ACCEPTOR listens for connections
         ;; and dispatches them to the easy handlers defined above.
         ;; :address "127.0.0.1" accepts connections from this computer only.
         (acceptor (make-instance 'hunchentoot:easy-acceptor
                                  :address "127.0.0.1" :port port)))
    ;; START opens the port and returns at once: Hunchentoot answers
    ;; requests in its own threads, one per connection.
    (hunchentoot:start acceptor)
    (format t "Listening on http://localhost:~D/~%" port)
    (finish-output)
    ;; MAIN must not return, because the program ends when it does.
    ;; Sleep forever; Ctrl+C interrupts SLEEP with the condition
    ;; SB-SYS:INTERACTIVE-INTERRUPT. HANDLER-CASE catches it (like
    ;; try/catch in Java), stops the server and ends the program normally.
    (handler-case (loop (sleep 60))
      (sb-sys:interactive-interrupt ()
        (hunchentoot:stop acceptor)
        (sb-ext:exit :code 0 :abort t)))))
