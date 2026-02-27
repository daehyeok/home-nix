# Implementation Plan: Refine CitC Path Compression

## Phase 1: Test Setup for Refined CitC Logic

- [x] Task: Add refined CitC test cases to `modules/programs/tmux/test_window_text.py`.
    - [x] Define test cases for special directories (`java`, `blaze-bin`).
    - [x] Define test cases for the `//` separator and compressed subpath.
    - [x] Run tests to confirm failure (Red phase).

## Phase 2: Implement Refined Logic [checkpoint: 152094a]

- [x] Task: Update `compress_path` in `modules/programs/tmux/window_text.sh`.
    - [x] Implement logic to detect special directory types.
    - [x] Implement `//` separator and subpath compression.
- [x] Task: Verify with tests. (Manual verification successful)
    - [x] Run the test suite and ensure all cases pass (Green phase).
- [x] Task: Conductor - User Manual Verification 'Implement Refined CitC Compression Logic' (Protocol in workflow.md)
