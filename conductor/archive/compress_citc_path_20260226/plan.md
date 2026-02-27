# Implementation Plan: Compress CitC Workspace Path

## Phase 1: Test Setup for CitC Paths

- [x] Task: Add CitC test cases to `modules/programs/tmux/test_window_text.py`.
    - [x] Define test cases for standard CitC paths.
    - [x] Define test cases for deep CitC paths.
    - [x] Run tests to confirm failure (Red phase).

## Phase 2: Implement CitC Compression Logic [checkpoint: afbad7b]

- [x] Task: Update `compress_path` in `modules/programs/tmux/window_text.sh`.
    - [x] Add logic to identify CitC paths and extract workspace/dir_type.
    - [x] Implement the `({workspace}:{dir_type}) ... {cur_dir}` formatting.
- [x] Task: Verify with tests. (Manual verification successful)
    - [x] Run the test suite and ensure all cases pass (Green phase).
- [x] Task: Conductor - User Manual Verification 'Implement CitC Compression Logic' (Protocol in workflow.md)
