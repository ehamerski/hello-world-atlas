// hello.cpp - C++ web: serve "Hello, World!" over HTTP.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The HTTP server is cpp-httplib, a "header-only" library: all of it is
// in the single file httplib.h, so there is no httplib library to link.
// Compare ../../c/web/hello.c, which links GNU libmicrohttpd and passes a
// C function pointer plus a variadic option list to start its server.

#include <cstdlib>   // std::getenv, EXIT_FAILURE
#include <iostream>  // std::cout, std::cerr
#include <stdexcept> // std::exception, thrown by std::stoi
#include <string>    // std::stoi

// All of cpp-httplib's names live in the namespace httplib.
#include <httplib.h>

int main()
{
    // The port comes from the PORT environment variable (default 8080), as
    // in the other web versions. std::stoi turns text into an int; unlike
    // C's atoi, it throws an exception for text that is not a number.
    int port = 8080;
    if (const char *text = std::getenv("PORT")) {
        try {
            port = std::stoi(text);
        } catch (const std::exception &) {
            port = 0; // reported just below
        }
    }
    if (port < 1 || port > 65535) {
        std::cerr << "PORT must be a number from 1 to 65535\n";
        return EXIT_FAILURE;
    }

    // The server is a normal C++ object on the stack: it is cleaned up
    // automatically when main ends (no MHD_stop_daemon by hand as in C).
    httplib::Server server;

    // Register a handler for GET /. The handler is a lambda: an unnamed
    // function written right here. It receives the request and a
    // response to fill in, both by reference (&): the library's objects,
    // not copies and not pointers. Every other path gets 404 Not Found
    // from the library, so there is no strcmp(url, "/") as in C.
    server.Get("/", [](const httplib::Request &, httplib::Response &res) {
        res.set_content("<p>Hello, World!</p>", "text/html; charset=utf-8");
    });

    // Listen on 127.0.0.1 (this computer only), not on every network
    // interface. listen() blocks: it serves requests until the program is
    // stopped (Ctrl+C), and returns false if the port cannot be used.
    std::cout << "Listening on http://localhost:" << port << '\n' << std::flush;
    if (!server.listen("127.0.0.1", port)) {
        std::cerr << "Could not listen on port " << port << '\n';
        return EXIT_FAILURE;
    }
}
