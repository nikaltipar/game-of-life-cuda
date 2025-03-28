cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
project(GameOfLife LANGUAGES CXX CUDA)

enable_testing()

set(CMAKE_CXX_STANDARD 23)

find_package(CLI11 CONFIG REQUIRED)
find_package(GTest CONFIG REQUIRED)

include_directories("include")

if(CMAKE_CUDA_COMPILER_ID STREQUAL "NVIDIA")
    set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} --extended-lambda")
endif()

add_subdirectory("src")
add_subdirectory("test")