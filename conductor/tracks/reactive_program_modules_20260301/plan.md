# Implementation Plan: Refactor Program Modules to Reactive Enablement

## Phase 1: Research and Pattern Definition
- [x] Task: Define the "Reactive" module pattern.
    - [x] Analyze `modules/programs/atuin.nix` and `modules/programs/tmux/default.nix` as representatives.
    - [x] Document the target structure: `config = mkIf config.programs.<name>.enable { ... }`.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Research and Pattern Definition' (Protocol in workflow.md)

## Phase 2: Refactor Simple Modules
- [ ] Task: Refactor single-file program modules.
    - [ ] Refactor `atuin.nix`, `bat.nix`, `bottom.nix`, `delta.nix`, `direnv.nix`, `fd.nix`, `fzf.nix`, `git.nix`, `htop.nix`, `jq.nix`, `lsd.nix`, `neovim.nix`, `ripgrep.nix`, `tealdeer.nix`, `zellij.nix`, `zoxide.nix`.
    - [ ] Verify each one: If `programs.<name>.enable` is true, the customization is applied; if false, it is not.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Refactor Simple Modules' (Protocol in workflow.md)

## Phase 3: Refactor Complex Modules
- [ ] Task: Refactor `tmux/default.nix`.
    - [ ] Ensure plugin configurations and `window_text.sh` are conditional on `programs.tmux.enable`.
- [ ] Task: Refactor `starship/default.nix`.
    - [ ] Ensure `starship.zsh` and prompt customizations are conditional on `programs.starship.enable`.
- [ ] Task: Refactor `zsh/default.nix`.
    - [ ] Ensure plugin imports and session variables are conditional on `programs.zsh.enable`.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Refactor Complex Modules' (Protocol in workflow.md)

## Phase 4: Cleanup and Final Verification
- [ ] Task: Clean up `settings/default.nix`.
    - [ ] Remove redundant `modules.programs.<name>.enable = true` settings.
- [ ] Task: Final Configuration Verification.
    - [ ] Run `nix-instantiate` to ensure the configuration remains valid.
    - [ ] (Optional) Perform a dry-run activation.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Cleanup and Final Verification' (Protocol in workflow.md)
