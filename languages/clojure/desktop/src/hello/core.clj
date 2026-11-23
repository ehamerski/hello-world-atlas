;; core.clj - Clojure desktop: open a window that shows "Hello, World!".
;;
;; Run it with ./run.sh, which explains each step. The window is drawn by
;; Swing, the GUI toolkit that is part of the JDK. Clojure has no GUI toolkit
;; of its own: it calls Swing through Java interop. Compare
;; ../../java/desktop-swing/, the same program in Java.

;; The :import clause of ns is Clojure's version of Java's import: it lets
;; us write JFrame instead of javax.swing.JFrame. The vector (square
;; brackets) names the package first and then the classes to import from it.
;; Swing class names start with "J" (JFrame, JLabel) to tell them apart
;; from the older AWT classes that Swing builds on.
(ns hello.core
  (:import (java.awt.event ActionListener WindowEvent)
           (javax.swing BorderFactory JFrame JLabel SwingConstants
                        SwingUtilities Timer)))

;; defn- defines a private function: other namespaces cannot call it.
;; Everything here runs on the event dispatch thread (EDT), because -main
;; hands it to SwingUtilities/invokeLater, so it may touch Swing components.
(defn- create-and-show-window []
  ;; let binds names to values for the code inside it, like local variables,
  ;; but they never change afterwards. (JFrame. "...") is the interop form
  ;; of "new JFrame(...)": a class name followed by a dot calls its
  ;; constructor. In Java the call is written new JFrame("Hello, World!").
  (let [frame (JFrame. "Hello, World!")   ; the text in the title bar
        ;; SwingConstants/CENTER is a static field: Class/NAME, where Java
        ;; writes SwingConstants.CENTER.
        label (JLabel. "Hello, World!" SwingConstants/CENTER)]
    ;; By default, closing a JFrame only hides it and the program keeps
    ;; running. EXIT_ON_CLOSE ends the program when the window is closed.
    ;; (.method object args) calls an instance method: Java's
    ;; frame.setDefaultCloseOperation(...) becomes
    ;; (.setDefaultCloseOperation frame ...), with the object after the name.
    (.setDefaultCloseOperation frame JFrame/EXIT_ON_CLOSE)

    ;; An empty border (40 pixels on every side) keeps the window from being
    ;; tiny.
    (.setBorder label (BorderFactory/createEmptyBorder 40 40 40 40))
    (.add frame label)

    (.pack frame)                      ; size the window to fit the label
    (.setLocationRelativeTo frame nil) ; nil = centre it on the screen
    (.setVisible frame true)           ; put the window on the screen

    ;; Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
    ;; with TF_VERIFY=1, check that the window is shown, print the label's
    ;; text, and close the window after 2 seconds. A student running
    ;; ./run.sh never sees this. System/getenv is Java's System.getenv.
    (when (= "1" (System/getenv "TF_VERIFY"))
      (when-not (.isShowing frame)
        (throw (IllegalStateException. "The window was not shown.")))
      (println (.getText label))
      ;; javax.swing.Timer waits without blocking the window and then runs
      ;; its action ON THE EDT. The action sends the same "window closing"
      ;; event as a click on the close button, so EXIT_ON_CLOSE ends the
      ;; program.
      ;; Timer wants an ActionListener, a Java interface with one method,
      ;; actionPerformed. reify builds an object that implements an
      ;; interface on the spot, so it plays the part of Java's lambda or
      ;; anonymous class. A method of reify lists the object itself (like
      ;; "this") first, then its arguments; the underscore names a parameter
      ;; that the code does not use.
      (doto (Timer. 2000 (reify ActionListener
                           (actionPerformed [_ _event]
                             (.dispatchEvent frame (WindowEvent. frame WindowEvent/WINDOW_CLOSING)))))
        (.setRepeats false)   ; fire once, not every 2 seconds
        (.start)))))

;; -main is the entry point, found by "clojure -M -m hello.core".
(defn -main [& args]
  ;; Do NOT build the window here. Oracle's Swing tutorial explains why:
  ;; almost all code that creates or interacts with Swing components must
  ;; run on the event dispatch thread (EDT), because most Swing methods are
  ;; not thread safe.
  ;; Source: https://docs.oracle.com/javase/tutorial/uiswing/concurrency/initial.html
  ;;
  ;; SwingUtilities/invokeLater hands a task to the EDT and returns at once.
  ;; It expects a java.lang.Runnable. Every Clojure function implements
  ;; Runnable (the interface clojure.lang.IFn extends it), so the function
  ;; create-and-show-window is passed as it is. Java needs a lambda or a
  ;; method reference for this.
  (SwingUtilities/invokeLater create-and-show-window)
  ;; -main ends here, but the program keeps running: the EDT now waits for
  ;; events (clicks, the close button) until the window closes.
  nil)
