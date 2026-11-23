#!/bin/sh
# install.sh — Smalltalk web: download Pharo 14 into a local cache.
#
# WHAT: downloads the Pharo 14.0 image and VM from files.pharo.org into
#       languages/smalltalk/.cache/pharo14/, checks each file's SHA-256 digest
#       against pharo-env.sh, and unpacks them. Nothing is downloaded without
#       your "y". Idempotent: a second run exits immediately if the cache
#       already holds the image and VM.
# WHY:  Pharo is an image-based Smalltalk system. The VM interprets the image
#       file (Pharo.image) which contains Zinc HTTP Components (ZnServer),
#       Pharo's standard HTTP library. There is no package manager entry; the
#       Pharo project publishes the image and VM as ZIP files.
# HOW:  ./install.sh       (run once; safe to run again)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux x86_64 and Windows x86_64 (Git Bash) use their own VM ZIP and are NOT
# verified with this script.
# Source: https://files.pharo.org/get-files/140/
#         https://pharo.org/download
#         https://github.com/svenvc/zinc (Zinc HTTP Components)

set -eu

cd -- "$(dirname -- "$0")"
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh
# PHARO_VERSION, PHARO_CACHE, PHARO_HEADLESS, PHARO_UI, PHARO_IMAGE, URLs, digests
# shellcheck source=pharo-env.sh
. ./pharo-env.sh

# fetch URL SHA256 FILE - download URL to FILE, then check its SHA-256 digest.
fetch() {
    curl -fsSL "$1" -o "$3"
    echo "$2  $3" | shasum -a 256 -c - >/dev/null \
        || fail "Checksum mismatch for $1: see the note in pharo-env.sh."
}

# write_launcher FILE [OPTION] - write a small sh script that starts the VM
# with OPTION and passes on its own arguments. It finds the VM next to itself.
write_launcher() {
    # shellcheck disable=SC2016  # $0 and $@ belong in the launcher, unexpanded
    printf '%s\n' '#!/bin/sh' \
        '# Starts the Pharo VM in this folder. Written by install.sh.' \
        'dir=$(cd -- "$(dirname -- "$0")" && pwd)' \
        "exec \"\$dir/$vm_bin\" ${2:-}\"\$@\"" > "$1"
    chmod +x "$1"
}

# install_pharo - download and check both ZIPs, unpack them, write the launchers.
install_pharo() {
    dl=$PHARO_CACHE/download
    rm -rf "$dl" "$PHARO_CACHE/pharo-vm"
    mkdir -p "$dl"
    fetch "$PHARO_FILES/$PHARO_IMAGE_ZIP" "$PHARO_IMAGE_SHA256" "$dl/image.zip"
    fetch "$PHARO_FILES/get-files/$PHARO_VERSION/$vm_zip" "$vm_sha256" "$dl/vm.zip"
    unzip -q "$dl/image.zip" -d "$dl/image"
    unzip -q "$dl/vm.zip" -d "$PHARO_CACHE/pharo-vm"
    mv -f "$dl"/image/*.image "$PHARO_IMAGE"
    mv -f "$dl"/image/*.changes "$PHARO_CACHE/Pharo.changes"
    mv -f "$dl"/image/*.sources "$PHARO_CACHE/"
    write_launcher "$PHARO_HEADLESS" "--headless "
    write_launcher "$PHARO_UI"
    rm -rf "$dl"
}

step "1/3 Check whether Pharo 14 is already in the cache"
explain "WHY: install is idempotent — running it twice wastes bandwidth and time."
if [ -f "$PHARO_IMAGE" ] && [ -x "$PHARO_HEADLESS" ]; then
    ok "Pharo 14 found in $PHARO_CACHE"
    exit 0
fi
warn "Pharo 14 not in cache."

step "2/3 Pick the Pharo VM for this system"
explain "WHY: the image runs everywhere, but the VM is a native program per OS and CPU."
case "$TF_OS" in
    macos-intel) vm_zip=pharo-vm-Darwin-x86_64-stable.zip
                 vm_sha256=$PHARO_VM_SHA256_DARWIN_X86_64
                 vm_bin=pharo-vm/Pharo.app/Contents/MacOS/Pharo ;;
    macos-arm)   vm_zip=pharo-vm-Darwin-arm64-stable.zip
                 vm_sha256=$PHARO_VM_SHA256_DARWIN_ARM64
                 vm_bin=pharo-vm/Pharo.app/Contents/MacOS/Pharo ;;
    linux)       [ "$(uname -m)" = x86_64 ] \
                     || fail "No pinned Pharo VM for Linux on $(uname -m). See https://pharo.org/download"
                 vm_zip=pharo-vm-Linux-x86_64-stable.zip
                 vm_sha256=$PHARO_VM_SHA256_LINUX_X86_64
                 vm_bin=pharo-vm/pharo ;;
    windows)     vm_zip=pharo-vm-Windows-x86_64-stable.zip
                 vm_sha256=$PHARO_VM_SHA256_WINDOWS_X86_64
                 vm_bin=pharo-vm/PharoConsole.exe ;;
    *)           fail "Unknown OS. Download Pharo by hand: https://pharo.org/download" ;;
esac
ok "VM: $vm_zip"

step "3/3 Download Pharo 14 (image + VM, about 45 MB) into $PHARO_CACHE"
explain "WHY: Pharo is not in a package manager; the Pharo project publishes ZIPs."
explain "     Each file's SHA-256 digest is checked against pharo-env.sh first."
explain "     Image: $PHARO_FILES/$PHARO_IMAGE_ZIP"
explain "     VM:    $PHARO_FILES/get-files/$PHARO_VERSION/$vm_zip"
require_cmd curl "curl downloads Pharo from files.pharo.org. Install it from your package manager."
require_cmd shasum "shasum checks the digests. It comes with Perl; install it from your package manager."
require_cmd unzip "unzip unpacks the Pharo ZIPs. Install it from your package manager."
install_pkg "Pharo 14 (image and VM)" install_pharo || exit 1
