#!/usr/bin/env bash

# Dynamic cat wrapper for Gemini CLI compatibility
# If GEMINI_CLI is set to 1, use the standard cat command.
# Otherwise, use bat (with --plain to be safe as a cat replacement, or as configured).

if [[ "$GEMINI_CLI" == "1" ]]; then
    # Use the real cat. We use 'command cat' to avoid calling ourselves if aliased.
    exec command cat "$@"
else
    # Use bat.
    # The current configuration uses 'bat --plain'.
    exec bat --plain "$@"
fi
