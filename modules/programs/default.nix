{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [ ./zsh-fast-syntax-highlighting.nix ];
}
