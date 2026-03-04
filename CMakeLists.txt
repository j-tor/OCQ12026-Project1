cmake_minimum_required(VERSION 3.10)
project(MipsGraphicsBridge)

set(CMAKE_CXX_STANDARD 17)

# Find necessary packages for olcPixelGameEngine
find_package(OpenGL REQUIRED)
find_package(X11 REQUIRED)
find_package(PNG REQUIRED)

add_library(mips_display SHARED Main.cpp MipsDisplay.cpp)

target_include_directories(mips_display PRIVATE ${CMAKE_SOURCE_DIR})

target_link_libraries(mips_display
    PRIVATE
    ${OPENGL_LIBRARIES}
    ${X11_LIBRARIES}
    ${PNG_LIBRARIES}
)

# For Windows builds, olcPixelGameEngine needs GDI+
if(WIN32)
    target_link_libraries(mips_display PRIVATE gdiplus shlwapi dwmapi)
endif()
