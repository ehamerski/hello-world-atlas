#!/bin/sh
# install.sh - QCL cli: check (and optionally install) the QCL interpreter 0.6.7
#
# WHAT: checks that the QCL interpreter (qcl) is in $QCL_PREFIX (see qcl-env.sh). If it is
#       missing, offers to download the author's source archive, check its SHA-256 digest,
#       build it with make and copy the interpreter and its library into $QCL_PREFIX. Nothing
#       is installed without your "y", and sudo is never used.
# WHY:  QCL (Quantum Computation Language) is a quantum programming language and simulator.
#       It runs on a classical computer and simulates quantum circuits, so no quantum hardware
#       is needed for Hello World. It is built from source because no package manager ships it.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the development machine). macOS Apple Silicon and Linux
# (Debian/Ubuntu) are supported by the script and NOT verified. Windows (Git Bash / WSL) is NOT
# verified: the script stops.
# Sources: the QCL source archive (URL and digest in qcl-env.sh), the Homebrew formula
# "readline" (brew info readline) on macOS, and the Debian package libreadline-dev on Linux.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so relative paths work from anywhere.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/warn/fail, TF_OS, has_cmd, confirm, install_pkg, fix_developer_dir.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# QCL_VERSION, QCL_URL, QCL_SHA256, QCL_PREFIX, QCL, QCL_LIB, QCL_READLINE.
# shellcheck source=qcl-env.sh
. ./qcl-env.sh

# build_qcl_from_source - download the QCL source archive, check it, build it with make
# and copy the interpreter and its library into $QCL_PREFIX (no sudo).
build_qcl_from_source() {
    qcl_cache=${XDG_CACHE_HOME:-$HOME/.cache}/hello-world-qcl
    qcl_tgz=qcl-$QCL_VERSION.tgz
    explain "Download $qcl_tgz from the author's server into $qcl_cache, check its SHA-256"
    explain "digest, build it with make, and copy qcl and its lib/ folder into $QCL_PREFIX."
    confirm "Build QCL $QCL_VERSION now (a few minutes)?" \
        || { warn "Skipped. Run ./install.sh again when you are ready."; exit 1; }

    case "$TF_OS" in
        linux) tools_hint="Run: sudo apt-get install build-essential flex bison libreadline-dev" ;;
        *)     tools_hint="Run: xcode-select --install" ;;
    esac
    has_cmd make || fail "make is missing. $tools_hint"
    has_cmd c++ || fail "A C++ compiler is missing. $tools_hint"
    has_cmd flex || fail "flex is missing. $tools_hint"
    has_cmd bison || has_cmd yacc || fail "bison (or yacc) is missing. $tools_hint"
    if [ ! -f "$QCL_READLINE/include/readline/readline.h" ]; then
        warn "GNU readline headers were not found in $QCL_READLINE/include/readline."
        case "$TF_OS" in
            linux)
                fail "GNU readline is missing. Run: sudo apt-get install libreadline-dev (or set QCL_READLINE to its folder)" ;;
            *)
                has_cmd brew || fail "Homebrew is missing. Install it from https://brew.sh, then run: brew install readline"
                install_pkg "GNU readline (Homebrew formula readline)" brew install readline || exit 1
                # The prefix is the same before and after the install; check the header is there now.
                [ -f "$QCL_READLINE/include/readline/readline.h" ] \
                    || fail "readline.h is still missing in $QCL_READLINE after brew install readline." ;;
        esac
    fi

    mkdir -p "$qcl_cache"
    [ -f "$qcl_cache/$qcl_tgz" ] || curl -fL -o "$qcl_cache/$qcl_tgz" "$QCL_URL"
    # The checksum proves the file is exactly the QCL 0.6.7 archive.
    echo "$QCL_SHA256  $qcl_cache/$qcl_tgz" | shasum -a 256 -c - \
        || fail "Checksum mismatch: delete $qcl_cache/$qcl_tgz and retry."

    qcl_src=$(mktemp -d)
    tar -xzf "$qcl_cache/$qcl_tgz" -C "$qcl_src"
    # PLOPT= and PLLIB= leave out the plot feature (it needs GNU libplotter). RLOPT and RLLIB
    # point the compiler and linker at GNU readline (Homebrew's on macOS, because macOS's readline
    # lacks rl_unbind_key; the system one on Linux).
    (
        cd "$qcl_src/qcl-$QCL_VERSION"
        make PLOPT= PLLIB= \
            RLOPT="-DQCL_USE_READLINE -I$QCL_READLINE/include" \
            RLLIB="-L$QCL_READLINE/lib -lreadline -lncurses"
    ) || fail "Building QCL failed. See the messages above."
    mkdir -p "$QCL_PREFIX/bin" "$QCL_PREFIX/lib"
    cp "$qcl_src/qcl-$QCL_VERSION/qcl" "$QCL_PREFIX/bin/qcl"
    cp -R "$qcl_src/qcl-$QCL_VERSION/lib/." "$QCL_PREFIX/lib/"
    rm -rf "$qcl_src"
}

step "1/2 Check whether the QCL interpreter is installed"
explain "WHY: qcl runs hello.qcl on a classical computer, simulating the quantum parts."
if [ -x "$QCL" ]; then
    ok "QCL found: $QCL"
    exit 0
fi
warn "QCL is not installed at $QCL."

step "2/2 Install QCL $QCL_VERSION"
explain "WHY: QCL is distributed as a source archive, so it is built on your computer (see qcl-env.sh)."
case "$TF_OS" in
    macos-intel|macos-arm|linux)
        fix_developer_dir
        build_qcl_from_source ;;
    *)
        fail "Windows is not verified for this implementation. Build QCL under WSL, or see $QCL_URL." ;;
esac

[ -x "$QCL" ] || fail "'$QCL' was not built. See the messages above."
ok "QCL $QCL_VERSION is ready in $QCL_PREFIX. Next: ./build.sh"
