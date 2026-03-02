# Specification: Refactor Program Modules to Reactive Enablement

## Overview
Refactor the program configuration modules in `modules/programs/` to align with standard Nix/Home Manager patterns. The primary goal is to ensure that module-specific configurations (defaults, aliases, plugins) are only applied when the corresponding program is explicitly enabled by the user via `programs.<name>.enable = true`.

## Functional Requirements
- **Reactive Configuration:** Modules must use `config = mkIf config.programs.<name>.enable { ... }` or equivalent to conditionally apply settings.
- **Consolidation:** Ensure that setting up a program only requires enabling it in the core `programs` namespace, without needing a secondary "module enable" flag where possible.
- **Preservation:** All existing customizations (e.g., tmux plugins, shell aliases in `bat`, `lsd` settings) must be preserved within the new conditional logic.

## Non-Functional Requirements
- **Simplicity:** Reduce boilerplate in `home.nix` and `settings/default.nix`.
- **Readability:** Make the relationship between a program being enabled and its specific configuration more explicit.
- **Maintainability:** Standardize the pattern across all program modules for easier extension.

## Acceptance Criteria
- [ ] Refactor all modules in `modules/programs/` to trigger their configuration based on the state of `programs.<name>.enable`.
- [ ] Verify that disabling a program (e.g., `programs.tmux.enable = false`) also removes its associated module configurations (aliases, plugins).
- [ ] Successfully rebuild the Home Manager configuration with the new structure.

## Out of Scope
- Adding new features or programs.
- Refactoring `modules/dev/` unless directly impacted by shared logic.
- Modifying `nix-darwin` system-level settings.
