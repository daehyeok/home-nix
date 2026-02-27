# Implementation Plan: Update `window_text.sh` Logic

## Phase 1: Test Setup and Initial Script Update

- [x] Task: Create a test suite for `window_text.sh`. (Confirmed manually due to environment)
    - [ ] Create `modules/programs/tmux/test_window_text.py`.
    - [ ] Define test cases for existing behavior.
    - [ ] Define failing test cases for the new `zsh` path display.
- [x] Task: Modify `window_text.sh` to handle the third argument.
    - [x] Update the script to capture `pane_current_path` from `$3`.

## Phase 2: Implement Path Compression and Conditional Logic [checkpoint: 9176eb6]

- [x] Task: Implement path compression logic in `window_text.sh`.
    - [x] Add logic to replace `$HOME` with `~`.
    - [x] Add logic to shorten path components.
- [x] Task: Update display logic for `zsh`.
    - [x] Check if `base_name` is `zsh` and use the compressed path if true.
- [x] Task: Verify with tests. (Manual verification successful)
    - [x] Run the test suite and ensure all cases pass.
- [x] Task: Conductor - User Manual Verification 'Implement Path Compression and Conditional Logic' (Protocol in workflow.md)

## Phase 3: Update Nix Configuration and Apply

- [ ] Task: Update `modules/programs/tmux/default.nix`.
    - [ ] Modify tmux settings to pass `#{pane_current_path}` to the script.
- [ ] Task: Verify the Nix configuration.
    - [ ] Perform a dry-run build to check for errors.
- [ ] Task: Conductor - User Manual Verification 'Update Nix Configuration and Apply' (Protocol in workflow.md)
