# shellcheck shell=sh
# use-msys2-ruby.sh - sourced by every install.sh and run.sh of this language
# (not run on its own)
#
# WHAT: on Windows, makes the Ruby that install.sh got from MSYS2 the one that
#       runs. Elsewhere, or while that Ruby is not installed, it does nothing.
# WHY:  on Windows, install.sh gets Ruby 4.0 from MSYS2 (see install.sh): the
#       same Ruby version as on macOS, with Bundler 4.0.20, the version
#       recorded in the Gemfile.lock files. MSYS2 is pre-installed on the
#       GitHub windows-latest image but "not added to PATH", and its packages
#       live in C:\msys64\ucrt64\bin. Each script is a separate process, so
#       each one adds that folder itself. It goes at the START of PATH
#       because the runner image has another Ruby (RubyInstaller 3.3), and
#       this one must win; the folder holds only what the packages bring
#       (ruby, gem, bundle, gcc, Tcl/Tk and their DLLs).
#       MAKE: the gems with a C part (Puma, tk) are built by "make". On
#       Windows, Ruby's mkmf writes Makefiles with paths like /C/msys64/...
#       for "make from msys", so RubyGems is pointed at MSYS2's make package
#       (C:\msys64\usr\bin\make.exe), not the native mingw32-make.
#       BUNDLE: MSYS2's "bundle" file does not start with "#!", so Git Bash
#       does not run it as a command; msys2-bin/bundle (first on PATH) does.
# Sources:
#   https://github.com/actions/runner-images/blob/main/images/windows/Windows2025-Readme.md#msys2
#   https://packages.msys2.org/packages/mingw-w64-ucrt-x86_64-ruby   (/ucrt64/bin/ruby.exe, bundle)
#   https://packages.msys2.org/packages/make                         (/usr/bin/make.exe)
#   https://github.com/ruby/ruby/blob/master/lib/mkmf.rb             (mkintpath: "mingw uses make from msys")
#   https://github.com/ruby/rubygems/blob/master/lib/rubygems/ext/builder.rb  (ENV["MAKE"])
#   https://cygwin.com/cygwin-ug-net/using-filemodes.html             (when a file counts as executable)
if [ "${TF_OS:-}" = windows ] && [ -x /c/msys64/ucrt64/bin/ruby.exe ]; then
    # Every script cd's into its own folder first, so ../msys2-bin is this
    # language's folder of that name.
    PATH="$(cd .. && pwd)/msys2-bin:/c/msys64/ucrt64/bin:$PATH"
    # A Windows path, because RubyGems starts make itself (not through sh).
    MAKE=C:/msys64/usr/bin/make.exe
    export PATH MAKE
fi
