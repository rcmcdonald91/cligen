#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# ensure sure CMAKE_BUILD_TYPE is at least set to the default set above
if(NOT CMAKE_BUILD_TYPE)
	message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
	set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE
		STRING "Choose the type of build." FORCE
		)
endif()

if(CLIGEN_MAINTAINER_MODE)
	# Turn warnings as errors
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Werror")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")

	# we want to enforce debug building while in maintainer mode
	set(CMAKE_BUILD_TYPE Debug)

	# useful for debugging purposes
	set(CMAKE_VERBOSE_MAKEFILE ON)
endif()
