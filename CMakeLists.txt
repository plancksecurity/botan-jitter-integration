cmake_minimum_required(VERSION 3.29)

project(build_botan_jitter)

find_package(python REQUIRED COMPONENTS Interpreter)

cmake_host_system_information(RESULT THE_OS_NAME QUERY OS_NAME)

if(THE_OS_NAME EQUAL "Windows")
set(NINJA_BASE_EXE ninja.exe)
else()
set(NINJA_BASE_EXE ninja)
endif()

cmake_path(SET NINJA_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/ninja)
cmake_path(SET NINJA_EXE NORMALIZE ${CMAKE_CURRENT_BINARY_DIR}/${NINJA_BASE_EXE})
cmake_path(SET NINJA_CONFIGURE NORMALIZE ${NINJA_DIR}/configure.py)

cmake_path(SET JITTER_SRC NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/jitterentropy-library)

cmake_path(SET LOCAL_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/local)
set(PREFIX ${LOCAL_DIR})
cmake_path(SET BUILD_JITTER NORMALIZE ${LOCAL_DIR}/build_jitter)

add_custom_command(
    OUTPUT ${NINJA_EXE}
    COMMAND ${Python_EXECUTABLE} ${NINJA_CONFIGURE} --bootstrap
)

add_custom_command(
    OUTPUT ${LOCAL_DIR}/jitter/blarg
    COMMAND cmake -S ${JITTER_SRC} -B ${BUILD_JITTER}
    COMMAND cmake --build ${BUILD_JITTER}
    COMMAND cmake --install ${BUILD_JITTER} --prefix ${PREFIX}
)

add_custom_target(
    jitter-build
    DEPENDS
        ${NINJA_EXE}
        ${LOCAL_DIR}/jitter/blarg
)
