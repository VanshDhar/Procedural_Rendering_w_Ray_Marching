cmake_minimum_required(VERSION 3.1)
set(CMAKE_CXX_STANDARD 11)

project(ray-marching)

file(GLOB_RECURSE ray-marching-source "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE ray-marching-headers "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h*")

add_executable(ray-marching ${ray-marching-source} ${ray-marching-headers} )
