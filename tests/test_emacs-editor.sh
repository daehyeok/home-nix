#!/usr/bin/env bash
# Tests for modules/programs/emacs-editor, using the emacs/emacsclient stubs next to this file.
# Run from anywhere: bash tests/test_emacs-editor.sh

set -u

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$TESTS_DIR/../modules/programs/emacs-editor"

STUB_LOG_DIR="$(mktemp -d "${TMPDIR:-/tmp}/emacs-editor-test.XXXXXX")"
export STUB_LOG_DIR
trap 'rm -rf "$STUB_LOG_DIR"' EXIT
export PATH="$TESTS_DIR:$PATH"

fail() { echo "FAIL: $*"; exit 1; }

[[ -f "$SCRIPT_PATH" ]] || fail "script $SCRIPT_PATH not found"
[[ -x "$SCRIPT_PATH" ]] || fail "script $SCRIPT_PATH is not executable"
echo "PASS: script exists and is executable"

# Runs the script with stdin/stdout on a pseudo-terminal.
run_tty() {
  if [[ "$(uname)" == "Darwin" ]]; then
    script -q /dev/null "$SCRIPT_PATH" "$@" > /dev/null
  else
    script -qec "$(printf '%q ' "$SCRIPT_PATH" "$@")" /dev/null > /dev/null
  fi
}

# Runs the script with no terminal at all.
run_notty() {
  "$SCRIPT_PATH" "$@" < /dev/null > /dev/null 2>&1
}

# expect <name> <stub> <expected args>: checks which stub ran last and with what arguments.
expect() {
  local name="$1" stub="$2" want="$3" got other
  [[ "$stub" == emacs ]] && other=emacsclient || other=emacs
  [[ -f "$STUB_LOG_DIR/${stub}_args.log" ]] || fail "$name - $stub was not called"
  [[ ! -f "$STUB_LOG_DIR/${other}_args.log" ]] || fail "$name - $other was called unexpectedly"
  got="$(cat "$STUB_LOG_DIR/${stub}_args.log")"
  [[ "$got" == "$want" ]] || fail "$name - expected $stub '$want', got '$got'"
  echo "PASS: $name"
}

reset() {
  rm -f "$STUB_LOG_DIR"/*.log
  unset INSIDE_EMACS GEMINI_CLI
}

# 1. Server down: terminal fallback without init files.
reset; export EMACSCLIENT_TEST_RETURN=1
run_tty no-server.txt
expect "server down -> emacs -nw -q" emacs "-nw -q no-server.txt"

# 2. Server up, inside an Emacs terminal: open in the current server.
reset; export EMACSCLIENT_TEST_RETURN=0; export INSIDE_EMACS=vterm
run_tty test.txt
expect "INSIDE_EMACS -> emacsclient" emacsclient "test.txt"

# 3. Server up, plain terminal: edit in the terminal.
reset; export EMACSCLIENT_TEST_RETURN=0
run_tty other.file
expect "terminal -> emacsclient -nw" emacsclient "-nw other.file"

# 4. Server up, no terminal: new GUI frame.
reset; export EMACSCLIENT_TEST_RETURN=0
run_notty gui.txt
expect "no terminal -> emacsclient -c" emacsclient "-c gui.txt"

# 5. Option arguments go to the real emacs, whatever the server state.
reset; export EMACSCLIENT_TEST_RETURN=0
run_tty --version
expect "option arg -> real emacs" emacs "--version"
reset; export EMACSCLIENT_TEST_RETURN=0
run_tty -Q notes.txt
expect "option arg with file -> real emacs" emacs "-Q notes.txt"

# 6. +LINE is not an option: still goes through emacsclient.
reset; export EMACSCLIENT_TEST_RETURN=0
run_tty +10 notes.txt
expect "+LINE -> emacsclient -nw" emacsclient "-nw +10 notes.txt"

# 7. GEMINI_CLI changes nothing.
reset; export EMACSCLIENT_TEST_RETURN=0; export GEMINI_CLI=1
run_tty notes.txt
expect "GEMINI_CLI ignored" emacsclient "-nw notes.txt"

echo "All emacs-editor tests passed"
