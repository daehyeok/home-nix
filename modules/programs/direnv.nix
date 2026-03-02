# Module for direnv configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  config = mkIf config.programs.direnv.enable {
    programs.direnv = {
      nix-direnv.enable = mkDefault true;
    };
  };
}
