#!/bin/bash
set -e
# Compile
clang++ -O1 -g -fsanitize-blacklist=blacklist.txt -fsanitize=address -fno-omit-frame-pointer -c example_UseAfterFree.cpp utils/sub_function.cpp
# Link
clang++ -g -fsanitize=address example_UseAfterFree.o sub_function.o -o sanitize
./sanitize