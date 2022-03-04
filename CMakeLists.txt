#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# set minimum cmake version
cmake_minimum_required(VERSION 3.22)

# useful for debugging
set(CMAKE_VERBOSE_MAKEFILE OFF)

# set the default build type
set(default_build_type Debug)

# perform some early configuration
set(CLIGEN_VERSION_MAJOR 5)
set(CLIGEN_VERSION_MINOR 6)
set(CLIGEN_VERSION_PATCH 0)
set(CLIGEN_VERSION  "${CLIGEN_VERSION_MAJOR}.${CLIGEN_VERSION_MINOR}.${CLIGEN_VERSION_PATCH}")

# require out-of-source build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR
        "In-source build is not allowed. \
        Please make a standalone build directory and run CMake from there. \
        You may need to remove CMakeCache.txt.")
endif()

# check the supported platform
if(NOT UNIX)
    message(FATAL_ERROR "Only *nix like systems are supported.")
endif()

# ensure we have a default build type
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
        STRING "Choose the type of build." FORCE)
endif()

# turn on testing framework
enable_testing()

# start preflight check section
message(STATUS "Performing preflight checks:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# grab some useful information for spewing
string(TIMESTAMP _today "%Y.%m.%d %H:%M")
cmake_host_system_information(RESULT _host_name QUERY HOSTNAME)

# now spew this useful information
message(STATUS "CMake version ${CMAKE_VERSION}")
message(STATUS "CLIgen version ${CLIGEN_VERSION}")
message(STATUS "Build type ${CMAKE_BUILD_TYPE}")
message(STATUS "Build host ${_host_name}")
message(STATUS "Build time ${_today}")
message(STATUS "Build user $ENV{USER}")

# setup the main cligen project
project(cligen
    VERSION ${CLIGEN_VERSION}
    DESCRIPTION "Command-Line Interface generator"
    HOMEPAGE_URL "https://www.cligen.se/"
    LANGUAGES C)

# end the preflight check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# walk the source tree
add_subdirectory(cligen)
add_subdirectory(apps)

# install public headers from include/*.h, which are all public headers
install(
    DIRECTORY include/
    TYPE INCLUDE
    FILES_MATCHING PATTERN "*.h")

# install both the shared and static cligen libraries
install(TARGETS cligen_shared)
install(TARGETS cligen_static)
