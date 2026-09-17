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

function _tmux_window_title_precmd() {
  emulate -L zsh
  [[ -z "${TMUX:-}" ]] && return
  local compressed="$(_tmux_compress_path "$PWD")"
  printf "\033k%s\033\\" "$compressed"
}

function _tmux_window_title_preexec() {
  emulate -L zsh
  [[ -z "${TMUX:-}" ]] && return
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
  [[ -n "$cmd" ]] && printf "\033k%s\033\\" "${cmd:t}"
}

if [[ -n "${TMUX:-}" ]]; then
  _tmux_title_find_compress_path
  if [[ -n "${COMPRESS_PATH_SH:-}" && -f "${COMPRESS_PATH_SH:-}" ]]; then
    source "${COMPRESS_PATH_SH:-}"
  fi

  autoload -U add-zsh-hook
  add-zsh-hook precmd _tmux_window_title_precmd
  add-zsh-hook preexec _tmux_window_title_preexec
fi
