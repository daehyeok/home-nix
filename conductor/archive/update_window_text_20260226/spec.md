# Track Specification: Update `window_text.sh` Logic

## Overview
Update the `window_text.sh` script to display a compressed current path when the active process is `zsh`, rather than just displaying the word "zsh". This will provide more context about the active directory within the tmux window title.

## Functional Requirements
1. **Modify `window_text.sh` Parameters:**
   - Update the script to accept a third argument: `pane_current_path`.
2. **Implement Path Compression:**
   - Create logic to "compress" the path (e.g., replace the home directory with `~` and potentially shorten intermediate directory names).
3. **Conditional Display Logic:**
   - If the identified `base_name` is `zsh`, display the Zsh icon followed by the compressed path.
   - For all other processes, maintain the existing behavior (display icon and process name).
4. **Update Tmux Configuration:**
   - Modify `modules/programs/tmux/default.nix` to pass `#{pane_current_path}` as the third argument to `window_text.sh`.

## Acceptance Criteria
- When a tmux window is running `zsh`, the window title shows the Zsh icon followed by the shortened path (e.g., ` ~/c/p/project`).
- When running other processes (e.g., `nvim`), it still shows the icon and process name.
- The change is applied correctly via Home Manager/nix-darwin.
