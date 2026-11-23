-- app.lua - Lua web: a Pegasus server that answers "Hello, World!".
--
-- Run it with:  ./run.sh   then open http://localhost:8080/
--
-- Unlike the cli version, this program does not print anything and exit.
-- It starts a web server that waits for browsers to ask for a page, and
-- answers each request by calling the function below.

-- Pegasus is not part of Lua itself: install.sh installs it from LuaRocks
-- (the Lua package manager) into the local rocks/ folder, and run.sh tells
-- Lua where to find it. require() loads a module and returns what it
-- exports, here the Pegasus "class" (a table). Python and Java write this
-- as "import"; Node writes "require" too.
local Pegasus = require("pegasus")

-- os.getenv reads an environment variable. It returns nil when the variable
-- is not set, and "or" then picks the default: in Lua, "a or b" is a if a is
-- not nil/false, and b otherwise. tonumber turns the text "8080" into the
-- number 8080.
local port = tonumber(os.getenv("PORT")) or 8080

-- Pegasus:new{...} builds a server. The braces make a table, Lua's only
-- data structure (it works as a list, a dictionary, and an object). A call
-- whose only argument is a table may leave out the parentheses. The host
-- "127.0.0.1" means this computer only: other machines cannot connect.
local server = Pegasus:new({ host = "127.0.0.1", port = port })

-- start() runs the server loop and never returns (until you stop the
-- program). The function we pass is called once for every request. A
-- function is a value in Lua, so it can be passed as an argument, as in
-- JavaScript. Express (Node) writes app.get("/", handler), Flask (Python)
-- uses @app.route("/"), and Go uses http.HandleFunc("/", handler). Here,
-- every URL gets the same answer.
server:start(function(request, response)
    response:statusCode(200)
    -- Without this header the browser would treat the answer as plain
    -- text. "text/html" makes it show the text inside the <p> tag.
    response:addHeader("Content-Type", "text/html")
    -- The argument of write() is the body of the HTTP response.
    -- "response:write(x)" is the same as "response.write(response, x)": the
    -- colon passes the object as the first argument, like "this" in Java.
    response:write("<p>Hello, World!</p>")
end)
