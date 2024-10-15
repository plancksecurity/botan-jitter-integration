cmake_minimum_required(VERSION 3.29)

project(build_botan_jitter)

cmake_path(SET LOCAL_DIR NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/local)
set(PREFIX ${LOCAL_DIR})
cmake_path(SET BUILD_JITTER NORMALIZE ${LOCAL_DIR}/build_jitter)

find_package(python REQUIRED COMPONENTS Interpreter)

cmake_host_system_information(RESULT THE_OS_NAME QUERY OS_NAME)

if(${THE_OS_NAME} STREQUAL "Windows")
set(JITTER_LIB_BASE jitterentropy.lib)
set(BOTAN_LIB_BASE botan-3.lib)
endif()

cmake_path(SET PREFIX_INCLUDE NORMALIZE ${LOCAL_DIR}/include)
cmake_path(SET PREFIX_LIB NORMALIZE ${LOCAL_DIR}/lib)

# main jitter header file
cmake_path(SET JITTER_HEADER NORMALIZE ${PREFIX_INCLUDE}/jitterentropy.h)

# Botan library artifact
cmake_path(SET BOTAN_LIB NORMALIZE ${PREFIX_LIB}/${BOTAN_LIB_BASE})

cmake_path(SET JITTER_SRC NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/jitterentropy-library)
cmake_path(SET BOTAN_SRC NORMALIZE ${CMAKE_CURRENT_SOURCE_DIR}/botan)
cmake_path(SET BOTAN_CONFIGURE NORMALIZE ${BOTAN_SRC}/configure.py)

add_custom_command(
    OUTPUT ${JITTER_HEADER}
    COMMAND cmake -S ${JITTER_SRC} -B ${BUILD_JITTER} -G Ninja -D INTERNAL_TIMER=OFF
    COMMAND cmake --build ${BUILD_JITTER}
    COMMAND cmake --install ${BUILD_JITTER} --prefix ${PREFIX}
)

add_custom_command(
    OUTPUT ${BOTAN_LIB}
    WORKING_DIRECTORY ${BOTAN_SRC}
    COMMAND
        ${Python_EXECUTABLE}
            ${BOTAN_CONFIGURE}
            --build-tool=ninja
            --cc=msvc
            --os=windows
            --prefix=${PREFIX}
    COMMAND ninja
    COMMAND ninja install
)

add_custom_target(
    jitter-build
    DEPENDS
        ${JITTER_HEADER}
)

add_custom_target(
    botan-build
    DEPENDS
        ${BOTAN_LIB}
)
