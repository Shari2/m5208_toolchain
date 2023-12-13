# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

FROM ubuntu:latest AS ubuntu_with_cmake_ninja_qemudeps
RUN apt-get update && apt-get -y install cmake ninja-build glib-2.0 libpixman-1-0

FROM ubuntu_with_cmake_ninja_qemudeps AS ubuntu_with_all_prerequisites
RUN apt-get update && apt-get -y install build-essential  python-is-python3 python3-venv texinfo meson pkg-config glib-2.0 curl libpixman-1-dev
ADD cmake /cmake
RUN cmake -Hcmake -Bbuild -GNinja
RUN ninja -C build/ all

FROM ubuntu_with_cmake_ninja_qemudeps
COPY --from=ubuntu_with_all_prerequisites /opt /opt
