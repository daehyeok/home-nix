# Implementation Plan: Fix Build Problem (Invalid Git Configuration Nesting)

Correct the nesting of the `git` configuration in `home.nix` to restore a successful build.

## Phase 1: Fix Implementation
- [x] Task: Refactor `home.nix` to move `git` settings out of the `programs.zsh` block and into a dedicated `programs.git` (or shared `programs`) block. 7a82150
- [x] Task: Ensure all `programs.zsh` specific settings (like `initContent`) remain correctly positioned. 7a82150

## Phase 2: Verification
- [x] Task: Run `home-manager switch --dry-run` to confirm the configuration error is resolved and the build completes successfully. 94e24a4
- [x] Task: Conductor - User Manual Verification 'Phase 2: Verification' (Protocol in workflow.md) [checkpoint: 94e24a4]
