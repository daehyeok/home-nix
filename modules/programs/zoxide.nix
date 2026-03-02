# Module for zoxide configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.zoxide;
in
{
  options.modules.programs.zoxide = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable zoxide configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = mkDefault true;
    };
  };
}
