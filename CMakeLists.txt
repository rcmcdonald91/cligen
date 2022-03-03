#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# set minimum cmake version
cmake_minimum_required(VERSION 3.22)

# require out-of-source build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR
        "In-source build is not allowed. \
        Please make a standalone build directory and run CMake from there. \
        You may need to remove CMakeCache.txt."
    )
endif()

# check the supported platform
if(NOT UNIX)
    message(FATAL_ERROR "Only *nix like systems are supported.")
endif()

# turn on testing framework
enable_testing()

# start preflight check section
message(STATUS "Performing preflight checks:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# define default build type
set(default_build_type "Debug")

# make sure we have a valid build type before proceeding
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
        STRING "Choose the type of build." FORCE
    )
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release"
    )
endif()

# grab some useful information for spewing
string(TIMESTAMP _today "%Y.%m.%d %H:%M")
cmake_host_system_information(RESULT _host_name QUERY HOSTNAME)

# now spew this useful information
message(STATUS "CMake version ${CMAKE_VERSION}")
message(STATUS "Build type ${CMAKE_BUILD_TYPE}")
message(STATUS "Build host ${_host_name}")
message(STATUS "Build time ${_today}")
message(STATUS "Build user $ENV{USER}")

# set the project name
project(cligen
    VERSION 5.6.0
    DESCRIPTION "Command-Line Interface generator"
    HOMEPAGE_URL "http://www.cligen.se/"
    LANGUAGES C
)

# end the preflight check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# first build the cligen library
add_subdirectory(cligen)

# second build the cligen apps
add_subdirectory(apps)

# bring in the tests
add_subdirectory(test)

# install public headers from include/*.h, which are all public headers
install(DIRECTORY include/ TYPE INCLUDE FILES_MATCHING PATTERN "*.h")

# install shared and static libraries
install(TARGETS cligen_shared)
install(TARGETS cligen_static)
