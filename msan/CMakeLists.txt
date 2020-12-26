cmake_minimum_required(VERSION 3.10)

# set the project name
project(msan)

# set(MSAN_CFLAGS "-fPIE -fsanitize=memory -stdlib=libc++ -L/llvm-project/build/lib -lc++abi -I/llvm-project/build/include/llvm -I/llvm-project/build/include/c++/v1")
set(MSAN_CFLAGS "-fPIE -fsanitize=memory -stdlib=libc++  -I/llvm-project/build/include/llvm -I/llvm-project/build/include/c++/v1")

set(CMAKE_CXX_FLAGS  ${MSAN_CFLAGS})
set(CMAKE_C_FLAGS ${MSAN_CFLAGS})

link_directories(/llvm-project/build/lib)

set(SANITIZE ON)

if(SANITIZE)
    # set(SANITIZER_BLACKLIST_FILE ${CMAKE_BINARY_DIR}/sanitizer_blacklist/asan_compile_time.txt)

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
        set(SANITIZER_COMMON_FLAGS -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -O2)
        
        # For using LeakSanitizer in standalone mode
        # https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer#stand-alone-mode
        # Using this mode was a bit unstable
        set(LEAK_SANITIZER_FLAGS -fsanitize=leak)

        set(ADDRESS_SANITIZER_FLAGS -fsanitize=address -fsanitize-address-use-after-scope ${SANITIZER_BLACKLIST})
        set(MEMORY_SANITIZER_FLAGS -fsanitize=memory -fPIE)

        # Combine different sanitizer flags to define overall sanitization
        set(SANITIZER_FLAGS ${SANITIZER_COMMON_FLAGS} ${MEMORY_SANITIZER_FLAGS})

        # unset local variables , to avoid polluting global space
        unset(SANITIZER_BLACKLIST)
        unset(SANITIZER_COMMON_FLAGS)
        unset(ADDRESS_SANITIZER_FLAGS)
    else()
        message( FATAL_ERROR "You need to run sanitize with gcc/clang compiler." )
    endif()
endif()

set(GTEST_COMPILE_FLAGS -fPIE)
set(GTEST_CMAKE_ARGS -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_FLAGS='${GTEST_COMPILE_FLAGS}' -DCMAKE_CXX_FLAGS='${GTEST_COMPILE_FLAGS}')

# Download and unpack googletest at configure time
configure_file(cmake/googletest.cmake.in googletest-download/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
if(result)
  message(FATAL_ERROR "CMake step for googletest failed: ${result}")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build .
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
if(result)
  message(FATAL_ERROR "Build step for googletest failed: ${result}")
endif()

# Prevent overriding the parent project's compiler/linker
# settings on Windows
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Add googletest directly to our build. This defines
# the gtest and gtest_main targets.
add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/googletest-src
                 ${CMAKE_CURRENT_BINARY_DIR}/googletest-build
                 EXCLUDE_FROM_ALL)

# The gtest/gtest_main targets carry header search path
# dependencies automatically when using CMake 2.8.11 or
# later. Otherwise we have to add them here ourselves.
if (CMAKE_VERSION VERSION_LESS 2.8.11)
  include_directories("${gtest_SOURCE_DIR}/include")
endif()



# add the executable
add_executable(msan msan.cpp)
target_compile_options(msan PRIVATE ${SANITIZER_FLAGS})
target_link_libraries(msan gtest ${SANITIZER_FLAGS})