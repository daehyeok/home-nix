---
name: notify-user
description: Sends the user a terminal notification (Rex tab badge and desktop banner) with agent-notify. Use when a long-running or background job the user is waiting on finishes or fails, when the user asks to be told when something completes ("let me know when the build is done"), or when you are blocked on an outside action the CLI can't see (someone's review, a browser login outside Jetski). Don't use for ordinary turn ends, ask_question prompts, permission prompts or sign-in / expired credentials; Jetski reports those itself.
---

# Notify the user

`agent-notify` reports status to the terminal the user is looking at. In Rex it
sets the tab's status and Rex shows a desktop notification when the tab isn't
focused. Outside Rex it silently does nothing, so it is always safe to call.

## When to notify

Jetski already reports its own lifecycle to Rex (built-in OSC 7501,
`AGY_CLI_OSC7501=on`): working, blocked on a permission prompt, question, plan
review, sign-in or expired credentials, done with your final reply, and failed.

So call `agent-notify` yourself only for what the CLI can't see:

| Situation | Call |
|---|---|
| A background job, build, test run or subagent the user is waiting on finished | `agent-notify done --msg "<result>"` |
| That job failed | `agent-notify error --msg "<what failed>"` |
| The user asked "tell me when X finishes" | `done` or `error` when X ends |
| You're waiting on an outside action the CLI doesn't track (someone's review, a login in another tool) | `agent-notify blocked --kind auth --msg "<what to do>"` (`auth` for credentials or logins, `permission` for approvals) |

Don't notify for every step, progress, or things the user is watching live.
One notification per outcome. Jetski's next status update (for example `done`
when your turn ends) replaces yours, so notify for outcomes that matter while
the turn is still running or after a background job ends.

## How to call

```sh
agent-notify <working|blocked|done|error|clear> \
  [--kind question|permission|auth] [--title TEXT] [--msg TEXT]
```

- `--title` defaults to empty. Use `jetski - <short project name>` so the
  banner says which project it's about.
- If `agent-notify` isn't on `PATH`, use `~/.local/bin/agent-notify`.
- It exits 0 even when it can't notify, so never retry or branch on its result.

## Writing the message

- One sentence, outcome first: "Build passed: 412 tests, 0 failures." not
  "I have finished running the build that you asked about."
- Short enough for a banner: aim for under 80 characters. Longer text is cut.
- Say what the user needs to do when blocked: "Refresh your credentials, then reply 'go'."
- No secrets, tokens, internal links, or long paths. Use a project or file name.

## Examples

```sh
agent-notify done  --title "jetski - dotfiles" --msg "Remote render finished; output unchanged."
agent-notify error --title "jetski - dotfiles" --msg "sync/test.sh failed: 2 of 56 tests."
agent-notify blocked --kind auth --msg "Credentials expired. Refresh them, then reply 'go'."
```
