// main.go - Go desktop: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The window is drawn by Fyne, a GUI toolkit written in Go. Go's standard
// library has no GUI package (unlike Python's tkinter), so Fyne is a
// dependency: go.mod names it and "go build" downloads it.

package main

// Imports are grouped in parentheses. Standard library packages have short
// paths ("os", "time"); packages from other modules start with the module
// path ("fyne.io/fyne/v2/..."), which is also where Go downloads them from.
import (
	"fmt"
	"os"
	"time"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
)

func main() {
	// app.New() creates the application. ":=" declares a variable and
	// infers its type, so there is no type name to write (Java needs one
	// unless it uses "var"; Python needs no declaration at all).
	a := app.New()

	// A window with "Hello, World!" in its title bar.
	w := a.NewWindow("Hello, World!")

	// A Label is a widget that shows text. NewCenter keeps it in the
	// middle of the window, the way JavaFX's StackPane does in ../../java.
	label := widget.NewLabel("Hello, World!")
	w.SetContent(container.NewCenter(label))

	// Without a size the window would be exactly as big as the label.
	// Fyne measures sizes in its own device-independent units, not pixels.
	w.Resize(fyne.NewSize(320, 160))

	// Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
	// with TF_VERIFY=1, print the label's text once the app is running and
	// close the app after 2 seconds. A student running ./run.sh never
	// sees this.
	if os.Getenv("TF_VERIFY") == "1" {
		// SetOnStarted registers a function that Fyne calls when the app
		// is running. "func() { ... }" is an anonymous function (a closure),
		// like a lambda in Java or Python.
		a.Lifecycle().SetOnStarted(func() {
			fmt.Println(label.Text)
		})
		// "go" starts the function in a goroutine: a lightweight thread
		// managed by the Go runtime. It sleeps without blocking the window.
		// Fyne's user interface must only be changed from Fyne's own
		// goroutine, so fyne.Do hands the call to a.Quit back to it.
		go func() {
			time.Sleep(2 * time.Second)
			fyne.Do(a.Quit)
		}()
	}

	// Show the window and run Fyne's event loop. ShowAndRun only returns
	// when the last window is closed (or a.Quit is called). tkinter's
	// mainloop() and JavaFX's launch() behave the same way.
	w.ShowAndRun()
}
