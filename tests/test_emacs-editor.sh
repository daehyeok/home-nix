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

# --- Test emacsclient check ---

TEST_PATH="$(pwd)/tests:$PATH"

# Test case: Server running
export EMACSCLIENT_TEST_RETURN=0
PATH="$TEST_PATH" "$SCRIPT_PATH"
if [[ $? -ne 0 ]]; then
    echo "FAIL: Server check (running) - script exited with $?"
    exit 1
fi
echo "PASS: Server check - Server running"

# Test case: Server not running
export EMACSCLIENT_TEST_RETURN=1
PATH="$TEST_PATH" "$SCRIPT_PATH"
if [[ $? -ne 1 ]]; then # Expecting server not running code path
    echo "FAIL: Server check (not running) - script exited with $?"
    exit 1
fi
echo "PASS: Server check - Server not running"

unset EMACSCLIENT_TEST_RETURN

echo "All emacsclient tests passed"
exit 0
