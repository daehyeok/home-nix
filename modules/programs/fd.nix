# Module for fd configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.fd;
in
{
  options.modules.programs.fd = {
    enable = mkEnableOption "fd configuration";
  };

  config = mkIf cfg.enable {
    programs.fd = {
      enable = true;
    };
  };
}
