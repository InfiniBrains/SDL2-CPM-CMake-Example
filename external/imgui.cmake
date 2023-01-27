#ImGui
string(TIMESTAMP BEFORE "%s")
CPMAddPackage(
        NAME IMGUI
        URL "https://github.com/ocornut/imgui/archive/refs/tags/v1.89.2.zip"
)
IF(IMGUI_ADDED)
    add_library(IMGUI STATIC)

    target_sources( IMGUI
            PRIVATE
            ${IMGUI_SOURCE_DIR}/imgui_demo.cpp
            ${IMGUI_SOURCE_DIR}/imgui_draw.cpp
            ${IMGUI_SOURCE_DIR}/imgui_tables.cpp
            ${IMGUI_SOURCE_DIR}/imgui_widgets.cpp
            ${IMGUI_SOURCE_DIR}/imgui.cpp

            PRIVATE
            ${IMGUI_SOURCE_DIR}/backends/imgui_impl_sdlrenderer.cpp
            ${IMGUI_SOURCE_DIR}/backends/imgui_impl_sdl.cpp
            ${IMGUI_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
            )
    target_include_directories( IMGUI
            PUBLIC ${IMGUI_SOURCE_DIR}
            PUBLIC ${IMGUI_SOURCE_DIR}/backends
            )
    find_package(OpenGL REQUIRED)
    if(EMSCRIPTEN)
        target_link_libraries(IMGUI PUBLIC ${OPENGL_gl_LIBRARY} SDL2 ${CMAKE_DL_LIBS})
    else()
        target_link_libraries(IMGUI PUBLIC ${OPENGL_gl_LIBRARY} SDL2-static ${CMAKE_DL_LIBS})
    endif()
ENDIF()
include_directories(${IMGUI_SOURCE_DIR} ${IMGUI_SOURCE_DIR}/backends)
string(TIMESTAMP AFTER "%s")
math(EXPR DELTAIMGUI "${AFTER} - ${BEFORE}")
MESSAGE(STATUS "IMGUI TIME: ${DELTAIMGUI}s")

