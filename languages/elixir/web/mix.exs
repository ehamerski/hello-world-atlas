# mix.exs - Elixir web: the project file read by Mix, Elixir's build tool.
#
# Build and run it with ./build.sh and ./run.sh, which explain each step.
# By hand (from web/):  mix deps.get && mix compile && mix run --no-halt
#
# This file is Elixir code, not a data format: it is a script (.exs) that
# Mix runs to learn about the project. Compare package.json in Node.js,
# Cargo.toml in Rust or pom.xml in Java, which only describe the project.

# A module groups functions under a name. "do ... end" is how Elixir opens
# and closes a block; there are no braces. The module name is CamelCase.
defmodule HelloWeb.MixProject do
  # "use" runs a macro from another module. Mix.Project adds the callbacks
  # that Mix expects to find here (project/0 and application/0).
  use Mix.Project

  # "def name do ... end" defines a public function. Functions have no
  # "return": the value of the last expression is the result.
  def project do
    # A list of {key, value} pairs written "key: value" is a keyword list,
    # the usual way to pass options in Elixir.
    [
      # :app is an atom: a constant whose value is its own name (like a
      # Ruby symbol). It names the application that this project builds.
      app: :hello_web,
      version: "0.1.0",
      # "~> 1.20" means ">= 1.20.0 and < 2.0.0". Mix stops with an error on
      # an older Elixir.
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Which application module Mix starts when the project starts.
  def application do
    [
      # :logger is part of Elixir; Bandit and this program log through it.
      extra_applications: [:logger],
      # mod: {Module, args} names the module whose start/2 function runs
      # first. It is the entry point of this program (see lib/).
      mod: {HelloWeb.Application, []}
    ]
  end

  # "defp" defines a private function, visible only inside this module.
  defp deps do
    [
      # Plug is a specification for web application modules plus a few
      # tools, including Plug.Router. Bandit is the HTTP server that calls
      # the plug. Both come from Hex, the package repository of the Erlang
      # and Elixir community. "~> 1.14" means ">= 1.14.0 and < 2.0.0"; the
      # exact versions that were used are fixed in mix.lock.
      {:plug, "~> 1.20"},
      {:bandit, "~> 1.14"}
    ]
  end
end
