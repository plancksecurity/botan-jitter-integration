rmdir -r build
rmdir -r local
rmdir -r botan\Makefile

cmake -S . -B build -G Ninja
cmake --build build -t botan-build
