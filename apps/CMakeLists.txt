#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# declare cligen apps by input and output name
set(cligen_apps
	cligen_file
	cligen_hello
	cligen_tutorial
)

# build each app and link against cligen
foreach(_app IN LISTS cligen_apps)

	# declare the app and source
	add_executable(${_app} "${_app}.c")

	# link against the cligen library
	target_link_libraries(${_app} PUBLIC cligen_static)

	# point to public headers
	target_include_directories(${_app} PUBLIC "${PROJECT_SOURCE_DIR}/include")
endforeach()

install(TARGETS ${cligen_apps} RUNTIME)
