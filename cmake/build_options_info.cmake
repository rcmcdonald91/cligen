#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# define the variables we are interested in
set(CLIGEN_BUILD_OPTIONS
	CLIGEN_MAINTAINER_MODE
	CLIGEN_SOURCE
	CLIGEN_STATIC
	CLIGEN_WITH_LIBXML2
)

# now print them
message(STATUS "Build options:")
foreach(_build_option IN LISTS CLIGEN_BUILD_OPTIONS)
	list(APPEND CMAKE_MESSAGE_INDENT "  ")
	get_property(_help_string CACHE ${_build_option} PROPERTY HELPSTRING)
	message(STATUS "${_build_option}: ${${_build_option}}")
	list(POP_BACK CMAKE_MESSAGE_INDENT)
endforeach()
