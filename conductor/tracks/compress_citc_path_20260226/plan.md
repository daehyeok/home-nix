# Implementation Plan: Compress CitC Workspace Path

## Phase 1: Test Setup for CitC Paths

- [ ] Task: Add CitC test cases to `modules/programs/tmux/test_window_text.py`.
    - [ ] Define test cases for standard CitC paths.
    - [ ] Define test cases for deep CitC paths.
    - [ ] Run tests to confirm failure (Red phase).

## Phase 2: Implement CitC Compression Logic

- [ ] Task: Update `compress_path` in `modules/programs/tmux/window_text.sh`.
    - [ ] Add logic to identify CitC paths and extract workspace/dir_type.
    - [ ] Implement the `({workspace}:{dir_type}) ... {cur_dir}` formatting.
- [ ] Task: Verify with tests.
    - [ ] Run the test suite and ensure all cases pass (Green phase).
- [ ] Task: Conductor - User Manual Verification 'Implement CitC Compression Logic' (Protocol in workflow.md)
