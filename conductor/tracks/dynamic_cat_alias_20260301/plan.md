# Implementation Plan: Dynamic 'cat' Alias for Gemini CLI Compatibility

## Phase 1: Setup & Reproduce (Red Phase)
- [ ] Task: Create a reproduction/test script `modules/programs/test_cat_wrapper.py` to verify the desired behavior of the new `cat` logic.
- [ ] Task: Run the test and confirm it fails against the current system configuration.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Setup & Reproduce' (Protocol in workflow.md)

## Phase 2: Implementation (Green Phase)
- [ ] Task: Create a shell script `modules/programs/cat_wrapper.sh` that implements the conditional logic (use `bat` unless `GEMINI_CLI=1`).
- [ ] Task: Modify `modules/programs/bat.nix` to:
    - Include `cat_wrapper.sh` in the user's configuration.
    - Set up an alias or function that points `cat` to this wrapper.
- [ ] Task: Run the reproduction test and confirm it passes.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implementation' (Protocol in workflow.md)

## Phase 3: Finalize & Verification
- [ ] Task: Perform manual verification by setting `GEMINI_CLI=1` and checking the output of `cat`.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Finalize & Verification' (Protocol in workflow.md)
