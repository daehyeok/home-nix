# Implementation Plan: Replace eza with lsd

## Phase 1: Cleanup eza

- [ ] Task: Remove `eza` related files and references.
    - [ ] Delete `modules/programs/eza.nix`.
    - [ ] Remove `./eza.nix` import from `modules/programs/default.nix`.
    - [ ] Remove `eza.enable = true;` and the `tree` alias from `settings/default.nix`.

## Phase 2: Implement lsd

- [ ] Task: Create and register the `lsd` module.
    - [ ] Create `modules/programs/lsd.nix` with options for `enable`, `icons`, and `colors`.
    - [ ] Add `./lsd.nix` to `modules/programs/default.nix`.
- [ ] Task: Configure aliases and enablement.
    - [ ] Update `settings/default.nix` to enable the `lsd` module.
    - [ ] Define standard aliases (`ls`, `ll`, `tree`) within the `lsd.nix` module.

## Phase 3: Verification

- [ ] Task: Verify the configuration.
    - [ ] Check Nix syntax in modified files.
    - [ ] Perform a dry-run build to ensure the configuration is valid.
- [ ] Task: Conductor - User Manual Verification 'Replace eza with lsd' (Protocol in workflow.md)
