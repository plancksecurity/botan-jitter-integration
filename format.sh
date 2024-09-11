#!/bin/sh

./botan/src/scripts/dev_tools/run_clang_format.py \
    --clang-format=clang-format-17 \
    --src-dir=botan/src \
    --clang-format-binary clang-format-mp-17
