// main.dart - the whole app: one screen that shows "Hello, World!".
//
// Flutter apps are written in Dart. This one file builds for Android; the
// same code also builds for iOS (see ../README.md). Unlike a native Android
// app written with Views, the widgets on this screen are drawn by Flutter's
// own rendering engine, not by Android View classes. See "Flutter's rendering
// model" in the Flutter architectural overview:
// https://docs.flutter.dev/resources/architectural-overview

// Import the Material library: Google's Material Design widgets (buttons,
// pages, text). In Dart, an import names a package ('package:flutter/...'),
// not a folder path as in Java's `import java.util.*`.
import 'package:flutter/material.dart';

// main() is the entry point. Dart calls it when the app starts. It needs no
// `int` return type and no argument list, unlike C's `int main(int argc, ...)`.
void main() {
  // print() writes a line to the log. On Android the line goes to logcat with
  // the tag "flutter". run.sh --verify reads that line to check the app ran.
  print('Hello, World!');

  // runApp() makes HelloApp the root of the widget tree and draws it.
  runApp(const HelloApp());
}

// A widget is an object that describes part of the screen. StatelessWidget
// means this widget holds no changing state: its output depends only on its
// inputs, so it never needs to be rebuilt by itself.
class HelloApp extends StatelessWidget {
  // `const` creates the object once at compile time. `super.key` passes an
  // optional identifier to the parent class; Flutter uses keys to match
  // widgets when the tree is rebuilt.
  const HelloApp({super.key});

  // build() describes what this widget shows. Flutter calls it whenever the
  // screen must be redrawn, so it should be quick and have no side effects.
  @override
  Widget build(BuildContext context) {
    // MaterialApp sets up the theme, the navigation and the default text style.
    return const MaterialApp(
      // Scaffold is the basic page layout: an app bar, a body, a drawer, etc.
      // This page has only a body.
      home: Scaffold(
        // Center places its child in the middle of the page.
        body: Center(
          // Text shows a string. Its font and color come from the theme.
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
