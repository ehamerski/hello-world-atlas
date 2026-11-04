// HelloSwing.java - Java desktop-swing: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The window is drawn by Swing, the GUI toolkit that is part of the JDK
// itself (the java.desktop module). Nothing is downloaded: compare
// ../desktop, where Maven has to fetch JavaFX.

package com.example.hello;

// "import" lets us write JLabel instead of javax.swing.JLabel.
// Swing classes start with "J" (JFrame, JLabel) to tell them apart from the
// older AWT classes (Frame, Label) that Swing builds on.
import java.awt.event.WindowEvent;
import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;
import javax.swing.Timer;

// Unlike ../desktop (JavaFX), this class extends nothing: Swing is a plain
// library of components, and we create them ourselves.
public class HelloSwing {

    // The entry point, as in ../cli. It runs on the "initial thread".
    public static void main(String[] args) {
        // Do NOT build the window here. Oracle's Swing tutorial explains
        // why: "almost all code that creates or interacts with Swing
        // components must run on the event dispatch thread" (EDT), because
        // "most Swing object methods are not 'thread safe'". Calling them
        // from two threads "risks thread interference or memory consistency
        // errors", and such programs "may function correctly most of the
        // time" but fail in ways "difficult to reproduce".
        // Sources: https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html
        //          https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html
        //
        // SwingUtilities.invokeLater() hands a task to the EDT and returns
        // at once. HelloSwing::createAndShowWindow is a "method reference"
        // (Java 8+): it passes the method itself as the task, not its result.
        SwingUtilities.invokeLater(HelloSwing::createAndShowWindow);
        // main() ends here, but the program keeps running: the EDT now
        // waits for events (clicks, the close button) until the window
        // closes. tkinter's mainloop() and JavaFX's launch() work alike.
    }

    // Runs on the EDT, so it may touch Swing components freely.
    private static void createAndShowWindow() {
        // A JFrame is a window with a title bar and a close button.
        JFrame frame = new JFrame("Hello, World!");  // the text in the title bar
        // By default, closing a JFrame only hides it and the program keeps
        // running. EXIT_ON_CLOSE ends the program when the window is closed.
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // A JLabel shows text. CENTER centres it inside the window, and an
        // empty border (40 pixels on every side) keeps the window from being
        // tiny, like the padding in ../desktop.
        JLabel label = new JLabel("Hello, World!", SwingConstants.CENTER);
        label.setBorder(BorderFactory.createEmptyBorder(40, 40, 40, 40));
        frame.add(label);

        frame.pack();                       // size the window to fit the label
        frame.setLocationRelativeTo(null);  // null = centre it on the screen
        frame.setVisible(true);             // put the window on the screen

        // Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
        // with TF_VERIFY=1, check that the window is shown, print the
        // label's text to the terminal, and close the window after 2
        // seconds. A student running ./run.sh never sees this.
        if ("1".equals(System.getenv("TF_VERIFY"))) {
            if (!frame.isShowing()) {
                throw new IllegalStateException("The window was not shown.");
            }
            System.out.println(label.getText());
            // javax.swing.Timer waits without blocking the window and then
            // runs its action ON THE EDT, so the action may touch the frame.
            // The action sends the same "window closing" event as a click on
            // the close button, so EXIT_ON_CLOSE ends the program.
            Timer timer = new Timer(2000, event -> frame.dispatchEvent(
                    new WindowEvent(frame, WindowEvent.WINDOW_CLOSING)));  // a lambda (Java 8+)
            timer.setRepeats(false);  // fire once, not every 2 seconds
            timer.start();
        }
    }
}
