#!/usr/bin/env bash

set -euo pipefail

# Simple formatter runner. Default mode: in-place format.
# With --check: fail if any file is not properly formatted.

MODE="fix"
if [[ "${1-}" == "--check" ]]; then
    MODE="check"
fi

mapfile -t FILES < <(find firmware -type f \( -name '*.c' -o -name '*.h' \))
if (( ${#FILES[@]} == 0 )); then
    echo "No files to format"
    exit 0
fi

if [[ "$MODE" == "fix" ]]; then
    clang-format -i "${FILES[@]}"
else
    clang-format --dry-run --Werror "${FILES[@]}"
fi