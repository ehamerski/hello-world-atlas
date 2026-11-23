#!/bin/sh
# install.sh - C desktop: check (and optionally install) cc, pkg-config and
#              GTK 4
#
# WHAT: 1. checks for a C compiler ("cc");
#       2. checks for pkg-config, which tells the compiler where GTK is;
#       3. checks that GTK 4 is installed ("pkg-config --exists gtk4").
#       If something is missing, shows the install command for your
#       operating system and runs it only if you answer "y". Nothing is
#       installed silently and sudo is never hidden.
# WHY:  standard C has no windows or graphics, so the window comes from a
#       library, GTK 4. C has no package manager of its own: libraries come
#       from the operating system's package manager.
#       macOS Intel is a special case. Homebrew has no ready-made (bottled)
#       GTK 4 for Intel Macs, and building its formula needs the full Xcode
#       app (for dart-sass, a tool GTK only needs when built from git). So on
#       Intel this script offers to build GTK from GNOME's official source
#       release instead, which does not need sass: Homebrew installs GTK's
#       dependencies and the build tools (meson, ninja), and GTK is built into
#       ~/.local/gtk-4.24.1 (see gtk4-env.sh). On the dev machine the GTK
#       build itself took about 3.5 minutes (2026-10-31), plus Homebrew's time.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); Linux and Windows
# (Git Bash) verified in CI; macOS Apple Silicon and WSL are documented but
# NOT verified.
# Sources for the install commands:
#   https://formulae.brew.sh/formula/gtk4
#   https://www.gtk.org/docs/installations/linux
#   https://www.gtk.org/docs/installations/windows
#   https://docs.gtk.org/gtk4/building.html   (building GTK from source)

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, TF_OS, has_cmd, install_pkg,
# confirm, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# On Windows: MSYS2's UCRT64 tools first on PATH, and msys2_ensure.
# shellcheck source=../msys2-env.sh
. ../msys2-env.sh
# GTK4_VERSION, GTK4_SHA256, GTK4_PREFIX, PKG_CONFIG_PATH.
# shellcheck source=gtk4-env.sh
. ./gtk4-env.sh

# build_gtk4_from_source - macOS Intel only: build GTK from GNOME's
# release tarball into $GTK4_PREFIX with meson and ninja.
build_gtk4_from_source() {
    has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
    # GTK's dependencies (the same list as Homebrew's gtk4 formula) plus
    # the build tools. Most of them have Intel bottles.
    install_pkg "GTK's dependencies and build tools (meson, ninja)" \
        brew install meson ninja gettext cairo fontconfig fribidi gdk-pixbuf \
        glib graphene harfbuzz hicolor-icon-theme jpeg-turbo libepoxy libpng \
        librsvg libtiff pango || exit 1

    gtk_src=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-c
    gtk_tar=gtk-$GTK4_VERSION.tar.xz
    gtk_url=https://download.gnome.org/sources/gtk/${GTK4_VERSION%.*}/$gtk_tar
    explain "Download $gtk_url into $gtk_src,"
    explain "check its SHA-256 checksum, then build and install into $GTK4_PREFIX."
    confirm "Build GTK $GTK4_VERSION from source now (several minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    mkdir -p "$gtk_src"
    [ -f "$gtk_src/$gtk_tar" ] || curl -fL -o "$gtk_src/$gtk_tar" "$gtk_url"
    # The checksum proves the file is exactly GNOME's release.
    echo "$GTK4_SHA256  $gtk_src/$gtk_tar" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $gtk_src/$gtk_tar and retry."
    rm -rf "$gtk_src/gtk-$GTK4_VERSION" "$gtk_src/build-$GTK4_VERSION"
    tar -xJf "$gtk_src/$gtk_tar" -C "$gtk_src"

    # Only the library is built: no demos, tests, docs or introspection
    # data, and no optional backends that would need more dependencies
    # (GStreamer video, Vulkan). The options are listed in meson.options.
    meson setup "$gtk_src/build-$GTK4_VERSION" "$gtk_src/gtk-$GTK4_VERSION" \
        --prefix="$GTK4_PREFIX" --buildtype=release \
        -Dbuild-demos=false -Dbuild-examples=false -Dbuild-tests=false \
        -Dbuild-testsuite=false -Ddocumentation=false -Dman-pages=false \
        -Dintrospection=disabled -Dmedia-gstreamer=disabled -Dvulkan=disabled \
        -Dx11-backend=false -Dmacos-backend=true
    meson install -C "$gtk_src/build-$GTK4_VERSION"
}

