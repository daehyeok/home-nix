# Implementation Plan: Replace eza with lsd

## Phase 1: Cleanup eza

- [x] Task: Remove `eza` related files and references.
    - [x] Delete `modules/programs/eza.nix`.
    - [x] Remove `./eza.nix` import from `modules/programs/default.nix`.
    - [x] Remove `eza.enable = true;` and the `tree` alias from `settings/default.nix`.

## Phase 2: Implement lsd

- [x] Task: Create and register the `lsd` module.
    - [x] Create `modules/programs/lsd.nix` with options for `enable`, `icons`, and `colors`.
    - [x] Add `./lsd.nix` to `modules/programs/default.nix`.
- [x] Task: Configure aliases and enablement.
    - [x] Update `settings/default.nix` to enable the `lsd` module.
    - [x] Define standard aliases (`ls`, `ll`, `tree`) within the `lsd.nix` module.

## Phase 3: Verification

- [x] Task: Verify the configuration.
    - [x] Check Nix syntax in modified files.
    - [x] Perform a dry-run build to ensure the configuration is valid.
- [x] Task: Conductor - User Manual Verification 'Replace eza with lsd' (Protocol in workflow.md)

## Phase: Review Fixes
- [x] Task: Apply review suggestions ee6a9d9
