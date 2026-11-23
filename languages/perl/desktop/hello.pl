# hello.pl - Perl desktop: open a window that shows "Hello, World!".
#
# Run it with:  ./run.sh   (it tells Perl where install.sh put Tkx)
#
# The window is drawn by Tk, a GUI toolkit implemented in C as a package of
# the Tcl language. Tkx is the Perl module that talks to Tcl/Tk, through
# Tcl.pm. This is the same Tcl/Tk that Python's tkinter and Ruby's Tk use
# (see the other desktop folders). Perl/Tk, the older Perl binding, is not
# used because on macOS it needs an X11 server (see README.md).

use strict;
use warnings;

# "use Tkx" loads the module from the local folder that install.sh filled
# (run.sh puts it on Perl's search path, PERL5LIB). Python's equivalent is
# "import tkinter". Perl loads a module once, at this line.
use Tkx;

# "my" declares a variable that exists only in this file (strict requires
# it). Tkx::widget->new(".") wraps Tk's root window, which Tk calls ".":
# the main window of the application.
my $mw = Tkx::widget->new(".");
# Tk commands become Perl method calls: Tk's "wm title window text" is
# $window->g_wm_title("text"). A "g_" method calls the Tcl command that
# follows the prefix with the window as its first argument.
$mw->g_wm_title("Hello, World!");     # the text in the window's title bar

# Tk's "ttk::label" becomes new_ttk__label (the "::" is written "__").
# ttk is the "themed" widget set: its widgets look like the native ones on
# macOS, Windows and Linux. -text and -padding are Tk options, written with
# a leading "-". The padding "60 40" adds empty space (in pixels) left and
# right (60) and above and below (40) the text. "=>" is Perl's "fat comma":
# it pairs an option name with its value.
my $label = $mw->new_ttk__label(-text => "Hello, World!", -padding => "60 40");
# pack is a "geometry manager". Until a widget is placed by one (pack,
# grid, or place), it is not shown.
$label->g_pack;

# Self-check used by ./run.sh --verify (and scripts/verify-all.sh): with
# TF_VERIFY=1, draw the window now, check that it is shown, print the
# label's text to the terminal, and close the window after 2 seconds. A
# reader running ./run.sh never sees this; the window stays open until
# closed. (Waiting for a "visibility" event does not work with Tk 9 on
# macOS, so the program calls update and then asks if the window is mapped.)
if (($ENV{TF_VERIFY} // '') eq '1') {
    $| = 1;                          # flush the output at once
    Tkx::update();                   # handle pending events: draw the window
    die "The window was not shown.\n" unless $mw->g_winfo_viewable;
    print $label->cget("-text"), "\n";
    Tkx::after(2000, sub { $mw->g_destroy });   # 2000 ms later, close it
}

# MainLoop hands control to Tk: it draws the window and waits for events
# (clicks, key presses, the close button). It returns when the last window
# is closed. The cli version had no loop: it printed once and ended. The web
# version has one too: the server waits for requests the same way.
Tkx::MainLoop();
