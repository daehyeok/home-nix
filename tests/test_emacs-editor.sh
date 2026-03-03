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

# --- Test emacsclient and INSIDE_EMACS check ---

TEST_PATH="$(pwd)/tests:$PATH"

# Test case 1: Server NOT running
export EMACSCLIENT_TEST_RETURN=1
unset INSIDE_EMACS
rm -f tests/emacs_args.log
PATH="$TEST_PATH" "$SCRIPT_PATH" no-server.txt
if [[ $? -ne 0 ]]; then
    echo "FAIL: Case 1 (Server NOT running) - script exited with $?"
    exit 1
fi
ARGS=$(cat tests/emacs_args.log)
if [[ "$ARGS" != "-q no-server.txt" ]]; then
    echo "FAIL: Case 1 - Expected args '-q no-server.txt', got '$ARGS'"
    exit 1
fi
echo "PASS: Case 1 - Server NOT running"

# Test case 2: Server running, INSIDE_EMACS set
export EMACSCLIENT_TEST_RETURN=0
export INSIDE_EMACS=t
rm -f tests/emacsclient_args.log
PATH="$TEST_PATH" "$SCRIPT_PATH" test.txt
if [[ $? -ne 0 ]]; then
    echo "FAIL: Case 2 (Server running, INSIDE_EMACS) - script exited with $?"
    exit 1
fi
ARGS=$(cat tests/emacsclient_args.log)
if [[ "$ARGS" != "test.txt" ]]; then
    echo "FAIL: Case 2 - Expected args 'test.txt', got '$ARGS'"
    exit 1
fi
echo "PASS: Case 2 - Server running, INSIDE_EMACS"

# Test case 3: Server running, INSIDE_EMACS NOT set
export EMACSCLIENT_TEST_RETURN=0
unset INSIDE_EMACS
rm -f tests/emacsclient_args.log
PATH="$TEST_PATH" "$SCRIPT_PATH" other.file
if [[ $? -ne 0 ]]; then
    echo "FAIL: Case 3 (Server running, NOT INSIDE_EMACS) - script exited with $?"
    exit 1
fi
ARGS=$(cat tests/emacsclient_args.log)
if [[ "$ARGS" != "-nw other.file" ]]; then
    echo "FAIL: Case 3 - Expected args '-nw other.file', got '$ARGS'"
    exit 1
fi
echo "PASS: Case 3 - Server running, NOT INSIDE_EMACS"

unset INSIDE_EMACS
unset EMACSCLIENT_TEST_RETURN

echo "All emacs-editor tests passed"
exit 0
