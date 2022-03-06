#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# start application build check section
message(STATUS "Checking Cligen apps:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# declare the cligen apps to build
set(cligen_apps
	"cligen_file.c"
	"cligen_hello.c"
	"cligen_tutorial.c"
	)

# iterate over each app and create and link the build targets
foreach(_app_filename IN LISTS cligen_apps)
	message(CHECK_START "Looking for ${_app_filename}")

	# guard check, only continue if successful
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_app_filename}")
		message(CHECK_PASS "found, will build")

		# strip extension from filename for build target name
		get_filename_component(_app ${_app_filename} NAME_WE)

		# declare app build target
		add_executable(${_app} "${_app_filename}")

		# link with cligen as private (i.e. the app has no consumers)
		target_link_libraries(${_app} PRIVATE cligen)

		# declare app install target
		install(TARGETS ${_app} RUNTIME)

		# check the next app...
		continue()
	endif()

	# whoops...
	message(CHECK_FAIL "not found")
endforeach()

# end application build check section
list(POP_BACK CMAKE_MESSAGE_INDENT)
