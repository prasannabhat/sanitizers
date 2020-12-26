#!/bin/bash
set -e
# source ~/qnx700/qnxsdp-env.sh 
COMPILER=clang++
# Clean
# rm *.o sanitize
# Compile
# $COMPILER -O1 -g -fsanitize-blacklist=blacklist.txt -fsanitize=address -fno-omit-frame-pointer -c asan.cpp utils/sub_function.cpp
$COMPILER -O1 -g -fsanitize=address -fno-omit-frame-pointer -c asan.cpp utils/asan_lib.cpp
# Link
$COMPILER -g -fsanitize=address asan.o asan_lib.o -o sanitize
./sanitize