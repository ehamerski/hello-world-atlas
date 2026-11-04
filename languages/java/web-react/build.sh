#!/bin/sh
# build.sh - Java web-react: compile the backend and build the front end
#
# WHAT: 1. backend/:  "mvn package" compiles the Spring Boot API into the
#          executable jar backend/target/hello-api.jar;
#       2. frontend/: "npm run build" (Vite) turns index.html and the
#          React code in src/ into plain HTML and JavaScript in frontend/dist.
# WHY:  each part has its own build. The JVM runs bytecode, so javac (called
#       by Maven) compiles the Java first. Browsers do not understand JSX
#       (the HTML-like syntax in App.jsx) and load one bundled file faster
#       than many small ones, so Vite translates and bundles the front end.
# HOW:  ./build.sh         (after ./install.sh; run again after editing code)
#
# Platforms: macOS Intel (verified on the dev machine); macOS Apple Silicon,
# Linux and Windows (Git Bash / WSL) are documented but NOT verified.

# -e: stop at the first failing command; -u: using an unset variable is an error.
set -eu

# Run from this script's folder so backend/ and frontend/ are found.
cd -- "$(dirname -- "$0")"
# Shared helpers: step/explain/ok/fail, require_cmd.
# shellcheck source=../../../scripts/common.sh
. ../../../scripts/common.sh

step "1/3 Check the build tools"
explain "WHY: the backend needs the JDK and Maven, the front end needs Node.js and its"
explain "     packages; ./install.sh installs all of them."
require_cmd javac "The JDK compiles the backend."
require_cmd mvn "Maven builds the backend."
require_cmd npm "npm runs the front end's build."
[ -x frontend/node_modules/.bin/vite ] \
    || fail "frontend/node_modules is missing. Run ./install.sh first."

step "2/3 Backend: compile and package the Spring Boot API with Maven"
explain "WHY: 'mvn package' compiles backend/src/main/java and packs backend/target/hello-api.jar"
explain "     with Spring and Tomcat inside. The first build downloads them into ~/.m2."
(cd backend && mvn --batch-mode --quiet package)
ok "Built backend/target/hello-api.jar"

step "3/3 Front end: build the React app with Vite"
explain "WHY: 'npm run build' runs 'vite build', which translates the JSX into JavaScript"
explain "     and writes index.html plus one bundled .js file into frontend/dist."
(cd frontend && npm run build)

ok "Both parts are built. Next: ./run.sh"
