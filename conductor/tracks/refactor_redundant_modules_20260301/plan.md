# Implementation Plan: Refactor Redundant Program Modules

## Phase 1: Cleanup and Deletion
- [ ] Task: Delete redundant program modules in `modules/programs/`.
    - [ ] Delete `atuin.nix`, `bottom.nix`, `fd.nix`, `htop.nix`, `jq.nix`, `ripgrep.nix`, `tealdeer.nix`, `zellij.nix`, `zoxide.nix`.
- [ ] Task: Update `modules/programs/default.nix` to reflect changes.
    - [ ] Remove imports for the deleted modules.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Cleanup and Deletion' (Protocol in workflow.md)

## Phase 2: Verification
- [ ] Task: Verify configuration and rebuild potential.
    - [ ] Run `nix-instantiate --parse` on `home.nix` to check for syntax errors.
    - [ ] Confirm that `settings/default.nix` still enables the required programs.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Verification' (Protocol in workflow.md)
