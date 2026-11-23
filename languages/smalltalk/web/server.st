"server.st - Smalltalk web: an HTTP server using Zinc HTTP Components.

WHAT: starts a ZnServer on localhost that answers every request for /
      with a simple HTML page containing Hello, World (plus a greeting mark).
WHY:  Zinc HTTP Components (ZnServer) is the standard HTTP library for
      Pharo Smalltalk. It provides ZnServer, a lightweight multi-threaded
      HTTP server. Zinc is included in the standard Pharo 14 image, so no
      extra packages are needed.
HOW:  Run via run.sh, which calls:
        pharo Pharo.image st server.st

Sources:
  Zinc HTTP Components: https://github.com/svenvc/zinc
  OSEnvironment API:    Pharo standard library, Pharo 14.
  ZnServer API:         https://pharo.org/documentation

Port is read from the PORT environment variable; defaults to 8080.
run.sh manages the server lifetime; this script runs until killed.

Note: In Pharo .st chunk format, ASCII 33 (the exclamation-mark character)
ends a code chunk. It is therefore built by concatenation below,
not written as a literal inside comments or strings.
"

| port server bang body |

" Build the response body. ASCII 33 is the exclamation-mark character.
  It is computed here rather than written literally so the chunk parser
  does not treat it as a chunk separator. "
bang := (Character value: 33) asString.
body := '<html><body><p>Hello, World', bang, '</p></body></html>'.

" Read PORT from the environment; fall back to 8080.
  OSEnvironment current provides access to the process environment. "
port := (OSEnvironment current at: 'PORT' ifAbsent: [ '8080' ]) asInteger.

" ZnServer startOn: creates and starts the server synchronously.
  After this call, the server is immediately ready to accept connections. "
server := ZnServer startOn: port.

" Register a handler for every incoming request.
  onRequestRespond: sets a block that receives a ZnRequest and returns a ZnResponse.
  ZnResponse ok: wraps the entity in a 200 OK response.
  ZnEntity html: wraps a string in a text/html entity. "
server onRequestRespond: [ :request |
    ZnResponse ok: (ZnEntity html: body) ].

" Print the URL so the student knows the server is running.
  Stdio stdout writes directly to the process standard output in headless mode. "
Stdio stdout nextPutAll: 'Listening on http://localhost:', port printString; lf.

" Keep the server running until this process is killed (Ctrl+C or trap in run.sh).
  The loop checks every 500 ms to avoid busy-waiting. "
[ server isRunning ] whileTrue: [ (Delay forMilliseconds: 500) wait ].
