# Module for htop configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.htop;
in
{
  options.modules.programs.htop = {
    enable = mkEnableOption "htop configuration";
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
    };
  };
}
