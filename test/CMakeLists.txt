#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# start test suite check section
message(STATUS "Performing test suite checks:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# bring in required CMake modules
include(FindUnixCommands)

# test for bash
IF(NOT BASH)

	# the ability to run the test suite is optional
	message(WARNING "Test suite unavailable: missing bash.")
ELSE()

	# glob any tests in the current source directory (test)
	file(GLOB test_commands "${CMAKE_CURRENT_SOURCE_DIR}/test_*.sh")

	# iterate through each and create a suitable test target
	FOREACH(_cmd IN LISTS test_commands)

		# grab the test command stem and filename
		cmake_path(GET _cmd STEM _cmd_stem)
		cmake_path(GET _cmd FILENAME _cmd_filename)

		# spew some useful status of what was found
		message(STATUS "Found ${_cmd_filename}")

		# now actually declare the test
		add_test(NAME ${_cmd_stem} COMMAND ${_cmd})
	ENDFOREACH()
ENDIF()

# end test suite check section
list(POP_BACK CMAKE_MESSAGE_INDENT)
