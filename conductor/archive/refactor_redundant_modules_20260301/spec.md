# Specification: Refactor Redundant Program Modules

## Overview
Refactor `modules/programs/` to remove redundant files that contain only empty `mkIf` blocks or purely boilerplate code without actual configuration. This will clean up the module structure and reduce the number of empty files.

## Functional Requirements
- Identify all program modules in `modules/programs/` that do not contain actual configuration settings, aliases, or overrides.
- Based on my analysis, the following files are redundant:
    - `atuin.nix`
    - `bottom.nix`
    - `fd.nix`
    - `htop.nix`
    - `jq.nix`
    - `ripgrep.nix`
    - `tealdeer.nix`
    - `zellij.nix`
    - `zoxide.nix`
- Delete these files.
- Update `modules/programs/default.nix` to remove the imports of the deleted files.
- Ensure `settings/default.nix` remains the source of truth for enabling these programs.

## Acceptance Criteria
- Redundant modules are removed.
- `modules/programs/default.nix` is updated and free of broken imports.
- All programs listed in `settings/default.nix` remain functional with their default NixOS/Home Manager settings.
- The project rebuilds successfully (verified via syntax check).

## Out of Scope
- Adding new program configurations.
- Refactoring modules that *do* contain configuration (e.g., `bat.nix`, `delta.nix`, `lsd.nix`).
