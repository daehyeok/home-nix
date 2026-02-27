# Track Specification: Refine CitC Path Compression

## Overview
Refine the specialized compression for Google Cloud (CitC) workspace paths. This update adds support for identifying "special" directory types (like `java` or `blaze-bin`) within the workspace and replaces the directory ellipsis (`...`) with a double-slash (`//`) separator followed by a compressed subpath.

## Functional Requirements
1. **Detect Special Directory Types:**
   - Within a CitC path (`/google/src/cloud/{user}/{workspace}/google3/...`), identify if the next directory level matches a "special" list:
     - `blaze-*` (e.g., `blaze-bin`, `blaze-out`)
     - `java`
     - `javatests`
   - Use this special directory name as the `dir_type` in the compressed label.
   - If no match is found, default to `google3`.
2. **Implement Label Formatting:**
   - Format the prefix as `({workspace}:{effective_dir_type})`.
3. **Implement Double-Slash Separator and Compressed Subpath:**
   - Use `//` to separate the compressed label from the rest of the path.
   - Compress the remaining path components (shorten intermediate folders to their first character, keeping the last component whole).
   - If the path ends exactly at the `effective_dir_type`, show only the label.

## Acceptance Criteria
- `/google/src/cloud/user/firover/google3/javatests/com/google/firover` -> `(firover:javatests)//c/g/firover`
- `/google/src/cloud/user/my-ws/google3/blaze-bin/path/to/app` -> `(my-ws:blaze-bin)//p/t/app`
- `/google/src/cloud/user/ws/google3` -> `(ws:google3)`
- Non-CitC paths are unaffected.
