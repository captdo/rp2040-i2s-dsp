# ADR-001: Toolchain, Standard Library and Early Runtime Strategy

**Status**  
Accepted

**Date**  
2025-12-05

---

## Context

This project targets the RP2040 MCU and is intentionally **bare-metal** (no Pico SDK).  
For the first milesone (M1: Project & Tooling), the primary goals are:

- Have a **reproducible cross-compile toolchain**.
- Make sure firmware (bootloader + demo app) **builds in CI** with strict warnings.
- Avoid committing to a final memory layout / boot strategy before the bootloader
  and application architecture are fully designed.

At this stage the firmware is effectively:

```c
int main(void) { return 0; }
```

There is no:

- Custom linker script for RP2040 flash/RAM.
- Startup/CRT code (vector table, Reset_Handler, data/bss init).
- Real I/O (UART, USB, filesystem, etc.).

However, the **GNU Arm Embedded toolchain** and newlib still expect:

- A proper **cross-compile configuration** (system name, compiler, CPU flags).
- A set of **syscall-like functions** (`_write`, `_read`, `_sbrk`, `_exit`, etc.)
  to resolve references in the C library.

We want CI to be meaningful (build with `arm-none-eabi-gcc`, use newlib), but we
do **not** want to prematurely design the full runtime and flash layout in M1-4.

## Decision

### 1. Toolchain

We use the **GNU Arm Embedded toolchain** as the primary toolchain:

- Compiler: `arm-none-eabi-gcc`
- Binutils: `arm-none-eabi-objcopy`, `arm-none-eabi-objdump`, etc.
- C library: **newlib** as packaged with the toolchain.

The toolchain is configured via a dedicated **CMake toolchain file**:

- Path: `cmake/rp2040_gcc_toolchain.cmake`
- Provided to CMake through `-DCMAKE_TOOLCHAIN_FILE=...`
- Responsible for:

  - Selecting `arm-none-eabi-gcc` as the C compiler.
  - Targeting `cortex-m0plus` with `-mcpu=cortex-m0plus -mthumb`.
  - Setting up basic compile flags appropriate for bare-metal.

This toolchain file is **not** responsible for project-level policies like warnings
or formatting; those are handled separately in project CMake modules and scripts.

### 2. Standard library

We link against **newlib** from the GNU Arm Embedded toolchain:

- This gives us a standard `libc` implementation and keeps us close to a
  realistic production setup.
- We deliberately **do not** enable full hosted features (no OS, no files, etc.).
- Newlib’s expectations of certain low-level functions are fulfilled by a custom
  runtime layer (see below).

Alternative options (e.g. completely freestanding with no `libc`, or a different
embedded C library) are deferred until there is a concrete need.

### 3. Early runtime: “fast track” with syscall stubs

For M1 we adopt a **fast-track runtime strategy**:

1. **No custom linker script or startup code yet**

   - We do not define a RP2040-specific linker script or startup assembly in this
     milestone.
   - The goal is to keep CI and build configuration simple while we focus on
     toolchain, warnings, and formatting.
   - As a consequence, the produced binaries are **not intended to run on real
     hardware yet**; they exist to validate the build pipeline.

2. **Minimal syscall stubs in a dedicated platform library**

   We introduce a **platform runtime library**:

   - Location: `firmware/libs/platform`
   - Target: `platform_runtime`
   - Current content: `src/syscalls.c`

   This library provides stub implementations for the small set of functions
   expected by newlib:

   - `_write`
   - `_read`
   - `_sbrk`
   - `_close`
   - `_lseek`
   - `_exit`

   Characteristics of these stubs:

   - They are deliberately minimal and typically:

     - Set `errno` to `ENOSYS` or `ENOMEM`.
     - Return `-1` or a failure value.
     - Spin forever in `_exit`.
   - They do **not** perform any real I/O or memory management.
   - They exist solely to allow `arm-none-eabi-gcc` + newlib to link the firmware
     during M1.

3. **Linking strategy**

   - All firmware targets (bootloader and demo) are linked against `platform_runtime`.
   - At this stage, these targets are only used to validate the cross-compile
     pipeline and warnings/formatting policies.

---

## Consequences

### Positive

- We can **cross-compile with the real GNU Arm Embedded toolchain** from day one.
- CI validates:
  - The CMake configuration and toolchain setup.
  - That both firmware targets build under `arm-none-eabi-gcc`.
- The project already has a well-defined place for **platform/runtime code**
  (`firmware/libs/platform`), which will be extended later with:

  - Startup code.
  - Vector table and reset handler.
  - RP2040-specific initialization (clocks, memory, etc.).
  - Real implementations of low-level I/O functions.

### Trade-offs / limitations

- The resulting firmware binaries are **not yet runnable** on RP2040 hardware.
  That is an explicit non-goal for M1-4.
- The `syscalls.c` stubs are **not suitable** as a final runtime:

  - They provide no actual I/O or memory management semantics.
  - Any use of stdio or dynamic allocation will immediately hit these limitations.
- The final runtime design (including linker scripts, startup, bootloader/app
  flash layout) is deferred to a later milestone and may require adjustments in
  this library.

---

## Alternatives considered

1. **Introduce full linker script and startup code in M1**

   Rejected for now. It would front-load complexity (vector table, memory layout,
   bootloader/app separation) into a milestone that is primarily about CI and
   toolchain setup.

2. **Avoid newlib entirely and build completely freestanding**

   Rejected for M1-4. While possible, this makes the environment less realistic
   and complicates future work that expects a `libc`. Using newlib now keeps us
   closer to a typical embedded C environment at the cost of a small syscall
   shim.

3. **Use the Pico SDK**

   Rejected by project goals. The intent is to implement hardware/bootloader and
   runtime “by hand” to better understand the RP2040 hardware and boot process.
