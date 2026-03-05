# Implementation Plan: Update Emacs-Editor Module

Update the `emacs-editor` module to consistently set the `EDITOR` environment variable and ensure correct editor selection in the `GEMINI` environment.

## Phase 1: Research and Red Phase [checkpoint: f715d61]
- [x] Task: Inspect current `emacs-editor` module at `modules/programs/emacs-editor/`
- [x] Task: Identify shell initialization files (e.g., `modules/programs/zsh/default.nix`) and how they handle environment variables
- [x] Task: Write a failing test or reproduction script that checks if `EDITOR` is set and if it defaults to `vi` in the `GEMINI` environment
- [x] Task: Conductor - User Manual Verification 'Phase 1: Research and Red Phase' (Protocol in workflow.md)

## Phase 2: Green Phase - Set EDITOR Variable [checkpoint: 331e602]
- [x] Task: Fix `initContent` aggregation in `modules/programs/zsh/default.nix`
- [x] Task: Update `modules/programs/zsh/emacs-editor.nix` to include `home.sessionVariables.EDITOR = "emacs-editor";` (Verify it's already there or update)
- [x] Task: Implement logic in the module to detect the `GEMINI` environment and ensure Emacs is prioritized
- [x] Task: Verify the failing test/script now passes
- [x] Task: Conductor - User Manual Verification 'Phase 2: Green Phase - Set EDITOR Variable' (Protocol in workflow.md)

## Phase 3: Green Phase - Shell Integration [checkpoint: 331e602]
- [x] Task: Update Zsh module (`modules/programs/zsh/default.nix`) to ensure it correctly sources/inherits the `EDITOR` variable from Home Manager session variables
- [x] Task: Test the integration by launching a new shell session
- [x] Task: Conductor - User Manual Verification 'Phase 3: Green Phase - Shell Integration' (Protocol in workflow.md)

## Phase 4: Refactor and Finalization
- [ ] Task: Refactor any redundant environment variable declarations
- [ ] Task: Ensure all changes follow project style guides
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Refactor and Finalization' (Protocol in workflow.md)
