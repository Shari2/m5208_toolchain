# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.28)

set(PREFIX /opt/m68k-elf)
set(TARGET m68k-elf)

include(ExternalProject)
ExternalProject_Add(binutils
  URL  https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.xz
  CONFIGURE_COMMAND "../binutils/configure" "--prefix=${PREFIX}" "--target=${TARGET}"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
)

include(ExternalProject)
ExternalProject_Add(gcc_no_newlib
  URL  https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz
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
  "--with-cpu=68000"
  "--with-newlib"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
)

include(ExternalProject)
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
)

include(ExternalProject)
ExternalProject_Add(g++_full
  URL  https://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.xz
  CONFIGURE_COMMAND "../g++_full/configure"
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
  "--with-cpu=68000"
  "--with-newlib"
  BUILD_COMMAND  "make" "-j"
  INSTALL_COMMAND "make" "install"
)

project(m5208-cross-toolchain)
