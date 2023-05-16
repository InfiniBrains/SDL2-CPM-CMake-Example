if(NOT DEFINED EMSCRIPTEN)
    string(TIMESTAMP BEFORE "%s")

    CPMAddPackage(
        NAME glew
        URL https://github.com/nigels-com/glew/releases/download/glew-2.2.0/glew-2.2.0.tgz
        VERSION 2.2.0
        SOURCE_SUBDIR build/cmake
    )
    find_package(glew REQUIRED)
    message(STATUS "CPM_LAST_PACKAGE_NAME: " ${CPM_LAST_PACKAGE_NAME})

    set (glew_INCLUDE_DIR ${glew_SOURCE_DIR}/include)
    include_directories(${glew_INCLUDE_DIR})

    string(TIMESTAMP AFTER "%s")
    math(EXPR DELTAglew "${AFTER} - ${BEFORE}")
    MESSAGE(STATUS "glew TIME: ${DELTAglew}s")
endif()