#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# start header file check section
message(STATUS "Looking for header files:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# Bring in required CMake modules
include(CheckIncludeFile)
include(CheckSymbolExists)

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
	"unistd.h")

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
message(STATUS "Looking for symbols:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# check these symbols
set(SYMBOLS_TO_CHECK
	strsep
	strverscmp)

# transform symbol names into HAVE_ variables
foreach(_symbol IN LISTS SYMBOLS_TO_CHECK)
	# convert symbol name to uppercase HAVE_ variable
	string(TOUPPER "HAVE_${_symbol}" _symbol_v)

	# now we check it and set the output HAVE_ variable
	CHECK_SYMBOL_EXISTS(${_symbol} "${HEADERS_TO_CHECK}" ${_symbol_v})
endforeach()

# end symbol check section
list(POP_BACK CMAKE_MESSAGE_INDENT)

# now generate cligen_config.h, see cligen_config.h.in for usage
configure_file(cligen_config.h.in cligen_config.h @ONLY)
