# Firmware architecture

## Toolchain, C library and early runtime

Toolchain and runtime decisions are described in detail in
[ADR-001: Toolchain, Standard Library and Early Runtime Strategy](../adr/ADR-001-toolchain-runtime.md).
This section provides a short operational overview.

### Cross-compile toolchain

- Firmware is cross-compiled with the **GNU Arm Embedded toolchain**
  (`arm-none-eabi-gcc`, binutils, newlib).
- CMake is configured with a dedicated toolchain file:
  `cmake/rp2040_gcc_toolchain.cmake`, passed via `CMAKE_TOOLCHAIN_FILE`.
- All firmware targets (bootloader + demo) are built via the shared script `./scripts/build.sh` which is also used in CI.

### Platform runtime library

To allow linking with newlib before a full RP2040 runtime (linker script +
startup code) is implemented, we use a small platform runtime library:

- Location: `firmware/libs/platform`
- Target: `platform_runtime`
- Current responsibility:

  - Provide minimal syscall stubs in `src/syscalls.c` so that newlib can link.

These stubs:

- Are intentionally minimal and mostly return failure / set `errno`.
- Do **not** perform real I/O or memory management.
- Exist to support early milestones where firmware is essentially
  placeholder code and the focus is on toolchain + CI.

The library is linked into all firmware executables and will be extended in later
milestones with:

- Startup code and vector table.
- RP2040-specific initialization.
- Real low-level I/O implementations.

For the rationale behind this “fast-track runtime” approach and its trade-offs,
see [ADR-001](../adr/ADR-001-toolchain-runtime.md).

## Bootloader

## PIO I²S

## DMA & Buffering

## DSP

## Demo
