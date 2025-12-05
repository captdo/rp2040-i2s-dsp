# Hardware details

## Hardware Bill of Materials (BoM)

This section describes the reference hardware setup for the RP2040 bootloader + I²S/DSP platform. The goal is to define a concrete, reproducible baseline while still allowing equivalent substitutions.

### Required hardware

| Item                                 | Qty | Notes                                                                                                                   |
| ------------------------------------ | --- | ----------------------------------------------------------------------------------------------------------------------- |
| RP2040 development board             | 1   | Any RP2040 board with 3.3 V I/O. Reference build uses the **Raspberry Pi Pico** (non-W), with pre-soldered pin headers. |
| INMP441 I²S MEMS microphone breakout | 1   | INMP441-based breakout with pins: `VDD`, `GND`, `SCK`, `WS`, `SD`, `L/R`. Must be **3.3 V only** (no 5 V on `VDD`).     |
| Solderless breadboard                | 1   | Used as the reference prototyping medium for all wiring.                                                                |

### Recommended hardware (debugging)

| Item                     | Qty | Notes                                                                                                                                       |
| ------------------------ | --- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Second Raspberry Pi Pico | 1   | Used as a **Picoprobe** SWD debug probe for the target Pico. Connects to the target’s SWD pins (SWCLK, SWDIO, GND) and to the host via USB. |

---

### Example wiring: Pico ↔ INMP441

The project does **not** enforce a specific pinout, but the following mapping is used as the **reference example** and may be the default in firmware configuration:

| Function            | INMP441 pin | Pico pin (example) | Notes                                                                                           |
| ------------------- | ----------- | ------------------ | ----------------------------------------------------------------------------------------------- |
| Power               | `VDD`       | `3V3(OUT)`         | Mic is 3.3 V only; **do not power from 5 V**.                                                   |
| Ground              | `GND`       | `GND`              | Common ground between Pico and mic.                                                             |
| I²S bit clock (SCK) | `SCK`       | `GP10`             | Sometimes labelled **BCLK** on other breakouts.                                                 |
| I²S word select     | `WS`        | `GP11`             | Sometimes labelled **LRCLK**, **LRCL**, or **WS**.                                              |
| I²S data            | `SD`        | `GP12`             | I²S serial data into RP2040.                                                                    |
| Channel select      | `L/R`       | `GND` (example)    | Tie to **GND** for one channel (e.g. left). Tie to **3V3** for the opposite channel if desired. |

You are free to change the GPIO assignments as long as the firmware configuration (PIO program and pin constants) is updated accordingly.

### Electrical notes & assumptions

* **Voltage levels**

  * All digital signals between the Pico and the INMP441 are **3.3 V**.
  * No level shifting is used or required in the reference setup.
* **Passives**

  * No additional pull-ups, pull-downs, or series resistors are used on the I²S lines in the reference setup.
  * The design relies on decoupling already present on the Pico and on the INMP441 breakout.
* **Power**

  * The Pico is powered from its USB port (connected to the development host).
  * The INMP441 is powered directly from the Pico’s `3V3(OUT)` pin.
  * **Do not** connect the INMP441 `VDD` to any 5 V source.
