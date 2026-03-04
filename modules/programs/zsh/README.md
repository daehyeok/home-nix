# Zsh Modules

This directory contains modules related to Zsh configuration.

## emacs-editor.nix

This module provides an `emacs-editor` script and configures it as the default `$EDITOR`.

### Options

- `programs.zsh.emacs-editor.enable`: Boolean (default: `false`)
  Enables the module, making the `emacs-editor` script available in the PATH.

- `programs.zsh.emacs-editor.zsh_integration`: Boolean (default: `true`)
  If enabled, sets the `EDITOR` environment variable to `emacs-editor` for Zsh sessions.

### Script Behavior (`emacs-editor`)

- If an Emacs server is running and the script is called from within Emacs, it uses `emacsclient` to open the file in the current frame.
- If a server is running but not in Emacs, it uses `emacsclient -nw` to open the file in the terminal.
- If no server is running, it starts a new Emacs instance with `emacs -q`.
