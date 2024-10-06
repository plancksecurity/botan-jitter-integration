cmake_minimum_required(VERSION 3.29)

project(build_botan_jitter)

find_package(python REQUIRED COMPONENTS Interpreter)

cmake_host_system_information(RESULT THE_OS_NAME QUERY OS_NAME)

if(THE_OS_NAME EQUAL "Windows")
set(JITTER_LIB_BASE jitterentropy.lib)
endif()

cmake_path(SET PREFIX_INCLUDE NORMALIZE ${LOCAL_DIR}/include)

# main jitter header file
cmake_path(SET JITTER_HEADER NORMALIZE ${PREFIX_INCLUDE}/jitterentropy.h)

cmake_path(SET JITTER_SRC NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/jitterentropy-library)

cmake_path(SET LOCAL_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/local)
set(PREFIX ${LOCAL_DIR})
cmake_path(SET BUILD_JITTER NORMALIZE ${LOCAL_DIR}/build_jitter)

add_custom_command(
    OUTPUT ${JITTER_HEADER}
    COMMAND cmake -S ${JITTER_SRC} -B ${BUILD_JITTER} -G Ninja -D INTERNAL_TIMER=OFF
    COMMAND cmake --build ${BUILD_JITTER}
    COMMAND cmake --install ${BUILD_JITTER} --prefix ${PREFIX}
)

add_custom_target(
    jitter-build
    DEPENDS
        ${JITTER_HEADER}
)
