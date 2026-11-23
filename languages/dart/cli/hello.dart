// hello.dart - Dart cli: the simplest complete Dart program
//
// WHAT: prints "Hello, World!" to standard output.
// WHY:  Dart is a general-purpose language from Google. It compiles to
//       native machine code (AOT) or to JavaScript (for the web). The cli
//       version needs only the Dart SDK, no framework or build step.
// HOW:  dart hello.dart
//
// Entry point: the `main` function is the required entry point of every
// Dart program (dart.dev/language/functions#the-main-function).
// Comments: Dart uses C-style comments: // for single lines, /* */ for blocks.
// Reference: dart.dev/language/comments

void main() {
  // print() writes to standard output and appends a newline.
  // It is a top-level function in dart:core, imported automatically.
  // Unlike C printf, it handles the conversion safely and adds the newline.
  print('Hello, World!');
}
