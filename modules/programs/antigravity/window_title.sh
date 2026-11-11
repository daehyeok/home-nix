#!/bin/bash
# Jetski / Antigravity CLI title command (settings.json "title").
#
# Jetski wraps whatever this prints into an OSC 2 title, so the output must
# be plain text: terminals (and tmux's #T) show tmux style tags such as
# "#[fg=cyan]" literally.
#
# The title depends on where Jetski runs:
#   * inside tmux: "<state emoji>[📋][🤖] <dir>". The leading emoji is what
#     agenmux (modules/programs/jetski/agenmux-jetski.conf) matches on.
#   * in Rex, outside tmux: "🚀 <dir> · <topic>" (fixed rocket; topic = the
#     conversation's first request, cut to 30 characters, or "jetski" before
#     there is one; dir compressed like the zsh tab title via
#     compress_path.sh). Agent status (working, blocked, done, failed) goes
#     to Rex from Jetski's built-in OSC 7501 reporting (AGY_CLI_OSC7501=on,
#     set by the antigravity module's zsh init), so the title has no state.
#   * in any other terminal: same as tmux, so the state is still visible.
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields using jq
eval "$(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.workspace.current_dir // "")\"
   HAS_ACTIVE_SUBAGENTS=\((.subagents // .agsubagents // []) | any(type != "object" or .status != "completed"))
   TASKS_COUNT=\"\(.task_count // 0)\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD="" HAS_ACTIVE_SUBAGENTS=false TASKS_COUNT="0"')"
CONV_ID="$(jq -r '.conversation_id // .session_id // ""' <<<"$DATA" 2>/dev/null || true)"
TRANSCRIPT="$(jq -r '.transcript_path // ""' <<<"$DATA" 2>/dev/null || true)"

# Conversation topic for the Rex tab: the first user request (a leading
# /command removed), one line, at most 30 characters. It is read from the
# transcript once and cached per conversation, since Jetski runs this script
# about once a second.
topic() {
    [ -n "$CONV_ID" ] || return 0
    local dir="${TMPDIR:-/tmp}" cache t
    cache="${dir%/}/jetski-title-topic-${CONV_ID//[^A-Za-z0-9_-]/_}"
    if [ -s "$cache" ]; then
        cat "$cache"
        return 0
    fi
    [ -r "$TRANSCRIPT" ] || return 0
    t="$(jq -rn 'first(inputs | select(.type == "USER_INPUT") | .content // "")
        | (capture("<USER_REQUEST>\\s*(?<r>[\\s\\S]*?)\\s*</USER_REQUEST>").r // .)
        | gsub("\\s+"; " ") | sub("^ "; "") | sub("^/[A-Za-z0-9_:-]+ ?"; "") | sub(" $"; "")' \
        "$TRANSCRIPT" 2>/dev/null || true)"
    [ -n "$t" ] || return 0
    if [ "${#t}" -gt 30 ]; then
        t="${t:0:29}…"
    fi
    printf '%s' "$t" > "$cache" 2>/dev/null || true
    printf '%s' "$t"
}

# Directory label: "(citc_ws:google3_top)/dir", or just "dir".
WORKSPACE=""
if [[ "$CWD" =~ /google/src/cloud/[^/]+/([^/]+) ]]; then
    WORKSPACE="${BASH_REMATCH[1]}"
fi
if [[ "$CWD" =~ /google/src/cloud/[^/]+/[^/]+/google3/([^/]+) ]]; then
    WORKSPACE="${WORKSPACE}:${BASH_REMATCH[1]}"
fi
DIR_NAME=$(basename "${CWD:-/}")
if [ -n "$WORKSPACE" ]; then
    DIR_LABEL="(${WORKSPACE})/${DIR_NAME}"
else
    DIR_LABEL="${DIR_NAME}"
fi

if [ -z "${TMUX:-}" ] && { [ -n "${REX_BLOCK:-}" ] || [ "${TERM_PROGRAM:-}" = "rex" ]; }; then
    # Same compressed path as the zsh tab title, e.g. "(ws:google3)//.../dir".
    REX_DIR="$DIR_LABEL"
    COMPRESS_PATH_SH="$(dirname "${BASH_SOURCE[0]}")/compress_path.sh"
    if [ -n "$CWD" ] && [ -f "$COMPRESS_PATH_SH" ]; then
        # shellcheck source=/dev/null
        source "$COMPRESS_PATH_SH"
        REX_DIR="$(compress_path "$CWD")"
    fi
    TOPIC="$(topic)"
    echo "🚀 ${REX_DIR} · ${TOPIC:-jetski}"
    exit 0
fi

# One distinct leading emoji per agent_state. The agenmux jetski.conf
# (WORKING_TITLE / BLOCKED_TITLE) matches on these, so keep them in sync.
case "$STATE" in
    Ready|idle)     EMOJI="🚀" ;;
    thinking)       EMOJI="🤔" ;;
    working)        EMOJI="🏃" ;;
    tool_use)       EMOJI="🛠️" ;;
    reviewing)      EMOJI="🔍" ;;
    authenticating) EMOJI="🛂" ;;
    initializing)   EMOJI="⏳" ;;
    error)          EMOJI="❌" ;;
    *)              EMOJI="❓" ;;
esac

if [ "$TASKS_COUNT" != "0" ]; then
    EMOJI="${EMOJI}📋"
fi

if [ "$HAS_ACTIVE_SUBAGENTS" = "true" ]; then
    EMOJI="${EMOJI}🤖"
fi

echo "${EMOJI} ${DIR_LABEL}"