step "1/3 Check the C compiler"
explain "WHY: 'cc' compiles hello.c (see ../cli/install.sh for the details)."
fix_developer_dir
if [ "$TF_OS" = windows ]; then
    # Not just any 'cc': it must be the gcc that built MSYS2's libraries.
    msys2_ensure "gcc" gcc
    ok "C compiler found: $(gcc --version 2>&1 | head -n 1)"
elif has_cmd cc && cc --version >/dev/null 2>&1; then
    ok "C compiler found: $(cc --version 2>&1 | head -n 1)"
else
    case "$TF_OS" in
        macos-*) install_pkg "Apple's Command Line Tools (clang)" xcode-select --install || exit 1
                 fail "Finish Apple's installer window, then run ./install.sh again." ;;
        linux)   install_pkg "gcc (build-essential)" sudo apt-get install -y build-essential || exit 1 ;;
        *)       fail "Unknown OS. Install gcc or clang with your package manager." ;;
    esac
fi

step "2/3 Check pkg-config"
explain "WHY: 'pkg-config --cflags --libs gtk4' prints the -I, -L and -l flags for GTK"
explain "     and the roughly 20 libraries under it (GLib, Pango, Cairo, ...)."
if [ "$TF_OS" = windows ]; then
    # Not the Perl script of the same name that other Windows tools bring.
    msys2_ensure "pkg-config (pkgconf)" pkgconf
    ok "pkg-config found: $(pkg-config --version)"
elif has_cmd pkg-config; then
    ok "pkg-config found: $(pkg-config --version)"
else
    case "$TF_OS" in
        macos-*) has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
                 install_pkg "pkg-config (pkgconf)" brew install pkgconf || exit 1 ;;
        linux)   install_pkg "pkg-config" sudo apt-get install -y pkg-config || exit 1 ;;
        *)       fail "Unknown OS. Install pkg-config with your package manager." ;;
    esac
fi

step "3/3 Check GTK 4"
explain "WHY: GTK 4 is the GUI library hello.c calls (gtk_application_new, gtk_label_new...)."
# On Windows the library comes from MSYS2 (package list:
# https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-gtk4).
if [ "$TF_OS" = windows ]; then
    msys2_ensure "GTK 4" gtk4
fi
if pkg-config --exists gtk4; then
    ok "GTK found: version $(pkg-config --modversion gtk4) ($(pkg-config --variable=prefix gtk4))"
else
    case "$TF_OS" in
        macos-arm)
            has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh first."
            install_pkg "GTK 4" brew install gtk4 || exit 1 ;;
        macos-intel)
            warn "Homebrew has no ready-made GTK 4 for Intel Macs (see the comment at the top)."
            build_gtk4_from_source ;;
        linux)
            # The -dev package holds the headers and the .pc file for pkg-config.
            install_pkg "GTK 4 (development files)" sudo apt-get install -y libgtk-4-dev || exit 1 ;;
        *)       fail "Unknown OS. See https://www.gtk.org/docs/installations/" ;;
    esac
    pkg-config --exists gtk4 \
        || fail "pkg-config still cannot find gtk4. Open a new terminal and retry."
    ok "GTK found: version $(pkg-config --modversion gtk4)"
fi
ok "Ready. Next: ./build.sh"
