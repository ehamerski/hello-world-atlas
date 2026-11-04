# shellcheck shell=sh
# gtk4-env.sh - C desktop: where GTK 4 is, shared by install.sh, build.sh
#               and run.sh (sourced, not run: it only sets variables)
#
# WHAT: sets GTK4_VERSION, GTK4_SHA256 and GTK4_PREFIX, and adds
#       $GTK4_PREFIX/lib/pkgconfig to PKG_CONFIG_PATH.
# WHY:  on most systems GTK 4 comes from a package manager (Homebrew on
#       Apple Silicon, apt, MSYS2) and pkg-config finds it on its own. On
#       macOS Intel, Homebrew has no ready-made GTK 4 package, so
#       install.sh can build GTK from GNOME's source release into
#       GTK4_PREFIX, a folder in your home directory (no sudo needed).
#       pkg-config only looks there if PKG_CONFIG_PATH says so.
#
# GTK4_SHA256 is the checksum GNOME publishes next to the release:
#   https://download.gnome.org/sources/gtk/4.24/gtk-4.24.1.sha256sum

# shellcheck disable=SC2034  # GTK4_SHA256 is used by install.sh
GTK4_VERSION=4.24.1
GTK4_SHA256=e98abe720e16129c8c0f50761dee0a2e9ae2478055e31018f6cf977fcf6513e9
# Override with: GTK4_PREFIX=/some/dir ./install.sh (and the same for build.sh)
GTK4_PREFIX=${GTK4_PREFIX:-$HOME/.local/gtk-$GTK4_VERSION}
PKG_CONFIG_PATH=$GTK4_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}
export GTK4_PREFIX PKG_CONFIG_PATH
