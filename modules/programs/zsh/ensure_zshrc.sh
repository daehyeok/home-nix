#!/usr/bin/env bash
# Ensures ~/.zshrc exists as a writable file and sources ~/.config/zsh/.zshrc first.

set -euo pipefail

zshrc_file="${1:-$HOME/.zshrc}"

header_block='# =============================================================================
# Home Manager Zsh Configuration Loader
# Automatically managed by `home-manager switch`.
# Ensures ~/.config/zsh/.zshrc is sourced first while keeping ~/.zshrc writable
# for third-party CLI installers and local machine customizations.
# =============================================================================
if [[ -z "${_HM_ZSHRC_LOADING:-}" && -f "$HOME/.config/zsh/.zshrc" ]]; then
  _HM_ZSHRC_LOADING=1
  source "$HOME/.config/zsh/.zshrc"
  unset _HM_ZSHRC_LOADING
fi'

# If ~/.zshrc is a symlink (e.g. an old Nix store symlink), replace it with a regular file
if [[ -L "$zshrc_file" ]]; then
  rm -f "$zshrc_file"
fi

if [[ ! -f "$zshrc_file" ]]; then
  printf '%s\n' "$header_block" > "$zshrc_file"
  chmod 0640 "$zshrc_file"
elif ! grep -qF ".config/zsh/.zshrc" "$zshrc_file"; then
  tmp_file="$(mktemp "${zshrc_file}.tmp.XXXXXX")"
  {
    printf '%s\n' "$header_block"
    if [[ -s "$zshrc_file" ]]; then
      printf '\n'
      cat "$zshrc_file"
    fi
  } > "$tmp_file"
  chmod 0640 "$tmp_file"
  mv "$tmp_file" "$zshrc_file"
fi
