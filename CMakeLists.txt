cmake_minimum_required(VERSION 3.29)

project(build_botan_jitter)

find_package(python REQUIRED COMPONENTS Interpreter)

cmake_path(SET JITTER_SRC NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/jitterentropy-library)

cmake_path(SET LOCAL_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/local)
set(PREFIX ${LOCAL_DIR})
cmake_path(SET BUILD_JITTER NORMALIZE ${LOCAL_DIR}/build_jitter)

add_custom_command(
    OUTPUT ${LOCAL_DIR}/jitter/blarg
    COMMAND cmake -S ${JITTER_SRC} -B ${BUILD_JITTER}
    COMMAND cmake --build ${BUILD_JITTER}
    COMMAND cmake --install ${BUILD_JITTER} --prefix ${PREFIX}
)

add_custom_target(
    jitter-build
    DEPENDS
        ${LOCAL_DIR}/jitter/blarg
)
