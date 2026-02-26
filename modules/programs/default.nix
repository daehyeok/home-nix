# Module for default configuration
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./starship
    ./zsh
    ./atuin.nix
    ./delta.nix
    ./git.nix
    ./jq.nix
    ./bat.nix
    ./zoxide.nix
    ./neovim.nix
    ./eza.nix
    ./fzf.nix
    ./tmux.nix
    ./zellij.nix
    ./tealdeer.nix
    ./ripgrep.nix
    ./fd.nix
    ./htop.nix
    ./bottom.nix
    ./direnv.nix
  ];

  config.programs.home-manager.enable = true;
}
