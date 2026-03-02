# Implementation Plan: Fix Coercion Error in Zsh Session Variables

## Phase 1: Diagnosis and Fix

### Task: Reproduce and Verify Error
- [ ] Task: Run `home-manager switch --dry-run` to confirm the error persists.

### Task: Apply Fix
- [ ] Task: Edit `modules/programs/zsh/default.nix` to remove `mkDefault` from `sessionVariables`.

### Task: Verification
- [ ] Task: Run `home-manager switch --dry-run` to ensure the fix works.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Diagnosis and Fix' (Protocol in workflow.md)
