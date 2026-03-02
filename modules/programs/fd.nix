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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fd configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.fd = {
      enable = mkDefault true;
    };
  };
}
