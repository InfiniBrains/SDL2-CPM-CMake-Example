IF(NOT DEFINED EMSCRIPTEN)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector-strong") # required for opus
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fstack-protector-strong") # required for opus

#    set(SDL_SHARED ON CACHE BOOL "SDL_SHARED" FORCE)
#    SET(SDL_STATIC ON CACHE BOOL "SDL_STATIC")
#    SET(SDL_STATIC_PIC ON CACHE BOOL "SDL_STATIC_PIC")
#    SET(INTERFACE_SDL2_SHARED OFF CACHE BOOL "INTERFACE_SDL2_SHARED" FORCE)
#    SET(SDL_WERROR OFF CACHE BOOL "Enable -Werror on SDL. flag SDL_WERROR" FORCE)
ENDIF()

set(SDL2IMAGE_INSTALL OFF CACHE BOOL "" FORCE)
set(SDL2TTF_INSTALL OFF CACHE BOOL "" FORCE)
set(SDL2NET_INSTALL OFF CACHE BOOL "" FORCE)
set(SDL2IMAGE_SAMPLES OFF CACHE BOOL "" FORCE)
set(SDL2NET_SAMPLES OFF CACHE BOOL "" FORCE)
set(SDL2TTF_SAMPLES OFF CACHE BOOL "" FORCE)
set(SDL2MIXER_SAMPLES OFF CACHE BOOL "" FORCE)
set(SDL2TTF_VENDORED ON CACHE BOOL "" FORCE)

IF(NOT DEFINED EMSCRIPTEN)
# SDL2
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(
        NAME SDL2
        GITHUB_REPOSITORY libsdl-org/SDL
        GIT_TAG release-2.26.0
        OPTIONS "SDL2_DISABLE_INSTALL TRUE"
)
find_package(SDL2 REQUIRED)
if (SDL2_ADDED)
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
endif()
include_directories(${SDL2_INCLUDE_DIR})
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL2 TIME: ${DELTASDL}s")


# SDL_ttf
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_ttf
        GIT_TAG release-2.20.1
        OPTIONS "SDL2TTF_INSTALL FALSE" "SDL2TTF_VENDORED TRUE") # vendor is required for mingw builds
find_package(SDL_ttf REQUIRED)
include_directories(${SDL_ttf_SOURCE_DIR})
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_ttf "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_ttf TIME: ${DELTASDL_ttf}s")

# SDL_image
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_image
        GIT_TAG release-2.6.2
        OPTIONS "SDL2IMAGE_INSTALL FALSE")
find_package(SDL_image REQUIRED)
include_directories(${SDL_image_SOURCE_DIR})
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_image "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_image TIME: ${DELTASDL_image}s")


## SDL_mixer
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(GITHUB_REPOSITORY libsdl-org/SDL_mixer
        GIT_TAG release-2.6.2
        OPTIONS "SDL2IMIXER_INSTALL FALSE" "SDL2MIXER_VENDORED TRUE") # vendor is required for mingw builds
find_package(SDL_mixer REQUIRED)
include_directories(${SDL_mixer_SOURCE_DIR}/include)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTASDL_mixer "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "SDL_mixer TIME: ${DELTASDL_mixer}s")
endif()

