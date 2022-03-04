#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# bring in required CMake modules
include(CMakePrintHelpers)
include(GNUInstallDirs)

# set a few variables required for build.c
string(TIMESTAMP _today "%Y.%m.%d %H:%M")
cmake_host_system_information(RESULT _host_name QUERY HOSTNAME)
set(CLIGEN_BUILDSTR "${_today} by $ENV{USER} on ${_host_name}")
string(LENGTH "${CLIGEN_BUILDSTR}" CLIGEN_BUILDSTR_LEN)

# now generate build.c
configure_file(build.c.in build.c @ONLY)

# start bison/flex section
message(STATUS "Locating BISON/FLEX:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# locate suitable bison and flex
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# end bison/flex section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# flex/bison targets, used in multiple places below
set(bison_target cligen_parse)
set(flex_target lex_${bison_target})

# declare the bison target
BISON_TARGET(${bison_target} ${bison_target}.y "${CMAKE_CURRENT_BINARY_DIR}/${bison_target}.tab.c"
	COMPILE_FLAGS "-l -d -b ${bison_target} -p ${bison_target}"
	DEFINES_FILE "${CMAKE_CURRENT_BINARY_DIR}/${bison_target}.tab.h")

# declare the flex target
FLEX_TARGET(${flex_target} ${bison_target}.l "${CMAKE_CURRENT_BINARY_DIR}/lex.${bison_target}.c"
	COMPILE_FLAGS "-P ${bison_target}")

# add dependency between scanner and parser
ADD_FLEX_BISON_DEPENDENCY(${flex_target} ${bison_target})

# declare any required in-tree sources
set(LIB_SOURCES
	cligen_buf.c
	cligen_callback.c
	cligen_cv.c
	cligen_cvec.c
	cligen_expand.c
	cligen_getline.c
	cligen_handle.c
	cligen_history.c
	cligen_io.c
	cligen_match.c
	cligen_object.c
	cligen_parsetree.c
	cligen_print.c
	cligen_pt_head.c
	cligen_read.c
	cligen_regex.c
	cligen_result.c
	cligen_syntax.c
	cligen_util.c)

# declare any required out-of-tree sources
set(LIB_SOURCES_GENERATED
	${CMAKE_CURRENT_BINARY_DIR}/build.c)

# declare all the required sources for building
set(LIB_SOURCES_ALL
	"${LIB_SOURCES}"
	"${LIB_SOURCES_GENERATED}"
	"${FLEX_${flex_target}_OUTPUTS}"
	"${BISON_${bison_target}_OUTPUTS}")

# declare both shared and static variants of the library, we will install both
add_library(cligen_shared SHARED "${LIB_SOURCES_ALL}")
add_library(cligen_static STATIC "${LIB_SOURCES_ALL}")

# declare necessary include directories
foreach(_target cligen_shared cligen_static)
	target_include_directories(${_target}
		PUBLIC "${CMAKE_SOURCE_DIR}/include"
		PRIVATE "${CMAKE_SOURCE_DIR}/include/cligen"
		PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../include"
		PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/../include")
endforeach()

list(POP_BACK CMAKE_MESSAGE_INDENT)

# rename the library target output names accordingly
# we deferentiated _shared and _static for CMake, but these can have the same name
set_property(TARGET cligen_shared PROPERTY LIBRARY_OUTPUT_NAME ${CMAKE_PROJECT_NAME})
set_property(TARGET cligen_static PROPERTY ARCHIVE_OUTPUT_NAME ${CMAKE_PROJECT_NAME})

# set VERSION/SOVERSION to properly generate namelinks for shared library
# symlinks will be automatically created for both VERSION/SOVERSION names
set_target_properties(cligen_shared PROPERTIES
	VERSION "${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}"
	SOVERSION ${CMAKE_PROJECT_VERSION_MAJOR})
