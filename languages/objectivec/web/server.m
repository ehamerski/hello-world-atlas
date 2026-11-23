// server.m — Objective-C web: HTTP server using BSD sockets and Foundation.
//
// WHAT: a minimal HTTP/1.1 server on localhost:8080 (or $PORT) that returns
//       "Hello, World!" in an HTML page for every GET / request.
// WHY:  BSD sockets (POSIX) are available on macOS and Linux without any extra
//       framework. Foundation (NSString, NSLog) formats the response and
//       handles string encoding. Using only Foundation and standard POSIX keeps
//       the dependency list to zero — no CFNetwork, no GCD, no third-party libs.
// HOW:  ./build.sh            compile server.m → server
//       ./run.sh              start the server
//       ./run.sh --verify     self-check: start, curl once, stop
//
// Platforms: macOS Intel (verified on the dev machine); Linux with GNUstep
// is attempted in CI (see ci/skip.yml if it fails there).
//
// References:
//   POSIX socket API:
//     https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/sys_socket.h.html
//   Foundation framework:
//     https://developer.apple.com/documentation/foundation
//   HTTP/1.1 response format:
//     https://www.rfc-editor.org/rfc/rfc9110

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

// Server socket fd, accessed by the signal handler to close the socket cleanly.
static int g_server_fd = -1;
static volatile int g_keep_running = 1;

// SIGINT / SIGTERM handler: flag stop and close the accept() socket so the
// main loop unblocks and exits instead of waiting for the next connection.
static void handle_signal(int sig) {
    (void)sig;
    g_keep_running = 0;
    if (g_server_fd >= 0) {
        close(g_server_fd);
        g_server_fd = -1;
    }
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        signal(SIGINT,  handle_signal);
        signal(SIGTERM, handle_signal);

        // Read PORT from the environment; default to 8080.
        // getenv() reads the process environment (set by run.sh via export PORT).
        const char *port_env = getenv("PORT");
        int port = port_env ? atoi(port_env) : 8080;
        if (port <= 0 || port > 65535) port = 8080;

        // --- create a TCP socket ---
        // AF_INET: IPv4. SOCK_STREAM: TCP (reliable, ordered bytes).
        // The third argument (0) selects the default protocol for SOCK_STREAM, TCP.
        g_server_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (g_server_fd < 0) {
            NSLog(@"socket() failed: %s", strerror(errno));
            return 1;
        }

        // SO_REUSEADDR: allow re-binding the same port immediately after the
        // server restarts, without waiting for TIME_WAIT to expire.
        // Reference: https://pubs.opengroup.org/onlinepubs/9799919799/functions/setsockopt.html
        int yes = 1;
        setsockopt(g_server_fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));

        // Bind to 127.0.0.1 (loopback only — no external access for a demo).
        struct sockaddr_in addr;
        memset(&addr, 0, sizeof(addr));
        addr.sin_family      = AF_INET;
        addr.sin_port        = htons((uint16_t)port);
        addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

        if (bind(g_server_fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
            NSLog(@"bind() failed: %s", strerror(errno));
            return 1;
        }

        // listen(): mark the socket as passive; queue up to 10 pending connections.
        if (listen(g_server_fd, 10) < 0) {
            NSLog(@"listen() failed: %s", strerror(errno));
            return 1;
        }

        // Build the fixed HTTP/1.1 response once — same for every request.
        // NSString handles UTF-8 encoding and length calculation via Foundation.
        NSString *body = @"<html><body><p>Hello, World!</p></body></html>";
        NSString *response = [NSString stringWithFormat:
            @"HTTP/1.1 200 OK\r\n"
             "Content-Type: text/html; charset=utf-8\r\n"
             "Content-Length: %lu\r\n"
             "Connection: close\r\n"
             "\r\n"
             "%@",
            (unsigned long)[body lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
            body];
        const char *resp_bytes = [response UTF8String];
        NSUInteger   resp_len  = [response lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

        NSLog(@"Listening on http://localhost:%d/", port);

        // --- accept loop ---
        while (g_keep_running) {
            // accept() blocks until a client connects, or returns -1 when the
            // socket is closed by the signal handler.
            int client_fd = accept(g_server_fd, NULL, NULL);
            if (client_fd < 0) {
                if (!g_keep_running) break;
                NSLog(@"accept() failed: %s", strerror(errno));
                break;
            }

            // Drain the request headers so the client does not receive a TCP RST.
            // A minimal HTTP/1.1 request ends with a blank line (\r\n\r\n).
            char buf[4096];
            ssize_t total = 0;
            buf[0] = '\0';
            while (total < (ssize_t)(sizeof(buf) - 1)) {
                ssize_t n = recv(client_fd, buf + total,
                                 sizeof(buf) - 1 - (size_t)total, 0);
                if (n <= 0) break;
                total += n;
                buf[total] = '\0';
                if (strstr(buf, "\r\n\r\n")) break;
            }

            // Write the response (best-effort; ignore partial-write errors for a demo).
            write(client_fd, resp_bytes, resp_len);
            close(client_fd);
        }

        if (g_server_fd >= 0) close(g_server_fd);
    }
    return 0;
}
