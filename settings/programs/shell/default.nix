{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./zsh
    ./starship
  ];
}
