# CMakeLists.txt - C++ desktop: how CMake builds hello.cpp against Qt 6.
#
# CMake reads this file and generates the files of a real build tool,
# which then call the C++ compiler. build.sh runs both steps. This follows
# Qt's own "Getting started with CMake" guide:
# https://doc.qt.io/qt-6/cmake-get-started.html

cmake_minimum_required(VERSION 3.20)

project(hello_desktop LANGUAGES CXX)

# ISO C++20, no compiler dialect (see ../cli/CMakeLists.txt).
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Find Qt 6 and its Widgets module. Qt installs "config files"
# (Qt6Config.cmake) that tell CMake where its headers and libraries are,
# the job pkg-config does in ../../c/desktop/build.sh. REQUIRED: stop
# with an error if Qt 6 is not installed.
find_package(Qt6 REQUIRED COMPONENTS Widgets)

# Qt's recommended defaults for a project (for example, it switches on
# Qt's code generators when a project needs them).
qt_standard_project_setup()

# qt_add_executable is Qt's wrapper around add_executable.
qt_add_executable(hello-desktop hello.cpp)

# Link Qt Widgets. Qt6::Widgets is an "imported target": it also brings
# in Qt's include folders and the modules Widgets depends on (Gui, Core).
target_link_libraries(hello-desktop PRIVATE Qt6::Widgets)

# Extra warnings, and no compiler extensions (as in ../cli). Qt's headers
# compile cleanly this way. Compare ../../c/desktop, where GTK's headers
# forced C99 instead of C89.
target_compile_options(hello-desktop PRIVATE -Wall -Wextra -pedantic-errors)
