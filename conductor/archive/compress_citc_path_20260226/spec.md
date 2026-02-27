# Track Specification: Compress CitC Workspace Path in tmux

## Overview
Enhance the `window_text.sh` script to provide specialized compression for Google Cloud (CitC) workspace paths. When a path is identified as being within a CitC workspace, it should be compressed to a concise format that highlights the workspace name and the directory type (e.g., `google3`, `experimental`).

## Functional Requirements
1. **Identify CitC Paths:**
   - Detect paths containing `/google/src/cloud/`.
   - Extract `{workspace}`, `{dir_type}`, and the current directory `{cur_dir}` from paths like `/google/src/cloud/{user}/{workspace}/{dir_type}/...`.
2. **Implement CitC Compression Logic:**
   - Format the prefix as `({workspace}:{dir_type})`.
   - If the path is deep, shorten intermediate folders (e.g., `({workspace}:{dir_type}) ... {cur_dir}`).
3. **Integration with `window_text.sh`:**
   - Integrate this logic into the `compress_path` function.
   - Maintain existing icon display.

## Acceptance Criteria
- Paths containing `/google/src/cloud/` are compressed to the `({workspace}:{dir_type})` format.
- Intermediate directories are shortened for deep paths.
- Normal paths (non-CitC) are unaffected.
