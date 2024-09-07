#!/bin/sh

clang-format-mp-17 -i botan/src/lib/rng/jitter_rng/jitter*
clang-format-mp-17 -i botan/src/tests/test_jitter_rng.cpp
