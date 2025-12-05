add_executable(bootloader 
    bootloader.c
    $<TARGET_OBJECTS:platform_runtime>
)

enable_compiler_warnings(bootloader)