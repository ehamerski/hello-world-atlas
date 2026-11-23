# app.pl - Perl web: a Mojolicious::Lite server that answers "Hello, World!".
#
# Run it with:  ./run.sh   then open http://localhost:8080/
#
# Unlike the cli version, this program does not print anything and exit.
# It starts a web server that waits for browsers to ask for a page, and
# answers each request by calling the function below.

# Mojolicious is not part of Perl itself: install.sh installs it from CPAN
# into the local folder local/ (run.sh puts that folder on PERL5LIB).
# "Mojolicious::Lite" is its one-file mode. Loading it automatically turns
# on "strict", "warnings" and newer Perl features (the lines the cli
# version wrote by hand), and adds the functions "get", "app" and the others
# used below to this file.
use Mojolicious::Lite;

# get registers a handler for GET requests to the URL "/". The handler is an
# anonymous function: "sub { ... }" is a value that holds code, like a lambda
# in Python or an arrow function in JavaScript. Other frameworks write the
# same idea differently: Flask (Python) uses @app.route("/"), Express (Node)
# uses app.get("/", handler), and Go uses http.HandleFunc("/", handler).
get '/' => sub {
    # $c is the "controller" object that Mojolicious passes in: it holds the
    # request and builds the response. shift takes the first argument of the
    # function (Perl passes arguments in the array @_, without names).
    my $c = shift;

    # render(text => ...) makes the string the body of the HTTP response.
    # format => 'html' sets the Content-Type to text/html, so the browser
    # shows the text inside the <p> paragraph tag.
    $c->render(text => '<p>Hello, World!</p>', format => 'html');
};

# start hands control to Mojolicious, which reads the command line. The
# command "daemon" runs the built-in web server, and "-l" says where it
# listens. ./run.sh runs "perl app.pl daemon -l http://127.0.0.1:8080".
# The program stays in this call, waiting for requests, until Ctrl+C.
app->start;
