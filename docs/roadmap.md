# Roadmap

This project is organized into a series of milestones that build on each other:

1. **M1 – Project & Tooling**  
2. **M2 – Custom Bootloader**  
3. **M3 – PIO I²S Driver**  
4. **M4 – Audio Capture & Buffering**  
5. **M5 – Basic DSP**  
6. **M6 – Demo & Documentation**

Each milestone has a clear goal and a small set of issues that, when completed, move the project to the next stage.

---

## M1 – Project & Tooling

**Goal:** Establish a clean repository, toolchain, and documentation foundation.

**Focus areas:**

- Repo structure for `firmware/bootloader`, `firmware/demo`, `docs/`, `adr/`, `tools/`.
- GitHub issue templates and labels.
- Architecture and hardware documentation skeleton.
- CI pipeline (build checks), code formatting, warnings policy.
- Hardware bill of materials (BoM).

**Key outcomes:**

- You can clone the repo, configure the toolchain, and build both bootloader and app.
- CI builds run automatically on pushes/PRs.
- There is a clear place for ADRs, architecture notes, and hardware notes.
- BoM clearly lists required hardware and wiring basics.

---

## M2 – Custom Bootloader

**Goal:** Implement a custom bootloader with basic firmware update flow.

**Focus areas:**

- Flash layout and image metadata design (size, checksum, version, “valid” flag).
- Clear rules for who owns system clocks and basic init.
- Minimal bootloader that decides whether to boot the app or stay in “boot mode”.
- UART-based firmware update protocol + host-side uploader script in `/tools`.
- Shared logging abstraction usable by bootloader and app.

**Key outcomes:**

- On reset, the bootloader checks metadata and either:
  - Jumps into a valid application, or  
  - Stays in boot mode (e.g. for updates).
- You can update the application region over UART without reflashing the bootloader.
- Failed or partial updates do not brick the board (invalid metadata prevents jumping).
- Logs from bootloader and app are visible via a simple logging interface.

---

## M3 – PIO I²S Driver

**Goal:** Implement a PIO-based I²S engine that generates clocks and receives 32-bit frames.

**Focus areas:**

- ADR for I²S configuration: sample rate, BCLK ratio, bit depth, pin mapping.
- PIO SM for I²S clocks (BCLK + LRCLK).
- PIO SM for I²S RX (sampling SD, pushing 32-bit words).
- Verifying I²S timing with a logic analyzer or second Pico.
- Centralized configuration header (e.g. `audio_config.h`) for sample rates, buffer sizes, etc.

**Key outcomes:**

- BCLK and LRCLK waveforms on the pins match expected frequencies and ratios.
- RX PIO can capture 32-bit words synchronized to the I²S clocks.
- Audio/driver parameters are configured from one central place rather than scattered constants.

---

## M4 – Audio Capture & Buffering

**Goal:** Move I²S data into memory using DMA and a buffering layer.

**Focus areas:**

- PIO “fake microphone” (TX SM) that outputs a known test pattern.
- Software harness that verifies the pattern end-to-end via PIO RX.
- DMA from PIO RX FIFO into RAM (circular or double buffers).
- `i2s_driver` abstraction that hides PIO + DMA setup and provides buffer access APIs.
- Swapping the fake mic for the real INMP441 and validating basic signal behavior.

**Key outcomes:**

- End-to-end fake TX → PIO RX → DMA → buffer → software test passes reliably.
- `i2s_driver` exposes a clean interface for the rest of the system.
- With the real INMP441 wired in, captured values clearly react to sound (silence vs claps/voice).
- Buffer overruns and glaring timing issues are addressed.

---

## M5 – Basic DSP

**Goal:** Add a minimal DSP layer that turns raw audio into filtered signals.

**Focus areas:**

- Converting raw 32-bit I²S words into useful audio samples (int32/float) with correct scaling.
- RMS and peak level computation over configurable windows.
- Simple filter implementation (e.g. a low-pass or high-pass).
- Host-side DSP test harness to validate conversions, metrics, and filter behavior without flashing.

**Key outcomes:**

- You have well-defined sample conversion helpers used by the DSP code.
- RMS/peak values clearly distinguish silence vs loud input in real time.
- The filter behaves as expected (e.g. attenuates noise or certain frequency ranges).
- A set of host-side tests covers conversions, metrics, and filter impulse/step responses.

---

## M6 – Demo & Documentation

**Goal:** Deliver an end-to-end demo and documentation.

**Focus areas:**

- Final demo firmware:
  - Bootloader → app → I²S driver → DMA → DSP → visualization.
- Simple visualization of audio level:
  - Serial VU meter, LEDs, or other basic UI.
- Architecture overview and data-flow diagrams.
- Quickstart guide with wiring, build, flash, and run instructions.
- Repository polish: license, basic release tagging, final doc cleanup.

**Key outcomes:**

- Powering the board with the final firmware runs a stable audio demo that clearly responds to sound.
- A new user can:
  - Assemble the hardware,
  - Build and flash the firmware,
  - Run the demo,
  - And understand the architecture using only the README + docs.
- The repo has a clear license, a tagged “first demo” release, and coherent documentation, making it suitable as a portfolio reference and learning resource.

---

## High-Level Timeline

1. **M1** - define structure, implement CI, and set up docs in place.
2. **M2** - implement the bootloader and update flow.
3. **M3** - implement I²S clocks and RX via PIO.
4. **M4** - implement DMA buffered data streams and integrate the real mic.
5. **M5** - implement DSP layer and host-side tests.
6. **M6** - implement demo and finalize documentation.
