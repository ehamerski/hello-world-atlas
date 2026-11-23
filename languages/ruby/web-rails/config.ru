# config.ru - Ruby on Rails web: the whole Rails application in one file.
#
# Run it with:  ./run.sh   then open http://localhost:8080/
#
# A config.ru ("rackup file") is the entry point of a Rack application: Rack
# is the standard interface between Ruby web servers and Ruby web apps.
# Every Rails application is a Rack application, and a Rails project made
# by "rails new" has a config.ru like this one too; it just spreads the
# code below over dozens of files. This file keeps only what an HTML
# "Hello, World!" needs, in the way the Rails contributors' own bug-report
# template does.

# Load only the parts of Rails that are used. "action_controller/railtie"
# brings in Rails::Application, the router, and controllers. The "rails/all"
# line that "rails new" apps use would also load Active Record, Active Job,
# Action Mailer, and more.
require "action_controller/railtie"

# Rails::Application is the class that represents a Rails app. Here it is
# subclassed, as in every Rails project (config/application.rb does the
# same). Its settings go in the class body.
class HelloApp < Rails::Application
  # Use the default settings of Rails 8.1, as config/application.rb does in
  # an app made by "rails new". Without it, Rails keeps older defaults.
  config.load_defaults 8.1
  # Rails looks for files (views, config) under the root folder.
  config.root = __dir__
  # Load code on demand: with only two classes there is nothing to preload.
  config.eager_load = false
  # Rails needs a secret key to initialize. It is only used for signed
  # cookies, which this app never sets, so a random value for each run is
  # enough here. A real app keeps its secret out of the source code.
  config.secret_key_base = SecureRandom.hex(64)
  # Write the log to the terminal, so ./run.sh shows each request.
  config.logger = Logger.new($stdout)
end

# initialize! runs Rails' start-up sequence: it reads the settings,
# builds the router and loads the frameworks.
HelloApp.initialize!

# The routes table maps a URL to a controller action. The line below says:
# a GET request for "/" is handled by the "index" action of the "hello"
# controller. Rails projects keep this in config/routes.rb.
Rails.application.routes.draw do
  root to: "hello#index"
end

# A controller is a class whose public methods are actions. The class name
# HelloController matches "hello" in the route above: that naming rule is
# an example of Rails' convention over configuration. ActionController::Base
# adds the request, the response, and render.
class HelloController < ActionController::Base
  def index
    # render html: sends a string as an HTML page (Content-Type: text/html).
    # Rails escapes HTML in strings by default, to prevent injection of
    # scripts; html_safe says that this text is trusted HTML.
    render html: "<p>Hello, World!</p>".html_safe
  end
end

# run is Rack's way to say "this object is the application". A Rails::Application
# is a Rack app: the server calls it once for each HTTP request.
run HelloApp
