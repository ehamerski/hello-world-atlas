# shellcheck shell=sh
# use-runner-jdk.sh - sourced by install.sh, build.sh and run.sh of the Java, Clojure and Kotlin folders.
#
# WHAT: on Windows, put JDK 21 first on PATH when the machine has one that is
#       not the default. On every other OS it does nothing.
# WHY:  the GitHub windows-latest image ships several JDKs side by side,
#       Java 17 first on PATH, and publishes where each one lives in the
#       variables JAVA_HOME_8_X64 ... JAVA_HOME_25_X64. This project needs 21
#       (maven.compiler.release in pom.xml), so we select it ourselves.
#       Every script sources this file because each one is a separate process:
#       a PATH change made by install.sh does not reach build.sh or run.sh.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#java
#   https://cygwin.com/cygwin-ug-net/cygpath.html   (cygpath -u: C:\x -> /c/x)
if [ "${TF_OS:-}" = windows ] && [ -n "${JAVA_HOME_21_X64:-}" ] && has_cmd cygpath; then
    # Maven's mvn.cmd reads JAVA_HOME in Windows form, Git Bash's PATH wants
    # the POSIX form of the same folder.
    JAVA_HOME=$JAVA_HOME_21_X64
    export JAVA_HOME
    PATH="$(cygpath -u "$JAVA_HOME")/bin:$PATH"
    export PATH
fi
