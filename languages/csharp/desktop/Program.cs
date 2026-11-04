// Program.cs - C# desktop: open a window that shows "Hello, World!".
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// The window is drawn by Avalonia, a cross-platform UI toolkit for .NET
// installed from NuGet (see hello-desktop.csproj). Microsoft's own desktop
// toolkits, WPF and Windows Forms, run only on Windows.
//
// Avalonia apps usually describe their windows in XAML files (an XML
// dialect for UIs). This one builds the window in C# code instead, so the
// whole program fits in one file, like ../../java/desktop (Swing) and
// ../../cpp/desktop (Qt).

using Avalonia;
using Avalonia.Controls;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Layout;
using Avalonia.Themes.Fluent;
using Avalonia.Threading;

// Unlike ../cli, this program declares its classes itself: Avalonia needs
// an Application subclass. The entry point is still Main, now written by
// hand inside a class.
class Program
{
    // [STAThread] is an attribute: extra information attached to the method.
    // It asks for a "single-threaded apartment", which Windows UI code
    // needs. Avalonia's app template puts it on Main too, for Windows.
    [STAThread]
    static void Main(string[] args)
    {
        // Configure<App>() says which Application class to create; <App> is
        // a generic type argument, as in Java's List<String>.
        // UsePlatformDetect() picks the backend for this OS (Cocoa on macOS,
        // Win32 on Windows, X11 on Linux). The calls are chained: each one
        // returns the same builder ("fluent interface").
        // StartWithClassicDesktopLifetime runs the event loop until the last
        // window is closed.
        AppBuilder.Configure<App>()
            .UsePlatformDetect()
            .StartWithClassicDesktopLifetime(args);
    }
}

// App inherits from Avalonia's Application (": Application"), like
// "extends" in Java. Its methods are called by Avalonia at startup.
class App : Application
{
    // "override" replaces a method of the base class. C# requires the word,
    // and the base method must be marked "virtual"; Java overrides
    // silently (the @Override annotation is optional there).
    public override void Initialize()
    {
        // A theme gives every control its look. Without one, nothing is drawn.
        Styles.Add(new FluentTheme());
    }

    public override void OnFrameworkInitializationCompleted()
    {
        // "is ... desktop" checks the type and, if it matches, gives a
        // variable of that type ("pattern matching"). On a desktop OS the
        // lifetime is always the classic desktop one.
        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            // "new Window { ... }" creates the window and sets its
            // properties in one expression (an "object initializer").
            // Content is what the window shows: here a TextBlock, a
            // control that displays text.
            var window = new Window
            {
                Title = "Hello, World!",
                Width = 320,
                Height = 160,
                Content = new TextBlock
                {
                    Text = "Hello, World!",
                    HorizontalAlignment = HorizontalAlignment.Center,
                    VerticalAlignment = VerticalAlignment.Center,
                },
            };
            desktop.MainWindow = window;

            // Self-check used by ./run.sh --verify (and scripts/verify-all.sh):
            // with TF_VERIFY=1, print the text once the window is shown and
            // close it after 2 seconds. A student running ./run.sh never
            // sees this.
            if (Environment.GetEnvironmentVariable("TF_VERIFY") == "1")
            {
                // "+=" subscribes a handler to an event: Opened fires when
                // the window is on screen. (s, e) are the sender and the
                // event data, unused here.
                window.Opened += (s, e) =>
                {
                    // The TextBlock is read back from the window, so this
                    // prints what is really displayed.
                    var text = ((TextBlock)window.Content!).Text;
                    Console.WriteLine(text);
                    // RunOnce calls the lambda one time after the delay, on
                    // the UI thread, where windows may be touched.
                    DispatcherTimer.RunOnce(window.Close, TimeSpan.FromSeconds(2));
                };
            }
        }

        base.OnFrameworkInitializationCompleted();
    }
}
