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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bottom configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.bottom = {
      enable = mkDefault true;
    };
  };
}
