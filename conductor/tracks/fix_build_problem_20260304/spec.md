# Specification: Fix Build Problem (Invalid Git Configuration Nesting)

## Overview
The build is failing because the `git` configuration is incorrectly nested under `programs.zsh` in `home.nix`. This track aims to fix this nesting issue to restore a successful Home Manager build.

## Functional Requirements
1. **Fix Configuration Nesting:** Move the `git` configuration from under `programs.zsh` to its correct location under `programs.git` (or as a direct child of `programs` if it's meant to be its own module).
2. **Verify Configuration:** Ensure that after the fix, the `git` user settings (email, name) are correctly applied.

## Non-Functional Requirements
1. **Maintain Modularity:** Ensure the fix adheres to the project's modular architecture.

## Acceptance Criteria
- `home-manager switch --dry-run` completes successfully without the "option `programs.zsh.git` does not exist" error.
- The `git` configuration is correctly located in `home.nix`.

## Out of Scope
- Adding new features or programs to the configuration.
- Refactoring other parts of the configuration not related to this build error.
