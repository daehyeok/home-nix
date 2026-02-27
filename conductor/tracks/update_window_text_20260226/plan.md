# Implementation Plan: Update `window_text.sh` Logic

## Phase 1: Test Setup and Initial Script Update

- [ ] Task: Create a test suite for `window_text.sh`.
    - [ ] Create `modules/programs/tmux/test_window_text.py`.
    - [ ] Define test cases for existing behavior.
    - [ ] Define failing test cases for the new `zsh` path display.
- [ ] Task: Modify `window_text.sh` to handle the third argument.
    - [ ] Update the script to capture `pane_current_path` from `$3`.

## Phase 2: Implement Path Compression and Conditional Logic

- [ ] Task: Implement path compression logic in `window_text.sh`.
    - [ ] Add logic to replace `$HOME` with `~`.
    - [ ] Add logic to shorten path components.
- [ ] Task: Update display logic for `zsh`.
    - [ ] Check if `base_name` is `zsh` and use the compressed path if true.
- [ ] Task: Verify with tests.
    - [ ] Run the test suite and ensure all cases pass.
- [ ] Task: Conductor - User Manual Verification 'Implement Path Compression and Conditional Logic' (Protocol in workflow.md)

## Phase 3: Update Nix Configuration and Apply

- [ ] Task: Update `modules/programs/tmux/default.nix`.
    - [ ] Modify tmux settings to pass `#{pane_current_path}` to the script.
- [ ] Task: Verify the Nix configuration.
    - [ ] Perform a dry-run build to check for errors.
- [ ] Task: Conductor - User Manual Verification 'Update Nix Configuration and Apply' (Protocol in workflow.md)
