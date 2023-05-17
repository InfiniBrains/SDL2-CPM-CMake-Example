if(NOT DEFINED EMSCRIPTEN)
    string(TIMESTAMP BEFORE "%s")

    CPMAddPackage(
        NAME "glew"
        URL "https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz"
        SOURCE_SUBDIR "build/cmake"
        OPTIONS "BUILD_SHARED_LIBS OFF" "BUILD_UTILS OFF" "BUILD_32_BIT OFF" "BUILD_SINGLE_CONTEXT OFF" "GLEW_USE_STATIC_LIBS ON"
    )

    find_package(glew REQUIRED)

    set (glew_INCLUDE_DIR ${glew_SOURCE_DIR}/include)
    include_directories(${glew_INCLUDE_DIR})

    string(TIMESTAMP AFTER "%s")
    math(EXPR DELTAglew "${AFTER} - ${BEFORE}")
    MESSAGE(STATUS "glew TIME: ${DELTAglew}s")
endif()