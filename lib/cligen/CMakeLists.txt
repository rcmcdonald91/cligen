#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# declare public headers for installation and packaging purpsoses
set(PUBLIC_HEADERS
	cligen.h
	cligen_buf.h
	cligen_callback.h
	cligen_cv.h
	cligen_cvec.h
	cligen_expand.h
	cligen_getline.h
	cligen_handle.h
	cligen_history.h
	cligen_io.h
	cligen_match.h
	cligen_object.h
	cligen_parse.h
	cligen_parsetree.h
	cligen_print.h
	cligen_pt_head.h
	cligen_read.h
	cligen_regex.h
	cligen_result.h
	cligen_syntax.h
	cligen_util.h
	)

# prepend the correct absolute path to each header file
list(TRANSFORM PUBLIC_HEADERS PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

# set public headers for the installation/packaging phase
set_property(TARGET cligen PROPERTY PUBLIC_HEADER "${PUBLIC_HEADERS}")
