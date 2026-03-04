# Specification: emacs-editor Script and Nix Module

## 1. Overview

This track is to create a shell script `emacs-editor` that can be used as the default EDITOR, and a corresponding Nix module to integrate it into the Zsh environment managed by Home Manager.

## 2. Functional Requirements

### 2.1. `emacs-editor` Script

- **Location:** The script will be located at `modules/programs/emacs-editor`.
- **Execution Logic:**
    - **Check for Emacs Server:** The script must first check if an Emacs server is running. This can be done using `emacsclient -e t > /dev/null 2>&1`.
    - **If Server is Running:**
        - **Check if inside Emacs:** Determine if the script is being run from within an Emacs session by checking the `$INSIDE_EMACS` environment variable.
        - **Inside Emacs:** If `$INSIDE_EMACS` is set, open the file(s) in the current Emacs client instance (e.g., `emacsclient "$@" `).
        - **Outside Emacs:** If not inside Emacs, open the file(s) in a new Emacs client within the current terminal using `emacsclient -nw "$@" `.
    - **If Server is NOT Running:**
        - Open the file(s) directly with `emacs -q "$@" `.

### 2.2. Nix Module

- **Location:** The Nix module will be located at `modules/programs/zsh/emacs-editor.nix`.
- **Options:**
    - `enable`: A boolean option to enable or disable the `emacs-editor` integration. Defaults to `false`.
    - `zsh_integration`: A boolean option to control Zsh environment setup. Defaults to `true` if `enable` is true.
- **Functionality:**
    - When `enable` is true, the module should make the `emacs-editor` script available in the user's PATH.
    - When `zsh_integration` is true, the module should set the `EDITOR` environment variable to the path of the `emacs-editor` script within the Zsh configuration.

## 3. Non-Functional Requirements

- The script should be robust and handle potential errors gracefully.
- The Nix module should integrate cleanly with the existing Home Manager structure.

## 4. Acceptance Criteria

- The `emacs-editor` script is created at the specified location.
- The script functions correctly based on whether the Emacs server is running and whether it's called from within Emacs.
- The Nix module `modules/programs/zsh/emacs-editor.nix` is created.
- Enabling the module makes the `emacs-editor` command available.
- With `zsh_integration` enabled, the `EDITOR` environment variable is set to `emacs-editor` in Zsh sessions.
- The module can be enabled and disabled configureably.

## 5. Out of Scope

- Starting the Emacs server automatically if it's not running.
- Extensive configuration options for the Emacs command itself.
