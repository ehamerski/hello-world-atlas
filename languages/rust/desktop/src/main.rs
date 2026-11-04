// main.rs - Rust desktop: open a window that shows "Hello, World!".
//
// Build and run it with ../build.sh and ../run.sh, which explain each step.
// The window is drawn by egui, an "immediate mode" GUI library, through its
// framework eframe. Rust's standard library has no GUI (unlike Python's
// tkinter), so eframe is a dependency: Cargo.toml names it.
//
// Immediate mode means there are no widget objects to create and keep, as
// in Fyne (../../go/desktop) or JavaFX (../../java/desktop). Instead, the
// closure below runs again every time the window is repainted and
// describes the whole window from scratch: "a label with this text".

use std::time::{Duration, Instant};

// eframe re-exports egui, so one dependency gives both.
use eframe::egui;

// main returns eframe::Result: Ok(()) if the window was closed normally,
// or an error (for example, no graphics driver). Returning a Result from
// main makes Rust print the error and exit with a non-zero code.
fn main() -> eframe::Result {
    // Options for the native window: its size, in egui's logical points
    // (not physical pixels, so it looks the same on a Retina screen).
    let options = eframe::NativeOptions {
        viewport: egui::ViewportBuilder::default().with_inner_size([320.0, 160.0]),
        // "..Default::default()" fills every other field with its default:
        // Rust has no optional arguments, so this is the usual way.
        ..Default::default()
    };

    // Self-check used by ../run.sh --verify (and scripts/verify-all.sh):
    // with TF_VERIFY=1 the app prints the label's text on its first frame
    // and closes itself after 2 seconds. A student running ./run.sh never
    // sees this. "let mut" declares a variable that may change; without
    // "mut", Rust variables are read-only.
    let verify = std::env::var("TF_VERIFY").as_deref() == Ok("1");
    let started = Instant::now();
    let mut printed = false;

    // Open the window and run eframe's event loop until it is closed.
    // The first argument is the app's name, which eframe also uses as the
    // window title. The third is a closure (an anonymous function, like a
    // lambda in Java or Python) that eframe calls on every repaint. "move"
    // gives the closure ownership of verify, started, and printed, because
    // the closure outlives main's local variables and cannot borrow them.
    eframe::run_ui_native("Hello, World!", options, move |ui, _frame| {
        // CentralPanel fills the window and gives it a background color.
        egui::CentralPanel::default().show(ui, |ui| {
            // Center the label horizontally and vertically.
            ui.centered_and_justified(|ui| {
                ui.label("Hello, World!");
            });
        });

        if verify {
            if !printed {
                println!("Hello, World!");
                printed = true;
            }
            if started.elapsed() >= Duration::from_secs(2) {
                // Ask eframe to close the window, which ends the event loop.
                ui.ctx().send_viewport_cmd(egui::ViewportCommand::Close);
            }
            // egui only repaints when something happens (a click, a key).
            // Ask for another repaint soon, so the 2-second check runs.
            ui.ctx().request_repaint_after(Duration::from_millis(100));
        }
    })
}
