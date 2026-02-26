# Tech Stack: Home Manager & Cross-Platform Nix Configuration

## Core Infrastructure
- **Operating Systems:** macOS (darwin), Linux (NixOS or other distributions)
- **Environment Management:** Nix (with Unstable channel)
- **Configuration Frameworks:** 
  - **nix-darwin:** To manage system-level settings on macOS (darwin).
  - **Home Manager:** To manage user-level dotfiles and application settings across both macOS and Linux.

## Shell & CLI Tools
- **Shell:** Zsh (with autopair, autosuggestions, completions, and fast-syntax-highlighting)
- **Prompt:** Starship (for a fast, customizable prompt)
- **Terminal Emulator:** vterm (for emacs integration)

## Development Environments
- **Python:** Python 3.13 with LSP, isort, flake8, and yapf.
- **Rust:** Managed through Nix modules (cargo-edit, rust-analyzer).
- **Dart & Kotlin:** Nix-managed development toolchains.
- **Nix:** Self-managing configuration environment.

## Built-in Utilities
- **Home Manager modules:** Categorized by tool (modules/programs/, modules/dev/, etc.)
- **Devenv:** For reproducible, project-specific developer environments.
- **Pre-commit:** Framework for managing and maintaining multi-language pre-commit hooks (Nix formatting, whitespace, etc.).
- **System Fonts:** fontconfig, emacs-all-the-icons-fonts.
