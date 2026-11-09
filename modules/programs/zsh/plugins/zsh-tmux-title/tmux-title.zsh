# Zsh hooks for dynamic tmux window title and path compression updates.

zmodload zsh/parameter 2>/dev/null

typeset -g _TMUX_TITLE_RAW_DIR="${0:h}"
typeset -g _TMUX_TITLE_REAL_DIR="${0:A:h}"

function _tmux_title_find_compress_path() {
  emulate -L zsh
  if [[ -n "${COMPRESS_PATH_SH:-}" && -f "${COMPRESS_PATH_SH:-}" ]]; then
    export COMPRESS_PATH_SH
    return 0
  fi

  local -a candidates
  if [[ -n "${_TMUX_TITLE_RAW_DIR:-}" ]]; then
    candidates+=(
      "${_TMUX_TITLE_RAW_DIR}/.compress_path.sh"
      "${_TMUX_TITLE_RAW_DIR}/compress_path.sh"
      "${_TMUX_TITLE_RAW_DIR}/../../../tmux/compress_path.sh"
    )
  fi
  if [[ -n "${_TMUX_TITLE_REAL_DIR:-}" ]]; then
    candidates+=(
      "${_TMUX_TITLE_REAL_DIR}/.compress_path.sh"
      "${_TMUX_TITLE_REAL_DIR}/compress_path.sh"
      "${_TMUX_TITLE_REAL_DIR}/../../../tmux/compress_path.sh"
    )
  fi
  candidates+=(
    "${ZDOTDIR:-}/.compress_path.sh"
    "${ZDOTDIR:-}/compress_path.sh"
    "${HOME:-}/.config/zsh/.compress_path.sh"
    "${HOME:-}/.config/zsh/compress_path.sh"
    "${HOME:-}/.config/home-manager/common/modules/programs/tmux/compress_path.sh"
  )

  for cand in "${candidates[@]}"; do
    if [[ -n "$cand" && -f "$cand" ]]; then
      export COMPRESS_PATH_SH="$cand"
      return 0
    fi
  done
  return 1
}

function _tmux_compress_path() {
  emulate -L zsh
  if ! typeset -f compress_path >/dev/null 2>&1; then
    if [[ -z "${COMPRESS_PATH_SH:-}" || ! -f "${COMPRESS_PATH_SH:-}" ]]; then
      _tmux_title_find_compress_path
    fi
    if [[ -n "${COMPRESS_PATH_SH:-}" && -f "${COMPRESS_PATH_SH:-}" ]]; then
      source "${COMPRESS_PATH_SH:-}"
    fi
  fi
  if ! typeset -f compress_path >/dev/null 2>&1; then
    unset COMPRESS_PATH_SH
    _tmux_title_find_compress_path
    if [[ -n "${COMPRESS_PATH_SH:-}" && -f "${COMPRESS_PATH_SH:-}" ]]; then
      source "${COMPRESS_PATH_SH:-}"
    fi
  fi
  if ! typeset -f compress_path >/dev/null 2>&1; then
    echo "${1:-$PWD}"
    return 0
  fi
  compress_path "$@"
}

# Returns success when running inside Rex (and not inside a nested tmux).
function _term_title_in_rex() {
  [[ -z "${TMUX:-}" && ( -n "${REX_BLOCK:-}" || "${TERM_PROGRAM:-}" == "rex" ) ]]
}

# Emits a window/tab title: tmux window name (ESC k) inside tmux, otherwise
# the standard OSC 2 terminal title (used by Rex for the tab name).
function _term_title_emit() {
  emulate -L zsh
  if [[ -n "${TMUX:-}" ]]; then
    printf "\033k%s\033\\" "$1"
  elif _term_title_in_rex; then
    printf "\033]2;%s\007" "$1"
  fi
}

function _tmux_window_title_precmd() {
  emulate -L zsh
  [[ -z "${TMUX:-}" ]] && ! _term_title_in_rex && return
  local compressed="$(_tmux_compress_path "$PWD")"
  # In Rex, prefix the title with a marker while the last command failed.
  if _term_title_in_rex && [[ -n "${_REX_STATUS_LAST_EXIT:-}" ]] \
      && (( _REX_STATUS_LAST_EXIT != 0 && _REX_STATUS_LAST_EXIT != 130 )); then
    compressed="${REX_TITLE_ERROR_MARK:-❌}${_REX_STATUS_LAST_EXIT} $compressed"
  fi
  _term_title_emit "$compressed"
}

