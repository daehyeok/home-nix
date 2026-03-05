# Specification: Update Conduct Workflow (User Input Transformation)

## Overview
Update the `conductor/workflow.md` to mandate a grammar/clarity transformation step for all user-provided text (e.g., track descriptions, task names) before it is written to persistent registry files like `tracks.md`, `plan.md`, and `metadata.json`. This ensures that all persistent project records are professionally written, clear, and free of errors, particularly when the input may be from a non-native English speaker.

## Functional Requirements
1. **Mandatory Text Transformation:** The agent MUST rewrite and correct all user-provided text for grammar, clarity, and professional tone *before* it is written to any file.
2. **Intent Preservation:** While correcting grammar and improving clarity, the agent MUST ensure that the original intent of the user's input is accurately preserved.
3. **Registry Protection:** This transformation check is required for any tool call that modifies `tracks.md`, `plan.md`, `spec.md`, or other core documentation/registry files.
4. **Task Lifecycle Integration:** Update the "Task Workflow" and "New Track Initialization" protocols in `workflow.md` to explicitly include this transformation step.

## Acceptance Criteria
- `conductor/workflow.md` is updated with the text transformation requirements.
- The protocol for "Updating Tracks Registry" and "Implementation Plan" explicitly mentions this transformation step.
- All subsequent track-level documentation shows improved grammar and professional quality.

## Out of Scope
- Automated spell-checking of code comments or non-user-facing files.
- Modifying the user's direct messages or chat history.
