#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#
# CMake should be as generalized as possible,
# so we read version from /CLIGEN_VERSION
#

# version file to read and parse
set(CLIGEN_VERSION_FILE "${CMAKE_SOURCE_DIR}/CLIGEN_VERSION")

# bail out if the version file is not found
if(NOT EXISTS ${CLIGEN_VERSION_FILE})
	message(FATAL_ERROR "Unable to locate ${CLIGEN_VERSION_FILE}")
endif()

# read the file
file(READ "${CMAKE_SOURCE_DIR}/CLIGEN_VERSION" ver)

# parse CLIGEN_VERSION_MAJOR
string(REGEX MATCH "CLIGEN_VERSION_MAJOR=([0-9]*)" _ ${ver})
set(CLIGEN_VERSION_MAJOR ${CMAKE_MATCH_1})

# parse CLIGEN_VERSION_MINOR
string(REGEX MATCH "CLIGEN_VERSION_MINOR=([0-9]*)" _ ${ver})
set(CLIGEN_VERSION_MINOR ${CMAKE_MATCH_1})

# parse CLIGEN_VERSION_PATCH
string(REGEX MATCH "CLIGEN_VERSION_PATCH=([0-9a-zA-Z]*)" _ ${ver})
set(CLIGEN_VERSION_PATCH ${CMAKE_MATCH_1})

# build the complete version string
set(CLIGEN_VERSION "${CLIGEN_VERSION_MAJOR}.${CLIGEN_VERSION_MINOR}.${CLIGEN_VERSION_PATCH}")

# some useful output spew
message(STATUS "Build Cligen version: ${CLIGEN_VERSION}")
