# Implementation Plan: Refactor Nix Modules for Simplified Program Configuration

## Phase 1: Research and Pattern Definition [checkpoint: 9e8a92e]
- [x] Task: Define the new simplified module pattern.
    - [x] Analyze `modules/programs/tmux/default.nix` as a reference.
    - [x] Document the target pattern: `options.modules...enable` defaults to `true`, and `config` uses `mkDefault` for `programs...enable`.
- [x] Task: List all modules to be refactored.
    - [x] Scan `modules/programs/` and `modules/dev/` for modules using the old `mkEnableOption` pattern.
- [x] Task: Conductor - User Manual Verification 'Phase 1: Research and Pattern Definition' (Protocol in workflow.md) (9e8a92e)

## Phase 2: Refactor Program Modules
- [x] Task: Refactor simple program modules.
    - [x] `modules/programs/atuin.nix`
    - [x] `modules/programs/bat.nix`
    - [x] `modules/programs/bottom.nix`
    - [x] `modules/programs/delta.nix`
    - [x] `modules/programs/direnv.nix`
    - [x] `modules/programs/fd.nix`
    - [x] `modules/programs/fzf.nix`
    - [x] `modules/programs/jq.nix`
    - [x] `modules/programs/lsd.nix`
    - [x] `modules/programs/ripgrep.nix`
    - [x] `modules/programs/tealdeer.nix`
    - [x] `modules/programs/zoxide.nix`
- [x] Task: Refactor complex program modules.
    - [x] `modules/programs/git.nix`
    - [x] `modules/programs/neovim.nix`
    - [x] `modules/programs/tmux/default.nix`
    - [x] `modules/programs/zellij.nix`
    - [x] `modules/programs/zsh/default.nix`
    - [x] `modules/programs/starship/default.nix`
- [x] Task: Refactor system utility modules.
    - [x] `modules/programs/htop.nix`
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Refactor Program Modules' (Protocol in workflow.md)

## Phase 3: Refactor Dev Modules
- [x] Task: Refactor dev modules.
    - [x] `modules/dev/dart.nix`
    - [x] `modules/dev/nix.nix`
    - [x] `modules/dev/rust.nix`
    - [x] `modules/dev/kotlin.nix`
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Refactor Dev Modules' (Protocol in workflow.md)

## Phase 4: Cleanup and Verification
- [x] Task: Cleanup `settings/default.nix`.
    - [x] Remove redundant `modules.programs.<name>.enable = true` settings.
    - [x] Ensure any non-default configurations are preserved.
- [x] Task: Verify configuration.
    - [x] Use `nix-instantiate --parse` or similar to check for syntax errors.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Cleanup and Verification' (Protocol in workflow.md)
