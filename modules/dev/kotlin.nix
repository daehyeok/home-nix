{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.dev.kotlin;
in
{
  options.modules.dev.kotlin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable kotlin development environment";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ ];
  };
}
