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
    ./antigravity
    ./atuin
    ./bat
    ./starship
    ./tmux
    ./zsh
    ./delta.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./lsd.nix
    ./neovim.nix
    ./npm.nix
    ./rex
  ];

  config.programs.home-manager.enable = true;
}
