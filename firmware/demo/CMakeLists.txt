add_executable(demo 
    demo_main.c
    $<TARGET_OBJECTS:platform_runtime>
)
