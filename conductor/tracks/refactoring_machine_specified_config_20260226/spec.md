# Specification: Refactor Machine Specific Configuration

## Overview
This track focuses on refactoring the Nix configuration to centralize machine-specific settings. The goal is to move configurations from `modules/base/default.nix` and the `initContent` within `modules/zsh/default.nix` into the main `home.nix` file.

## Goals
- Improve the organization of the Nix configuration.
- Simplify the management of machine-specific settings.
- Increase the readability of the configuration files.
- Reduce the overall complexity of the setup.

## Functional Requirements
1.  All settings and values currently defined in `modules/base/default.nix` must be moved to `home.nix`.
2.  The `initContent` string within `modules/zsh/default.nix` must be moved to `home.nix`.
3.  The structure of `home.nix` should be updated to accommodate these new configurations in a clear and logical manner.
4.  The existing functionality and behavior of the shell and other configured programs must be preserved after the refactoring.

## Acceptance Criteria
-   `modules/base/default.nix` is either removed or contains no machine-specific values.
-   The `initContent` is no longer defined within `modules/zsh/default.nix`.
-   All moved configurations are present and correctly applied from `home.nix`.
-   Running `darwin-rebuild switch` or the equivalent Nix command results in the same environment configuration as before the changes.
-   The Zsh shell initializes correctly with the expected settings and scripts.

## Out of Scope
-   Refactoring of other modules not specified above.
-   Changes to the Tech Stack.
-   Adding new features or functionalities.
