SPDX-License-Identifier: BSD-2-Clause
SPDX-FileCopyrightText: Copyright (c) 2023 Marian Sauer

General:
The image is 2GB+ because of many static multilibs build by gcc.
I was not able to find a way to reduce the multilibs without patching gcc.

Setup image and container:
buildah build --tag m68k-elf-gcc-13.2.0 m68k-elf-gcc-13.2.0.dockerfile
buildah from --name m68k-elf-gcc-13.2.0-working-container m68k-elf-gcc-13.2.0

Build and run project in container:
buildah run -v $(realpath cmake/hello_world):/hello_world m68k-elf-gcc-13.2.0-working-container /bin/bash
cmake -Hhello_world -Bbuild -GNinja -DCMAKE_TOOLCHAIN_FILE=/hello_world/m5208evb_semihosted.cmake
ninja -C build/
/opt/m68k-qemu/bin/qemu-system-m68k -M mcf5208evb -semihosting -nographic -kernel build/main
