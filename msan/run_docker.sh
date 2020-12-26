#!/bin/bash

# the absolute path of the directory assigned to the build
WORKSPACE=$(git rev-parse --show-toplevel)

build_memsanitizer() {
  docker build -t memsanitizer $WORKSPACE/msan
}

run_docker () {
  WORKDIR=$WORKSPACE/msan
  docker container rm memsanitizer-builder
  docker run \
    -it \
    --name memsanitizer-builder \
    --mount type=bind,source="$WORKDIR",target=$WORKDIR \
    memsanitizer:latest
}

# build_docker
# build_memsanitizer
run_docker

