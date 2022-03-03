#
# Copyright (C) 2022 R. Christian McDonald <rcmcdonald91@gmail.com>
# Copyright (C) 2022 Rubicon Communications, LLC (Netgate)
#

# start build check section
message(STATUS "Performing build checks:")
list(APPEND CMAKE_MESSAGE_INDENT "  ")

# just walk down the tree
add_subdirectory(include)
add_subdirectory(src)

# end build check section
list(POP_BACK CMAKE_MESSAGE_INDENT)
