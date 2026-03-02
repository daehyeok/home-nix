# Implementation Plan: Dynamic 'cat' Alias for Gemini CLI Compatibility

## Phase 1: Setup & Reproduce (Red Phase) [checkpoint: b2fb361]
- [x] Task: Create a reproduction/test script `modules/programs/test_cat_wrapper.py` to verify the desired behavior of the new `cat` logic. (470e8e8)
- [x] Task: Run the test and confirm it fails against the current system configuration. (b2fb361)
- [x] Task: Conductor - User Manual Verification 'Phase 1: Setup & Reproduce' (Protocol in workflow.md) (b2fb361)

## Phase 2: Implementation (Green Phase) [checkpoint: 22b8bae]
- [x] Task: Create a shell script `modules/programs/cat_wrapper.sh` that implements the conditional logic (use `bat` unless `GEMINI_CLI=1`). (69e25ed)
- [x] Task: Modify `modules/programs/bat.nix` to:
    - Include `cat_wrapper.sh` in the user's configuration.
    - Set up an alias or function that points `cat` to this wrapper. (22b8bae)
- [x] Task: Run the reproduction test and confirm it passes. (22b8bae)
- [x] Task: Conductor - User Manual Verification 'Phase 2: Implementation' (Protocol in workflow.md) (22b8bae)

## Phase 3: Finalize & Verification [checkpoint: 4b41c76]
- [x] Task: Perform manual verification by setting `GEMINI_CLI=1` and checking the output of `cat`. (4b41c76)
- [x] Task: Conductor - User Manual Verification 'Phase 3: Finalize & Verification' (Protocol in workflow.md) (4b41c76)
