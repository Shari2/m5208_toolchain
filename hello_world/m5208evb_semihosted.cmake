# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_C_COMPILER "/opt/m68k-elf/bin/m68k-elf-gcc")
set(CMAKE_CXX_COMPILER "/opt/m68k-elf/bin/m68k-elf-g++")

add_compile_options("-mcpu=5208")
add_link_options("-mcpu=5208" "-T" "m5208evb-ram-hosted.ld")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
