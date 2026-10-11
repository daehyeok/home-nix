#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields using jq
eval $(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.workspace.current_dir // "")\"
   CONV_ID=\"\(.conversation_id // "")\"
   HAS_ACTIVE_SUBAGENTS=\((.subagents // .agsubagents // []) | any(type != "object" or .status != "completed"))
   TASKS_COUNT=\"\(.task_count // 0)\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD="" CONV_ID="" HAS_ACTIVE_SUBAGENTS=false TASKS_COUNT="0"')

WORKSPACE=""
CITC_DIR_TYPE=""
# Try to extract CitC workspace name from CWD
if [ -n "$CWD" ]; then
    if [[ "$CWD" =~ /google/src/cloud/[^/]+/([^/]+) ]]; then
        WORKSPACE="${BASH_REMATCH[1]}"
    fi

    if [[ "$CWD" =~ /google/src/cloud/[^/]+/[^/]+/google3/([^/]+) ]]; then
        WORKSPACE="${WORKSPACE}:${BASH_REMATCH[1]}"
    fi
fi

if [ -n "$WORKSPACE" ]; then
    DIR_FMT="#[fg=yellow](${WORKSPACE})#[fg=white]/#[fg=cyan]$(basename $CWD)"
else
    DIR_FMT="#[fg=cyan]$(basename $CWD)"
fi

case "$STATE" in
    Ready|idle)   EMOJI="🚀" ;;
    thinking)     EMOJI="🤔" ;;
    working)      EMOJI="🏃" ;;
    tool_use)     EMOJI="🛠️" ;;
    authenticating)            EMOJI="🛂" ;;
    reviewing)            EMOJI="🔍" ;;
    *)            EMOJI="⏳" ;;
esac

if [ "$TASKS_COUNT" != "0" ]; then
    EMOJI="${EMOJI}📋"
fi

if [ "$HAS_ACTIVE_SUBAGENTS" = "true" ]; then
    EMOJI="${EMOJI}🤖"
fi

TITLE="${EMOJI}${DIR_FMT}"

echo "$TITLE"
