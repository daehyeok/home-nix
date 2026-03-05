# Specification: Update Emacs-Editor Module

## Overview
Update the `emacs-editor` module to correctly set the `EDITOR` environment variable and ensure that Emacs is used as the default editor even within specific environments like `GEMINI`, where it currently defaults to `vi`.

## Functional Requirements
1. **Set `EDITOR` Variable:** Ensure the `EDITOR` environment variable is consistently set to `emacs` (or `emacsclient` as appropriate) across all shell sessions managed by the Nix configuration.
2. **Environment-Specific Logic (`GEMINI`):** Add logic to detect if the shell is in the `GEMINI` environment/state and force the use of the Emacs-based editor instead of defaulting to `vi`.
3. **Shell Integration:** Update Zsh and other relevant shell configurations to correctly inherit these editor settings.
4. **Bug Fix:** Resolve the issue where the `EDITOR` environment variable is not being set correctly in some shell sessions.

## Non-Functional Requirements
1. **Reproducibility:** Ensure the configuration remains fully reproducible via Nix.
2. **Modular Architecture:** Maintain the modular structure of the Home Manager configuration.

## Acceptance Criteria
- `echo $EDITOR` returns the correct Emacs-based command in a new shell session.
- Within the `GEMINI` environment, launching a generic editor command uses Emacs.
- No regression in existing `vterm` or icon configurations.

## Out of Scope
- Adding new Emacs packages beyond what's required for the bug fix and basic functionality.
- Modifying other development environments (Python, Rust, etc.) unless directly related to the editor setup.
