cmake_minimum_required(VERSION 3.20)

project(pico_i2s_dsp_platform
    LANGUAGES C
)

include(cmake/compiler_warnings.cmake)

add_subdirectory(firmware)

add_custom_target(format
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/format.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running clang-format on all firmware source files"
)

add_custom_target(format-check
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/scripts/format.sh --check
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running clang-format check on all firmware source files"
)