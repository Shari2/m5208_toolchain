# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.22)

set(PREFIX /opt/m68k-elf)
set(PREFIX_QEMU /opt/m68k-qemu)
set(TARGET m68k-elf)

include(ExternalProject)


ExternalProject_Add(binutils
  URL  https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz
  CONFIGURE_COMMAND "../binutils/configure" "--prefix=${PREFIX}" "--target=${TARGET}"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
)

ExternalProject_Add(gcc_no_newlib
  URL  https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz
  PATCH_COMMAND "../gcc_no_newlib/contrib/download_prerequisites"
  CONFIGURE_COMMAND "../gcc_no_newlib/configure"
  "--prefix=${PREFIX}"
  "--target=${TARGET}"
  "--enable-languages=c"
  "--disable-libssp"
  "--disable-nls"
  "--disable-threads"
  "--disable-libmudflap"
  "--disable-libgomp"
  "--disable-shared"
  "--disable-libquadmath"
  "--disable-libatomic"
  "--with-cpu=5208"
  "--with-newlib"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
  DEPENDS binutils
)

ExternalProject_Add(newlib
  URL  ftp://sourceware.org/pub/newlib/newlib-4.3.0.20230120.tar.gz
  CONFIGURE_COMMAND
  ${CMAKE_COMMAND} -E env "PATH=${PREFIX}/bin:$ENV{PATH}"
  "../newlib/configure"
  "--prefix=${PREFIX}"
  "--target=${TARGET}"
  "--enable-newlib-io-c99-formats"
  "--enable-newlib-io-long-double"
  "--enable-newlib-reent-small"
  "--disable-shared"
  "--enable-static"
  #"--enable-newlib-multithread"
  "--disable-newlib-mb"
  "--disable-newlib-atexit-alloc"
  "--enable-target-optspace"
  #"--enable-fast-install"
  BUILD_COMMAND
  ${CMAKE_COMMAND} -E env "PATH=${PREFIX}/bin:$ENV{PATH}"
  "make" "-j"
  INSTALL_COMMAND
  ${CMAKE_COMMAND} -E env "PATH=${PREFIX}/bin:$ENV{PATH}"
  "make" "install"
  DEPENDS gcc_no_newlib
)

ExternalProject_Get_property(gcc_no_newlib SOURCE_DIR)
ExternalProject_Add(g++_full
  DOWNLOAD_COMMAND "" # already got the source with gcc_no_newlib project
  SOURCE_DIR ${SOURCE_DIR}
  CONFIGURE_COMMAND "${SOURCE_DIR}/configure"
  "--prefix=${PREFIX}"
  "--target=${TARGET}"
  "--enable-languages=c,c++"
  "--disable-libssp"
  "--disable-nls"
  "--disable-threads"
  "--disable-libmudflap"
  "--disable-libgomp"
  "--disable-shared"
  "--disable-libquadmath"
  "--disable-libatomic"
  "--with-cpu=5208"
  "--with-newlib"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
  DEPENDS newlib
)

ExternalProject_Add(qemu
  URL  https://download.qemu.org/qemu-8.1.3.tar.xz
  PATCH_COMMAND "patch" -p 1 < "${CMAKE_CURRENT_LIST_DIR}/0001-Do-not-touch-my-stack-register.patch"
  CONFIGURE_COMMAND "../qemu/configure"
  "--prefix=${PREFIX_QEMU}"
  "--target-list=m68k-softmmu"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
)

ExternalProject_Add(hello_world
  SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/hello_world
  CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_CURRENT_LIST_DIR}/hello_world/m5208evb_semihosted.cmake
  BUILD_COMMAND  "ninja"
  INSTALL_COMMAND ""
  DEPENDS g++_full
)

project(m5208-cross-toolchain)

ExternalProject_Get_property(hello_world BINARY_DIR)
add_custom_target(run_hello_world
  COMMAND ${PREFIX_QEMU}/bin/qemu-system-m68k -M mcf5208evb -semihosting -nographic -kernel ${BINARY_DIR}/main
  DEPENDS hello_world
  DEPENDS qemu
)
