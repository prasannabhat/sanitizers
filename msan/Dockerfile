FROM ubuntu:focal as builder

RUN apt-get update
# https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
# Dependencies
RUN apt-get install -y \
	cmake \
	clang \
	git 
RUN apt-get install -y ninja-build
RUN git clone --depth=1 https://github.com/llvm/llvm-project 
RUN  cd llvm-project;mkdir build;cd build;cmake -GNinja ../llvm \
	-DCMAKE_BUILD_TYPE=Release \
	-DLLVM_ENABLE_PROJECTS="libcxx;libcxxabi" \
	-DCMAKE_C_COMPILER=clang \
	-DCMAKE_CXX_COMPILER=clang++ \
	-DLLVM_USE_SANITIZER=MemoryWithOrigins;cmake --build . -- cxx cxxabi

ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++


