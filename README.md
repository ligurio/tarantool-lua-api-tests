## Fuzzing Tarantool Lua API

Fuzzing tests for Tarantool built-in Lua modules -
https://www.tarantool.io/en/doc/latest/reference/reference_lua/

### Usage

Build Tarantool:

```sh
$ CFLAGS="-fsanitize=fuzzer-no-link" LDFLAGS="-fsanitize=fuzzer-no-link" CC=clang CXX=clang++ cmake -S . -B build -DENABLE_BUNDLED_LIBCURL=OFF -DCMAKE_BUILD_TYPE=Debug -DENABLE_ASAN=ON -DENABLE_BACKTRACE=OFF
$ cmake --build build --parallel
```

Run tests:

```sh
$ luarocks --local install luzer
$ git clone https://github.com/ligurio/tarantool-corpus tests/tarantool-corpus
$ LSAN_OPTIONS=suppressions=$(pwd)/asan/lsan.supp ASAN_OPTIONS=heap_profile=0:unmap_shadow_on_exit=1:print_suppressions=0 tarantool tarantool_csv.lua
```
