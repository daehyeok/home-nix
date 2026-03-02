# Track: Fix Coercion Error in Zsh Session Variables

## Overview
Running `home-manager switch --dry-run` currently fails with a `cannot coerce a set to a string` error. This error stems from the use of `mkDefault` within the `programs.zsh.sessionVariables` attribute set in `modules/programs/zsh/default.nix`. Home Manager's Zsh module attempts to stringify these values directly, but `mkDefault` returns an attribute set when not properly merged and evaluated.

## Functional Requirements
- Remove the `mkDefault` calls from the values within `programs.zsh.sessionVariables`.
- Ensure that `ZSH_CACHE_DIR` and `WORDCHARS` are set as plain strings.

## Non-Functional Requirements
- Maintain existing behavior where possible (though these are already defaults in the module).

## Acceptance Criteria
- `home-manager switch --dry-run` completes successfully without coercion errors.
- The resulting `.zshenv` contains the correct exports for `ZSH_CACHE_DIR` and `WORDCHARS`.

## Out of Scope
- Refactoring other parts of the Zsh configuration.
- Changing the values of the session variables themselves.
