# Initial Concept
Manage personal Home Manager environment on macOS (darwin) with Nix, including dev environments (Python, Rust, Dart, Kotlin) and shell configurations (Zsh, Starship).

# Project Guide: Home Manager & Darwin Nix Configuration

## Vision
A unified system and user environment management for macOS using Nix, providing a seamless bridge between OS settings (nix-darwin) and user-level dotfiles (home-manager).

## Target Users
- **Daehyeok (Self):** Primary user on macOS (darwin) who values a reproducible, clean, and highly portable development setup.

## Key Goals
- **Full System & User Integration:** Leverage both nix-darwin and Home Manager to control everything from system defaults to shell aliases in one place.
- **CLI-Centric & Minimalist:** Prioritize lightweight, efficient command-line tools and a distraction-free environment.
- **Bleeding Edge Reproducibility:** Use the Nix Unstable channel to ensure access to the latest software versions while maintaining a consistent configuration.

## Core Features
- **Rapid Dev Environment Setup:** Instant setup for Python, Rust, Dart, and Kotlin development through Nix modules.
- **Unified Shell Experience:** Consistent Zsh, Starship, and vterm configurations across all terminals.
- **Clean, Modular Architecture:** A highly readable configuration structure that separates programs, services, and system settings.

## Success Metrics
- **Reproducibility:** A single `nix build` or `darwin-rebuild` command fully restores the environment on a new macOS machine.
- **Speed:** Minimal shell startup time and low overhead for development tools.
- **Cleanliness:** Zero manual configuration outside of the Nix store.
