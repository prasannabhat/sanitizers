cmake_minimum_required(VERSION 3.10)

# NOTE : This project builds in the specific docker container only!!!

# set the project name
project(msan)

set(SANITIZE ON)
set(SANITIZE_LIBS OFF)

if(SANITIZE)
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
    else()
        message( FATAL_ERROR "You need to run sanitize with gcc/clang compiler." )
    endif()
endif()

if(SANITIZE_LIBS)
# set(MSAN_CFLAGS "-fPIE -fsanitize=memory -stdlib=libc++ -L/llvm-project/build/lib -lc++abi -I/llvm-project/build/include/llvm -I/llvm-project/build/include/c++/v1")
# set(MSAN_CFLAGS "-fPIE -fsanitize=memory -stdlib=libc++  -I/llvm-project/build/include/llvm -I/llvm-project/build/include/c++/v1")
# link_directories(/llvm-project/build/lib)
endif(SANITIZE_LIBS)


################################ DOWNLOAD & BUILD GTEST #############################
# # Download and unpack googletest at configure time
# configure_file(cmake/googletest.cmake.in googletest-download/CMakeLists.txt)
# execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
#   RESULT_VARIABLE result
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
# if(result)
#   message(FATAL_ERROR "CMake step for googletest failed: ${result}")
# endif()
# execute_process(COMMAND ${CMAKE_COMMAND} --build .
#   RESULT_VARIABLE result
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/googletest-download )
# if(result)
#   message(FATAL_ERROR "Build step for googletest failed: ${result}")
# endif()

# # Prevent overriding the parent project's compiler/linker
# # settings on Windows
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# # Add googletest directly to our build. This defines
# # the gtest and gtest_main targets.
# add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/googletest-src
#                  ${CMAKE_CURRENT_BINARY_DIR}/googletest-build
#                  EXCLUDE_FROM_ALL)

# # The gtest/gtest_main targets carry header search path
# # dependencies automatically when using CMake 2.8.11 or
# # later. Otherwise we have to add them here ourselves.
# if (CMAKE_VERSION VERSION_LESS 2.8.11)
#   include_directories("${gtest_SOURCE_DIR}/include")
# endif()
#####################################################################################
message(STATUS "Sanitizer flags ${SANITIZER_FLAGS}")


# NOTE : Google test is pre-built in the specific path
set(GTEST_FLAGS -I/googletest/googletest/include)
# set(ADDITIONAL_FLAGS -Wno-error=unused-command-line-argument -fsanitize=memory -stdlib=libc++ -L/llvm-project/build/lib -lc++abi -I/llvm-project/build/include -I/llvm-project/build/include/c++/v1)
set(ADDITIONAL_FLAGS  -stdlib=libc++ -L/llvm-project/build/lib -lc++abi -I/llvm-project/build/include -I/llvm-project/build/include/c++/v1)
link_directories(/googletest/build/lib)

# add the executable
add_executable(msan msan.cpp)
target_compile_options(msan PRIVATE ${SANITIZER_FLAGS} ${GTEST_FLAGS} ${ADDITIONAL_FLAGS})
target_link_libraries(msan gtest ${SANITIZER_FLAGS} ${GTEST_FLAGS} ${ADDITIONAL_FLAGS} pthread)