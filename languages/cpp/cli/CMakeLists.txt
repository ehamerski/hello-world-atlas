# CMakeLists.txt - C++ cli: how CMake builds hello.cpp into hello-cli.
#
# CMake does not compile anything itself. It reads this file and generates
# the files of a real build tool (Makefiles by default on macOS and Linux),
# which then call the C++ compiler. build.sh runs both steps.
# Reference: https://cmake.org/cmake/help/latest/guide/tutorial/index.html

# The oldest CMake this file is written for. It also switches on the
# behavior ("policies") of that version.
cmake_minimum_required(VERSION 3.20)

# The project name and its language: CXX is CMake's name for C++.
project(hello_cli LANGUAGES CXX)

# Compile as ISO C++20. REQUIRED: stop if the compiler cannot do C++20
# instead of silently using an older standard. EXTENSIONS OFF: pass
# -std=c++20, not the compiler's dialect -std=gnu++20 (the same idea as
# -std=c89 -pedantic-errors in ../../c/cli/build.sh).
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# One executable, made from one source file.
add_executable(hello-cli hello.cpp)

# Extra warnings (clang and gcc). -pedantic-errors rejects compiler
# extensions, so the code stays standard C++.
target_compile_options(hello-cli PRIVATE -Wall -Wextra -pedantic-errors)
