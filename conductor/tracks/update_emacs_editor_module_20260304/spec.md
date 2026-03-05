# Specification: Update Emacs-Editor Module

## Overview
Update the `emacs-editor` module to correctly set the `EDITOR` environment variable and ensure that `vi` is used as the editor within the `GEMINI` environment, while Emacs remains the default elsewhere.

## Functional Requirements
1. **Set `EDITOR` Variable:** Ensure the `EDITOR` environment variable is consistently set to `emacs-editor` across all shell sessions managed by the Nix configuration.
2. **Environment-Specific Logic (`GEMINI`):** Add logic to the `emacs-editor` script to detect if the shell is in the `GEMINI` environment/state (e.g., `GEMINI_CLI=1`) and use `vi` as the editor.
3. **Shell Integration:** Fix the `initContent` aggregation in Zsh to correctly source environment variables (like `hm-session-vars.sh`).
4. **Bug Fix:** Resolve the issue where the `EDITOR` environment variable is not being set correctly in Zsh sessions.

## Non-Functional Requirements
1. **Reproducibility:** Ensure the configuration remains fully reproducible via Nix.
2. **Modular Architecture:** Maintain the modular structure of the Home Manager configuration.

## Acceptance Criteria
- `echo $EDITOR` returns `emacs-editor` in a new shell session.
- Within the `GEMINI` environment (`GEMINI_CLI=1`), running `emacs-editor` launches `vi`.
- Outside the `GEMINI` environment, running `emacs-editor` launches Emacs.
- No regression in existing `vterm` or icon configurations.

## Out of Scope
- Adding new Emacs packages beyond what's required for the bug fix and basic functionality.
- Modifying other development environments (Python, Rust, etc.) unless directly related to the editor setup.
