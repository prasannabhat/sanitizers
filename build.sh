#!/bin/bash

# Compile
clang++ -O1 -g -fsanitize-blacklist=lacklist.txt -fsanitize=address -fno-omit-frame-pointer -c example_UseAfterFree.cpp
# Link
clang++ -g -fsanitize=address example_UseAfterFree.o -o sanitize
./sanitize