#!/bin/sh

clang-format-mp-18 -i botan/src/lib/rng/jitter_rng/jitter*
clang-format-mp-18 -i botan/src/test/test_jitter_rng.cpp