function _tmux_window_title_preexec() {
  emulate -L zsh
  [[ -z "${TMUX:-}" ]] && ! _term_title_in_rex && return
  local -a words
  words=(${(z)1:-})
  local cmd=""
  local fallback_cmd=""
  local skip_next=0

  for w in "${words[@]}"; do
    if [[ $skip_next -eq 1 ]]; then
      skip_next=0
      continue
    fi
    [[ "$w" == *=* ]] && continue
    if [[ "$w" == -* ]]; then
      case "$w" in
        -[ugCnprtTU]|--user|--group|--host|--unset|--split-string|--adjustment)
          skip_next=1
          ;;
      esac
      continue
    fi
    case "$w" in
      sudo|doas|env|nocorrect|noglob|command|builtin|exec|time|watch|xargs|nice|stdbuf|strace|valgrind|nohup|setsid|ionice|chroot|systemd-run|tsort|unbuffer)
        continue
        ;;
    esac
    [[ -z "$fallback_cmd" ]] && fallback_cmd="$w"
    if (( $+commands[$w] || $+functions[$w] || $+aliases[$w] || $+builtins[$w] )) || [[ "$w" == */* ]]; then
      cmd="$w"
      break
    fi
  done
  [[ -z "$cmd" ]] && cmd="$fallback_cmd"
  typeset -g _TERM_TITLE_LAST_CMD="${cmd:t}"
  [[ -n "$cmd" ]] && _term_title_emit "${cmd:t}"
}

# --- Rex program status (OSC 7501) -----------------------------------------
# Rex shows a spinner on unfocused tabs while a command is `working`, and a
# done/error marker afterwards. See
# https://www.superlogical.com/rex/docs/build/program-status
#
# REX_STATUS_MIN_SECONDS: commands shorter than this leave no done/error
#   marker (default 10).
# REX_STATUS_IGNORE: interactive programs that never report `working`.
# REX_TITLE_ERROR_MARK: tab title prefix after a failed command (default ❌),
#   followed by the exit code, e.g. "❌3 ~/.../src". Cleared by the next
#   command that succeeds; Ctrl-C (130) doesn't set it.

typeset -g REX_STATUS_MIN_SECONDS="${REX_STATUS_MIN_SECONDS:-10}"
typeset -ga REX_STATUS_IGNORE
(( ${#REX_STATUS_IGNORE} )) || REX_STATUS_IGNORE=(
  vi vim nvim nano emacs emacsclient hx less more most man bat top htop btop
  watch ssh mosh tmux rex screen fzf lazygit tig python python3 ipython node
  zsh bash fish jetski gemini claude
)
typeset -g _REX_STATUS_START=""
typeset -g _REX_STATUS_CMD=""
typeset -g _REX_STATUS_LAST_EXIT=""

# Emits one OSC 7501 report. Args: state [app] [msg].
function _rex_status_emit() {
  emulate -L zsh
  local state="$1" app="${2:-}" msg="${3:-}"
  local body="state=$state"
  app="${app//[^A-Za-z0-9_.+-]/}"
  [[ -n "$app" ]] && body+=":app=${app[1,32]}"
  if [[ -n "$msg" ]]; then
    msg="${msg//[[:cntrl:]]/ }"
    msg="${msg[1,120]}"
    body+=":msg=$(print -rn -- "$msg" | base64 | tr -d '\n')"
  fi
  printf '\033]7501;%s\033\\' "$body"
}

function _rex_status_preexec() {
  emulate -L zsh
  _term_title_in_rex || return
  zmodload zsh/datetime 2>/dev/null
  local -a words=(${(z)1})
  local cmd="${_TERM_TITLE_LAST_CMD:-${words[1]:t}}"
  _REX_STATUS_START="$EPOCHREALTIME"
  _REX_STATUS_CMD="$cmd"
  (( ${REX_STATUS_IGNORE[(Ie)$cmd]} )) && return
  _rex_status_emit working "$cmd" "$1"
}

function _rex_status_precmd() {
  local exit_code=$?
  emulate -L zsh
  _term_title_in_rex || return
  [[ -z "$_REX_STATUS_START" ]] && return
  zmodload zsh/datetime 2>/dev/null
  local cmd="$_REX_STATUS_CMD"
  local -i elapsed=$(( EPOCHREALTIME - _REX_STATUS_START ))
  _REX_STATUS_START=""
  _REX_STATUS_CMD=""
  _REX_STATUS_LAST_EXIT="$exit_code"

  if (( ${REX_STATUS_IGNORE[(Ie)$cmd]} )) || (( exit_code == 130 )); then
    _rex_status_emit clear
  elif (( elapsed < REX_STATUS_MIN_SECONDS )); then
    _rex_status_emit clear
  elif (( exit_code == 0 )); then
    _rex_status_emit done "$cmd" "$cmd finished in ${elapsed}s"
  else
    _rex_status_emit error "$cmd" "$cmd exited $exit_code after ${elapsed}s"
  fi
}

if [[ -n "${TMUX:-}" ]] || _term_title_in_rex; then
  _tmux_title_find_compress_path
  if [[ -n "${COMPRESS_PATH_SH:-}" && -f "${COMPRESS_PATH_SH:-}" ]]; then
    source "${COMPRESS_PATH_SH:-}"
  fi

  autoload -U add-zsh-hook
  add-zsh-hook precmd _tmux_window_title_precmd
  add-zsh-hook preexec _tmux_window_title_preexec

  if _term_title_in_rex; then
    # Status precmd goes first so it sees the command's exit code.
    precmd_functions=(_rex_status_precmd ${precmd_functions:#_rex_status_precmd})
    add-zsh-hook preexec _rex_status_preexec
  fi
fi
