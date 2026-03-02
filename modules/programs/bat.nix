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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bat configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = mkDefault true;
    };

    home.shellAliases.cat = "${pkgs.writeShellScript "cat-wrapper" (builtins.readFile ./cat_wrapper.sh)}";
  };
}
