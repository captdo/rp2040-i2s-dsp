# Pico (RP2040) I²S DSP Platform

This repository contains a bare-metal firmware stack for the RP2040 (Raspberry Pi Pico)
that takes the chip from reset to real-time audio DSP using an I²S MEMS microphone.

The project is structured as a small “platform” rather than a single demo: it includes
a custom bootloader, a PIO-based I²S engine, DMA-driven audio capture, and a minimal
DSP layer (RMS/peak, basic filters), topped off with an end-to-end demo application.
All low-level work (bootloader, clocks, flash layout, PIO, DMA) is done without the
Pico SDK.

## Goals

- **Own the whole startup path**  
  Implement a custom bootloader that controls flash layout, image metadata, and the
  jump into the main application, plus a simple UART-based firmware update flow.

- **Build an I²S pipeline with PIO + DMA**  
  Use RP2040 PIO state machines to generate BCLK/LRCLK and sample the INMP441’s
  data line, then stream 32-bit frames into RAM via DMA and a small buffering layer.

- **Explore practical real-time DSP**  
  Convert raw I²S words into samples, compute basic metrics (RMS/peak), and add a
  simple filter to show meaningful audio processing on the microcontroller.

- **Serve as a learning reference**  
  Document design decisions with ADRs and architecture notes so the repository can
  serve as a study resource for bare-metal RP2040 work, PIO programming, and embedded audio.

The long-term vision is to have a clean, well-tested, and well-documented reference project
that’s suitable as a starting point for more advanced audio or signal-processing experiments
on the RP2040.
