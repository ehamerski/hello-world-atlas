/*
 * hello.c - C desktop: open a window that shows "Hello, World!".
 *
 * Build and run it with ./build.sh and ./run.sh, which explain each step.
 * The window is drawn by GTK 4, the toolkit of the GNOME desktop, which
 * is itself written in C. Standard C has no windows at all, so GTK is a
 * library that has to be installed (./install.sh). GTK's headers need
 * C99, so this folder is compiled as C99, not C89 like ../cli. The code
 * below still keeps to the C89 style: comments in slash-star form and
 * every declaration at the top of its block.
 */

#include <stdio.h>  /* printf, fflush */
#include <stdlib.h> /* getenv */
#include <string.h> /* strcmp */

/* One header brings in all of GTK (and GLib, the utility library under
 * it). Its names start with gtk_ / Gtk and g_ / G: C has no namespaces,
 * so prefixes keep the names apart. */
#include <gtk/gtk.h>

/*
 * Called by the timer of the self-check (see activate). Returning
 * G_SOURCE_REMOVE tells GLib not to call it again.
 * "gpointer" is GLib's name for "void *": a pointer to anything. C has no
 * generics or closures, so callbacks receive their data as a void pointer
 * that the callback casts back to the real type.
 */
static gboolean quit_app(gpointer data)
{
    g_application_quit(G_APPLICATION(data));
    return G_SOURCE_REMOVE;
}

/*
 * GTK calls this function when the application starts ("activate"
 * signal, connected in main). It builds the window. In GTK's C API,
 * classes are emulated with structs and functions: gtk_window_set_title
 * is the "set_title method" of GtkWindow, and the object comes first.
 */
static void activate(GtkApplication *app, gpointer user_data)
{
    GtkWidget *window;
    GtkWidget *label;
    const char *verify;

    (void) user_data; /* unused: tell -Wextra it is on purpose */

    /* A top-level window that belongs to the application. */
    window = gtk_application_window_new(app);

    /*
     * GTK_WINDOW(window) is a checked cast: every widget is a GtkWidget,
     * and the macro converts it to the more specific GtkWindow (it warns
     * at run time if the object is not a window). This is GTK's form of
     * inheritance, done in plain C; Java or C++ do the same with classes.
     */
    gtk_window_set_title(GTK_WINDOW(window), "Hello, World!");
    gtk_window_set_default_size(GTK_WINDOW(window), 320, 160);

    /* A label shows text. A window has one child; GTK centers a label in
     * the space it gets, so no layout container is needed. */
    label = gtk_label_new("Hello, World!");
    gtk_window_set_child(GTK_WINDOW(window), label);

    /* Show the window. */
    gtk_window_present(GTK_WINDOW(window));

    /*
     * Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
     * with TF_VERIFY=1, print the label's text and close the app after 2
     * seconds. A student running ./run.sh never sees this.
     */
    verify = getenv("TF_VERIFY");
    if (verify != NULL && strcmp(verify, "1") == 0) {
        printf("%s\n", gtk_label_get_text(GTK_LABEL(label)));
        fflush(stdout); /* print now, not when the program ends */
        g_timeout_add_seconds(2, quit_app, app);
    }
}

/*
 * main receives the command-line arguments: argc counts them and argv is
 * an array of strings (char * is "pointer to char", how C passes text).
 * They are handed to GTK, which understands some options of its own.
 */
int main(int argc, char **argv)
{
    GtkApplication *app;
    int status;

    /*
     * The application ID names the app in reverse-DNS form. example.com is
     * reserved for examples, so this ID belongs to nobody.
     */
    app = gtk_application_new("com.example.HelloDesktop",
                              G_APPLICATION_DEFAULT_FLAGS);

    /*
     * Connect the "activate" signal to the function above. G_CALLBACK
     * casts it to GLib's generic function-pointer type; NULL is the
     * user_data passed to activate.
     */
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);

    /*
     * Run the event loop. g_application_run only returns when the last
     * window is closed (or the app quits); its result is the exit status.
     * tkinter's mainloop() and Fyne's ShowAndRun() work the same way.
     */
    status = g_application_run(G_APPLICATION(app), argc, argv);

    /* GTK objects are reference counted: drop ours so the app is freed.
     * C has no garbage collector. */
    g_object_unref(app);
    return status;
}
