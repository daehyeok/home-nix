# Module for bat configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.bat;
in
{
  options.modules.programs.bat = {
    enable = mkEnableOption "bat configuration";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
    };
    home.shellAliases.cat = "bat --plain";
  };
}
