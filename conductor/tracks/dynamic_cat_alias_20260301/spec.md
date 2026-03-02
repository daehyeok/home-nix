# Specification: Dynamic 'cat' Alias for Gemini CLI Compatibility

## Overview
Currently, the `bat` module likely sets up a simple alias `cat = "bat"`. This can cause issues with tools like `gemini-cli` which might rely on the standard output format of the original `cat` program. This track will replace that simple alias with a dynamic shell wrapper or function that checks for the `GEMINI_CLI` environment variable.

## Functional Requirements
- **Conditional Execution:** When `cat` is invoked:
    - If `GEMINI_CLI=1` (or any value that evaluates to true), the original `cat` command should be executed.
    - Otherwise, the `bat` command should be executed.
- **Preserve Arguments:** All arguments passed to the `cat` command must be correctly forwarded to either the original `cat` or `bat`.
- **Integration:** The logic should be integrated into the existing `modules/programs/bat.nix` Home Manager module.

## Non-Functional Requirements
- **Performance:** The wrapper logic should introduce minimal overhead to command execution.
- **Portability:** The logic should be compatible with Zsh (the primary shell in this project).

## Acceptance Criteria
- [ ] Running `GEMINI_CLI=1 cat file.txt` executes the system `cat` command.
- [ ] Running `cat file.txt` (with `GEMINI_CLI` unset or not equal to 1) executes the `bat` command.
- [ ] The implementation is contained within `modules/programs/bat.nix`.
- [ ] All arguments (e.g., `cat -n file.txt`) are correctly passed through.

## Out of Scope
- Modifying other aliases or programs.
- Complex file type detection (beyond the requested environment variable check).
