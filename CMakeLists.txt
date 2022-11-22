cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# CPM REGION
set(CPM_DOWNLOAD_VERSION 0.34.0)
if(CPM_SOURCE_CACHE)
    set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
    set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
    set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()
if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
    message(STATUS "Downloading CPM.cmake to ${CPM_DOWNLOAD_LOCATION}")
    file(DOWNLOAD
            https://github.com/TheLartians/CPM.cmake/releases/download/v${CPM_DOWNLOAD_VERSION}/CPM.cmake
            ${CPM_DOWNLOAD_LOCATION}
            )
endif()
include(${CPM_DOWNLOAD_LOCATION})

# create project
project(MyProject)

# set where the compiled files goes
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector-strong") # required for opus
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector-strong") # required for opus

# SDL
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL
        GIT_TAG main
        OPTIONS "SDL2_DISABLE_INSTALL TRUE")
if (SDL_ADDED)
    file(GLOB SDL_HEADERS "${SDL_SOURCE_DIR}/include/*.h")

    # Create a target that copies headers at build time, when they change
    add_custom_target(sdl_copy_headers_in_build_dir
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${SDL_SOURCE_DIR}/include" "${CMAKE_BINARY_DIR}/SDLHeaders/SDL2"
            DEPENDS ${SDL_HEADERS})

    # Make SDL depend from it
    add_dependencies(SDL2 sdl_copy_headers_in_build_dir)

    # And add the directory where headers have been copied as an interface include dir
    target_include_directories(SDL2 INTERFACE "${CMAKE_BINARY_DIR}/SDLHeaders")
    set (SDL2_INCLUDE_DIR ${SDL2_SOURCE_DIR}/include)
    MESSAGE(STATUS "SDL2_INCLUDE_DIR: ${SDL2_INCLUDE_DIR}")
    add_library(SDL2::SDL2 ALIAS SDL2)
endif()
find_package(SDL REQUIRED)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL2 TIME: ${DELTASDL}s")

# SDL_ttf
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_ttf
        GIT_TAG main
        OPTIONS "SDL2TTF_INSTALL FALSE" "SDL2TTF_VENDORED TRUE") # vendor is required for mingw builds
find_package(SDL_ttf REQUIRED)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_ttf "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_ttf TIME: ${DELTASDL_ttf}s")

# SDL_image
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_image
        GIT_TAG main
        OPTIONS "SDL2IMAGE_INSTALL FALSE")
find_package(SDL_image REQUIRED)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_image "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_image TIME: ${DELTASDL_image}s")

## SDL_mixer
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_mixer
        GIT_TAG main
        OPTIONS "SDL2IMIXER_INSTALL FALSE" "SDL2MIXER_VENDORED TRUE") # vendor is required for mingw builds
find_package(SDL_mixer REQUIRED)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_mixer "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_mixer TIME: ${DELTASDL_mixer}s")

# summary
MESSAGE(STATUS "######################### SUMMARY TIME #########################")
MESSAGE(STATUS "SDL2      TIME: ${DELTASDL}s")
MESSAGE(STATUS "SDL_ttf   TIME: ${DELTASDL_ttf}s")
MESSAGE(STATUS "SDL_image TIME: ${DELTASDL_image}s")
MESSAGE(STATUS "SDL_mixer TIME: ${DELTASDL_mixer}s")

# add executable
add_executable(main main.cpp)
include_directories(${SDL2_INCLUDE_DIR})
target_include_directories(main PRIVATE ${SDL2_INCLUDE_DIR})
target_link_libraries(main SDL2 SDL2_ttf SDL2_image SDL2_mixer)
