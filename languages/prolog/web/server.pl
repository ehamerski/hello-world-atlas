% server.pl - Prolog web: serve "Hello, World!" on http://localhost:8080/
%
% Run it with ./run.sh, which explains each step. By hand (from web/):
%   swipl server.pl                 (stop with Ctrl+C)
%   PORT=9000 swipl server.pl       use another port
%
% Compare ../cli/hello.pl first. The program is still a set of clauses and
% runs by proving the goal main. The new part is SWI-Prolog's HTTP server,
% which ships with SWI-Prolog as a set of library modules: nothing is
% downloaded, unlike Flask (Python) or Scotty (../../haskell/web).
%
% Paradigm (see ../cli/hello.pl for more): Prolog is a LOGIC language. The
% server does not call a function for each request; it asks Prolog to
% PROVE the goal say_hello(Request), and the reply is written while the
% proof runs, as a side effect.

% use_module/1 loads a library module and imports its public predicates,
% like "import" in Java or Python.
%   thread_httpd   the HTTP server; each request is handled by a pool of
%                  worker threads (http_server/2 comes from here)
%   http_dispatch  maps URL paths to handler predicates (http_handler/3)
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

% As in ../cli: when the file is loaded, prove main, then stop.
:- initialization(main, main).

% A DIRECTIVE that registers a handler: requests for the path "/" are
% answered by proving say_hello(Request). root(.) means "the root of the
% server", that is "/". The last argument is a list of options (none).
% The directive passes the predicate NAME say_hello, without arguments; for each request
% the server adds the request as the extra argument and proves
% say_hello(Request). Here the predicate plays the role of a callback.
:- http_handler(root(.), say_hello, []).

% say_hello(+Request) is the handler. Request is a list describing the
% HTTP request (method, path, headers, and so on). This handler does not need it;
% a name starting with "_" tells Prolog (and the reader) that the variable
% is unused.
%
% The server collects what the handler writes to standard output and sends
% it to the browser: first the CGI-style header lines, then an empty line
% ("~n~n"), then the body. Python's Flask returns a string instead; here
% the reply is a side effect of proving the goal.
say_hello(_Request) :-
    format("Content-type: text/html; charset=UTF-8~n~n"),
    format("<p>Hello, World!</p>").

% main/0: read the port, start the server, then wait.
%
% The first goal is an if-then-else: ( Condition -> Then ; Else ).
% getenv/2 SUCCEEDS if the PORT environment variable exists, binding
% Value to its text; then atom_number/2 converts it to the number Port.
% If getenv/2 FAILS, Prolog takes the Else branch and Port is 8080.
% Failing is not an error in Prolog: it is how a test answers "no".
%
% In Prolog, a name starting with an uppercase letter is a VARIABLE, and
% a variable is set once, by unification ("Port = 8080" makes Port and
% 8080 the same; it is not an assignment that can change later).
main :-
    (   getenv('PORT', Value)
    ->  atom_number(Value, Port)
    ;   Port = 8080
    ),
    % localhost:Port listens on this computer only. http_server/2 starts
    % the server in background threads and returns at once.
    http_server(http_dispatch, [port(localhost:Port)]),
    format("Listening on http://localhost:~w/~n", [Port]),
    % main must not finish, or initialization(main, main) would stop the
    % program and the server with it. thread_get_message/1 waits for a
    % message on this thread's queue; nobody sends one, so it waits until
    % you press Ctrl+C.
    thread_get_message(_).
