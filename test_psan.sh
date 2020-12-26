#!/bin/bash
rm tsan
clang++ -fsanitize=thread -g -O1 -o tsan tsan.cpp
./tsan