# Module for direnv configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.direnv;
in
{
  options.modules.programs.direnv = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable direnv configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = mkDefault true;
      nix-direnv.enable = true;
    };
  };
}
