# Module for tealdeer configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.tealdeer;
in
{
  options.modules.programs.tealdeer = {
    enable = mkEnableOption "tealdeer configuration";
  };

  config = mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
    };
  };
}
