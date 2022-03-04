#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# start application build check section
message(STATUS "Performing application build checks:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# declare the cligen apps to build
set(cligen_apps
	cligen_file
	cligen_hello
	cligen_tutorial)

# iterate over each app and create and link the build targets
foreach(_app IN LISTS cligen_apps)
	set(_app_filename "${_app}.c")

	message(CHECK_START "Looking for ${_app_filename}")

	# guard check, continue if successful
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_app_filename}")
		message(CHECK_PASS "found, will build")
		add_executable(${_app} "${_app_filename}")
		target_link_libraries(${_app} PRIVATE cligen_shared)
		install(TARGETS ${_app} RUNTIME)
		continue()
	endif()

	message(CHECK_FAIL "not found")
endforeach()

# end application build check section
list(POP_BACK CMAKE_MESSAGE_INDENT)
