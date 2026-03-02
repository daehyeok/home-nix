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
    ./delta.nix
    ./git.nix
    ./bat.nix
    ./neovim.nix
    ./lsd.nix
    ./fzf.nix
    ./tmux
    ./direnv.nix
  ];

  config.programs.home-manager.enable = true;
}
