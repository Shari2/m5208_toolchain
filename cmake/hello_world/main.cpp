// SPDX-FileCopyrightText: 2023 Marian Sauer
//
// SPDX-License-Identifier: BSD-2-Clause

#include <cstdio>
#include <format>

extern "C"
int getentropy(void *buffer, size_t length) {
    return -1;
}

int main()
{
  auto hello = std::format("{} {}!", "Hello", "world", "something");
  printf("%s\n", hello.c_str());
  return 0;
}
