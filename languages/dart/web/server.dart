// server.dart - Dart web: an HTTP server using dart:io
//
// WHAT: starts an HTTP server on localhost that answers every request
//       for "/" with a simple HTML page containing "Hello, World!".
// WHY:  dart:io is part of the Dart standard library. It provides
//       HttpServer, a low-level HTTP server, without any third-party
//       dependency. This is the Dart equivalent of Node.js's http module.
// HOW:  dart server.dart
//       Open http://localhost:8080/ in your browser.
//
// Reference: https://api.dart.dev/dart-io/HttpServer-class.html

import 'dart:io';

// The port is read from the environment variable PORT, defaulting to 8080.
// On macOS 12+, port 5000 is often taken by AirPlay Receiver.
final port = int.parse(Platform.environment['PORT'] ?? '8080');

void main() async {
  // bind() listens on localhost only (not on all interfaces).
  // It returns a Future<HttpServer>, so main() is async.
  // Reference: https://api.dart.dev/dart-io/HttpServer-class.html
  final server = await HttpServer.bind('localhost', port);

  // Process each request as it arrives.
  await for (final request in server) {
    // Every request gets the same response.
    // write() sends the body; close() finishes the response.
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write('<html><body><p>Hello, World!</p></body></html>')
      ..close();
  }
}
