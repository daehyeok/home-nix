# Module for bottom configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.bottom;
in
{
  options.modules.programs.bottom = {
    enable = mkEnableOption "bottom configuration";
  };

  config = mkIf cfg.enable {
    programs.bottom = {
      enable = true;
    };
  };
}
