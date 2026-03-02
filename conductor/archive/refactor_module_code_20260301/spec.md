# Specification: Refactor Nix Modules for Simplified Program Configuration

## Overview
Refactor the core Nix modules in `modules/` to simplify the configuration experience in `home.nix`. The primary goal is to eliminate the need for redundant `enable` flags (e.g., needing both `module.<name>.enable` and `programs.<name>.enable`) by having modules enable their respective programs by default when included.

## Functional Requirements
- **Automatic Enablement:** Modules should enable their respective programs by default (`programs.<name>.enable = true`).
- **Inheritance & Overwriting:** Users should still be able to override default values in `home.nix`.
- **Modular Organization:** Ensure that core modules remain clean and readable after the refactor.
- **Consistent Interface:** Apply this pattern consistently across all modules in `modules/programs/`.

## Non-Functional Requirements
- **Simplicity:** Minimize boilerplate in `home.nix`.
- **Readability:** Improve the clarity of the module definitions and their usage.
- **Maintainability:** Ensure the refactored structure is easy to extend for new programs.

## Acceptance Criteria
- [ ] Refactor all modules in `modules/programs/` to enable their corresponding `programs.<name>` by default.
- [ ] Update `modules/default.nix` and `home.nix` as needed to support the new simplified configuration.
- [ ] Verify that programs are correctly enabled without explicit `programs.<name>.enable = true` in `home.nix`.
- [ ] Verify that user overrides in `home.nix` still work as expected.

## Out of Scope
- Major architectural changes to the Nix-Darwin configuration (focus on Home Manager modules).
- Adding new features to existing program modules.
