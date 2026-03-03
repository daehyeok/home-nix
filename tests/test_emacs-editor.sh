#!/usr/bin/env bash

# Basic test to ensure the script exists and is executable

SCRIPT_PATH="/usr/local/google/home/daehyeok/.config/home-manager/common/modules/programs/emacs-editor"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "FAIL: Script $SCRIPT_PATH not found"
    exit 1
fi

if [ ! -x "$SCRIPT_PATH" ]; then
    echo "FAIL: Script $SCRIPT_PATH is not executable"
    exit 1
fi

echo "PASS: Script exists and is executable (initial check)"
exit 0
