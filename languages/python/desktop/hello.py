# hello.py - Python desktop: open a window that shows "Hello, World!".
#
# Run it with:  python3 hello.py   (or ./run.sh, which explains each step)
#
# The window is drawn by Tk, a GUI toolkit implemented in C as a package of
# the Tcl language. tkinter is the Python module that talks to Tk. The
# python.org installers include it, so, unlike Flask in ../web, there is
# nothing to download from PyPI (Homebrew and Linux ship it separately).

# os gives access to environment variables (used only for the self-check).
import os

# "import tkinter as tk" loads the module under the short name "tk".
# ttk is the "themed" widget set: its widgets look like the native ones on
# macOS, Windows and Linux, unlike the classic tk widgets.
import tkinter as tk
from tkinter import ttk

# Tk() starts Tk (with its own Tcl interpreter) and creates the root
# window, the main window of the application.
root = tk.Tk()
root.title("Hello, World!")  # the text in the window's title bar

# A Label is a widget that shows text. padding adds empty space around the
# text (in pixels) so the window is not tiny.
label = ttk.Label(root, text="Hello, World!", padding=40)
# pack() places the label inside the window. Until a widget is placed by a
# "geometry manager" (pack, grid, or place), it is not shown.
label.pack()

# Self-check used by ./run.sh --verify (and scripts/verify-all.sh): with
# TF_VERIFY=1, draw the window now, check that it is shown, print the
# label's text to the terminal, and close the window after 2 seconds. A
# reader running ./run.sh never sees this; the window stays open until
# closed. (wait_visibility() is not used: with Tk 9 on macOS it never
# returned, because no "visibility" event arrived.)
if os.environ.get("TF_VERIFY") == "1":
    root.update()                     # handle pending events: draw the window
    if not root.winfo_viewable():     # true once the window is mapped (shown)
        raise SystemExit("The window was not shown.")
    print(label.cget("text"), flush=True)
    root.after(2000, root.destroy)    # 2000 ms later, close the window

# mainloop() hands control to Tk: it draws the window and waits for events
# (clicks, key presses, the close button). It returns when the window is
# closed. The cli version had no loop: it printed once and ended. The web
# version has one too: the server waits for requests the same way.
root.mainloop()
