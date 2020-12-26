#!/bin/bash
set -e
COMPILER=clang++

echo $(which llvm-symbolizer)
if [[ ! -f $(which llvm-symbolizer) ]]
then
    echo "WARNING : llvm-symbolizer not found. Stack trace may not be symbolized!"
fi

export UBSAN_OPTIONS=print_stacktrace=1
# compiler & link
# -fno-sanitize-recover : print error and exit program
$COMPILER -fsanitize=address -fsanitize=undefined -fsanitize=thread -fno-omit-frame-pointer -g ubsan.cpp utils/ubsan_lib.cpp -o ubsan
./ubsan
echo "Return code is $?"