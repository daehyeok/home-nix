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
  ];

  config.programs.home-manager.enable = true;
}
