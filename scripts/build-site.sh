#!/bin/sh
# scripts/build-site.sh - build the website from languages/ and docs/.
#
# WHAT:
#   1. checks Node.js (Astro needs Node >= 22.23.4, an even major version);
#   2. installs the site's npm packages from site/package-lock.json (npm ci);
#   3. generates the pages from the repository Markdown and meta.yml files
#      (site/scripts/generate.mjs);
#   4. packs one ZIP per implementation (scripts/package-downloads.sh);
#   5. builds the static site into site/dist/ (Astro + Starlight);
#   6. checks every internal link of the built site (site/scripts/check-links.mjs);
#   7. with --preview, serves site/dist/ on http://localhost:4321/.
#
# WHY: the site has no content of its own. Every page comes from the
#   repository at build time, so the site and the READMEs never disagree.
#   Everything this script writes is git-ignored.
#
# USAGE:
#   scripts/build-site.sh              # build into site/dist/
#   scripts/build-site.sh --preview    # build, then serve it locally
#   scripts/build-site.sh --clean      # reinstall the npm packages first
#   SITE_BASE=/hello-world/ scripts/build-site.sh   # site served under a sub-path
#
# References: Astro install requirements https://docs.astro.build/en/install-and-setup/
#   npm ci https://docs.npmjs.com/cli/commands/npm-ci

set -eu
cd -- "$(dirname -- "$0")/.."
. ./scripts/common.sh

PREVIEW=0
CLEAN=0
for arg in "$@"; do
    case "$arg" in
        --preview) PREVIEW=1 ;;
        --clean) CLEAN=1 ;;
        *) fail "Unknown option: $arg (use --preview or --clean)" ;;
    esac
done

# Astro collects anonymous usage data unless this is set: https://astro.build/telemetry/
ASTRO_TELEMETRY_DISABLED=1
export ASTRO_TELEMETRY_DISABLED

step "1. Checking Node.js"
explain "Astro, the site generator, runs on Node.js >= 22.23.4 (even major versions only)."
require_cmd node "Install Node.js LTS from https://nodejs.org/."
major=$(node -p 'process.versions.node.split(".")[0]')
if [ "$major" -lt 22 ] || [ $((major % 2)) -ne 0 ]; then
    fail "Node.js $(node -v) is not supported by Astro. Install an even major version >= 22."
fi
ok "Node.js $(node -v)"

step "2. Installing the site's npm packages"
if [ "$CLEAN" = 1 ] || [ ! -d site/node_modules ]; then
    explain "npm ci installs the exact versions in site/package-lock.json, so every build uses the same packages."
    (cd site && npm ci --no-fund --no-audit)
else
    explain "site/node_modules exists, so the install is skipped (use --clean to reinstall from the lockfile)."
fi

step "3. Generating the pages from languages/ and docs/"
explain "Each README, doc, and meta.yml becomes a page; nothing is copied by hand."
node site/scripts/generate.mjs

step "4. Packing the download ZIPs"
explain "Each language page links to a ZIP of its implementations."
scripts/package-downloads.sh site/public/downloads

step "5. Building the static site"
explain "Astro renders every page to HTML in site/dist/ and Pagefind builds the search index."
(cd site && ./node_modules/.bin/astro build)
ok "Site built in site/dist/"

step "6. Checking the links of the built site"
explain "Every rewritten link must land on a real page and heading."
node site/scripts/check-links.mjs

if [ "$PREVIEW" = 1 ]; then
    step "7. Serving the site at http://localhost:4321/ (Ctrl+C to stop)"
    explain "astro preview serves the built files; it is for checking, not for production."
    cd site && exec ./node_modules/.bin/astro preview
else
    explain "Preview it with: scripts/build-site.sh --preview   (or: cd site && npm run preview)"
fi
