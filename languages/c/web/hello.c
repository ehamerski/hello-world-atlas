/*
 * hello.c - C web: a web server that answers "/" with <p>Hello, World!</p>.
 *
 * Build and run it with ./build.sh and ./run.sh, which explain each step.
 * Then open http://localhost:8080/ in a browser.
 *
 * The C standard library has no networking at all (Go has net/http, Java
 * and Python have HTTP servers in their standard libraries), so the HTTP
 * server is GNU libmicrohttpd, a small C library made to be embedded in
 * programs like this one. Its header uses C99 types (<stdint.h>,
 * long long), so this folder is compiled as C99, not C89 like ../cli.
 * The code below still keeps to the C89 style: comments in slash-star
 * form and every declaration at the top of its block.
 */

/* Standard C headers: the ANSI part of this program. */
#include <stdio.h>  /* printf, fprintf */
#include <stdlib.h> /* getenv, atoi, EXIT_FAILURE */
#include <string.h> /* strcmp, memset */

/*
 * The network address types are not standard C either: they come from the
 * operating system. #ifdef is the preprocessor's "if": it keeps or drops
 * lines before compiling. Windows (_WIN32) declares struct sockaddr_in in
 * its Winsock headers, which microhttpd.h already includes there; POSIX
 * systems (macOS, Linux) declare it in <netinet/in.h>.
 */
#ifndef _WIN32
#include <netinet/in.h> /* struct sockaddr_in, htons, htonl, INADDR_LOOPBACK */
#endif

/* libmicrohttpd's API. Its names all start with MHD_ (C has no namespaces). */
#include <microhttpd.h>

/*
 * The page. "static const char page[]" is an array of characters that ends
 * with an invisible '\0' byte: that is all a string is in C. sizeof page
 * counts that '\0' too, so the body length is sizeof page - 1.
 */
static const char page[] = "<p>Hello, World!</p>";
static const char not_found[] = "<p>Not Found</p>";

/*
 * The request handler. libmicrohttpd calls it for every request; it was
 * registered in main() by passing its name, which in C is a pointer to the
 * function (Go and Python pass functions the same way, Java uses lambdas).
 * The signature is fixed by libmicrohttpd; this program only needs url and
 * connection, and the "(void) name;" lines tell the compiler the other
 * parameters are unused on purpose (otherwise -Wextra warns).
 * "static" means the function is private to this file.
 */
static enum MHD_Result answer(void *cls, struct MHD_Connection *connection,
                              const char *url, const char *method,
                              const char *version, const char *upload_data,
                              size_t *upload_data_size, void **req_cls)
{
    /* C89 style: declare all variables at the start of the block. */
    struct MHD_Response *response;
    enum MHD_Result result;
    unsigned int status = MHD_HTTP_OK;
    const char *body = page;
    size_t length = sizeof page - 1;

    (void) cls; (void) method; (void) version;
    (void) upload_data; (void) upload_data_size; (void) req_cls;

    /*
     * Only the path "/" exists, as in the other web versions. strcmp
     * compares two strings and returns 0 when they are equal: C has no
     * == for strings (== would compare the two addresses).
     */
    if (strcmp(url, "/") != 0) {
        status = MHD_HTTP_NOT_FOUND;
        body = not_found;
        length = sizeof not_found - 1;
    }

    /*
     * A response object points at the body. "static" tells libmicrohttpd
     * the text never changes or goes away, so it is not copied.
     */
    response = MHD_create_response_from_buffer_static(length, body);
    if (response == NULL)
        return MHD_NO; /* out of memory: libmicrohttpd closes the connection */
    MHD_add_response_header(response, MHD_HTTP_HEADER_CONTENT_TYPE,
                            "text/html; charset=utf-8");

    /*
     * Queue it for sending, then release this function's handle at once:
     * libmicrohttpd keeps what it still needs until the response is sent.
     * C has no garbage collector: whatever is created must be released by
     * hand.
     */
    result = MHD_queue_response(connection, status, response);
    MHD_destroy_response(response);
    return result;
}

int main(void)
{
    const char *port_text;
    int port;
    struct sockaddr_in address;
    struct MHD_Daemon *daemon;

    /* The port comes from the PORT environment variable (default 8080),
     * as in the other web versions. getenv returns NULL when it is unset;
     * atoi turns text into a number (and returns 0 for non-numbers). */
    port_text = getenv("PORT");
    port = port_text != NULL ? atoi(port_text) : 8080;
    if (port < 1 || port > 65535) {
        fprintf(stderr, "PORT must be a number from 1 to 65535\n");
        return EXIT_FAILURE;
    }

    /*
     * Listen on 127.0.0.1 (this computer only), not on every network
     * interface. memset fills the struct with zero bytes first, because C
     * does not initialize local variables. htons and htonl put the numbers
     * in network byte order (big-endian), as the socket API requires.
     */
    memset(&address, 0, sizeof address);
    address.sin_family = AF_INET;
    address.sin_port = htons((unsigned short) port);
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    /*
     * Start the server. MHD_start_daemon takes flags, the port, two
     * callbacks with their extra data (no access policy: NULL, NULL; then
     * answer), and a list of options that ends with MHD_OPTION_END. That
     * list is a C variadic argument list (like printf's), so nothing checks
     * the types: the order must match the documentation exactly.
     * MHD_USE_ERROR_LOG prints libmicrohttpd's errors to stderr. With no
     * threading flag, the server runs in this thread, inside the loop below.
     */
    daemon = MHD_start_daemon(MHD_USE_ERROR_LOG, (uint16_t) port,
                              NULL, NULL, &answer, NULL,
                              MHD_OPTION_SOCK_ADDR_LEN,
                              (socklen_t) sizeof address,
                              (const struct sockaddr *) &address,
                              MHD_OPTION_END);
    if (daemon == NULL) {
        fprintf(stderr, "Could not start the server (is port %d in use?)\n",
                port);
        return EXIT_FAILURE;
    }

    printf("Listening on http://localhost:%d/\n", port);
    /* stdout is buffered when it is not a terminal; flush so the line shows
     * up at once, for example in a log file. */
    fflush(stdout);

    /*
     * The event loop: wait for network activity (-1 = no time limit), then
     * handle it, forever. Ctrl+C ends the program; the operating system
     * then closes the socket and frees the memory. A longer-running program
     * would catch the signal and call MHD_stop_daemon(daemon).
     */
    for (;;)
        MHD_run_wait(daemon, -1);
}
