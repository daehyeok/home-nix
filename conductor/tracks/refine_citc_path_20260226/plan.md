# Implementation Plan: Refine CitC Path Compression

## Phase 1: Test Setup for Refined CitC Logic

- [ ] Task: Add refined CitC test cases to `modules/programs/tmux/test_window_text.py`.
    - [ ] Define test cases for special directories (`java`, `blaze-bin`).
    - [ ] Define test cases for the `//` separator and compressed subpath.
    - [ ] Run tests to confirm failure (Red phase).

## Phase 2: Implement Refined Logic

- [ ] Task: Update `compress_path` in `modules/programs/tmux/window_text.sh`.
    - [ ] Implement logic to detect special directory types.
    - [ ] Implement `//` separator and subpath compression.
- [ ] Task: Verify with tests.
    - [ ] Run the test suite and ensure all cases pass (Green phase).
- [ ] Task: Conductor - User Manual Verification 'Implement Refined CitC Compression Logic' (Protocol in workflow.md)
