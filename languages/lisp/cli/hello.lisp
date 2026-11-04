;;;; hello.lisp - Common Lisp cli: print "Hello, World!" to the terminal.
;;;;
;;;; Build and run it with ./build.sh and ./run.sh, which explain each step.
;;;; Quick try without building (from the cli/ folder):
;;;;   sbcl --script hello.lisp      (prints nothing: see the last comment)
;;;;   sbcl --noinform --eval '(load "hello.lisp")' --eval '(main)' --quit
;;;;
;;;; Lisp code is made of LISTS written in parentheses. The first element of a
;;;; list names the function (or macro, or special operator) and the rest are
;;;; its arguments: (+ 1 2) is 1 + 2 in C. This "prefix" notation is the same
;;;; for everything, and because code is itself a list, a Lisp program can
;;;; build and change code as data (that is what macros do).
;;;;
;;;; Common Lisp is grouped with the FUNCTIONAL languages: functions are
;;;; values that can be passed around and returned, and programs are often
;;;; written as expressions that compute results rather than as steps that
;;;; change variables. Unlike Haskell (../../haskell/cli) it is not PURE:
;;;; any function may print or change data, as FORMAT below does.
;;;;
;;;; A comment starts with ";" and runs to the end of the line. By
;;;; convention, ";;;;" starts a file header, ";;;" a top-level comment,
;;;; and ";;" a comment inside code.

;;; DEFUN defines a named function: (defun name (parameters) body...).
;;; MAIN has no parameters, so its parameter list is the empty list ().
;;; The name "main" is a choice of this program: Common Lisp has no required entry point.
;;; build.sh tells SBCL to call this function when the program starts.
(defun main ()
  ;; FORMAT writes formatted text, like printf in C.
  ;;   T                the destination: T means the standard output
  ;;   "Hello, World!~%"  the control string; ~% is FORMAT's newline
  ;;                    directive, where C would use \n
  ;; Every Lisp form returns a value. FORMAT to T returns NIL (Lisp's
  ;; "nothing" and "false"), so MAIN returns NIL too; nobody uses it.
  (format t "Hello, World!~%"))

;;; Loading this file only DEFINES main; it does not call it. That is why
;;; "sbcl --script hello.lisp" prints nothing, and why build.sh saves a
;;; program whose start-up function is MAIN.
