#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# setup the cmake project, and spew some useful information
message(STATUS "CMake current version: ${CMAKE_VERSION}")
cmake_minimum_required(VERSION 3.17)
message(STATUS "CMake minimum version: ${CMAKE_MINIMUM_REQUIRED_VERSION}")
project(cligen)

# bring in some required cmake modules
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckSymbolExists)
include(GNUInstallDirs)

# specify default build type
set(DEFAULT_BUILD_TYPE Release)

# options to control error behavior
option(CLIGEN_MAINTAINER_MODE "Fail compliation on warnings" OFF)
include(cmake/maintainer_mode.cmake)

# cligen library options
option(CLIGEN_SOURCE "Configure for source package only, skipping build configuration" OFF)
option(CLIGEN_STATIC "Build statically linked binaries" OFF)
option(CLIGEN_WITH_LIBXML2 "Use GNOME/libxml2 regex engine" OFF)

# we just hijack the built-in control variable here
if(CLIGEN_STATIC)
	set(BUILD_SHARED_LIBS OFF)
else()
	set(BUILD_SHARED_LIBS ON)
endif()

# spew some useful host-related information
include(cmake/host_info.cmake)

# parse and set the correct version strings from CLIGEN_VERSION
include(cmake/version.cmake)

# no need to execute any additional steps if only packaging the source
if(CLIGEN_SOURCE)
	return()
endif()

# require out-of-source build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
	message(FATAL_ERROR
		"In-source building is not allowed. \
		Please make a standalone build directory and run CMake from there. \
		You may need to remove CMakeCache.txt."
		)
endif()

# check the supported platform
if(NOT UNIX)
	message(FATAL_ERROR "Only *nix like systems are supported.")
endif()

# spew some additional information
include(cmake/build_options_info.cmake)
include(cmake/compile_options_info.cmake)

# process any relevant subdirs
add_subdirectory(lib)
add_subdirectory(apps)

# define install target for the cligen library
# public headers are installed to /usr/local/include/cligen/
# consumers are expected to source headers as <cligen/*.h>
install(TARGETS cligen
	PUBLIC_HEADER DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/cligen"
	)
