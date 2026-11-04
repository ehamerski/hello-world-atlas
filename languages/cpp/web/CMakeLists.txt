# CMakeLists.txt - C++ web: how CMake builds hello.cpp with cpp-httplib.
#
# CMake reads this file and generates the files of a real build tool,
# which then call the C++ compiler. build.sh runs both steps.

cmake_minimum_required(VERSION 3.20)

project(hello_web LANGUAGES CXX)

# ISO C++20, no compiler dialect (see ../cli/CMakeLists.txt).
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# cpp-httplib is header-only: the compiler only needs to find httplib.h.
# find_path searches the usual include folders (and CMAKE_PREFIX_PATH)
# and stores the folder in HTTPLIB_INCLUDE_DIR. Its installed CMake package
# (httplib::httplib) is not used on purpose: Homebrew's build turns on
# HTTPS and compression, which would also require OpenSSL and zlib, and a
# plain-HTTP hello world needs neither.
find_path(HTTPLIB_INCLUDE_DIR httplib.h REQUIRED)

# cpp-httplib serves connections from a pool of worker threads (class
# ThreadPool in httplib.h), so the program must be linked with the
# system's thread library. Threads::Threads is
# CMake's portable name for it (-pthread on Linux).
find_package(Threads REQUIRED)

add_executable(hello-web hello.cpp)
target_include_directories(hello-web PRIVATE ${HTTPLIB_INCLUDE_DIR})
target_link_libraries(hello-web PRIVATE Threads::Threads)
target_compile_options(hello-web PRIVATE -Wall -Wextra -pedantic-errors)
