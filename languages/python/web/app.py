# app.py - Python web: a Flask server that answers "Hello, World!".
#
# Run it with:  ./run.sh   then open http://localhost:8080/
#
# Unlike the cli version, this program does not print anything and exit.
# It starts a web server that waits for browsers to ask for a page, and
# answers each request by calling the function below.

# Flask is not part of Python itself: install.sh installs it from PyPI into
# the local .venv folder. "from flask import Flask" loads the Flask class
# from that package (as "import" does in Java or Go).
from flask import Flask

# Create the web application. __name__ is the name of this module ("app");
# Flask uses it to find files that belong to the app.
app = Flask(__name__)


# A decorator (the line starting with "@") wraps the function under it.
# @app.route("/") registers hello_world() as the handler for the URL "/".
# Other frameworks write the same idea differently: Express (Node) uses
# app.get("/", handler), Spring Boot (Java) uses @GetMapping("/"), and Go
# uses http.HandleFunc("/", handler).
@app.route("/")
def hello_world():
    # The returned string is the body of the HTTP response. Flask sends it
    # as an HTML page (Content-Type: text/html), so the browser shows the
    # text inside the <p> paragraph tag.
    return "<p>Hello, World!</p>"

# There is no app.run() here: ./run.sh starts the server with the command
# "flask --app app run --port 8080". "--app app" names this file; Flask
# would also find a file called app.py on its own.
