#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# some configuration, only used to generate cligen_config.h
set(CLIGEN_REGFD	1)
set(CLIGEN_SUBMODE	1)

# bring in required CMake modules
include(CheckIncludeFile)
include(CheckSymbolExists)

# start header file check section
message(STATUS "Checking headers:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# check these header files
set(HEADERS_TO_CHECK
	"inttypes.h"
	"memory.h"
	"stdint.h"
	"stdlib.h"
	"string.h"
	"strings.h"
	"sys/stat.h"
	"sys/types.h"
	"termios.h"
	"unistd.h"
	)

# transform header file names into HAVE_ variables
foreach(_header IN LISTS HEADERS_TO_CHECK)
	# replaces / and . with _
	string(REGEX REPLACE "[/|.]" "_" _header_v "${_header}")

	# convert file name to uppercase HAVE_ variable 
	string(TOUPPER "HAVE_${_header_v}" _header_v)

	# now we check it and set the output HAVE_ variable
	CHECK_INCLUDE_FILE("${_header}" ${_header_v})
endforeach()

# end header file check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# start symbol check section
message(STATUS "Checking symbols:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# check these symbols
set(SYMBOLS_TO_CHECK
	strsep
	strverscmp
	)

# transform symbol names into HAVE_ variables
foreach(_symbol IN LISTS SYMBOLS_TO_CHECK)
	# convert symbol name to uppercase HAVE_ variable
	string(TOUPPER "HAVE_${_symbol}" _symbol_v)

	# now we check it and set the output HAVE_ variable
	CHECK_SYMBOL_EXISTS(${_symbol} "${HEADERS_TO_CHECK}" ${_symbol_v})
endforeach()

# end symbol check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# start library check section
message(STATUS "Checking libraries:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# check for libxml2 if linking against it and set HAVE_ variables
if(CLIGEN_WITH_LIBXML2)
	find_package(LibXml2 REQUIRED)
	
	# now we should test for <libxml/xmlregexp.h>, because why not...
	list(APPEND CMAKE_REQUIRED_INCLUDES ${LIBXML2_INCLUDE_DIRS})
	CHECK_INCLUDE_FILE("libxml/xmlregexp.h" HAVE_LIBXML_XMLREGEXP_H)
endif()

# end library check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# now generate cligen_config.h, see cligen_config.h.in for usage
configure_file(cligen_config.h.in cligen_config.h @ONLY)

# set a few variables required for build.c
string(TIMESTAMP _today "%Y.%m.%d %H:%M")
cmake_host_system_information(RESULT _host_name QUERY HOSTNAME)
set(CLIGEN_BUILDSTR "${_today} by $ENV{USER} on ${_host_name}")
string(LENGTH "${CLIGEN_BUILDSTR}" CLIGEN_BUILDSTR_LEN)

# now generate build.c
configure_file(build.c.in build.c @ONLY)

# start bison/flex section
message(STATUS "Looking for bison and flex:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# locate suitable bison and flex
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# end bison/flex section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# flex/bison targets, used in multiple places below
set(BISON_TARGET_NAME "cligen_parse")
set(FLEX_TARGET_NAME "lex_${BISON_TARGET_NAME}")

# declare the bison target
BISON_TARGET(${BISON_TARGET_NAME} "${BISON_TARGET_NAME}.y"
	"${CMAKE_CURRENT_BINARY_DIR}/${BISON_TARGET_NAME}.tab.c"
	COMPILE_FLAGS "-l -d -b ${BISON_TARGET_NAME} -p ${BISON_TARGET_NAME}"
	DEFINES_FILE "${CMAKE_CURRENT_BINARY_DIR}/${BISON_TARGET_NAME}.tab.h"
	)

# declare the flex target
FLEX_TARGET(${FLEX_TARGET_NAME} "${BISON_TARGET_NAME}.l"
	"${CMAKE_CURRENT_BINARY_DIR}/lex.${BISON_TARGET_NAME}.c"
	COMPILE_FLAGS "-P ${BISON_TARGET_NAME}"
	)

# add dependency between the scanner and parser
ADD_FLEX_BISON_DEPENDENCY(${FLEX_TARGET_NAME} ${BISON_TARGET_NAME})

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
	cligen_util.c
	)

# declare any required out-of-tree sources
set(LIB_SOURCES_GENERATED
	${CMAKE_CURRENT_BINARY_DIR}/build.c
	)

# declare all the required sources for building
set(LIB_SOURCES_ALL
	"${LIB_SOURCES}"
	"${LIB_SOURCES_GENERATED}"
	"${FLEX_${FLEX_TARGET_NAME}_OUTPUTS}"
	"${BISON_${BISON_TARGET_NAME}_OUTPUTS}"
	)

# declare cligen library build target
add_library(cligen "${LIB_SOURCES_ALL}")

# we need to conditionally link against libxml2 here
if(CLIGEN_USE_LIBXML2)
	target_link_libraries(cligen ${LIBXML2_LIBRARIES})
endif()

# set VERSION/SOVERSION to properly generate namelinks for shared library
# symlinks will be automatically created for both VERSION/SOVERSION names
set_target_properties(cligen PROPERTIES
	VERSION "${CLIGEN_VERSION_MAJOR}.${CLIGEN_VERSION_MINOR}"
	SOVERSION ${CLIGEN_VERSION_MAJOR}
	)
