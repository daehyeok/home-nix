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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zellij configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = mkDefault true;
    };
  };
}
