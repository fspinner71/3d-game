cmake_minimum_required(VERSION 3.20)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
project(3dgame)

add_definitions(-DGLEW_STATIC)

include_directories(include)
include_directories(${OPENGL_INCLUDE_DIRS})

file(GLOB SOURCES ${CMAKE_SOURCE_DIR}/src/*.cpp)

# add_library(SDL3 SHARED IMPORTED)
# add_library(SDL3_image SHARED IMPORTED)
# add_library(SDL3_ttf SHARED IMPORTED)
# add_library(SDL3_mixer SHARED IMPORTED)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi-") # or remove /Zi

# Disable debug information generation during linking for Release executables
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG- /PDB:NONE") 

find_library(GLFW_PATH NAMES glfw3 HINTS ${CMAKE_SOURCE_DIR}/lib)
find_library(GLEW_PATH NAMES glew32s HINTS ${CMAKE_SOURCE_DIR}/lib)
find_package(OpenGL REQUIRED)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/bin")


add_executable(game ${SOURCES})

target_compile_options(game PRIVATE -w)
if(MSVW)
    target_compile_options(game PRIVATE /wd)
endif()

if (WIN32)

    message("WIN32 variable is TRUE, running Windows-specific commands.")

    add_custom_command(TARGET game POST_BUILD        
        COMMAND ${CMAKE_COMMAND} -E copy_if_different  
            "${PROJECT_SOURCE_DIR}/lib/glfw3.dll" 
            $<TARGET_FILE_DIR:game>)


else()
    # Commands or logic for other operating systems
    message("WIN32 variable is FALSE, running non-Windows specific commands.")
endif()

add_custom_target(copy_assets
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets ${CMAKE_CURRENT_BINARY_DIR}/bin/assets
)
add_dependencies(game copy_assets)

if(GLFW_PATH AND GLEW_PATH)
    target_link_libraries(game ${GLFW_PATH} ${OPENGL_LIBRARIES} ${GLEW_PATH})
else()
    message(FATAL_ERROR "Library not found!")
endif()