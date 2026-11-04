// main.js - Node.js desktop: an Electron window that shows "Hello, World!".
//
// Run it with:  ./run.sh   (or "npm start", which runs "electron .")
//
// An Electron app has two kinds of process. This file is the MAIN process:
// it runs in Node.js (so require() works here, as in ../web) and creates
// the windows. Each window then runs a RENDERER process, a Chromium page
// that shows index.html. Python's tkinter and Go's Fyne draw native
// widgets instead; Electron draws a web page inside a native window.

// Load two modules from Electron. "electron/main" holds the APIs for the
// main process; { app, BrowserWindow } takes two of its properties into
// two variables (this is called "destructuring").
//   app           - controls the application's life (start, quit)
//   BrowserWindow - creates and controls a window
const { app, BrowserWindow } = require("electron/main");

// A function that creates the window. In JavaScript a function can be
// stored in a variable (here with the arrow syntax "() => { ... }").
const createWindow = () => {
  const win = new BrowserWindow({ width: 320, height: 160 });
  // Show index.html (a file in this folder) inside the window.
  win.loadFile("index.html");

  // Self-check used by ./run.sh --verify (and scripts/verify-all.sh): with
  // TF_VERIFY=1, wait until the page has loaded, check that the window is
  // shown, print the page's text to the terminal, and quit 2 seconds later.
  // A student running ./run.sh never sees this; the window stays open.
  if (process.env.TF_VERIFY === "1") {
    // "did-finish-load" is an event: Electron calls this function when the
    // page has finished loading. Nothing waits here; the code goes on.
    win.webContents.once("did-finish-load", async () => {
      if (!win.isVisible()) {
        console.error("The window was not shown.");
        app.exit(1);
        return;
      }
      // Run a line of JavaScript inside the page (the renderer process)
      // and get its result back. "await" waits for the answer without
      // blocking the app; it is only allowed in an "async" function.
      const text = await win.webContents.executeJavaScript(
        'document.getElementById("greeting").textContent'
      );
      console.log(text);
      setTimeout(() => app.quit(), 2000); // 2000 ms later, quit
    });
  }
};

// app.whenReady() returns a Promise: a value that arrives later. .then()
// runs createWindow once Electron has finished starting; windows cannot be
// created before that.
app.whenReady().then(() => {
  createWindow();

  // macOS only: clicking the Dock icon of a running app that has no
  // windows should open a new one (the usual macOS behaviour).
  app.on("activate", () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

// When the last window is closed, quit, except on macOS ("darwin"), where
// apps normally keep running until you press Cmd+Q.
app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

// There is no loop to write: like tkinter's mainloop() and Fyne's
// ShowAndRun(), Electron runs its own event loop and calls the functions
// above when events (ready, activate, window-all-closed) happen.
