#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="${BUILD_DIR:-build}"
BUILD_TYPE="${BUILD_TYPE:-Debug}"
TOOLCHAIN_FILE="${TOOLCHAIN_FILE:-cmake/rp2040_gcc_toolchain.cmake}"

cmake -S . -B "$BUILD_DIR" -G Ninja \
  -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE"

cmake --build "$BUILD_DIR" -- -v