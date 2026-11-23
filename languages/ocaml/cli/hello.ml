(* hello.ml - OCaml Hello World.
   An OCaml comment is text between an opening and a closing comment mark.
   Comments can nest, so you can comment out code that has comments. *)

(* A .ml file is a module. The program is the sequence of phrases in it.
   OCaml has no main function: the phrases run from top to bottom. *)

(* print_endline is in the Stdlib module, which OCaml opens for you.
   It writes the string and a newline, then flushes standard output.
   print_string would omit the newline. *)
(* The "let () =" form binds the result of the right-hand side to the
   pattern (), the only value of type unit. It is the usual way to write
   an action that returns nothing useful. *)
let () = print_endline "Hello, World!"
(* Compared with C or Java: there is no semicolon after the phrase, no
   braces, and no entry-point function to declare. *)
