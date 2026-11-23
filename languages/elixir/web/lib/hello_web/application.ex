# application.ex - Elixir web: starts the web server.
#
# Mix starts this module because mix.exs says "mod: {HelloWeb.Application, []}".
# It is the counterpart of main() in other languages, but it does not run the
# program itself. It only describes which processes the program is made of.
#
# Elixir processes are not operating system processes. They are very light
# units of work managed by the BEAM, the Erlang virtual machine, which also
# runs Erlang (see languages/erlang). They share nothing and talk by
# sending messages. A "supervisor" is a process whose only job is to start
# other processes and to restart them if they crash. This is the BEAM way of
# building a server that keeps running when something fails.

# The file is .ex, not .exs: it is meant to be compiled (by "mix compile")
# into a .beam file in _build/.
defmodule HelloWeb.Application do
  # "use Application" makes this module an OTP application callback module.
  # OTP is the set of libraries and conventions that comes with Erlang.
  use Application

  # "@impl true" says that the next function implements a callback of the
  # behaviour above. The compiler warns if the name or arity is wrong.
  @impl true
  # Mix calls start/2 once when the application starts. The two arguments
  # are the start type and the start arguments; this program uses neither,
  # and a name that starts with "_" tells the compiler that it is unused.
  def start(_type, _args) do
    # System.get_env/1 returns the value of an environment variable, or nil
    # if it is not set. Elixir has no null keyword: nil is an atom.
    # "case" matches the value against patterns, top to bottom. The pattern
    # "nil" matches only nil; the variable "text" matches anything else and
    # names it. This is pattern matching, the central idea of Elixir.
    port =
      case System.get_env("PORT") do
        nil -> 8080
        # String.to_integer/1 stops the program with an error if the text is
        # not a number (for example PORT=abc).
        text -> String.to_integer(text)
      end

    # A child specification says which process to start. {Bandit, options}
    # starts Bandit with these options (see the Bandit documentation):
    #   plug: HelloWeb.Router  the plug that answers every request
    #   ip: :loopback          listen on 127.0.0.1 only, so other computers
    #                          cannot connect (:any would listen on every
    #                          network interface)
    #   port: port             the number read above
    children = [
      {Bandit, plug: HelloWeb.Router, ip: :loopback, port: port}
    ]

    # Start a supervisor for these children. "one_for_one" means that if
    # one child stops, only that child is restarted.
    # The result is {:ok, pid}, a tuple that tells Mix that it worked.
    Supervisor.start_link(children, strategy: :one_for_one, name: HelloWeb.Supervisor)
  end
end
