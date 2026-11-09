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
#   * in Rex, outside tmux: "🚀 <dir> · jetski" (fixed rocket; "jetski" so
#     tabs are findable by name in fuzzy search; dir compressed like the
#     zsh tab title via compress_path.sh). Agent state goes to Rex through
#     the Program Status Protocol (OSC 7501) instead, and Rex draws its own
#     spinner/blocked/done indicators on the tab.
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

# Report agent state to Rex (OSC 7501). Written straight to the controlling
# terminal because stdout is captured by Jetski. Only sent when the state
# changes, keyed by Rex block + Jetski pid.
rex_report_status() {
    local status cache key prev msg
    case "$STATE" in
        Ready|idle)     status="idle" ;;
        thinking|working|tool_use|reviewing|initializing)
                        status="working" ;;
        authenticating) status="blocked:kind=auth" ;;
        error)          status="error" ;;
        *)              return 0 ;;
    esac

    key="${REX_BLOCK:-tty}-${PPID}"
    cache="${XDG_RUNTIME_DIR:-/tmp}/jetski-rex-status-${key//[^A-Za-z0-9_.-]/_}"
    prev=$(cat "$cache" 2>/dev/null || true)

    # A turn that finishes (working -> idle) is reported as "done", so Rex
    # flags the tab until it is looked at. Stay "done" while idle.
    if [ "$status" = "idle" ] && { [ "$prev" = "working" ] || [ "$prev" = "done" ]; }; then
        status="done"
    fi
    [ "$status" = "$prev" ] && return 0

    msg=$(printf '%s' "$STATE" | base64 | tr -d '\n')
    { printf '\e]7501;state=%s:app=jetski:msg=%s\e\\' "$status" "$msg" > /dev/tty; } 2>/dev/null || return 0
    printf '%s' "$status" > "$cache" 2>/dev/null || true
}

if [ -z "${TMUX:-}" ] && { [ -n "${REX_BLOCK:-}" ] || [ "${TERM_PROGRAM:-}" = "rex" ]; }; then
    rex_report_status || true
    # Same compressed path as the zsh tab title, e.g. "(ws:google3)//.../dir".
    REX_DIR="$DIR_LABEL"
    COMPRESS_PATH_SH="$(dirname "${BASH_SOURCE[0]}")/compress_path.sh"
    if [ -n "$CWD" ] && [ -f "$COMPRESS_PATH_SH" ]; then
        # shellcheck source=/dev/null
        source "$COMPRESS_PATH_SH"
        REX_DIR="$(compress_path "$CWD")"
    fi
    echo "🚀 ${REX_DIR} · jetski"
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
