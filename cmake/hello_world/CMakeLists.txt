# SPDX-FileCopyrightText: 2023 Marian Sauer
#
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.22)
project(hello_world)

add_executable(main main.cpp)
set_property(TARGET main PROPERTY CXX_STANDARD 20)
