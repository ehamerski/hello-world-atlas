# router.ex - Elixir web: answers GET / with a Hello World page.
#
# A "plug" is the unit of a web application in Elixir: a module (or a
# function) that takes a connection, a data structure that holds the request
# and the response, and returns the connection, changed. Plug.Router is a
# plug that picks one of its routes by the HTTP method and the path.
# Compare Flask's @app.route in Python or Scotty's get in Haskell.

defmodule HelloWeb.Router do
  # "use Plug.Router" runs a macro. It adds the functions "match" and
  # "dispatch" and the macros "get", "post", "match" and so on, which are
  # used below.
  use Plug.Router

  # "plug" adds a step to the pipeline that every request goes through, in
  # order. :match finds the route that fits the request, and :dispatch runs
  # it. Between them you could add plugs for logging or authentication.
  plug :match
  plug :dispatch

  # A route. It answers GET requests for the path "/". "conn" is the
  # connection; Plug.Router creates this variable for the body of every route.
  get "/" do
    # The pipe operator |> passes the result on its left as the FIRST
    # argument of the function on its right. The lines below mean
    #   send_resp(put_resp_content_type(conn, "text/html"), 200, "...")
    # but read from top to bottom, like a pipeline in a shell. Elixir data
    # is immutable: put_resp_content_type does not change conn, it returns a
    # new connection with the header set.
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "<p>Hello, World!</p>")
  end

  # "match _" is the last route and matches any other request. The "_" is
  # a pattern that matches anything. It makes every unknown path get a plain
  # 404 answer that this file controls.
  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
