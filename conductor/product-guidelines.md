# Project Guidelines: Home Manager & Darwin Nix Configuration

## General Principles
- **Nix-First:** All configuration changes must be made within the Nix configuration, avoiding manual edits to the file system.
- **Granularity:** Each program or tool should have its own dedicated Nix file within the `modules/` or `settings/` directories for maximum clarity and reuse.

## Nix Formatting & Style
- **Formatting:** Use `nixpkgs-fmt` (2 spaces, standard braces) for all Nix files to ensure consistent styling.
- **Environment Referencing:**
- **Brevity:** Prefer `with pkgs;` for common lists and package declarations for concise code.
- **Structured:** Use `let`-bindings for common package sets, build dependencies, and shared configuration values to improve readability and reusability.
- **Documentation:** Every module should start with a high-level comment explaining its purpose and any unique configuration logic. Complex logic blocks within files must be documented with concise comments.

## Modularity & Structure
- **Tool-Centric Modules:** Prefer individual files for each tool (e.g., `dev/python.nix`, `dev/rust.nix`) rather than grouping multiple tools into a single Nix file.
- **Clear Separation:** Maintain a clear distinction between system-level settings (nix-darwin) and user-level configurations (home-manager) to avoid configuration bleed.

## Reproducibility & Stability
- **Testing:** Always test new configurations or package additions with a dry-run or a temporary build before applying them permanently.
- **Pinning:** While using the Unstable channel, document any known issues or specific version requirements in the relevant module to prevent future regressions.
