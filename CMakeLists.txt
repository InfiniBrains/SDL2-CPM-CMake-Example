cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# policies
if(COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
endif(COMMAND cmake_policy)

# create project
project(MyProject)

# set where the compiled files goes
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/libs)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/libs)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
LINK_DIRECTORIES(${CMAKE_BINARY_DIR}/libs)

# emscripten settings
IF(EMSCRIPTEN)
    message(STATUS "emscripten build")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Oz -s WASM=2 -s USE_SDL=0 -s USE_SDL_IMAGE=0 -s USE_SDL_MIXER=0 -s USE_SDL_TTF=0 -s ASYNCIFY")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Oz -s WASM=2 -s USE_SDL=0 -s USE_SDL_IMAGE=0 -s USE_SDL_MIXER=0 -s USE_SDL_TTF=0 -s ASYNCIFY")

    file(GLOB HTML "${CMAKE_CURRENT_SOURCE_DIR}/html/*")
    file(COPY ${HTML} DESTINATION ${CMAKE_BINARY_DIR}/bin/)
ENDIF()

# add dependencies
include(external/compilerchecks.cmake)
include(external/cpm.cmake)
include(external/sdl.cmake)
include(external/imgui.cmake)

# add executable
add_executable(demo main.cpp)

target_link_libraries(demo PUBLIC SDL2-static SDL2_image SDL2_mixer IMGUI)
