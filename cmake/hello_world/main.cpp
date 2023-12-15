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
  volatile float a = 1.5;
  volatile float b = 0.5;
  float version = a + b;
  auto hello = std::format("{} {} {:.2f}!", "Hello", "world", version);
  printf("%s\n", hello.c_str());
  return 0;
}
