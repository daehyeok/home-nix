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
  ];

  config.programs.home-manager.enable = true;
}
