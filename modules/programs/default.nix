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
    ./zsh-fast-syntax-highlighting.nix
    ./zsh-autosuggestion.nix
    ./zsh-autopair.nix
    ./zsh-completions.nix
    ./zsh-vterm
  ];
}
