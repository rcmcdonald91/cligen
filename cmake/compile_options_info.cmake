#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# define the variables we are interested in
set(CLIGEN_COMPILE_OPTIONS
	CMAKE_C_FLAGS_DEBUG
	CMAKE_C_FLAGS_RELEASE
	CMAKE_C_FLAGS_RELWITHDEBINFO
	CMAKE_C_FLAGS_MINSIZEREL
	)

# now print them
message(STATUS "Compile flags:")
foreach(_option IN LISTS CLIGEN_COMPILE_OPTIONS)
	list(APPEND CMAKE_MESSAGE_INDENT "  ")
	message(STATUS "${_option}: ${${_option}}")
	list(POP_BACK CMAKE_MESSAGE_INDENT)
endforeach()
