# shellcheck shell=sh
# alire-env.sh - Ada cli: puts the folder where install.sh puts alr on PATH
#                (sourced by install.sh and build.sh, not run on its own)
#
# WHY:  install.sh unpacks alr into ~/.local/bin without touching your shell
#       profile, so the scripts add that folder to PATH themselves. On
#       Windows (Git Bash) a program installed after the terminal was opened
#       is never on PATH, so this is needed there for build.sh too. The
#       scripts run with "set -e", so this file must end with a command that
#       succeeds ("return 0").
ALR_BIN_DIR=${ALR_BIN_DIR:-$HOME/.local/bin}
case ":$PATH:" in
    *":$ALR_BIN_DIR:"*) ;;
    *) [ -d "$ALR_BIN_DIR" ] && PATH="$ALR_BIN_DIR:$PATH" ;;
esac
export ALR_BIN_DIR PATH
return 0
