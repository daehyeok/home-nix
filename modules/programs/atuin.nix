# Module for atuin configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.atuin;
in
{
  options.modules.programs.atuin = {
    enable = mkEnableOption "atuin configuration";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
    };
  };
}
