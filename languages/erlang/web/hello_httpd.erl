%% hello_httpd.erl - Erlang web: serve "Hello, World!" on http://localhost:8080/
%%
%% Build it with ./build.sh, run it with ./run.sh (both explain each step).
%% By hand (from web/):
%%   erlc -o ebin hello_httpd.erl
%%   erl -noshell -pa ebin -s hello_httpd main      (stop with Ctrl+C)
%%   PORT=9000 erl -noshell -pa ebin -s hello_httpd main
%%
%% The server is httpd, the web server of the "inets" application, and it
%% ships with Erlang/OTP: nothing is downloaded, as with PHP's built-in
%% server and unlike Flask (../../python/web). This one module does two jobs:
%% main/0 starts the server, and do/1 is the callback that httpd calls for
%% every request (the "Erlang web server API"). The server runs each request
%% in its own lightweight Erlang process.

-module(hello_httpd).
%% main/0 is called by run.sh. do/1 is called by httpd, so it must be
%% exported too, or httpd could not reach it.
-export([main/0, do/1]).
%% httpd.hrl defines the record #mod{}: the data of one request (method,
%% URI, headers, ...). A record is a tuple with named fields.
-include_lib("inets/include/httpd.hrl").

%% main/0: read the port, start inets and httpd, then wait.
main() ->
    %% os:getenv("PORT") returns the text of the variable, or false when it
    %% is not set. The case expression chooses by PATTERN MATCHING: the
    %% first pattern that fits the value wins. false is an atom, not a
    %% boolean keyword; "Text" binds any other value to the variable Text.
    Port = case os:getenv("PORT") of
               false -> 8080;
               Text  -> list_to_integer(Text)
           end,
    %% inets is an application: a bundle of processes that OTP starts and
    %% supervises. It must be running before an HTTP server can be started.
    %% The "ok =" on the left is an assertion by pattern matching: if
    %% start/0 returned anything but the atom ok, the match would fail
    %% and the program would crash with a clear error. Erlang code
    %% usually does not check for errors by hand: "let it crash".
    ok = inets:start(),
    %% inets:start(httpd, Properties) starts one HTTP server. The properties
    %% are a list of {Key, Value} tuples:
    %%   port, server_name        where it listens, and the name it reports
    %%   bind_address {127,0,0,1} listen on this computer only (an IP address
    %%                            is a tuple of its four numbers)
    %%   server_root, document_root  folders httpd requires; this server
    %%                            sends no file, so the current folder is fine
    %%   modules                  the chain of modules that handle a request,
    %%                            in order. Here there is one: this module.
    {ok, _Pid} = inets:start(httpd, [{port, Port},
                                     {server_name, "localhost"},
                                     {bind_address, {127, 0, 0, 1}},
                                     {server_root, "."},
                                     {document_root, "."},
                                     {modules, [?MODULE]}]),
    %% ?MODULE is a macro that the compiler replaces with hello_httpd.
    %% io:format prints on standard output; ~w prints any term, here the port.
    io:format("Listening on http://localhost:~w/~n", [Port]),
    %% The VM stops when main/0 returns (run.sh ends it with init:stop()).
    %% httpd runs in other processes, so this process only has to wait.
    %% "receive" with no matching message blocks forever: Ctrl+C ends it.
    receive
        never -> ok
    end.

%% do/1 is the httpd callback. httpd calls it once per request, with a
%% #mod{} record. The pattern "#mod{method = Method, request_uri = Uri}"
%% takes two fields out of the record in the function head.
do(#mod{method = "GET", request_uri = "/"}) ->
    %% The answer is {proceed, Data}: "I handled it; pass this data on".
    %% The data is a list with one {response, ...} entry in the format that
    %% the httpd documentation recommends: a header list and a body. The
    %% header list has the status code, the Content-Type, and the
    %% Content-Length; the body is an iolist (here, a plain list of
    %% characters). Without a Content-Length, a client that keeps the
    %% connection open (curl does) cannot tell where the body ends.
    Body = "<p>Hello, World!</p>",
    Head = [{code, 200},
            {content_type, "text/html; charset=UTF-8"},
            {content_length, integer_to_list(length(Body))}],
    {proceed, [{response, {response, Head, Body}}]};
do(_ModData) ->
    %% Any other request (another path or method) gets a 404. The second
    %% clause matches everything the first one did not: Erlang tries the
    %% clauses of a function from top to bottom, and "_ModData" ignores
    %% the argument.
    Body = "<p>Not found</p>",
    Head = [{code, 404},
            {content_type, "text/html; charset=UTF-8"},
            {content_length, integer_to_list(length(Body))}],
    {proceed, [{response, {response, Head, Body}}]}.
