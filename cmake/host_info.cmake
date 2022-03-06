#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# grab the current datetime stamp
string(TIMESTAMP _TODAY "%m/%d/%Y %H:%M:%S")

# grab the build machine hostname
cmake_host_system_information(RESULT _HOST_NAME QUERY HOSTNAME)

# can be useful to see next to build type
if(CLIGEN_MAINTAINER_MODE)
	set(_extra " (Maintainer mode enabled)")
endif()

# now print the things...
message(STATUS "Build host: ${_HOST_NAME}")
message(STATUS "Build time: ${_TODAY}")
message(STATUS "Build user: $ENV{USER}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}${_extra}")
