rmdir -r build
rmdir -r local
rmdir -r botan\Makefile
rmdir -r botan\build.ninja
rmdir -r botan\.ninja_deps

cmake -S . -B build -G Ninja
cmake --build build -t botan-build
