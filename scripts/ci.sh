#!/usr/bin/env bash
set -euo pipefail

./scripts/build.sh
./scripts/format.sh --check