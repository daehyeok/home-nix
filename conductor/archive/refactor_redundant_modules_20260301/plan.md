# Implementation Plan: Refactor Redundant Program Modules

## Phase 1: Cleanup and Deletion [checkpoint: aee1837]
- [x] Task: Delete redundant program modules in `modules/programs/`.
    - [x] Delete `atuin.nix`, `bottom.nix`, `fd.nix`, `htop.nix`, `jq.nix`, `ripgrep.nix`, `tealdeer.nix`, `zellij.nix`, `zoxide.nix`.
- [x] Task: Update `modules/programs/default.nix` to reflect changes.
    - [x] Remove imports for the deleted modules.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Cleanup and Deletion' (Protocol in workflow.md) (aee1837)

## Phase 2: Verification
- [x] Task: Verify configuration and rebuild potential.
    - [x] Run `nix-instantiate --parse` on `home.nix` to check for syntax errors.
    - [x] Confirm that `settings/default.nix` still enables the required programs.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Verification' (Protocol in workflow.md) (aee1837)
