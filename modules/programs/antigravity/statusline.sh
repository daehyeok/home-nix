#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

# Extract fields using jq
# Uses JQ's optional chaining operator (?) for null safety across various environments
eval $(jq -r '
    "STATE=\"\(.agent_state // "idle")\"
    CWD=\"\(.workspace?.current_dir // "")\"
    PROJECT_DIR=\"\(.workspace?.project_dir // "")\"
    USED_PCT=\"\(.context_window?.used_percentage // 0)\"
    COST=\"\(.cost?.total_cost_usd // 0)\"
    VCS_BRANCH=\"\(.vcs?.branch // "")\"
    VCS_CLIENT=\"\(.vcs?.client // "")\"
    VCS_DIRTY=\"\(.vcs?.dirty // false)\"
    TASKS_COUNT=\"\(.task_count // 0)\"
    AGENT_NAME=\"\(.agent?.name | if . == null or . == "" or . == "default" then "Default" else . end)\"
    SUBAGENTS_COUNT=\"\(.subagents // [] | map(select(.status == "running")) | length)\"
    ARTIFACTS_COUNT=\"\(.artifact_count // 0)\"
    MODEL_NAME=\"\(.model?.display_name // "")\"
    COLS=\"\(.terminal_width // 80)\"
    "
' 2>/dev/null <<< "$DATA" || echo 'STATE="idle" CWD="" PROJECT_DIR="" USED_PCT="0" COST="0" VCS_BRANCH="" VCS_CLIENT="" VCS_DIRTY="false" TASKS_COUNT="0" AGENT_NAME="Default" SUBAGENTS_COUNT="0" ARTIFACTS_COUNT="0" MODEL_NAME="" COLS="80"')

USED_PCT_FMT=$(printf "%.2f" "$USED_PCT")

# Format agent state with ANSI colors
case "$STATE" in
    idle)     STATE_FMT="\033[1;32m🚀 READY\033[0m" ;;
    thinking) STATE_FMT="\033[1;33m🤔 THINKING\033[0m" ;;
    working)  STATE_FMT="\033[1;36m🏃 WORKING\033[0m" ;;
    tool_use) STATE_FMT="\033[1;35m🛠 TOOL USE\033[0m" ;;
    *)        STATE_FMT="\033[2m⏳ ${STATE}\033[0m" ;;
esac

# Format Workspace / Folder Directory & Branch details
CWD_BASE="${CWD##*/}"
BRANCH_DISPLAY="${VCS_BRANCH:-$VCS_CLIENT}"

# Filter out internal tracking patterns (e.g., ofy- or host branches)
if [[ "$BRANCH_DISPLAY" == *daehyeok-* || "$BRANCH_DISPLAY" == *host* ]]; then
    BRANCH_DISPLAY=""
fi

if [ "$VCS_DIRTY" = "true" ] && [ -n "$BRANCH_DISPLAY" ]; then
    BRANCH_DISPLAY="${BRANCH_DISPLAY}*"
fi

DIR_FMT=""
if [ -n "$CWD_BASE" ] && [ -n "$BRANCH_DISPLAY" ]; then
    DIR_FMT="📁 \033[36m$CWD_BASE\033[0m \033[90m>\033[0m \033[34m$BRANCH_DISPLAY\033[0m"
elif [ -n "$CWD_BASE" ]; then
    DIR_FMT="📁 \033[36m$CWD_BASE\033[0m"
fi

# Format and adapt display to current terminal width (COLS)
if [ "${COLS:-80}" -ge 100 ]; then
    # Wide screen: All-in-one unified single line layout
    if [ -n "$DIR_FMT" ]; then
        echo -e " $STATE_FMT \033[90m│\033[0m \033[35m$MODEL_NAME\033[0m \033[90m│\033[0m \033[33m🪟 ${USED_PCT_FMT}%\033[0m \033[90m│\033[0m 📋 Tasks: \033[36m$TASKS_COUNT\033[0m \033[90m│\033[0m 🧠 Agent: \033[32m$AGENT_NAME\033[0m \033[90m│\033[0m 👥 Subagents: \033[36m$SUBAGENTS_COUNT\033[0m \033[90m│\033[0m 📄 Artifacts: \033[35m$ARTIFACTS_COUNT\033[0m \033[90m│\033[0m $DIR_FMT"
    else
        echo -e " $STATE_FMT \033[90m│\033[0m \033[35m$MODEL_NAME\033[0m \033[90m│\033[0m \033[33m🪟 ${USED_PCT_FMT}%\033[0m \033[90m│\033[0m 📋 Tasks: \033[36m$TASKS_COUNT\033[0m \033[90m│\033[0m 🧠 Agent: \033[32m$AGENT_NAME\033[0m \033[90m│\033[0m 👥 Subagents: \033[36m$SUBAGENTS_COUNT\033[0m \033[90m│\033[0m 📄 Artifacts: \033[35m$ARTIFACTS_COUNT\033[0m"
    fi
else
    # Narrow screen: Multi-line responsive layout
    echo -e "\033[90m╭─\033[0m $STATE_FMT \033[90m│\033[0m \033[35m$MODEL_NAME\033[0m"
    echo -e "\033[90m╰─\033[0m \033[33m🪟 ${USED_PCT_FMT}%\033[0m \033[90m│\033[0m 📋 Tasks: \033[36m$TASKS_COUNT\033[0m \033[90m│\033[0m 🧠 Agent: \033[32m$AGENT_NAME\033[0m \033[90m│\033[0m 👥 Subagents: \033[36m$SUBAGENTS_COUNT\033[0m \033[90m│\033[0m 📄 Artifacts: \033[35m$ARTIFACTS_COUNT\033[0m"
    if [ -n "$DIR_FMT" ]; then
        echo -e " $DIR_FMT"
    fi
fi
