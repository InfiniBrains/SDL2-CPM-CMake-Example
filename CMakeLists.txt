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

CPMAddPackage(
        NAME SDL2
        VERSION 2.24.2
        URL "https://github.com/libsdl-org/SDL/archive/refs/tags/release-2.24.2.zip"
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

    MESSAGE(DEBUG "TOLSTAAAAAAAAAAAAAAAA")
    set (SDL2_INCLUDE_DIR ${SDL2_SOURCE_DIR}/include)
endif()

# add executable
add_executable(main main.cpp)
target_compile_features(main PRIVATE cxx_std_20)
include_directories(${SDL2_INCLUDE_DIR})
target_include_directories(main PRIVATE ${SDL2_INCLUDE_DIR})
target_link_libraries(main SDL2)