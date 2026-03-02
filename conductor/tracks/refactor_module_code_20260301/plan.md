# Implementation Plan: Refactor Nix Modules for Simplified Program Configuration

## Phase 1: Research and Pattern Definition
- [ ] Task: Define the new simplified module pattern.
    - [ ] Analyze `modules/programs/tmux/default.nix` as a reference.
    - [ ] Document the target pattern: `options.modules...enable` defaults to `true`, and `config` uses `mkDefault` for `programs...enable`.
- [ ] Task: List all modules to be refactored.
    - [ ] Scan `modules/programs/` and `modules/dev/` for modules using the old `mkEnableOption` pattern.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Research and Pattern Definition' (Protocol in workflow.md)

## Phase 2: Refactor Program Modules
- [ ] Task: Refactor simple program modules.
    - [ ] `modules/programs/atuin.nix`
    - [ ] `modules/programs/bat.nix`
    - [ ] `modules/programs/bottom.nix`
    - [ ] `modules/programs/delta.nix`
    - [ ] `modules/programs/direnv.nix`
    - [ ] `modules/programs/fd.nix`
    - [ ] `modules/programs/fzf.nix`
    - [ ] `modules/programs/jq.nix`
    - [ ] `modules/programs/lsd.nix`
    - [ ] `modules/programs/ripgrep.nix`
    - [ ] `modules/programs/tealdeer.nix`
    - [ ] `modules/programs/zoxide.nix`
- [ ] Task: Refactor complex program modules.
    - [ ] `modules/programs/git.nix`
    - [ ] `modules/programs/neovim.nix`
    - [ ] `modules/programs/tmux/default.nix`
    - [ ] `modules/programs/zellij.nix`
    - [ ] `modules/programs/zsh/default.nix`
    - [ ] `modules/programs/starship/default.nix`
- [ ] Task: Refactor system utility modules.
    - [ ] `modules/programs/htop.nix`
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Refactor Program Modules' (Protocol in workflow.md)

## Phase 3: Refactor Dev Modules
- [ ] Task: Refactor dev modules.
    - [ ] `modules/dev/dart.nix`
    - [ ] `modules/dev/nix.nix`
    - [ ] `modules/dev/rust.nix`
    - [ ] `modules/dev/kotlin.nix`
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Refactor Dev Modules' (Protocol in workflow.md)

## Phase 4: Cleanup and Verification
- [ ] Task: Cleanup `settings/default.nix`.
    - [ ] Remove redundant `modules.programs.<name>.enable = true` settings.
    - [ ] Ensure any non-default configurations are preserved.
- [ ] Task: Verify configuration.
    - [ ] Use `nix-instantiate --parse` or similar to check for syntax errors.
    - [ ] (Optional) Try a dry-run activation if environment allows.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Cleanup and Verification' (Protocol in workflow.md)
