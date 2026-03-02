# Implementation Plan: Fix Coercion Error in Zsh Session Variables

## Phase 1: Diagnosis and Fix [checkpoint: b7384ad]

### Task: Reproduce and Verify Error
- [x] Task: Run `home-manager switch --dry-run` to confirm the error persists. (Reproduced)

### Task: Apply Fix
- [x] Task: Edit `modules/programs/zsh/default.nix` to remove `mkDefault` from `sessionVariables`. (0b533a5)

### Task: Resolve Starship Config Conflict
- [x] Task: Edit `modules/programs/starship/default.nix` to use `mkForce` for `format` to resolve catppuccin conflict. (0b533a5)

### Task: Verification
- [x] Task: Run `home-manager switch --dry-run` to ensure the fix works. (0b533a5)
- [x] Task: Conductor - User Manual Verification 'Phase 1: Diagnosis and Fix' (Protocol in workflow.md) (b7384ad)
