// HelloApp.java - Java desktop: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The window is drawn by JavaFX, a GUI toolkit for Java (the older one,
// Swing, is still part of the JDK). Unlike Python's tkinter, JavaFX is not
// part of the standard installation: Maven downloads it (see pom.xml).

package com.example.hello;

// "import" lets us write Label instead of javafx.scene.control.Label.
// Python's "from tkinter import ttk" plays the same role.
import javafx.animation.PauseTransition;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import javafx.util.Duration;

// A JavaFX program is a class that "extends Application": it inherits the
// application life cycle from JavaFX and fills in the start() method.
// This is object-oriented inheritance; the cli version needed none of it.
public class HelloApp extends Application {

    // JavaFX calls start() once it is ready, on the "JavaFX Application
    // Thread". A Stage is a window; the first one is created for us.
    @Override  // tells the compiler we are replacing Application.start()
    public void start(Stage stage) {
        // A Label is a control that shows text.
        Label label = new Label("Hello, World!");

        // A StackPane is a layout that centres its children. The padding
        // (40 pixels on every side) keeps the window from being tiny.
        StackPane root = new StackPane(label);
        root.setPadding(new Insets(40));

        // A Scene holds everything drawn inside the window. The window
        // sizes itself to fit the scene.
        stage.setScene(new Scene(root));
        stage.setTitle("Hello, World!");  // the text in the title bar
        stage.show();                     // put the window on the screen

        // Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
        // with TF_VERIFY=1, check that the window is shown, print the
        // label's text to the terminal, and close the app after 2 seconds.
        // A student running ./run.sh never sees this.
        if ("1".equals(System.getenv("TF_VERIFY"))) {
            if (!stage.isShowing()) {
                throw new IllegalStateException("The window was not shown.");
            }
            System.out.println(label.getText());
            // A PauseTransition waits without blocking the window, then
            // runs its "on finished" handler. Platform.exit() ends the app.
            PauseTransition pause = new PauseTransition(Duration.seconds(2));
            pause.setOnFinished(event -> Platform.exit());  // a lambda (Java 8+)
            pause.play();
        }
        // start() returns, but the program keeps running: JavaFX now waits
        // for events (clicks, the close button) until the last window is
        // closed. tkinter's mainloop() and a web server's loop work alike.
    }

    // The entry point, as in ../cli. launch() starts the JavaFX runtime,
    // creates a HelloApp object and calls its start() method.
    public static void main(String[] args) {
        launch(args);
    }
}
