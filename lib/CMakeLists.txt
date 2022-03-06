#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# declare cligen library build target
add_subdirectory(src)
add_subdirectory(cligen)

# public headers for library consumers and for the library itself
target_include_directories(cligen
	PUBLIC  "${CMAKE_CURRENT_SOURCE_DIR}"
	PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/cligen"
	)

# private headers (static and generated) for the library itself
target_include_directories(cligen
	PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src"
	PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/src"
	)
