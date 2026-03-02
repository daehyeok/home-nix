# Implementation Plan: Refactor Program Modules to Reactive Enablement

## Phase 1: Research and Pattern Definition [checkpoint: e81ea68]
- [x] Task: Define the "Reactive" module pattern.
    - [x] Analyze `modules/programs/atuin.nix` and `modules/programs/tmux/default.nix` as representatives.
    - [x] Document the target structure: `config = mkIf config.programs.<name>.enable { ... }`.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Research and Pattern Definition' (Protocol in workflow.md) (e81ea68)

## Phase 2: Refactor Simple Modules [checkpoint: e73bb7e]
- [x] Task: Refactor single-file program modules.
    - [x] Refactor `atuin.nix`, `bat.nix`, `bottom.nix`, `delta.nix`, `direnv.nix`, `fd.nix`, `fzf.nix`, `git.nix`, `htop.nix`, `jq.nix`, `lsd.nix`, `neovim.nix`, `ripgrep.nix`, `tealdeer.nix`, `zellij.nix`, `zoxide.nix`.
    - [x] Verify each one: If `programs.<name>.enable` is true, the customization is applied; if false, it is not.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Refactor Simple Modules' (Protocol in workflow.md) (e73bb7e)

## Phase 3: Refactor Complex Modules [checkpoint: a572b88]
- [x] Task: Refactor `tmux/default.nix`.
    - [x] Ensure plugin configurations and `window_text.sh` are conditional on `programs.tmux.enable`.
- [x] Task: Refactor `starship/default.nix`.
    - [x] Ensure `starship.zsh` and prompt customizations are conditional on `programs.starship.enable`.
- [x] Task: Refactor `zsh/default.nix`.
    - [x] Ensure plugin imports and session variables are conditional on `programs.zsh.enable`.
- [x] Task: Conductor - User Manual Verification 'Phase 3: Refactor Complex Modules' (Protocol in workflow.md) (a572b88)

## Phase 4: Cleanup and Final Verification
- [x] Task: Clean up `settings/default.nix`.
    - [x] Remove redundant `modules.programs.<name>.enable = true` settings.
- [x] Task: Final Configuration Verification.
    - [x] Run `nix-instantiate` to ensure the configuration remains valid.
- [x] Task: Conductor - User Manual Verification 'Phase 4: Cleanup and Final Verification' (Protocol in workflow.md) (1dc9b0a)
