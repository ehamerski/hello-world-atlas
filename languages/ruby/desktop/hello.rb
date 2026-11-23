# hello.rb - Ruby desktop: open a window that shows "Hello, World!".
#
# Run it with:  ./run.sh   (it sets up Bundler, then runs "bundle exec ruby hello.rb")
#
# The window is drawn by Tk, a GUI toolkit implemented in C as a package of
# the Tcl language. Ruby/Tk, the "tk" gem, is the Ruby library that talks to
# Tk. It is a gem, a library that is not part of the Ruby language itself,
# like Flask in the Python web version. install.sh installs it into the
# local vendor/ folder.

# require loads a library, as "import" does in Python or Java. "tk" loads
# the Ruby/Tk gem and defines TkRoot, TkLabel, Tk.mainloop, and the other
# classes used below.
require "tk"

# TkRoot.new creates the root window, the main window of the application.
# The block { ... } runs with the new object as "self", so "title" below
# is a method call on the window: it sets the text in the title bar. In
# Python's tkinter, the same step is root.title("...") on the object.
root = TkRoot.new { title "Hello, World!" }

# A TkLabel is a widget that shows text. padx and pady add empty space
# around the text (in pixels), so the window is not tiny. The first
# argument, root, says that the label lives inside that window.
label = TkLabel.new(root) do
  text "Hello, World!"
  padx 40
  pady 40
end

# pack places the label inside the window. Until a widget is placed by a
# "geometry manager" (pack, grid, or place), Tk does not show it. Python's
# tkinter uses the same name, because both libraries wrap the same Tk.
label.pack

# Self-check used by ./run.sh --verify (and scripts/verify-all.sh): with
# TF_VERIFY=1, draw the window now, check that it is shown, print the
# label's text to the terminal, and close the window after 2 seconds. A
# reader running ./run.sh never sees this; the window stays open until
# closed. (Calls that wait for a "visibility" event are not used: with
# Tk 9 on macOS they never return.)
if ENV["TF_VERIFY"] == "1"
  Tk.update                              # handle pending events: draw the window
  abort "The window was not shown." unless root.winfo_viewable
  puts label.cget("text")                # prints: Hello, World!
  $stdout.flush
  Tk.after(2000) { root.destroy }        # 2000 ms later, close the window
end

# Tk.mainloop hands control to Tk: it draws the window and waits for events
# (clicks, key presses, the close button). It returns when the window is
# closed. The cli version had no loop: it printed once and ended.
Tk.mainloop
