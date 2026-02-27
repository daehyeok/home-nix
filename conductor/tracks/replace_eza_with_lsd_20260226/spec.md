# Track Specification: Replace eza with lsd

## Overview
Replace the `eza` file listing utility with `lsd` (LSDeluxe) across the entire Nix configuration. This involves removing all `eza` related modules, settings, and aliases, and introducing a new `lsd` module with consistent styling and improved icons.

## Functional Requirements
1. **Remove eza:**
   - Delete `modules/programs/eza.nix`.
   - Remove references to `eza` in `modules/programs/default.nix`.
   - Remove enable flag and custom aliases in `settings/default.nix`.
2. **Implement lsd:**
   - Create a new Nix module `modules/programs/lsd.nix`.
   - Use standard Home Manager `programs.lsd` options.
   - Enable icons (Nerd Font) and color output.
3. **Update Shell Aliases:**
   - `ls` -> `lsd`
   - `ll` -> `lsd -l`
   - `tree` -> `lsd --tree`
4. **Integration:**
   - Register the new `lsd` module in `modules/programs/default.nix`.
   - Enable `lsd` in `settings/default.nix`.

## Acceptance Criteria
- Running `ls` should execute `lsd`.
- `ll` and `tree` commands should work as expected with `lsd` backend.
- Icons should be visible in the terminal.
- `eza` should no longer be present in the user's environment after a rebuild.
