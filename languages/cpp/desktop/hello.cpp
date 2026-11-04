// hello.cpp - C++ desktop: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The window is drawn by Qt 6 Widgets, a toolkit written in C++. Standard
// C++, like standard C, has no windows, so Qt is a library that has to be
// installed (./install.sh). Compare ../../c/desktop/hello.c: GTK does the
// same job in C, emulating classes with structs, casts and gpointer
// callbacks. Here the language has real classes, so the code is shorter.

#include <cstdlib>  // std::getenv (C's <stdlib.h>, inside namespace std)
#include <cstring>  // std::strcmp
#include <iostream> // std::cout

// One header per Qt class. Qt's class names start with Q (QApplication,
// QLabel) instead of living in a namespace, a prefix like GTK's Gtk.
// Unlike in C, though, a QLabel is a real class.
#include <QApplication>
#include <QLabel>
#include <QTimer>

int main(int argc, char *argv[])
{
    // The application object: one per GUI program. It must be created
    // before any widget, and it reads Qt's own command-line options, so
    // argc and argv are passed in. This is an object on the stack, not a
    // pointer: no "new" and no unref. It is destroyed automatically when
    // main returns (C++ calls its destructor, "RAII"). In C, GTK needs
    // g_object_unref(app) by hand.
    QApplication app(argc, argv);

    // A label with no parent widget is a top-level window of its own, so
    // no separate window object is needed. Its member functions are
    // called with a dot: label.setWindowTitle(...), where GTK's C API
    // writes gtk_window_set_title(GTK_WINDOW(window), ...).
    QLabel label("Hello, World!");
    label.setWindowTitle("Hello, World!");
    label.setAlignment(Qt::AlignCenter); // Qt:: is a namespace
    label.resize(320, 160);
    label.show();

    // Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
    // with TF_VERIFY=1, print the label's text and quit after 2 seconds.
    // A student running ./run.sh never sees this.
    const char *verify = std::getenv("TF_VERIFY");
    if (verify != nullptr && std::strcmp(verify, "1") == 0) {
        // text() returns a QString (Unicode text); toStdString() converts
        // it to a std::string, which std::cout can print. std::endl adds
        // "\n" and flushes, so the line appears now (C: fflush(stdout)).
        std::cout << label.text().toStdString() << std::endl;

        // The second argument is a lambda: an unnamed function written
        // in place. [&app] "captures" app by reference, so the lambda can
        // use it later. C has no lambdas: c/desktop needs a separate
        // function plus a void pointer to pass the app along.
        QTimer::singleShot(2000, [&app] { app.quit(); });
    }

    // Run the event loop until the window is closed (or quit() is
    // called); its result is the exit status, as in GTK's
    // g_application_run.
    return app.exec();
}
