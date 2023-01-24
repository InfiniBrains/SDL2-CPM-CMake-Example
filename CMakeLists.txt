cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# policies
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

# create project
project(MyProject)

# set where the compiled files goes
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# add dependencies
include(external/compilerchecks.cmake)
include(external/cpm.cmake)
include(external/sdl.cmake)
include(external/imgui.cmake)

# add executable
add_executable(main main.cpp)
target_link_libraries(main PRIVATE SDL2-static SDL2_ttf SDL2_image SDL2_mixer IMGUI)
