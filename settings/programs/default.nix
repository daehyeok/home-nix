{ config, lib, pkgs, ... }:

{
  imports =
    [ ./git ./kitty ./tmux ./zsh ./p10k ./starship ./fzf.nix ./nvim.nix ];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fd
    jq
    bat
    delta
    exa
    htop
    ripgrep
    ruplacer
    shellcheck
    tldr
    nixfmt
    gh
    choose
    wget
  ];
}
