# app.rb - Ruby web: a Sinatra server that answers "Hello, World!".
#
# Run it with:  ./run.sh   then open http://localhost:8080/
#
# Unlike the cli version, this program does not print anything and exit.
# It starts a web server that waits for browsers to ask for a page, and
# answers each request by running the block below.

# Sinatra is not part of Ruby itself: install.sh installs it into the local
# vendor/ folder. require loads the library, as "import" does in Python or
# Java. Sinatra applications "can be run directly" with "ruby app.rb": when
# the file ends, Sinatra starts its web server by itself. Flask needs a
# separate "flask run" command for that.
require "sinatra"

# set changes a setting of the application. The port comes from the PORT
# environment variable (8080 when it is not set), as in the other web
# versions of this repository; ENV.fetch gives a default for a missing key.
# bind says which network address to listen on: 127.0.0.1 is this computer
# only, so nobody else on the network can reach the server.
set :port, ENV.fetch("PORT", "8080").to_i
set :bind, "127.0.0.1"

# get "/" registers the block under it as the handler for GET requests for
# the URL "/". Other frameworks write the same idea differently: Flask
# (Python) uses @app.route("/"), Express (Node) uses app.get("/", handler),
# and Spring Boot (Java) uses @GetMapping("/"). Sinatra calls this a
# "route" and the language feature behind it, a block between do and end,
# is a piece of code passed to a method.
get "/" do
  # The value of the last expression is the body of the HTTP response.
  # Sinatra sends it as an HTML page (Content-Type: text/html), so the
  # browser shows the text inside the <p> paragraph tag. There is no
  # "return": in Ruby a block or method returns its last expression.
  "<p>Hello, World!</p>"
end
