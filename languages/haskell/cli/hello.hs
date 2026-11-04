-- hello.hs - Haskell cli: print "Hello, World!" to the terminal.
--
-- Build and run it with ./build.sh and ./run.sh, which explain each step.
-- By hand (from the cli/ folder):
--   ghc -outputdir build -o bin/hello-cli hello.hs
--   ./bin/hello-cli
--
-- Haskell is a purely FUNCTIONAL language. A program is built from
-- functions in the mathematical sense: given the same arguments, a function
-- always returns the same result and changes nothing else. There are no
-- statements that modify variables, as in C, Java or Python. So how can a
-- program print anything? The answer is the type IO, explained below.
--
-- A comment starts with "--" and runs to the end of the line, like "//" in
-- C99, Java or Go. "{- ... -}" is a block comment.

-- Every Haskell program is a module. "module Main (main) where" names this
-- one Main and exports only main. The line could be left out (a file
-- without a header is module Main), but writing it is the usual style.
module Main (main) where

-- This is a TYPE SIGNATURE: "main has the type IO ()".
--   IO ()   is an ACTION that, when it is run, may do input/output and then
--           gives back () ("unit", an empty value, like void in C).
-- The signature is optional, because GHC infers types by itself, but
-- writing it for top-level names is the norm. It also makes the key idea
-- visible: the type of a value tells whether it can have side effects.
-- A function of type String -> String can never print; only IO actions
-- can.
main :: IO ()
-- This is a DEFINITION: main is equal to the action putStrLn "Hello, World!".
-- putStrLn has the type String -> IO (): give it a string and you get an
-- action that writes the string and a newline. Applying a function needs no
-- parentheses or commas: "f x" in Haskell is "f(x)" in C.
--
-- Defining main does not print anything by itself. The Haskell runtime
-- system RUNS the action called main when the program starts. That is the
-- one place where a pure program meets the outside world.
main = putStrLn "Hello, World!"
