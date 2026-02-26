# Module for zellij configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zellij;
in
{
  options.modules.programs.zellij = {
    enable = mkEnableOption "zellij configuration";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };
  };
}
