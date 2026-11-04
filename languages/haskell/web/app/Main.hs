-- Main.hs - Haskell web: serve "Hello, World!" on http://localhost:8080/
--
-- Build and run it with ../build.sh and ../run.sh, which explain each step.
--
-- Compare ../../cli/hello.hs first: main is still an IO action that the
-- runtime system runs. Here the action starts a web server instead of
-- printing one line. The server is Scotty, a small web framework on top
-- of Warp (the HTTP server) and WAI (the interface between them).

-- A LANGUAGE pragma turns on a GHC extension for this file.
-- OverloadedStrings lets a string literal such as "/" have other text
-- types too, not only String: below, "/" becomes a route pattern and the
-- HTML a lazy Text value. Without it, each would need a conversion call.
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

-- Imports name exactly what is used, so you can see where each comes from.
import Network.Wai.Handler.Warp (defaultSettings, setHost, setPort)
import System.Environment (lookupEnv)
import Web.Scotty (ScottyM, defaultOptions, get, html, scottyOpts, settings)

-- The web app is a VALUE of type ScottyM (): a description of the routes,
-- built by combining smaller descriptions. Nothing runs when it is
-- defined; scottyOpts in main runs it.
--   get "/" action  answers GET requests for the path "/" with the action
--   html text       sends text as the body with Content-Type: text/html
-- get and html are ordinary functions: get takes a path and an action and
-- returns a route. Defining app with them is pure; it does not print, open
-- a port or read the network.
-- The "$" operator applies a function to everything on its right, so
-- "get "/" $ html x" means "get "/" (html x)": it saves parentheses.
app :: ScottyM ()
app = get "/" $ html "<p>Hello, World!</p>"

-- main is a "do" block: a sequence of IO actions, run in order. This is
-- how Haskell writes step-by-step code, and the type IO () says so. Only
-- main is run by the runtime system, so the routes in app come to life
-- only when main passes app to scottyOpts.
main :: IO ()
main = do
  -- "<-" runs an action and names its result. lookupEnv returns a
  -- Maybe String: Just "9000" if PORT is set, Nothing if not. Haskell has
  -- no null; the type forces the code to handle the "not set" case.
  portVar <- lookupEnv "PORT"
  -- "let" names a pure value (no action is run). maybe 8080 read portVar
  -- gives 8080 for Nothing and "read" applied to the text for Just text.
  -- The type annotation ":: Int" tells read what to parse.
  let port = maybe 8080 read portVar :: Int
  putStrLn ("Listening on http://localhost:" ++ show port ++ "/")
  -- Warp's settings: listen on 127.0.0.1 (this computer only) and PORT.
  -- "f . g" is function composition: setHost ... . setPort port applies
  -- setPort first, then setHost, to the default settings. Record update
  -- syntax "defaultOptions { settings = ... }" copies defaultOptions with
  -- one field changed: values are never modified in place.
  let warp = setHost "127.0.0.1" . setPort port $ defaultSettings
  -- Runs the server; this action never finishes on its own (Ctrl+C stops it).
  scottyOpts defaultOptions { settings = warp } app
