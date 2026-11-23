# shellcheck shell=sh disable=SC2034  # sourced: install.sh and run.sh use these
# pharo-env.sh — shared Pharo 14 variables for desktop/ and web/.
# Source this after cd-ing to the category directory (desktop/ or web/).
#
# WHAT: sets PHARO_VERSION, PHARO_CACHE, the launcher and image paths, and the
#       download URLs and digests that install.sh and run.sh use. Keeping them
#       here means only one place changes when upgrading Pharo.
# HOW:  . ./pharo-env.sh      (from install.sh or run.sh, after cd to category)

# PHARO_VERSION: 140 = Pharo 14.0 (folder name on files.pharo.org).
# Source: https://files.pharo.org/get-files/140/
PHARO_VERSION=140

# PHARO_CACHE: shared cache for VM + image, one level up from each category.
# Desktop and web share it; downloading twice wastes time and bandwidth.
# $(dirname "$0") is the category directory (desktop/ or web/), so ".." is
# the smalltalk/ language directory.
PHARO_CACHE="$(cd "$(dirname "$0")/.." && pwd)/.cache/pharo14"

# After install.sh runs, the cache contains:
#   Pharo.image — the Pharo 14.0 image
#   pharo       — headless launcher (scripting, server, --verify)
#   pharo-ui    — UI launcher (Morphic GUI, interactive)
#   pharo-vm/   — the platform-specific virtual machine
#   Pharo.changes and Pharo14.0-64bit-*.sources — the image's change log and source code

PHARO_HEADLESS="$PHARO_CACHE/pharo"
PHARO_UI="$PHARO_CACHE/pharo-ui"
PHARO_IMAGE="$PHARO_CACHE/Pharo.image"

# The files install.sh downloads from files.pharo.org, and their SHA-256 digests.
# The image is a fixed build (789, commit e649a7f87c). The VM ZIPs are the "stable"
# files that get.pharo.org itself downloads; their names stay the same when Pharo
# publishes a new VM. Each digest was computed with "shasum -a 256" on the file
# downloaded from the URL below on 2026-11-19 (Pharo publishes no checksums).
# If a download no longer matches, install.sh stops; check the new file, then
# update its value here.
# Sources: https://files.pharo.org/image/140/ and https://files.pharo.org/get-files/140/
PHARO_FILES=https://files.pharo.org
PHARO_IMAGE_ZIP=image/140/Pharo14.0-SNAPSHOT.build.789.sha.e649a7f87c.arch.64bit.zip
PHARO_IMAGE_SHA256=b01b0fb445cef02ab091d254514ae65402b2efd46e5111cf7b839a1efff9a0dc
PHARO_VM_SHA256_DARWIN_X86_64=0dfc2f877ec25b2fe4c497c43388d445e11b966a3348811946c3c2a3c9fcb0e9
PHARO_VM_SHA256_DARWIN_ARM64=a642a83ec7bbd74bf021db3d0350e280449b98d72ed630afe7537529cbb90a11
PHARO_VM_SHA256_LINUX_X86_64=3ba284b46faf14af59b32f6bc936d7d69da4e0fe0aef5b0474952a366c80a514
PHARO_VM_SHA256_WINDOWS_X86_64=af912994eab9b82fc4835c8516d11a848f518c269db8c795699f1b2616640ae1
