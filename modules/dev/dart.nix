{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.dev.dart;
in
{
  options.modules.dev.dart = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dart development environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.dart ];
  };
}
